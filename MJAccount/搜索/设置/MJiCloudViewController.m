//
//  MJiCloudViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJiCloudViewController.h"
#import "MJiCloud.h"
#import "LZGestureViewController.h"

@interface MJiCloudViewController ()<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>

@property (strong, nonatomic)UITableView *myTableView;

@end

@implementation MJiCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self myTableView];
}
-(void)setNavBar{
    MJWeakSelf(ws)
    [self MJSetNavigationTitle:@"iCloud 设置"];
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iCloudCellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iCloudCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = MJColorFromRGB(21, 126, 251);
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"同步到iCloud";
    }else{
        cell.textLabel.text = @"从iCloud同步";
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSArray * titles =@[@"注意: 同步到iCloud操作, 会覆盖已在iCloud的备份!",@"注意: 从iCloud同步到本地操作, 会覆盖本地已有的数据!"];
    return titles[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![MJiCloud iCloudEnable]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"iCloud不可用,请到\"设置--iCloud\"进行启用" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    //同步之前 touchid验证
    if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
        [[MJTouchId sharedInstance]startVerifyTouchID:^{
            if (indexPath.section ==0) {
                [SVProgressHUD show];
                NSString * path = [MJSqliteTool MJCreateSqliteWithName:MJSqliteName];
                [MJiCloud uploadToiCloud:path resultBlock:^(NSError *error) {
                    if (error == nil) {
                        [SVProgressHUD showInfoWithStatus:@"同步成功"];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"同步出错"];
                    }
                }];
            }else{
                [SVProgressHUD show];
                [MJiCloud downloadFromiCloudWithBlock:^(id obj) {
                    if (obj !=nil) {
                        NSData * data = (NSData*)obj;
                        [data writeToFile:[MJSqliteTool MJCreateSqliteWithName:MJSqliteName] atomically:YES];
                        [SVProgressHUD showInfoWithStatus:@"同步成功"];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"同步出错"];
                    }
                }];
            }
        }];
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
            make.left.right.and.bottom.mas_equalTo(self.view);
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
