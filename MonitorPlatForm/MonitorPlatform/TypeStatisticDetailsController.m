//
//  TypeStatisticDetailsController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TypeStatisticDetailsController.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "NumberUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation TypeStatisticDetailsController
@synthesize dataTableView,fromDateStr,endDateStr,fwbh,fwzlmc,webHelper;
@synthesize resultDataAry,curParsedData,isGotJsonString,bLoaded,widthAry;
@synthesize jyDataAry,dataType,currentMethod;

#define cf_data 0
#define jy_data 1

#pragma mark - Private methods

-(void)requestData
{
    if (dataType == cf_data)
    {
        NSString *param = [WebServiceHelper createParametersWithKey:@"cszdwmc" value:@"",@"csz",@"",@"fwlbbh",fwbh,@"kssj",fromDateStr,@"jssj",endDateStr,@"page",@"1",@"pagenum",@"50",nil];
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
        NSString *param = [WebServiceHelper createParametersWithKey:@"fwlbbh" value:fwbh,@"jszdwbh",@"",@"kssj",fromDateStr,@"jssj",endDateStr,nil];
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

-(void)segctrlClicked:(id)sender{
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    dataType = segCtrl.selectedSegmentIndex;
    if(segCtrl.selectedSegmentIndex == 0){
        if(resultDataAry && [resultDataAry count] > 0){
            [self.dataTableView reloadData];
            return;
        }
        
    }
    else {
        if(jyDataAry && [jyDataAry count] > 0){
            [self.dataTableView reloadData];
            return;
        }
    }
    
    [self requestData];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bLoaded = NO;
        self.widthAry = [NSArray arrayWithObjects:@"0.6",@"0.2",@"0.2", nil];
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
    //标题标签设置
    titleLabel.backgroundColor = [UIColor colorWithRed:(0x50/255.0f) green:(0x8d/255.0f) blue:(0xd0/255.0f) alpha:1.000f];
    titleLabel.text = fwzlmc;
    //导航栏分段按钮设置
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"  产废单位  ", @"  经营单位  ",nil]];
    
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segctrlClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segCtrl;
    segCtrl.selectedSegmentIndex = 0;
    [segCtrl release];
    //获取默认数据
    [segCtrl setSelectedSegmentIndex:0];
    dataType = 0;
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
        if (dataType == cf_data)
            self.resultDataAry = [curParsedData objectFromJSONString];
        else
            self.jyDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    bLoaded = YES;
    
    CGFloat totalCount = 0;
    CGFloat wftotalCount = 0;
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:20];
   
    NSArray *dataAry = nil;
    NSString *slKey = nil;
    NSString *nameKey = nil;
     NSString *wfslKey = nil;
    
    if (dataType == cf_data)
    {
        slKey = @"SL";
         wfslKey = @"SL1";
        nameKey = @"CSZDWMC";
        dataAry = resultDataAry;
    }
    else
    {
        slKey = @"JSZQRSL";
         wfslKey = @"JSZQRSL1";
        nameKey = @"JSZDWMC";
        dataAry = jyDataAry;
    }
    
    for (NSDictionary *tmpDic in dataAry)
    {
        NSString *sl = [tmpDic objectForKey:slKey];
        float slCount = [sl floatValue];
        totalCount += slCount;
        
        NSString *wfsl = [tmpDic objectForKey:wfslKey];
        float wfslCount = [wfsl floatValue];
        wftotalCount += wfslCount;
        
        [tmpArray addObject:tmpDic];
    }
    
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [tmpDic setObject:[NSString stringWithFormat:@"%.2f",totalCount] forKey:slKey];
    [tmpDic setObject:@"汇总" forKey:nameKey];
     [tmpDic setObject:[NSString stringWithFormat:@"%.2f",wftotalCount] forKey:wfslKey];
    [tmpArray addObject:tmpDic];
    
    if (dataType == cf_data)
        self.resultDataAry = tmpArray;
    else
        self.jyDataAry = tmpArray ;
    
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
    if (dataType == cf_data)
    {
        if ([resultDataAry count] > 0)
            return [resultDataAry count];
        else
            return 1;
    }
    else
    {
        if ([jyDataAry count] > 0)
            return [jyDataAry count];
        else
            return 1;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = nil;
    
    if (dataType == cf_data)
        aryTmp = [NSArray arrayWithObjects:@" 序号  产废单位名称",@"数量",@"危废数量",nil];
    else
        aryTmp = [NSArray arrayWithObjects:@" 序号  经营单位名称",@"转移量",@"危废数量",nil];
    
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
        else if (i == 3)
            label.textAlignment = UITextAlignmentRight;
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
    
    if (dataType == cf_data &&[resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (dataType == jy_data &&[jyDataAry count] == 0)
    {
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
        NSArray *dataAry = nil;
        NSDictionary *dicTmp = nil;
        
        if (dataType == cf_data)
        {
            dicTmp = [resultDataAry objectAtIndex:indexPath.row];
            num = [dicTmp objectForKey:@"SL"];
            num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
            wfnum = [dicTmp objectForKey:@"SL1"];
            wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];
            name = [dicTmp objectForKey:@"CSZDWMC"];
            dataAry = resultDataAry;
        }
        
        else
        {
            dicTmp = [jyDataAry objectAtIndex:indexPath.row];
            num = [dicTmp objectForKey:@"JSZQRSL"];
            num = [NSString stringWithFormat:@"%.2f 吨",[num floatValue]];
            wfnum = [dicTmp objectForKey:@"JSZQRSL1"];
            wfnum = [NSString stringWithFormat:@"%.2f 吨",[wfnum floatValue]];
            name = [dicTmp objectForKey:@"JSZDWMC"];
            dataAry = jyDataAry;
        }
        
        NSString *xh = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        if (indexPath.row == [dataAry count]-1)
            xh = @" ";
        name = [NSString stringWithFormat:@"  %@  %@",xh,name];
        NSArray *valueArr = [NSArray arrayWithObjects:name,num,wfnum, nil];
        
        UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueArr andWidths:widthAry andHeight:55 andIdentifier:@"TypeStatisticDetail" firstAlign:NSTextAlignmentLeft ];
        
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        return cell;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
