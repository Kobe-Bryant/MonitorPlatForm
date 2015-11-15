//
//  ZFTZParticularsViewController.m
//  MonitorPlatform
//
//  Created by PowerData on 14-4-18.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import "ZFTZParticularsViewController.h"
#import "ServiceUrlString.h"
#import "MBProgressHUD.h"

@interface ZFTZParticularsViewController ()<UIWebViewDelegate>
@property (nonatomic, retain) MBProgressHUD* HUD;
@end

@implementation ZFTZParticularsViewController
@synthesize  HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webView.delegate = self;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"QUERY_ZFBD" forKey:@"service"];
        [params setObject:self.wrybm forKey:@"WRYBH"];
        [params setObject:[self.dataDic objectForKey:@"RECORDID"] forKey:@"recordId"];
        [params setObject:[self.dataDic objectForKey:@"MBBH"] forKey:@"templateId"];
        NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8086/"  Application:@"platform" Parameters:params];
        NSURL *url = [NSURL URLWithString:strUrl];
        NSURLRequest *requst = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requst];

    if (self.view != nil) {
        HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview: HUD];
        HUD.labelText = @"请稍后，正在加载...";
        [HUD show:YES];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
