//
//  MJTabbarController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJTabbarController.h"

@interface MJTabbarController ()

@end

@implementation MJTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildViewController];
   
}
- (void)setUpAllChildViewController{
//    XGFirstViewController * zeroVC = [[XGFirstViewController alloc]init];
//    [self setUpOneChildViewController:zeroVC image:@"01" title:@"首页"];
//    
//    // 1.添加第一个控制器
//    XGStoreController *oneVC = [[XGStoreController alloc]init];
//    [self setUpOneChildViewController:oneVC image:@"06" title:@"门店"];
//    
//    // 2.添加第2个控制器
//    XGForetasteController *twoVC = [[XGForetasteController alloc]init];
//    [self setUpOneChildViewController:twoVC image:@"07" title:@"试吃推荐"];
}
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageStr title:(NSString *)title{
    
//    MJBaseNaviController *navC = [[MJBaseNaviController alloc]initWithRootViewController:viewController];
//    
//    navC.tabBarItem.title = title;
//    navC.tabBarItem.image = [UIImage imageNamed:imageStr];
//    navC.tabBarItem.selectedImage =[UIImage imageWithOriginalName:[imageStr addString:@"-1"]];
//    
//    //    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
//    
//    [self addChildViewController:navC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
