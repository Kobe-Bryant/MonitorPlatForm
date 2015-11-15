//
//  PM25GraphView.m
//  MonitorPlatform
//
//  Created by 张仁松 on 13-5-29.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "PM25GraphView.h"

@implementation PM25GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.yMaxValue = 500;
    }
    return self;
}

-(UIColor*)getColorByGrade:(NSInteger)index{
    UIColor *levelColor = nil;
    if (index == 1)
        levelColor = [UIColor greenColor];
    else if (index == 2)
        levelColor = [UIColor yellowColor];
    else if (index == 3)
        levelColor = [UIColor orangeColor];
    else if (index == 4)
        levelColor = [UIColor redColor];
    else if (index == 5)
        levelColor = [UIColor purpleColor];
    else
        levelColor = [UIColor colorWithRed:96/255.0 green:40/255.0 blue:30/255.0 alpha:1];
    return levelColor;
}

- (NSString *)getStringByGrade:(NSInteger)index
{
    NSString *title;
    if (index == 1)
        title = @"优";
    else if (index == 2)
        title = @"良";
    else if (index == 3)
        title = @"轻度污染";
    else if (index == 4)
        title = @"中度污染";
    else if (index == 5)
        title = @"重度污染";
    else
        title = @"严重污染";
    return title;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   
    
    CGContextRef c = UIGraphicsGetCurrentContext();

	CGFloat offsetX = self.drawAxisX ? 60.0f : 10.0f;
	CGFloat offsetY = (self.drawAxisX || self.drawInfo) ? 30.0f : 10.0f;

    CGFloat maxY = self.yMaxValue;
    

	CGFloat stepY = (self.frame.size.height - (offsetY * 2)) / maxY;
	
    CGFloat valItems[7]={0,50,100,150,200,300,500};
	for (NSUInteger i = 1; i < 7; i++) {
		
		float y1 = valItems[i] * stepY;
		float y0 = valItems[i-1]  * stepY;
        
        CGContextSetLineWidth(c, 1.0);
        CGContextSetRGBFillColor(c, 0, 0, 0, 1);
        UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
        float delta = (self.frame.size.height - y1 - offsetY) - (self.frame.size.height - y0 - offsetY);
        CGRect rect = CGRectMake(self.frame.size.width - offsetX, self.frame.size.height - y1 - offsetY - delta/2 - 10, 80, 40);
        NSString *title = [self getStringByGrade:i];
        [title drawInRect:rect withFont:font];
        
        CGContextMoveToPoint(c, offsetX, self.frame.size.height - y0 - offsetY);
        CGContextAddLineToPoint(c, offsetX, self.frame.size.height - y1 - offsetY);
        CGContextAddLineToPoint(c, offsetX+10, self.frame.size.height - y1 - offsetY);
        CGContextAddLineToPoint(c, offsetX+10, self.frame.size.height - y0 - offsetY);
        CGContextClosePath(c);
        UIColor *color = [self getColorByGrade:i];
        CGContextSetFillColorWithColor(c, color.CGColor);
        CGContextFillPath(c);
        
        
    }
    
    [super drawRect:rect];
    
}


@end
