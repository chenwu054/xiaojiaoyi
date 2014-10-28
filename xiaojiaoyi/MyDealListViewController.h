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
#import "MyDealListTableViewCell.h"
#import "MyDealPassGestureView.h"

@interface MyDealListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>


@property (nonatomic) NSString* userId;

@end
