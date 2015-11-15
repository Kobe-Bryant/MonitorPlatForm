//
//  CftzDataModel.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-26.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "CftzDataModel.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "CfjysViewController.h"
#import "WryJbxxController.h"

extern MPAppDelegate *g_appDelegate;

@implementation CftzDataModel
@synthesize webResultAry,isLoading;

#pragma mark - Private Methods

- (void)requestData{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested){
        [displayTableView reloadData];
        return;
    }
    isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"dwbh" value:wrybh,nil];
    NSString *URL = [NSString stringWithFormat:WRYCFTZ_URL,g_appDelegate.xxcxServiceIP];
    
    //NSLog(@"param:%@\n url:%@",param,URL);
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL 
                                                                   method:@"GetXzfc" 
                                                                nameSpace:@"http://tempuri.org/" 
                                                               parameters:param 
                                                                 delegate:self] autorelease];
    [self.webHelper runAndShowWaitingView:parentController.view];
}

#pragma mark - URL ConnHelper Delegate

- (void)processWebData:(NSData*)webData
{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);
    */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

- (void)processError:(NSError *)error{
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([webResultAry count] >0)
        return [webResultAry count];
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
    if ([webResultAry count] > 0) 
    {
        NSDictionary *aItem = [webResultAry objectAtIndex:indexPath.row];
        NSString *aTitle = [NSString stringWithFormat:@"案件性质：%@",[aItem objectForKey:@"DMNR"]];
        
        NSString *aCode = [aItem objectForKey:@"LASJ"];
        if ([aCode length] > 0)
        {
            aCode = [NSString stringWithFormat:@"立案时间：%@",[aCode substringToIndex:10]];
        }
        else{
            aCode = @"立案时间：无";
        }
        
        NSString *aCDate = [aItem objectForKey:@"SFSL"];
        if ([aCDate isEqualToString:@"1"])
            aCDate = [NSString stringWithFormat:@"已受理"];
        else
            aCDate = [NSString stringWithFormat:@"未受理"];
        
        cell = [UITableViewCell makeSubCell:(UITableView *)tableView 
                                  withTitle:aTitle
                                   caseCode:aCode 
                              complaintDate:aCDate 
                                    endDate:@""
                                       Mode:@""];
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
            cell.textLabel.text = @"该污染源没有处罚信息。";
        else
            cell.textLabel.text = @"正在读取数据...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aItem = [webResultAry objectAtIndex:indexPath.row];
    CfjysViewController *childView = [[[CfjysViewController alloc] initWithCaseCode:[aItem objectForKey:@"LADJBH"]] autorelease];
    [parentController.navigationController pushViewController:childView animated:YES];
}

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetXzfcResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetXzfcResult"]) 
    {
        self.webResultAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = NO;
    if(self.webResultAry.count <= 0)
    {
        WryJbxxController *parentVC = (WryJbxxController*)self.parentController;
        parentVC.emptyView.hidden = NO;
        self.displayTableView.hidden = YES;
    }
    [self.displayTableView reloadData];
}


@end
