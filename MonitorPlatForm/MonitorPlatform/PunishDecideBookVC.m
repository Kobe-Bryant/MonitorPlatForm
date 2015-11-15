//
//  PunishDecideBookVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PunishDecideBookVC.h" 
#import "UITableViewCell+Custom.h" 
#import "MPAppDelegate.h" 
#import "JSONKit.h" 
#import "ZrsUtils.h"  
#import "LoginedUsrInfo.h"

extern MPAppDelegate *g_appDelegate;  

@implementation PunishDecideBookVC 
@synthesize titleAry,valueAry,cellHeightAry;
@synthesize bwbh,webservice;  

#pragma mark - Private methods
- (void)requestData 
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    //NSString *userInfo = [NSString stringWithFormat:USER_INFO,usrInfo.userPinYinName,g_appDelegate.userPassWord];
    
    NSString *param = [NSString stringWithFormat:@"&lcbh=4e033baa-9bab-439f-b483-4ca632bea3dd&yhid=%@",usrInfo.userPinYinName];
    NSString *url = [NSString stringWithFormat:TJFZ_URL,g_appDelegate.javaServiceIp];
    NSString *requestString = [NSString stringWithFormat:@"%@&service=%@%@&bwbh=%@",url,@"GET_CFJDS_DETAIL",param,bwbh];
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    
}  

#pragma mark - View lifecycle  
- (void)dealloc 
{     
    [titleAry release];
    [valueAry release]; 
    [cellHeightAry release];
    [bwbh release];  
    [webservice release];   
    [super dealloc]; 
}  
- (id)initWithStyle:(UITableViewStyle)style 
{     
    self = [super initWithStyle:style];    
    if (self) 
    {         
        // Custom initialization     
    }     
    return self; 
}  

- (void)didReceiveMemoryWarning 
{     // Releases the view if it doesn't have a superview.     
    [super didReceiveMemoryWarning];   
    // Release any cached data, images, etc that aren't in use. 
}  

- (void)viewDidLoad 
{     
    [super viewDidLoad];     
    self.title = @"处罚决定书";   
     
    self.cellHeightAry = [NSMutableArray arrayWithCapacity:10];     
    [self requestData]; 
}  

- (void)viewDidUnload 
{     
    [super viewDidUnload]; 
    // Release any retained subviews of the main view. 
    // e.g. self.myOutlet = nil; 
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
    if (webservice)    
        [webservice cancel]; 
    [super viewWillDisappear:animated]; 
}  

- (void)viewDidDisappear:(BOOL)animated 
{     
    [super viewDidDisappear:animated];
}  

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{     // Return YES for supported orientations 
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}  

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{     
    [self.tableView reloadData];
}  

#pragma mark - URL connhelper delegate 

-(void)processWebData:(NSData*)webData 
{     
    if([webData length] <=0 )  
        return;    
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];  
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];   
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];    
    NSArray *resultAry = [str objectFromJSONString];  
    NSDictionary *tmpDic = [resultAry objectAtIndex:0];  
    NSArray *keyAry = [tmpDic allKeys];  
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {             
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该任务没有处罚决定书信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];*/
            
            UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
            [bgView setBackgroundColor:[UIColor whiteColor]];
            [self.tableView addSubview:bgView];
            UIImageView *emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
            emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
            [bgView addSubview:emptyView];
            [emptyView release];
            [bgView release];
            
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {         
        self.titleAry = [NSArray arrayWithObjects:@"违法条款",@"罚款金额(万元)",@"案情简介",@"备注",@"文件文号",@"文件正文", nil];   
        NSString *wftk = [tmpDic objectForKey:@"WFTK"];   
        NSString *cfje = [[tmpDic objectForKey:@"CFJE"] stringValue];  
        NSString *aqjj = [tmpDic objectForKey:@"AQJJ"];    
        NSString *bz = [tmpDic objectForKey:@"BZ"];      
        NSString *wjwh = [tmpDic objectForKey:@"WJWH"];   
        NSString *wjzw = [tmpDic objectForKey:@"JDSNR"];  
        wjzw = [wjzw stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];   
        self.valueAry = [NSArray arrayWithObjects:wftk,cfje,aqjj,bz,wjwh,wjzw,nil];  
        
        if ([cellHeightAry count] > 0)        
            [cellHeightAry removeAllObjects];  
        
        CGFloat width;     
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;  
        if (UIDeviceOrientationIsLandscape(orientation))       
            width = 1024/10*8-20;     
        else            
            width = 768/10*8-20;      
        
        for (NSString *value in valueAry)     
        {             
            CGFloat height = [ZrsUtils calculateTextHeight:value byFontSize:19 andWidth:width]; 
            [cellHeightAry addObject:[NSNumber numberWithFloat:height]];  
        }                
        
        [self.tableView reloadData];  
    }      
}   

- (void)processError:(NSError *)error 
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败,请检查网络连接并重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];   
    [alert release]; 
    return; 
} 

#pragma mark - Table view data source 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(indexPath.row%2 == 0)     
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}  

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{     
    return [valueAry count]; 
} 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 	
    CGFloat height; 
    if ([cellHeightAry count] > 0) 
    {        
        height = [[cellHeightAry objectAtIndex:indexPath.row] floatValue]; 
    } 
    else 
    {      
        height = 56; 
    }   
    return height; 
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{     
    UITableViewCell *cell;  
    NSString *title = [titleAry objectAtIndex:indexPath.row];  
    NSString *value = [valueAry objectAtIndex:indexPath.row];     
    NSArray *values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@:",title],value, nil]; 
    cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:1 cellHeight:[[cellHeightAry objectAtIndex:indexPath.row] floatValue] valueArray:values];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell; 
}   

#pragma mark - Table view delegate  
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{     
}  

@end 
