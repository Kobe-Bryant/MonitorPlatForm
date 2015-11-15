//
//  ToDoOAController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-10.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ToDoOAController.h"
#import "UITableViewCell+Custom.h"
#import "ToDoOADetailController.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation ToDoOAController

@synthesize aryItems;
@synthesize curParsedData,webHelper;

#pragma mark -
#pragma mark View lifecycle

//初始化数据并且获取第一页公文 
-(void)getInitialItemsList{
	
    if (isLoading)
    {
        return;
    }
	totalRow = -1;
	totalPage = -1;
    
	bUpdateFlag = YES;
	currentPageIndex = 1;
    [aryItems removeAllObjects];
    [self.tableView reloadData];
	[self getDaiBan];	
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //该步骤主要是任务做完返回来后自动刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInitialItemsList) name:@"doneBack" object:nil];
    
    aryItems = [[NSMutableArray alloc] initWithCapacity:50];
    self.curParsedData = [NSMutableString string];
	UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain
															 target:self
															 action:@selector(getInitialItemsList)];
	self.navigationItem.rightBarButtonItem = aItem;
	[aItem release];
	self.title = @"待办公文";
    isNone = NO;
    [self getInitialItemsList];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Override to allow orientations other than the default portrait orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (totalRow >0 && totalRow == [aryItems count]) {
		return totalRow;
	}
    return [aryItems count] + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int index = [indexPath row];
	if (index < [aryItems count])
    {
        ToDoOAItem *aItem = [aryItems objectAtIndex:index];
        UITableViewCell* cell = [UITableViewCell makeSubCell:tableView withTitle:aItem.title sender:aItem.fromPerson withDate:aItem.generateDate];
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
			cell.imageView.image = [UIImage imageNamed:@"默认.png"];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
	}
    else
    {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"] autorelease];
		if(isNone)
			cell.textLabel.text = @"没有相关数据...";
		else if(index == aryItems.count && index != 0)
			cell.textLabel.text = @"更多...";
        else
            cell.textLabel.text = @"正在加载数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	if (totalRow <= [aryItems count])
		return;
	
	NSIndexPath *index = [NSIndexPath indexPathForRow:currentPageIndex *PageSize inSection:0];
	UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:index];
	//NSLog(@"scrollViewDidScroll %d %f %f %f",currentPageIndex *PageSize,
   //	  scrollView.contentOffset.y,,cell.frame.origin.y);
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
		isLoading = YES;
		
		cell.textLabel.text = @"正在获取更多数据...";
		
        currentPageIndex++;
		[self getDaiBan];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int index = [indexPath row];

	if (index < [aryItems count]) {
		ToDoOADetailController *detailViewController = [[ToDoOADetailController alloc] initWithNibName:@"ToDoOADetailController" bundle:nil];
		
		detailViewController.aItem = [aryItems objectAtIndex:index];
        detailViewController.isDone = NO;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
        
	} else {
		currentPageIndex++;
		[self getDaiBan];
	}
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if(emptyView)
    {
        [emptyView removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [emptyView release];
	[curParsedData release];
	[aryItems release];
    [super dealloc];
}

#pragma mark - getDaiBan

- (void)getDaiBan
{
	
    if (bUpdateFlag == YES) {
        [aryItems removeAllObjects];
        bUpdateFlag = NO;
    }
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"userSign" 
                                        value:g_appDelegate.userPinYinName,
     @"offset",[NSString stringWithFormat:@"%d", currentPageIndex],
     @"rows",[NSString stringWithFormat:@"%d", PageSize], nil];
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
 
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"GetWaitTodo2" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webHelper run];
    isLoading = YES;
}

-(void)processWebData:(NSData*)webData
{
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error
{
    NSString *msg = @"请求数据失败。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    isLoading = NO;
}

/*
 <MessageItemGuid>string</MessageItemGuid>
 <Title>string</Title>
 <GenerateDate>dateTime</GenerateDate>
 <FromDispName>string</FromDispName>
 */

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
    if([elementName isEqualToString:@"Document"])
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
	else if( [elementName isEqualToString:@"FileType"])
	{
		nParserStatus = PARSER_FileType;
	}
	else if( [elementName isEqualToString:@"TotalPage"])
	{
		nParserStatus = PARSER_TotalPage;
	}
	else if( [elementName isEqualToString:@"TotalRow"])
	{
		nParserStatus = PARSER_TotalRow;
	}
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
                
                if (tmpTodoItem != Nil) tmpTodoItem.generateDate = test ;
                break;
            case PARSER_FromDispName:			
                if (tmpTodoItem != Nil) tmpTodoItem.fromPerson = [NSString stringWithString:curParsedData];
                break;
            case PARSER_FileType:			
                if (tmpTodoItem != Nil) tmpTodoItem.fileType = [NSString stringWithString:curParsedData];
                break;
            case PARSER_TotalPage:			
                totalPage = [curParsedData intValue];
                break;
            case PARSER_TotalRow:			
                totalRow = [curParsedData intValue];
                break;
            default:
                if (tmpTodoItem != Nil&&[elementName isEqualToString:@"Document"]) {
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
	//NSLog(@"-------------------end--------------");
    if ([aryItems count] == 0)
        isNone = YES;
    if(isNone)
    {
        self.tableView.hidden = YES;
        if(emptyView == nil)
        {
            emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
            emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
        }
        [self.view.window addSubview:emptyView];
        
    }
    isLoading = NO;
    [self.tableView reloadData];
}

@end


