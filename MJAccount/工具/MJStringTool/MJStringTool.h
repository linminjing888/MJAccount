//
//  MJStringTool.h
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJStringTool : NSObject

/**
 生成一个随机的字符串来作为唯一标识符

 @return 生成一个随机的字符串,并且进行了MD5编码
 */
+ (NSString*)creatRedomMD5String;


/**
 AES 加密

 @param str 加密前字符串
 @return 加密后字符串
 */
+ (NSString *)encode:(NSString *)str;

/**
 解密

 @param str 解密前字符串
 @return 解密后字符串
 */
+ (NSString *)decode:(NSString *)str;


@end
