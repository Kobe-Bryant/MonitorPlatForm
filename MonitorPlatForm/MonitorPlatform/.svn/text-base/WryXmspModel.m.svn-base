//
//  WryXmspModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryXmspModel.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "XmspDetailsController.h"
#import "WryJbxxController.h"

extern MPAppDelegate *g_appDelegate;

@implementation WryXmspModel

@synthesize xmspArray,isLoading;

- (void)dealloc
{
    [xmspArray release];
    [super dealloc];
}


-(void)requestData
{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested)
    {
        [displayTableView reloadData];
         return;
    }
    self.isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"strWRYBH" value:wrybh,nil];
    NSString *URL = [NSString stringWithFormat:WRYJBXX_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL method:@"GetXmsp_List" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    [self.webHelper runAndShowWaitingView:parentController.view];
}


#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);
     
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([xmspArray count] >0)
        return [xmspArray count];
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([xmspArray count] > 0) 
    {
        NSDictionary *aItem = [xmspArray objectAtIndex:indexPath.row];
        NSString *aTitle = [NSString stringWithFormat:@"项目名称：%@",[aItem objectForKey:@"XMMC"]];
        
        NSString *aMode = [NSString stringWithFormat:@"投资单位：%@",[aItem objectForKey:@"TZDW"]];
        
        NSString *aCode = [NSString stringWithFormat:@"项目年份：%@",[aItem objectForKey:@"XMND"]];
        
        NSString *aCDate = [aItem objectForKey:@"SFTGSP"];
        if ([aCDate intValue] == 1)
            aCDate = @"已通过";
        else
            aCDate = @"未通过";
        
        NSString *person = [aItem objectForKey:@"SPY"];
        
        cell = [UITableViewCell makeSubCell:tableView withTitle:aTitle andSubvalue1:aMode andSubvalue2:aCDate andSubvalue3:aCode andSubvalue4:[NSString stringWithFormat:@"审批人：%@" ,person] andNoteCount:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell_NoInformation";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        if (!isLoading)
            cell.textLabel.text = @"该污染源没有建设项目审批信息。";
        else
            cell.textLabel.text = @"正在读取数据...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(xmspArray.count <= 0)
    {
        return;
    }
    NSDictionary *aItem = [xmspArray objectAtIndex:indexPath.row];
    
    XmspDetailsController *childView = [[XmspDetailsController alloc] initWithProjectCode:[aItem objectForKey:@"XMBH"] andDataType:1];
    
    [parentController.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetXmsp_ListResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetXmsp_ListResult"])
    {
        self.xmspArray = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.isLoading = NO;
    if([xmspArray count] <= 0)
    {
        WryJbxxController *parentVC = (WryJbxxController*)self.parentController;
        parentVC.emptyView.hidden = NO;
        self.displayTableView.hidden = YES;
    }
    [self.displayTableView reloadData];
}
@end