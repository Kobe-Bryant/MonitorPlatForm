//
//  ReadMonthDetailViewController.m
//  MonitorPlatform
//
//  Created by ihumor on 13-2-21.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "ReadMonthDetailViewController.h"
#import "ServiceUrlString.h"

@interface ReadMonthDetailViewController ()

@property (nonatomic,strong) NSURLConnHelper *webHelper;
@end

@implementation ReadMonthDetailViewController
@synthesize fileType;

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
    _detailWebView.scalesPageToFit = YES;
    
    if (_fjbh != nil) {
        [self requestFileDataWithBh:_fjbh];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (_webHelper)
        [_webHelper cancel];
    [super viewWillDisappear:animated];
}

- (void)requestFileDataWithBh:(NSString *)fileCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_ZHYB_FILE" forKey:@"service"];
    [param setObject:fileCode forKey:@"bh"];
    
    NSString *url = [ServiceUrlString generateUrlByParameters:param];
    self.webHelper = [[[NSURLConnHelper alloc] initWithUrl:url andParentView:self.view delegate:self] autorelease];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    
   
    if([webData length] <=0 )
        return;
    
    NSString *tmpDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    
    //如果不是xls文件 就是word文档转换后的pdf文件
    if (![fileType isEqualToString:@"xls"]) {
        if (![fileType isEqualToString:@"xlsx"]) {
            fileType = @"pdf";
        }
    }
    NSString *tmpStr = [NSString stringWithFormat:@"月报表.%@",fileType];
    
    NSString *tempFile = [tmpDirectory stringByAppendingPathComponent:tmpStr];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath: tempFile])
        [manager removeItemAtPath:tempFile error:NULL];
    
    NSURL *url = [NSURL fileURLWithPath:tempFile];
    [webData writeToURL:url atomically:NO];
    
    [_detailWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


- (void)dealloc {
    
    [fileType release];
    [_fjbh release];
    [_detailWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFileType:nil];
    [self setFjbh:nil];
    [self setDetailWebView:nil];
    [super viewDidUnload];
}
@end
