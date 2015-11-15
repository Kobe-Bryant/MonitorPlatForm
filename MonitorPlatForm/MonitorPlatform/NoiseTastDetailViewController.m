//
//  NoiseTastDetailViewController.m
//  MonitorPlatform
//
//  Created by ihumor on 13-2-28.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "NoiseTastDetailViewController.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"
#import "HandlePassViewController.h"
#import "LoginedUsrInfo.h"


#define FONT_SIZE 18.0f
#define CELL_CONTENT_MARGIN 10.0f

extern MPAppDelegate *g_appDelegate;

@interface NoiseTastDetailViewController (){
    
    BOOL isDealWithRead;
    NSArray *baseInfoKeyArr;
    NSArray *baseInfoNameArr;
}
@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,assign) BOOL bHave;
@property (nonatomic, retain) NSArray *constructionTimeArr;
@property (nonatomic, retain) NSArray *workFlowListArr;
@property (nonatomic,strong) NSURLConnHelper *webservice;
@end

@implementation NoiseTastDetailViewController
@synthesize networkQueue;
@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //等待提示初始化
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    hud.labelText = @"正在请求数据，请稍候...";
    
    if (!_hasDone) {
        
        if ([_SFZB isEqualToString:@"READER"]) {
            
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"来文已阅" style:UIBarButtonItemStylePlain target:self action:@selector(hasRead:)] autorelease];
        }
        else{
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"办理" style:UIBarButtonItemStylePlain target:self action:@selector(HandleTask:)] autorelease];
        }
        
        
    }
    baseInfoKeyArr = [[NSArray alloc] initWithObjects:@"GDMC",@"GCDM,GCXMSQDJH",@"JSDW",@"JSDWFZR,JSDWFZRDH",@"SGDWMC",@"SGDWFZR,SGDWFZRDH",@"SQR,SQRDH",@"SGXCDD",@"SGXCZWHJ",@"SQYCSGSJLY",@"SGNR",@"SGJD",@"JJSGGLBMYJ",@"SQCL",@"CSYJ",@"CSR,CSSJ",@"CSSFTY",@"SHYJ",@"SHR,SHSJ",@"QPYJ",@"QPR,QPSJ",nil];
    /*baseInfoNameArr = [[NSArray alloc] initWithObjects:@"工程名称",@"工程代码,申报登记号",@"建设单位",@"建设单位负责人,负责人电话",@"施工单位名称",@"施工单位负责人,施工单位负责人电话",@"经办人,经办人电话",@"施工现场地点",@"施工现场周围环境",@"申请延长施工时间理由",@"施工内容",@"施工阶段",@"基建施工管理部门意见",@"申请材料",@"初审意见",@"初审人,初审时间",@"办理意见",@"审核意见",@"审核人,审核时间",@"签批意见",@"签批人,签批时间",nil];*/
    baseInfoNameArr = [[NSArray alloc] initWithObjects:@"工程名称:",@"工程代码:,申报登记号:",@"建设单位:",@"建设单位负责人:,负责人电话:",@"施工单位名称:",@"施工单位负责人:,施工单位负责人电话:",@"经办人:,经办人电话:",@"施工现场地点:",@"施工现场周围环境:",@"申请延长施工时间理由:",@"施工内容:",@"施工阶段:",@"基建施工管理部门意见:",@"申请材料:",@"初审意见:",@"初审人:,初审时间:",@"办理意见:",@"审核意见:",@"审核人:,审核时间:",@"签批意见:",@"签批人:,签批时间:",nil];
    
    [self requestData];
}


- (void)viewWillAppear:(BOOL)animated{
    
    NSString *title = self.title;
    if (![title isEqualToString:@""]) {
        self.title = @"";
    }
}

- (void)HandleTask:(id)sender{
    
    self.title = @"噪声许可任务详情";
    
    HandlePassViewController *childView = [[HandlePassViewController alloc] initWithNibName:@"HandlePassViewController" bundle:nil];
    
    [childView setLetterVisitNum:_ywxtbh];
    [childView setNLinker:3];
    //对比办理人信息，看是否是协办
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    if (![usrInfo.userPinYinName isEqualToString:_yhid])
        childView.isChangeUser = YES;
    else
        childView.isChangeUser = NO;
    childView.changeUserID = _yhid;
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [networkQueue cancelAllOperations];
    [hud hide:YES];
    [super viewWillDisappear:animated];
}


