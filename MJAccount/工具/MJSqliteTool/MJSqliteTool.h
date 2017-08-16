//
//  MJSqliteTool.h
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJGroupModel.h"
#import "MJDataModel.h"
@class FMDatabase;
@interface MJSqliteTool : NSObject

/**
 *  创建一个数据库,保存在沙盒
 *
 *  @param sqliteName 数据库名,可加后缀(.sqlite),也可不加,方法内有判断
 *
 *  @return 返回数据库位置路径
 */
+ (NSString*)MJCreateSqliteWithName:(NSString*)sqliteName;

/**
 *  生成一个单例的数据库文件
 *
 *  @return 返回一个单例数据库
 */
+ (FMDatabase*)MJDefaultDataBase;

/**
 *  在数据库中创建一个表
 *
 *  @param tableName 创建的表名
 */
+ (void)MJCreateDataTableWithName:(NSString*)tableName;
+ (void)MJCreateGroupTableWithName:(NSString*)tableName;
/**
 #pragma 创建密码表
 
 @param tableName 创建的表名
 */
+ (void)MJCreatePswTableWithName:(NSString*)tableName;

#pragma 增
/**
 *  向表中添加一个组数据
 *
 *  @param model 需要添加的数据模型
 */
+ (void)MJInsertToGroupTable:(NSString*)tableName model:(MJGroupModel*)model;
/**
 *  向表中添加一个元素数据
 *
 *  @param model 需要添加的数据模型
 */
+ (void)MJInsertToDataTable:(NSString*)tableName model:(MJDataModel*)model;
/**
 在密码表中插入密码 key值和value值
 
 @param tableName 密码表
 @param pswKey key
 @param pswvalue value
 */
+ (void)MJInsertToPswTable:(NSString*)tableName passwordKey:(NSString *)pswKey passwordValue:(NSString *)pswvalue ;
#pragma 删

/**
 删除表中的一个数据

 @param tableName 表名
 @param model 元素Model
 */
+ (void)MJDeleteFromTable:(NSString*)tableName element:(MJDataModel*)model;

/**
 删除分组

 @param tableName 表名
 @param model 组Model
 */
+ (void)MJDeleteFromGroupTable:(NSString*)tableName element:(MJGroupModel*)model;

#pragma 改

/**
 修改表元素

 @param tableName 表名
 @param model model
 */
+ (void)MJUpdateTable:(NSString*)tableName model:(MJDataModel*)model;

/**
 更新分组名称

 @param tableName 表名
 @param model model
 */
+(void)MJUpdateGroupTable:(NSString*)tableName model:(MJGroupModel*)model;
#pragma 查
/**
 *  获取某张表里元素的个数
 *
 *  @return 表里数据的数目
 */
+ (NSInteger)MJSelectElementCountFromTable:(NSString*)tableName;
/**
 查询某个表中所有的分组

 @param tableName 查询的表名
 @return 含有所有数据模型的数组
 */
+(NSArray*)MJSelectAllGroupsFromTable:(NSString*)tableName;

/**
 查询某个表中所有的元素

 @param tableName 查询的表名
 @return 含有所有数据模型的数组
 */
+(NSArray*)MJSelectAllElementsFromTable:(NSString*)tableName;
/**
 查询某个分组下的所有数据

 @param tableName 表名
 @param groupID 组id
 @return 同一个组的数据模型的数组
 */
+(NSArray*)MJSelectGroupElementsFromTable:(NSString*)tableName groupID:(NSString*)groupID;

/**
 根据元素id查询元素Model类
 */
+(MJDataModel*)MJSelectElementFromTable:(NSString*)tableName identifier:(NSString*)identifier;

/**
 查询密码值
 
 @param tableName 密码表
 @param pswKey key
 @return 密码值
 */
+(NSString *)MJSelectPswFromTable:(NSString*)tableName passwprdKey:(NSString*)pswKey ;



@end
