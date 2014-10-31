//
//  CollectionViewCell.m
//  xiaojiaoyi
//
//  Created by chen on 9/11/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(CollectionViewCell *)initWithName:(NSString *)name andURL:(NSURL*)url
{
    _name=name;
    _imageURL=url;
    _image=nil;
    _hasURL=YES;
    _hasImage =NO;
    _isFailed=NO;
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesBegan:touches withEvent:event];
    //!!let the next responder respond to the touches! otherwise will not move horizontall;
    //NSLog(@"cell-----------------------");
    //NSLog(@"collection view cell touch began");
    [self.nextResponder touchesBegan:touches withEvent:event];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.nextResponder touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"cell touch ended");
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSSet* touchSet = event.allTouches;
//    for(UITouch *touch in touchSet){
//        NSLog(@"touch is %@",touch);
//    }

//    UITouch *touch = [touches anyObject];
//    CGFloat xDiff = [touch locationInView:self].x - [touch previousLocationInView:self].x;
//    CGFloat yDiff = [touch locationInView:self].y - [touch previousLocationInView:self].y;
//    if(xDiff >=-0.5 && xDiff<=0.5 && yDiff>=-0.5 && yDiff<=0.5){
        //NSLog(@"CV Cell selected");
        //UICollectionView * view = (UICollectionView*)self.nextResponder;
        //NSLog(@"delegate is %@",view.delegate);
        
//    }
//    NSArray *gestures = [self gestureRecognizers];
//    NSLog(@"CV cell guesture size is %ld",gestures.count);
    
//    NSLog(@"next responder is %@",self.nextResponder);
//    NSLog(@"next2 responder is %@",self.nextResponder.nextResponder);
//    NSLog(@"next3 responder is %@",self.nextResponder.nextResponder.nextResponder);
    
//    if([self.superview.nextResponder.nextResponder respondsToSelector:@selector(hideSearchBar)]){
//        [self.superview.nextResponder.nextResponder performSelector:@selector(hideSearchBar)];
//    }
    //NSLog(@"cell touch cancelled");
    [super touchesCancelled:touches withEvent:event];
    //NSLog(@"cell cancelled");
    [self.nextResponder touchesCancelled:touches withEvent:event];
}
@end

