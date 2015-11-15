//
//  AttachmentViewController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "AttachmentViewController.h"
#import "MPAppDelegate.h"
#import "LoginedUsrInfo.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation AttachmentViewController
@synthesize resultWV,nLinkerType,webservice;
@synthesize code,attachmentName,attachmentType;

#define xfLinker 1
#define cfLinker 2

#pragma mark - Private method

- (void)getAttachmentData
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    if (nLinkerType == xfLinker) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_XFTS_FILE" forKey:@"service"];
        [param setObject:code forKey:@"bh"];
        
        NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
    }
    
    else if (nLinkerType == cfLinker) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_COMPLAINTS_FILE" forKey:@"service"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
        [param setObject:code forKey:@"bh"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        
        NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
        
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
    
}

#pragma mark - NSURLConnHelper delegate

-(void)processWebData:(NSData*)webData
{
    NSString* tmpDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    NSString *tempFile = nil;
    
    if (nLinkerType == xfLinker)
        tempFile = [tmpDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",attachmentName,attachmentType]];
    else if (nLinkerType == cfLinker)
        tempFile = [tmpDirectory stringByAppendingPathComponent:attachmentName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath: tempFile])
        [manager removeItemAtPath:tempFile error:NULL];
    
    NSURL *url = [NSURL fileURLWithPath:tempFile];
    [webData writeToURL:url atomically:NO];
    
    [resultWV loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = attachmentName;
    [self getAttachmentData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [super dealloc];
    [resultWV release];
    [code release];
    [attachmentName release];
    [attachmentType release];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}
@end
