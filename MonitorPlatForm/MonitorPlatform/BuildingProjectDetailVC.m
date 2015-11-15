//
//  BuildingProjectDetailVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "BuildingProjectDetailVC.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "ZrsUtils.h"
#import "HtmlTableGenerator.h"
#import "ServiceUrlString.h"
#import "ZFXXListViewController.h"
#import "SFXXListViewController.h"

extern MPAppDelegate *g_appDelegate;

@implementation BuildingProjectDetailVC
@synthesize dataDic,listAry,hud,wrybh;
@synthesize sbdjbh,networkQueue;

#pragma mark - Private Methods

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    NSLog(@"request of BPDetail went wrong.");
}

//工程项目详情
-(void)requestGCXMXQDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    NSDictionary *tmpDic = [resultAry objectAtIndex:0];  
    NSArray *keyAry = [tmpDic allKeys];  
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {             
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无详情数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];   
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {         
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        NSString *jzmj = [NSString stringWithFormat:@"%@ 平方米",[tmpDic objectForKey:@"JZMJ"]];
        [resultDic setObject:jzmj forKey:@"JZMJ"];
        

        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"工程项目详情" andParaMeters:resultDic andServiceName:@"QUERY_GCXM_INFO_DETAIL"];
        //NSLog(@"%@", htmlStr);
        myWeb.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [myWeb loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    }
}

//工程噪声许可
- (void)requestXMZSXKDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    NSDictionary *testDic = [resultAry objectAtIndex:0];  
    NSString *judge = [testDic objectForKey:@"result"];
    BOOL bSuccess = YES;
    if (judge)
        bSuccess = NO;
       
    if (bSuccess)   
    {
        self.listAry = resultAry;
        
        [myTable reloadData];
    }
}

//执法信息
- (void)requestJBXXDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultArray = [resultJSON objectFromJSONString];
    
    if(resultArray.count == 1)
    {
        NSDictionary *dict = [resultArray objectAtIndex:0];
        if([[dict objectForKey:@"result"] isEqualToString:@"failed"])
        {
            return;
        }
        else
        {
            [zfxxList addObject:dict];
        }
    }
    else
    {
        for(NSDictionary *dict in resultArray)
        {
            [zfxxList addObject:dict];
        }
    }
}

//收费信息
- (void)requestJFTZSDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultArray = [resultJSON objectFromJSONString];
    
    if(resultArray.count == 1)
    {
        NSDictionary *dict = [resultArray objectAtIndex:0];
        if([[dict objectForKey:@"result"] isEqualToString:@"failed"])
        {
            return;
        }
        else
        {
            [sfxxList addObject:dict];
        }
    }
    else
    {
        for(NSDictionary *dict in resultArray)
        {
            [sfxxList addObject:dict];
        }
    }
}

- (void)allSyncFinished:(ASIHTTPRequest *)request
{
    [hud hide:YES];
}

