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

#define XJY_URL_SCHEME "study.xiaojiaoyi"

#define APP_ID "337462276428867"

#define TW_ACCESS_TOKEN_KEY "access_token";
#define TW_ACCESS_TOKEN_SECRET_KEY "access_token_secret";
#define TW_REQUEST_TOKEN_KEY "request_token";
#define TW_REQUEST_TOKEN_SECRET_KEY "request_token_secret";
#define TW_OAUTH_VERIFIER_KEY "oauth_verifier";
#define TW_OAUTH_VERIFIER_TOKEN_KEY "oauth_verfier_token";
#define TW_USER_ID_KEY "user_id";
#define TW_SCREEN_NAME_KEY "screen_name";
#define TW_USER_NAME_KEY "user_name";
#define TW_USER_IMAGE_URL_KEY "user_image_url";

#define LK_ACCESS_TOKEN "access_token"
#define LK_EXPIRES_IN "expires_in"
#define LK_REQUEST_TOKEN "request_token"
//#define LK_API_KEY @"75iapcxav6yub5";
//#define LK_DEFAULT_SCOPE @"r_basicprofile"
//#define LK_DEFAULT_STATE @"ThisIsARandomeState"
//#define LK_REDIRECT_URL @"http://xiaojiaoyi_linkedin_redirectURL"

@implementation SessionManager

static TWSession* twSession;
static FBSession* fbSession;
static NSDictionary* lkSession;
static MyFBSessionTokenCachingStrategy* myFBTokenCachingStrategy;

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
//============================================================================
#pragma mark - linkedin login methods
+(BOOL)writeLKSessionCache:(NSDictionary*)session
{
    NSString *filePath = [self getFileDirWithOAuthType:LINKEDIN];
    NSString *file = [self getFilePathWithOAuthLoginType:LINKEDIN withFilename:@TOKEN_FILE_NAME];
    //NSLog(@"linkedin file is %@",file);
    if (![[NSFileManager defaultManager] fileExistsAtPath:file])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    return [session writeToFile:file atomically:YES];
}
+(NSDictionary*)readLKSessionCache
{
    NSString *file = [self getFilePathWithOAuthLoginType:LINKEDIN withFilename:@TOKEN_FILE_NAME];
    lkSession =  [[NSDictionary alloc] initWithContentsOfFile:file];
    
    return lkSession;
}
+(void)clearLKSessionCache
{
    NSString *file = [self getFilePathWithOAuthLoginType:LINKEDIN withFilename:@TOKEN_FILE_NAME];
    NSDictionary * nilDict = nil;
    [nilDict writeToFile:file atomically:YES];
    
}

//============================================================================
#pragma mark - twitter login methods
+(TWSession*)twSession
{
    if(!twSession)
        twSession = [[TWSession alloc] init];
    return twSession;
}

+(NSDictionary*)readTWSessionCache
{
    NSString *file = [self getFilePathWithOAuthLoginType:TWITTER withFilename:@TOKEN_FILE_NAME];
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:file];
    return dict;
}
+(BOOL)clearTwitterLocalCache
{
    NSString *file = [self getFilePathWithOAuthLoginType:TWITTER withFilename:@TOKEN_FILE_NAME];
    NSDictionary * nilDict = nil;
    return [nilDict writeToFile:file atomically:YES];
}
+(BOOL)writeProfileImage:(NSData *)imageData
{
//    NSString *filePath = [self getFileDirWithOAuthType:TWITTER];
    NSLog(@"the data is %@",imageData);
    NSString *file = [self getFilePathWithOAuthLoginType:TWITTER withFilename:@PROFILE_IMAGE_FILE];
    //NSLog(@"twitter file is %@",file);
    
    BOOL result = [imageData writeToFile:file options:NSDataWritingAtomic error:NULL];
    NSLog(@"the result is %d", result);
    return result;
}
+(void)loadTWSession
{
    NSDictionary* dict = [self readTWSessionCache];
    TWSession *currentSession = [SessionManager twSession];
    currentSession.access_token = [dict valueForKey:@"access_token"];
    currentSession.access_token_secret = [dict valueForKey:@"access_token_secret"];
    currentSession.request_token = [dict valueForKey:@"request_token"];
    currentSession.request_token_secret = [dict valueForKey:@"request_token_secret"];
    currentSession.oauth_verifier = [dict valueForKey:@"oauth_verifier"];
    currentSession.oauth_verifier_token=[dict valueForKey:@"oauth_verfier_token"];
    currentSession.user_id_str = [dict valueForKey:@"user_id"];
    currentSession.screen_name = [dict valueForKey:@"screen_name"];
    currentSession.user_name = [dict valueForKey:@"user_name"];
    currentSession.user_image_url = [dict valueForKey:@"user_image_url"];
}
+(BOOL) writeTWSessionCache:(NSDictionary*)dict
{
    NSString *filePath = [self getFileDirWithOAuthType:TWITTER];
    NSString *file = [self getFilePathWithOAuthLoginType:TWITTER withFilename:@TOKEN_FILE_NAME];
    NSLog(@"twitter file is %@",file);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:file])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    if(dict)
        return [dict writeToFile:file atomically:YES];
   
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          twSession.access_token,@"access_token",
                          twSession.access_token_secret,@"access_token_secret",
                          twSession.request_token,@"request_token",
                          twSession.request_token_secret, @"request_token_secret",
                          twSession.oauth_verifier, @"oauth_verifier",
                          twSession.oauth_verifier_token,@"oauth_verfier_token",
                          twSession.user_id_str,@"user_id",
                          twSession.screen_name,@"screen_name",
                          twSession.user_name,@"user_name",
                          twSession.user_image_url,@"user_image_url",nil];
    
    return [data writeToFile:file atomically:YES];
}
+(void)clearUpTWSession
{
    
    
}

