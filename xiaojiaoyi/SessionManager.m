//
//  SessionMananger.m
//  xiaojiaoyi
//
//  Created by chen on 9/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//
#import "SessionManager.h"

#define LOGIN_TOKEN_DIR "LoginTokens"
#define FACEBOOK_DIR "Facebook"
#define LINKEDIN_DIR "Linkedin"
#define TWITTER_DIR "Twitter"
#define GOOGLE_DIR "Google"
#define TOKEN_FILE_NAME "token.plist"
#define PROFILE_FILE_NAME "profile.plist"
#define PROFILE_IMAGE_FILE "profile.image"

#define APP_ID "337462276428867"


@implementation SessionManager

static BOOL isTwitter;
static BOOL isLinkedin;
static NSString* redirectURL;

#pragma mark - utils

//here @synchronized is not used because only main thread will use this method
+(NSString*)documentsDir
{
    static NSString *documentsDir;
    if(!documentsDir){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [paths firstObject];
    }
    return documentsDir;
}

//here @synchronized is not used because only main thread will use this method
+(NSString*)tokenCacheDir
{
    static NSString *tokenCacheDir;
    
    if(!tokenCacheDir){
        tokenCacheDir = [NSString stringWithFormat:@"%@/%@",[self documentsDir],@LOGIN_TOKEN_DIR];
    }
    
    return tokenCacheDir;
}

+(NSString*)getFileDirWithOAuthType:(MyOAuthLoginType)oauthType
{
    if(oauthType==FACEBOOK){
        return [NSString stringWithFormat:@"%@/%@",[self tokenCacheDir],@FACEBOOK_DIR];
    }
    else if(oauthType == LINKEDIN){
        return [NSString stringWithFormat:@"%@/%@",[self tokenCacheDir],@LINKEDIN_DIR];
    }
    else if(oauthType == TWITTER){
        return [NSString stringWithFormat:@"%@/%@",[self tokenCacheDir],@TWITTER_DIR];
    }
    else if(oauthType == GOOGLE){
        return [NSString stringWithFormat:@"%@/%@",[self tokenCacheDir],@GOOGLE_DIR];
    }
    else
        return nil;
}

+(NSString*)getFilePathWithOAuthLoginType:(MyOAuthLoginType)oauthType withFilename:(NSString*)filename
{
    NSString *dir = [self getFileDirWithOAuthType:oauthType];
    return dir?[NSString stringWithFormat:@"%@/%@",dir,filename]:nil;
}
+(NSArray *)getUsernameAndImageURLWithOAuthType:(MyOAuthLoginType)oauthType
{
    NSString *filePath = [self getFilePathWithOAuthLoginType:oauthType withFilename:@PROFILE_FILE_NAME];
    return filePath?[NSArray arrayWithContentsOfFile:filePath]:nil;
}

+(BOOL)writeUsername:(NSString*)username imageURL:(NSString*)imageURL forOAuthType:(MyOAuthLoginType)oauthType
{
    NSArray * arr = [NSArray arrayWithObjects:username,imageURL, nil];
    NSString *filePath = [self getFilePathWithOAuthLoginType:oauthType withFilename:@PROFILE_FILE_NAME];
    return [arr writeToFile:filePath atomically:YES];
}


#pragma mark - login flow methods
+(BOOL)openSessionWithOAuthLoginType:(MyOAuthLoginType)oauthType
{
    return  NO;
}
+(BOOL)refreshSession:(MyOAuthLoginType)oauthType withCompletionHandler:(void(^)(BOOL success))handler
{
    
    return NO;
}
+(void)loginWithOAuthLoginType:(MyOAuthLoginType)oauthType withCompletionHandler:(void(^)(NSString *urlString, NSString* username, NSError* error))handler
{
    if(oauthType == FACEBOOK){
        [self loginFacebook];
    }
    else if(oauthType == TWITTER){
        
    }
    else if(oauthType == LINKEDIN){
        
    }
    else if(oauthType == GOOGLE){
        
    }
    else{
        
    }
    
}
-(void)logoutWithOAuthLoginType:(MyOAuthLoginType)oauthType withCompletionHandler:(void(^)(BOOL success))handler
{
    
}

#pragma mark - twitter login methods

+(void)loginTwitter
{
    
}
+(void)logoutTwitter
{
    
}
+(void)logoutTwitterWithCompletionHanlder:(void(^)(BOOL succes))handler
{
    
}
+(void)loginTwitterWithCompletionHandler:(void(^)(BOOL success, NSString *accessToken))handler
{
    
}
+(BOOL)writeTwitterLocalCache
{
    
    return NO;
}
+(BOOL)clearTwitterLocalCache
{
    return NO;
}
+(NSDictionary*)loadTwitterAccessDataFromCache
{
    return nil;
}


#pragma mark - facebook methods
+(FBSession *)fbSession
{
    return [self fbSessionWithRecreate:NO];
}

+(FBSession *)fbSessionWithRecreate:(BOOL)recreate
{
    static FBSession* fbSession;
    {
        if(!fbSession || recreate){
            fbSession = [self createFBSession];
        }
    }
    return fbSession;
}

+(MyFBSessionTokenCachingStrategy *)myFBTokenCachingStrategy
{
    static MyFBSessionTokenCachingStrategy* myFBTokenCachingStrategy;
    {
        if(!myFBTokenCachingStrategy){
            myFBTokenCachingStrategy=[self createMyTokenCachingStrategy];
        }
    }
    return myFBTokenCachingStrategy;
}

