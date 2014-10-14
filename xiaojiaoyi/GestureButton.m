//
//  GestureButton.m
//  xiaojiaoyi
//
//  Created by chen on 10/12/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "GestureButton.h"

@implementation GestureButton

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"hit test in button");
//    return [super hitTest:point withEvent:event];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     a horizontal pan gesture in the Gesture Collection View, even though touchesBegan is nothing here, CenterViewController.view can still recognize the pan gesture. setting the cancelsTouchesInView=NO does NOT help!
     */
    //calling super is to have the collecion view's functions, such as detecting selecting a cell. this
    // is very important.
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"-------------------");
    //NSLog(@"button began");
    NSArray *arr = [self gestureRecognizers];
    for(int i=0;i<arr.count;i++){
        //NSLog(@"buttonGR%d is %@",i,arr[i]);
    }
    //this is the method that delivers to main view
    [self.nextResponder touchesBegan:touches withEvent:event];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesMoved:touches withEvent:event];
    //NSLog(@"button moved");
    [self.nextResponder touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    //NSLog(@"button ended");
    [self.nextResponder touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    //NSLog(@"button cancelled");
    [self.superview touchesCancelled:touches withEvent:event];
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
