//
//  xjyViewController.h
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OADataFetcher.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "CenterTabHotDealController.h"
#import "CenterTabBuddyDealController.h"
#import "CenterTabNearbyDealController.h"
#import "MyDealViewController.h"
#import "SellDealViewController.h"
#import "DataModalUtils.h"


//#import "OASignatureProviding.h"
#import "YelpViewController.h"

@class  YelpViewController;
@class MainViewController;
@class CenterTabHotDealController;
@class SellDealViewController;

@interface CenterViewController : UINavigationController <DataFetcherDelegate,UITabBarControllerDelegate,UIToolbarDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *yelpButton;
@property (strong,nonatomic) OADataFetcher *dataFetcher;
@property (nonatomic) NSString* term;
@property (nonatomic) NSString* query;
@property (nonatomic) NSString* limit;
@property (nonatomic) NSString* location;

//@property (nonatomic) id<MenuNavigationDelegate> delegate;

@property (nonatomic) IBOutlet UIButton *slideButton;
@property (nonatomic) UITabBarController *tabController;
//@property (nonatomic) UIToolbar* toolBar;
@property (nonatomic) UITabBar *tabBar;

@property (nonatomic) LoginViewController* loginController;

@property (nonatomic) YelpViewController* yelpController;
@property (nonatomic) CenterTabHotDealController* centerTabHotDealController;
@property (nonatomic) CenterTabBuddyDealController* centerTabBuddyDealController;
@property (nonatomic) CenterTabNearbyDealController* centerTabNearbyDealController;
@property (nonatomic) MainViewController *superVC;
@property (nonatomic) SellDealViewController *sellDealController;

@property (nonatomic) DataModalUtils* utils;

@end
