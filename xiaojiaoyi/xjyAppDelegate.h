//
//  xjyAppDelegate.h
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFBSessionTokenCachingStrategy.h"
@interface xjyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) MyFBSessionTokenCachingStrategy* myFBTokenCachingStrategy;


-(void) sessionStateChanged:(FBSession*) session state:(FBSessionState)state error:(NSError*) error;


@end
