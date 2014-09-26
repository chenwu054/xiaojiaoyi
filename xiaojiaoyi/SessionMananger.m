//
//  SessionMananger.m
//  xiaojiaoyi
//
//  Created by chen on 9/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "SessionMananger.h"

#define LOGIN_TOKEN_DIR "LoginTokens"
#define FACEBOOK_DIR "Facebook"
#define TOKEN_FILE_NAME "token.plist"
#define APP_ID "337462276428867"
@implementation SessionMananger

-(void) loginFacebook
{
    [self printCurrentSessionWithSignature:@"***"];
    
    if(_fbSession == nil || _fbSession.state == FBSessionStateClosed){
        _fbSession = [self createFBSession];
    }
    if(_fbSession.state == FBSessionStateOpen || _fbSession.state == FBSessionStateOpenTokenExtended){
        return;
    }
    if(_fbSession.state == FBSessionStateCreated || _fbSession.state == FBSessionStateCreatedTokenLoaded){
        [_fbSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if(error || status != FBSessionStateOpen || status != FBSessionStateOpenTokenExtended){
                
                NSLog(@"open session with ERROR!");
            }
            else
                NSLog(@"open session NO error!");
            [self printCurrentSessionWithSignature:@"---"];
        }];
    }
    
    
}
-(FBSession *) createFBSession
{
    MyFBSessionTokenCachingStrategy * strategy = [self createMyTokenCachingStrategy];
    FBSession * session = [[FBSession alloc] initWithAppID:@APP_ID permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:strategy];
    
    return session;
    
}
-(MyFBSessionTokenCachingStrategy*)createMyTokenCachingStrategy
{
    MyFBSessionTokenCachingStrategy *strategy = [[MyFBSessionTokenCachingStrategy alloc]
                                                 initWithFilePath:[NSString stringWithFormat:@"%s/%s",LOGIN_TOKEN_DIR,FACEBOOK_DIR] andFileName:@TOKEN_FILE_NAME];
    return strategy;
}

//-(FBSession *) getFBSession
//{
//    if()
//}

-(void) logoutFacebook
{
    if(_fbSession.state == FBSessionStateOpenTokenExtended || _fbSession.state == FBSessionStateOpen){
        [_fbSession closeAndClearTokenInformation];
        if(_fbSession.state == FBSessionStateClosed){
            NSLog(@"successfully log out");
        }
    }
}

-(NSString *)getFBLogedinUsername
{
    return nil;
}
#pragma mark - debug
-(void) printCurrentSessionWithSignature:(NSString*) sig
{
    NSLog(@"%@ - current session is: %@",sig, _fbSession);
}
-(void) printDirectory
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSDirectoryEnumerator * enumerator= [[NSFileManager defaultManager] enumeratorAtPath: documentsDirectory];
    for(NSURL * url in enumerator){
        NSLog(@"file is %@",url);
    }
}

@end
