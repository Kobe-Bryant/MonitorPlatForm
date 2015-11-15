//
//  MainRecordController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "MainRecordController.h"

#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "RecordDetailsController.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;
@implementation MainRecordController
@synthesize recordTable,defaultEndTime;
@synthesize infoAry,isGotJsonString;
@synthesize searchBtn,jzrqLab;
@synthesize webHelper,defaultStartTime,currentTag;
@synthesize dateController,scrollImage;
@synthesize webResultAry;
@synthesize isLoading,isScroll,currentPage,isEnd;

#define kTag_DWLX_Field 1 //单位类型
#define kTag_JGJB_Field 2 //监管级别

#pragma mark - Private methods

- (void)setLandscape
{
    self.dwmcFie.frame = CGRectMake(185, 20, 85, 31);
    self.dwmcFie.frame = CGRectMake(278, 20, 203, 31);
    self.dwdzFie.frame = CGRectMake(511, 20, 85, 31);
    self.dwdzFie.frame = CGRectMake(604, 20, 175, 31);
    self.dwlxFie.frame = CGRectMake(185, 66, 85, 31);
    self.dwlxFie.frame = CGRectMake(278, 66, 203, 31);
    self.jgjbFie.frame = CGRectMake(511, 66, 85, 31);
    self.jgjbFie.frame = CGRectMake(604, 66, 175, 31);
    self.searchBtn.frame = CGRectMake(799, 20, 41, 77);
}

- (void)setPortrait
{
    self.dwmcFie.frame = CGRectMake(57, 20, 85, 31);
    self.dwmcFie.frame = CGRectMake(150, 20, 203, 31);
    self.dwdzFie.frame = CGRectMake(383, 20, 85, 31);
    self.dwdzFie.frame = CGRectMake(476, 20, 175, 31);
    self.dwlxFie.frame = CGRectMake(57, 66, 85, 31);
    self.dwlxFie.frame = CGRectMake(150, 66, 203, 31);
    self.jgjbFie.frame = CGRectMake(383, 66, 85, 31);
    self.jgjbFie.frame = CGRectMake(476, 66, 175, 31);
    self.searchBtn.frame = CGRectMake(671, 20, 41, 77);
    
}

- (void)getWebDataWithPageCount:(int)page
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d",self.selectedJGJB] forKey:@"JGJB"];
    [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"P_CURRENT"];
    
    
    if(self.dwmcFie.text != nil && self.dwmcFie.text.length > 0)
    {
        [params setObject:self.dwmcFie.text forKey:@"WRYMC"];
    }
    //地址
    if(self.dwdzFie.text != nil && self.dwdzFie.text.length > 0)
    {
        [params setObject:self.dwdzFie.text forKey:@"WRYDZ"];
    }
    //单位类型
    if(self.dwlxFie.text != nil && self.dwlxFie.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedDWLX] forKey:@"dwlx"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    isLoading = YES;
    
    //NSLog(@"%@ %@", param, strUrl);
}

- (IBAction)selectWord:(id)sender
{
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    
    UITextField *field = (UITextField *)sender;
    field.text = @"";
    self.currentTag = field.tag;
    
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"工业",@"三产",@"市政设施",@"医疗机构",@"其他", nil];
            break;
        case kTag_JGJB_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"国控",@"省控",@"市控",@"区控",@"非控", nil];
            break;
        default:
            break;
    }
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:[field bounds] inView:field permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [self.dwmcFie resignFirstResponder];
    [self.dwdzFie resignFirstResponder];
    
    if(self.infoAry)
    {
        [self.infoAry removeAllObjects];
    }
    [self.recordTable reloadData];
    
    isScroll = NO;
    [self getWebDataWithPageCount:1];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    self.title = @"执法台账";
    
    self.scrollImage.hidden = YES;
    
    self.infoAry = [NSMutableArray array];
    
    self.wordSelectCtrl = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
    self.wordSelectCtrl.delegate = self;
    self.wordSelectCtrl.contentSizeForViewInPopover = CGSizeMake(320, 400);
    self.wordsPopover = [[UIPopoverController alloc]initWithContentViewController:self.wordSelectCtrl];
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    isLoading = YES;
    self.selectedJGJB = 1;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d",self.selectedJGJB]forKey:@"JGJB"];
    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [self.wordsPopover dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.dwlxFie.text = words;
            self.selectedDWLX = row;
            break;
        case kTag_JGJB_Field:
            self.jgjbFie.text = words;
            if(self.jgjbFie.text != nil && self.jgjbFie.text.length > 0)
            {
                if([words isEqualToString:@"国控"])
                {
                    self.selectedJGJB = 1;
                }
                else if([words isEqualToString:@"省控"])
                {
                    self.selectedJGJB = 2;
                }
                else if([words isEqualToString:@"市控"])
                {
                    self.selectedJGJB = 3;
                }
                else if([words isEqualToString:@"区控"])
                {
                    self.selectedJGJB = 4;
                }
                else if([words isEqualToString:@"非控"])
                {
                    self.selectedJGJB = 9;
                }
            }
            break;
    }
    
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData *)webData{
    isLoading = NO;
    NSString *curParsedData = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",curParsedData);
    [curParsedData release];
    
    if ([curParsedData length] > 0) {
        if (currentPage == 1)
            [self.infoAry removeAllObjects];
        NSDictionary *detailDict = [curParsedData objectFromJSONString];
        webResultAry = [detailDict objectForKey:@"data"];
        self.totalCount = [[detailDict objectForKey:@"totalCount"] intValue];
        [self.infoAry addObjectsFromArray:webResultAry];
        
        [self.recordTable reloadData];
        
    } else {
        
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
        }
        else{
            
            msg = @"没有符合查询条件的执法任务";
            [infoAry removeAllObjects];
            [recordTable reloadData];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)processError:(NSError *)error{
    isLoading = NO;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *tmpDic = [infoAry objectAtIndex:indexPath.row];
    //现场检查人  询问人
    NSString *person = [NSString stringWithFormat:@"企业地址：%@",[tmpDic objectForKey:@"DWDZ"]];
    NSString *remark = [tmpDic objectForKey:@"REMARK"];
    NSString *frdb = [NSString stringWithFormat:@"所属区县:%@",[tmpDic objectForKey:@"SZXZQ"]];
    NSString *jgjb = [NSString stringWithFormat:@"监管级别:%@", [tmpDic objectForKey:@"HBJGJB"]];
    cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"WRYMC"] andSubvalue1:person andSubvalue2:remark andSubvalue3:frdb andSubvalue4:jgjb andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [infoAry objectAtIndex:indexPath.row];
    RecordDetailsController *childView = [[[RecordDetailsController alloc] initWithNibName:@"RecordDetailsController" bundle:nil] autorelease];
    [childView setDataDic:tmpDic];
    
    [self.navigationController pushViewController:childView animated:YES];
}

#define ONE_PAGE_SIZE 25

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0 || self.totalCount <= 25)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        [self getWebDataWithPageCount:currentPage];
		
    }
}

@end
