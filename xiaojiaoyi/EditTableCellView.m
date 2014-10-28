//
//  EditTableCellView.m
//  xiaojiaoyi
//
//  Created by chen on 10/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "EditTableCellView.h"

@implementation EditTableCellView

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"hide view gesture began");
//    //NSLog(@"next responder=%@, %@, %@",self.nextResponder,self.nextResponder.nextResponder,self.nextResponder.nextResponder.nextResponder);
//    //NSArray* gr=self.superview.gestureRecognizers;
////    for(UIGestureRecognizer* g in gr){
////        [g touchedBegan:touches withEvent:event];
////    }
//    [self.nextResponder touchesBegan:touches withEvent:event];
//}
//
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    NSLog(@"hide view gesture moved");
//    [self.nextResponder touchesMoved:touches withEvent:event];
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    NSLog(@"hide view gesture ended");
//    [self.nextResponder touchesEnded:touches withEvent:event];
//}
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    [super touchesCancelled:touches withEvent:event];
//    NSLog(@"hide view gesture cancelled");    
//    [self.nextResponder touchesCancelled:touches withEvent:event];
//}


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
