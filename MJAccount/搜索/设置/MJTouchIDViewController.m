//
//  MJTouchIDViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJTouchIDViewController.h"

@interface MJTouchIDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
}
@end

@implementation MJTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNavBar];
}
-(void)setupNavBar{
    [self MJSetNavigationTitle:@"设置 TouchID"];
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"touchIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    UISwitch * sw = [[UISwitch alloc]init];
    [sw addTarget:self action:@selector(swAction:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    sw.on = [[MJTouchId sharedInstance]isTouchIdEnabledOrNotByUser];
    
    cell.textLabel.text = @"开启TouchID";
    return cell;
}
-(void)swAction:(UISwitch*)sw{
    //改变后的值
    if (sw.on == NO) {
        sw.on = YES; //等指纹验证之后，才可以关闭
        if ([[MJTouchId sharedInstance]canVerifyTouchID]) {
            [[MJTouchId sharedInstance]startVerifyTouchID:^{
                [[MJTouchId sharedInstance]save_TouchIdEnabledOrNotByUser_InUserDefaults:NO];
                sw.on = NO;
            }];
        }
    }else{
        [[MJTouchId sharedInstance]save_TouchIdEnabledOrNotByUser_InUserDefaults:YES];
    }
}
-(void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(MJNavigationHeight);
    }];
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
