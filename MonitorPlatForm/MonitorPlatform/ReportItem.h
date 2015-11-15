//
//  ReportItem.h
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportItem : NSObject

@property (nonatomic, retain) NSString* code;//报告编号
@property (nonatomic, retain) NSString* content;//监测内容
@property (nonatomic, retain) NSString* result;//监测结论
@property (nonatomic, retain) NSString* pubDate;//报告时间
@property (nonatomic, retain) NSString* author;//填报人

@end
