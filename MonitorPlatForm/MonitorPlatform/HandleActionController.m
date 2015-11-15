    //
//  HandleActionController.m
//  EvePad
//
//  Created by chen on 11-6-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HandleActionController.h"
#import "ActionItemsController.h"
#import "MPAppDelegate.h"
#import "WebServiceHelper.h"

extern MPAppDelegate *g_appDelegate;

@implementation HandleActionController
@synthesize action;
@synthesize sendBtn,myTableView,tmpSelectedUserIDAry;
@synthesize baseInfoXML;
@synthesize parentController,webHelper;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(IBAction)sendBtnPressed:(id)sender{
	action.selectedUsersAry = tmpSelectedUserIDAry;
	NSMutableString *submitXML = [[NSMutableString alloc] initWithString:baseInfoXML];

	[submitXML appendFormat:@"<Action actionid=\"%@\" actiontype=\"%@\" type=\"0\" "
	 "totaskid=\"%@\">",action.ActionID,action.ActionType,action.ToTaskID];
	if ([action.selectedUsersAry count] > 0) {
		for(NSString *userID in action.selectedUsersAry)
			[submitXML appendFormat:@"<User id=\"%@\"></User>",userID];
		
	}
	
	[submitXML appendString:@"</Action>"];
				
	[submitXML appendString:@"</流程相关></公文></root>]]>"];
	//NSLog(@"%@",submitXML);
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"dealgwxml" 
                                                          value:submitXML,
                       nil];
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
    
	self.webHelper= [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"ExecDealGW" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webHelper runAndShowWaitingView:self.view];

    [submitXML release];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor whiteColor];
	self.contentSizeForViewInPopover =  CGSizeMake(320, 400);
	
	
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame =  CGRectMake(35, 10, 250, 35);
	[btn setTitle:@"发送" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(sendBtnPressed:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	self.sendBtn = btn;
	[btn release];
	
	tmpSelectedUserIDAry = [[NSMutableArray alloc] initWithArray:action.selectedUsersAry];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 55, 290, 300)
											   style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	[self.view addSubview:myTableView];
	
	if ([action.UserNameAry count] > 0) {
		[self.myTableView setHidden:NO];
	}
	else {
		[self.myTableView setHidden:YES];
	}

	
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"人员选择";	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [action.UserNameAry count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *userName = [action.UserNameAry objectAtIndex:indexPath.row];
	cell.textLabel.text = userName;
	NSString *userID = [action.UserIDAry objectAtIndex:indexPath.row];
	
	if ([tmpSelectedUserIDAry containsObject:userID]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}	
	return cell;
}


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *userID = [action.UserIDAry objectAtIndex:indexPath.row];
	if ([action.ActionType intValue] == 1) {//多选
		if ([tmpSelectedUserIDAry  containsObject:userID]) {
			[tmpSelectedUserIDAry  removeObject:userID];
		} else {
			[tmpSelectedUserIDAry  addObject:userID];
		}
	}
	else {//单选
		[tmpSelectedUserIDAry  removeAllObjects];
		[tmpSelectedUserIDAry  addObject:userID];
	}

	[tableView reloadData];
}

-(void)processWebData:(NSData*)webData{
    
    NSMutableString *theXML = [[NSMutableString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
	[theXML replaceOccurrencesOfString:@"&lt;" withString:@"<" 
							   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [theXML length])];
	[theXML replaceOccurrencesOfString:@"&gt;" withString:@">" 
							   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [theXML length])];
	/*
    NSRange range = [theXML rangeOfString:@"服务器无法处理请求"];
    
    if (range.length >0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"办理公文失败,服务器无法处理请求..."
                              message:commitResult
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
     */
    
    NSData  *replacedData = [[[NSData alloc] initWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]] autorelease];

	[theXML release];
    commitResult = nil;
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: replacedData ] autorelease];
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{

	if( [elementName isEqualToString:@"ExecDealGWResponse"])
	{
		commitResult = [[NSMutableString alloc] initWithCapacity:50];
	}
	
}



-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

	if (commitResult) {
		[commitResult appendString:string];
	}

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

	
    if ([g_appDelegate.userCNName isEqualToString:@"陈钰瀚"]) 
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [parentController.delegate doneAndBack];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

	if( [elementName isEqualToString:@"ExecDealGWResponse"])
	{			
			if([commitResult length] > 0){
				
				UIAlertView *alert = [[UIAlertView alloc] 
									  initWithTitle:@"办理公文失败" 
									  message:commitResult 
									  delegate:nil 
									  cancelButtonTitle:@"确定" 
									  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] 
									  initWithTitle:@"提示" 
									  message:@"办理公文成功" 
									  delegate:nil
									  cancelButtonTitle:@"确定" 
									  otherButtonTitles:nil];
                [alert setDelegate:self];
				[alert show];
				[alert release];
				
				
			}
			
			
			[commitResult release];
			commitResult = nil;
	}
	
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"-------------------start--------------");
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
	[baseInfoXML release];
	[tmpSelectedUserIDAry release];
	[myTableView release];
	[action release];
    [super dealloc];
}


@end
