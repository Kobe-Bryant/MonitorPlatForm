//
//  UsersHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "UsersHelper.h"

#import "DataSyncTables.h"
@implementation UsersHelper

-(id)init{
    if(self = [super init]){
        
        NSArray *aryTables = [DataSyncTables tableNamesAry];
        for(NSString *table in aryTables){
            NSString *key = [DataSyncTables primaryKeyForTable:table];
            if([key length] > 0){
                [self deleteDupRecords:table byKeyColumn:key];
            }
        }
    }
    return self;
}

-(void)saveAllUsers:(NSArray *)aryUsers{
    
}

-(NSArray*)queryAllUsers{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from  T_ADMIN_RMS_YH  order by PXH"];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}

- (NSString *)queryUserNameByID:(NSString *)userId
{
    if([userId isEqualToString:@"system"])
    {
        return @"系统管理员";
    }
    __block NSString *ret = @"";
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where YHID='%@'  order by PXH", userId];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if (rs.next) {
            ret = [rs stringForColumn:@"YHMC"];
        }
        [rs close];
    }];
    return ret;
}

- (NSString *)queryUserBMBHByName:(NSString *)userName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where YHMC='%@'  order by PXH", userName];
    NSString __block *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            ret = [dic objectForKey:@"BMBH"];
        }
        [rs close];
    }];
    return ret;
}

- (NSArray *)queryAllRootDept
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@' order by PXH ", @"ROOT"];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSArray *)queryAllDept
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG  order by PXH "];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (BOOL)hasSubDept:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    BOOL __block ret = NO;
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@'  order by PXH", deptStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if(rs.next)
        {
            ret = YES;
        }
        [rs close];
    }];
    return ret;
}

- (NSArray *)queryAllSubDept:(NSString *)parentStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@' order by PXH ", parentStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSArray *)queryAllUsers:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where BMBH='%@' order by PXH ", deptStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSString *)queryParentDeptName:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where ZZBH=(select SJZZXH from T_ADMIN_RMS_ZZJG where ZZBH='%@')  order by PXH", deptStr];
    NSString __block *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            ret = [dic objectForKey:@"ZZQC"];
        }
        [rs close];
    }];
    return ret;
}

- (void)clearAllData
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql1 = [NSString stringWithFormat:@"delete from %@", @"T_ADMIN_RMS_YH"];
    NSString *sql2 = [NSString stringWithFormat:@"delete from %@", @"T_ADMIN_RMS_ZZJG"];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql1];//一点要先清空用户表，然后再清空组织机构表
        [db executeUpdate:sql2];
    }];
}

- (NSString *)queryBMMCByBMBH:(NSString *)bmbh{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where ZZBH='%@'  order by PXH", bmbh];
    NSString __block *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        //ret = [rs stringForColumn:@"ZZQC"];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            ret = [dic objectForKey:@"ZZQC"];
        }
        [rs close];
    }];
    return ret;
}

-(NSString*)queryHBJMCBySJQX:(NSString*)sjqx{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_YDZF_HBJMC_JCDDCW where SJQX='%@'", sjqx];
    NSString __block *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        //ret = [rs stringForColumn:@"ZZQC"];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            ret = [dic objectForKey:@"HBJMC"];
        }
        [rs close];
    }];
    return ret;
}
@end
