//
//  ReportDetailViewController.m
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "JSONKit.h"
#import "ReportDetailItem.h"
#import "HtmlTableGenerator.h"
#import "MPAppDelegate.h"

@interface ReportDetailViewController ()

@end

@implementation ReportDetailViewController

@synthesize resultJsonStr, currentElementName;
@synthesize ypjbh,wrymc;

- (void)dealloc
{
    self.ypjbh = nil;
    self.resultJsonStr = nil;
    [webservice release];
    [wrymc release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"监测报告详细";
    [self requestData:ypjbh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(webservice)
    {
        [webservice cancel];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - mark Network Handler

- (void)requestData:(NSString*)code
{
    //准备SOAP参数
    NSString *param = [WebServiceHelper createParametersWithKey:@"jcbgbh" value:code,@"wryMc",wrymc, nil];
    
    //读取配置文件 ip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.oaServiceIp = [defaults stringForKey:@"oaip_prefer"];
    
    //拼接请求URL地址
    NSString *URL = [NSString stringWithFormat:RECORD_URL, appDelegate.xxcxServiceIP];
    
	webservice = [[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"MonitorReportData"
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param
                                                                 delegate:self];
	[webservice runAndShowWaitingView:self.view];
    //NSLog(@"%@ %@ %@", URL, param, @"RetrieveMonitoringReportDetail");
}

-(void)processWebData:(NSData*)webData
{
 //   NSLog(@"%@",[[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding]);
    if(webData.length > 0)
    {
        NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData] autorelease];
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: YES];
        [xmlParser parse];
    }
}

-(void)processError:(NSError *)error
{
    NSString *msg = @"请求数据失败，请检查网络。";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - NSXMLParser Delegate Method

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"MonitorReportDataResult"])
    {
        resultJsonStr = [[NSMutableString alloc] init];
        currentElementName = elementName;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElementName isEqualToString:@"MonitorReportDataResult"])
    {
        [resultJsonStr appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"MonitorReportDataResult"])
    {
        //do nothing
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self parseJSON:resultJsonStr];
}

#pragma mark - Parse JSON

- (void)parseJSON:(NSString*)str
{
  /*  NSArray *jsonArray = [str objectFromJSONString];
    if(jsonArray.count == 0)
    {
        UIImageView *emptyBackgroud = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
        emptyBackgroud.image = [UIImage imageNamed:@"nodata.png"];
        [self.view addSubview:emptyBackgroud];
        [emptyBackgroud release];
    }
    resultDataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in jsonArray)
    {
        ReportDetailItem *aItem = [[ReportDetailItem alloc] init];
        aItem.reportAuthor = [dict objectForKey:@"采样人"];
        aItem.pubDate = [dict objectForKey:@"采样时间"];
        aItem.reportLocation = [dict objectForKey:@"采样位置"];
        aItem.reportResult = [dict objectForKey:@"监测结果"];
        aItem.pollutionName = [dict objectForKey:@"污染物名称"];
        aItem.stdStage = [dict objectForKey:@"标准级别"];
        aItem.hasOverPass = [dict objectForKey:@"是否超标"];
        [resultDataArray addObject:aItem];
        [aItem release];
    }
    
    NSString *html =  [self generatorHtmlTable:@"" andWithContent:resultDataArray];*/
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-20-44)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView loadHTMLString:str baseURL:nil];
    [webView release];
}

- (NSString *)generatorHtmlTable:(NSString *)aTitle andWithContent:(NSArray *)aContent
{
    if(aContent.count == 0)
        return nil;
    NSMutableString *paramsStr = [[[NSMutableString alloc] init] autorelease];
    ;
    [paramsStr appendFormat:@"<tr><td width=\"16%%\" class=\"t1\">%@</td><td  width=\"34%%\"  class=\"t2\">%@</td><td width=\"16%%\" class=\"t1\">%@</td><td width=\"34%%\" class=\"t2\">%@</td></tr>", @"采样人", [[aContent objectAtIndex:0] reportAuthor], @"采样位置", [[aContent objectAtIndex:0] reportLocation]];
    for (ReportDetailItem *item in aContent)
    {
        /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:item.pubDate];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timeStr = [formatter stringFromDate:date];
        [formatter release];*/
         [paramsStr appendFormat:@"<tr><td width=\"16%%\" class=\"t1\">%@</td><td  width=\"34%%\"  class=\"t2\">%@</td><td width=\"16%%\" class=\"t1\">%@</td><td width=\"34%%\" class=\"t2\">%@</td></tr>", @"污染物名称",item.pollutionName , @"监测结果", item.reportResult];
        [paramsStr appendFormat:@"<tr><td width=\"14%%\" class=\"t1\">%@</td><td  width=\"36%%\"  class=\"t2\">%@</td><td width=\"16%%\" class=\"t1\">%@</td><td width=\"34%%\" class=\"t2\">%@</td></tr>", @"标准级别",item.stdStage,@"是否超标", item.hasOverPass];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tablenew" ofType:@"htm"];
    NSMutableString *resultHtml = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //去除标题
    NSRange range = [resultHtml rangeOfString:@"<h2>"];
    
    [resultHtml appendFormat:@"%@", [resultHtml substringToIndex:range.location] ];
    
    [resultHtml appendString:@"<div class=\"tablemain\"><table width=\"100%%\" border=\"0\" cellspacing=\"1\"  cellpadding=\"0\" bgcolor=\"#caeaff\">"];
    [resultHtml appendString:paramsStr];
    [resultHtml appendString:@"</table></div></div></body></html>"];
    
    return resultHtml;
}

@end
