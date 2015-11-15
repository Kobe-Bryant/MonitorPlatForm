//
//  PersonChooseVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PersonChooseVC.h"
#import "DataSyncManagerEx.h"
#import "MBProgressHUD.h"

@interface PersonChooseVC ()
@property(nonatomic,strong)NSArray *aryDeparts;
@property(nonatomic,strong)NSArray *aryUsers;
@property(nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation PersonChooseVC
@synthesize aryDeparts,aryUsers,multiUsers,parentBMBH,delegate,aryChoosedPersons,refresh,HUD;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        usersHelper = [[UsersHelper alloc] init];
        
    }
    return self;
}

-(void)okBtnPressed:(id)sender{
    [delegate personChoosed:aryChoosedPersons];
}

-(void)refreshBtnPressed:(id)sender{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"正在同步数据，请稍候...";
    [HUD show:YES];
    [self.view addSubview:HUD];
    
    DataSyncManagerEx *syncManager = [[DataSyncManagerEx alloc] init];
    [syncManager syncAllTables:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFinished:) name:kNotifyDataSyncFininshed object:nil];
}

- (void)dataSyncFinished:(NSNotificationCenter *)notification{
    
    [HUD hide:YES];
    [HUD removeFromSuperview];
    
    [self loadParentData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(multiUsers){
        UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okBtnPressed:)];
        
        self.navigationItem.rightBarButtonItem = commitButton;
        
    }
    if (refresh) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithTitle:@"同步" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshBtnPressed:)];
        
        self.navigationItem.leftBarButtonItem = refreshButton;
        
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]init];
        backBarButton.title = @"返回";
        
        self.navigationItem.backBarButtonItem = backBarButton;
    }
    
    self.contentSizeForViewInPopover = CGSizeMake(300, 400);
    
    [self loadParentData];
}

-(void)loadParentData{
    //04表示支队，不从root查
    if ([parentBMBH length] <= 0 || [parentBMBH isEqualToString:@"04"]) {
        self.aryChoosedPersons = [NSMutableArray arrayWithCapacity:3];
        self.aryDeparts = [usersHelper queryAllSubDept:@"04"];
        self.aryUsers = [usersHelper queryAllUsers:@"04"];
        
    }else{
        self.aryDeparts = [usersHelper queryAllSubDept:parentBMBH];
        self.aryUsers = [usersHelper queryAllUsers:parentBMBH];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) 
        return [aryDeparts count];
    else 
        return [aryUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
  //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [[aryDeparts objectAtIndex:indexPath.row] objectForKey:@"ZZJC"];
        cell.imageView.image = [UIImage imageNamed:@"depart"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.textLabel.text = [[aryUsers objectAtIndex:indexPath.row] objectForKey:@"YHMC"];
        cell.imageView.image = [UIImage imageNamed:@"user"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *curUserID = [[aryUsers objectAtIndex:indexPath.row] objectForKey:@"YHID"];
        for(NSDictionary *dicItem in aryChoosedPersons){
            if([[dicItem objectForKey:@"YHID"] isEqualToString:curUserID]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.section == 0) {
        PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
        controller.aryChoosedPersons = aryChoosedPersons;
        controller.multiUsers = multiUsers;
        controller.parentBMBH = [[aryDeparts objectAtIndex:indexPath.row] objectForKey:@"ZZBH"];
        controller.delegate = delegate;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (multiUsers) {
            if([aryChoosedPersons containsObject:[aryUsers objectAtIndex:indexPath.row]])
            {
                [aryChoosedPersons removeObject:[aryUsers objectAtIndex:indexPath.row]];
            }
            else{
                [aryChoosedPersons addObject:[aryUsers objectAtIndex:indexPath.row]];
            }
            [tableView reloadData];
        }else{
            [delegate personChoosed:aryChoosedPersons];
        }
    }
}

@end
