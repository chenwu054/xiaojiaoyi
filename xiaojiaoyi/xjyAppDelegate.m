//
//  xjyAppDelegate.m
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "xjyAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

@implementation xjyAppDelegate

//static NSString * const kClientId = @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[FBLoginView class];
    
    //do not check FBSession 
    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//    }
    return YES;
}




-(void) sessionStateChanged:(FBSession*) session state:(FBSessionState)state error:(NSError*) error
{
    NSLog(@"calling the fb session state change in the appDelegate to state: %ld",state);
    
}


//- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
//    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//    
//    // You can add your app-specific url handling code here if needed
//    
//    return wasHandled;
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //this will clean up the flow and eventually transtion to the closeLoginFailed
    
    [FBAppCall handleDidBecomeActiveWithSession:[SessionManager fbSession]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //good practice, transition state to closed but does NOT clear cached data or delete session
    [[SessionManager fbSession] close];
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

//has the required method from facebook
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //NSLog(@"scheme is %@", [url scheme]);
    // this is the methods that prevents FBAppCall to handle openRUL
    //if ([[url scheme] isEqualToString:@"http"] == NO) return NO;
    //NSLog(@"the open URL is %@",url);
    
    //NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    //NSString *token = d[@"oauth_token"];
    //NSString *verifier = d[@"oauth_verifier"];
    
    //LoginViewController *lvc = (LoginViewController *)[[self window] rootViewController];
    //[lvc setOAuthToken:token oauthVerifier:verifier];
    
    //let FBAppCall handle incoming url
    //NSLog(@"appDelegate handle openURL:%@",url);
    
    
//    NSString * urlStr = [url description];
//    NSLog(@"urlStr is %@",urlStr);
//    NSRange linkedinRange = [urlStr rangeOfString:@"linkedin"];
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    loginVC.linkedinCallback=urlStr;
//    if(linkedinRange.location!=NSNotFound){
//        //[self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
//        return YES;
//    }
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[SessionManager fbSession]] || [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
