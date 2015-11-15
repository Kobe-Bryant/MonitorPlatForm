//
//  GraphTypeDataItem.m
//  StatisticsGraphController
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "GraphTypeDataItem.h"
#import "GraphGroupDataItem.h"
@implementation GraphTypeDataItem
@synthesize typeName,groupDataItems;

-(id)init{
    if(self = [super init]){
        self.groupDataItems = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

-(void)addGroupName:(NSString*)name withDatas:(NSDictionary*)values{
    GraphGroupDataItem *aItem = [[GraphGroupDataItem alloc] init];
    aItem.groupName = name;
    aItem.dicValues = values;
    [groupDataItems addObject:aItem];
    [aItem release];
}

-(void)dealloc{
    [typeName release];
    [groupDataItems release];
    [super dealloc];
}
@end
