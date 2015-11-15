//
//  PwsfZtqkDataModel.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PwsfZtqkDataModel.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation PwsfZtqkDataModel
@synthesize delegate;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end
{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    
    isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"startDate" value:from,@"endDate",end,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetPWSF_SQSTJ"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [self.webHelper runAndShowWaitingView:parentController.view];
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);*/
    
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
    if ([elementName isEqualToString:@"GetPWSF_SQSTJResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetPWSF_SQSTJResult"])
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
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
    NSArray *aryTmp = [NSArray arrayWithObjects:@"排污类型",
                       @"排放量（m³或分贝）",@"应缴费用（元）",@"实缴费用（元）",
                       nil];
    
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 745, 45)];
    
    CGFloat width = 745.0/[aryTmp count];
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
    view.backgroundColor = CELL_HEADER_COLOR;
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *identifierStr = @"Cell_pwsf_sqs";
    
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    
    NSArray *aryTmp = [NSArray arrayWithObjects:
                       [dicTmp objectForKey:@"排污类型"],
                       [dicTmp objectForKey:@"排放量"],
                       [dicTmp objectForKey:@"应缴费用"],
                       [dicTmp objectForKey:@"实缴费用"],
                       nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView
                                      withTexts:aryTmp andHeight:60 andWidth:745 andIdentifier:identifierStr];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2)
        [delegate returnRequestType:indexPath.row];
}

@end
