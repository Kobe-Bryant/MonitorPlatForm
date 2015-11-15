//
//  GufeiDetailInfoController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"


@class WebServiceHelper;

@interface GufeiDetailInfoController : UITableViewController <NSURLConnHelperDelegate,NSXMLParserDelegate>

@property (nonatomic,copy) NSString *wrybh;
@property (nonatomic,copy) NSString *code;

@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,copy) NSString *currentMethod;
@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *valueArray;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@end