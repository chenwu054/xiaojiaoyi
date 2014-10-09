//
//  GestureCollectionView.m
//  xiaojiaoyi
//
//  Created by chen on 10/7/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "GestureCollectionView.h"

@implementation GestureCollectionView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //NSLog(@"begin");
       //NSLog(@"next responder is %@",self.nextResponder);
    //NSLog(@"next responder is %@",self.nextResponder.nextResponder);
//        NSLog(@"next2 responder is %@",self.nextResponder.nextResponder.nextResponder);
//        NSLog(@"next3 responder is %@",self.nextResponder.nextResponder.nextResponder.nextResponder);
//        NSLog(@"next4 responder is %@",self.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder);
//        NSLog(@"next5 responder is %@",self.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder);
//        NSLog(@"next6 responder is %@",self.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder);
    //NSLog(@"next3 responder is %@",self.nextResponder.nextResponder.nextResponder);
    //NSLog(@"self.superview is %@",self.superview);
    //NSLog(@"next view is %@",self.superview.superview);
//    NSLog(@"next2 view is %@",self.superview.superview.superview);
//    NSLog(@"next3 view is %@",self.superview.superview.superview.superview);
//    NSLog(@"next4 view is %@",self.superview.superview.superview.superview.superview);
//    NSLog(@"next5 view is %@",self.superview.superview.superview.superview.superview.superview);
//    NSLog(@"next6 superview is %@",self.superview.superview.superview.superview.superview.superview.superview);
    //NSLog(@"next3 responder is %@",self.nextResponder.nextResponder.nextResponder);
    
    
    //calling super is to have the collecion view's functions, such as detecting selecting a cell. this
    // is very important.
    [super touchesBegan:touches withEvent:event];
    
    NSArray *gestures = self.superview.gestureRecognizers;

    for(int i = 0;i<gestures.count;i++){
        //NSLog(@"superview gesture is %@",gestures[i]);
        [gestures[i] touchesBegan:touches withEvent:event];
    }
    NSArray *selfGestures = self.gestureRecognizers;
    for(int i = 0;i<selfGestures.count;i++){
        //NSLog(@"selfGestures is %@",selfGestures[i]);
        //[selfGestures[i] touchesBegan:touches withEvent:event];
    }

    [self.nextResponder touchesBegan:touches withEvent:event];
    //[self.nextResponder.nextResponder touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    [super touchesMoved:touches withEvent:event];
    
    NSArray *gestures = self.superview.gestureRecognizers;
    for(int i = 0;i<gestures.count;i++){
        //NSLog(@"superview in move gesture is %@",gestures[i]);
        [gestures[i] touchesMoved:touches withEvent:event];
    }
    
    [self.nextResponder touchesMoved:touches withEvent:event];


    //NSLog(@"moved");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    
    NSArray *gestures = self.superview.gestureRecognizers;
    for(int i = 0;i<gestures.count;i++){
       // NSLog(@"superview in end gesture is %@",gestures[i]);
        [gestures[i] touchesEnded:touches withEvent:event];
    }
    [self.nextResponder touchesEnded:touches withEvent:event];

    //NSLog(@"ended");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    NSArray *gestures = self.superview.gestureRecognizers;
    for(int i = 0;i<gestures.count;i++){
        //NSLog(@"superview gesture is %@",gestures[i]);
        [gestures[i] touchesCancelled:touches withEvent:event];
    }
    
    [self.nextResponder touchesCancelled:touches withEvent:event];
    
    //[self.superview touchesCancelled:touches withEvent:event];
    //NSLog(@"cancelled");
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
