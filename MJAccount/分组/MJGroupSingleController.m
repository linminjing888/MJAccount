//
//  MJGroupSingleController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/8.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJGroupSingleController.h"
#import "MJDetailViewController.h"
#import "MJEditViewController.h"

@interface MJGroupSingleController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJGroupSingleController
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
    
    [self MJSetNavigationTitle:self.groupModel.groupName];
    
    MJWeakSelf(ws)
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        if (ws.navigationController) {
            [ws.navigationController popViewControllerAnimated:YES];
        }else{
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self MJSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        
        MJEditViewController * edit =[[MJEditViewController alloc]init];
        edit.defaultGroup = self.groupModel;
        [self.navigationController pushViewController:edit animated:YES];

    }];
}
-(void)loadData{
   NSArray * arr = [MJSqliteTool MJSelectGroupElementsFromTable:MJSqliteDataTableName groupID:self.groupModel.identifier];
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:arr];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = @"singleGroupCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.textColor = MJColorGray;
        cell.textLabel.font = MJFontDefaulte;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MJDataModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.account;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJDetailViewController * detail =[[MJDetailViewController alloc]init];
    detail.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据删除后,不可恢复,是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
    MJWeakSelf(ws)
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [MJSqliteTool MJDeleteFromTable:MJSqliteDataTableName element:self.dataArray[indexPath.row]];
        [ws.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
