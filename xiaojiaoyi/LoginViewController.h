//
//  LoginViewController.h
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

#import "TWSession.h"
#import "xjyAppDelegate.h"
#import "MyFBSessionTokenCachingStrategy.h"
#import "SessionManager.h"

@interface LoginViewController : UIViewController <FBLoginViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,NSXMLParserDelegate,GPPSignInDelegate>

//@property (nonatomic) MyOAuthLoginType currentLoginType;
//overall properties
@property (nonatomic) BOOL isUserLogin;
@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isLinkedin;
@property (nonatomic) BOOL isFacebook;

//linkedin properties
@property (nonatomic) NSString* linkedinCallback;
@property (nonatomic) NSString* lkCallbackCode;
@property (nonatomic) NSString* lkCallbackState;

//twitter properties
@property (nonatomic) TWSession *twSession;
@property (nonatomic) NSInteger twLoginRetryLimit;

//facebook properties

@property (nonatomic) UIActivityIndicatorView *spinner;

//- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;


@end
