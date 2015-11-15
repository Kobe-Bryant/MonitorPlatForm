//
//  MonitorWarnCountController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDateRangeController.h"
#import "WebServiceHelper.h"

@interface MonitorWarnCountController : UIViewController
<ChooseDateRangeDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>

@property (nonatomic,retain)IBOutlet UITableView *dataTableView;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property(nonatomic,retain) NSString *fromDateStr;
@property(nonatomic,retain)NSString* endDateStr;
@property(nonatomic,strong)NSArray *resultDataAry;
@property (nonatomic,assign) BOOL isLoading;
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) WebServiceHelper *webHelper;
-(void)requestData;

@end

