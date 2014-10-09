//
//  UIView+GestureView.m
//  xiaojiaoyi
//
//  Created by chen on 10/6/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "UIView+GestureView.h"

@implementation UIView (GestureView)



#pragma mark - category methods
-(void)recursiveDescription{
    [self printView:self atLevel:0];
}
-(void)printView:(UIView*)view atLevel:(NSInteger)level
{
    if(!view)
        return;
    NSLog(@"level %ld and view is %@",level,view);
    NSArray *arr = view.subviews;
    
    for(int i=0;i<arr.count;i++){
        [self printView:arr[i] atLevel:level+1];
    }
}

+(void)recursivePrintViewTree:(UIView*)view{
    [self printView:view atLevel:0];
}
+(void)printView:(UIView*)view atLevel:(NSInteger)level
{
    if(!view)
        return;
    NSLog(@"level %ld and view is %@",level,view);
    NSArray *arr = view.subviews;
    
    for(int i=0;i<arr.count;i++){
        [self printView:arr[i] atLevel:level+1];
    }
}


@end
