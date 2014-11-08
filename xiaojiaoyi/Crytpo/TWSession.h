//
//  TWAccessToken.h
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWMutableURLRequest.h"
#import "NSString+URLEncoding.h"

@interface TWSession : NSObject
//@property (nonatomic) NSString *requstToken;
@property (nonatomic) NSString* request_token;
@property (nonatomic) NSString* request_token_secret;
@property (nonatomic) NSString* access_token;
@property (nonatomic) NSString* access_token_secret;
@property (nonatomic) NSString* oauth_verifier;
@property (nonatomic) NSString* oauth_verifier_token; //this is the token returned back together with oauth_verifier and should be the same as request_token.
@property (nonatomic) NSString* user_id_str;
@property (nonatomic) NSString* screen_name;
@property (nonatomic) NSString* user_name;
@property (nonatomic) NSString* user_image_url;
@property (nonatomic) NSDate* expireDate;

@property (nonatomic) OAToken* accessToken;


-(void) getRequestTokenWithCompletionTask:(void (^)(BOOL success, NSURLResponse *response, NSError *error))completionTask;

-(void) getAccessTokenWithOAuthToken:(NSString*) oauth_token andOAuthVerifier:(NSString*)oauth_verifier withCompletionTask:(void (^)(NSURLResponse *response, NSError *error,NSString* accessToken, NSString * accessTokenSecret,NSString* screen_name, NSString* user_id))completionTask;
-(void)getUserProfileByScreenName:(NSString *)screen_name andUserId:(NSString*) user_id withCompletionTask:(void(^)(NSURLResponse *response, NSError *error,NSString *name,NSString* URLString))completionTask;

-(void)uploadWithImageURL:(NSURL*)imageURL withCompletionHandler:(void(^)())handler;
-(void)updateStatus:(NSString*)status withCompletionHandler:(void(^)())handler;
-(void)requestUserTimeline;
@end
