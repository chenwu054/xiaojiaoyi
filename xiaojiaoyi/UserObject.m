//
//  UserObject.m
//  xiaojiaoyi
//
//  Created by chen on 11/3/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "UserObject.h"
#define USER_DEFAULTS_USER_INFO_KEY @"user_info"

@interface UserObject ()


@end

@implementation UserObject
static UserObject* currentUser;

+(UserObject*)currentUser
{
    if(!currentUser){
        currentUser = [[UserObject alloc] init];
    }
    return currentUser;
}
+(void)updateCurrentUser:(UserObject*)user
{
    currentUser = user;
}

+(void)updateCurrentUserWithNewInfo:(NSDictionary*)dict
{
    UserObject* user = [UserObject currentUser];
    NSMutableDictionary* curDict = [self convertToDictionaryFromUser:user];
    for(NSString* k in dict){
        curDict[k] = dict[k];
    }
    [self convertToUser:user FromDictionary:curDict];
}

+(UserObject*)loadUserObjectFromUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [defaults objectForKey:USER_DEFAULTS_USER_INFO_KEY];
    UserObject* user = [[UserObject alloc] init];
    [self convertToUser:user FromDictionary:dict];
    
    return user;
}

+(void)updateUserObjectInUserDefaults:(UserObject*)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [self convertToDictionaryFromUser:user==nil?[UserObject currentUser]:user];
    [defaults setObject:dict forKey:USER_DEFAULTS_USER_INFO_KEY];
    
    [defaults synchronize];
}

+(void)loadUserObjectFromFileToCurrentUser
{
    UserObject* user = [UserObject currentUser];
    NSURL* currentUserURL = [self currentUserInfoURL];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:currentUserURL];
    user.username = dict[@"username"];
    user.userLogin = dict[@"userLogin"];
    user.email = dict[@"email"];
    user.password =dict[@"password"];
    user.user_last_login=dict[@"user_last_login"];
    
    user.fbLogin = dict[@"fbLogin"];
    user.fbUsername=dict[@"fbUsername"];
    user.fbID=dict[@"fbID"];
    user.fbProfileURL=dict[@"fbProfileURL"];
    user.fbAccessToken = dict[@"fbAccessToken"];
    user.fbExpireDate = dict[@"fbExpireDate"];
    
    user.twLogin = dict[@"twLogin"];
    user.twAccessToken=dict[@"twAccessToken"];
    user.twUsername=dict[@"twUsername"];
    user.twProfileURL=dict[@"twProfileURL"];
    user.twExpireDate=dict[@"twExpireDate"];
    
    user.ggLogin=dict[@"ggLogin"];
    user.ggAccessToken=dict[@"ggAccessToken"];
    user.ggUsername=dict[@"ggUsername"];
    user.ggProfileURL=dict[@"ggProfileURL"];
    user.ggExpireDate=dict[@"ggExpireDate"];
    
    user.lkLogin=dict[@"lkLogin"];
    user.lkAccessToken=dict[@"lkAccessToken"];
    user.lkUsername=dict[@"lkUsername"];
    user.lkProfileURL=dict[@"lkProfile"];
    user.lkExpireDate=dict[@"lkExpireDate"];
}

