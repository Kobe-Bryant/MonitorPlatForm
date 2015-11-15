//
//  ZFXXListViewController.m
//  MonitorPlatform
//
//  Created by apple on 13-6-7.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "ZFXXListViewController.h"
#import "ZfrwDataModel.h"

@interface ZFXXListViewController ()

@end

@implementation ZFXXListViewController

@synthesize wrybh, emptyView;

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
    [resTableView release];
    [zfrw release];
    [scrollView release];
    [emptyView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"工程执法信息表";
    
    emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
    emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    scrollView = [[UIImageView alloc] initWithFrame:CGRectMake(184, 860, 400, 100)];
    scrollView.image = [UIImage imageNamed:@"upScroll.png"];
    [self.view addSubview:scrollView];
    scrollView.hidden = YES;
    
    resTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-20-44)];
    [self.view addSubview:resTableView];
    
    
    zfrw = [[ZfrwDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView andImageView:scrollView];
    [zfrw requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
