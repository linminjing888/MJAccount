//
//  AppDelegate.m
//  MJAccount
//
//  Created by YXCZ on 17/8/4.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "AppDelegate.h"
#import "MJTabbarController.h"
#import "MJSqliteTool.h"
#import "MJGroupModel.h"
#import "MJDataModel.h"
#import "LZGestureScreen.h"
@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ///正式
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-8977527621627800~3504510605"];
    ///测试
//    [GADMobileAds configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MJTabbarController alloc]init];
    [self.window makeKeyAndVisible];
    
    [self verifyPassword];
    [self createSqlite];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
    return YES;
}
- (void)createSqlite {

    [MJSqliteTool MJCreateSqliteWithName:MJSqliteName];
    [MJSqliteTool MJDefaultDataBase];
    [MJSqliteTool MJCreateDataTableWithName:MJSqliteDataTableName];
    [MJSqliteTool MJCreateGroupTableWithName:MJSqliteGroupTableName];
    [MJSqliteTool MJCreatePswTableWithName:MJSqliteDataPasswordKey];
    
    NSInteger groups = [MJSqliteTool MJSelectElementCountFromTable:MJSqliteGroupTableName];
    NSInteger count = [MJSqliteTool MJSelectElementCountFromTable:MJSqliteDataTableName];
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    BOOL isDataInit = [us objectForKey:@"dataAlreadyInit"];
    if (count <= 0 && groups <= 0 && !isDataInit) {
        [self createData];
    }
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    BOOL isPswAlreadySaved = [[df objectForKey:@"pswAlreadySavedKey"]boolValue];
    if (!isPswAlreadySaved) {
        NSString * psw = [df objectForKey:@"redomSaveKey"];
        if (psw.length > 0) {
            [MJSqliteTool MJInsertToPswTable:MJSqliteDataPasswordKey passwordKey:MJSqliteDataPasswordKey passwordValue:psw];
        }
        [df setBool:YES forKey:@"pswAlreadySavedKey"];
    }
}

-(void)createData{
    MJGroupModel * group = [[MJGroupModel alloc]init];
    group.groupName = @"社交";
    [MJSqliteTool MJInsertToGroupTable:MJSqliteGroupTableName model:group];
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setBool:YES forKey:@"dataAlreadyInit"];
    [us synchronize];
    
    MJGroupModel * group1 =[[MJGroupModel alloc]init];
    group1.groupName = @"博客";
    [MJSqliteTool MJInsertToGroupTable:MJSqliteGroupTableName model:group1];
    
    MJGroupModel * group2 =[[MJGroupModel alloc]init];
    group2.groupName = @"网站";
    [MJSqliteTool MJInsertToGroupTable:MJSqliteGroupTableName model:group2];
    
    MJGroupModel * group3 =[[MJGroupModel alloc]init];
    group3.groupName = @"APP";
    [MJSqliteTool MJInsertToGroupTable:MJSqliteGroupTableName model:group3];
    
//    identifier,groupName,title,account,password,phoneNumber,email,dsc,groupID
    MJDataModel * model = [[MJDataModel alloc]init];
    model.groupName = @"社交";
    model.account = @"543716817@qq.com";
    model.title = @"简书";
    model.password = @"666666";
    model.phoneNumber =@"543716817";
    model.email = @"543716817@qq.com";
    model.dsc = @"简书";
    model.groupID = group1.identifier;
    [MJSqliteTool MJInsertToDataTable:MJSqliteDataTableName model:model];
    
    MJDataModel * model1 = [[MJDataModel alloc]init];
    model1.groupName = @"默认分组";
    model1.account = @"minjing_lin@sina.cn";
    model1.title = @"微博";
    model1.password = @"66666";
    model1.phoneNumber =@"543716817";
    model1.email = @"543716817@qq.com";
    model1.groupID = group.identifier;
    [MJSqliteTool MJInsertToDataTable:MJSqliteDataTableName model:model1];
}

- (void)verifyPassword{
    if ([LZGestureTool isGestureEnable]) {
        [[LZGestureScreen shared]show];
        if ([[MJTouchId sharedInstance]canVerifyTouchID]) {
            [[MJTouchId sharedInstance]startVerifyTouchID:^{
                [[LZGestureScreen shared]dismiss];
            }];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //每次进入前台都要弹出
    [self verifyPassword];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
