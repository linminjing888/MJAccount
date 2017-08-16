//
//  MJGroupManagerController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJGroupManagerController.h"

@interface MJGroupManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJGroupManagerController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self tableView];
}

-(void)setupNaviBar{
    
    [self MJSetNavigationTitle:@"分组管理"];
    
    MJWeakSelf(ws)
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        if (ws.navigationController) {
            [ws.navigationController popViewControllerAnimated:YES];
        }else{
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self MJSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        [ws addNewGroup];
    }];
}
-(void)loadData{
    NSArray * arr = [MJSqliteTool MJSelectAllGroupsFromTable:MJSqliteGroupTableName];
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:arr];
    [self.tableView reloadData];
}
#pragma mark -- 添加账号
-(void)addNewGroup{
    
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"新建分组" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    MJWeakSelf(ws)
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * arr = alert.textFields;
        UITextField * field = arr[0];
        MJGroupModel * group = [[MJGroupModel alloc]init];
        group.groupName = field.text;
        [MJSqliteTool MJInsertToGroupTable:MJSqliteGroupTableName model:group];
        [ws.dataArray addObject:group];
        [ws.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入组名";
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = @"singleGroupCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = MJColorGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [cell addGestureRecognizer:longPress];
    }
    
    MJGroupModel * model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    return cell;
}
-(void)longPressAction:(UILongPressGestureRecognizer*)ges{
    UITableViewCell * cell = (UITableViewCell*)ges.view;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改名称" message:@"您可以输入新的分组名称" preferredStyle:UIAlertControllerStyleAlert];
    MJWeakSelf(ws)
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = cell.textLabel.text;
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * field = [[alert textFields]firstObject];
        MJGroupModel * group = [ws.dataArray objectAtIndex:indexPath.row];
        group.groupName = field.text;
        [MJSqliteTool MJUpdateGroupTable:MJSqliteGroupTableName model:group];
        cell.textLabel.text = field.text;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSArray * arr  =[MJSqliteTool MJSelectGroupElementsFromTable:MJSqliteDataTableName groupID:group.identifier];
            if (arr.count > 0) {
                for (MJDataModel * model in arr) {
                    model.groupName = field.text;
                    [MJSqliteTool MJUpdateTable:MJSqliteDataTableName model:model];
                }
            }
        });
    }];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除分组及分组下的信息,无法恢复,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
    MJWeakSelf(ws)
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MJGroupModel * group = [ws.dataArray objectAtIndex:indexPath.row];
        
        [MJSqliteTool MJDeleteFromGroupTable:MJSqliteGroupTableName element:group];
        
        [ws.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSArray * arr  =[MJSqliteTool MJSelectGroupElementsFromTable:MJSqliteDataTableName groupID:group.identifier];
            if (arr.count > 0) {
                for (MJDataModel * model in arr) {
                    [MJSqliteTool MJDeleteFromTable:MJSqliteDataTableName element:model];
                }
            }
        });
    }];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
-(UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        MJWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(MJNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view).offset(MJTabBarHeight);
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
