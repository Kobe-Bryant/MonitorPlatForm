//
//  HaveDoneOAController.m
//  ShenChaOA
//
//  Created by 王 哲义 on 12-5-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "HaveDoneOAController.h"
#import "UITableViewCell+Custom.h"
#import "ToDoOADetailController.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@implementation HaveDoneOAController
@synthesize aryItems;
@synthesize curParsedData;
@synthesize webHelper;
@synthesize titleLbl;
@synthesize sendDateLbl,psLabel;
@synthesize titleFie;
@synthesize sendDateFie;
@synthesize resultTable,searchBtn;
@synthesize popController,dateController;

#pragma mark - Private methods

-(void)setLandscape
{
    self.resultTable.frame = CGRectMake(0, 146, 1024, 558);
    self.titleLbl.frame = CGRectMake(295, 20, 100, 31);
    self.sendDateLbl.frame = CGRectMake(295, 59, 100, 31);
    self.titleFie.frame = CGRectMake(398, 20, 260, 31);
    self.sendDateFie.frame = CGRectMake(398, 59, 260, 31);
    self.searchBtn.frame = CGRectMake(677, 20, 53, 70);
    self.psLabel.frame = CGRectMake(316, 106, 393, 31);
}

-(void)setPortrait
{
    self.resultTable.frame = CGRectMake(0, 146, 768, 814);
    self.titleLbl.frame = CGRectMake(167, 20, 100, 31);
    self.sendDateLbl.frame = CGRectMake(167, 59, 100, 31);
    self.titleFie.frame = CGRectMake(270, 20, 260, 31);
    self.sendDateFie.frame = CGRectMake(270, 59, 260, 31);
    self.searchBtn.frame = CGRectMake(549, 20, 53, 70);
    self.psLabel.frame = CGRectMake(188, 106, 393, 31);
}

-(void)getInitialItemsList
{
	
	totalRow = -1;
	totalPage = -1;
    
	bUpdateFlag = YES;
	currentPageIndex = 1;
    
    titleFie.text = @"";
    
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24*10 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    sendDateFie.text = [dateFormatter stringFromDate:fromDate];
    [dateFormatter release];
	[self getYiBan];	
}

- (IBAction)searchButtonPressed:(id)sender
{
    if ([sendDateFie.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入查询的起始日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    //点击按钮取消键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    totalRow = -1;
	totalPage = -1;
    
	bUpdateFlag = YES;
	currentPageIndex = 1;
    
	[self getYiBan];
}

- (void)getYiBan
{
    if (bUpdateFlag == YES) {
        [aryItems removeAllObjects];
        bUpdateFlag = NO;
    }
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"user" value:g_appDelegate.userPinYinName,@"titlekey",titleFie.text,@"date",sendDateFie.text, nil];
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
    
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                     method:@"searchresult" 
                                                  nameSpace:@"http://tempuri.org/"
                                                 parameters:param 
                                                   delegate:self] autorelease];
	[webHelper runAndShowWaitingView:self.view];
}

- (IBAction)touchFromDate:(id)sender {
    UITextField *tfd =(UITextField*)sender;
    
    self.sendDateFie.text = @"";
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];  
        self.sendDateFie.text = dateString;
    }
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

