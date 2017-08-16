//
//  MJSqliteTool.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJSqliteTool.h"
#import "FMDB.h"
#import "MJStringTool.h"

static NSString * MJ_dbPath = nil;
@implementation MJSqliteTool

+ (NSString*)MJCreateSqliteWithName:(NSString*)sqliteName{
    NSString * fileName = nil;
    NSArray * strArr = [sqliteName componentsSeparatedByString:@"."];
    if ([[strArr lastObject] isEqualToString:@"sqlite"]||[[strArr lastObject]isEqualToString:@"db"]) {
        fileName = sqliteName;
    }else{
        fileName = [NSString stringWithFormat:@"%@.db",sqliteName];
    }
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:fileName];
    MJLog(@"数据库路径：%@",path);
    MJ_dbPath = path;
    if (![manager fileExistsAtPath:path]) {
        [manager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}
+(FMDatabase*)MJDefaultDataBase{
    if (MJ_dbPath == nil) {
        [self MJCreateSqliteWithName:@"myDataBase"];
    }
    FMDatabase * db = [[FMDatabase alloc]initWithPath:MJ_dbPath];
    return db;
}

+(void)MJCreateDataTableWithName:(NSString*)tableName{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if (![db tableExists:tableName]) {
        NSString * createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL,groupName TEXT,title TEXT,account TEXT,password TEXT,phoneNumber TEXT,email TEXT,dsc TEXT,groupID TEXT NOT NULL)",tableName];
        [db executeUpdate:createTable];
    }
    [db close];
}
+ (void)MJCreateGroupTableWithName:(NSString*)tableName{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if (![db tableExists:tableName]) {
        NSString * createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL,groupName TEXT)",tableName];
        [db executeUpdate:createTable];
    }
    [db close];
}

//插入分组
+ (void)MJInsertToGroupTable:(NSString*)tableName model:(MJGroupModel*)model{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSInteger count = [self MJSelectElementCountFromTable:tableName];
        count++;
        NSString * insert = [NSString stringWithFormat:@"INSERT INTO '%@'(identifier,groupName) VALUES ('%@','%@')",tableName,model.identifier,model.groupName];
        [db executeUpdate:insert];
    }
    [db close];
}

+ (void)MJInsertToDataTable:(NSString*)tableName model:(MJDataModel*)model{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSString * account =[MJStringTool encode:model.account];
        NSString * psw = [MJStringTool encode:model.password];
        NSString * phoneNumber = [MJStringTool encode:model.phoneNumber];
        NSString * email = [MJStringTool encode:model.email];
        NSString * dsc = [MJStringTool encode:model.dsc];
        
        NSString * insert =[NSString stringWithFormat:@"INSERT INTO '%@' (identifier,groupName,title,account,password,phoneNumber,email,dsc,groupID) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,model.identifier,model.groupName,model.title,account,psw,phoneNumber,email,dsc,model.groupID];
        [db executeUpdate:insert];
    }
    [db close];
}


+ (void)MJCreatePswTableWithName:(NSString*)tableName{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if (![db tableExists:tableName]) {
        NSString * createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL,dataPsw TEXT)",tableName];
        [db executeUpdate:createTable];
    }
    [db close];
}
+ (void)MJInsertToPswTable:(NSString*)tableName passwordKey:(NSString *)pswKey passwordValue:(NSString *)pswvalue{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSInteger count = [self MJSelectElementCountFromTable:tableName];
        count++;
        NSString * insert = [NSString stringWithFormat:@"INSERT INTO '%@'(identifier,dataPsw) VALUES ('%@','%@')",tableName,pswKey,pswvalue];
        [db executeUpdate:insert];
    }
    [db close];
}
+ (void)MJDeleteFromTable:(NSString*)tableName element:(MJDataModel*)model{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        
        NSString * delete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE identifier = '%@'",tableName,model.identifier];
        [db executeUpdate:delete];
    }
    [db close];
}
+ (void)MJDeleteFromGroupTable:(NSString*)tableName element:(MJGroupModel*)model{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        
        NSString * delete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE identifier = '%@'",tableName,model.identifier];
        [db executeUpdate:delete];
    }
    [db close];
}

+ (void)MJUpdateTable:(NSString*)tableName model:(MJDataModel*)model{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSString * account =[MJStringTool encode:model.account];
        NSString * psw = [MJStringTool encode:model.password];
        NSString * phoneNumber = [MJStringTool encode:model.phoneNumber];
        NSString * email = [MJStringTool encode:model.email];
        NSString * dsc = [MJStringTool encode:model.dsc];
        
        NSString * update = [NSString stringWithFormat:@"UPDATE '%@' SET groupName = '%@',title = '%@',account = '%@',password = '%@',phoneNumber = '%@',email = '%@',dsc = '%@',groupID = '%@' WHERE identifier = '%@'",tableName,model.groupName,model.title,account,psw,phoneNumber,email,dsc,model.groupID,model.identifier];
        [db executeUpdate:update];
    }
    [db close];
}
+(void)MJUpdateGroupTable:(NSString*)tableName model:(MJGroupModel*)model{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
    
        NSString * update = [NSString stringWithFormat:@"UPDATE '%@' SET groupName = '%@' WHERE identifier = '%@'",tableName,model.groupName,model.identifier];
        [db executeUpdate:update];
    }
    [db close];
    
}

