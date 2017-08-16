//
//  ViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/4.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    /// 正式
    self.bannerView.adUnitID = @"ca-app-pub-8977527621627800/7495726503";
    /// 测试
//    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
