//
//  MJiCloud.h
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadBlock)(NSError * error);
typedef void(^downloadBlock)(id obj);
@interface MJiCloud : NSObject

/**
 iCloud 是否可用
 
 @return 返回结果
 */
+ (BOOL)iCloudEnable;

/**
 根据文件名生成本地保存路径
 
 @param name 文件名
 @return 返回路径
 */
+ (NSString *)localFilePath:(NSString *)name;

/**
 上传到iCloud方法
 
 @param name 保存在iCloud的名称
 @param file 需要保存的文件, 可为数组, 字典,或已保存在本地的文件路径或名称
 @param block 上传结果回调
 */
+ (void)uploadToiCloud:(NSString *)name file:(id)file resultBlock:(uploadBlock)block;

/**
 从iCloud获取保存的文件
 
 @param name 保存在iCloud的文件名称
 @param block 保存的文件,可能为数组,字典或NSData
 */
+ (void)downloadFromiCloud:(NSString *)name responsBlock:(downloadBlock)block;


// 下面两个方法是省略了iCloud的文件名的上传及下载方法

/**
 上传iCloud的方法
 
 @param file 需要保存的文件, 可为数组, 字典,或已保存在本地的文件路径或名称
 @param block 上传结果回调
 */
+ (void)uploadToiCloud:(id)file resultBlock:(uploadBlock)block;

/**
 从iCloud获取保存的文件
 
 @param block 返回保存的文件,可能为数组,字典或NSData
 */
+ (void)downloadFromiCloudWithBlock:(downloadBlock)block;

@end
