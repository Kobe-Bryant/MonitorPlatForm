//
//  TaskCountDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TaskCountZTQKDataModel.h"
#import "UITableViewCell+Custom.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "ServiceUrlString.h"
#import "NSDateUtil.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

extern MPAppDelegate *g_appDelegate;
@implementation TaskCountZTQKDataModel
@synthesize delegate,requetStatus,allDataAry;
@synthesize fromDate,endDate,HUD;
@synthesize webHelper,deptID;

#define httpStatus 1
#define soapStatus 2

-(void)dealloc
{
    [allDataAry release];
    [fromDate release];
    [endDate release];
    [HUD release];
    [super dealloc];
}

-(void)refreshTableView
{

    
    if ([allDataAry count] > 0)
    {
        int totalCount = 0;
        int outCount = 0;
        int completedCount = 0;
        int uncompletedCount = 0;
        int completingCount = 0;
        
        NSMutableArray *tmpAry = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *tmpDic in allDataAry)
        {
            totalCount += [[tmpDic objectForKey:@"任务总数"] intValue];
            outCount += [[tmpDic objectForKey:@"超时完成数"] intValue];
            completedCount += [[tmpDic objectForKey:@"已完成数"] intValue];
            uncompletedCount += [[tmpDic objectForKey:@"超时未完成数"] intValue];
            completingCount += [[tmpDic objectForKey:@"正在办理"] intValue];
            [tmpAry addObject:tmpDic ];
        }
        
        NSMutableDictionary *endDic = [NSMutableDictionary dictionaryWithCapacity:6];
        [endDic setObject:@"汇总" forKey:@"任务种类"];
        [endDic setObject:[NSString stringWithFormat:@"%d",totalCount] forKey:@"任务总数"];
        [endDic setObject:[NSString stringWithFormat:@"%d",outCount] forKey:@"超时完成数"];
        [endDic setObject:[NSString stringWithFormat:@"%d",completedCount] forKey:@"已完成数"];
        [endDic setObject:[NSString stringWithFormat:@"%d",uncompletedCount] forKey:@"超时未完成数"];
        [endDic setObject:[NSString stringWithFormat:@"%d",completingCount] forKey:@"正在办理"];
        [tmpAry addObject:endDic];
        self.allDataAry = tmpAry;
    }
    
     if(HUD)
     {
         [HUD hide:YES];
         [HUD removeFromSuperview];
         [HUD release];
     }
     [self.displayTableView reloadData];
}

