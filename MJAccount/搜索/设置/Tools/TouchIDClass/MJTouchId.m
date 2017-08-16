//
//  MJTouchId.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJTouchId.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation MJTouchId

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MJTouchId * shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        NSDictionary * infoDictionary = [[NSBundle mainBundle]infoDictionary];
        NSString * appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        if (appName.length <=0) {
            appName = @"";
        }
        _appName =[[NSString alloc]initWithString:appName];
    }
    return self;
}

-(void)save_TouchIdEnabledOrNotByUser_InUserDefaults:(BOOL)isEnabled{
    NSNumber * isEnableNum = [NSNumber numberWithBool:isEnabled];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isEnableNum forKey:KEY_UserDefaults_isTouchIdEnabledOrNotByUser];
    [userDefaults synchronize];
}
- (BOOL)isTouchIdEnabledOrNotByUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber * isEnabledNum = [userDefaults objectForKey:KEY_UserDefaults_isTouchIdEnabledOrNotByUser];
    
    return [isEnabledNum boolValue];
}
-(BOOL)isTouchIdEnabledOrNotBySystem{
#ifdef __IPHONE_8_0
    LAContext * context =[[LAContext alloc]init];
    NSError * authError = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        return YES;
    }else{
        return NO;
    }
#else
    /**
     无法验证指纹
     */
    return NO;
#endif
}

-(BOOL)canVerifyTouchID{
#ifdef __IPHONE_8_0
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        /**
         读取用户配置：用户是否 想使用touchID解锁
         */
        BOOL isEnabled = [self isTouchIdEnabledOrNotByUser];
        if (isEnabled) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
#else
    return NO;
#endif
}

- (void)startVerifyTouchID:(void (^)(void))completionBlock
{
    NSString *myLocalizedReasonString = [NSString stringWithFormat:@"通过验证指纹解锁%@", _appName];
    if (_reasonThatExplainAuthentication.length) {
        myLocalizedReasonString = _reasonThatExplainAuthentication;
    }
    
    
#ifdef __IPHONE_8_0
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    
    // Hide "Enter Password" button
    myContext.localizedFallbackTitle = @"";
    
    // show the authentication UI
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        /**
         读取用户配置：用户是否 想使用touchID解锁
         */
        BOOL isEnabled = [self isTouchIdEnabledOrNotByUser];
        
        if (!isEnabled) {
            
            /**
             如果用户拒绝使用touchID解锁，则 显示提醒。
             */
            [self showAlertIfUserDenied];
            
            return;
        }
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 成功
                                         */
                                        [self authenticatedSuccessfully:completionBlock];
                                    });
                                    
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 失败
                                         */
                                        [self authenticatedFailedWithError:error];
                                    });
                                    
                                }
                            }];
    }
    else
    {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             无法校验指纹
             */
            [self evaluatePolicyFailedWithError:nil];
        });
        
    }
    
#endif  /* __IPHONE_8_0 */
}

#pragma mark - 私有方法
/**
 如果用户拒绝使用touchID解锁，则 显示提醒。
 */
- (void)showAlertIfUserDenied
{
    NSString * title = [NSString stringWithFormat:@"未开启%@指纹解锁", _appName];
    NSString * msg = [NSString stringWithFormat:@"请在%@设置－开启Touch ID指纹解锁", _appName];
    if (_alertMessageToShowWhenUserDisableTouchID.length) {
        msg = _alertMessageToShowWhenUserDisableTouchID;
    }
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message: msg delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil, nil];
    
    [alertView show];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    
#else
    
#endif
}

/**
 指纹校验 成功
 */
- (void)authenticatedSuccessfully:(void (^)(void))completionBlock
{
    if (completionBlock) {
        completionBlock();
    }
}

/**
 指纹校验 失败
 */
- (void)authenticatedFailedWithError:(NSError *)error
{
    
    if (error.code == -1)
    {
        /**
         震动
         */
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
/**
 无法校验指纹
 */
- (void)evaluatePolicyFailedWithError:(NSError *)error
{
    NSLog(@"无法校验指纹");
}

@end
