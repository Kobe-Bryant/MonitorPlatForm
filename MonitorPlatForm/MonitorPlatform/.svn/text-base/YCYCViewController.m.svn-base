//
//  YCYCViewController.m
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-4.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "YCYCViewController.h"
#import "MPAppDelegate.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "PlantPolicyItem.h"

@interface YCYCViewController ()

@property (nonatomic, retain) NSMutableString* resultJsonStr;
@property (nonatomic, retain) NSString* currentElementName;

@end

@implementation YCYCViewController

@synthesize wrymc, wrybh;
@synthesize resultJsonStr, currentElementName;

- (void)dealloc
{
    self.wrymc = nil;
    self.wrybh = nil;
    resultJsonStr = nil;
    [resultDataArray release];
    //[resultHtmlString release];
    [resultWebView release];
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
    
    self.title = @"一厂一策";
    [self requestDataWithName:wrymc andWithCode:wrybh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeView:(NSString *)html
{
    resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-20-44)];
    [self.view addSubview:resultWebView];
    [resultWebView loadHTMLString:html baseURL:nil];
}

#pragma mark - Network Handler

- (void)requestDataWithName:(NSString *)aName andWithCode:(NSString *)aCode
{
    //读取配置文件 ip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.oaServiceIp = [defaults stringForKey:@"oaip_prefer"];
    
    //拼接请求URL地址
    NSString *URL = [NSString stringWithFormat:RECORD_URL, appDelegate.xxcxServiceIP];
    
    //准备SOAP参数
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh, @"wrymc", wrymc, nil];
    
    //发送SOAP请求
	WebServiceHelper *webservice = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"RetrieveAPlantOnePolicy"
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param
                                                                 delegate:self] autorelease];
	[webservice runAndShowWaitingView:self.view];
}

-(void)processWebData:(NSData*)webData
{
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
	if([elementName isEqualToString:@"RetrieveAPlantOnePolicyResult"])
    {
        resultJsonStr = [[NSMutableString alloc] init];
        currentElementName = elementName;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElementName isEqualToString:@"RetrieveAPlantOnePolicyResult"])
    {
        [resultJsonStr appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"RetrieveAPlantOnePolicyResult"])
    {
        //NSLog(@"%@", resultJsonStr);
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if([resultJsonStr isEqualToString:@""] || resultJsonStr == nil)
    {
        //[reportListTableView setHidden:YES];
        UIImageView *emptyBackgroud = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
        emptyBackgroud.image = [UIImage imageNamed:@"nodata.png"];
        [self.view addSubview:emptyBackgroud];
        [emptyBackgroud release];
        return;
        /*UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"没有相关的数据!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
        [_alertView release];*/
        
    }
    [self parseJSON:resultJsonStr];
}

#pragma mark - Parse JSON

- (void)parseJSON:(NSString*)str
{
    if(str == nil || [str isEqualToString:@""])
    {
        return;
    }
    //解析JSON格式的数据
    NSArray *jsonArray = [str objectFromJSONString];
    resultDataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in jsonArray)
    {
        PlantPolicyItem *item = [[PlantPolicyItem alloc] init];
        item.year = [dict objectForKey:@"年度"];
        item.season = [dict objectForKey:@"季度"];
        item.content = [dict objectForKey:@"内容"];
        [resultDataArray addObject:item];
        [item release];
    }
    //加载界面
    [self makeView:[self generatorHtmlTable:resultDataArray]];
}

- (NSString *)generatorHtmlTable:(NSArray *)aContent
{
    NSMutableString *paramsStr = [[[NSMutableString alloc] init] autorelease];
    for (PlantPolicyItem *item in aContent)
    {
        [paramsStr appendFormat:@"<tr><td width=\"13%%\" class=\"t1\">%@</td><td  width=\"37%%\"  class=\"t2\">%@年</td><td width=\"13%%\" class=\"t1\">%@</td><td width=\"37%%\" class=\"t2\">第%@季度</td></tr>", @"年度", item.year, @"季度", item.season];
        [paramsStr appendFormat:@"<tr><td width=\"13%%\" class=\"t1\">%@</td><td  width=\"87%%\" colspan=\"3\"  class=\"t2\">%@</td></tr>", @"内容", item.content];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tablenew" ofType:@"htm"];
    resultHtmlString = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //去除标题
    NSRange range = [resultHtmlString rangeOfString:@"<h2>"];
    [resultHtmlString appendFormat:@"%@", [resultHtmlString substringToIndex:range.location] ];
    [resultHtmlString appendString:@"<div class=\"tablemain\"><table align=\"center\" width=\"96%%\" border=\"0\" cellspacing=\"1\"  cellpadding=\"0\" bgcolor=\"#caeaff\">"];
    [resultHtmlString appendString:paramsStr];
    [resultHtmlString appendString:@"</table></div></div></body></html>"];
    
    return resultHtmlString;
}

@end