- (void)requestData
{
    if (! networkQueue ) {
        self.networkQueue = [[[ ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_SQ_INFO" forKey:@"service"];
    [param setObject:_yhid forKey:@"yhid"];
    [param setObject:_ywxtbh forKey:@"ywxtbh"];
    [param setObject:_lclxbh forKey:@"lclxbh"];
    [param setObject:_bwbhnew forKey:@"bwbhnew"];
    
    //获取详情
    NSString *urlStrDetails = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestDetails;
    requestDetails = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrDetails]];
    [requestDetails setDelegate:self];
    [requestDetails setDidFinishSelector: @selector (requestDetailsDone:)];
    [requestDetails setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestDetails];
    
    [param setObject:@"WORKFLOW_HISTORY_PAGE" forKey:@"service"];
    [param setObject:_yhid forKey:@"yhid"];
    [param setObject:_bwbhnew forKey:@"workflowId"];
    
    //获取步骤流程
    NSString *urlStrXMZSXK = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestXMZSXK;
    requestXMZSXK = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrXMZSXK]];
    [requestXMZSXK setDelegate:self];
    [requestXMZSXK setDidFinishSelector: @selector (requestXMZSXKDone:)];
    [requestXMZSXK setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestXMZSXK];
    
    [networkQueue go];
    
    [hud show:YES];
}

- (void)hasRead:(id)sender{
    //来文已阅
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"WORKFLOW_TRANSITION_AUTO" forKey:@"service"];
    [param setObject:_lclxbh forKey:@"LCBH"];
    [param setObject:_bwbhnew forKey:@"LCSLBH"];
    [param setObject:_BZDYBH forKey:@"BZDYBH"];
    [param setObject:_BZBH forKey:@"BZBH"];
    [param setObject:_yhid forKey:@"processer"];
    [param setObject:_SFZB forKey:@"processType"];
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    isDealWithRead = YES;//当前为办理已阅读
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
    
}

#pragma mark - Private methods

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    NSLog(@"request of ZSDetail went wrong.");
}

-(void)requestDetailsDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    
    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    if (resultAry == nil||resultAry.count==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无详情数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary *tmpDic = [resultAry objectAtIndex:0];
    
    NSMutableDictionary *muTmpDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
    NSArray *keyAry = [tmpDic allKeys];
    BOOL bSuccess = YES;
    for (NSString *key in keyAry)
    {
        if ([key isEqualToString:@"COUNT"])
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
        if ([[muTmpDic objectForKey:@"CSSFTY"] intValue]==1) {
            [muTmpDic setValue:@"许可" forKey:@"CSSFTY"];
        }
        else{
            [muTmpDic setValue:@"不许可" forKey:@"CSSFTY"];
        }
        self.baseInfoDic = muTmpDic;
        self.constructionTimeArr = [muTmpDic objectForKey:@"SGZSYCSJAP"];
        [_tetailTable reloadData];
    }
}

- (void)requestXMZSXKDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultAry = [resultJSON objectFromJSONString];
    //NSLog(@"%@", resultJSON);
    
    NSDictionary *testDic = [resultAry objectAtIndex:0];
    BOOL bSuccess = YES;
    NSString *judge = [testDic objectForKey:@"result"];
    
    if (judge)
        bSuccess = NO;
    
    if (bSuccess)
    {
        self.workFlowListArr = resultAry;
        
        [_tetailTable reloadData];
    }
}

