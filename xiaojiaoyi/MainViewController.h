//
//  MainViewController.h
//  xiaojiaoyi
//
//  Created by chen on 9/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableController.h"
#import "YelpViewController.h"
#import "UserMenuController.h"
#import "CenterViewController.h"

@class CenterViewController;

@protocol MenuNavigationDelegate <NSObject>

-(void) slideLeftAll;
-(void) slideRightAll;
-(void) reset;
-(void) resetWithDuration:(CGFloat)duration;
-(void) slideWithTransition:(CGPoint)transition ended:(BOOL)ended;

@end

@interface MainViewController : UIViewController <MenuNavigationDelegate,UITableViewDelegate>


@property (nonatomic) MenuTableController* menuViewController;
@property (nonatomic) UserMenuController *userMenuController;
@property (nonatomic) CenterViewController* viewController;


@end
