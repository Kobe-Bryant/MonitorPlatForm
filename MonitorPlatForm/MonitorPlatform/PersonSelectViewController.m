//
//  PersonSelectViewController.m
//  EvePad
//
//  Created by yushang on 11-3-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonSelectViewController.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@implementation PersonSelectViewController
//@synthesize delegate;
@synthesize action;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"通讯录";
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
	if ([action.selectedUsersAry  containsObject:userName]) {
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
	
	NSString *userName = [action.UserNameAry objectAtIndex:indexPath.row];
	if ([action.selectedUsersAry  containsObject:userName]) {
		[action.selectedUsersAry  removeObject:userName];
	} else {
		[action.selectedUsersAry  addObject:userName];
	}
	[tableView reloadData];
  }


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[action release];
    [super dealloc];
}


@end

