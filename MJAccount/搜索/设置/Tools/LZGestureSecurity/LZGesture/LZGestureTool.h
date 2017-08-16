//
//  LZGestureTool.h
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZGestureTool : NSObject


+ (void)saveGestureEnableByUser:(BOOL)isEnable;
/// 用户是否开启了手势解锁
+ (BOOL)isGestureEnableByUser;

/// 保存 读取用户设置的密码
+ (void)saveGesturePsw:(NSString *)psw;
+ (NSString *)getGesturePsw;
+ (void)deleteGesturePsw;
+ (BOOL)isGesturePswEqualToSaved:(NSString *)psw;
/// 是否（开启了手势解锁且设置了解锁密码）
+ (BOOL)isGestureEnable;
/// 是否设置解锁密码
+ (BOOL)isGesturePswSavedByUser;

+ (void)saveGestureResetEnableByTouchID:(BOOL)enable;
+ (BOOL)isGestureResetEnableByTouchID;
@end
