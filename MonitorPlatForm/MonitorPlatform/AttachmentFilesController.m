//
//  AttachmentFilesController.m
//  EvePad
//
//  Created by chen on 11-7-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttachmentFilesController.h"


@implementation AttachmentFilesController
@synthesize fileAry,delegate;

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


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




- (void)viewWillDisappear:(BOOL)animated {
	
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return [fileAry count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    AttachFileItem *aItem = [fileAry objectAtIndex:indexPath.row];
    
    if([aItem.fileName hasSuffix:@".doc"])
    {
        cell.imageView.image = [UIImage imageNamed:@"doc_file"];
    }
    else if([aItem.fileName hasSuffix:@".xls"])
    {
        cell.imageView.image = [UIImage imageNamed:@"xls_file"];
    }
    else if([aItem.fileName hasSuffix:@".rar"])
    {
        cell.imageView.image = [UIImage imageNamed:@"rar_file"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"default_file"];
    }
    
    cell.textLabel.text = aItem.fileName;
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //[delegate OpenAttachFile:@"test" AtIndex:indexPath.row];
    AttachFileItem *aItem = [fileAry objectAtIndex:indexPath.row];
    [delegate openAttachFile:aItem];
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
    [super dealloc];
}


@end

