//
//  ChopImageView.m
//  xiaojiaoyi
//
//  Created by chen on 10/18/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "ChopImageView.h"

@implementation ChopImageView



-(void)drawRect:(CGRect)rect
{
    [[UIColor colorWithWhite:0.5 alpha:0.9] set];
    UIRectFill(rect);
    
    [[UIColor clearColor] setFill];
    UIRectFill(self.rect);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
