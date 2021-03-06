//
//  MyDealListViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/25/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModalUtils.h"
#import "EditTableCellView.h"
//#import "MyDealPassGestureView.h"
#import "DealSummaryEditViewController.h"
#import "MainViewController.h"

@class MainViewController;

@interface MyDealListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic) MainViewController* mainVC;

@property (nonatomic) NSString* userId;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) DealObject* transferDealObject;

-(void)editButtonClicked;
-(void)setup;


@end
