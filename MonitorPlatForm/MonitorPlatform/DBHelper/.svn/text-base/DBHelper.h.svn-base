//
//  DBHelper.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBHelper : NSObject
+ (DBHelper *) sharedInstance;


//获取数据库表的最后更新时间
-(NSString*)queryLastSyncTimeByTable:(NSString*)table;
//插入数据到本地数据库
-(void)insertTable:(NSString*)tableName andDatas:(NSArray*)aryItems; 


//查询所有污染源 如果ignoreGPS ＝ NO 查询GPS有效的污染源
-(NSArray*)queryAllWrys:(BOOL)ignoreGPS;

//查询所有执法的企业
-(NSArray*)queryWrysByMC:(NSString*)wrymc;

//查询在线监测的污染源 按照污染源名称
-(NSArray*)queryZXJCWrysByMC:(NSString*)wrymc;

//查询污染源及在线监测污染源
-(NSArray*)queryWrysBySql:(NSString*)sql;

//查询污染源是否存在监测数据
-(NSArray*)queryIfZxjcDataBySql:(NSString*)sql;

//同步数据的本地数据库操作
-(void)updateTable:(NSString*)tableName andDatas:(NSArray*)aryItems andKeyword:(NSString*)keyword;

@end
