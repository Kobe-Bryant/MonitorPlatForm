//
//  MonitorWarnItemController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "ChooseDateRangeController.h"

@interface MonitorWarnItemController : UIViewController
<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,ChooseDateRangeDelegate>

@property (nonatomic,retain)IBOutlet UITableView *dataTableView;

@property(nonatomic,retain) NSString *fromDateStr;
@property(nonatomic,retain) NSString* endDateStr;
@property(nonatomic,strong) NSArray *resultDataAry;
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property(nonatomic,copy) NSString *wrybh;
@property(nonatomic,copy) NSString *wrymc;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;

@property (nonatomic,assign) BOOL bChooseDate;

-(void)requestData;
-(id)initWithWryBh:(NSString*)bh wryMc:(NSString*)mc fromDateStr:(NSString*)fromDate
     andEndDateStr:(NSString*)endDate;
@end
