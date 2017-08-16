//
//  MJGesSettingViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/14.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJGesSettingViewController.h"
#import "LZGestureViewController.h"
#import "MJGesIntroduceViewController.h"
#import "LZPasswordViewController.h"
@interface MJSwitch:UISwitch
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
@implementation MJSwitch
@end


@interface MJGesSettingViewController ()<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>{
    UITableView * _tableView;
    BOOL _isShowOther; ///根据是否开启手势，来做判断，是否展示其它
    MJSwitch * _stateSwitch;
}

@end

@implementation MJGesSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupMainView];
}

-(void)setupNavBar{
    MJWeakSelf(ws);
    [self MJSetNavigationTitle:@"手势设置"];
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui"  actionBlock:^(UIButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)setupMainView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(MJNavigationHeight);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    _isShowOther = [LZGestureTool isGestureEnable];
    if (_isShowOther) {
        return 4;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1 && ![[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
        return 0;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"GesSettingCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    switch (indexPath.section) {
        case 0:{
            MJSwitch * sw = [[MJSwitch alloc]init];
            [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
            _stateSwitch = sw;
            cell.accessoryView  =sw;
            sw.indexPath = indexPath;
            cell.textLabel.text = @"开启密码锁定";
            sw.on = [LZGestureTool isGestureEnableByUser];
        }
            break;
        case 1:{
            MJSwitch * sw = [[MJSwitch alloc]init];
            [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
            sw.indexPath = indexPath;
            cell.textLabel.text = @"使用指纹重置手势密码";
            sw.on = [LZGestureTool isGestureResetEnableByTouchID];
        }
            break;
        case 2:{
            cell.textLabel.text = @"修改手势密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case 3:{
            cell.textLabel.text = @"忘记手势密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case 4:{
            cell.textLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }
    return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (![[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem] && section==1) {
        return 1;
    }
    return UITableViewAutomaticDimension;
}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1 &&[[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
        return  @"开启后，当您忘记手势密码时，可使用指纹密码来重置手势密码";
    }else if (section==3){
        if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem]) {
            return @"如果您使用了数字密码或指纹密码,可使用其中之一来重置手势密码";
        }
        return @"如果您使用了数字密码,可使用数字密码重置手势密码";
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf(ws);
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.5];
    if (indexPath.section == 2) {
        LZGestureViewController * ges = [[LZGestureViewController alloc]init];
        [ges showInViewController:self type:LZGestureTypeUpdate];
    }else if (indexPath.section ==3){
        UIAlertController * alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([[MJTouchId sharedInstance]isTouchIdEnabledOrNotBySystem] && [LZGestureTool isGestureResetEnableByTouchID]) {
            
            UIAlertAction * touchID =[UIAlertAction actionWithTitle:@"使用指纹密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[MJTouchId sharedInstance]startVerifyTouchID:^{
                    MJGesIntroduceViewController * intro =[[MJGesIntroduceViewController alloc]init];
                    [ws.navigationController pushViewController:intro animated:YES];
                }];
            }];
            [alert addAction:touchID];
        }
        if ([LZNumberTool isNumberPasswordEnable]) {
            UIAlertAction * num = [UIAlertAction actionWithTitle:@"使用数字密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LZPasswordViewController * psv =[[LZPasswordViewController alloc]init];
                [psv showInViewController:self style:LZPasswordStyleVerity];
                [psv veritySuccess:^{
                    MJGesIntroduceViewController * info =[[MJGesIntroduceViewController alloc]init];
                    [ws.navigationController pushViewController:info animated:YES];
                }];
            }];
            [alert addAction:num];
        }
        
        if (![LZGestureTool isGestureResetEnableByTouchID]&&![LZNumberTool isNumberPasswordEnable]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您没有设置数字密码,无法通过数字密码重置!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)sw:(MJSwitch*)sw{
    if (sw.indexPath.section == 0) {
        BOOL isON = sw.isOn;
        if ([LZGestureTool isGestureEnableByUser]) {
            sw.on = YES;
            LZGestureViewController * ges = [[LZGestureViewController alloc]init];
            ges.delegate = self;
            [ges showInViewController:self type:LZGestureTypeVerifying];
        }else{
            ///yes
            [LZGestureTool saveGestureEnableByUser:isON];
            _isShowOther = YES;
            [_tableView reloadData];
        }
    }else if (sw.indexPath.section ==1){
        if ([LZGestureTool isGestureResetEnableByTouchID]) {
            sw.on = YES;
        }else{
            sw.on = NO;
        }
        [[MJTouchId sharedInstance]startVerifyTouchID:^{
            sw.on = !sw.on;
            [LZGestureTool saveGestureResetEnableByTouchID:sw.on];
        }];
    }
}
-(void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc{
    [LZGestureTool saveGestureEnableByUser:NO];
    _isShowOther = NO;
    [_tableView reloadData];
    _stateSwitch.on = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
