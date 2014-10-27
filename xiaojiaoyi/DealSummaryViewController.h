//
//  DealSummaryViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/21/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPageContentViewController.h"
#import "DataModalUtils.h"
#import "DealObject.h"

@interface DealSummaryViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic) NSString* conditionStr;
@property (nonatomic) NSString* descriptionStr;
@property (nonatomic) NSDate* expireDate;


////Deal parameters
//@property (nonatomic) NSString* dealSoundURL;
//@property (nonatomic) NSString* dealTitle;
//@property (nonatomic) NSInteger* dealPrice;
//@property (nonatomic) NSString* dealDescription;
//@property (nonatomic) BOOL dealShipping;
//@property (nonatomic) BOOL dealExchange;
//@property (nonatomic) NSDate* dealCreateDate;
//@property (nonatomic) NSDate* dealExpireDate;
//@property (nonatomic) NSString* dealCondition;
//@property (nonatomic) NSArray* dealPhotoURL;

@property (nonatomic) DealObject* myNewDeal;

@end
