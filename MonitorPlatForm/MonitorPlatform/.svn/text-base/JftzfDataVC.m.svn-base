//
//  JftzfDataVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-4.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "JftzfDataVC.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "DetailsInfoType.h"
#import "HtmlTableGenerator.h"

extern MPAppDelegate *g_appDelegate;

@implementation JftzfDataVC
@synthesize curParsedData,webHelper,webResultAry;
@synthesize isGotJsonString,wrymc,tzsbh;

#pragma mark - Private methods
- (void)requestData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"strTZSBH" value:tzsbh,nil];
    NSString *URL = [NSString stringWithFormat:WRYPWSB_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL 
                                                     method:@"Get_JFTZS_Detail" 
                                                  nameSpace:@"http://tempuri.org/" 
                                                 parameters:param 
                                                   delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [curParsedData release];
    [webHelper release];
    [webResultAry release];
    [wrymc release];
    [tzsbh release];
    [super dealloc];
}

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

    self.title = wrymc;
    
    [self requestData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData{
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Get_JFTZS_DetailResult"])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString) {
        [self.curParsedData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"Get_JFTZS_DetailResult"])
    {
        
        self.webResultAry = [curParsedData objectFromJSONString];
        
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    if ([curParsedData length] > 0) 
    {
        NSDictionary *tmpDic = [webResultAry lastObject];
        
        NSMutableDictionary *reDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        
        NSString *qsrq = [reDic objectForKey:@"QSRQ"];
        if ([qsrq length] > 10) qsrq = [qsrq substringToIndex:10];
        [reDic setObject:qsrq forKey:@"QSRQ"];
        
        NSString *zzrq = [reDic objectForKey:@"ZZRQ"];
        if ([zzrq length] > 10) zzrq = [zzrq substringToIndex:10];
        [reDic setObject:zzrq forKey:@"ZZRQ"];
        
        NSString *yjrq = [reDic objectForKey:@"YJRQ"];
        if ([yjrq length] > 10) yjrq = [yjrq substringToIndex:10];
        [reDic setObject:yjrq forKey:@"YJRQ"];
        
        NSString *fdrq = [reDic objectForKey:@"FDRQ"];
        if ([fdrq length] > 10) fdrq = [fdrq substringToIndex:10];
        [reDic setObject:fdrq forKey:@"FDRQ"];
        
        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"排污收费详情" andParaMeters:reDic andServiceName:@"GET_JFTZS_DETAIL"];
        resultWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [resultWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    else {
        NSString *msg = @"没有符合查询条件的缴费数据";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

@end
