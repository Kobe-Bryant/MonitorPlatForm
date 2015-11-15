//
//  GFTypeStatisticController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "GFTypeStatisticController.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "WebServiceHelper.h"
#import "TypeStatisticDetailsController.h"
#import "NumberUtil.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation GFTypeStatisticController
@synthesize dataTableView,popController,dateController;
@synthesize fromDateStr,endDateStr,resultDataAry,widthAry;
@synthesize curParsedData,isGotJsonString,bLoaded,webHelper;
@synthesize nEntrance,dwmc,currentMethod,jszbh;


#define main_Entrance 1
#define cfdw_Entrance 2
#define jydw_Entrance 3

#pragma mark - Private methods

-(void)requestData
{
    if (nEntrance == main_Entrance)
    {
        NSString *param = [WebServiceHelper createParametersWithKey:@"StartTime" value:fromDateStr,
                       @"EndTime",endDateStr, nil];
        NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
        self.currentMethod = @"GetFwzltjEx";
        self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                                 method:currentMethod 
                                                              nameSpace:@"http://tempuri.org/" 
                                                             parameters:param 
                                                               delegate:self] autorelease];
        [webHelper runAndShowWaitingView:self.view];
    }
    else if (nEntrance == cfdw_Entrance)
    {
        NSString *param = [WebServiceHelper createParametersWithKey:@"cszdwmc" value:dwmc,@"csz",@"",@"fwlbbh",@"",@"kssj",fromDateStr,@"jssj",endDateStr,@"page",@"1",@"pagenum",@"50",nil];
        NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
        self.currentMethod = @"GetCFDWFwzlTjEx";
        self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl
                                                         method:currentMethod
                                                      nameSpace:@"http://tempuri.org/"
                                                     parameters:param
                                                       delegate:self] autorelease];
        [webHelper runAndShowWaitingView:self.view];
    }
    else
    {
        NSString *param = [WebServiceHelper createParametersWithKey:@"fwlbbh" value:@"",@"jszdwbh",jszbh,@"kssj",fromDateStr,@"jssj",endDateStr,nil];
        NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
        self.currentMethod = @"GetJszFwzlTjEx";
        self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                        method:currentMethod
                                                     nameSpace:@"http://tempuri.org/"
                                                    parameters:param
                                                      delegate:self] autorelease];
        [webHelper runAndShowWaitingView:self.view];
    }
}

-(void)chooseDateRange:(id)sender{

    [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.bLoaded = NO;
        self.nEntrance = main_Entrance;
        self.widthAry = [NSArray arrayWithObjects:@"0.1",@"0.3",@"0.2",@"0.2",@"0.2", nil];
    }
    return self;
}

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
    
    
    
    if (nEntrance == main_Entrance)
    {
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
        self.title = [NSString stringWithFormat:@"按废物种类统计(%@ ~ %@)",fromDateStr,endDateStr];
    }
    else
        self.title = dwmc;
    

    [self requestData];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    if(popController)
      [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:YES];
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

