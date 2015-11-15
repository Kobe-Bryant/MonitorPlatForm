//
//  ZrsUtils.m
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZrsUtils.h"

@implementation ZrsUtils

+(CGFloat)calculateTextHeight:(NSString*) text byFontSize:(CGFloat)size
                     andWidth:(CGFloat)width{
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:size];
    
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize cellSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat cellHeight = cellSize.height + 40;
    
    if (cellHeight < 56)
        cellHeight = 44;
    
    return cellHeight;        
    
}

+(void)showAlertMsg:(NSString*)msg andDelegate:(id)delegate{
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:delegate 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
}

@end
