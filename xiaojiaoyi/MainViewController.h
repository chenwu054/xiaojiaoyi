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
#import "DataModalUtils.h"
#import "SettingsViewController.h"
#import "DealSummaryEditViewController.h"

@class CenterViewController;
@class MyDealViewController;
@class CategoryCollectionViewController;
@class SettingsViewController;

@protocol MenuNavigationDelegate <NSObject,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIToolbarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

-(void) slideLeftAll;
-(void) slideRightAll;
-(void) slideLeftAllWithCenterView:(UIView*)centerView;
-(void) slideRightAllWithCenterView:(UIView*)centerView;
-(void) reset;
-(void) resetWithCenterView:(UIView*)centerView;
-(void) resetWithCenterView:(UIView*)centerView inDuration:(CGFloat)duration;
-(void) slideWithCenterView:(UIView*)centerView atTransition:(CGPoint)transition ended:(BOOL)ended;

@end

@interface MainViewController : UIViewController <MenuNavigationDelegate,UITableViewDelegate>

@property (nonatomic) NSInteger* currentUserId;

@property (nonatomic) MenuTableController* menuViewController;
@property (nonatomic) UserMenuController *userMenuController;
@property (nonatomic) CenterViewController* centerViewController;
@property (nonatomic) MyDealViewController* myDealViewController;
@property (nonatomic) CategoryCollectionViewController* categoryViewControllerOne;
@property (nonatomic) CategoryCollectionViewController* categoryViewControllerTwo;

//@property (nonatomic) UINavigationController* navigationVC;
@property (nonatomic) SettingsViewController* settingsViewController;

@property (nonatomic) UIView* mainContainerView;
@property (nonatomic) UIToolbar* toolBar;

//+(MainViewController*)sharedInstance;

-(void)customPushViewController:(UIViewController*)viewController;
-(void)customPopViewController;

-(UIPanGestureRecognizer*)getPanGestureRecognizer;
-(UITapGestureRecognizer*)getTapGestureRecognizer;

-(void)backToCenterViewFromMyDealView;
-(void)backToCenterViewFromCategoryView;

-(BOOL) isReset;
@end
