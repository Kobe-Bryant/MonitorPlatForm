//
//  CfjysViewController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-26.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "NSURLConnHelperDelegate.h"

@interface CfjysViewController : UIViewController <NSURLConnHelperDelegate,NSXMLParserDelegate>

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,strong) NSArray *JysResultAry;
@property (nonatomic,copy) NSString *caseCode;
@property (nonatomic,copy) NSString *methodStr;

@property (nonatomic,strong) UIWebView *myWebView;
@property (nonatomic,strong) NSMutableDictionary *infoDic;

@property (nonatomic,assign) BOOL bHaveLoaded;
@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,assign) BOOL isGotJsonString;

@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webservice;

- (id)initWithCaseCode:(NSString *)caseStr;

@end
