    //
//  OpinionViewController.m
//  EvePad
//
//  Created by chen on 11-7-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpinionViewController.h"
#import "QQList.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@implementation OpinionViewController
@synthesize opinion,delegate,origOpinion;
@synthesize jyyBtn,cyyjBtn,ljcBtn,zwmcBtn;
@synthesize bcmbBtn,cleanBtn,saveBtn,cancelBtn;

@synthesize wordsSelectViewController,wordsPopoverController,myTableView;
@synthesize currentParsedData,departDic,departNameAry;
@synthesize curDepartID,curPersonName,curDepartName;
@synthesize load,webHelper,backgrandView;
@synthesize opinionSelectVC,opinionPopover;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark - Private methods

- (void)setLandscape
{
    self.myTableView.frame = CGRectMake(4, 11, 310, 587);
    signature.frame = CGRectMake(458, 326, 228, 31);
    self.load.frame = CGRectMake(129, 627, 192, 30);
    self.opinion.frame = CGRectMake(357, 73, 626, 209);
    self.jyyBtn.frame = CGRectMake(399, 388, 130, 36);
    self.cyyjBtn.frame = CGRectMake(399, 435, 130, 36);
    self.zwmcBtn.frame = CGRectMake(588, 435, 130, 36);
    self.ljcBtn.frame = CGRectMake(588, 388, 130, 36);
    self.bcmbBtn.frame = CGRectMake(775, 388, 130, 36);
    self.cleanBtn.frame = CGRectMake(775, 435, 130, 36);
    self.saveBtn.frame = CGRectMake(399, 485, 130, 36);
    self.cancelBtn.frame = CGRectMake(588, 485, 130, 36);
    self.backgrandView.image = [UIImage imageNamed:@"opinionLandscape_bg.png"];
}

- (void)setPortrait
{
    self.myTableView.frame = CGRectMake(2, 8, 285, 808);
    signature.frame = CGRectMake(424, 322, 228, 31);
    self.load.frame = CGRectMake(100, 862, 192, 30);
    self.opinion.frame = CGRectMake(327, 62, 404, 226);
    self.jyyBtn.frame = CGRectMake(365, 381, 130, 36);
    self.cyyjBtn.frame = CGRectMake(365, 428, 130, 36);
    self.zwmcBtn.frame = CGRectMake(365, 475, 130, 36);
    self.ljcBtn.frame = CGRectMake(548, 382, 130, 36);
    self.bcmbBtn.frame = CGRectMake(548, 428, 130, 36);
    self.cleanBtn.frame = CGRectMake(549, 475, 129, 36);
    self.saveBtn.frame = CGRectMake(366, 525, 126, 36);
    self.cancelBtn.frame = CGRectMake(548, 525, 130, 36);
    self.backgrandView.image = [UIImage imageNamed:@"opinionPortrait_bg.png"];
}

- (IBAction)backgroundTap:(id)sender {
	[opinion resignFirstResponder];
	//[self getDown];
}

