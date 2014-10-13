//
//  MyTapGestureRecognizer.m
//  xiaojiaoyi
//
//  Created by chen on 10/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyTapGestureRecognizer.h"

@implementation MyTapGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"collection view began");
    /*
     a horizontal pan gesture in the Gesture Collection View, even though touchesBegan is nothing here, CenterViewController.view can still recognize the pan gesture. setting the cancelsTouchesInView=NO does NOT help!
     */
    //calling super is to have the collecion view's functions, such as detecting selecting a cell. this
    // is very important.
   
    //[super touchesBegan:touches withEvent:event];
    //this is the method that delivers to main view
   
    //NSLog(@"GCV next responder is %@",self.nextResponder);
    //    NSArray *arr = [self gestureRecognizers];
    //    for(int i=0;i<arr.count;i++){
    //        //NSLog(@"GCV GR%d is %@",i,arr[i]);
    //    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     NSLog(@"collection view moved");
    //[super touchesMoved:touches withEvent:event];
   }
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"collection view ended");
    //NSLog(@"collection view ended next responder:%@",self.nextResponder);
    //[super touchesEnded:touches withEvent:event];
   }
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"collection view cancelled");
    //[super touchesCancelled:touches withEvent:event];
}


@end
