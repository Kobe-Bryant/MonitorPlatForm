//
//  JftzfDataVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-4.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "NSURLConnHelperDelegate.h"

@interface JftzfDataVC : UIViewController <NSXMLParserDelegate,NSURLConnHelperDelegate>
{
    IBOutlet UIWebView *resultWebView;
}

@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSArray *webResultAry;

@property (nonatomic,copy) NSString *wrymc;
@property (nonatomic,copy) NSString *tzsbh;
@end
