//
//  LoginViewController.h
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"
#import "TWAccessToken.h"
#import "xjyAppDelegate.h"

@interface LoginViewController : UIViewController <FBLoginViewDelegate,UIAlertViewDelegate>
@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isLinkedin;
@property (nonatomic) BOOL isFacebook;

@property (nonatomic) NSString *twitterOAuthToken;
@property (nonatomic) NSString *twitterOAuthTokenVerifier;
@property (nonatomic) TWAccessToken *twAccessToken;
@property (nonatomic) NSInteger twLoginRetryLimit;
@property (nonatomic) BOOL isUserLogin;

@property (nonatomic) UIActivityIndicatorView *spinner;



- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;


@end
