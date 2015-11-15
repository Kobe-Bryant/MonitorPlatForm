//
//  CategoryItemViewController.h
//  handbook
//
//  Created by chen on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CategoryItemViewController : UITableViewController<UISearchBarDelegate> {
    IBOutlet UITableView *myTableView;
	NSMutableArray *dataResultArray;
    NSMutableArray *dataNameArray;
	int kindcode;
    UISearchBar *_searchBar;
    BOOL isSelect;
    sqlite3 *data_db;
}
@property(nonatomic,retain)NSMutableArray *dataResultArray;
@property(nonatomic,assign)int kindcode;

@end