+(UserObject*)loadUserObjectFromFile
{
    NSURL* currentUserURL = [self currentUserInfoURL];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:currentUserURL];
    UserObject* user = [[UserObject alloc] init];
    user.username = dict[@"username"];
    user.userLogin = dict[@"userLogin"];
    user.email = dict[@"email"];
    user.password =dict[@"password"];
    user.user_last_login=dict[@"user_last_login"];

    user.fbLogin = dict[@"fbLogin"];
    user.fbUsername=dict[@"fbUsername"];
    user.fbID = dict[@"fbID"];
    user.fbProfileURL=dict[@"fbProfileURL"];
    user.fbAccessToken = dict[@"fbAccessToken"];
    user.fbExpireDate = dict[@"fbExpireDate"];
    
    user.twLogin = dict[@"twLogin"];
    user.twAccessToken=dict[@"twAccessToken"];
    user.twUsername=dict[@"twUsername"];
    user.twProfileURL=dict[@"twProfileURL"];
    user.twExpireDate=dict[@"twExpireDate"];
    
    user.ggLogin=dict[@"ggLogin"];
    user.ggAccessToken=dict[@"ggAccessToken"];
    user.ggUsername=dict[@"ggUsername"];
    user.ggProfileURL=dict[@"ggProfileURL"];
    user.ggExpireDate=dict[@"ggExpireDate"];
    
    user.lkLogin=dict[@"lkLogin"];
    user.lkAccessToken=dict[@"lkAccessToken"];
    user.lkUsername=dict[@"lkUsername"];
    user.lkProfileURL=dict[@"lkProfile"];
    user.lkExpireDate=dict[@"lkExpireDate"];
    return user;
}
+(void)updateUserObjectToFile:(UserObject*)user
{
    
    NSDictionary* dict = [self convertToDictionaryFromUser:user==nil?[UserObject currentUser]:user];
    NSURL* url = [self currentUserInfoURL];
    [dict writeToURL:url atomically:YES];
}

#pragma mark - utils methods

+(NSMutableDictionary*)convertToDictionaryFromUser:(UserObject*)user
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(user.username)
        [dict setObject:user.username forKey:@"username"];
    if(user.password)
        [dict setObject:user.password forKey:@"password"];
    if(user.userLogin)
        [dict setObject:[NSNumber numberWithBool:user.userLogin]  forKey:@"userLogin"];
    if(user.email)
        [dict setObject:user.email forKey:@"email"];
    if(user.user_last_login)
        [dict setObject:user.user_last_login forKey:@"user_last_login"];
    
    if(user.fbLogin)
        [dict setObject:[NSNumber numberWithBool:user.fbLogin] forKey:@"fbLogin"];
    if(user.fbUsername)
        [dict setObject:user.fbUsername forKey:@"fbUsername"];
    if(user.fbID)
        [dict setObject:user.fbID forKey:@"fbID"];
    if(user.fbProfileURL)
        [dict setObject:user.fbProfileURL forKey:@"fbProfileURL"];
    if(user.fbAccessToken)
        [dict setObject:user.fbAccessToken forKey:@"fbAccessToken"];
    if(user.fbExpireDate)
        [dict setObject:user.fbExpireDate forKey:@"fbExpireDate"];
    
    if(user.twLogin)
        [dict setObject:[NSNumber numberWithBool:user.twLogin] forKey:@"twLogin"];
    if(user.twUsername)
        [dict setObject:user.twUsername forKey:@"twUsername"];
    if(user.twProfileURL)
        [dict setObject:user.twProfileURL forKey:@"twProfileURL"];
    if(user.twAccessToken)
        [dict setObject:user.twAccessToken forKey:@"twAccessToken"];
    if(user.twExpireDate)
        [dict setObject:user.twExpireDate forKey:@"twExpireDate"];
    
    if(user.ggLogin)
        [dict setObject:[NSNumber numberWithBool:user.ggLogin] forKey:@"ggLogin"];
    if(user.ggUsername)
        [dict setObject:user.ggUsername forKey:@"ggUsername"];
    if(user.ggProfileURL)
        [dict setObject:user.ggProfileURL forKey:@"ggProfileURL"];
    if(user.ggAccessToken)
        [dict setObject:user.ggAccessToken forKey:@"ggAccessToken"];
    if(user.ggExpireDate)
        [dict setObject:user.ggExpireDate forKey:@"ggExpireDate"];
    
    if(user.lkLogin)
        [dict setObject:[NSNumber numberWithBool:user.lkLogin] forKey:@"lkLogin"];
    if(user.lkUsername)
        [dict setObject:user.lkUsername forKey:@"lkUsername"];
    if(user.lkProfileURL)
        [dict setObject:user.lkProfileURL forKey:@"lkProfileURL"];
    if(user.lkAccessToken)
        [dict setObject:user.lkAccessToken forKey:@"lkAccessToken"];
    if(user.lkExpireDate)
        [dict setObject:user.lkExpireDate forKey:@"lkExpireDate"];
    return dict;
}

