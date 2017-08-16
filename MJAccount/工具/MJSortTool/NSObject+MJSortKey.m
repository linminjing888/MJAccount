//
//  NSObject+MJSortKey.m
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "NSObject+MJSortKey.h"
#import <objc/runtime.h>

@implementation NSObject (MJSortKey)


- (void)setKey:(NSString *)key {
    
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)key {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
