//
//  WasteGasController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WasteGasController.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "HtmlTableGenerator.h"

extern MPAppDelegate *g_appDelegate;

@implementation WasteGasController
@synthesize bh,infoDic,myWebView;
@synthesize isGotJsonString,curParsedData,webHelper;

#pragma mark - Private methods

- (IBAction)cancelPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getWebData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"serialNumber" value:bh, nil];
    NSString *strUrl = [NSString stringWithFormat:RECORD_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl method:@"RetrieveWasteGasRecord" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"废气笔录";
    
    self.myWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)] autorelease];
    [self.view addSubview:myWebView];
    
    [self getWebData];
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
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
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

#pragma mark - XML parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"RetrieveWasteGasRecordResult"])
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
    if (isGotJsonString && [elementName isEqualToString:@"RetrieveWasteGasRecordResult"]) 
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
    if ([curParsedData length] > 0) {
        
        
        NSString *longInfo = [infoDic objectForKey:@"存在的问题及整改要求"];
        longInfo = [longInfo stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        NSMutableDictionary *adjustDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        [adjustDic setObject:longInfo forKey:@"存在的问题及整改要求"];
        
        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"废气检查笔录" andParaMeters:adjustDic andServiceName:@"RetrieveWasteGasRecord"];
        myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有废气笔录信息，请检查数据库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

@end
