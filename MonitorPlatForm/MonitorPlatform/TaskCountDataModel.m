//
//  TaskCountDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TaskCountDataModel.h"
#import "UITableViewCell+Custom.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation TaskCountDataModel
@synthesize webHelper;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID{

    displayTableView.delegate = self;
    displayTableView.dataSource = self;
  //  if(isDataRequested){
   //     [displayTableView reloadData];
   //     return;
   // }
    
    self.fromDate = from;
    self.endDate = end;
    
    isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"pLawTypeID"
                        value:@"410",@"StartDate",from,
                       @"EndDate",end,@"orgid",@"440301",@"strDept",depID,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    
    if (webHelper) {
        [webHelper cancel];
        
    }
    
     self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                        method:@"TaskCount_New_Ex"
                                                     nameSpace:@"http://tempuri.org/"
                                                    parameters:param
                                                      delegate:self] autorelease];
    
    [webHelper runAndShowWaitingView:parentController.view];
    
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
    if ([elementName isEqualToString:@"TaskCount_New_ExResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"TaskCount_New_ExResult"]) 
    {
       // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        /*if(self.resultDataAry)
        {
            [self.resultDataAry removeAllObjects];
        }
        [self.resultDataAry addObjectsFromArray:[curParsedData objectFromJSONString]];*/
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = NO;
    [self.displayTableView reloadData];
    [self.displayTableView setHidden:NO];
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
 //   if ([resultDataAry count] > 0)
        return [resultDataAry count];
 //   else
  //      return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"部门名称",
                       @"执法人员",@"任务总数",@"正常完成数",
                      @"正在办理", @"超时完成数",@"超时未完成数",
                       nil];

    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 739, 45)];

    CGFloat width = 739.0/[aryTmp count];
    CGRect tRect = CGRectMake(0, 5, width, 33);
        
    for (int i =0; i < [aryTmp count]; i++) {
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width;
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR2;
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *identifierStr = nil;
    
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    NSString *showBMMC = [dicTmp objectForKey:@"部门名称"];
    /*
    if ([lastBMMC isEqualToString:[dicTmp objectForKey:@"部门名称"]]) {
        showBMMC = @"";
        identifierStr = @"Hide_countCell";
    }else{
        lastBMMC = showBMMC = [dicTmp objectForKey:@"部门名称"];
        identifierStr = @"Show_countCell";
    }*/
    if (indexPath.row == 0)
        identifierStr = @"Show_countCell";
    else
    {
        NSDictionary *lastDicTmp = [resultDataAry objectAtIndex:indexPath.row-1];
        if ([showBMMC isEqualToString:[lastDicTmp objectForKey:@"部门名称"]])
        {
            showBMMC = @"";
            identifierStr = @"Hide_countCell";
        }
        else
            identifierStr = @"Show_countCell";
    }
    
    NSArray *aryTmp = [NSArray arrayWithObjects:showBMMC,
                       [dicTmp objectForKey:@"执法人员"],
                       [dicTmp objectForKey:@"任务总数"],
                       [dicTmp objectForKey:@"已完成数"],
                       [dicTmp objectForKey:@"正在办理"],
                       [dicTmp objectForKey: @"超时完成数"],
                       [dicTmp objectForKey:@"超时未完成数"],
                       nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView
                                      withTexts:aryTmp andHeight:60 andWidth:739 andIdentifier:identifierStr];
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = SELECT_UICOLOR;
    cell.selectedBackgroundView = bgview;
    [bgview release];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSDictionary *tmpDic = [resultDataAry objectAtIndex:row];
    
    int uncompleted = [[tmpDic objectForKey:@"超时未完成数"] intValue];
    
    if (uncompleted == 0)
        return;
    XzcfUndealVC *childVC = [[XzcfUndealVC alloc] initWithNibName:@"XzcfUndealVC" bundle:nil];
    childVC.fromStr = _fromDate;
    childVC.endStr = _endDate;
    childVC.type = 1;
    childVC.yhid = [tmpDic objectForKey:@"执法人员"];
    [parentController.navigationController pushViewController:childVC animated:YES];
    [childVC release];

}

@end