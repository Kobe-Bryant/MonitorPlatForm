//
//  QueryBuildingDeptVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "QueryBuildingDeptVC.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation QueryBuildingDeptVC
@synthesize resultAry,dmzAry,gxgsValue;
@synthesize webservice,wordsPopover,wordSelectCtrl;
@synthesize isLoading,currentPage,totalPages,isScroll;

#pragma mark - Private methods

- (void)requestData
{
    scrollImage.hidden = YES;
    isLoading = YES;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"QUERY_SGDW_INFO_LIST" forKey:@"service"];
    [param setObject:@"20" forKey:@"pageSize"];
    [param setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    
    if ([gxgsFie.text length] > 0)
        [param setObject:gxgsValue forKey:@"gxgs"];
    if ([dwxxFie.text length] > 0)
        [param setObject:dwxxFie.text  forKey:@"dwxx"];
    
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    currentPage = 1;
    isScroll = NO;
    [self requestData];
}

- (void)selectWord:(id)sender
{
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    
    wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"深圳市人居环境委员会",@"深圳市水源保护区办公室",@"福田区环保局",@"罗湖区环保局",@"南山区环保局",@"盐田区环保局",@"宝安区环保局",@"龙岗区环保局",@"光明新区城建局",@"坪山新区环保局", nil];
    
    [wordSelectCtrl.tableView reloadData];
    [wordsPopover presentPopoverFromRect:[fie bounds] inView:fie permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [resultAry release];
    [dmzAry release];
    [gxgsValue release];
    [webservice release];
    [wordsPopover release];
    [wordSelectCtrl release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dmzAry = [NSArray arrayWithObjects:@"440301",@"440309",@"440304",@"440303",@"440305",@"440308",@"440306",@"440307",@"440302",@"440310", nil];
        self.resultAry = [NSMutableArray array];
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
    
    self.title = @"施工单位信息查询";
    
    //管辖归属可选功能初始化
    [gxgsFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:wordSelectCtrl];
    self.wordsPopover = popCtrl;
    [wordCtrl release];
    [popCtrl release];
    
    //获取默认数据
    gxgsFie.text = @"深圳市人居环境委员会";
    self.gxgsValue = @"440301";
    currentPage = 1;
    isScroll = NO;
    [self requestData];
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
    
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [listTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    gxgsFie.text = words;
    self.gxgsValue = [dmzAry objectAtIndex:row];
    
    [wordsPopover dismissPopoverAnimated:YES];
}

#pragma mark - URL connhelper delegate 

-(void)processWebData:(NSData*)webData 
{     
    isLoading = NO;
    if([webData length] <=0 )  
        return;    
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];  
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];   
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];   
    NSArray *oneAry = [str objectFromJSONString];
    NSMutableArray *tmpAry = [NSMutableArray arrayWithArray:oneAry]; 
    
    
    NSDictionary *tmpDic = [tmpAry objectAtIndex:0];  
    NSArray *keyAry = [tmpDic allKeys];  
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {
            currentPage = 0;
            totalPages = 0;
            
            [resultAry removeAllObjects];
            [listTable reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];   
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {         
        NSDictionary *pageDic = [tmpAry lastObject];
        
        currentPage = [[pageDic objectForKey:@"currentPage"] intValue];
        totalPages = [[pageDic objectForKey:@"pageCount"] intValue]; 
        
        [tmpAry removeLastObject];
        
        if (!isScroll)
            [resultAry removeAllObjects];
        
        [resultAry addObjectsFromArray:tmpAry];
        
        if ([tmpAry count] == 20)
            scrollImage.hidden = NO;
        else
            scrollImage.hidden = YES;
        
        [listTable reloadData];
    }
}   

- (void)processError:(NSError *)error 
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                    message:@"请求数据失败,请检查网络连接并重试。" 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil]; 
    [alert show];   
    [alert release]; 
    return; 
} 

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (currentPage <= totalPages) {
            isScroll = YES;
            [self requestData];
        }
        else
        {
            [scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        }
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - Table View Data Source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *tmpDic = [resultAry objectAtIndex:index];
    NSString *gcxmmc = [tmpDic objectForKey:@"SGDWMC"];
    NSString *jsdw = [NSString stringWithFormat:@"单位地址：%@",[tmpDic objectForKey:@"SGDWDZ"]];
    NSString *sgdw = [NSString stringWithFormat:@"联系电话：%@",[tmpDic objectForKey:@"SGDWLXDH"]];
    NSString *sgcddz = [NSString stringWithFormat:@"法人代表：%@",[tmpDic objectForKey:@"SGDWFRDB"]];
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:gcxmmc andSubvalue1:jsdw andSubvalue2:sgdw andSubvalue3:sgcddz andSubvalue4:@"" andNoteCount:index];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
