    //
//  UIChargeController.m
//  EPad
//
//  Created by chen on 11-6-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIChargeController.h"
#import "UIChargeDetailController.h"
#import "MPAppDelegate.h"


@implementation UIChargeController
@synthesize myTableView;
@synthesize dataFGBH,dataFGMC,dataWJMC,dataSFML,dataFGDH,dataDLDM;
@synthesize _searchBar,saveFGMC,allInfo,isSelect,isExisSelect,viewTitle;
@synthesize firstPageType;
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


-(void)searchByFIDH:(id)strFIDH root:(id)rootMl{
    self.title =  self.viewTitle = rootMl;
    NSString *sqlStr;
    if ([strFIDH isKindOfClass:[NSArray class]]) {
        
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM FLFG where FIDH = '%@' or FIDH = '%@' AND ORGID= 330100",[strFIDH objectAtIndex:0],[strFIDH objectAtIndex:1]];
        //const char *utfsql = [sqlStr cStringUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM FLFG WHERE FIDH = '%@' AND ORGID= 330100",strFIDH];
    }

    //NSLog(@"sql:%@",sqlStr);
    //NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM FLFG WHERE FIDH = '%@' AND ORGID= 330100",strFIDH];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  
	const char *utfsql = [sqlStr cStringUsingEncoding:enc];
	//NSLog(sqlStr);
	sqlite3_stmt *statement; 
	if (sqlite3_prepare_v2(data_db, utfsql, -1, &statement, nil)!=SQLITE_OK) 
    { 
		//NSLog(@"select ok."); 
        
	}
    //int nRetValue = sqlite3_prepare_v2(data_db, utfsql, -1, &statement, nil);
    //NSLog(@"%d", sqlite3_step(statement));
    
    char *name;
	NSString *text;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:20];
	[dataFGBH removeAllObjects];
	[dataFGMC removeAllObjects];
	[dataSFML removeAllObjects];
	[dataWJMC removeAllObjects];
    [saveFGMC removeAllObjects];
    [allInfo removeAllObjects];
	while (sqlite3_step(statement)==SQLITE_ROW) { 
        
		name=(char *)sqlite3_column_text(statement,0 ); 
        if (name == NULL) {
			[dic setObject:@"" forKey:@"FGBH"];
		}
        else
        {
            text = [NSString stringWithCString:name  encoding:enc];			
            [dataFGBH addObject:text];
            [dic setObject:text forKey:@"FGBH"];
        }
        
        name=(char *)sqlite3_column_text(statement,1 ); 
        if (name == NULL) {
			[dic setObject:@"" forKey:@"FGMC"];
		}
        else
        {
            text = [NSString stringWithCString:name  encoding:enc];
			if (text==nil) {
                text = [NSString stringWithCString:name  encoding:NSUTF8StringEncoding];
            }
            [dataFGMC addObject:text];
            [dic setObject:text forKey:@"FGMC"];
        }
        
        name=(char *)sqlite3_column_text(statement,3 ); 
        if (name == NULL) {
			[dic setObject:@"" forKey:@"SFML"];
		}
        else
        {
            text = [NSString stringWithCString:name  encoding:enc];			
            [dataSFML addObject:text ];
            [dic setObject:text  forKey:@"SFML"];
        }
        
        name=(char *)sqlite3_column_text(statement,6 ); 
        if (name == NULL) {
			[dic setObject:@"" forKey:@"WJMC"];
		}
        else
        {
            text = [NSString stringWithCString:name  encoding:enc];			
            [dataWJMC addObject:text];
            [dic setObject:text forKey:@"WJMC"];
        }
        
        name=(char *)sqlite3_column_text(statement,13 );
        if (name == NULL) {
			[dic setObject:@"" forKey:@"DLDM"];
		}
        else
        {
            text = [NSString stringWithCString:name  encoding:enc];
            [dataDLDM addObject:text];
            [dic setObject:text forKey:@"DLDM"];
        }
        
        [allInfo addObject:[NSDictionary dictionaryWithDictionary:dic]];
	}
    
    saveFGMC = [dataFGMC mutableCopy];
    
	//NSLog(@"zuixin:%@",allInfo);
	sqlite3_finalize(statement);
    sqlite3_close(data_db);
	
	[self.myTableView reloadData];    


}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *dataDbPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"db"];
	if (sqlite3_open([dataDbPath UTF8String], &data_db)!=SQLITE_OK) { 
		//NSLog(@"open datadb sqlite db error."); 
	}	
    isExisSelect = NO;
    
    
    //NSString *str = [titlePage objectAtIndex:nIndex];
    //self.title = @"法律法规";
    //  UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithTitle:@"名称查询" style:UIBarButtonItemStylePlain target:self action:@selector(selectFGMC:)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 0.0)];
    _searchBar.delegate = self;
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    self.navigationItem.rightBarButtonItem = searchItem;
    [searchItem release];
    
    myTableView.rowHeight = 60;
    NSMutableArray *ary0 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.dataFGBH = ary0;
	[ary0 release];
	
	NSMutableArray *ary1 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.dataFGMC = ary1;
	[ary1 release];
	
	NSMutableArray *ary2 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.dataSFML = ary2;
	[ary2 release];
	
	NSMutableArray *ary3 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.dataWJMC = ary3;
	[ary3 release];
    
    NSMutableArray *ary7 = [[NSMutableArray alloc] initWithCapacity:130];
	self.dataDLDM = ary7;
	[ary7 release];
    
    NSMutableArray *ary4 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.saveFGMC = ary4;
	[ary4 release];
    
    NSMutableArray *ary5 = [[NSMutableArray alloc] initWithCapacity:130];	
	self.allInfo = ary5;
	[ary5 release];
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
    

    
    if (firstPageType >= 1) {
        switch (firstPageType) {
            case PAGE_TYPE_FLFG:
                [self searchByFIDH:@"899" root:@"法律法规"];
                break;
            case PAGE_TYPE_ZYZDS:
                [self searchByFIDH:@"12" root:@"作业指导书"];
                break;
            case PAGE_TYPE_NBZD:
                [self searchByFIDH:@"18" root:@"内部管理制度"];
                break;
            case PAGE_TYPE_HBBZ:
                [self searchByFIDH:@"1101" root:@"深圳用环保标准"];
                break;
            case PAGE_TYPE_YJZN:
                [self searchByFIDH:@"1102" root:@"深圳用应急指南"];
            default:
                break;
        }
    }
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataFGMC count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = [indexPath row];
    
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
  //  NSString *image = [NSString stringWithFormat:@"mc_%d",indexPath.row];
  //  cell.imageView.image = [UIImage imageNamed:image];

   /* NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:(index%2 == 0) ? @"lightblue" : @"white" ofType:@"png"];
    UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];*/
    cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView.frame = cell.bounds;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    
    if (isSelect == YES) {
        NSMutableDictionary *dic = [dataFGMC objectAtIndex:index];
        cell.textLabel.text = [dic objectForKey:@"FGMC"];
    }
    else
    {
        cell.textLabel.text = [dataFGMC objectAtIndex:index];
    }
    
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"共%d个",[dataFGBH count]];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = nil;
    //NSLog(@"FD%@",dataFGMC);
    NSString *boolStr = [dataSFML objectAtIndex:[indexPath row]];
    
	BOOL bHasChild = [boolStr boolValue];
    if (isSelect == NO) 
    {
        if (bHasChild) 
        {
            UIChargeController *detailViewController = [[UIChargeController alloc] initWithNibName:@"UIChargeController" bundle:nil];
            detailViewController.firstPageType = PAGE_TYPE_NONE;
            //	detailViewController.title = [dataFGMC objectAtIndex:indexPath.row];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController searchByFIDH:[dataFGBH objectAtIndex:[indexPath row]] root:[dataFGMC objectAtIndex:indexPath.row]];
            [detailViewController release];
            //NSLog(@"111-%@",[dataFGBH objectAtIndex:[indexPath row]]);
        }
        else
        {
            NSString *typeStr = [dataDLDM objectAtIndex:[indexPath row]];            
            UIChargeDetailController *detailViewController = [[UIChargeDetailController alloc] initWithNibName:@"UIChargeDetailController" bundle:nil];
            detailViewController.title = [dataFGMC objectAtIndex:indexPath.row];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            
            if ([typeStr isEqualToString:@"html"])
                [detailViewController loadHtmlFile:[dataWJMC objectAtIndex:[indexPath row]]];
            else
                [detailViewController loadOtherFile:[dataWJMC objectAtIndex:[indexPath row]] type:typeStr];
                
            [detailViewController release];
            //NSLog(@"222-%@",[dataFGBH objectAtIndex:[indexPath row]]);
        }
        
    }
    else
    {
        dic = [dataFGMC objectAtIndex:indexPath.row];
        if (bHasChild) 
        {
            UIChargeController *detailViewController = [[UIChargeController alloc] initWithNibName:@"UIChargeController" bundle:nil];
            detailViewController.firstPageType = PAGE_TYPE_NONE;
            //	detailViewController.title = [dataFGMC objectAtIndex:indexPath.row];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController searchByFIDH:[dic objectForKey:@"FGBH"] root:[dic objectForKey:@"FGMC"]];
            [detailViewController release];
            //NSLog(@"%@",[dic objectForKey:@"FGBH"]);
        }
        else
        {
            UIChargeDetailController *detailViewController = [[UIChargeDetailController alloc] initWithNibName:@"UIChargeDetailController" bundle:nil];
            detailViewController.title = [dic objectForKey:@"FGMC"];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            NSString *typeStr = [dic objectForKey:@"DLDM"];
            if ([typeStr isEqualToString:@"html"])
                [detailViewController loadHtmlFile:[dic objectForKey:@"WJMC"]];
            else
                [detailViewController loadOtherFile:[dic objectForKey:@"WJMC"] type:typeStr];
            [detailViewController release];
            //NSLog(@"%@",[dic objectForKey:@"FGBH"]);
        }
        
    }
	
}
//数组深复制
-(NSMutableArray *)ArrayMutableDeepCopy:(NSMutableArray *)array
{
    
    NSMutableArray *mutArray = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i = 0; i < [array count];i++)
    {//循环读取复制每一个元素
        id value = [array objectAtIndex:i];
        [mutArray addObject:value];
    }
    return mutArray;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isSelect =YES;
    [self.dataFGMC removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        self.dataFGMC = [self ArrayMutableDeepCopy:allInfo];
        NSLog(@"111%@",self.dataFGMC);
        NSLog(@"222%@",allInfo);
        [self.myTableView reloadData];
        return;
    }
    int dataCount = [allInfo count];
    NSDictionary *dic;
    NSString *tmp;
    for (int i = 0; i < dataCount; i++) {
        dic = [allInfo objectAtIndex:i];
        tmp = [saveFGMC objectAtIndex:i];
        if ([tmp rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [dataFGMC addObject:dic ];
            
        }
    }
    
    [self.myTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}


- (void)dealloc {
	[myTableView release];
    [super dealloc];
}


@end
