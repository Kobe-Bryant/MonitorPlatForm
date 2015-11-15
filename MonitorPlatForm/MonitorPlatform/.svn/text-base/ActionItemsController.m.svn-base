//
//  ActionItemsController.m
//  EvePad
//
//  Created by chen on 11-7-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionItemsController.h"
#import "HandleActionController.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"
extern MPAppDelegate *g_appDelegate;

@implementation ActionItemsController

@synthesize actionAry,baseInfoXML,delegate,currentParsedData,gwGUID,webHelper;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle
- (void)getActions
{	
    NSString *param = [WebServiceHelper createParametersWithKey:@"gwSign" 
                                                          value:gwGUID,nil];
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
    
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"GetActions" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webHelper runAndShowWaitingView:self.view];
    
    
    
}

-(void)processWebData:(NSData*)webData{
    //NSLog(@"date 2 %@",[NSDate date]);
	//NSLog(@"3 DONE. Received Bytes: %d", [webData length]);
	//NSMutableString *theXML = [[NSMutableString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"%@",theXML);
    //清除Array
	[actionAry removeAllObjects];
    tmpActionItem = nil;
	nParserStatusFather = -1;
    nParserStatus = 0;
	NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData] autorelease];
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

#define PARSER_Actions     2
#define PARSER_Action     21
#define PARSER_Users      211

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if (nParserStatusFather == -1) {
		if( [elementName isEqualToString:@"Actions"])
		{
			nParserStatusFather = PARSER_Actions;
		}
	}
	else if (nParserStatusFather == PARSER_Actions) {
		if( [elementName isEqualToString:@"Action"])
		{
			tmpActionItem = [[ActionItem alloc] init];			
		}
		else if( tmpActionItem && [elementName isEqualToString:@"Users"]){
			tmpActionItem.UserIDAry = [NSMutableArray arrayWithCapacity:20];
			tmpActionItem.UserNameAry = [NSMutableArray arrayWithCapacity:20];
			tmpActionItem.UserDepartmentNameAry = [NSMutableArray arrayWithCapacity:20];
			tmpActionItem.selectedUsersAry = [NSMutableArray arrayWithCapacity:20];
			tmpActionItem.handled = NO;
			nParserStatus= PARSER_Users;			
		}			
	}
    
}



-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(nParserStatusFather >=0)
		[currentParsedData appendString:string];
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if(nParserStatusFather == PARSER_Actions){
		if( [elementName isEqualToString:@"Actions"])
		{
			nParserStatusFather = -1;
		} 
		else if([elementName isEqualToString:@"Action"]) {
			[actionAry addObject:tmpActionItem];
			[tmpActionItem release];
			tmpActionItem = nil;
		}
		
		if (tmpActionItem) {
			if (nParserStatus != PARSER_Users) {
				if( [elementName isEqualToString:@"Name"]) {
					
					tmpActionItem.Name = [currentParsedData copy];
				}
				else if([elementName isEqualToString:@"ActionID"]) {
					tmpActionItem.ActionID = [currentParsedData copy];
				}
				else if([elementName isEqualToString:@"Type"]) {
					tmpActionItem.Type = [currentParsedData copy];
				}
				else if([elementName isEqualToString:@"ToTaskID"]) {
					tmpActionItem.ToTaskID = [currentParsedData copy];
				}
				else if([elementName isEqualToString:@"ActionType"]) {
					tmpActionItem.ActionType = [currentParsedData copy];
				}
				
			}		
			else{
				if([elementName isEqualToString:@"ID"]) {
					[tmpActionItem.UserIDAry addObject:[currentParsedData copy]];
				}
				else if([elementName isEqualToString:@"Name"]) {
					[tmpActionItem.UserNameAry addObject:[currentParsedData copy]];
				}
				else if([elementName isEqualToString:@"DepartmentName"]) {
					[tmpActionItem.UserDepartmentNameAry addObject:[currentParsedData copy]];
				}
				else if([elementName isEqualToString:@"Users"]) {
					nParserStatus = -1;
				}
			}
		}
        
	}	
	
	[currentParsedData setString:@""];
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------start--------------");
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"办理方法";
    actionAry = [[NSMutableArray alloc] initWithCapacity:5];
    currentParsedData = [[NSMutableString alloc] initWithCapacity:100];
    [self getActions];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [actionAry count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	ActionItem *aItem = [actionAry  objectAtIndex:indexPath.row];
	cell.textLabel.text = aItem.Name;
    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    HandleActionController *detailViewController = [[HandleActionController alloc] init];
    detailViewController.action = [actionAry objectAtIndex:indexPath.row];
	detailViewController.baseInfoXML= baseInfoXML;
	detailViewController.parentController = self;
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [actionAry release];
	[baseInfoXML release];
    [super dealloc];
}


@end

