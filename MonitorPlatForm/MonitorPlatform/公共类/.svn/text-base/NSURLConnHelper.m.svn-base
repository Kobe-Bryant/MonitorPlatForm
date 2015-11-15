//
//  WebserviceHelper.m
//  tesgt
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnHelper.h"

@implementation NSURLConnHelper
@synthesize webData,delegate,HUD,mConnection,saveTag;

-(void)dealloc
{
    self.webData = nil;
    [super dealloc];
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl 
                   andParentView:(UIView*)aView
                        delegate:(id)aDelegate{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        
        if (!webData) {
            NSMutableData *data = [[NSMutableData alloc] initWithLength:100];
            self.webData = data;
            [data release];
        }
        NSURL *url = [NSURL URLWithString:aUrl];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (HUD) {
            [HUD release];
        }
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = @"正在请求数据，请稍候...";
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                        andTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.saveTag = tag;
        self.delegate = aDelegate;
        
        if (!webData) {
            NSMutableData *data = [[NSMutableData alloc] initWithLength:100];
            self.webData = data;
            [data release];
        }
        NSURL *url = [NSURL URLWithString:aUrl];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (HUD) {
            [HUD release];
        }
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = @"正在请求数据，请稍候...";
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                         andTag:(NSInteger)tag
                     andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.saveTag = tag;
        self.delegate = aDelegate;
        
        if (!webData) {
            NSMutableData *data = [[NSMutableData alloc] initWithLength:100];
            self.webData = data;
            [data release];
        }
        NSURL *url = [NSURL URLWithString:aUrl];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (HUD) {
            [HUD release];
        }
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            HUD.labelText = message;
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

-(void)cancel{
    if(mConnection) [mConnection cancel];
    if(HUD)  [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
    if(HUD) [HUD hide:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (delegate &&[delegate respondsToSelector:@selector(processError: andTag:)]) {
        [delegate processError:error andTag:saveTag];
    }
    else{
        [delegate processError:error] ;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(HUD)  [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (delegate &&[delegate respondsToSelector:@selector(processWebData: andTag:)]) {
        [delegate processWebData:webData andTag:saveTag];
    }
    else{
        [delegate processWebData:webData];
    }
    
//    [webData release];
}


@end
