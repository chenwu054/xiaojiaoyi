//
//  UserObject.h
//  xiaojiaoyi
//
//  Created by chen on 11/3/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic) NSString * username;
@property (nonatomic) BOOL userLogin;
@property (nonatomic) NSString * email;
@property (nonatomic) NSString * password;
@property (nonatomic) NSDate * user_last_login;
//@property (nonatomic) NSSet *deals_bought;
//@property (nonatomic) NSSet *deals_created;

@property (nonatomic) BOOL fbLogin;
@property (nonatomic) NSString* fbUsername;
@property (nonatomic) NSString* fbProfileURL;
@property (nonatomic) NSString* fbID;
@property (nonatomic) NSString* fbAccessToken;
@property (nonatomic) NSDate* fbExpireDate;

@property (nonatomic) BOOL twLogin;
@property (nonatomic) NSString* twAccessToken;
@property (nonatomic) NSString* twUsername;
@property (nonatomic) NSString* twProfileURL;
@property (nonatomic) NSDate* twExpireDate;

@property (nonatomic) BOOL ggLogin;
@property (nonatomic) NSString* ggAccessToken;
@property (nonatomic) NSString* ggUsername;
@property (nonatomic) NSString* ggProfileURL;
@property (nonatomic) NSDate* ggExpireDate;

@property (nonatomic) BOOL lkLogin;
@property (nonatomic) NSString* lkAccessToken;
@property (nonatomic) NSString* lkUsername;
@property (nonatomic) NSString* lkProfileURL;
@property (nonatomic) NSDate* lkExpireDate;

+(UserObject*)currentUser;
+(void)updateCurrentUser:(UserObject*)user;
+(void)updateCurrentUserWithNewInfo:(NSDictionary*)dict;

+(UserObject*)loadUserObjectFromUserDefaults;
+(void)updateUserObjectInUserDefaults:(UserObject*)user;

+(UserObject*)loadUserObjectFromFile;
+(void)updateUserObjectToFile:(UserObject*)user;
+(void)loadUserObjectFromFileToCurrentUser;

+(NSMutableDictionary*)convertToDictionaryFromUser:(UserObject*)user;
+(void)convertToUser:(UserObject*)user FromDictionary:(NSDictionary*)dict;

+(NSURL*)currentUserLKProfileURL;
+(NSURL*)currentUserGGProfileURL;
+(NSURL*)currentUserTWProfileURL;
+(NSURL*)currentUserFBProfileURL;
+(NSURL*)currentUserInfoURL;
+(NSURL*)currentUserURL;

@end
