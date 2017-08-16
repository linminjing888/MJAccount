//
//  MJSettingViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJSettingViewController.h"
#import "MJTouchId.h"
#import "MJiCloudViewController.h"
#import "MJAboutViewController.h"
#import "MJTouchIDViewController.h"
#import "MJGesSetupViewController.h"
#import "MJNumberViewController.h"

@interface MJSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;

@end

@implementation MJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self MJSetNavigationTitle:@"设置"];
    [self myTableView];
}
-(NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"手势密码",@"数字密码",@"指纹解锁"],@[@"iCloud同步"],@[@"关于我们"], nil];
        }else{
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"手势密码",@"数字密码"],@[@"iCloud同步"],@[@"关于我们"], nil];
        }
    }
    return _dataArray;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCellID"];
        cell.textLabel.textColor = MJColorFromHex(0x555555);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *arr = self.dataArray[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.dataArray[section];
    return arr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * titles =@[@"安全设置",@"iCloud设置",@"关于"];
    return titles[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==2) {
        MJAboutViewController * about =[[MJAboutViewController alloc]init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }else if (indexPath.section ==1) {
        MJiCloudViewController * icloud =[[MJiCloudViewController alloc]init];
        icloud.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:icloud animated:YES];
    }else{ 
        switch (indexPath.row) {
            case 0:{
                MJGesSetupViewController * ges =[[MJGesSetupViewController alloc]init];
                ges.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ges animated:YES];
            }
                break;
            case 1:{
                MJNumberViewController * num =[[MJNumberViewController alloc]init];
                num.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:num animated:YES];
            }
                break;
            case 2:{
                MJTouchIDViewController * touchid =[[MJTouchIDViewController alloc]init];
                touchid.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:touchid animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        _myTableView = table;
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(MJNavigationHeight);
            make.left.right.and.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-MJTabBarHeight);
        }];
    }
    
    return _myTableView;
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
