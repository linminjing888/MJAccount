//
//  MJiCloud.m
//  MJAccount
//
//  Created by YXCZ on 17/8/11.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJiCloud.h"

NSString *iCloudDataName = @"敬敬账号助手";

@implementation MJiCloud
+(BOOL)iCloudEnable{
    NSFileManager * manager = [NSFileManager defaultManager];
    //判断iCloud是否可用
    // 参数传nil表示使用默认容器
    NSURL * url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    return NO;
}

+(NSString*)localFilePath:(NSString *)name{
    // 得到本程序沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    
    return filePath;
}
+(void)uploadToiCloud:(id)file resultBlock:(uploadBlock)block{
    [self uploadToiCloud:iCloudDataName file:file resultBlock:block];
}
+(void)uploadToiCloud:(NSString *)name file:(id)file resultBlock:(uploadBlock)block{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if ([file isKindOfClass:[NSString class]]) {
            [self uploadToiCloud:name localfile:file resultBlock:block];
        }else{
            NSString * path =[self localFilePath:@"temp.data"];
            NSError * error = nil;
            if ([file writeToFile:path options:NSDataWritingAtomic error:&error]) {
                [self uploadToiCloud:name localfile:path resultBlock:block];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(error);
                });
            }
        }
    });
}

/**
 上传本地文件路径
 */
+(void)uploadToiCloud:(NSString *)name localfile:(id)file resultBlock:(uploadBlock)block{
    NSURL * iCloudUrl = [self iCloudFilePathByName:[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *localFilePath = file;
    if ([file componentsSeparatedByString:@"/"].count < 2) {
        
        localFilePath = [self localFilePath:file];
    }
    NSFileManager *manager  = [NSFileManager defaultManager];
    // 判断本地文件是否存在
    if ([manager fileExistsAtPath:localFilePath]) {
        
        NSData *data = [NSData dataWithContentsOfFile:localFilePath];
        // 判断iCloud里该文件是否存在
        if ([manager isUbiquitousItemAtURL:iCloudUrl]) {
            
            NSError *error = nil;
            [data writeToURL:iCloudUrl options:NSDataWritingAtomic error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(error);
            });
            
        } else {
            
            NSURL *fileUrl = [NSURL fileURLWithPath:localFilePath];
            
            NSError *error = nil;
            [manager setUbiquitous:YES itemAtURL:fileUrl destinationURL:iCloudUrl error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(error);
            });
        }
    }
}
+(NSURL*)iCloudFilePathByName:(NSString*)name{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断iCloud是否可用
    // 参数传nil表示使用默认容器
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    
    if (url == nil) {
        
        return nil;
    }
    // 获取Documents目录
    url = [url URLByAppendingPathComponent:@"Documents"];
    NSURL *iCloudPath = [NSURL URLWithString:name relativeToURL:url];
    
    return iCloudPath;
}


+ (void)downloadFromiCloudWithBlock:(downloadBlock)block {
    
    
    [self downloadFromiCloud:iCloudDataName responsBlock:block];
}

+ (void)downloadFromiCloud:(NSString *)name responsBlock:(downloadBlock)block {
    NSURL *iCloudUrl = [self iCloudFilePathByName:[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        if ([self downloadFileIfNotAvailable:iCloudUrl]) {
            
            // 先尝试转为数组
            NSArray *array = [[NSArray alloc]initWithContentsOfURL:iCloudUrl];
            
            if (array != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    block(array);
                });
                
            } else {
                
                // 如果数组为nil, 再尝试转为字典
                NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfURL:iCloudUrl];
                if (dic != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        block(dic);
                    });
                } else {
                    // 如果字典为nil, 最后尝试转为NSData
                    NSData *data = [[NSData alloc]initWithContentsOfURL:iCloudUrl];
                    if (data != nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            block(data);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            block(nil);
                        });
                    }
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(nil);
            });
        }
    });
}
// // 此方法是官方文档提供,用来检查文件状态并下载
+ (BOOL)downloadFileIfNotAvailable:(NSURL*)file {
    NSNumber*  isIniCloud = nil;
    
    if ([file getResourceValue:&isIniCloud forKey:NSURLIsUbiquitousItemKey error:nil]) {
        // If the item is in iCloud, see if it is downloaded.
        if ([isIniCloud boolValue]) {
            NSNumber*  isDownloaded = nil;
            if ([file getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemDownloadingStatusKey error:nil]) {
                if ([isDownloaded boolValue])
                    return YES;
                
                // Download the file.
                NSFileManager*  fm = [NSFileManager defaultManager];
                if (![fm startDownloadingUbiquitousItemAtURL:file error:nil]) {
                    return NO;
                }
                return YES;
            }
        }
    }
    
    // Return YES as long as an explicit download was not started.
    return YES;
}

@end
