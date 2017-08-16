//
//  MJDetailViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJDetailViewController.h"
#import "MJDetailTableViewCell.h"
#import "MJPasswordCell.h"
#import "MJRemarkTabCell.h"
#import "MJEditViewController.h"
#import "LZGestureViewController.h"

@interface MJDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJDetailViewController
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
    
    [self MJSetNavigationTitle:@"详情"];
    
    MJWeakSelf(ws)
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self MJSetRightButtonWithTitle:nil selectedImage:nil normalImage:@"edit" actionBlock:^(UIButton *button) {
        [ws adjustGesture];
    }];
}
-(void)adjustGesture{
    
    MJWeakSelf(ws);
    // 进入编辑页的时候需要验证身份
    if ([LZGestureTool isGestureEnable]) {
        LZGestureViewController * ges =[[LZGestureViewController alloc]init];
        ges.delegate = ws;
        [ges showInViewController:ws type:LZGestureTypeVerifying];
        
        if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
            [[MJTouchId sharedInstance]startVerifyTouchID:^{
                [ws pushToEditWithAnimate:NO];
                [ges dismiss];
            }];
        }
    }else{
        static BOOL isShowWarn = YES;
        if (isShowWarn) {
            isShowWarn = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有设置手势密码,您可以在设置中启用手势密码,这样在进行编辑时需要验证,可以更好的保护您的信息安全!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [ws pushToEditWithAnimate:YES];
            }];
            [alert addAction:ok];
            [ws presentViewController:alert animated:YES completion:nil];
        }else{
            [ws pushToEditWithAnimate:YES];
        }
    }
}

-(void)pushToEditWithAnimate:(BOOL)animate{
    MJEditViewController * edit =[[MJEditViewController alloc]init];
    edit.model  =self.model;
    edit.flog = @"edit";
    [self.navigationController pushViewController:edit animated:animate];
}
-(void)loadData{

    MJDataModel * model = [MJSqliteTool MJSelectElementFromTable:MJSqliteDataTableName identifier:self.model.identifier];
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObject:model.groupName];
    [self.dataArray addObject:model.title];
    [self.dataArray addObject:model.account];
    [self.dataArray addObject:model.password];
    [self.dataArray addObject:model.phoneNumber];
    [self.dataArray addObject:model.email];
    [self.dataArray addObject:model.dsc];
    [self.tableView reloadData];
    
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
        passwordCell.editEnabled = NO;
        MJWeakSelf(ws)
        passwordCell.showBlock = ^(BOOL show){
            if ([LZGestureTool isGestureEnable]) {
                if (passwordCell.showPSW == NO) {
                    LZGestureViewController * ges =[[LZGestureViewController alloc]init];
                    ges.delegate = self;
                    ges.view.tag = 100;
                    [ges showInViewController:ws type:LZGestureTypeVerifying];
                    if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
                        [[MJTouchId sharedInstance]startVerifyTouchID:^{
                            [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
                            [ges dismiss];
                        }];
                    }
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:NO]];
                }
            }else{
                static BOOL isShowWarn = YES;
                if (isShowWarn) {
                    isShowWarn = NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有设置手势密码,您可以在设置中启用手势密码,这样在进行编辑时需要验证,可以更好的保护您的信息安全!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        /// 使用通知的方式发送结果,接受者在LZPasswordCell里
                        [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
                        
                    }];
                    [alert addAction:ok];
                    [ws presentViewController:alert animated:YES completion:nil];
                }else{
                     [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:!show]];
                }
            }
        };
        return passwordCell;
    }else if(indexPath.row == 6){
        MJRemarkTabCell * remarkCell = [MJRemarkTabCell cellWithTableView:tableView];
        remarkCell.title = self.titleArray[indexPath.row];
        remarkCell.detailTitle = self.dataArray[indexPath.row];
        remarkCell.editEnabled = NO;
        return remarkCell;
    }else{
        MJDetailTableViewCell * detailCell = [MJDetailTableViewCell cellWithTableView:tableView];
        detailCell.title = self.titleArray[indexPath.row];
        detailCell.detailTitle = self.dataArray[indexPath.row];
        detailCell.editEnabled = NO;
        return detailCell;
    }
}
-(void)showWarn{
    
}
#pragma mark ges 协议
- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    //显示明文密码
    if (vc.view.tag == 100) {
        [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
    }else{
        [self pushToEditWithAnimate:NO];
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
