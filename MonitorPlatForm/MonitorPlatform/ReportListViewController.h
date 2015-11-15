//
//  ReportListViewController.h
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface ReportListViewController : UIViewController <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UITableView *reportListTableView;
    NSMutableArray *resultDataArray;
    WebServiceHelper *webservice;
}

@property (nonatomic, retain) NSString* wrybh;
@property (nonatomic, retain) NSString* wrymc;

@end
