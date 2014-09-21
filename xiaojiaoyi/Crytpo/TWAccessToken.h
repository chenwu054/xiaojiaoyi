//
//  TWAccessToken.h
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWMutableURLRequest.h"


@interface TWAccessToken : NSObject
@property (nonatomic) NSString *requstToken;
@property (nonatomic) NSString* oauth_token;
@property (nonatomic) NSString* oauth_token_secret;
@property (nonatomic) NSString* access_token;
@property (nonatomic) NSString* access_token_secret;
@property (nonatomic) NSString* user_id_str;
@property (nonatomic) NSString* screen_name;
@property (nonatomic) OAToken* token;

-(void) getRequestTokenWithCompletionTask:(void (^)())completionTask;
-(void) getAccessTokenWithOAuthToken:(NSString*) oauth_token andOAuthVerifier:(NSString*)oauth_verifier withCompletionTask:(void (^)(NSString* accessToken, NSString * accessTokenSecret,NSString* screen_name, NSString* user_id))completionTask;
-(void)getUserProfileByScreenName:(NSString *)screen_name andUserId:(NSString*) user_id withCompletionTask:(void(^)(NSString *name,NSString* URLString))completionTask;

-(void) userAuthorize;

@end
