//
//  GestureView.m
//  xiaojiaoyi
//
//  Created by chen on 10/6/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch event began with touch: %@ and event: %@",touches,event);
    [super touchesBegan:touches withEvent:event];
    
    [self.nextResponder touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.nextResponder touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    //NSLog(@"in the hit test");
//    NSArray *arr = self.subviews;
//    BOOL selfIn = [self pointInside:point withEvent:event];
//    if(!selfIn)
//        return nil;
//    UIView* toReturn = nil;
//    for(int i=0;i<arr.count;i++){
//        UIView *returnView = [arr[i] hitTest:point withEvent:event];
//        if(!returnView){
//            if([arr[i] isKindOfClass:[UICollectionView class]] || [arr[i] isKindOfClass:[UITableView class]]){
//                toReturn = self;
//            }
//            else{
//                toReturn = returnView;
//            }
//        }
//        
//    }
//    //NSLog(@"toreturn is %@",toReturn);
//    return toReturn?toReturn:self;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
