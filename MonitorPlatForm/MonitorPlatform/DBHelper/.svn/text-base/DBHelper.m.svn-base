//
//  DBHelper.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabaseQueue.h"
#import "WryEntity.h"

@interface DBHelper()
@property(nonatomic,retain) FMDatabaseQueue *dbQueue;
@property(nonatomic,assign) BOOL isDbOpening;
@end

@implementation DBHelper
@synthesize dbQueue,isDbOpening;

static DBHelper *_sharedSingleton = nil;
+ (DBHelper *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [NSAllocateObject([self class], 0, NULL) init];
            
        }
    }
    
    return _sharedSingleton;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax; // denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

-(BOOL)initDataBaseQueue{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"jcpt_db.sqlite3"];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];;

    isDbOpening = YES;
    return YES;
    
}

-(BOOL)initJCPTDataBaseQueue{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"jcpt_db.sqlite3"];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];;
    
    isDbOpening = YES;
    return YES;
    
}

-(NSString*)queryLastSyncTimeByTable:(NSString*)table{
    NSString *__block result = @"2000-01-01 10:00:00";//如果查找不到更新时间，就用这个时间
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT ifnull(MAX(XGSJ),'') as LASTSYNC FROM  %@",table];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = [rs stringForColumn:@"LASTSYNC"];
        }
    }];
    

    if([result isEqualToString:@""])
        result = @"2000-01-01 10:00:00";
    return result;
}

-(void)updateTable:(NSString*)tableName andDatas:(NSArray*)aryItems andKeyword:(NSString*)keyword
{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    if(aryItems == nil || [aryItems count] == 0 )
        return;
    NSMutableString *sqlstr = [NSMutableString stringWithCapacity:100];
    NSMutableString *fieldStr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:50];
    
    FMDatabase *dbTmp = [dbQueue database];
    if(dbTmp == nil)return;
    [dbTmp beginTransaction];
    
    for(NSDictionary *dic in aryItems){
        
        NSString *k_value = [dic objectForKey:keyword];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,keyword,k_value];
        [dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,keyword,k_value];
                NSLog(@"deleteSQL:%@",deleteSql);
                [dbTmp executeUpdate:deleteSql];
            }
        }];
        
        NSArray *aryKeys = [dic allKeys];
        //NSInteger *fieldCount = [aryKeys count];
        for(NSString *field in aryKeys){
            [fieldStr appendFormat:@"%@,",field];
            [valueStr appendFormat:@"'%@',",[dic objectForKey:field]];
        }
        
        
        [sqlstr appendFormat:@"insert into %@(%@) values(%@)",tableName,[fieldStr substringToIndex:([fieldStr length]-1)],[valueStr substringToIndex:([valueStr length]-1)]];
        NSLog(@"insertSQL:%@",sqlstr);
        //[dbQueue inDatabase:^(FMDatabase *db) {
        [dbTmp executeUpdate:sqlstr];
        //}];
        
        [fieldStr setString:@""];
        [valueStr setString:@""];
        [sqlstr setString:@""];
        
    }
    
    [dbTmp commit];
    //[dbTmp close];
}

-(void)insertTable:(NSString*)tableName andDatas:(NSArray*)aryItems{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    if(aryItems == nil || [aryItems count] == 0 )
        return;
    NSMutableString *sqlstr = [NSMutableString stringWithCapacity:100];
    NSMutableString *fieldStr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:50];
    
    FMDatabase *dbTmp = [dbQueue database];
    if(dbTmp == nil)return;
    [dbTmp beginTransaction];
    
    for(NSDictionary *dic in aryItems){
        
        NSArray *aryKeys = [dic allKeys];
        //NSInteger *fieldCount = [aryKeys count];
        for(NSString *field in aryKeys){
            [fieldStr appendFormat:@"%@,",field];
            [valueStr appendFormat:@"'%@',",[dic objectForKey:field]];
        }


        [sqlstr appendFormat:@"insert into %@(%@) values(%@)",tableName,[fieldStr substringToIndex:([fieldStr length]-1)],[valueStr substringToIndex:([valueStr length]-1)]];
        NSLog(@"insert sql:%@",sqlstr);
        //[dbQueue inDatabase:^(FMDatabase *db) {
        [dbTmp executeUpdate:sqlstr];
        //}];
        
        [fieldStr setString:@""];
        [valueStr setString:@""];
        [sqlstr setString:@""];
    
    }

    [dbTmp commit];
    [dbTmp close];
}

