//
//  DealSummaryEditViewController.h
//  xiaojiaoyi
//
//  Created by chen on 11/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealSummaryViewController.h"



@interface DealSummaryEditViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>


@property (nonatomic) DealObject* myNewDeal;

@property (nonatomic) BOOL cancelDeal;

@end
