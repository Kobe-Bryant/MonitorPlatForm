//
//  NoiseAllowViewController.m
//  MonitorPlatform
//
//  Created by ihumor on 13-2-28.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "NoiseAllowViewController.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "LoginedUsrInfo.h"
#import "ServiceUrlString.h"
#import "NoiseTastDetailViewController.h"

extern MPAppDelegate *g_appDelegate;

@interface NoiseAllowViewController ()
@property (nonatomic,retain) NSArray *infoArr;
@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic,assign) int nDataType;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int totalPages;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) BOOL isScroll;

@end

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

@implementation NoiseAllowViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    if (_hasDone) {
        self.title = @"已办噪声许可任务列表";
    }
    else{
        self.title = @"噪声许可任务列表";
    }
    
    self.currentPage = 1;
    self.totalPages = 0;
    self.isScroll = NO;
    [_scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
}
- (void)refreshData{
    
    [self getWebData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (_webservice)
        [_webservice cancel];
    
    [super viewWillDisappear:YES];
}


#pragma mark - private methods

- (void)getWebData
{
    _scrollImage.hidden = YES;
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"GET_RWCX_LIST" forKey:@"service"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    [param setObject:@"44030100006" forKey:@"lclxbh"];
    if (_hasDone) {
        [param setObject:@"0" forKey:@"sfdqbz"];
    }
    else{
        [param setObject:@"1" forKey:@"sfdqbz"];
    }
    if (_currentPage > 0)
        [param setObject:[NSString stringWithFormat:@"%d",_currentPage] forKey:@"currentPage"];
    [param setObject:@"50" forKey:@"pageSize"];
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    self.isLoading = YES;
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_infoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    NSDictionary *aItem = [_infoArr objectAtIndex:index];
    
    NSString *code = [NSString stringWithFormat:@"办理人：%@",[aItem objectForKey:@"YHM"]];
    NSString *phase = [NSString stringWithFormat:@"办理阶段：%@",[aItem objectForKey:@"BZMC"]];
    NSString *reason = @"";
    NSString *timeLimit = [NSString stringWithFormat:@"办理期限：%@",[aItem objectForKey:@"LCQX"]];
    NSArray *dateArr = [timeLimit componentsSeparatedByString:@" "];
    if (dateArr.count>=2) {
        timeLimit = [dateArr objectAtIndex:0];
    }
    NSString *titleStr = [NSString stringWithFormat:@"%@\n%@",[aItem objectForKey:@"B_DWMC"],[aItem objectForKey:@"LCMC"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView
                                               withTitle:titleStr
                                                caseCode:code
                                           complaintDate:phase
                                                 endDate:timeLimit
                                                    Mode:reason];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 1111) {
            [view removeFromSuperview];
        }
    }
    NSString *str = [aItem objectForKey:@"BZSYSJ"];
    if (!_hasDone) {
        if ([str intValue]>2)
            cell.imageView.image =  [UIImage imageNamed:@"a1.png"];
        else if ([str intValue]<=2 && [str intValue]>=0)
            cell.imageView.image =  [UIImage imageNamed:@"a3.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"a2.png"];
    }
    else{
        CGRect rect =CGRectMake(0, 3, 40, 72);;
        UILabel *lb = [[UILabel alloc] initWithFrame:rect];
        lb.text = [NSString stringWithFormat:@"%i、",indexPath.row+1];
        lb.tag = 1111;
        lb.textAlignment = UITextAlignmentCenter;
        lb.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lb];
        [lb release];
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (_isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        _currentPage++;
        
        if (_currentPage <= _totalPages) {
            _isScroll = YES;
            [self getWebData];
        }
        else
        {
            [_scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_infoArr objectAtIndex:indexPath.row];
    
    NoiseTastDetailViewController *detail = [[NoiseTastDetailViewController alloc] initWithNibName:@"NoiseTastDetailViewController" bundle:nil];
    detail.yhid = [dic objectForKey:@"YHBH"];
    detail.bwbhnew = [dic objectForKey:@"BH"];
    detail.ywxtbh = [dic objectForKey:@"YWXTBH"];
    detail.SFZB = [dic objectForKey:@"SFZB"];
    detail.BZDYBH  = [dic objectForKey:@"BZDYBH"];
    detail.BZBH = [dic objectForKey:@"BZBH"];
    detail.lclxbh = @"44030100006";
    detail.hasDone = _hasDone;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
    
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{    
    if([webData length] <=0 )
    {
        return;
    }
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
    self.nDataType = nDataNormal;
    
    //异常或无数据的处理
    NSArray *aryJson = [str objectFromJSONString];
    if(aryJson == nil||aryJson.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"未获取到相关数据。"
                              
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:aryJson];
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
    
    if (_nDataType == nDataNormal) {
        self.infoArr = [resultDic objectForKey:@"beans"];
        NSDictionary *pageInfoDic = [resultDic objectForKey:@"pageInfo"];
        _totalPages = [[pageInfoDic objectForKey:@"pageCount"]intValue];
        if(_totalPages == 0)
        {
            self.listTable.hidden = YES;
        
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
            [self.listTable.superview addSubview:bgView];
        
            UIImageView *emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
            emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
            [bgView addSubview:emptyView];
            [emptyView release];
            [bgView release];
        }
        [_listTable reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有未处理的处罚案件..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    _isLoading = NO;
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
    _isLoading = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_listTable release];
    [_scrollImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setListTable:nil];
    [self setScrollImage:nil];
    [super viewDidUnload];
}
@end
