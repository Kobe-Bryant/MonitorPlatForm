//
//  GFczfsCountVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "GFczfsCountVC.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "NSDateUtil.h"
#import "TDBadgedCell.h"
#import "UITableViewCell+Custom.h"
#import "ZL_DetailVC.h"
#import "DW_DetailVC.h"

extern MPAppDelegate *g_appDelegate;

@interface GFczfsCountVC ()
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) ChooseDateRangeController *dateController;

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;
@property (nonatomic,copy) NSString *methodStr;
@property (nonatomic,strong) NSArray *kindArray;
@property (nonatomic,strong) NSArray *companyArray;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSArray *widthAry;

@property (nonatomic,assign) int dataType;

@end

@implementation GFczfsCountVC
@synthesize popController,dateController,fromDateStr,endDateStr;
@synthesize kindArray,companyArray,webHelper,curParsedData,widthAry;
@synthesize isGotJsonString,dataType,methodStr;


#pragma mark - Private methods

-(void)requestData
{
    if (dataType == 0)
        self.methodStr = @"GetCzfsOneEx";
    else
        self.methodStr = @"GetJydwOneEx";
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"Kssj" value:fromDateStr,@"Jssj",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:methodStr
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    //NSLog(@"%@?op=%@ %@", strUrl, methodStr, param);
    [webHelper runAndShowWaitingView:self.view];
}

