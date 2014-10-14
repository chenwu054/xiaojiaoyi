//
//  GestureView.m
//  xiaojiaoyi
//
//  Created by chen on 10/6/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"hit test in Gesture View");
//    return [super hitTest:point withEvent:event];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"gesture view began");
    NSArray *arr = [self gestureRecognizers];
    for(int i=0;i<arr.count;i++){
        NSLog(@"GV GR%d is %@",i,arr[i]);
    }
    //NSLog(@"GV-------------------");
    //!!have to explicitly call the gesture recognizers, using super will not work
    [self.nextResponder touchesBegan:touches withEvent:event];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"gesture view moved");
    [self.nextResponder touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //NSLog(@"gesture view ended and NR is %@",self.nextResponder);
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    //NSLog(@"gesture view cancelled");
    [self.nextResponder touchesCancelled:touches withEvent:event];
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
