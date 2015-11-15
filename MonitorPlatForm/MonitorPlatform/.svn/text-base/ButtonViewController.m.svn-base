//
//  ButtonViewController.m
//  Eve
//
//  Created by yushang on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonViewController.h"
#import "MainMenuViewController.h"
#import "CustomBadge.h"
@implementation ButtonViewController
@synthesize parent, lblTitle,btnNamesAry,pageTitle,aryBadgeViews;


-(void)toggleFrom:(id)sender {
	//UIButton* btn = (UIButton*) sender;
    
	[(MainMenuViewController*)parent toggleFromByPage:page ByIndex: [sender tag]];
}

- (id)initWithButtonsAry:(NSArray*)btnsAry 
                andTitle:(NSString*)title
              andPageNum:(NSInteger)pageNum{
	page = pageNum;
    [self initWithNibName:@"ButtonViewController" bundle:nil];
    self.pageTitle = title;
    self.btnNamesAry = btnsAry;
    return self;
}

-(void)updateBadgesWithOaCount:(NSInteger)oaCount andXfCount:(NSInteger)xfCount andChufaCount:(NSInteger)chufaCount andZaoShengCount:(NSInteger)zaoshengCount{
    int btnsIndex[8] = {0,1,2,3,4,5,6,7};
    int countIndex[4]={oaCount,xfCount,chufaCount,zaoshengCount};
    if (aryBadgeViews) {
        for (UIView* aView in aryBadgeViews) {
            [aView removeFromSuperview];
        }
        [aryBadgeViews removeAllObjects];
    }
    else{
        self.aryBadgeViews = [NSMutableArray arrayWithCapacity:5];
    }
    
    for (int i = 0;i < 8;i++) {

        if (i%2 == 0){
            NSString *strNumber = [NSString stringWithFormat:@"%d",countIndex[i/2]];
        
            if(strNumber != nil && [strNumber intValue] > 0){
            CustomBadge *badge1 = [CustomBadge customBadgeWithString:strNumber 
                                                     withStringColor:[UIColor whiteColor] 
                                                      withInsetColor:[UIColor redColor] 
                                                      withBadgeFrame:YES 
                                                 withBadgeFrameColor:[UIColor whiteColor] 
                                                           withScale:1.0
                                                         withShining:YES];
            
                [badge1 setFrame:CGRectMake(btn[btnsIndex[i]].frame.origin.x+ btn[btnsIndex[i]].frame.size.width-badge1.frame.size.width, btn[btnsIndex[i]].frame.origin.y-badge1.frame.size.height*1/3, badge1.frame.size.width, badge1.frame.size.height)];  
                [self.view addSubview:badge1];
                [aryBadgeViews addObject:badge1];
            } 
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
	self.view.backgroundColor = [UIColor clearColor];
    lblTitle.text  = pageTitle;
	int w = 110, h = 110;
	int n = 4;
	int span = (768 - n * w) / (n + 1);
    
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        n = 5;
        span = (1024 - n * w) / (n + 1);
        self.lblTitle.frame = CGRectMake(0, 83, 1024, 42);
    }

    if(btnNamesAry == nil  ) return;
	int count = [btnNamesAry count];
	for (int i = 0; i < count; i++) {

		btn[i]=[[UIButton alloc] initWithFrame:
		CGRectMake(span + (span + w) * (i % n), 
				   span + (span + h) * (i / n) + 100,
				   w, h)];
		btn[i].tag = i ;

		btn[i].backgroundColor = [UIColor clearColor];
		NSString *s = [NSString stringWithFormat:@"mc_%d_%d.png", page + 1, i + 1];
        if ([UIImage imageNamed:s] == nil) {
            s = @"btn_default.png";
        }
		[btn[i] setBackgroundImage:[UIImage imageNamed:s] forState:UIControlStateNormal];
	
		
		[btn[i] addTarget:self action:@selector(toggleFrom:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn[i]];
		//[btn[i] release];
		
		UILabel *btnLabel = [[UILabel alloc] initWithFrame:
					CGRectMake(span + (span + w) * (i % n), 
								span + (span + h) * (i / n) + 80 +w,
								w, 50)];
		btnLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		btnLabel.numberOfLines = 2;
		btnLabel.text = [btnNamesAry objectAtIndex:i];
		btnLabel.textAlignment = UITextAlignmentCenter;
		btnLabel.backgroundColor = [UIColor clearColor];
		[self.view addSubview:btnLabel];
        [btnLabel release];
		//[btnLabel release];
	}
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	for (int i = 0; i < [btnNamesAry count]; i++) {
		[btn[i] release];
	}
}


- (void)dealloc {
    [btnNamesAry release];
    [aryBadgeViews release];
    [pageTitle release];
    [lblTitle release];
    
    [super dealloc];
}


@end
