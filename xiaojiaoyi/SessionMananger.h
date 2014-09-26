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

@interface SessionMananger : NSObject

@property (nonatomic) FBSession *fbSession;
@property (nonatomic) NSString *fbTokenCacheFileName;
@property (nonatomic) FBSessionTokenCachingStrategy *myFBSessionTokenCachingStrategy;

-(void) loginFacebook;
//-(FBSession *) getFBSession;
-(void) logoutFacebook;
-(NSString *)getFBLogedinUsername;


@end

//TODO: add session delegate !
