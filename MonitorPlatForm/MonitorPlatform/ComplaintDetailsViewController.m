//
//  ComplaintDetailsViewController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ComplaintDetailsViewController.h"
#import "AttachmentViewController.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "HandlePassViewController.h"
#import "ReturnBackViewController.h"
#import "ZrsUtils.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation ComplaintDetailsViewController
@synthesize attachments,caseProcessAry,nDataType,webservice;
@synthesize complaintNum,orgid,detailsTable,bHave,processCode;
@synthesize title1,title2,value1,value2,nParserStatus,cellHeightAry;
@synthesize isChangeUser,changeUserID;

#define nBaseData 1
#define nProcessData 2
#define nAttachmentData 3

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#pragma mark - Private methods

- (void)getBaseWebData
{
    self.nParserStatus = nBaseData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_XFTS_DETAIL" forKey:@"service"];
    [param setObject:complaintNum forKey:@"xfxh"];
    [param setObject:orgid forKey:@"orgid"];
    [param setObject:_stepNum forKey:@"bzbh"];
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}



- (void)getProcessWebData
{
    self.nParserStatus = nProcessData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_XFTS_WORKFLOW_LIST" forKey:@"service"];
    [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lcbh"];
    [param setObject:complaintNum forKey:@"xfxh"];
    [param setObject:orgid forKey:@"orgid"];
   
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}

- (void)getAttachmentsWebData
{
    self.nParserStatus = nAttachmentData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_XFTS_FILE_LIST" forKey:@"service"];
    [param setObject:processCode forKey:@"lcslbh"];
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}


- (IBAction)HandlePassing:(id)sender 
{
    HandlePassViewController *childView = [[HandlePassViewController alloc] initWithNibName:@"HandlePassViewController" bundle:nil];
    
    [childView setLetterVisitNum:complaintNum];
    [childView setNLinker:1];
    childView.isChangeUser = isChangeUser;
    childView.changeUserID = changeUserID;
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

- (IBAction)GetBack:(id)sender 
{
    ReturnBackViewController *childView = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    
    [childView setLetterVisitNum:complaintNum];
    [childView setNLinker:1];
    childView.isChangeUser = isChangeUser;
    childView.changeUserID = changeUserID;
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}


- (void)hasRead:(id)sender{
    //来文已阅
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"WORKFLOW_TRANSITION_AUTO" forKey:@"service"];
    [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"LCBH"];
    [param setObject:[_readInfoDic objectForKey:@"LCSLBH"] forKey:@"LCSLBH"];
    [param setObject:[_readInfoDic objectForKey:@"BZDYBH"] forKey:@"BZDYBH"];
    [param setObject:_stepNum forKey:@"BZBH"];
    [param setObject:changeUserID forKey:@"processer"];
    [param setObject: [_readInfoDic objectForKey:@"TYPE"] forKey:@"processType"];
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    isDealWithRead = YES;//当前为办理已阅读
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
    
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    if (isDealWithRead) {
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
        return;
    }
    
    self.nDataType = nDataNormal;
    
    //异常或无数据的处理
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[resultJSON objectFromJSONString]];
    
    
    if ([resultArray count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"请求数据失败,请检查网络连接并重试。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    
    }
    
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    NSArray *keys = [resultDic allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"COUNT"]) {
            self.nDataType = nDataNone;
            break;
        }
        if ([key isEqualToString:@"exception"]) {
            self.nDataType = nDataException;
            break;
        }
    }
    
    //如果是阅读改变导航栏按钮
    NSString * type = [resultDic objectForKey:@"TYPE"];
    if(type != nil){
        if ([type isEqualToString:@"READER"]) {
            
            
            UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithTitle:@"来文已阅" style:UIBarButtonItemStyleBordered  target:self action:@selector(hasRead:)];
            self.navigationItem.rightBarButtonItem = item2;
            [item2 release];
            self.readInfoDic = resultDic;
            
        }else{
            //各种控件初始化
            UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(HandlePassing:)];
            UIBarButtonItem *aItem2 = [[UIBarButtonItem alloc] initWithTitle:@"退回" style:UIBarButtonItemStyleBordered target:self action:@selector(GetBack:)];
            
            UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(600, 0, 160, 44)];
            [tools setTintColor:[self.navigationController.navigationBar tintColor]];
            [tools setAlpha:[self.navigationController.navigationBar alpha]];
            NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:8];
            [buttons addObject:aItem];
            [buttons addObject:aItem2];
            [aItem release];
            [aItem2 release];
            [tools setItems:buttons animated:NO];
            [buttons release];
            
            UIBarButtonItem *myBItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
            
            self.navigationItem.rightBarButtonItem = myBItem;
            [myBItem release]; 
            [tools release];
        }
    }
    

    if (nDataType == nDataException) {
        NSString *msg = [NSString stringWithFormat:@"访问错误,请联系信访系统维护人员"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    if (nDataType == nDataNone){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"案件并无详细数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    
    if (nParserStatus == nBaseData) 
    {   
        NSDictionary *reDic = [resultArray lastObject];
        
        self.title1 = [NSMutableArray arrayWithCapacity:10];
        self.title2 = [NSMutableArray arrayWithCapacity:10];
        self.value1 = [NSMutableArray arrayWithCapacity:10];
        self.value2 = [NSMutableArray arrayWithCapacity:10];
        
        [title1 addObject:@"处理期限:"];
        [value1 addObject:[reDic objectForKey:@"CLQX"]];
        [title2 addObject:@"应返天数:"];
        NSString *yfts = [reDic objectForKey:@"YFTS"] ? [NSString stringWithFormat:@"%@ 自然日",[reDic objectForKey:@"YFTS"]]:@"";
        [value2 addObject:yfts];
        
        [title1 addObject:@"处理部门:"];
        [value1 addObject:[reDic objectForKey:@"CLBM"]];
        [title2 addObject:@"所属城区:"];
        [value2 addObject:[reDic objectForKey:@"SSCQ"]];
        
        [title1 addObject:@"受理类别:"];
        [value1 addObject:[reDic objectForKey:@"SLLB"]];
        [title2 addObject:@"来源行业:"];
        [value2 addObject:[reDic objectForKey:@"LYHY"]];
        
        [title1 addObject:@"受理方式:"];
        [value1 addObject:[reDic objectForKey:@"SLFS"]];
        [title2 addObject:@"方式子类:"];
        [value2 addObject:[reDic objectForKey:@"FSZL"]];
        
        [title1 addObject:@"受理时间:"];
        NSString *slsj = [reDic objectForKey:@"SLSJ"];
        if ([slsj length] > 10)
            slsj = [slsj substringToIndex:10];
        [value1 addObject:slsj];
        [title2 addObject:@"投诉时间:"];
        NSString *tssj = [reDic objectForKey:@"TSSJ"]?[reDic objectForKey:@"TSSJ"]:@"";
        if ([tssj length] > 10)
            tssj = [tssj substringToIndex:10];
        [value2 addObject:tssj];
        
        [title1 addObject:@"投诉次数:"];
        [value1 addObject:[reDic objectForKey:@"TSCS"]];
        [title2 addObject:@"投诉人姓名:"];
        [value2 addObject:[reDic objectForKey:@"TSRXM"]];
        
        [title1 addObject:@"联系电话:"];
        [value1 addObject:[reDic objectForKey:@"LXDH"]];
        [title2 addObject:@"联系地址:"];
        [value2 addObject:[reDic objectForKey:@"LXDZ"]];
        
        [title1 addObject:@"被投诉单位:"];
        [value1 addObject:[reDic objectForKey:@"BTSDW"]];
        [title2 addObject:@"被投诉地址:"];
        [value2 addObject:[reDic objectForKey:@"BTSDZ"]];
        
        [title1 addObject:@"污染类型:"];
        [value1 addObject:[reDic objectForKey:@"WRLX"]];
        [title2 addObject:@"污染子类型:"];
        [value2 addObject:[reDic objectForKey:@"WRZLX"]];
        
        [title1 addObject:@"投诉内容:"];
        [value1 addObject:[reDic objectForKey:@"TSNR"]];
        
        [title1 addObject:@"调查情况:"];
        NSString *dcqk = [reDic objectForKey:@"DCQK"] ? [reDic objectForKey:@"DCQK"]:@"";
        [value1 addObject:dcqk];
        
        [title1 addObject:@"处理结果:"];
        NSString *cljg = [reDic objectForKey:@"CLJG"] ? [reDic objectForKey:@"CLJG"]:@"";
        [value1 addObject:cljg];
        
        if ([cellHeightAry count] > 0)
            [cellHeightAry removeAllObjects];
        

        CGFloat width = 768/2/5*3-20;

            
        
        for (int i = 0;i < [value2 count];i++)
        {
            NSString *valueStr1 = [value1 objectAtIndex:i];
            CGFloat height1 = [ZrsUtils calculateTextHeight:valueStr1 byFontSize:19 andWidth:width];
            NSString *valueStr2 = [value2 objectAtIndex:i];
            CGFloat height2 = [ZrsUtils calculateTextHeight:valueStr2 byFontSize:19 andWidth:width];
            if (height1 < height2)
                height1 = height2;
            [cellHeightAry addObject:[NSNumber numberWithFloat:height1]];
        }
        
        width = 768/10*8-20;
        
        for (int i = [value1 count] - 3 ; i < [value1 count] ; i++)
        {
            NSString *valueStr = [value1 objectAtIndex:i];
            CGFloat height = [ZrsUtils calculateTextHeight:valueStr byFontSize:19 andWidth:width];
            [cellHeightAry addObject:[NSNumber numberWithFloat:height]];
        }
        
        int nAttachment = [[reDic objectForKey:@"SFYFJ"] intValue];
        self.processCode = [reDic objectForKey:@"LCSLBH"];
        
        if (nAttachment == 1)
        {
            self.bHave = YES;
            [self getAttachmentsWebData];
        } else {
            self.bHave = NO;
            [self getProcessWebData];
        }
        
    } else if (nParserStatus == nAttachmentData) {
        
        [attachments addObjectsFromArray:resultArray];
        [self getProcessWebData];
        
    } else if (nParserStatus == nProcessData) {
        [caseProcessAry addObjectsFromArray:resultArray];
        [self.detailsTable reloadData];
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
    return;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"环境信访投诉详细信息";
    
    self.attachments = [NSMutableArray arrayWithCapacity:4];
    self.caseProcessAry = [NSMutableArray arrayWithCapacity:4];
    self.cellHeightAry = [NSMutableArray arrayWithCapacity:4];
    
   
    
    [self getBaseWebData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    
    [super viewWillDisappear:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.detailsTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc 
{
    [super dealloc];
    [detailsTable release];
    [attachments release];
    [caseProcessAry release];
    [complaintNum release];
    [orgid release];
    [title1 release];
    [title2 release];
    [value1 release];
    [value2 release];
    [processCode release];
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
    NSInteger count;
    if (section == 0) {
        count = [title1 count];
    } else if (section == 1 ) {
        if (bHave) 
            count = [attachments count];
        else 
            count = 1;
    } else {
        count = [caseProcessAry count];
    }
    return count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    
    NSString *headTitle;
    if (section == 0) {
        headTitle = @"基本信息";
    } else if (section == 1) {
        headTitle = @"附件信息";
    } else {
        headTitle = @"案件处理流程";
    }
    return headTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger height;
    if ([indexPath section] == 0) {
        height = [[cellHeightAry objectAtIndex:indexPath.row] floatValue];
        
    } else if ([indexPath section] == 1) {
        height = 88;
    } else {
        height = 44*3;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    UITableViewCell *cell;
    
    if (section == 0) {
        CGFloat cellHeight = [[cellHeightAry objectAtIndex:row] floatValue];
        if (row < [title2 count]) {
            
            NSArray *valueAry = [NSArray arrayWithObjects:[title1 objectAtIndex:row],[value1 objectAtIndex:row],[title2 objectAtIndex:row],[value2 objectAtIndex:row], nil];
            cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:cellHeight valueArray:valueAry];
            
        } else {
            
            NSArray *valueAry = [NSArray arrayWithObjects:[title1 objectAtIndex:row],[value1 objectAtIndex:row], nil];
            
            cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:1 cellHeight:cellHeight valueArray:valueAry];
        }
        
    } else if (section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"attachment_cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"attachment_cell"] autorelease];
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19];
        cell.textLabel.numberOfLines = 0;
        if (bHave) {
            cell.textLabel.text = [[attachments objectAtIndex:row] objectForKey:@"FJMC"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString *fileName = [[attachments objectAtIndex:row] objectForKey:@"FJMC"];
            if([fileName hasSuffix:@".doc"])
            {
                cell.imageView.image = [UIImage imageNamed:@"doc_file"];
            }
            else if([fileName hasSuffix:@".xls"])
            {
                cell.imageView.image = [UIImage imageNamed:@"xls_file"];
            }
            else if([fileName hasSuffix:@".rar"])
            {
                cell.imageView.image = [UIImage imageNamed:@"rar_file"];
            }
            else if([fileName hasSuffix:@".pdf"])
            {
                cell.imageView.image = [UIImage imageNamed:@"pdf_file"];
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"default_file"];
            }
        } else {
            cell.textLabel.text = @"暂无附件";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone; 
        } 
    } else {
            NSDictionary *dicTmp = [caseProcessAry objectAtIndex:row];
            NSString *process = [NSString stringWithFormat:@"%@",[dicTmp objectForKey:@"BZMC"]];
            NSString *signature = [NSString stringWithFormat:@"%@ / %@",[dicTmp objectForKey:@"CLR"],[[dicTmp objectForKey:@"CLSJ"] substringToIndex:16]];
        
            cell = [UITableViewCell makeSubCell:tableView 
                                          Title:process 
                                        Opinion:[dicTmp objectForKey:@"CLRYJ"] 
                                      Signature:signature]; 
    }
    
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1 && bHave) {
        
        AttachmentViewController *childView = [[AttachmentViewController alloc] initWithNibName:@"AttachmentViewController" bundle:nil];
        [childView setCode:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"BH"]];
        [childView setAttachmentName:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"FJMC"]];
        [childView setAttachmentType:[[attachments objectAtIndex:[indexPath row]] objectForKey:@"FJLX"]];
        [childView setNLinkerType:1];
        [self.navigationController pushViewController:childView animated:YES];
        [childView release];
    }
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
}
@end
