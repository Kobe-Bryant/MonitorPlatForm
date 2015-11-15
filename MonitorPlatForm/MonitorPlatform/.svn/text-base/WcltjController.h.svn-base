//
//  WcltjController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-16.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 误差量统计

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WcltjConditionController.h"
@class WebServiceHelper;

@interface WcltjController :  UIViewController<WcltjConditionDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UIScrollViewDelegate>

@property (nonatomic,retain)IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) WcltjConditionController *dateController;
@property(nonatomic,retain) NSString *fromDateStr;
@property(nonatomic,retain) NSString* endDateStr;
@property (nonatomic,copy) NSString *wasteType;
@property(nonatomic,strong)NSMutableArray *resultDataAry;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) WebServiceHelper *webHelper;
-(void)requestDataWithStartTime:(NSString *)startT endTime:(NSString *)endT pageCount:(int)page waste:(NSString *)wasteCategory;
@end
