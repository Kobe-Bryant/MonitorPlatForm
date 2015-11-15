    //
//  PopupYearMonthViewController.m
//  EPad
//
//  Created by chen on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopupYearMonthViewController.h"


@implementation PopupYearMonthViewController
@synthesize delegate,myPicker;

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
-(IBAction)saveDate:(id)sender{
    NSInteger year = [myPicker selectedRowInComponent:0]+2000;
    NSInteger month = [myPicker selectedRowInComponent:1]+1;
	[delegate popupController:self Saved:YES selectedYear:year andMonth:month];
}


-(IBAction)cancelDate:(id)sender{
	
	[delegate popupController:self Saved:NO selectedYear:0 andMonth:0];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 260.0);
    
	UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 216)];

	[self.view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow:12 inComponent:0 animated:YES];
	self.myPicker = picker;
	[picker release];
	
	UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
									style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDate:)];
    
    self.navigationItem.leftBarButtonItem = aButtonItem;
	[aButtonItem release];
	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered 
																	target:self action:@selector(saveDate:)];
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;
	[aButtonItem2 release];
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0)return 50;
    else return 12;
}


#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d年",row+2000];
                
    }else{
         return [NSString stringWithFormat:@"%d月",row+1];
    }
        
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (void)dealloc {
	[myPicker release];
    [super dealloc];
}


@end
