//
//  PwsfDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PwsfDataModel.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "WryJbxxController.h"
#import "SFXXListViewController.h"

extern MPAppDelegate *g_appDelegate;

@implementation PwsfDataModel

@synthesize itemArray,isLoading;

- (void)dealloc
{
    [itemArray release];
    [super dealloc];
}


-(void)requestData{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested){
        [displayTableView reloadData];
        return;
    }
    
    self.isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,nil];
    NSString *URL = [NSString stringWithFormat:WRYPWSB_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL 
                                                                   method:@"NewGetJfqkch" 
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([itemArray count] > 0)
        return [itemArray count];
    else
        return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"发单日期",
                       @"经办人",@"总共应收",@"是否缴费",@"欠缴金额",
                       nil];
    
    CGFloat headWidth = 768;

    
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, headWidth, 45)];
    
    int width = (headWidth - 28)/5;
    CGRect tRect = CGRectMake(14, 5, width, 33);
    
    for (int i =0; i < 5; i++) {
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
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([itemArray count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    NSString *identifierStr = @"pwsfCell";
    NSDictionary *dicTmp = [itemArray objectAtIndex:indexPath.row];

    NSString *fdrq = [dicTmp objectForKey:@"发单日期"];
    NSString *jbr = [dicTmp objectForKey:@"经办人"];
    NSString *zgys = [dicTmp objectForKey:@"总共应收"];
    NSString *qjje = [[dicTmp objectForKey:@"欠缴金额"] length] > 0 ? [dicTmp objectForKey:@"欠缴金额"]:@"";
    
    NSArray *aryTmp = [NSArray arrayWithObjects:[fdrq substringToIndex:10],jbr,[NSString stringWithFormat:@"%@元",zgys],[dicTmp objectForKey:@"是否缴费"],qjje,nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:aryTmp andHeight:40 andWidth:768 andIdentifier:identifierStr];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NewGetJfqkchResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"NewGetJfqkchResult"]) 
    {
        self.itemArray = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.isLoading = NO;
    if(self.itemArray.count <= 0)
    {
        self.displayTableView.hidden = YES;
        if([self.parentController isKindOfClass:[WryJbxxController class]])
        {
            WryJbxxController *parentVC = (WryJbxxController*)self.parentController;
            parentVC.emptyView.hidden = NO;
           
        }
        else if([self.parentController isKindOfClass:[SFXXListViewController class]])
        {
            SFXXListViewController *parentVC = (SFXXListViewController*)self.parentController;
            parentVC.emptyView.hidden = NO;
        }
    }
    [self.displayTableView reloadData];
}

@end
