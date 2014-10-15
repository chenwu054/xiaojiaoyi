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
#import "UIView+GestureView.h"
#import "MyDealViewController.h"
#import "CategoryCollectionViewController.h"

@class CenterViewController;
@class MyDealViewController;

@protocol MenuNavigationDelegate <NSObject,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

-(void) slideLeftAll;
-(void) slideRightAll;
-(void) slideLeftAllWithCenterView:(UIView*)centerView;
-(void) slideRightAllWithCenterView:(UIView*)centerView;
-(void) reset;
-(void) resetWithCenterView:(UIView*)centerView;
-(void) resetWithCenterView:(UIView*)centerView inDuration:(CGFloat)duration;
-(void) slideWithCenterView:(UIView*)centerView atTransition:(CGPoint)transition ended:(BOOL)ended;

@end

@interface MainViewController : UINavigationController <MenuNavigationDelegate,UITableViewDelegate>


@property (nonatomic) MenuTableController* menuViewController;
@property (nonatomic) UserMenuController *userMenuController;
@property (nonatomic) CenterViewController* centerViewController;
@property (nonatomic) MyDealViewController* myDealViewController;


-(UIPanGestureRecognizer*)getPanGestureRecognizer;
-(void)backToCenterView;

-(BOOL) isReset;
@end
