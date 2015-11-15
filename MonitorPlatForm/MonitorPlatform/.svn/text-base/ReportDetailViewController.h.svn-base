//
//  ReportDetailViewController.h
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "NSURLConnHelperDelegate.h"

@interface ReportDetailViewController : UIViewController <NSURLConnHelperDelegate,NSXMLParserDelegate>
{
    NSMutableArray *resultDataArray;
    WebServiceHelper *webservice;
}

@property (nonatomic, retain) NSString* ypjbh;
@property (nonatomic, retain) NSString* wrymc;
@property (nonatomic, retain) NSMutableString *resultJsonStr;
@property (nonatomic, retain) NSString *currentElementName;

@end