- (void)requestJavaWebService
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_TJZS_TJZSL" forKey:@"service"];
    [param setObject:fromDate forKey:@"kssj"];
    [param setObject:endDate forKey:@"jssj"];
    [param setObject:deptID forKey:@"bmbh"];
    
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:param];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *resultAry = [jsonStr objectFromJSONString];
    
    //URL示例:http://113.106.85.17:8086/ebcmjczd/invoke?version=1.0&imei=8C:FA:BA:05:3A:CF&clientType=IPAD&userid=lixiaotao&password=1&service=GET_TJZS_TJZSL&kssj=2013-07-01&bmbh=&jssj=2013-07-10
    
    NSDictionary *testDic = [resultAry objectAtIndex:0];
    BOOL bSuccess = YES;
    
    if ([testDic objectForKey:@"result"])
        bSuccess = NO;
    
    
    if (bSuccess)
    {
        [allDataAry insertObjects:resultAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, resultAry.count)]];
    }
    else
    {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:7];
        [tmpDic setObject:@"环境信访" forKey:@"任务种类"];
        [tmpDic setObject:@"0" forKey:@"任务总数"];
        [tmpDic setObject:@"0" forKey:@"超时完成数"];
        [tmpDic setObject:@"0" forKey:@"正在办理"];
        [tmpDic setObject:@"0" forKey:@"已完成数"];
        [tmpDic setObject:@"0" forKey:@"超时未完成数"];
        [allDataAry insertObject:[NSDictionary dictionaryWithDictionary:tmpDic] atIndex:0 ];
        
        [tmpDic setObject:@"噪声许可" forKey:@"任务种类"];
        [tmpDic setObject:@"0" forKey:@"任务总数"];
        [tmpDic setObject:@"0" forKey:@"超时完成数"];
        [tmpDic setObject:@"0" forKey:@"正在办理"];
        [tmpDic setObject:@"0" forKey:@"已完成数"];
        [tmpDic setObject:@"0" forKey:@"超时未完成数"];
        [allDataAry insertObject:[NSDictionary dictionaryWithDictionary:tmpDic] atIndex:1 ];
        
        [tmpDic setObject:@"行政处罚" forKey:@"任务种类"];
        [tmpDic setObject:@"0" forKey:@"任务总数"];
        [tmpDic setObject:@"0" forKey:@"超时完成数"];
        [tmpDic setObject:@"0" forKey:@"正在办理"];
        [tmpDic setObject:@"0" forKey:@"已完成数"];
        [tmpDic setObject:@"0" forKey:@"超时未完成数"];
        [allDataAry insertObject:[NSDictionary dictionaryWithDictionary:tmpDic] atIndex:2 ];
        
    }
    requetStatus += httpStatus;
    if (requetStatus >= soapStatus+httpStatus) {
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
    
    
   // self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:parentController.view delegate:self] autorelease];
}

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)department
{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    isLoading = YES;
    self.fromDate = from;
    self.endDate = end;
    self.deptID = department;
    requetStatus = 0;
    self.allDataAry = [NSMutableArray arrayWithCapacity:10];
    NSString *param = [WebServiceHelper createParametersWithKey:@"StartDate" value:from,@"EndDate",end,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl method:@"TaskCountZTQK_New_Ex" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    [self.webHelper run];
    //http://219.133.105.204:81/MobileLawService_NewJCPT/MapNavigation.asmx?op=TaskCountZTQK_New
    //NSLog(@"%@ %@", param, strUrl);
    
    if (parentController != nil) {
        HUD = [[MBProgressHUD alloc] initWithView:parentController.view];
        [parentController.view addSubview:HUD];
        
        HUD.labelText = @"正在请求数据，请稍候...";
        [HUD show:YES];
    }
    
    [NSThread detachNewThreadSelector:@selector(requestJavaWebService) toTarget:self withObject:nil];
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData
{
    /*
    NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",logstr);
    [logstr release];
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
    isLoading = NO;
}

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"TaskCountZTQK_New_ExResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"TaskCountZTQK_New_ExResult"]) 
    {
        NSDictionary *tmpNameDic = [curParsedData objectFromJSONString];
        NSArray *keyAry = [NSArray arrayWithObjects:@"现场执法任务",@"排污收费",@"预警", nil];
        NSMutableArray *dealResult = [NSMutableArray array];
        
        for (NSString *key in keyAry)
        {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
            NSString *count;
            if ([key isEqualToString:@"现场执法任务"])
                [tmpDic setObject:@"现场执法任务" forKey:@"任务种类"];
            
            else if ([key isEqualToString:@"排污收费"])
                [tmpDic setObject:@"排污收费" forKey:@"任务种类"];
            
            else if ([key isEqualToString:@"预警"])
                [tmpDic setObject:@"预警" forKey:@"任务种类"];

            if ([tmpDic count] != 0)
            {
                NSArray *countAry = [tmpNameDic objectForKey:key];
                NSDictionary *aTypeDic = [countAry objectAtIndex:0];
                count = [aTypeDic objectForKey:@"任务总数"];
                [tmpDic setObject:count  forKey:@"任务总数"];
            
                count = [aTypeDic objectForKey:@"已完成数"];
                [tmpDic setObject:count forKey:@"已完成数"];
            
                count = [aTypeDic objectForKey:@"正在办理"];
                [tmpDic setObject:count forKey:@"正在办理"];
            
                count = [aTypeDic objectForKey:@"超时完成数"];
                [tmpDic setObject:count  forKey:@"超时完成数"];
                
                count = [aTypeDic objectForKey:@"超时未完成数"];
                [tmpDic setObject:count  forKey:@"超时未完成数"];
                
                [dealResult addObject:tmpDic];
            }
            
        }

        /*if(self.resultDataAry)
        {
            [self.resultDataAry removeAllObjects];
        }
        [self.resultDataAry addObjectsFromArray:[NSArray arrayWithArray:dealResult]];*/
        self.resultDataAry = dealResult;
        
        [allDataAry addObjectsFromArray:resultDataAry];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = NO;
    requetStatus += soapStatus;
    if (requetStatus >= soapStatus+httpStatus) {
        [self refreshTableView];
    }
    //[self.displayTableView reloadData];
   // isLoading = NO;

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
    if ([allDataAry count] > 0)
        return [allDataAry count];
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"任务种类",@"任务总数",
                       @"正常完成数",@"正在办理",@"超时完成数",@"超时未完成数",
                       nil];

    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 739, 45)];

    CGFloat width = 739.0/[aryTmp count];
    CGRect tRect = CGRectMake(0, 5, width, 33);
        
    for (int i =0; i < aryTmp.count; i++) {
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
    if ([allDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    NSString *identifierStr = @"ztqkCell";
    NSDictionary *dicTmp = [allDataAry objectAtIndex:indexPath.row];
   
    NSArray *aryTmp = [NSArray arrayWithObjects:[dicTmp objectForKey:@"任务种类"],
                       [dicTmp objectForKey:@"任务总数"],
                       [dicTmp objectForKey:@"已完成数"],
                       [dicTmp objectForKey:@"正在办理"],
                       [dicTmp objectForKey: @"超时完成数"],
                       [dicTmp objectForKey:@"超时未完成数"],
                       nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView
                                      withTexts:aryTmp
                                      andHeight:60 
                                       andWidth:739
                                  andIdentifier:identifierStr];
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = SELECT_UICOLOR;
    cell.selectedBackgroundView = bgview;
    [bgview release];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicTmp = [allDataAry objectAtIndex:indexPath.row];
    int count = [[dicTmp objectForKey:@"任务总数"] intValue];
    if (count == 0)
        return;
    [delegate returnRequestType:dicTmp];
}

@end