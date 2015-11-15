//
//  ReportListViewController.m
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ReportListViewController.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "ReportItem.h"
#import "ReportDetailViewController.h"
#import "UITableViewCell+Custom.h"

@interface ReportListViewController ()

@property (nonatomic, strong) NSMutableString *resultJsonStr;
@property (nonatomic, strong) NSString *currentElementName;

@end

@implementation ReportListViewController

@synthesize wrybh, wrymc;
@synthesize resultJsonStr, currentElementName;

- (void)dealloc
{
    self.wrybh = nil;
    self.wrymc = nil;
    self.resultJsonStr = nil;
    [reportListTableView release];
    [resultDataArray release];
    [webservice release];
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
    self.title = [NSString stringWithFormat:@"%@-废水监测报告",wrymc];
    [self makeView];
    [self requestDataWithName:wrymc andWithCode:wrybh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View

- (void)viewWillDisappear:(BOOL)animated
{
    [webservice cancel];
    [super viewWillDisappear:animated];
}

- (void)makeView
{
    reportListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768 , 1024-20-44) style:UITableViewStylePlain];
    reportListTableView.delegate = self;
    reportListTableView.dataSource = self;
    [self.view addSubview:reportListTableView];
}

#pragma mark - Network Handler

- (void)requestDataWithName:(NSString*)aName andWithCode:(NSString*)aCode
{
    //读取配置文件 ip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.oaServiceIp = [defaults stringForKey:@"oaip_prefer"];
    
    //拼接请求URL地址
    NSString *URL = [NSString stringWithFormat:RECORD_URL, appDelegate.xxcxServiceIP];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *StartTime = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*60*60*365*5]];//5年
     NSString *EndTime = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    //准备SOAP参数
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh, @"wrymc", wrymc, @"StartTime", StartTime, @"EndTime", EndTime, nil];
    
	webservice = [[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"RetrieveMonitoringReport"
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param
                                                                 delegate:self];
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
     else
     {
         NSString *msg = @"没有相关数据。";
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alert show];
         [alert release];
         return;
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
	if([elementName isEqualToString:@"RetrieveMonitoringReportResult"])
    {
        resultJsonStr = [[NSMutableString alloc] init];
        currentElementName = elementName;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElementName isEqualToString:@"RetrieveMonitoringReportResult"])
    {
        [resultJsonStr appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"RetrieveMonitoringReportResponse"])
    {
        //NSLog(@"%@", resultJsonStr);
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self parseJSON:resultJsonStr];
}

#pragma mark - Parse JSON

- (void)sortData
{
    NSArray *tmpArray = [resultDataArray sortedArrayUsingSelector:@selector(compare:)];
    [resultDataArray removeAllObjects];
    [resultDataArray addObjectsFromArray:tmpArray];
    [reportListTableView reloadData];
}

- (void)parseJSON:(NSString*)str
{
    if([str isEqualToString:@""] || str == nil)
    {
        /*NSString *msg = @"没有相关数据。";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];*/
        [reportListTableView setHidden:YES];
        UIImageView *emptyBackgroud = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
        emptyBackgroud.image = [UIImage imageNamed:@"nodata.png"];
        [self.view addSubview:emptyBackgroud];
        [emptyBackgroud release];
        return;
    }
    NSArray *jsonArray = [str objectFromJSONString];
    resultDataArray = [[NSMutableArray alloc] init];
    for (int i= [jsonArray count]-1; i>=0; i--) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
        ReportItem *item = [[ReportItem alloc] init];
        item.code = [dict objectForKey:@"报告编号"];
        item.result = [dict objectForKey:@"监测结论"];
        item.pubDate = [dict objectForKey:@"报告时间"];
        [resultDataArray addObject:item];
        [item release];
    }
    [self sortData];
}

#pragma mark - UITableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportItem *item = [resultDataArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"报告编号：%@",item.code];
    NSString *timeStr = item.pubDate;
    if([timeStr length] > 16)timeStr = [timeStr substringToIndex:16];
    cell.detailTextLabel.text = item.pubDate;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportDetailViewController *detail = [[ReportDetailViewController alloc] initWithNibName:@"ReportDetailViewController" bundle:nil];
    ReportItem *aItem = [resultDataArray objectAtIndex:indexPath.row];
    detail.ypjbh = aItem.code;
    detail.wrymc = wrymc;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


@end