//================Facebook methods============================================
#pragma mark - facebook methods
+(FBSession *)fbSession
{
    if(!fbSession){
        MyFBSessionTokenCachingStrategy * strategy = [SessionManager myFBTokenCachingStrategy];
        fbSession = [[FBSession alloc] initWithAppID:@APP_ID permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:strategy];
//        fbSession = [self fbSessionWithRecreate:NO];
        [FBSession setActiveSession:fbSession];
    }
    return fbSession;
}
+(void)setFBSession:(FBSession*)newSession
{
    fbSession = newSession;
}

+(FBSession *)fbSessionWithRecreate:(BOOL)recreate
{
    //static FBSession* fbSession;
    if(recreate){
        fbSession = [self createFBSession];
    }
    return fbSession;
}
+(FBSession *)createFBSession
{
    MyFBSessionTokenCachingStrategy * strategy = [SessionManager myFBTokenCachingStrategy];
    FBSession * session = [[FBSession alloc] initWithAppID:@APP_ID permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:strategy];
    return session;
}
+(MyFBSessionTokenCachingStrategy *)myFBTokenCachingStrategy
{
    if(!myFBTokenCachingStrategy){
        myFBTokenCachingStrategy=[[MyFBSessionTokenCachingStrategy alloc] initWithFilePath:[self getFileDirWithOAuthType:FACEBOOK] andFileName:@TOKEN_FILE_NAME];
    }
    return myFBTokenCachingStrategy;
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
    FBSession * session = [SessionManager fbSession];// [self fbSession];
    if(session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended){
        handler(session,session.state,NULL);
        return;
    }
    if(session.state == FBSessionStateClosed || session.state == FBSessionStateClosedLoginFailed){
        session = [self createFBSession];
        [FBSession setActiveSession:session];
        [SessionManager setFBSession:session];
        //session = [self fbSessionWithRecreate:YES];
    }
    if(session.state != FBSessionStateOpen && session.state != FBSessionStateOpenTokenExtended){
        //NSLog(@"session is not open, about to open");
        [session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            //NSLog(@"about to do the login handler");
            handler(session,status,error);
        }];
    }
}

+(void)uploadImage:(UIImage*)image withCompletionHandler:(void(^)(FBRequestConnection *connection, id result, NSError *error))handler
{
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        handler(connection,result,error);
    }];
}
+(void)checkFBPermissionsWithCompletionHandler:(void(^)(FBRequestConnection *connection, id result, NSError *error))handler
{
    if([FBSession activeSession].state!=FBSessionStateOpen&&[FBSession activeSession].state!=FBSessionStateOpenTokenExtended){
        FBSession.activeSession = [self fbSession];
    }
    [FBRequestConnection startWithGraphPath:@"/me/permissions" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        handler(connection,result,error);
                              
     }];
}
+(void)requestPublicActionPermissionWithCompletionHandler:(void(^)(FBSession* session, NSError* error))handler
{
    FBSession.activeSession = [self fbSession];
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            
                                            handler(session,error);
                                            
                                        }];
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
    FBSession * currentSession = [SessionManager fbSession];
    if(revokePermissions){
        if(currentSession.state & FB_SESSIONSTATEOPENBIT){
            [self revokeFBPermissionsWithCompletionHandler:^{
                if(cleanCache){
                    [currentSession closeAndClearTokenInformation];
                }
                else{
                    [currentSession close];
                }
                //VERY ESSENTIAL!!! everytime user logs out, will delete the session and create a new one.
                //[self fbSessionWithRecreate:YES];
                if(handler)
                    handler(currentSession,currentSession.state,NULL);
            }];
        }
    }
    else{
        NSLog(@"the session is%@", currentSession);
        if(currentSession.state & FB_SESSIONSTATEOPENBIT){
            if(cleanCache){
                [currentSession closeAndClearTokenInformation];
            }
            else{
                [currentSession close];
            }
            //VERY ESSENTIAL!!! everytime user logs out, will delete the session and create a new one.
            //[self fbSessionWithRecreate:YES];
        }
        if(handler)
            handler(currentSession,currentSession.state,NULL);
    }
}


//========================================================
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


