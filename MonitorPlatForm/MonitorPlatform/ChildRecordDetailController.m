//
//  ChildRecordDetailController.m
//  MonitorPlatform
//
//  Created by 张仁松 on 13-6-4.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "ChildRecordDetailController.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "HtmlTableGenerator.h"
#import "WebServiceHelper.h"
extern MPAppDelegate *g_appDelegate;

@interface ChildRecordDetailController ()

@property (nonatomic,strong) UIWebView *myWebView;
@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSString *xmlTagName;

@end

@implementation ChildRecordDetailController
@synthesize theItem,myWebView,infoDic,isGotJsonString,curParsedData,webHelper,xmlTagName;


- (void)dealloc
{
    self.curParsedData = nil;
    self.myWebView = nil;
    self.infoDic = nil;
    self.isGotJsonString = nil;
    self.curParsedData = nil;
    self.webHelper = nil;
    self.xmlTagName = nil;
    [super dealloc];
}

- (void)cancelPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getWebData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"serialNumber" value:theItem.recordBH, nil];
    NSString *strUrl = [NSString stringWithFormat:RECORD_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl method:theItem.serviceName nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    self.xmlTagName = [NSString stringWithFormat:@"%@Result",theItem.serviceName];
    [webHelper runAndShowWaitingView:self.view];
    //NSLog(@"%@ %@ %@", strUrl, param, theItem.serviceName);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Do any additional setup after loading the view.
    //NSLog(@"%@ %@ %@", theItem.recordBH, theItem.recordName, theItem.serviceName);
    self.title = theItem.recordName;
    self.myWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)] autorelease];
    [self.view addSubview:myWebView];
    [self getWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if(webData.length > 0)
    {
        NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: YES];
        [xmlParser parse];
    }
}

-(void)processError:(NSError *)error
{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"     message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"     otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - XML parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:xmlTagName])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
    {
        [self.curParsedData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:xmlTagName])
    {
        if ([curParsedData length] > 0) {
            NSArray *tmpAry = [curParsedData objectFromJSONString];
            self.infoDic = [tmpAry lastObject];
        } else
            self.infoDic = [NSDictionary dictionary];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([curParsedData length] > 0)
    {
        NSArray *json2Array = [curParsedData objectFromJSONString];
        if(json2Array.count == 1)
        {
            NSMutableDictionary *adjustDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
            NSString *xccyqk = [infoDic objectForKey:@"现场采样情况"];
            if(xccyqk!=nil)
            {
                if ([xccyqk isEqualToString:@"1"])
                    xccyqk = @"总排口采样";
                else if ([xccyqk isEqualToString:@"2"])
                    xccyqk = @"其他位置采样";
                else
                    xccyqk = @"未采样";
                [adjustDic setObject:xccyqk forKey:@"现场采样情况"];
            }
            
            NSString *czwt = [infoDic objectForKey:@"存在的问题及整改要求"];
            if(czwt != nil)
            {
                czwt = [czwt stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                [adjustDic setObject:czwt forKey:@"存在的问题及整改要求"];
            }
            NSString *wd = [infoDic objectForKey:@"问题"];
            if(wd!=nil)
            {
                wd = [wd stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                [adjustDic setObject:wd forKey:@"问题"];
            }
            
            for(NSString *key in [adjustDic allKeys])
            {
                NSString *oldValue = [adjustDic objectForKey:key];
                if([key isEqualToString:@"JGXZ"] || [key isEqualToString:@"监管性质"])
                {
                    if([oldValue intValue] == 1)
                    {
                        [adjustDic setValue:@"国控企业" forKey:key];
                    }
                    else if([oldValue intValue] == 2)
                    {
                        [adjustDic setValue:@"省控企业" forKey:key];
                    }
                    else if([oldValue intValue] == 3)
                    {
                        [adjustDic setValue:@"市控企业" forKey:key];
                    }
                    else if([oldValue intValue] == 4)
                    {
                        [adjustDic setValue:@"常规监管企业" forKey:key];
                    }
                    else if([oldValue intValue] == 5)
                    {
                        [adjustDic setValue:@"三同时企业" forKey:key];
                    }
                    else if([oldValue intValue] == 6)
                    {
                        [adjustDic setValue:@"限期治理企业" forKey:key];
                    }
                    else if([oldValue intValue] == 7)
                    {
                        [adjustDic setValue:@"挂牌企业" forKey:key];
                    }
                    else if([oldValue intValue] == 8)
                    {
                        [adjustDic setValue:@"其他" forKey:key];
                    }
                }
            }
            
            if([theItem.serviceName isEqualToString:@"RetrieveFrmIndustrySafety"])
            {
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveFrmIndustrySafety" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                //联系人
                if([[adjustDic allKeys] containsObject:@"LXR"] == NO)
                {
                    NSRange range = [html rangeOfString:@"LXR"];
                    if (range.location  != NSNotFound) {
                        [html replaceCharactersInRange:range withString:@""];
                    }
                }
                //职务
                if([[adjustDic allKeys] containsObject:@"ZW"] == NO)
                {
                    NSRange range = [html rangeOfString:@"ZW"];
                    if (range.location  != NSNotFound) {
                        [html replaceCharactersInRange:range withString:@""];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveIndustry"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveIndustry" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveDuping"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveDuping" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveSiteSupervise"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveSiteSupervise" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveWasteLandFill"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveWasteLandFill" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                NSString *ljtmzl = nil;
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if([key isEqualToString:@"LJTMZL"])
                    {
                        ljtmzl = oldValue;
                        continue;
                    }
                    if (range.location != NSNotFound)
                    {
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                NSRange range2 = [html rangeOfString:@"LJTMZL"];
                if(range2.location != NSNotFound)
                {
                    [html replaceCharactersInRange:range2 withString:ljtmzl];
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrievePlatingPCB"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrievePlatingPCB" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveFrmPowerStationRQ"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveFrmPowerStationRQ" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                 {
                 NSString *oldValue = [adjustDic objectForKey:key];
                 NSRange range = [html rangeOfString:key];
                 if (range.location != NSNotFound)
                 {
                 [html replaceCharactersInRange:range withString:oldValue];
                 }
                 }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else if([theItem.serviceName isEqualToString:@"RetrieveWasteIncineration"])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"RetrieveWasteIncineration" ofType:@"htm"];
                NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                for(NSString *key in [adjustDic allKeys])
                {
                    NSString *oldValue = [adjustDic objectForKey:key];
                    NSRange range = [html rangeOfString:key];
                    if (range.location != NSNotFound)
                    {
                        [html replaceCharactersInRange:range withString:oldValue];
                    }
                }
                
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
                [html release];
            }
            else
            {
                NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:theItem.recordName andParaMeters:adjustDic andServiceName:theItem.serviceName];
                myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
                [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
            }
        }
        else
        {
            NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:theItem.recordName andParaMetersArray:json2Array andServiceName:theItem.serviceName];
            myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
            [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        }
    }
    else
    {
        [myWebView loadHTMLString:@"没有相关笔录信息，请检查数据库" baseURL:nil];
    }
}

@end
