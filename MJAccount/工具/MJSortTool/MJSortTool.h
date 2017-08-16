//
//  MJSortTool.h
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 返回的排序后的结果字典中,序号对应的key */
static NSString  const * _Nonnull  MJSortToolKey = @"MJSortToolKey";

/** 返回的排序后的结果字典中,value对应的key*/
static NSString const * _Nonnull MJSortToolValueKey = @"MJSortToolValueKey";

typedef NS_ENUM (NSInteger,MJSortResultType) {
    /** 不含有索引值的结果 */
    MJSortResultTypeSingleValue = 0,
    /** 含有索引值的结果 */
    MJSortResultTypeDoubleValues = 1,
};

@interface MJSortTool : NSObject

/**
 对一组字符串,按照首个字符的首字母进行分组排序

 @param sourceArray 待分组排序的字符串集合集合
 @param sortType 排序结果的类型
 @return 返回一个排序分组后的数组
 */
+ (nullable NSArray*)sortStrings:(nonnull NSArray<NSString *>*)sourceArray withSortType:(MJSortResultType)sortType;

/**
 对一组NSObject的子类对象(一般是model模型)按某个属性进行排序

 @param sources 含有model的数组
 @param key 排序依据,必须是model的一个字符串属性,不能为nil
 @param sortType 排序结果的类型
 @return 返回排序结果(含有model)
 */
+ (nullable NSArray *)sortObjcs:(nonnull NSArray <NSObject *>*)sources byKey:(nonnull NSString *)key withSortType:(MJSortResultType)sortType;
@end
