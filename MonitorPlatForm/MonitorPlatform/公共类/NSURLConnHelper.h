//
//  WebserviceHelper.h
//  tesgt
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface NSURLConnHelper : NSObject

@property(nonatomic,retain)NSMutableData *webData;
@property(nonatomic,retain) id<NSURLConnHelperDelegate> delegate;
@property(atomic) NSInteger saveTag;
@property(nonatomic,retain)MBProgressHUD *HUD;
@property(nonatomic,retain)NSURLConnection *mConnection;

-(void)cancel;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl 
                   andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                        delegate:(id)aDelegate;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                         andTag:(NSInteger)tag;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                         andTag:(NSInteger)tag
                     andMessage:(NSString *)message;
@end
