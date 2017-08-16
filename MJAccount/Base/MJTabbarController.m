//
//  MJTabbarController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJTabbarController.h"
#import "MJNavigationController.h"
#import "MJMainViewController.h"
#import "MJSearchViewController.h"
#import "MJSettingViewController.h"

@interface MJTabbarController ()

@end

@implementation MJTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildViewController];
   
}
- (void)setUpAllChildViewController{
    MJMainViewController * zeroVC = [[MJMainViewController alloc]init];
    [self setUpOneChildViewController:zeroVC image:@"main_selected" title:@"分组"];
    
    // 1.添加第一个控制器
    MJSearchViewController *oneVC = [[MJSearchViewController alloc]init];
    [self setUpOneChildViewController:oneVC image:@"search_selected" title:@"搜索"];
    
    // 2.添加第2个控制器
    MJSettingViewController *twoVC = [[MJSettingViewController alloc]init];
    [self setUpOneChildViewController:twoVC image:@"setting_selected" title:@"设置"];
}
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageStr title:(NSString *)title{
    
    MJNavigationController *navC = [[MJNavigationController alloc]initWithRootViewController:viewController];
    
    navC.tabBarItem.title = title;
    navC.tabBarItem.image = [UIImage imageNamed:imageStr];
    UIImage * image1 = [UIImage imageNamed:[imageStr stringByAppendingString:@"_1"]];
    navC.tabBarItem.selectedImage = image1;//[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:navC];
    
    self.tabBar.tintColor = MJColorMain;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
