//
//  YuQingViewController.h
//  GIS
//
//  Created by yushang on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface WebServiceHelper : NSObject  {
	NSString *url;
	NSString *method;
	NSString *nameSpace;
	NSString *parameters;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSURLConnection *theConnection;
	
	id<NSURLConnHelperDelegate> delegate;
	BOOL bConnected;
    
}

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *nameSpace;
@property(nonatomic, copy) NSString *parameters;

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic,retain) MBProgressHUD *HUD;
@property(nonatomic, assign) id<NSURLConnHelperDelegate> delegate;


+ (NSString*) createParametersWithKey:(NSString*) aKey value:(NSString*) aValue, ...;

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace 
					  parameters:(NSString*) aParameters 
						delegate:(id) aDelegate;

- (WebServiceHelper*)initWithUrl:(NSString *)aUrl 
                          method:(NSString *)aMethod 
                       nameSpace:(NSString *)aNameSpace 
                        delegate:(id)aDelegate;

- (void)run;
-(void)cancel;
- (void)runAndShowWaitingView:(UIView*)parentView;
@end
