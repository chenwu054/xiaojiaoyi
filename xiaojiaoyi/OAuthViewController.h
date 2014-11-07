//
//  OAuthViewController.h
//  xiaojiaoyi
//
//  Created by chen on 9/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface OAuthViewController : UIViewController <UIWebViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSString * requestURL;

@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isLinkedin;
@property (nonatomic) BOOL isFacebook;

@property (nonatomic) LoginViewController* superVC;

@end
