//
//  MJEditViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJEditViewController.h"
#import "MJDetailTableViewCell.h"
#import "MJPasswordCell.h"
#import "MJRemarkTabCell.h"

@interface MJEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    if ([self.flog isEqualToString:@"edit"]) {
        [self loadData];
    }else{
        for (NSInteger i=0; i<self.titleArray.count; i++) {
            if (i==0&&self.defaultGroup) {
                [self.dataArray addObject:self.defaultGroup.groupName];
            }else{
                [self.dataArray addObject:@""];
            }
        }
    }
    [self tableView];
}

-(void)setupNaviBar{
    
    [self MJSetNavigationTitle:@"编辑"];
    
    MJWeakSelf(ws)
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self MJSetRightButtonWithTitle:nil selectedImage:nil normalImage:@"save" actionBlock:^(UIButton *button) {
        [self saveBtnClick];
    }];
}

-(void)loadData{
    
    [self.dataArray addObject:self.model.groupName];
    [self.dataArray addObject:self.model.title];
    [self.dataArray addObject:self.model.account];
    [self.dataArray addObject:self.model.password];
    [self.dataArray addObject:self.model.phoneNumber];
    [self.dataArray addObject:self.model.email];
    [self.dataArray addObject:self.model.dsc];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 120.0;
    }else{
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        MJPasswordCell * passwordCell = [MJPasswordCell cellWithTableView:tableView];
        passwordCell.title = self.titleArray[indexPath.row];
        passwordCell.detailTitle = self.dataArray[indexPath.row];
        passwordCell.editEnabled = YES;
        passwordCell.showBlock = ^(BOOL show){
              [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:!show]];
        };
        return passwordCell;
    }else if(indexPath.row == 6){
        MJRemarkTabCell * remarkCell = [MJRemarkTabCell cellWithTableView:tableView];
        remarkCell.title = self.titleArray[indexPath.row];
        remarkCell.detailTitle = self.dataArray[indexPath.row];
        remarkCell.editEnabled = YES;
        return remarkCell;
    }else{
        MJDetailTableViewCell * detailCell = [MJDetailTableViewCell cellWithTableView:tableView];
        detailCell.title = self.titleArray[indexPath.row];
        detailCell.detailTitle = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            detailCell.editEnabled = NO;
        }else{
            detailCell.editEnabled = YES;
        }
        return detailCell;
    }
}

/**
 保存数据
 */
-(void)saveBtnClick{
    MJDataModel * model = nil;
    if (self.model !=nil) {
        model = self.model;
    }else{
        model = [[MJDataModel alloc]init];
    }
    MJDetailTableViewCell * cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    model.groupName = cell0.detailField.text;
    
    MJDetailTableViewCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    model.title = cell1.detailField.text;
    
    if (model.title.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空!"];
        return;
    }
    
    MJDetailTableViewCell * cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    model.account = cell2.detailField.text;
    
    MJPasswordCell * cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    model.password = cell3.detailField.text;
    
    MJDetailTableViewCell * cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    model.phoneNumber = cell4.detailField.text;
    
    MJDetailTableViewCell * cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    model.email = cell5.detailField.text;
    
    MJRemarkTabCell * cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    model.dsc = cell6.textView.text;
    
    if (model.groupID == nil || model.groupID.length <= 0) {
        model.groupID = self.defaultGroup.identifier;
    }
    
    MJLog(@"%@%@%@%@%@%@%@",model.groupName,model.title,model.account,model.password,model.phoneNumber,model.email,model.dsc);
    NSString * message = nil;
    if ([self.flog isEqualToString:@"edit"]) {
        message = @"恭喜，修改成功，是否保存?";
    }else{
        message = @"恭喜，添加成功，是否保存?";
    }
    MJWeakSelf(ws)
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([ws.flog isEqualToString:@"edit"]) {
            [MJSqliteTool MJUpdateTable:MJSqliteDataTableName model:model];
        }else{
            [MJSqliteTool MJInsertToDataTable:MJSqliteDataTableName model:model];
        }
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(NSArray*)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"分   类:",@"标   题:",@"账   号:",@"密   码:",@"手机号:",@"邮   箱:",@"备   注:", nil];
    }
    return _titleArray;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
-(UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        MJWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(MJNavigationHeight);
            make.left.right.and.bottom.mas_equalTo(ws.view);
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