+(FBSession *) createFBSession
{
    MyFBSessionTokenCachingStrategy * strategy = [self createMyTokenCachingStrategy];
    FBSession * session = [[FBSession alloc] initWithAppID:@APP_ID permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:strategy];
    
    return session;
    
}
+(MyFBSessionTokenCachingStrategy*)createMyTokenCachingStrategy
{
    MyFBSessionTokenCachingStrategy *strategy = [[MyFBSessionTokenCachingStrategy alloc]
                                                 initWithFilePath:[self getFileDirWithOAuthType:FACEBOOK] andFileName:@TOKEN_FILE_NAME];
    return strategy;
}
//this handler is executed every time a session state is changed.
+(void)refreshFBSessionFromLocalCacheWithCompletionHandler:(void(^)(FBSession* session,FBSessionState status, NSError *error))handler
{
    FBAccessTokenData * data = [[self myFBTokenCachingStrategy] fetchFBAccessTokenData];
    FBSession * session = [self fbSession];
    if(session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended || session.state == FBSessionStateCreatedTokenLoaded)
        return;
    
    NSLog(@"1. session state is %@", session);
    if(session.state == FBSessionStateClosed || session.state == FBSessionStateClosedLoginFailed)
        session = [self fbSessionWithRecreate:YES];
    NSLog(@"2. session state is %@", session);
    //cannot create from this state
    [session openFromAccessTokenData:data completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        handler(session,status,error);

    }];
}
+(void) loginFacebook
{
    //[self printCurrentSessionWithSignature:@"***"];
    [self loginFacebookWithCompletionHandler:nil];
    
}

+(void)loginFacebookWithCompletionHandler:(void(^)(FBSession *session, FBSessionState status, NSError *error))handler
{
    //[self printCurrentSessionWithSignature:@"***"];
    FBSession * session = [self fbSession];
    if(session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended){
        handler(session,session.state,NULL);
        return;
    }
    if(session.state == FBSessionStateClosed || session.state == FBSessionStateClosedLoginFailed){
        //session = [self createFBSession];
        session = [self fbSessionWithRecreate:YES];
    }
    if(session.state != FBSessionStateOpen && session.state != FBSessionStateOpenTokenExtended){
        //NSLog(@"session is not open, about to open");
        [session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            //NSLog(@"about to do the login handler");
            handler(session,status,error);
        }];
    }
}

+(void)checkFBPermissions
{
    FBSession.activeSession = [self fbSession];
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              //__block NSString *alertText;
                              //__block NSString *alertTitle;
                              if (!error){
                                  NSDictionary *permissions= [(NSArray *)[result data] objectAtIndex:0];
                                  NSLog(@"permissions are %@",permissions);
                                  if (![permissions objectForKey:@"public_profile"]){
                                      // Publish permissions not found, ask for publish_actions
                                      //[self requestPublishPermissions];
                                      
                                  } else {
                                      // Publish permissions found, publish the OG story
                                      //[self publishStory];
                                  }
                                  
                              } else {
                                  // There was an error, handle it
                                  // See https://developers.facebook.com/docs/ios/errors/
                              }
                          }];
}

+(void)revokeFBPermissionsWithCompletionHandler:(void(^)())handler
{
    FBSession.activeSession = [self fbSession];
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions" parameters:nil HTTPMethod:@"delete"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              __block NSString *alertText;
                              __block NSString *alertTitle;
                              //NSDictionary * dict = (NSDictionary*)result;
                              //NSString * value = [dict valueForKeyPath:@"success"];
                              //NSLog(@"after revoke session is %@",[self fbSession]);
                              //NSLog(@"error is %@",error);
                              if (!error) {
                                  // Revoking the permission worked
                                  alertTitle = @"Permission successfully revoked";
                                  alertText = @"This app will no longer post to Facebook on your behalf.";
                              }
                              else{
                                  alertTitle = @"Permissions are not revoked";
                                  alertText =@"Please try again or go to your Facebook page to revoke permissions";
                              }
                              
                              [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
                              handler();
                          }];
}

+(void) logoutFacebook
{
    return [self logoutFacebookCleanCache:NO revokePermissions:NO WithCompletionHandler:nil];
}

+(void) logoutFacebookCleanCache:(BOOL)cleanCache revokePermissions:(BOOL)revokePermissions WithCompletionHandler:(void(^)(FBSession *session, FBSessionState status, NSError *error))handler
{
    FBSession * currentSession = [self fbSession];
    if(revokePermissions){
        [self revokeFBPermissionsWithCompletionHandler:^{
            if(cleanCache){
                [currentSession closeAndClearTokenInformation];
            }
            else{
                [currentSession close];
            }
            //VERY ESSENTIAL!!! everytime user logs out, will delete the session and create a new one.
            [self fbSessionWithRecreate:YES];
            handler(currentSession,currentSession.state,NULL);
        }];
    }
    else{
        NSLog(@"the session is%@", currentSession);
        if(currentSession.state == FBSessionStateOpenTokenExtended || currentSession.state == FBSessionStateOpen){
            if(cleanCache){
                [currentSession closeAndClearTokenInformation];
            }
            else{
                [currentSession close];
            }
            //VERY ESSENTIAL!!! everytime user logs out, will delete the session and create a new one.
            [self fbSessionWithRecreate:YES];
        }
        handler(currentSession,currentSession.state,NULL);
    }
}

#pragma mark - debug
+(void) printCurrentSessionWithSignature:(NSString*) sig
{
    NSLog(@"%@ - current session is: %@",sig, self.fbSession);
}

+(void) printDirectory
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


