//
//  MyFBSessionTokenCachingStrategy.h
//  xiaojiaoyi
//
//  Created by chen on 9/23/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface MyFBSessionTokenCachingStrategy : FBSessionTokenCachingStrategy

@property (nonatomic, strong) NSString *tokenFilePath;
- (NSString *) filePath;

@end