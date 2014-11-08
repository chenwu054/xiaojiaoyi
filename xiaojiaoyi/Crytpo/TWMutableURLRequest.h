//
//  TWMutableURLRequest.h
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAToken.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OASignatureProviding.h"
#import "NSString+URLEncoding.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSURL+Base.h"


@interface TWMutableURLRequest : NSMutableURLRequest{

}
//consumer is the app key ID
@property (nonatomic) OAConsumer* consumer;
//token is the access_token and access_token_secret
@property (nonatomic) OAToken *token;
@property (nonatomic) id<OASignatureProviding> signatureProvider;
@property(readonly,nonatomic) NSString *signature;
@property(readonly) NSString *nonce;
@property (readonly) NSString *timestamp;
@property (readonly) NSString *callbackURL;

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
      callbackURL:(NSString*)callbackURL
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider;

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
      callbackURL:(NSString*)callbackURL
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider
            nonce:(NSString *)aNonce
        timestamp:(NSString *)aTimestamp;

- (void)prepare;
- (void)prepareForUpload;
-(void)prepareForStatusUpdate:(NSString*)status;
-(void)prepareForTimelineWithUserId:(NSString*)userId andScreenName:(NSString*)screenName;

- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)tokenParams andBodyParams:(NSMutableDictionary*)bodyParams;
- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)tokenParams andQueryParams:(NSMutableDictionary*)queryParams;
- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)tokenParams queryParams:(NSMutableDictionary*)queryParams andBodyParams:(NSMutableDictionary*)bodyParams;


- (NSString *)signatureBaseString;

@end
