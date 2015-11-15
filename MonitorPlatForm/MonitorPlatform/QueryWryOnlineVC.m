//
//  QueryWryOnlineVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-30.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "QueryWryOnlineVC.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "JftzfDataVC.h"

extern MPAppDelegate *g_appDelegate;

@implementation QueryWryOnlineVC

@synthesize wordsPopover,wordSelectCtrl;
@synthesize currentTag,isGotJsonString;
@synthesize curParsedData,webHelper,webResultAry;
@synthesize datePopover,dateSelectCtrl;

#pragma mark - Private methods

- (void)requestData
{
    NSString *orgId = nil;
    if(![xzqhFie.text isEqualToString:@""] && xzqhFie.text != nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pl_wry_unit" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        orgId = [[dict objectForKey:@"values"] objectForKey:xzqhFie.text];
    }
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"strCSSJ" value:qsrqFie.text,@"strSJSJ",jsrqFie.text,@"strWRYMC",wryNameFie.text,@"strORGID",orgId,nil];
    NSString *URL = [NSString stringWithFormat:WRYPWSB_URL,g_appDelegate.xxcxServiceIP];
   
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                     method:@"Get_JFQK_ListNew" 
                                                  nameSpace:@"http://tempuri.org/" 
                                                 parameters:param 
                                                   delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [wryNameFie resignFirstResponder];
    [self requestData];
}

- (void)selectWord:(id)sender
{
    if (wordsPopover)
    {
        [wordsPopover dismissPopoverAnimated:YES];
    }
    
    
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    
    UIControl *btn = (UIControl *)sender;
    currentTag = btn.tag;
    
    NSString *plPath = [[NSBundle mainBundle] pathForResource:@"pl_wry_unit" ofType:@"plist"];
    NSDictionary *plDict = [NSDictionary dictionaryWithContentsOfFile:plPath];
    wordSelectCtrl.wordsAry = [plDict objectForKey:@"keys"];
    [wordSelectCtrl.tableView reloadData];
    
    [wordsPopover presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)selectDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
	[self.datePopover presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [wordsPopover release];
    [wordSelectCtrl release];
    [curParsedData release];
    [webHelper release];
    [webResultAry release];
    [datePopover release];
    [dateSelectCtrl release];
    [super dealloc];
}

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
    
    self.title = @"排污收费查询";
    //选择短语
    [xzqhFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:wordSelectCtrl];
    self.wordsPopover = popCtrl;
    [wordCtrl release];
    [popCtrl release];
    
    //选择日期
    [qsrqFie addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    [jsrqFie addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateSelectCtrl = date;
	self.dateSelectCtrl.delegate = self;
	[date release];	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:dateSelectCtrl];	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.datePopover = popover;
	//popController.delegate = self; 
	[popover release];
	[navDate release];
    
    //获取默认数据
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [formatter stringFromDate:[NSDate date]];
    NSArray *dateAry = [endDateStr componentsSeparatedByString:@"-"];
    NSString *fromDateStr = [NSString stringWithFormat:@"%@-01-01",[dateAry objectAtIndex:0]];
    qsrqFie.text = fromDateStr;
    jsrqFie.text = endDateStr;
    
    [self requestData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    [wordsPopover dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [resultTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Words delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    xzqhFie.text = words;
    [wordsPopover dismissPopoverAnimated:YES];
}

#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.datePopover dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];  
        
        if (currentTag == 5)
        {
            qsrqFie.text = dateString;
        }
        if (currentTag == 6)
        {
            jsrqFie.text = dateString;
        }
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
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

#pragma mark - NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Get_JFQK_ListNewResult"])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString) {
        [self.curParsedData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"Get_JFQK_ListNewResult"]) 
    {
        self.webResultAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    if ([curParsedData length] > 0) 
    {
        [resultTable reloadData];
    }
    else
    {
        [webResultAry removeAllObjects];
        [resultTable reloadData];
        NSString *msg = @"没有符合查询条件的缴费数据";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - Table View Data Source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    CGFloat totalWidth = 768;

    
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, 55)];
    view.backgroundColor = [UIColor whiteColor];
    NSArray *aryTitles = [NSArray arrayWithObjects:@"单位名称",@"总共应收(元)",@"缴费时段",@"缴费状态", nil];
    NSArray *widthAry = [NSArray arrayWithObjects:@"0.35",@"0.2",@"0.2",@"0.2",@"0.05", nil];
    CGFloat width = totalWidth*[[widthAry objectAtIndex:0] floatValue];
    CGRect tRect = CGRectMake(0, 0, width, 54);
    
    for (int i =0; i <= [aryTitles count]; i++)
    {
        width = totalWidth*[[widthAry objectAtIndex:i] floatValue];
        
        tRect.size.width = width;
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:17.0];
        label.textAlignment = UITextAlignmentRight;
        label.numberOfLines = 2;
        if (i<[aryTitles count])
            [label setText:[aryTitles objectAtIndex:i]];
        [view addSubview:label];
        [label release];
        
        tRect.origin.x += width;
  
    }
    view.backgroundColor = [UIColor colorWithRed:(0x50/255.0f) green:(0x8d/255.0f) blue:(0xd0/255.0f) alpha:1.000f];
    return [view autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [webResultAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *tmpDic = [webResultAry objectAtIndex:index];
    
    NSString *wrymc = [tmpDic objectForKey:@"污染源名称"];
    NSString *zgys = [tmpDic objectForKey:@"总共应收"];
    NSString *jfzt = [tmpDic objectForKey:@"缴费状态"];
    
    NSString *jfqsrq = [tmpDic objectForKey:@"缴费起始日期"];
    if ([jfqsrq length] > 10)
        jfqsrq = [jfqsrq substringToIndex:10];
    NSArray *jfDate = [jfqsrq componentsSeparatedByString:@"-"];
    NSString *jfsd = [NSString stringWithFormat:@"%@年%@月",[jfDate objectAtIndex:0],[jfDate objectAtIndex:1]];
    
    NSArray *valueAry = [NSArray arrayWithObjects:wrymc,zgys,jfsd,jfzt,@"", nil];
    
    NSString *cellIdentifier = @"cell_pwsfList";
    
    NSArray *widthAry = [NSArray arrayWithObjects:@"0.35",@"0.2",@"0.2",@"0.2",@"0.05", nil];
    
    UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueAry andWidths:widthAry andHeight:70 andIdentifier:cellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [webResultAry objectAtIndex:indexPath.row];
    
    JftzfDataVC *childVC = [[[JftzfDataVC alloc] initWithNibName:@"JftzfDataVC" bundle:nil] autorelease];
    childVC.tzsbh = [tmpDic objectForKey:@"通知书编号"];
    childVC.wrymc = [tmpDic objectForKey:@"污染源名称"];
    [self.navigationController pushViewController:childVC animated:YES];
}

@end
