//
//  XmspDetailsController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-5-4.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface XmspDetailsController : UIViewController <NSURLConnHelperDelegate,NSXMLParserDelegate>

@property (nonatomic,strong) UIWebView *myWebView;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,assign) int dataType;
@property (nonatomic,copy) NSString *proCode;

- (id)initWithProjectCode:(NSString *)projectStr andDataType:(int)type;
- (id)initWithInfoDic:(NSDictionary *)dataDic andDataType:(int)type;

@end
