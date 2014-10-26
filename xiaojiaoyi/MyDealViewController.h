//
//  MyDealViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureView.h"
#import "MainViewController.h"
#import "MyDealListViewController.h"
#import "BoughtDealListViewController.h"
#import "FriendDealListViewController.h"


@class MainViewController;

@interface MyDealViewController : UIViewController <UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic)UIView* parentView;
@property (nonatomic) MainViewController* mainVC;


@property (nonatomic) MyDealListViewController* myDealListController;
@property (nonatomic) BoughtDealListViewController* boughtDealListController;
@property (nonatomic) FriendDealListViewController* friendDealListController;



@end