-(IBAction)jingYongYuBtnPressed:(id)sender{
	UIButton* btn = (UIButton*) sender;
	BOOL focus = NO;
	focus = [opinion isFirstResponder];
	if (!focus) {
		[opinion becomeFirstResponder];		
	}
	
	NSArray *ary = [NSArray arrayWithObjects:@"请", @"让", @"至", nil];	
	wordsSelectViewController.wordsForIfPass = NO;
	wordsSelectViewController.wordsAry = ary;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

//常用意见存储路径
-(NSString*)usualOpinionpath{
	NSString* documentsDirectory  = [NSHomeDirectory() 
									 stringByAppendingPathComponent:@"Documents//"];
	
	//NSString *filePath = [[[NSString alloc] initWithFormat:@"%@%@",documentsDirectory,@"usual_opinion.config"] autorelease];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"usual_opinion.config"];

	//return [filePath retain];
    return filePath;
	
}

//人员列表存储路径
-(NSString*)personListpath{
	NSString* documentsDirectory  = [NSHomeDirectory() 
									 stringByAppendingPathComponent:@"Documents//"];
	
	//NSString *filePath = [[[NSString alloc] initWithFormat:@"%@%@",documentsDirectory,@"personlist.config"] autorelease];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"personlist.plist"];
	//NSLog(@"%@",filePath);
    return filePath;
	//return [filePath retain];
	
}
//personlist.plist Dictionary的key

-(NSString*)personListKeypath{
	NSString* documentsDirectory  = [NSHomeDirectory() 
									 stringByAppendingPathComponent:@"Documents//"];
	
	//NSString *filePath = [[[NSString alloc] initWithFormat:@"%@%@",documentsDirectory,@"personlist.config"] autorelease];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"personlist_key.plist"];
	//NSLog(@"%@",filePath);
    return filePath;
	//return [filePath retain];
	
}

-(IBAction)changYongYiJianBtnPressed:(id)sender{
	UIButton* btn = (UIButton*) sender;
	BOOL focus = NO;
	focus = [opinion isFirstResponder];
	if (!focus) {
		[opinion becomeFirstResponder];		
	}
	
	NSString *filePath = [self usualOpinionpath];
	NSArray *ary =[NSArray arrayWithContentsOfFile:filePath];
	if (ary == nil || [ary count] == 0) {
		ary =[NSArray arrayWithObjects:@"同意。",@"已阅。",@"请局领导传阅。",@"不同意。",  nil];
		[ary writeToFile:filePath atomically:YES];
	}

	opinionSelectVC.wordsAry = [NSMutableArray arrayWithArray:ary];
	[opinionSelectVC.tableView reloadData];
	[self.opinionPopover presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(IBAction)lianJieCiBtnPressed:(id)sender{
	UIButton* btn = (UIButton*) sender;
	BOOL focus = NO;
	focus = [opinion isFirstResponder];
	if (!focus) {
		[opinion becomeFirstResponder];		
	}
	
	NSArray *ary = [NSArray arrayWithObjects:@"阅处", @"阅办",@"阅示",@"跟进", @"办理", @"先提出意见", @"研究",  @"会签",
			  nil];
	
	wordsSelectViewController.wordsForIfPass = NO;
	wordsSelectViewController.wordsAry = ary;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(IBAction)zhiWuMingChenBtnPressed:(id)sender{
	UIButton* btn = (UIButton*) sender;
	BOOL focus = NO;
	focus = [opinion isFirstResponder];
	if (!focus) {
		[opinion becomeFirstResponder];		
	}
	
	NSArray *ary =[NSArray arrayWithObjects:@"局长",@"副局长",@"副巡视员",@"处长",@"副处长",@"主任",@"副主任",nil];
	
	wordsSelectViewController.wordsForIfPass = NO;
	wordsSelectViewController.wordsAry = ary;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
	
    if([opinion.text length] <= 0){
        opinion.text = words;
    }else{
        //定位光标
        NSRange range = [opinion selectedRange];
        NSMutableString *top = [[NSMutableString alloc] initWithString:[opinion text]];
        NSString *addName = [NSString stringWithFormat:@"%@",words];
        [top insertString:addName atIndex:range.location];
        opinion.text = top;
        [top release];
        int opLoaction = [addName length] + range.location ;
        opinion.selectedRange = NSMakeRange(opLoaction, 0);
    }
    	
	if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
	
}

-(IBAction)cancelModify:(id)sender{
	 [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)toModify:(id)sender{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy'年'MM'月'dd'日'"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    
    int Length = [opinion.text length];
    int timeLength = [timeString length];
    NSMutableString *text = [NSMutableString string];;
    
    if (Length>=timeLength) 
    {
        int  opinionLength = Length - 11;
        NSString *text1 = [opinion.text substringFromIndex:opinionLength];
        if ([text1 isEqualToString:timeString]) {
            [text appendString:opinion.text];
        }
        else
        {
            [text appendFormat:@"%@    %@%@",opinion.text,g_appDelegate.userCNName,timeString];
        }
        
    }
    else if([opinion.text isEqualToString:@""]||[opinion.text isEqualToString:@"在此录入意见"])
    {
        [text setString:@""];
    }
    else
    {
        [text appendFormat:@"%@     %@%@",opinion.text,g_appDelegate.userCNName,timeString];
    }        
    
    [delegate returnModifiedWords:text];
    [formatter release];
    
}

-(IBAction)clearOpinionText:(id)sender{
	opinion.text = @"";
    
  
}

-(IBAction)saveAndGoBack:(id)sender{
    hasSave = YES;
    [self toModify:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancelAndGoBack:(id)sender{
    hasSave = YES;
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveTemplate:(id)sender{
    
    if ([opinion.text length] == 0 || [opinion.text isEqualToString:@"在此录入意见"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先输入意见！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *filePath = [self usualOpinionpath];
        NSArray *ary =[NSArray arrayWithContentsOfFile:filePath];
        if (ary == nil || [ary count] == 0) {
            ary =[NSArray arrayWithObjects:@"同意。",@"已阅。",@"请局领导传阅。",@"不同意。",  nil];
            [ary writeToFile:filePath atomically:YES];
        }
        NSMutableArray *newAry = [NSMutableArray arrayWithArray:ary];
        BOOL isEqual = NO;
        for (NSString *oldItem in newAry) 
        {
            if ([opinion.text isEqualToString:oldItem]) {
                isEqual = YES;
            }
        }
        if (!isEqual) {
            [newAry addObject:opinion.text];
            [newAry writeToFile:filePath atomically:YES];
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存意见模版成功，在常用意见弹出窗体中可以找到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
        } 
        else
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见模版已存在，无需保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
        }
    }
}

-(IBAction)refreshPersonLists:(id)sender{
	//封装soap请求消息
    load.enabled =NO;
    
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
    
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                     method:@"GetUserInfo" 
                                                  nameSpace:@"http://tempuri.org/"
                                                 parameters:@"" 
                                                   delegate:self] autorelease];
	[webHelper runAndShowWaitingView:self.view];
	
    
	self.departDic = [NSMutableDictionary dictionaryWithCapacity: 15];
	self.departNameAry = [NSMutableArray arrayWithCapacity: 15];
	self.currentParsedData = [NSMutableString stringWithCapacity
                              :15];
}


- (void) loadQQData
{
	NSDictionary *dicPersons = [NSDictionary dictionaryWithContentsOfFile:[self personListpath]];
	NSArray *keysAry = [NSArray  arrayWithContentsOfFile:[self personListKeypath]];
	if (dicPersons == nil || [dicPersons count] ==0 ) {
		[self refreshPersonLists:nil];
	}
	else {
		[lists removeAllObjects];
		int departCount = [dicPersons count];
		// 仔细看数据结构怎么定义的
		//NSArray *keys = [dicPersons allKeys];
		for (int i=0; i<departCount; i++) {
			NSArray *personAry =  [dicPersons objectForKey:[keysAry objectAtIndex:i]];
			QQList *list = [[[QQList alloc] init] autorelease];
			list.m_nID = i; //  分组依据
			list.m_strGroupName = [keysAry objectAtIndex:i];
			list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
			///////////////////////////////////////////////////////////////fix
			list.opened = NO;
			list.indexPaths = [[[NSMutableArray alloc] init] autorelease];
			///////////////////////////////////////////////////////////////fix
			int personCount = [personAry count];
			for (int j = 0; j < personCount; j++) 
			{
				QQPerson *person = [[[QQPerson alloc] init] autorelease];
				person.m_nListID = i; //  分组依据	
				person.m_strPersonName = [personAry objectAtIndex:j];
				
				[list.m_arrayPersons addObject:person];
				///////////////////////////////////////////////////////////////fix
				[list.indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i]];
				///////////////////////////////////////////////////////////////fix
			}
			[lists addObject:list];
		}
	}
	[self.myTableView reloadData];
}

#pragma mark - View life cycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'年'MM'月'dd'日'"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [signature setText:[NSString stringWithFormat:@"%@%@",g_appDelegate.userCNName,timeStr]];
    
	opinion.font = [UIFont fontWithName:@"Helvetica" size:19.0];
	
	CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
	tmpController.contentSizeForViewInPopover = CGSizeMake(320, 400);
	tmpController.delegate = self;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
	
	[tmpController release];
    [tmppopover release];
    
    self.opinionSelectVC = [[[UsualOpinionVC alloc] initWithStyle:UITableViewStylePlain] autorelease];
    opinionSelectVC.contentSizeForViewInPopover = CGSizeMake(320, 480);
	opinionSelectVC.delegate = self;
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:opinionSelectVC] autorelease];
    self.opinionPopover = [[[UIPopoverController alloc] initWithContentViewController:nav] autorelease];
    
	lists =[[NSMutableArray alloc] init];
	
	[self performSelector:@selector(loadQQData)];
	//去除空格 换行符
	self.origOpinion = [origOpinion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//NSLog(@"len = %d aa%@cc",[origOpinion length],origOpinion);
	if ([origOpinion isEqualToString:@""]) {
		opinion.text = @"在此录入意见";
	}
	else
		opinion.text = origOpinion;
    
    [self setPortrait];
	
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{	
    [super viewDidAppear:animated];

        
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [departDic release];
	[departNameAry release];
	[currentParsedData release];
	[opinion release];
	[origOpinion release];
	[wordsPopoverController release];
	[wordsSelectViewController release];
    [super dealloc];
}


#define HEADER_HEIGHT 59

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return HEADER_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [lists count]; // 分组数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	QQList *persons = [lists objectAtIndex:section];
	if ([persons opened])
    {
		return [persons.m_arrayPersons count]; // 人员数
        
		
	}else {
		return 0;	// 不展开
	}
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	QQList *persons = [lists objectAtIndex:section];
	
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.myTableView.bounds.size.width, HEADER_HEIGHT) 
																				title:persons.m_strGroupName 
																			  section:section 
																			   opened:persons.opened
                                                                             delegate:self];
    [sectionHeadView setBackgroundWithPortrait:@"cellBG_type1.png" andLandscape:@"cellBG_type1.png"];
	return [sectionHeadView autorelease];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	QQList *persons = [lists objectAtIndex:indexPath.section];
    QQPerson *person = [persons.m_arrayPersons objectAtIndex:indexPath.row];

	[cell textLabel].text = person.m_strPersonName;	
	[cell textLabel].font = [UIFont boldSystemFontOfSize:19.0];
		
    return cell;
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
    persons.opened = !persons.opened;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [myTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0) 
    {
        ///////////////////////////////////////////////////////////////fix
		//        persons.indexPaths = [[NSMutableArray alloc] init];
		//        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
		//            [persons.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        ///////////////////////////////////////////////////////////////fix
		
        [self.myTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 展开+动画 (如果不需要动画直接reloaddata)
    ///////////////////////////////////////////////////////////////fix
	//if(persons.indexPaths){
    if ([persons.m_arrayPersons count] > 0)
    {
		[self.myTableView insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	//persons.indexPaths = nil;
    ///////////////////////////////////////////////////////////////fix
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    if([opinion.text length] <= 0){
        opinion.text = cell.textLabel.text;
    }else{
        BOOL focus = NO;
        focus = [opinion isFirstResponder];
        if (!focus) {
            [opinion becomeFirstResponder];		
        } 
        //定位光标
        NSRange range = [opinion selectedRange];
        NSMutableString *top = [[NSMutableString alloc] initWithString:[opinion text]];
        NSString *addName = [NSString stringWithString:cell.textLabel.text];
        [top insertString:addName atIndex:range.location];
        opinion.text = top;
        [top release];
        int opLoaction = [addName length] + range.location ;
        opinion.selectedRange = NSMakeRange(opLoaction, 0);
    }
    
	
	if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    
}


-(void)processWebData:(NSData*)webData{
    
    nParserStatus = -1;
    load.enabled = YES;
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败。";
    
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

#define TAG_UM_NAME 1
#define TAG_UM_DEPT 2
#define TAG_BMMC    3

/*  
 <TmpName>
 <UM_NAME>刘忠朴</UM_NAME>
 <UM_DEPT>00</UM_DEPT>
 <BMMC>局领导</BMMC>
 </TmpName>
 */

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"UM_NAME"]){
		nParserStatus = TAG_UM_NAME;
	}
	else if( [elementName isEqualToString:@"BMMC"]){
		nParserStatus = TAG_BMMC;
	}
	else 
		nParserStatus = -1;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if(nParserStatus >=0)
		[currentParsedData appendString:string];	
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
	if(nParserStatus == TAG_UM_NAME)
	{
		if( [elementName isEqualToString:@"UM_NAME"]){
			self.curPersonName = currentParsedData;
		}
		
	}
	else if(nParserStatus == TAG_BMMC)
	{
		if( [elementName isEqualToString:@"BMMC"]){
			self.curDepartName = currentParsedData;
		}		
	}
	else {
		if( [elementName isEqualToString:@"TmpName"]){
			 NSMutableArray *personAry = [departDic objectForKey:curDepartName];
			 if (personAry) {
				 [personAry addObject:curPersonName];
			 }
			else {
				personAry = [[NSMutableArray alloc] initWithObjects:curPersonName,nil];
				
				[departDic setObject:personAry forKey:curDepartName];
				[personAry release];
				
				[departNameAry addObject:curDepartName];
			}

		}
	}

	nParserStatus = -1;
	[currentParsedData setString:@""];
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser{
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	
	BOOL bRes = [departDic writeToFile:[self personListpath] atomically:YES];
	if (bRes) {
		//NSLog(@"OK");
	}
	
	[departNameAry  writeToFile:[self personListKeypath] atomically:YES];
    
	[self loadQQData];
	
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([opinion.text isEqualToString:@"在此录入意见"])
        opinion.text = @"";
}

#pragma mark - UsualOpinion delegate

- (void)returnSelectedOpinion:(NSString *)words
{
    if([opinion.text length] <= 0)
        opinion.text = words;
    else{
        //定位光标
        NSRange range = [opinion selectedRange];
        NSMutableString *top = [[NSMutableString alloc] initWithString:[opinion text]];
        NSString *addName = [NSString stringWithFormat:@"%@",words];
        [top insertString:addName atIndex:range.location];
        opinion.text = top;
        [top release];
        int opLoaction = [addName length] + range.location ;
        opinion.selectedRange = NSMakeRange(opLoaction, 0);
    }
    
    if (opinionPopover)
        [opinionPopover dismissPopoverAnimated:YES];
}

- (void)refreshUsualOpinions:(NSArray *)opinionsAry
{
    NSString *filePath = [self usualOpinionpath];
    [opinionsAry writeToFile:filePath atomically:YES];
}

@end
