//
//  TaskCountZSXKDataModel.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TaskCountZSXKDataModel.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"
#import "ZsxkUndealVC.h"

@implementation TaskCountZSXKDataModel
@synthesize fromDateStr,endDateStr;
@synthesize webservice;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID{
    
    self.fromDateStr = from;
    self.endDateStr = end;
    
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_JCGL_ZSXKTJSL" forKey:@"service"];
    [param setObject:from forKey:@"kssj"];
    [param setObject:end forKey:@"jssj"];
    [param setObject:depID forKey:@"bmbh"];
    
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:param];
    
     self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:parentController.view delegate:self] autorelease];
       
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    if ([webData length] <=0 )
        return;
    
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"%@", resultJSON);
    NSMutableArray *resultAry = [resultJSON objectFromJSONString];
    
    NSDictionary *testDic = [resultAry objectAtIndex:0];  
    NSArray *keyAry = [testDic allKeys];  
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {             
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];   
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {
        
        self.resultDataAry = resultAry;
        
        [displayTableView reloadData];
        if(displayTableView.hidden)
        {
            [displayTableView setHidden:NO];
        }
    }
    else
    {
        /*if(self.resultDataAry)
        {
            self.resultDataAry = [[NSMutableArray alloc] init];
        }*/
        [self.resultDataAry removeAllObjects];
        
        [displayTableView reloadData];
        if(displayTableView.hidden == NO)
        {
            [displayTableView setHidden:YES];
        }
    }
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
    if ([resultDataAry count] > 0)
        return [resultDataAry count];
    else
        return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"部门名称",
                       @"执法人员",@"任务总数",@"正常完成数",@"正在办理",@"超时完成数",@"超时未完成数",
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
    if ([resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    NSString *identifierStr = nil;
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    NSString *showBMMC = [dicTmp objectForKey:@"ZZJC"];
    
    if (indexPath.row == 0)
        identifierStr = @"Show_zsxkCell";
    else
    {
        NSDictionary *lastDicTmp = [resultDataAry objectAtIndex:indexPath.row-1];
        if ([showBMMC isEqualToString:[lastDicTmp objectForKey:@"ZZJC"]])
        {
            showBMMC = @"";
            identifierStr = @"Hide_zsxkCell";
        }
        else
            identifierStr = @"Show_zsxkCell";
    }
    
    NSArray *aryTmp = [NSArray arrayWithObjects:showBMMC,
                       [dicTmp objectForKey:@"MC"],
                       [dicTmp objectForKey:@"任务总数"],
                       [dicTmp objectForKey:@"已完成数"],
                       [dicTmp objectForKey:@"正在办理"],
                       [dicTmp objectForKey: @"超时完成数"],
                       [dicTmp objectForKey:@"超时未完成数"],
                       nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:aryTmp andHeight:60 andWidth:739 andIdentifier:identifierStr];
    
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
    
    ZsxkUndealVC *childVC = [[ZsxkUndealVC alloc] initWithNibName:@"ZsxkUndealVC" bundle:nil];
    childVC.fromStr = fromDateStr;
    childVC.endStr = endDateStr;
    childVC.yhid = [tmpDic objectForKey:@"YHID"];
    
    [parentController.navigationController pushViewController:childVC animated:YES];
    
    [childVC release];
}

@end
