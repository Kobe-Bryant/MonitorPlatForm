//
//  SFXXListViewController.m
//  MonitorPlatform
//
//  Created by apple on 13-6-7.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "SFXXListViewController.h"
#import "PwsfDataModel.h"

@interface SFXXListViewController ()

@end

@implementation SFXXListViewController

@synthesize wrybh,emptyView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.wrybh = nil;
    [resTableView release];
    [pwsf release];
    [emptyView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
    emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    resTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-20-44) style:UITableViewStylePlain];
    [self.view addSubview:resTableView];
    
    pwsf = [[PwsfDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView];
    [pwsf requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