#pragma mark - Choose Date Range Delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    self.title = [NSString stringWithFormat:@"废物种类统计(%@ - %@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
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
    NSString *resultName = [NSString stringWithFormat:@"%@Result",currentMethod];
    if ([elementName isEqualToString:resultName])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *resultName = [NSString stringWithFormat:@"%@Result",currentMethod];
    if (isGotJsonString && [elementName isEqualToString:resultName]) 
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    bLoaded = YES;
    if ([resultDataAry count] != 0)
    {
        CGFloat totalCount = 0;
        CGFloat wfTotalCount = 0;
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:20];
    
        NSString *slKey;
        NSString *nameKey;
        NSString *bhKey;
        NSString *wfslKey;
        
        if (nEntrance == main_Entrance)
        {
            slKey = @"数量";
            nameKey = @"废物名称";
            bhKey = @"废物类别编号";
            wfslKey = @"数量1";
        }
        else if (nEntrance == cfdw_Entrance)
        {
            slKey = @"SL";
            nameKey = @"DMNR";
            bhKey = @"FWLBBH";
            wfslKey = @"SL1";
        }
        else
        {
            slKey = @"JSZQRSL";
            nameKey = @"DMNR";
            bhKey = @"FWLBBH";
            wfslKey = @"JSZQRSL1";
        }
    
        for (NSDictionary *tmpDic in resultDataAry)
        {
            NSString *sl = [tmpDic objectForKey:slKey];
            float slCount = [sl floatValue];
            totalCount += slCount;
            wfTotalCount += [[tmpDic objectForKey:wfslKey] floatValue];
            [tmpArray addObject:tmpDic];
        }
    
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",totalCount] forKey:slKey];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",wfTotalCount] forKey:wfslKey];
        [tmpDic setObject:@"汇总" forKey:nameKey];
        [tmpDic setObject:@" " forKey:bhKey];
    
        [tmpArray addObject:tmpDic];
        self.resultDataAry = tmpArray;
    }
    [self.dataTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"序号",
                       @"废物名称",@"废物编号",@"总量",@"危废数量",
                       nil];
    
    UIView *view;
    CGFloat cellWidth = 748.0;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 45)];
    
    CGFloat width[5] = {cellWidth*0.1,cellWidth*0.3,cellWidth*0.2,cellWidth*0.2,cellWidth*0.2};
    CGRect tRect = CGRectMake(0, 0, width[0], 45);
    
    for (int i =0; i < [aryTmp count]; i++) {
        tRect.size.width = width[i];
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        label.backgroundColor = [UIColor clearColor];
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:20];
       // if (i == 1)
       //     label.textAlignment = UITextAlignmentLeft;
      //  else if (i == 3)
            label.textAlignment = UITextAlignmentRight;
       // else
        //    label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width[i];
        
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR;
    return [view autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([resultDataAry count] > 0)
        return [resultDataAry count];
    else
        return 1;
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
    
    if (!bLoaded) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"unload_cell"] autorelease];
        
        cell.textLabel.text = @"";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
        NSString *num = nil;
        NSString *wfnum = nil;
        NSString *name = nil;
        NSString *typeBH = nil;
        NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
        
        if (nEntrance == main_Entrance)
        {
            num = [dicTmp objectForKey:@"数量"];
            num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
            
            name = [dicTmp objectForKey:@"废物名称"];
            typeBH = [dicTmp objectForKey:@"废物类别编号"];
            wfnum = [dicTmp objectForKey:@"数量1"];
            wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];
            
        }
        else if (nEntrance == cfdw_Entrance)
        {
            num = [dicTmp objectForKey:@"SL"];
            num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
            
            name = [dicTmp objectForKey:@"DMNR"];
            typeBH = [dicTmp objectForKey:@"FWLBBH"];
            wfnum = [dicTmp objectForKey:@"SL1"];
            wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];

        }
        else
        {
            num = [dicTmp objectForKey:@"JSZQRSL"];
            num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
            
            name = [dicTmp objectForKey:@"DMNR"];
            typeBH = [dicTmp objectForKey:@"FWLBBH"];
            wfnum = [dicTmp objectForKey:@"JSZQRSL1"];
            wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];

        }
       
        NSString *xh = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        if (indexPath.row == [resultDataAry count] - 1)
        {
            xh = @" ";
        }
        
        
        NSArray *valueArr = [NSArray arrayWithObjects:xh,name,typeBH,num,wfnum, nil];
        
        UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueArr andWidths:widthAry andHeight:55 andIdentifier:@"GFTypeIdentity"];
                                 
      //  UITableViewCell *cell = [UITableViewCell makeTDCellForTableView:tableView valueArray:valueArr statisticNum:num cellHeight:45 andWidths:widthAry];
        
        if (nEntrance == main_Entrance)
        {
            if (indexPath.row != [resultDataAry count] - 1){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        else
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([resultDataAry count] == 0 || indexPath.row == [resultDataAry count] - 1)
        return;
    
    else if (nEntrance == main_Entrance)
    {
        NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    
        TypeStatisticDetailsController *childView = [[TypeStatisticDetailsController alloc] initWithNibName:@"TypeStatisticDetailsController" bundle:nil];
        [childView setFwbh:[dicTmp objectForKey:@"废物类别编号"]];
        [childView setFromDateStr:self.fromDateStr];
        [childView setEndDateStr:self.endDateStr];
        [childView setFwzlmc:[dicTmp objectForKey:@"废物名称"]];
        
        [self.navigationController pushViewController:childView animated:YES];
        [childView release];
    }
}


@end