-(NSArray*)queryAllWrys:(BOOL)ignoreGPS{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    NSMutableArray *__block ary = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    NSString *sql = nil;
    if(ignoreGPS)
        sql = [NSString stringWithFormat:@"SELECT WD,JD,WRYMC,WRYBH,WRYJC  from wry_jbxx"];
    else
        sql = [NSString stringWithFormat:@"SELECT WD,JD,WRYMC,WRYBH,WRYJC from wry_jbxx where WD>22.44 and wd<24 and JD>113.77 order by jd"];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WryEntity *aItem = [[WryEntity alloc] init];
            aItem.Latitude = [rs stringForColumn:@"WD"];
            aItem.Longitude = [rs stringForColumn:@"JD"];
            aItem.WRYMC = [rs stringForColumn:@"WRYMC"];
            aItem.WRYBH = [rs stringForColumn:@"WRYBH"];
            aItem.WRYJC = [rs stringForColumn:@"WRYJC"];
            [ary addObject:aItem];
            [aItem release];
        }
    }];
    
    return ary;
}

-(NSArray*)queryWrysByMC:(NSString*)wrymc{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    NSMutableArray *__block ary = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    NSString *sql = @"";
    if([wrymc length] > 0){
        sql = [NSString stringWithFormat:@"SELECT * from wry_jbxx WHERE FGMC LIKE \'%%%@%%\'",wrymc];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * from wry_jbxx"];
    }
    
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WryEntity *aItem = [[WryEntity alloc] init];
            aItem.WRYMC = [rs stringForColumn:@"WRYMC"];
            aItem.WRYBH = [rs stringForColumn:@"WRYBH"];
            aItem.DWDZ = [rs stringForColumn:@"DWDZ"];
            aItem.XZQH = [rs stringForColumn:@"XZQH"];
            NSString *tmp = [rs stringForColumn:@"HBJGJB"];
            if([tmp isEqualToString:@"1"])
                aItem.HBJGJB = [rs stringForColumn:@"国控"];
            else if([tmp isEqualToString:@"2"])
                aItem.HBJGJB = [rs stringForColumn:@"省控"];
            else if([tmp isEqualToString:@"3"])
                aItem.HBJGJB = [rs stringForColumn:@"市控"];
            else
                aItem.HBJGJB = [rs stringForColumn:@"市控"];
            aItem.DLMC = [rs stringForColumn:@"DLMC"];
            
            [ary addObject:aItem];
            [aItem release];
        }
    }];
    
    return ary;
}

-(NSArray*)queryZXJCWrysByMC:(NSString*)wrymc{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    NSMutableArray *__block ary = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    NSString *sql = @"";
    if([wrymc length] > 0){
        sql = [NSString stringWithFormat:@"SELECT * from wry_zxjc WHERE FGMC LIKE \'%%%@%%\'",wrymc];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * from wry_zxjc"];
    }

    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WryEntity *aItem = [[WryEntity alloc] init];
            aItem.WRYMC = [rs stringForColumn:@"WRYMC"];
            aItem.WRYBH = [rs stringForColumn:@"WRYBH"];
            
            [ary addObject:aItem];
            [aItem release];
        }
    }];
    
    return ary;
}

-(NSArray*)queryWrysBySql:(NSString*)sql{
    if(isDbOpening == NO){
        [self initDataBaseQueue];
    }
    NSMutableArray *__block ary = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WryEntity *aItem = [[WryEntity alloc] init];
            aItem.WRYMC = [rs stringForColumn:@"WRYMC"];
            aItem.WRYJC = [rs stringForColumn:@"WRYJC"];
            aItem.WRYBH = [rs stringForColumn:@"WRYBH"];
            aItem.DWDZ = [rs stringForColumn:@"DWDZ"];
            aItem.XZQH = [rs stringForColumn:@"XZQH"];
            NSString *tmp = [rs stringForColumn:@"HBJGJB"];
            if([tmp isEqualToString:@"1"])
                aItem.HBJGJB = @"国控";
            else if([tmp isEqualToString:@"2"])
                aItem.HBJGJB = @"省控";
            else if([tmp isEqualToString:@"3"])
                aItem.HBJGJB = @"市控";
            else
                aItem.HBJGJB = @"非控";
            aItem.DLMC = [rs stringForColumn:@"DLMC"];
            
            [ary addObject:aItem];
            [aItem release];
        }
    }];
    
    return ary;
}

-(NSArray*)queryIfZxjcDataBySql:(NSString*)sql
{
    if(isDbOpening == NO){
        [self initJCPTDataBaseQueue];
    }
    NSMutableArray *__block ary = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *aItem = [NSMutableDictionary dictionaryWithCapacity:3];
            [aItem setObject:[rs stringForColumn:@"JCBH"] forKey:@"JCBH"];
            [aItem setObject:[rs stringForColumn:@"QYBH"] forKey:@"QYBH"];
            
            [ary addObject:aItem];

        }
    }];
    
    return ary;
}

@end
