//
//  DealSummaryEditViewController.h
//  xiaojiaoyi
//
//  Created by chen on 11/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealSummaryViewController.h"
#import "UserObject.h"
#import "LoginViewController.h"
#import "SessionManager.h"
#import "MyFBSessionTokenCachingStrategy.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "TweetDialogViewController.h"

@interface DealSummaryEditViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>


@property (nonatomic) DealObject* myNewDeal;

@property (nonatomic) BOOL cancelDeal;
@property (nonatomic) BOOL shouldTweet;
@property (nonatomic) NSString* tweetString;

@end
