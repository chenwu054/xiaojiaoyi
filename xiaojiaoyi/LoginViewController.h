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

@interface LoginViewController : UIViewController <FBLoginViewDelegate>
@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isLinkedin;
@property (nonatomic) NSString *twitterOAuthToken;
@property (nonatomic) NSString *twitterOAuthTokenVerifier;
@property (nonatomic) TWAccessToken *twAccessToken;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;


@end
