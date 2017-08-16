//
//  MJGesSetupViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJGesSetupViewController.h"
#import "MJGesIntroduceViewController.h"
#import "MJGesSettingViewController.h"

static NSString * identifier = @"MJGesSetupViewControllerID";

@interface MJGesSetupViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;
}
@end

@implementation MJGesSetupViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self setupMainView];
}

- (void)setupNaviBar {
    MJWeakSelf(ws)
    [self MJSetNavigationTitle:@"加锁状态"];
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)setupMainView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(MJNavigationHeight);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (![cell.contentView viewWithTag:166]) {
        UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(MJSCREENW-90, 0, 60, cell.bounds.size.height)];
        lb.textColor = [UIColor blueColor];
        lb.textAlignment = NSTextAlignmentRight;
        lb.tag = 166;
        lb.hidden = YES;
        [cell.contentView addSubview: lb];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = @"手势锁定";
    UILabel * lb = (UILabel*)[cell.contentView viewWithTag:166];
    if ([LZGestureTool isGestureEnable]) {
        lb.text = @"开启";
        lb.textColor = MJColorMain;
        lb.hidden = NO;
    }else if (![LZGestureTool isGesturePswSavedByUser]){
        lb.text = @"未设置";//还没有设置手势密码
        lb.textColor = [UIColor darkGrayColor];
        lb.hidden = NO;
    }else if (![LZGestureTool isGestureEnableByUser]){
        lb.text = @"关闭";//关闭了手势
        lb.textColor = [UIColor darkGrayColor];
        lb.hidden = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isHasGestureSaveInUserDefaults = [LZGestureTool isGesturePswSavedByUser];
    if (isHasGestureSaveInUserDefaults) {
        MJGesSettingViewController * giVC = [[MJGesSettingViewController alloc]init];
        [self.navigationController pushViewController:giVC animated:YES];
    }else{
        MJGesIntroduceViewController * giVC = [[MJGesIntroduceViewController alloc]init];
        [self.navigationController pushViewController:giVC animated:YES];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return @"手势密码作为密码保护的主要验证方式,设置后请妥善保管!";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
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
