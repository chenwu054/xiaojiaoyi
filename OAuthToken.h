//
//  OAuthToken.h
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface OAuthToken : NSManagedObject

@property (nonatomic, retain) NSString * fb_access_token;
@property (nonatomic, retain) NSString * tw_access_token;
@property (nonatomic, retain) NSString * gg_access_token;
@property (nonatomic, retain) NSString * lk_access_token;
@property (nonatomic, retain) NSString * fb_token_secret;
@property (nonatomic, retain) NSString * lk_token_secret;
@property (nonatomic, retain) NSString * tw_token_secret;
@property (nonatomic, retain) NSString * gg_token_secret;
@property (nonatomic, retain) NSString * fb_profile_url;
@property (nonatomic, retain) NSString * fb_username;
@property (nonatomic, retain) NSString * lk_profile_url;
@property (nonatomic, retain) NSString * lk_username;
@property (nonatomic, retain) NSString * gg_profile_url;
@property (nonatomic, retain) NSString * gg_username;
@property (nonatomic, retain) NSString * tw_profile_url;
@property (nonatomic, retain) NSString * tw_username;
@property (nonatomic, retain) User *user_id;

@end
