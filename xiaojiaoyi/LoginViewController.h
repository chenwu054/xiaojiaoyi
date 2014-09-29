//
//  LoginViewController.h
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"
#import "TWSession.h"
#import "xjyAppDelegate.h"
#import "MyFBSessionTokenCachingStrategy.h"
#import "SessionManager.h"

@interface LoginViewController : UIViewController <FBLoginViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

//@property (nonatomic) MyOAuthLoginType currentLoginType;

@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isLinkedin;
@property (nonatomic) BOOL isFacebook;
@property (nonatomic) NSString *twitterOAuthToken;
@property (nonatomic) NSString *twitterOAuthTokenVerifier;
@property (nonatomic) TWSession *twAccessToken;
@property (nonatomic) NSInteger twLoginRetryLimit;
@property (nonatomic) BOOL isUserLogin;

@property (nonatomic) MyFBSessionTokenCachingStrategy *myFBTokenCachingStrategy;
//@property (nonatomic) SessionManager *sessionManager;
@property (nonatomic) UIActivityIndicatorView *spinner;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;


@end
