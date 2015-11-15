//
//  SearchWryController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-23.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "SearchWryController.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "WryJbxxController.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation SearchWryController
@synthesize nameField,addressField,areaField,streetField;
@synthesize isGotJsonString,curParsedData,resTableView,aryParsedItem;
@synthesize wordsSelectViewController,wordsPopoverController;
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

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    areaField.text = words;
    if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
}

-(IBAction)areaFieldPressed:(id)sender{
    
    
    UIControl *ctrl = (UIControl*)sender;
    
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:ctrl.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(IBAction)searchBtnPressed:(id)sender{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrymc" 
                                                          value:nameField.text,
                       @"wrydz",addressField.text,@"xzq",areaField.text, @"jd",streetField.text, nil];
    
    NSString *URL = [NSString stringWithFormat:WRYJBXX_URL,g_appDelegate.xxcxServiceIP];
    
	WebServiceHelper *webservice = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"GetCxwryJbxx" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webservice runAndShowWaitingView:self.view];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询污染源";
    CommenWordsViewController *tmpController = [[[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil] autorelease];
	tmpController.contentSizeForViewInPopover = CGSizeMake(220, 300);
	tmpController.delegate = self;
    
    tmpController.wordsAry = [NSArray arrayWithObjects:@"罗湖区",@"福田区",@"南山区",@"宝安区",@"龙岗区", @"盐田区",@"光明新区",@"坪山新区",@"其它", nil];
    
    
    UIPopoverController *tmppopover = [[[UIPopoverController alloc] initWithContentViewController:tmpController] autorelease];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)processWebData:(NSData*)webData{
   /* 
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);*/
    
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString stringWithCapacity:300];
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

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if( [elementName isEqualToString:@"GetCxwryJbxxResult"])
	{
		isGotJsonString = YES;
	} 
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( isGotJsonString)
	{
		[curParsedData appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(isGotJsonString&& [elementName isEqualToString:@"GetCxwryJbxxResult"]){
       // NSString *str =[curParsedData stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
       // NSString *str =[curParsedData stringByTrimmingCharactersInSet: [NSCharacterSet illegalCharacterSet]];
        NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
        NSString *str =[curParsedData stringByReplacingOccurrencesOfString:ctrlChar withString:@""]; 
        self.aryParsedItem = [str objectFromJSONString];
        
        [self.resTableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [aryParsedItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *tmpDic = [aryParsedItem objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"污染源简称:%@",[tmpDic objectForKey:@"污染源简称"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"污染源地址:%@",[tmpDic objectForKey:@"污染源地址"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WryJbxxController *controller = [[WryJbxxController alloc] initWithNibName:@"WryJbxxController" bundle:nil];
    NSDictionary *tmpDic = [aryParsedItem objectAtIndex:indexPath.row];
    controller.wrybh = [tmpDic objectForKey:@"污染源编号"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}
@end
