//
//  DW_DetailVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 13-2-5.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "DW_DetailVC.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@interface DW_DetailVC ()
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSDictionary *resultDic;
@property (nonatomic,strong) NSArray *titleAry;
@property (nonatomic,strong) NSArray *valueAry;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,assign) BOOL isGotJsonString;
@end

@implementation DW_DetailVC
@synthesize webHelper,fromDateStr,endDateStr,dwbh;
@synthesize curParsedData,isGotJsonString,resultDic;
@synthesize titleAry,valueAry;

#pragma mark - Get webData

-(void)requestData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"Kssj" value:fromDateStr,@"Jssj",endDateStr,@"jszdwdm",dwbh,nil];
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetJydwTwo"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

#pragma mark - View lifeCycle

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
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [dwbh release];
    [fromDateStr release];
    [endDateStr release];
    [webHelper release];
    [curParsedData release];
    [titleAry release];
    [resultDic release];
    [valueAry release];
    [super dealloc];
}

#pragma mark - NSURLConnhelper delegate

-(void)processWebData:(NSData*)webData{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);
     */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate:self];
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

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetJydwTwoResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetJydwTwoResult"])
    {
        NSArray *resultAry = [curParsedData objectFromJSONString];
        self.resultDic = [resultAry lastObject];
    }
    isGotJsonString = NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([resultDic count] > 0)
    {
        NSMutableArray *titleAryTmp = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *valueAryTmp = [NSMutableArray arrayWithCapacity:10];
        
        NSString *fwmc = [resultDic objectForKey:@"JSZDWMC"];
        [titleAryTmp addObject:@"经营单位名称："];
        [valueAryTmp addObject:fwmc];
        
        NSString *fsl = [resultDic objectForKey:@"焚烧量"];
        float fslCount = [fsl floatValue]/1000;
        fsl = [NSString stringWithFormat:@"%.3f 吨",fslCount];
        [titleAryTmp addObject:@"焚烧量："];
        [valueAryTmp addObject:fsl];
        
        NSString *whl = [resultDic objectForKey:@"物化量"];
        float whlCount = [whl floatValue]/1000;
        whl = [NSString stringWithFormat:@"%.3f 吨",whlCount];
        [titleAryTmp addObject:@"物化量："];
        [valueAryTmp addObject:whl];
        
        NSString *tml = [resultDic objectForKey:@"填埋量"];
        float tmlCount = [tml floatValue]/1000;
        tml = [NSString stringWithFormat:@"%.3f 吨",tmlCount];
        [titleAryTmp addObject:@"填埋量："];
        [valueAryTmp addObject:tml];
        
        NSString *lyl = [resultDic objectForKey:@"利用量"];
        float lylCount = [lyl floatValue]/1000;
        lyl = [NSString stringWithFormat:@"%.3f 吨",lylCount];
        [titleAryTmp addObject:@"利用量："];
        [valueAryTmp addObject:lyl];
        
        self.valueAry = valueAryTmp;
        self.titleAry = titleAryTmp;
    }
    else
    {
        self.valueAry = [NSArray array];
        self.titleAry = [NSArray array];
    }
    [dataTable reloadData];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"dw_czfs_detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.textLabel.text = [titleAry objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.detailTextLabel.text = [valueAry objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

@end
