//
//  DealSummaryViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/21/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPageContentViewController.h"


@interface DealSummaryViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic) NSString* conditionStr;
@property (nonatomic) NSString* descriptionStr;
@property (nonatomic) NSDate* expireDate;


@end
