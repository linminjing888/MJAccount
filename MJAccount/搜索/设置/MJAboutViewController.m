//
//  MJAboutViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJAboutViewController.h"

@interface MJAboutViewController ()

@end

@implementation MJAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self setupUI];
}

-(void)setNavBar{
    MJWeakSelf(ws)
    [self MJSetNavigationTitle:@"关于我们"];
    [self MJSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)setupUI{
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iconImage];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = MJColorFromHex(0x555555);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = [self getAPPVerson];
    [self.view addSubview:label];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"Copyright © 2017年 \nJingJing_Lin. All rights reserved.";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = MJColorFromHex(0x555555);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    [self.view addSubview:lab];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(3*MJNavigationHeight);
        make.centerX.mas_equalTo(self.view);
        make.height.and.with.mas_equalTo(@100);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImage.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(@40);
    }];

}

- (NSString *)getAPPVerson {
    
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    
    NSString *app_verson = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"敬敬账号助手 v%@",app_verson];
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
