//
//  AttachmentFilesController.h
//  EvePad
//
//  Created by chen on 11-7-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItem.h"
@protocol OpenFileDelegate
- (void)openAttachFile:(AttachFileItem*)aItem;
@end

@interface AttachmentFilesController : UITableViewController {
	NSMutableArray *fileAry;
	id<OpenFileDelegate> delegate;

}
@property(nonatomic,retain) NSMutableArray *fileAry;
@property(nonatomic,assign) id<OpenFileDelegate> delegate;

@end