- (void)allSyncFinished:(ASIHTTPRequest *)request
{
    [hud hide:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0 && indexPath.section == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {
        if (_baseInfoDic) {
            count = 21;
        }
    }
    else if (section == 1) {
        count = [_constructionTimeArr count];
        if (_constructionTimeArr.count == 0) {
            count = 1;
        }
    } else if (section == 2 ) {
        
        count = [_workFlowListArr count];
    }
    return count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *headTitle = @"";
    if (section == 0){
        headTitle = @"基本信息";
    }
    else if (section == 1) {
        headTitle = @"许可施工时间表";
    } else if (section == 2) {
        headTitle = @"任务处理流程";
    }
    return headTitle;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CGFloat height = 0;
    if (indexPath.section == 0) {
        NSString *keyStr = [baseInfoKeyArr objectAtIndex:indexPath.row];
        NSArray *keyArr = [keyStr componentsSeparatedByString:@","];
        if (keyArr.count==2) {
            keyStr = [keyArr objectAtIndex:0];
        }
        NSString *text = [_baseInfoDic objectForKey:keyStr];
        CGSize constraint = CGSizeMake(606, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    if (indexPath.section == 1) {
        height = 44;
    }
    else{
        height = 44*3;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        NSString *keyStr = [baseInfoKeyArr objectAtIndex:indexPath.row];
        NSArray *keyArr = [keyStr componentsSeparatedByString:@","];
        NSString *nameStr = [baseInfoNameArr objectAtIndex:indexPath.row];
        NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
        
        UILabel *label1 = nil;
        UILabel *label2 = nil;
        UILabel *label3 = nil;
        UILabel *label4 = nil;
        static NSString *baseInfoCellIdentifier = @"baseInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:baseInfoCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseInfoCellIdentifier] autorelease];
        }
        if (cell.contentView != nil) {
            label1 = (UILabel *)[cell.contentView viewWithTag:1];
            label2 = (UILabel *)[cell.contentView viewWithTag:2];
            label3 = (UILabel *)[cell.contentView viewWithTag:3];
            label4 = (UILabel *)[cell.contentView viewWithTag:4];
        }
       
        NSString *text = [_baseInfoDic objectForKey:[keyArr objectAtIndex:0]];
        CGSize constraint = CGSizeMake(600, 1000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        if (keyArr.count==2) {
            if (label1 == nil) {
                CGRect tRect1 = CGRectMake(0, 10, 162, MAX(size.height, 44.0f));
                label1 = [[UILabel alloc] initWithFrame:tRect1];
                [label1 setBackgroundColor:[UIColor clearColor]];
                [label1 setTextColor:[UIColor grayColor]];
                label1.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                label1.textAlignment = UITextAlignmentCenter;
                label1.numberOfLines = 0;
                label1.tag = 1;
                [cell.contentView addSubview:label1];
                [label1 release];
            }
            if (label2 == nil) {
                CGRect tRect2 = CGRectMake(162, 10, 222,MAX(size.height, 44.0f));
                label2 = [[UILabel alloc] initWithFrame:tRect2];
                [label2 setBackgroundColor:[UIColor clearColor]];
                label2.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                label2.textAlignment = UITextAlignmentLeft;
                label2.numberOfLines = 0;
                label2.tag = 2;
                [cell.contentView addSubview:label2];
                [label2 release];
            }
            
            if (label3 == nil) {
                
                 CGRect tRect3 = CGRectMake(222+162, 10, 162,MAX(size.height, 44.0f));
                label3 = [[UILabel alloc] initWithFrame:tRect3];
                [label3 setBackgroundColor:[UIColor clearColor]];
                [label3 setTextColor:[UIColor grayColor]];
                label3.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                label3.textAlignment = UITextAlignmentCenter;
                label3.numberOfLines = 0;
                label3.tag = 3;
                [cell.contentView addSubview:label3];
                [label3 release];
            }
            
            if (label4 == nil) {
                CGRect tRect4 = CGRectMake(222+162*2, 10, 222,MAX(size.height, 44.0f));
                label4 = [[UILabel alloc] initWithFrame:tRect4];
                [label4 setBackgroundColor:[UIColor clearColor]];
                label4.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                label4.textAlignment = UITextAlignmentLeft;
                label4.numberOfLines = 0;
                label4.tag = 4;
                [cell.contentView addSubview:label4];
                [label4 release];
            }
        }
        else{
            if (label3){
                [label3 removeFromSuperview];
                label3 = nil;
            }
            if (label4) {
                [label4 removeFromSuperview];
                label4 = nil;
            }
            if (label1 == nil) {
                CGRect tRect1 = CGRectMake(0, 10, 162, MAX(size.height, 44.0f));
                label1 = [[UILabel alloc] initWithFrame:tRect1];
                [label1 setBackgroundColor:[UIColor clearColor]];
                [label1 setTextColor:[UIColor grayColor]];
                label1.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                [label1 setText:[nameArr objectAtIndex:0]];
                label1.textAlignment = UITextAlignmentCenter;
                label1.numberOfLines = 0;
                label1.tag = 1;
                [cell.contentView addSubview:label1];
                [label1 release];
            }
            if (label2 == nil) {
                CGRect tRect2 = CGRectMake(162, 10, 606,MAX(size.height, 44.0f));
                label2 = [[UILabel alloc] initWithFrame:tRect2];
                [label2 setBackgroundColor:[UIColor clearColor]];
                label2.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
                label2.textAlignment = UITextAlignmentLeft;
                label2.numberOfLines = 0;
                label2.tag = 2;
                [cell.contentView addSubview:label2];
                [label2 release];
            }
        }
        if (label1!=nil) [label1 setText:[nameArr objectAtIndex:0]];
        //2013-07-12 屏蔽施工阶段字段
        if (label2!=nil)
        {
            if([[nameArr objectAtIndex:0] isEqualToString:@"施工阶段:"])
            {
                //ydwifi2013
                [label2 setText:@""];
            }
            else
            {
                [label2 setText:[_baseInfoDic objectForKey:[keyArr objectAtIndex:0]]];
            }
        }
        if (label3!=nil) [label3 setText:[nameArr objectAtIndex:1]];
        if (label4!=nil) [label4 setText:[_baseInfoDic objectForKey:[keyArr objectAtIndex:1]]];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1) {
        if (_constructionTimeArr.count>0)
        {
            NSDictionary *tmpDic = [_constructionTimeArr objectAtIndex:indexPath.row];
            NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
            NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
            
            
            cell = [UITableViewCell makeSubCell:tableView withSubvalue:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue1:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj]  andNum:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            
            NSString *cellIdentifier = @"nodata_Cell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            cell.textLabel.text = @"本项目没有通过许可的施工时间安排";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    else if(indexPath.section == 2){
        
        NSDictionary *dicTmp = [_workFlowListArr objectAtIndex:_workFlowListArr.count-indexPath.row-1];
        NSString *process = [NSString stringWithFormat:@"%@",[dicTmp objectForKey:@"BZMC"]];
        NSString *signature = [NSString stringWithFormat:@"%@ / %@",[dicTmp objectForKey:@"YHM"],[[dicTmp objectForKey:@"CJSJ"] substringToIndex:16]];
        NSString *opinion = [NSString stringWithFormat:@"%@",[dicTmp objectForKey:@"CLRYJ"]];
        
        if ([opinion isEqualToString:@""]&&[[dicTmp objectForKey:@"DQZT"] isEqualToString:@"Underway"]) {
            
            opinion = @"办理中";
        }
        cell = [UITableViewCell makeSubCell:tableView Title:process Opinion:opinion Signature:signature];
    }
    
    return cell;
    
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSInteger height;
 if (indexPath.section == 0) {
 height = 36;
 }
 else{
 height = 44*3;
 }
 return height;
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 UITableViewCell *cell;
 if (indexPath.section == 0) {
 if (_constructionTimeArr.count>0)
 {
 NSDictionary *tmpDic = [_constructionTimeArr objectAtIndex:indexPath.row];
 NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
 NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
 
 
 cell = [UITableViewCell makeSubCell:tableView withSubvalue:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue1:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj]];
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 }
 else
 {
 
 NSString *cellIdentifier = @"nodata_Cell";
 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 if (cell == nil)
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
 
 cell.textLabel.text = @"本项目没有通过许可的施工时间安排";
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 }
 
 }
 else if(indexPath.section == 1){
 
 NSDictionary *dicTmp = [_workFlowListArr objectAtIndex:indexPath.row];
 NSString *process = [NSString stringWithFormat:@"%@",[dicTmp objectForKey:@"BZMC"]];
 NSString *signature = [NSString stringWithFormat:@"%@ / %@",[dicTmp objectForKey:@"YHM"],[[dicTmp objectForKey:@"CJSJ"] substringToIndex:16]];
 NSString *opinion = [NSString stringWithFormat:@"%@",[dicTmp objectForKey:@"CLRYJ"]];
 
 if ([opinion isEqualToString:@""]&&[[dicTmp objectForKey:@"DQZT"] isEqualToString:@"Underway"]) {
 
 opinion = @"办理中";
 }
 cell = [UITableViewCell makeSubCell:tableView
 Title:process
 Opinion:opinion
 Signature:signature];
 }
 
 return cell;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if ([indexPath section] == 1 && bHave) {
     
     AttachmentViewController *childView = [[AttachmentViewController alloc] initWithNibName:@"AttachmentViewController" bundle:nil];
     [childView setCode:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"BH"]];
     [childView setAttachmentName:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"FJMC"]];
     [childView setAttachmentType:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"FJLX"]];
     [childView setNLinkerType:1];
     [self.navigationController pushViewController:childView animated:YES];
     [childView release];
     }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [networkQueue release];
    [_tetailTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTetailTable:nil];
    [super viewDidUnload];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    NSRange range = [resultJSON rangeOfString:@"流转成功"];
    
    if (range.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"办理成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10;
        [alert show];
        [alert release];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10;
        [alert show];
        [alert release];
    }
    
    
}


- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败,请检查网络连接并重试。"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
