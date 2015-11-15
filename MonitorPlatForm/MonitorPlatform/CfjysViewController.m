//
//  CfjysViewController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-26.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "CfjysViewController.h"
#import "JSONKit.h"
#import "HtmlTableGenerator.h"
#import "MPAppDelegate.h"
#import "ZrsUtils.h"

extern MPAppDelegate *g_appDelegate;

@implementation CfjysViewController

@synthesize webResultAry,caseCode,nParserStatus,methodStr,bHaveLoaded;
@synthesize isGotJsonString,curParsedData,JysResultAry,webservice;
@synthesize myWebView,infoDic;

#define nDetailData 1
#define nCfjysData 2

#pragma mark - Private methods

- (void)requestData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"ladjbh" value:caseCode,nil];
    NSString *URL = [NSString stringWithFormat:WRYCFTZ_URL,g_appDelegate.xxcxServiceIP];
    //NSLog(@"param=%@\n url=%@",param,URL);
    self.webservice = [[[WebServiceHelper alloc] initWithUrl:URL 
                                                                   method:methodStr 
                                                                nameSpace:@"http://tempuri.org/" 
                                                               parameters:param 
                                                                 delegate:self] autorelease];
    [webservice runAndShowWaitingView:self.view];
}

#pragma mark - View lifecycle

- (id)initWithCaseCode:(NSString *)caseStr
{
    self = [super init];
    if (self) {
        self.caseCode = caseStr;
        bHaveLoaded = NO;
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
    
    nParserStatus = nDetailData;
    self.methodStr = @"GetXzcfxx";
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
    if (webservice) {
        [webservice cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    /*
    NSString *xmlStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",xmlStr);
    [xmlStr release];
    */
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

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSString *methodResult = [NSString stringWithFormat:@"%@Result",methodStr];
    
    if ([elementName isEqualToString:methodResult])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *methodResult = [NSString stringWithFormat:@"%@Result",methodStr];
    
    if (isGotJsonString && [elementName isEqualToString:methodResult]) 
    {
        if (nParserStatus == nDetailData)
            self.webResultAry = [curParsedData objectFromJSONString];
        else
            self.JysResultAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    if (nParserStatus == nDetailData)
    {
        self.methodStr = @"GetCfjys";
        nParserStatus = nCfjysData;
        [self requestData];
    }
    else
    {
        
        NSDictionary *tmpDic1 = [webResultAry objectAtIndex:0];
        self.infoDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic1];
        
        NSDictionary *tmpDic2 = [JysResultAry objectAtIndex:0];
        if (tmpDic2 && [tmpDic2 count] > 0)
        {
            [infoDic setObject:[[tmpDic2 objectForKey:@"WJWH70_"] copy] forKey:@"WJWH70_"];
            [infoDic setObject:[[tmpDic2 objectForKey:@"JDSNR70_"] copy] forKey:@"JDSNR70_"];
        }
        else
        {
            [infoDic setObject:@" " forKey:@"WJWH70_"];
            [infoDic setObject:@" " forKey:@"JDSNR70_"];
        }
     
        //调整是否罚款
        NSString *sffk = [infoDic objectForKey:@"SFFK48_"];
        if ([sffk intValue] == 1)
        {
            sffk = @"是";
            [infoDic setObject:sffk forKey:@"SFFK48_"];
        }
        else
        {
            sffk = @"否";
            [infoDic setObject:sffk forKey:@"SFFK48_"];
        }
        //调整决定书内容
        NSString *spyj = [infoDic objectForKey:@"JDSNR70_"];
        if (spyj && [spyj length] > 0)
        {
            spyj = [spyj stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            [infoDic setObject:spyj forKey:@"JDSNR70_"];
        }
        
        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"行政处罚详情" andParaMeters:infoDic andServiceName:@"GetXzcfxx"];
        myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        
    }

}

@end
