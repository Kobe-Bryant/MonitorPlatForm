//
//  TableDataItem.h
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableDataItem : NSObject
@property(nonatomic,retain) NSArray *aryColumns;
@property(nonatomic,retain) NSArray *aryColumnWidth;
@property(nonatomic,retain) NSArray *values;
@property(nonatomic,assign) BOOL showImage;
@end
