//
//  GraphGroupDataItem
//  StatisticsGraphController
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "GraphGroupDataItem.h"

@implementation GraphGroupDataItem
@synthesize groupName,dicValues;

-(void)dealloc{
    [groupName release];
    [dicValues release];
    [super dealloc];
}
@end
