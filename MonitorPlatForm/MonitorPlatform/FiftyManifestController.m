//
//  FiftyManifestController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "FiftyManifestController.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "WebServiceHelper.h"
#import "NumberUtil.h"
#import "GFTypeStatisticController.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation FiftyManifestController

@synthesize dataTableView,resultDataAry,curParsedData,isGotJsonString;
@synthesize dateController,popController,endDateStr,fromDateStr;
@synthesize webHelper,isLoading,widthAry,mySearchBar,entranceFlag,cszStr;

#define mainFlag 1
#define subFlag 2

-(void)requestData
{    
    NSString *param = [WebServiceHelper createParametersWithKey:@"cszdwmc" value:@"",@"csz",cszStr,@"fwlbbh",@"",@"kssj",fromDateStr,@"jssj",endDateStr,@"page",@"1",@"pagenum",@"50",nil];
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl method:@"GetCFDWFwzlTjEx" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    
    //NSLog(@"%@ %@?op=GetCFDWFwzlTj", param, strUrl);
}

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate
{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    self.title = [NSString stringWithFormat:@"按产废单位统计(%@ - %@)",fromDateStr,endDateStr];
    titleLabel.backgroundColor = CELL_HEADER_COLOR;
    titleLabel.text = [NSString stringWithFormat:@"按产废单位统计(%@ ~ %@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemAction target:self action:@selector(goBack:)];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        
        self.isLoading = NO;
        self.widthAry = [NSArray arrayWithObjects:@"0.6",@"0.2",@"0.2", nil];
        self.entranceFlag = 1;
        self.cszStr = @"";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [dataTableView release];
    [resultDataAry release];
    [curParsedData release];
    [dateController release];
    [popController release];
    [webHelper release];
    [emptyView release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //标题标签设置
    titleLabel.backgroundColor = [UIColor colorWithRed:(0x50/255.0f) green:(0x8d/255.0f) blue:(0xd0/255.0f) alpha:1.000f];
    
    //搜索栏设置
    if (entranceFlag == mainFlag)
    {
        mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
        mySearchBar.placeholder = @"请输入产废单位名称";
        mySearchBar.delegate = self;
    
        self.navigationItem.titleView = mySearchBar;
    }
    
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    
    ChooseDateRangeController *date = [[ChooseDateRangeController alloc] init];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    
    NSDate *nowDate = [NSDate date];
    //NSDate *fromDate = [NSDate dateWithTimeInterval:-90*60*60*24 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    self.fromDateStr = [NSDateUtil firstDateThisMonth];
    [dateFormatter release];
    titleLabel.text = [NSString stringWithFormat:@"按产废单位统计(%@ ~ %@)",fromDateStr,endDateStr];
    titleLabel.backgroundColor = CELL_HEADER_COLOR;
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.dataTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];

    }
    [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}


#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    
     //NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     //NSLog(@"%@",logstr);
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData] autorelease];
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

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetCFDWFwzlTjExResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetCFDWFwzlTjExResult"]) 
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{

    isLoading = YES;

    if ([resultDataAry count] != 0)
    {
        dataTableView.hidden = NO;
        if(emptyView != nil)
        {
            emptyView.hidden = YES;
        }
        
        CGFloat totalCount = 0;
        CGFloat wfTotalCount = 0;
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:20];
    
        for (NSDictionary *tmpDic in resultDataAry)
        {
            NSString *sl = [tmpDic objectForKey:@"SL"];
            float slCount = [sl floatValue];
            totalCount += slCount;
            NSString *wfsl = [tmpDic objectForKey:@"SL1"];
            float wfslCount = [wfsl floatValue];
            wfTotalCount += wfslCount;
            [tmpArray addObject:tmpDic];
        }
    
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",totalCount] forKey:@"SL"];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",wfTotalCount] forKey:@"SL1"];
        [tmpDic setObject:@"产废前50汇总" forKey:@"CSZDWMC"];
        [tmpArray addObject:tmpDic];
        self.resultDataAry = tmpArray;
    
    }
    else
    {
        if (entranceFlag == mainFlag)
        {
            dataTableView.hidden = YES;
            if(emptyView == nil)
            {
                emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.24, 350, 290)];
                emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
            }
            [self.view addSubview:emptyView];
        }
        else
        {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:2];
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:3];
            [tmpDic setObject:@"0" forKey:@"SL"];
            [tmpDic setObject:@"0" forKey:@"SL1"];
            [tmpDic setObject:self.wrymc forKey:@"CSZDWMC"];
            [tmpArray addObject:tmpDic];
            self.resultDataAry = tmpArray;
        }
    }
    [self.dataTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([resultDataAry count] > 0)
        return [resultDataAry count];
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray *aryTmp = [NSArray arrayWithObjects:
                       @" 序号  产废单位",@"总量",@"危废数量  ",
                       nil];
    
    
    UIView *view;
    CGFloat cellWidth = 768.0;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 45)];
    
    CGFloat width[3] = {cellWidth*0.6,cellWidth*0.2,cellWidth*0.2};
    CGRect tRect = CGRectMake(0, 0, width[0], 45.0);
    
    for (int i =0; i < [aryTmp count]; i++) {
        tRect.size.width = width[i];
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:18];
        if (i == 0)
            label.textAlignment = UITextAlignmentLeft;
        else 
            label.textAlignment = UITextAlignmentCenter;

        tRect.origin.x += width[i];
        
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor =  CELL_HEADER_COLOR;
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (!isLoading) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"unload_cell"] autorelease];
        
        cell.textLabel.text = @"";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    if ([resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    else{
        
        NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
        NSString *xh = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        if (indexPath.row == [resultDataAry count]-1)
            xh = @" ";
        
        NSString *num = [dicTmp objectForKey:@"SL"];
        num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
        NSString *wfnum = [dicTmp objectForKey:@"SL1"];
        wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];
        
        NSString *name = [NSString stringWithFormat:@"  %@  %@",xh,[dicTmp objectForKey:@"CSZDWMC"]];
        NSArray *valueArr = [NSArray arrayWithObjects:name,num,wfnum, nil];
       // UITableViewCell *cell = [UITableViewCell makeTDCellForTableView:tableView valueArray:valueArr statisticNum:num cellHeight:45 andWidths:widthAry];
        UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueArr andWidths:widthAry andHeight:55 andIdentifier:@"FiftyManifestId" firstAlign:NSTextAlignmentLeft];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([resultDataAry count] == 0 || indexPath.row == [resultDataAry count]-1)
        return;
    
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    GFTypeStatisticController *childVC = [[GFTypeStatisticController alloc] initWithNibName:@"GFTypeStatisticController" bundle:nil];
    childVC.nEntrance = 2;
    childVC.dwmc = [dicTmp objectForKey:@"CSZDWMC"];
    childVC.fromDateStr = self.fromDateStr;
    childVC.endDateStr = self.endDateStr;
    
    [self.navigationController pushViewController:childVC animated:YES];
    [childVC release];
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.cszStr = mySearchBar.text;
    [self requestData];
}

@end
