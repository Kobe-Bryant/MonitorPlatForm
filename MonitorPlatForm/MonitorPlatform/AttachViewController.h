//
//  AttachViewController.h
//  EvePad
//
//  Created by yushang on 11-3-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class WebServiceHelper;

@interface AttachViewController : UIViewController<NSXMLParserDelegate> {

	UIWebView *webView;
	NSString  *attachName;
	BOOL isTifAttach;
	NSString *guid;
	NSMutableString *currentParsedData;
	int nParserStatus;
	NSString *currentTitle;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(nonatomic, copy) NSString *attachName;
@property(nonatomic, copy) NSString *guid;
@property(nonatomic, copy) NSString *currentTitle;
@property(nonatomic) BOOL isJPG;
@property(nonatomic, retain) NSMutableString *currentParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;

- (id)initWithTitle:(NSString *)szTitle andGUID:(NSString*) guid  isTif:(BOOL)aText;

- (void)getDetail;
@end