- (void)requestData
{
    if (!networkQueue )
    {
        self.networkQueue = [[[ASINetworkQueue alloc] init] autorelease];
    }
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue reset ]; // 队列清零
    [networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    //工程项目详情
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"QUERY_GCXM_INFO_DETAIL" forKey:@"service"];
    [param setObject:sbdjbh forKey:@"gcxmsbdjh"];
    NSString *urlStrGCXMXQ = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestGCXMXQ;
    requestGCXMXQ = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrGCXMXQ]];
    [requestGCXMXQ setDelegate:self];
    [requestGCXMXQ setDidFinishSelector: @selector (requestGCXMXQDone:)];
    [requestGCXMXQ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestGCXMXQ];
    
    //工程项目噪声许可
    [param setObject:@"QUERY_GCXM_ZCXK_LIST" forKey:@"service"];
    [param setObject:sbdjbh forKey:@"gcxmsqdjh"];
    NSString *urlStrXMZSXK = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestXMZSXK;
    requestXMZSXK = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrXMZSXK]];
    [requestXMZSXK setDelegate:self];
    [requestXMZSXK setDidFinishSelector: @selector (requestXMZSXKDone:)];
    [requestXMZSXK setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestXMZSXK];
    
    //执法信息的列表　QUERY_JCGL_XCZF_JBXX
    [param removeObjectForKey:@"gcxmsqdjh"];
    [param setObject:@"QUERY_JCGL_XCZF_JBXX" forKey:@"service"];
    [param setObject:wrybh forKey:@"dwbh"];
    NSString *urlStrJBXX = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestJBXX = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStrJBXX]];
    [requestJBXX setDelegate:self];
    [requestJBXX setDidFinishSelector:@selector(requestJBXXDone:)];
    [requestJBXX setDidFailSelector:@selector(requestWentWrong:)];
    [networkQueue addOperation:requestJBXX];
    
    //收费信息的列表　QUERY_JCGL_PWSF_JFTZS
    [param setObject:@"QUERY_JCGL_PWSF_JFTZS" forKey:@"service"];
    [param setObject:wrybh forKey:@"dwbh"];
    NSString *urlStrJFTZS = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestJFTZS= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStrJFTZS]];
    [requestJFTZS setDelegate:self];
    [requestJFTZS setDidFinishSelector:@selector(requestJFTZSDone:)];
    [requestJFTZS setDidFailSelector:@selector(requestWentWrong:)];
    [networkQueue addOperation:requestJFTZS];
    
    [networkQueue go];
    
    [hud show:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [dataDic release];
    [listAry release];
    [sbdjbh release];
    [zfxxList release];
    [sfxxList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"工程项目信息详情";
    
    //等待提示初始化
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    hud.labelText = @"正在请求数据，请稍候...";
    
    zfxxList = [[NSMutableArray alloc] init];
    sfxxList = [[NSMutableArray alloc] init];
    
    [self requestData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [networkQueue cancelAllOperations];
    [hud hide:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source 

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(indexPath.row%2 == 0)     
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 3;
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if (listAry && [listAry count] > 0)
        {
            return [listAry count];
        }
        else
        {
            return 1;
        }
    }
    else if(section == 1)
    {
        if (zfxxList && [zfxxList count] > 0)
        {
            return [zfxxList count];
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (sfxxList && [sfxxList count] > 0)
        {
            return [sfxxList count];
        }
        else
        {
            return 1;
        }
    }
} 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 	
    return 72; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"噪声许可证列表";
    }
    else if(section == 1)
    {
        return @"执法信息的列表";
    }
    else
    {
        return @"收费信息的列表";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (listAry && [listAry count] > 0)
        {
            NSDictionary *tmpDic = [listAry objectAtIndex:indexPath.row];
            NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
            NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
            if ([sgkssj length] > 10)
                sgkssj = [sgkssj substringToIndex:10];
            if ([sgjzsj length] > 10)
                sgjzsj = [sgjzsj substringToIndex:10];
            
            UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"SGNR"] andSubvalue1:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue2:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj] andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *cellIdentifier = @"nodata_Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            cell.textLabel.text = @"本项目没有通过许可的施工时间安排";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if(indexPath.section == 1)
    {
        /*if (zfxxList && [zfxxList count] > 0)
        {
            NSDictionary *tmpDic = [listAry objectAtIndex:indexPath.row];
            NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
            NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
            if ([sgkssj length] > 10)
                sgkssj = [sgkssj substringToIndex:10];
            if ([sgjzsj length] > 10)
                sgjzsj = [sgjzsj substringToIndex:10];
            
            UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"SGNR"] andSubvalue1:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue2:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj] andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *cellIdentifier = @"nodata_Cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            cell.textLabel.text = @"本项目暂无执法信息数据";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }*/
        NSString *cellIdentifier = @"nodata_Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.detailTextLabel.text = @"该项目对应的执法信息数据";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    else
    {
        /*if (sfxxList && [sfxxList count] > 0)
        {
            NSDictionary *tmpDic = [listAry objectAtIndex:indexPath.row];
            NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
            NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
            if ([sgkssj length] > 10)
                sgkssj = [sgkssj substringToIndex:10];
            if ([sgjzsj length] > 10)
                sgjzsj = [sgjzsj substringToIndex:10];
            
            UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"SGNR"] andSubvalue1:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue2:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj] andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *cellIdentifier = @"nodata_Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            cell.textLabel.text = @"本项目暂无收费信息数据";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }*/
        NSString *cellIdentifier = @"nodata_Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.detailTextLabel.text = @"该项目对应的排污收费信息数据";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section == 1)
    {
        ZFXXListViewController *zfxxListVC = [[ZFXXListViewController alloc] initWithNibName:@"ZFXXListViewController" bundle:nil];
        zfxxListVC.wrybh = wrybh;
        [self.navigationController pushViewController:zfxxListVC animated:YES];
        [zfxxListVC release];
    }
    else if(indexPath.section == 2)
    {
        //ZfrwDataModel
        SFXXListViewController *sfxxListVC = [[SFXXListViewController alloc] initWithNibName:@"SFXXListViewController" bundle:nil];
        sfxxListVC.wrybh = wrybh;
        [self.navigationController pushViewController:sfxxListVC animated:YES];
        [sfxxListVC release];
    }
}

@end