- (void)dealloc
{
    [emptyView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    aryItems = [[NSMutableArray alloc] initWithCapacity:50];
    self.curParsedData = [NSMutableString string];

	self.title = @"已办公文查询";
    
    emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
    emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	[date release];	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:dateController];	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
	//popController.delegate = self; 
	[popover release];
	[navDate release];
    
    [self getInitialItemsList];
    
    //[self setPortrait];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
    
    if (popController)
        [popController dismissPopoverAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
/*	if (totalRow >0 && totalRow == [aryItems count]) {
		return totalRow;
	}*/
    return [aryItems count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	UITableViewCell* cell = nil;
	
	int index = [indexPath row];
	if (index < [aryItems count])
    {
        ToDoOAItem *aItem = [aryItems objectAtIndex:index];

        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HaveDone_listCell"] autorelease];
        
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
		cell.textLabel.text = aItem.title;
        
		if ( [aItem.fileType isEqualToString:@"发文"])
        {
			cell.imageView.image = [UIImage imageNamed:@"批办.png"];
		}
        else if ([aItem.fileType isEqualToString:@"收文"])
        {
			cell.imageView.image = [UIImage imageNamed:@"阅读.png"];
		}
        else
        {
			cell.imageView.image = [UIImage imageNamed:@"公告.png"];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    /*
    else
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"] autorelease];
		if(isLoading)
			cell.textLabel.text = @"正在下载数据...";
		else
			cell.textLabel.text = @"更多...";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}*/
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int index = [indexPath row];
	if (index < [aryItems count])
    {
		ToDoOADetailController *detailViewController = [[ToDoOADetailController alloc] initWithNibName:@"ToDoOADetailController" bundle:nil];
        detailViewController.isDone = YES;
		detailViewController.aItem = [aryItems objectAtIndex:index];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	} 
    else 
    {
		currentPageIndex++;
		[self getYiBan];
	}
    
}
/*
#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	if (totalRow <= [aryItems count])
		return;
	
	NSIndexPath *index = [NSIndexPath indexPathForRow:currentPageIndex *PageSize inSection:0];
	UITableViewCell* cell = [self.resultTable cellForRowAtIndexPath:index];
	//NSLog(@"scrollViewDidScroll %d %f %f %f",currentPageIndex *PageSize,
	//	  scrollView.contentOffset.y,,cell.frame.origin.y);
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
		isLoading = YES;
		
		cell.textLabel.text = @"正在获取更多数据";
		
        currentPageIndex++;
		[self getYiBan];
    }
}
*/
#pragma mark - URL ConneHelp delegate

-(void)processWebData:(NSData*)webData{
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

#pragma mark - NSXML parser delegate
#define PARSER_MessageItemGuid 0
#define PARSER_Title 1
#define PARSER_GenerateDate 2
#define PARSER_FromDispName 3
#define PARSER_FileType 4
#define PARSER_TotalPage 5
#define PARSER_TotalRow  6

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	//NSLog(@"4 parser didStarElemen: namespaceURI: attributes:");
    if([elementName isEqualToString:@"DocumentForSearchResult"])
    {
        tmpTodoItem = [[ToDoOAItem alloc] init];
    }
	else if( [elementName isEqualToString:@"ID"])
	{
		nParserStatus = PARSER_MessageItemGuid;
	} 
	else if( [elementName isEqualToString:@"Title"])
	{
		nParserStatus = PARSER_Title;
	}
	else if( [elementName isEqualToString:@"SendTime"])
	{
		nParserStatus = PARSER_GenerateDate;
	}
	else if( [elementName isEqualToString:@"Sender"])
	{
		nParserStatus = PARSER_FromDispName;
	}
	else if( [elementName isEqualToString:@"FileCategory"])
	{
		nParserStatus = PARSER_FileType;
	}
    /*
	else if( [elementName isEqualToString:@"TotalPage"])
	{
		nParserStatus = PARSER_TotalPage;
	}
	else if( [elementName isEqualToString:@"TotalRow"])
	{
		nParserStatus = PARSER_TotalRow;
	}*/
	else 
	{
		nParserStatus = -1;
	}
	
	
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//NSLog(@"5 parser: foundCharacters:");
	if(nParserStatus >= 0)
		[curParsedData appendString:string];
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	NSString* test;
    // if(nParserStatus != -1 ){
    switch (nParserStatus) {
        case PARSER_MessageItemGuid:
            if (tmpTodoItem != Nil) tmpTodoItem.guid = [NSString stringWithString:curParsedData];
            break;
        case PARSER_Title:
            if (tmpTodoItem != Nil) tmpTodoItem.title = [NSString stringWithString:curParsedData];
            break;
        case PARSER_GenerateDate:	
            //张仁松添加
            //2011-03-31T13:13:54.52+08:00
            if ([curParsedData length] >= 16) {
                test = [NSString stringWithFormat:@"%@ %@",
                        [curParsedData substringToIndex:10],
                        [curParsedData substringWithRange:NSMakeRange(11, 5)]];
                
            }
            else {
                test =[NSString stringWithString:curParsedData];
            }
            
            if (tmpTodoItem != Nil) tmpTodoItem.generateDate = test;
            break;
        case PARSER_FromDispName:			
            if (tmpTodoItem != Nil) tmpTodoItem.fromPerson = [NSString stringWithString:curParsedData];
            break;
        case PARSER_FileType:			
            if (tmpTodoItem != Nil) tmpTodoItem.fileType =[NSString stringWithString:curParsedData];
            break;
       /* case PARSER_TotalPage:			
            totalPage = [curParsedData intValue];
            break;
        case PARSER_TotalRow:			
            totalRow = [curParsedData intValue];
            break;*/
        default:
            if (tmpTodoItem != Nil&&[elementName isEqualToString:@"DocumentForSearchResult"]) {
                [aryItems addObject:tmpTodoItem];
                [tmpTodoItem release];
            }
            break;
    }	
    // }
    
	
	[curParsedData setString:@""];
	nParserStatus = -1;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//NSLog(@"-------------------start--------------");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = NO;
    if(aryItems.count <= 0)
    {
        emptyView.hidden = NO;
        resultTable.hidden = YES;
        return;
    }
    else
    {
        emptyView.hidden = YES;
        resultTable.hidden = NO;
        [self.resultTable reloadData];
    }
    
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