+ (NSInteger)MJSelectElementCountFromTable:(NSString*)tableName{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return 0;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSString * select = [NSString stringWithFormat:@"SELECT count(*) FROM '%@'",tableName];
        FMResultSet * fs = [db executeQuery:select];
        [fs next];
        NSInteger count = [fs intForColumn:@"count(*)"];
        [fs close];
        [db close];
        return count;
    }
    return 0;
}

+(NSArray*)MJSelectAllGroupsFromTable:(NSString*)tableName{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSString * select = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        FMResultSet * fs = [db executeQuery:select];
        NSMutableArray * resultArr =[NSMutableArray arrayWithCapacity:0];
        while ([fs next]) {
            MJGroupModel * model = [[MJGroupModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.groupName = [fs stringForColumn:@"groupName"];
            [resultArr addObject:model];
        }
        [fs close];
        [db close];
        return resultArr;
    }
    return nil;
}
+(NSArray*)MJSelectAllElementsFromTable:(NSString*)tableName{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        
        NSString * select = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        FMResultSet * fs =[db executeQuery:select];
        NSMutableArray * resultArr =[NSMutableArray arrayWithCapacity:0];
        while ([fs next]) {
            MJDataModel * model = [[MJDataModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.title  =[fs stringForColumn:@"title"];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID =[fs stringForColumn:@"groupID"];
            
            NSString * account =[fs stringForColumn:@"account"];
            model.account = [MJStringTool decode:account];
            NSString * psw =[fs stringForColumn:@"password"];
            model.password = [MJStringTool decode:psw];
            NSString * phoneNumber =[fs stringForColumn:@"phoneNumber"];
            model.phoneNumber = [MJStringTool decode:phoneNumber];
            NSString * email =[fs stringForColumn:@"email"];
            model.email = [MJStringTool decode:email];
            NSString * dsc =[fs stringForColumn:@"dsc"];
            model.dsc = [MJStringTool decode:dsc];
            [resultArr addObject:model];
        }
        [fs close];
        [db close];
        return resultArr;
    }
    return nil;
}

+(NSArray*)MJSelectGroupElementsFromTable:(NSString*)tableName groupID:(NSString*)groupID{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        
        NSString * select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE groupID = '%@'",tableName,groupID];
        FMResultSet * fs =[db executeQuery:select];
        NSMutableArray * resultArr =[NSMutableArray arrayWithCapacity:0];
        while ([fs next]) {
            MJDataModel * model = [[MJDataModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.title  =[fs stringForColumn:@"title"];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID =[fs stringForColumn:@"groupID"];
            
            NSString * account =[fs stringForColumn:@"account"];
            model.account = [MJStringTool decode:account];
            NSString * psw =[fs stringForColumn:@"password"];
            model.password = [MJStringTool decode:psw];
            NSString * phoneNumber =[fs stringForColumn:@"phoneNumber"];
            model.phoneNumber = [MJStringTool decode:phoneNumber];
            NSString * email =[fs stringForColumn:@"email"];
            model.email = [MJStringTool decode:email];
            NSString * dsc =[fs stringForColumn:@"dsc"];
            model.dsc = [MJStringTool decode:dsc];
            [resultArr addObject:model];
        }
        [fs close];
        [db close];
        return resultArr;
    }
    return nil;
}

+(MJDataModel*)MJSelectElementFromTable:(NSString*)tableName identifier:(NSString*)identifier{
    FMDatabase *db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        
        NSString * select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE identifier = '%@'",tableName,identifier];
        FMResultSet * fs =[db executeQuery:select];
        
        MJDataModel * model = [[MJDataModel alloc]init];
        while ([fs next]) {
            model.identifier = [fs stringForColumn:@"identifier"];
            model.title  =[fs stringForColumn:@"title"];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID =[fs stringForColumn:@"groupID"];
            
            NSString * account =[fs stringForColumn:@"account"];
            model.account = [MJStringTool decode:account];
            NSString * psw =[fs stringForColumn:@"password"];
            model.password = [MJStringTool decode:psw];
            NSString * phoneNumber =[fs stringForColumn:@"phoneNumber"];
            model.phoneNumber = [MJStringTool decode:phoneNumber];
            NSString * email =[fs stringForColumn:@"email"];
            model.email = [MJStringTool decode:email];
            NSString * dsc =[fs stringForColumn:@"dsc"];
            model.dsc = [MJStringTool decode:dsc];
        }
        [fs close];
        [db close];
        return model;
    }
    return nil;
}


+(NSString *)MJSelectPswFromTable:(NSString*)tableName passwprdKey:(NSString*)pswKey{
    FMDatabase * db = [self MJDefaultDataBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    //为数据设置缓存,提高查询效率
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        NSString * password = nil;
        NSString * select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE identifier = '%@'",tableName,pswKey];
        FMResultSet * fs = [db executeQuery:select];
        if ([fs next]) {
            password = [fs stringForColumn:@"dataPsw"];
        }
        [fs close];
        [db close];
    }
    return nil;
}
@end
