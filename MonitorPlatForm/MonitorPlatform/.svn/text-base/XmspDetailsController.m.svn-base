//
//  XmspDetailsController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-5-4.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "XmspDetailsController.h"
#import "JSONKit.h"
#import "HtmlTableGenerator.h"
#import "MPAppDelegate.h"
#import "ZrsUtils.h"

extern MPAppDelegate *g_appDelegate;

@interface XmspDetailsController ()
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic, strong) NSMutableString *curParsedData;
@property (nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableDictionary *midDic;
@end


@implementation XmspDetailsController
@synthesize infoDic,myWebView,dataType,proCode;
@synthesize curParsedData,isGotJsonString,midDic;

#define fromProject 0
#define fromWry 1

#pragma mark - Private methods

-(void)requestData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"strXMBH" value:proCode,nil];
    NSString *URL = [NSString stringWithFormat:WRYJBXX_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL method:@"NewGetXmsp_Detail" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    [self.webHelper runAndShowWaitingView:self.view];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [infoDic release];
    [myWebView release];
    [super dealloc];
}

- (id)initWithInfoDic:(NSDictionary *)dataDic andDataType:(int)type
{
    self = [super init];
    if (self) {
        self.infoDic = dataDic;
        self.dataType = type;
    }
    return self;
}

- (id)initWithProjectCode:(NSString *)projectStr andDataType:(int)type
{
    self = [super init];
    if (self)
    {
        self.proCode = projectStr;
        self.dataType = type;
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
    
    UIWebView *aweb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    [self.view addSubview:aweb];
    self.myWebView = aweb;
    [aweb release];
    
    if (dataType == fromProject)
    {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        //调整日期数据
        NSString *sprq = [infoDic objectForKey:@"审批日期"];
        if ([sprq length] > 10)
            sprq = [sprq substringToIndex:10];
        [tmpDic setObject:sprq forKey:@"审批日期"];
        //调整意见数据
        NSString *spyj = [infoDic objectForKey:@"审批意见"];
        if ([spyj length] > 0)
            spyj = [spyj stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        [tmpDic setObject:spyj forKey:@"审批意见"];
    
        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"建设项目审批详情" andParaMeters:tmpDic andServiceName:@"NewGetXmsp"];
        myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
        [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    else
    {
        [self requestData];
    }
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
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);
     */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error
{
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

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
    self.midDic = [NSMutableDictionary dictionaryWithCapacity:20];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NewGetXmsp_DetailResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"NewGetXmsp_DetailResult"])
    {
        NSDictionary *tmpDic = [[curParsedData objectFromJSONString] objectAtIndex:0];
        
        [midDic setObject:[[tmpDic objectForKey:@"XMMC275_"] copy] forKey:@"项目名称"];
        [midDic setObject:[[tmpDic objectForKey:@"TZDW275_"] copy] forKey:@"WRYMC"];
        [midDic setObject:[[tmpDic objectForKey:@"TZDWDZ275_"] copy] forKey:@"建设地点或生产地址"];
        [midDic setObject:[[tmpDic objectForKey:@"SPY275_"] copy] forKey:@"审批员"];
        [midDic setObject:[[tmpDic objectForKey:@"SPRQ275_"] copy] forKey:@"审批日期"];
        [midDic setObject:[[tmpDic objectForKey:@"SFTGSP275_"] copy] forKey:@"是否通过"];
        [midDic setObject:[[tmpDic objectForKey:@"SPWH"] copy] forKey:@"审批文号"];
        [midDic setObject:[[tmpDic objectForKey:@"SPYJ"] copy] forKey:@"审批意见"];
        self.infoDic = midDic;
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    //调整日期数据
    NSString *sprq = [infoDic objectForKey:@"审批日期"];
    if ([sprq length] > 10)
        sprq = [sprq substringToIndex:10];
    [tmpDic setObject:sprq forKey:@"审批日期"];
    //调整是否通过审批
    NSString *sftg = [infoDic objectForKey:@"是否通过"];
    if ([sftg intValue] == 1)
        sftg = @"已通过";
    else
        sftg = @"未通过";
    [tmpDic setObject:sftg forKey:@"是否通过"];
    //调整意见数据
    NSString *spyj = [infoDic objectForKey:@"审批意见"];
    if ([spyj length] > 0)
        spyj = [spyj stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    [tmpDic setObject:spyj forKey:@"审批意见"];
    
    NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"建设项目审批详情" andParaMeters:tmpDic andServiceName:@"NewGetXmsp"];
    myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}

@end
