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
@class MainViewController;

@interface MyDealViewController : UIViewController


@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic)UIView* parentView;
@property (nonatomic) MainViewController* mainVC;

@end
