//
//  GraphTypeDataItem.h
//  StatisticsGraphController
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphTypeDataItem : NSObject
@property(nonatomic,retain) NSString *typeName;
@property(nonatomic,retain) NSMutableArray *groupDataItems;
-(void)addGroupName:(NSString*)name withDatas:(NSDictionary*)values;
@end