+(void)convertToUser:(UserObject*)user FromDictionary:(NSDictionary*)dict
{
    //UserObject* user = [[UserObject alloc] init];
    
    user.username = dict[@"username"];
    user.userLogin = dict[@"userLogin"];
    user.email = dict[@"email"];
    user.password =dict[@"password"];
    user.user_last_login=dict[@"user_last_login"];
    
    user.fbLogin = dict[@"fbLogin"];
    user.fbUsername=dict[@"fbUsername"];
    user.fbID=dict[@"fbID"];
    user.fbProfileURL=dict[@"fbProfileURL"];
    user.fbAccessToken = dict[@"fbAccessToken"];
    user.fbExpireDate = dict[@"fbExpireDate"];
    
    user.twLogin = dict[@"twLogin"];
    user.twAccessToken=dict[@"twAccessToken"];
    user.twUsername=dict[@"twUsername"];
    user.twProfileURL=dict[@"twProfileURL"];
    user.twExpireDate=dict[@"twExpireDate"];
    
    user.ggLogin=dict[@"ggLogin"];
    user.ggAccessToken=dict[@"ggAccessToken"];
    user.ggUsername=dict[@"ggUsername"];
    user.ggProfileURL=dict[@"ggProfileURL"];
    user.ggExpireDate=dict[@"ggExpireDate"];
    
    user.lkLogin=dict[@"lkLogin"];
    user.lkAccessToken=dict[@"lkAccessToken"];
    user.lkUsername=dict[@"lkUsername"];
    user.lkProfileURL=dict[@"lkProfile"];
    user.lkExpireDate=dict[@"lkExpireDate"];

}
-(NSString*)description
{
    return [NSString stringWithFormat:@"username:%@; userLogin:%d; password:%@; email:%@; user_last_login:%@; fbLogin:%d; fbUsername:%@; fbID:%@; fbProfileURL:%@; fbAccessToken:%@; fbExpireDate:%@; twLogin:%d; twUsername:%@; twProfileURL:%@; twAccessToken:%@; twExpireDate:%@; ggLogin:%d; ggUsername:%@; ggProfileURL:%@; ggAccessToken:%@; ggExpireDate:%@; lkLogin:%d; lkUsername:%@; lkProfileURL:%@; lkAccessToken:%@; lkExpireDate:%@",self.username,self.userLogin,self.password,self.email,self.user_last_login,self.fbLogin,self.fbUsername,self.fbID,self.fbProfileURL,self.fbAccessToken,self.fbExpireDate,self.twLogin,self.twUsername,self.twProfileURL,self.twAccessToken,self.twExpireDate,self.ggLogin,self.ggUsername,self.ggProfileURL,self.ggAccessToken,self.ggExpireDate, self.lkLogin,self.lkUsername,self.lkProfileURL,self.lkAccessToken,self.lkExpireDate];
}
+(NSURL*)currentUserLKProfileURL
{
    NSURL* userURL = [self currentUserURL];
    return [userURL URLByAppendingPathComponent:@"lkProfile"];
}
+(NSURL*)currentUserGGProfileURL
{
    NSURL* userURL = [self currentUserURL];
    return [userURL URLByAppendingPathComponent:@"ggProfile"];
}
+(NSURL*)currentUserTWProfileURL
{
    NSURL* userURL = [self currentUserURL];
    return [userURL URLByAppendingPathComponent:@"twProfile"];
}
+(NSURL*)currentUserFBProfileURL
{
    NSURL* userURL = [self currentUserURL];
    return [userURL URLByAppendingPathComponent:@"fbProfile"];
}
+(NSURL*)currentUserInfoURL
{
    NSURL* userURL = [self currentUserURL];
    if(![[NSFileManager defaultManager] fileExistsAtPath:userURL.path]){
        [[NSFileManager defaultManager] createDirectoryAtURL:userURL withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [userURL URLByAppendingPathComponent:@"userInfo"];
}
+(NSURL*)currentUserURL
{
    NSURL* userURL = [self userURL];
    return [userURL URLByAppendingPathComponent:@"currentUser"];
}
+(NSURL*)userURL
{
    NSURL* docDir = [self documentsURL];
    return [docDir URLByAppendingPathComponent:@"Users"];
}

+(NSURL*)documentsURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

@end
