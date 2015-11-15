//
//  JbxxDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "JbxxDataModel.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "ZrsUtils.h"
 

extern MPAppDelegate *g_appDelegate;

@implementation JbxxDataModel

@synthesize dicJbxx,dicWryjs,aryKeys,valueAry,cellHeightAry;



-(void)requestData{
    
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested){
        [displayTableView reloadData];
        return;
    }
    
    self.aryKeys = [NSArray arrayWithObjects:@"污染源简称", @"污染源地址", @"法人代表",  @"联系电话", @"环保联系人", @"环保联系人电话", @"行业类型",@"产生污染物种类",@"污染源责任人",@"重点源",@"在线监测企业",@"环保监管级别",@"开征排污费",@"污染源介绍",nil];
    
    self.valueAry = [NSMutableArray array];
    self.cellHeightAry = [NSMutableArray array];
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" 
                                                          value:self.wrybh,nil];
    
    NSString *URL = [NSString stringWithFormat:WRYJBXX_URL,g_appDelegate.xxcxServiceIP];
    
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"GetWryJbxx" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[self.webHelper runAndShowWaitingView:parentController.view];
    
    
}

-(NSString*)validateJson:(NSString*)origStr{
    NSMutableString *str = [NSMutableString stringWithString:origStr];
    NSArray *occurStrAry = [NSArray arrayWithObjects:@"\b",@"\t", @"\f",  nil];// @"\\", @"\"",
    NSArray *replaceStrAry = [NSArray arrayWithObjects:@"\\b",@"", @"\\f", nil];
    // @"\\\\", @"\\\"",
    for(int i = 0; i < occurStrAry.count;i++){
        NSString *occur = [occurStrAry objectAtIndex:i];
        NSString *replace = [replaceStrAry objectAtIndex:i];
       [str replaceOccurrencesOfString:occur withString:replace options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    }
    
    return str;
}

-(void)processWebData:(NSData*)webData{
    
    
    NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSData *repData = [[self validateJson:logstr] dataUsingEncoding:NSUTF8StringEncoding];
    [logstr release];
    
    self.isGotJsonString = NO;
    self.isDataRequested = YES;
    self.curParsedData = [NSMutableString stringWithCapacity:300];
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: repData ] autorelease];
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



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if( [elementName isEqualToString:@"GetWryJbxxResult"])
	{
		isGotJsonString = YES;
	} 
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(isGotJsonString)
	{
		[self.curParsedData appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(isGotJsonString && [elementName isEqualToString:@"GetWryJbxxResult"]){
        
        NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x0A];
        NSString *str =[curParsedData stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
        
        self.dicJbxx = [str objectFromJSONString];
        if ([valueAry count] > 0)
            [valueAry removeAllObjects];
        
        if ([cellHeightAry count] > 0)
            [cellHeightAry removeAllObjects];
        
        NSDictionary *tmpDic = [[dicJbxx objectForKey:@"污染源基本信息"] lastObject];
        
        CGFloat width = 768/10*8-20;
        
        for (int i = 0; i<[aryKeys count]-1; i++) {
            NSString *key = [aryKeys objectAtIndex:i];
            NSString *value = [tmpDic objectForKey:key];
            
            if ([value isEqualToString:@"0"])
                value = @"否";
            if ([value isEqualToString:@"1"])
                value = @"是";
            
            if ([value length] == 0)
                value = @" ";
            
            [valueAry addObject:value];
            
            CGFloat height = [ZrsUtils calculateTextHeight:value byFontSize:19 andWidth:width];
            [cellHeightAry addObject:[NSNumber numberWithFloat:height]];
        }
        
        NSDictionary *tmpDic2 = [[dicJbxx objectForKey:@"污染源介绍"] lastObject];
        for (int i = [aryKeys count]-1; i<[aryKeys count];i++)
        {
            NSString *key = [aryKeys objectAtIndex:i];
            NSString *value = [[tmpDic2 objectForKey:key] length]>0 ? [tmpDic2 objectForKey:@"污染源介绍"]:@" ";
            
            [valueAry addObject:value];
            
            CGFloat height = [ZrsUtils calculateTextHeight:value byFontSize:19 andWidth:width];
            [cellHeightAry addObject:[NSNumber numberWithFloat:height]];
        }
        
        isDataRequested = YES;
        
        [self.displayTableView reloadData];
    }
    isGotJsonString = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if ([cellHeightAry count] > 0) {
        height = [[cellHeightAry objectAtIndex:indexPath.row] floatValue];
    } else {
        height = 56;
    }
    return height;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) 
        return @"基本信息";
    else 
        return @"污染源介绍";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  [valueAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (isDataRequested) {
        NSString *title = [aryKeys objectAtIndex:indexPath.row];
        NSString *value = [valueAry objectAtIndex:indexPath.row];
        
        NSArray *values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@:",title],value, nil];
        
        cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:1 cellHeight:[[cellHeightAry objectAtIndex:indexPath.row] floatValue] valueArray:values];
    }
    else
    {
        static NSString *CellIdentifier = @"Cell_default";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
