//
//  NSObject+MJSortKey.h
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MJSortKey)
/********* 为方便排序,新增一个属性 *************/
@property (nonatomic,copy)NSString *key;

@end