-(void)chooseDateRange:(id)sender{
    
    [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)segctrlClicked:(id)sender{
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    self.dataType = segCtrl.selectedSegmentIndex;
    if(segCtrl.selectedSegmentIndex == 0){
        titleLabel.text = [NSString stringWithFormat:@"按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.title = [NSString stringWithFormat:@"按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.widthAry = [NSArray arrayWithObjects:@"0.10",@"0.25",@"0.13",@"0.13",@"0.13",@"0.13",@"0.13", nil];
        
    }
    else {
        titleLabel.text = [NSString stringWithFormat:@"按经营单位统计(%@ - %@)",fromDateStr,endDateStr];
        self.title = [NSString stringWithFormat:@"按经营单位统计(%@ - %@)",fromDateStr,endDateStr];
        self.widthAry = [NSArray arrayWithObjects:@"0.35",@"0.13",@"0.13",@"0.13",@"0.13",@"0.13",nil];
    }
    
    [self requestData];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //标题label设置
    titleLabel.backgroundColor = [UIColor colorWithRed:(0x50/255.0f) green:(0x8d/255.0f) blue:(0xd0/255.0f) alpha:1.000f];
    
    //导航栏分段按钮设置
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"  废物种类  ", @"  经营单位  ",nil]];
    
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segctrlClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segCtrl;
    segCtrl.selectedSegmentIndex = 0;
    self.dataType = 0;
    [segCtrl release];
    
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
    titleLabel.text = [NSString stringWithFormat:@"按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
    self.title = [NSString stringWithFormat:@"按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
    titleLabel.backgroundColor = CELL_HEADER_COLOR;
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    
    if (popController)
        [popController dismissPopoverAnimated:YES];
    
    [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [popController release];
    [dateController release];
    [fromDateStr release];
    [endDateStr release];
    [kindArray release];
    [companyArray release];
    [webHelper release];
    [curParsedData release];
    [widthAry release];
    [super dealloc];
}

#pragma mark - Choose date range delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate
{
    [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    if (dataType == 0)
    {
        titleLabel.text = [NSString stringWithFormat:@"废物种类按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.title = [NSString stringWithFormat:@"废物种类按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.kindArray = nil;
    }
    
    else
    {
        titleLabel.text = [NSString stringWithFormat:@"经营单位按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.title = [NSString stringWithFormat:@"经营单位按处置方式统计(%@ - %@)",fromDateStr,endDateStr];
        self.companyArray = nil;
    }
    
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

#pragma mark - NSURLConnhelper delegate

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

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result",methodStr]])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:[NSString stringWithFormat:@"%@Result",methodStr]])
    {
        if (dataType == 0)
            self.kindArray = [curParsedData objectFromJSONString];
        else
            self.companyArray = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSArray *dealAry = nil;
    if (dataType == 0)
        dealAry = kindArray;
    else
        dealAry = companyArray;
    
    if ([dealAry count] != 0)
    {
        float zlTotal = 0;
        float tmlTotal = 0,fslTotal = 0,whlTotal = 0,lylTotal = 0; 
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:20];
        
        for (NSDictionary *tmpDic in dealAry)
        {
            NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
            //总量
            NSString *zl = [tmpDic objectForKey:@"总量"];
            float zlCount = [zl floatValue];
            zlTotal += zlCount;
            //@"焚烧量"
            NSString *fsl = [tmpDic objectForKey:@"焚烧量"];
            float fslCount = [fsl floatValue];
            fslTotal += fslCount;
            //物化量
            NSString *whl = [tmpDic objectForKey:@"物化量"];
            float whlCount = [whl floatValue];
            whlTotal += whlCount;
            //填埋量
            NSString *tml = [tmpDic objectForKey:@"填埋量"];
            float tmlCount = [tml floatValue];
            tmlTotal += tmlCount;
            //利用量
            NSString *lyl = [tmpDic objectForKey:@"利用量"];
            float lylCount = [lyl floatValue];
            lylTotal += lylCount;
            
            zl = [NSString stringWithFormat:@"%.2f",zlCount/1000];
            fsl = [NSString stringWithFormat:@"%.2f",fslCount/1000];
            whl = [NSString stringWithFormat:@"%.2f",whlCount/1000];
            tml = [NSString stringWithFormat:@"%.2f",tmlCount/1000];
            lyl = [NSString stringWithFormat:@"%.2f",lylCount/1000];
            
            [tmpDictionary setObject:zl forKey:@"总量"];
            [tmpDictionary setObject:fsl  forKey:@"焚烧量"];
            [tmpDictionary setObject:whl  forKey:@"物化量"];
            [tmpDictionary setObject:tml  forKey:@"填埋量"];
            [tmpDictionary setObject:lyl  forKey:@"利用量"];
            
            if (dataType == 0)
            {
                [tmpDictionary setObject:[tmpDic objectForKey:@"FWMC"]  forKey:@"FWMC"];
                [tmpDictionary setObject:[tmpDic objectForKey:@"FWLBBH"]  forKey:@"FWLBBH"];
            }
            else
            {
                [tmpDictionary setObject:[tmpDic objectForKey:@"JSZDWMC"] forKey:@"JSZDWMC"];
                [tmpDictionary setObject:[tmpDic objectForKey:@"JSZDWDM"]  forKey:@"JSZDWDM"];
            }
            [tmpArray addObject:tmpDictionary];
        }
        
        NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
        NSString *zl = [NSString stringWithFormat:@"%.2f",zlTotal/1000];
        NSString *fsl = [NSString stringWithFormat:@"%.2f",fslTotal/1000];
        NSString *whl = [NSString stringWithFormat:@"%.2f",whlTotal/1000];
        NSString *tml = [NSString stringWithFormat:@"%.2f",tmlTotal/1000];
        NSString *lyl = [NSString stringWithFormat:@"%.2f",lylTotal/1000];
        [tmpDictionary setObject:zl  forKey:@"总量"];
        [tmpDictionary setObject:fsl  forKey:@"焚烧量"];
        [tmpDictionary setObject:whl  forKey:@"物化量"];
        [tmpDictionary setObject:tml  forKey:@"填埋量"];
        [tmpDictionary setObject:lyl  forKey:@"利用量"];
        if (dataType == 0)
        {
            [tmpDictionary setObject:@"汇总" forKey:@"FWMC"];
            [tmpDictionary setObject:@"--" forKey:@"FWLBBH"];
        }
        else
        {
            [tmpDictionary setObject:@"汇总" forKey:@"JSZDWMC"];
            [tmpDictionary setObject:@"999" forKey:@"JSZDWDM"];
        }
        
        [tmpArray addObject:tmpDictionary];
        
        if (dataType == 0)
        {
            self.widthAry = [NSArray arrayWithObjects:@"0.10",@"0.25",@"0.13",@"0.13",@"0.13",@"0.13",@"0.13",nil];
            self.kindArray = tmpArray;
        }
        else
        {
           self.widthAry = [NSArray arrayWithObjects:@"0.35",@"0.13",@"0.13",@"0.13",@"0.13",@"0.13",nil];
            self.companyArray = tmpArray;
        }
    }
    
    [dataTableView reloadData];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataType == 0)
        return [kindArray count];
    else
        return [companyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 85.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *aryTmp = nil;
    CGFloat width[7];
    CGFloat cellWidth = 768.0;
    if (dataType == 0)
        aryTmp = [NSArray arrayWithObjects:@"废物编号",@"废物名称",@"总量(吨)",@"焚烧量(吨)",@"物化量(吨)",@"填埋量(吨)",@"利用量(吨)", nil];
    else
        aryTmp = [NSArray arrayWithObjects:@"经营单位",@"总量(吨)",@"焚烧量(吨)",@"物化量(吨)",@"填埋量(吨)",@"利用量(吨)", nil];
    for(int i = 0; i < [aryTmp count]; i++){
        width[i] = cellWidth * [[widthAry objectAtIndex:i] floatValue];
    }
    UIView *view;
    
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 45)];
    
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSArray *showDataAry = nil;
    
    if (dataType == 0)
        showDataAry = kindArray;
    else
        showDataAry = companyArray;
    
    if ([showDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSDictionary *tmpDic = [showDataAry objectAtIndex:indexPath.row];
        NSArray *valueAry = nil;
        if (dataType == 0)
        {
            NSString *mc = [tmpDic objectForKey:@"FWMC"];
            NSString *bh = [tmpDic objectForKey:@"FWLBBH"];
            NSString *zl = [tmpDic objectForKey:@"总量"];
            NSString *fsl = [tmpDic objectForKey:@"焚烧量"];
            NSString *whl = [tmpDic objectForKey:@"物化量"];
            NSString *tml = [tmpDic objectForKey:@"填埋量"];
            NSString *lyl = [tmpDic objectForKey:@"利用量"];
            valueAry = [NSArray arrayWithObjects:bh,mc,zl,fsl,whl,tml,lyl, nil];
        }
        else
        {
            NSString *mc = [tmpDic objectForKey:@"JSZDWMC"];
            NSString *zl = [tmpDic objectForKey:@"总量"];
            NSString *fsl = [tmpDic objectForKey:@"焚烧量"];
            NSString *whl = [tmpDic objectForKey:@"物化量"];
            NSString *tml = [tmpDic objectForKey:@"填埋量"];
            NSString *lyl = [tmpDic objectForKey:@"利用量"];
            valueAry = [NSArray arrayWithObjects:mc,zl,fsl,whl,tml,lyl,  nil];
        }
        
        cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueAry andWidths:widthAry andHeight:55 andIdentifier:[NSString stringWithFormat:@"czfs_main_cell%d",dataType]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSInteger row = [indexPath row];
    if (dataType == 0)
    {
        if (row == [kindArray count] - 1)
            return;
        else
        {
            NSDictionary *tmpDic = [kindArray objectAtIndex:row];
            ZL_DetailVC *childVC = [[ZL_DetailVC alloc] initWithNibName:@"ZL_DetailVC" bundle:nil];
            childVC.fromDateStr = fromDateStr;
            childVC.endDateStr = endDateStr;
            childVC.fwlbbh = [tmpDic objectForKey:@"FWLBBH"];
            childVC.title = [tmpDic objectForKey:@"FWMC"];
            [self.navigationController pushViewController:childVC animated:YES];
            [childVC release];
        }
    }
    else
    {
        if (row == [companyArray count] - 1)
            return;
        else
        {
            NSDictionary *tmpDic = [companyArray objectAtIndex:row];
            DW_DetailVC *childVC = [[DW_DetailVC alloc] initWithNibName:@"DW_DetailVC" bundle:nil];
            childVC.dwbh = [tmpDic objectForKey:@"JSZDWDM"];
            childVC.title = [tmpDic objectForKey:@"JSZDWMC"];
            childVC.fromDateStr = fromDateStr;
            childVC.endDateStr = endDateStr;
            
            [self.navigationController pushViewController:childVC animated:YES];
            [childVC release];
        }
    }*/
}

@end
