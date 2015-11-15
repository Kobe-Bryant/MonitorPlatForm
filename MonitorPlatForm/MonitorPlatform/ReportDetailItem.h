//
//  ReportDetailItem.h
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportDetailItem : NSObject

@property (nonatomic, retain) NSString* reportAuthor;//采样人
@property (nonatomic, retain) NSString* pubDate;//采样日期
@property (nonatomic, retain) NSString* reportLocation;//采样位置
@property (nonatomic, retain) NSString* reportResult;//监测结果
@property (nonatomic, retain) NSString* pollutionName;//污染物名称
@property (nonatomic, retain) NSString* stdStage;//标准级别
@property (nonatomic, retain) NSString* hasOverPass;//是否超标

@end
