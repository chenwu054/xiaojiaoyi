//
//  SessionMananger.h
//  xiaojiaoyi
//
//  Created by chen on 9/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MyFBSessionTokenCachingStrategy.h"
#import "LoginViewController.h"
#import "TWSession.h"

@interface SessionManager : NSObject

typedef NS_ENUM(NSInteger, MyOAuthLoginType)
{
    FACEBOOK = 1,
    GOOGLE = 2,
    LINKEDIN = 3,
    TWITTER = 4,
};

+(BOOL)openSessionWithOAuthLoginType:(MyOAuthLoginType)oauthType;
+(BOOL)refreshSession:(MyOAuthLoginType)oauthType withCompletionHandler:(void(^)(BOOL success))handler;
+(NSArray *)getUsernameAndImageURLWithOAuthType:(MyOAuthLoginType)oauthType;
+(BOOL)writeUsername:(NSString*)username imageURL:(NSString*)imageURL forOAuthType:(MyOAuthLoginType)oauthType;

//linkedin methods
+(BOOL)writeLKSessionCache:(NSDictionary*)session;
+(NSDictionary*)readLKSessionCache;
+(void)clearLKSessionCache;


//twitter methods
+(TWSession*)twSession;
+(NSDictionary*)readTWSessionCache;
+(void)loadTWSession;
+(BOOL)clearTwitterLocalCache;
+(void)clearUpTWSession;
+(BOOL) writeTWSessionCache:(NSDictionary*)dict;
+(BOOL)writeProfileImage:(NSData *)imageData;


//facebook methods
+(FBSession *)fbSession;
+(void)setFBSession:(FBSession*)newSession;
+(void)loginFacebook;
+(void)loginFacebookWithCompletionHandler:(void(^)(FBSession *session, FBSessionState status, NSError *error))handler;
+(void)logoutFacebook;
+(void)logoutFacebookCleanCache:(BOOL)cleanCache revokePermissions:(BOOL)revokePermissions WithCompletionHandler:(void(^)(FBSession *session, FBSessionState status, NSError *error))handler;
+(void)refreshFBSessionFromLocalCacheWithCompletionHandler:(void(^)(FBSession* session,FBSessionState status, NSError *error))handler;
+(MyFBSessionTokenCachingStrategy *)myFBTokenCachingStrategy;

+(void)checkFBPermissionsWithCompletionHandler:(void(^)(FBRequestConnection *connection, id result, NSError *error))handler;
+(void)requestPublicActionPermissionWithCompletionHandler:(void(^)(FBSession* session, NSError* error))handler;
+(void)uploadImage:(UIImage*)image withCompletionHandler:(void(^)(FBRequestConnection *connection, id result, NSError *error))handler;
//+(void)loginWithOAuthLoginType:(OAuthLoginType)oauthType withCompletionHandler:(void(^)(NSString *urlString, NSString* username, NSError* error))handler;
//+(void)logoutWithOAuthLoginType:(OAuthLoginType)oauthType withCompletionHandler:(void(^)(BOOL success))handler;


@end

//TODO: add session delegate !
