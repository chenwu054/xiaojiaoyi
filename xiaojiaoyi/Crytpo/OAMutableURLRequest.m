//
//  OAMutableURLRequest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OAMutableURLRequest.h"


@interface OAMutableURLRequest (Private)
- (void)_generateTimestamp;
- (void)_generateNonce;
@end

@implementation OAMutableURLRequest
//@synthesize signature, nonce;

#pragma mark init

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider {
    self = [super initWithURL:aUrl
           cachePolicy:NSURLRequestReloadIgnoringCacheData
       timeoutInterval:10.0];
    
    _consumer = aConsumer;
    
    // empty token for Unauthorized Request Token transaction
    if (aToken == nil) {
        _token = [[OAToken alloc] init];
    } else {
        _token = aToken;
    }
    
    if (aRealm == nil) {
        _realm = @"";
    } else {
        _realm = aRealm;
    }
      
    // default to HMAC-SHA1
    if (aProvider == nil) {
        _signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    } else {
        _signatureProvider = aProvider;
    }
    
    [self _generateTimestamp];
    [self _generateNonce];
    
    return self;
}

// Setting a timestamp and nonce to known
// values can be helpful for testing
- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider
            nonce:(NSString *)aNonce
        timestamp:(NSString *)aTimestamp {
    self = [self initWithURL:aUrl
             consumer:aConsumer
                token:aToken
                realm:aRealm
    signatureProvider:aProvider];
    
    _nonce = [aNonce copy];
    _timestamp = [aTimestamp copy];
    
    return self;
}

- (void)prepare {
    // sign
//	NSLog(@"Base string is: %@", [self _signatureBaseString]);
   _signature = [_signatureProvider signClearText:[self signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
                                                  [_consumer.secret encodedURLParameterString],
                                                  _token.secret ? [_token.secret encodedURLParameterString] : @""]];
    //NSLog(@"signature is:%@",_signature);
    
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	[chunks addObject:[NSString stringWithFormat:@"realm=\"%@\"", _realm]];
    //[chunks addObject:[NSString stringWithFormat:@"realm=\"%@\"", [_realm encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];

	NSDictionary *tokenParameters = [_token parameters];
	for (NSString *k in tokenParameters) {
		[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParameters objectForKey:k] encodedURLParameterString]]];
	}

	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
	
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    
//    NSDictionary *dict = self.allHTTPHeaderFields;
//    for(NSString * k in dict.keyEnumerator){
//        NSLog(@"oauth header is:%@ for key: %@", [dict valueForKey:k],k);
//    }
    
    
}

- (void)_generateTimestamp {
    _timestamp = [[NSString alloc]initWithFormat:@"%ld", time(NULL)];
}

- (void)_generateNonce {
//    CFUUIDRef theUUID = CFUUIDCreate(NULL);
//    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
//    NSMakeCollectable(theUUID);
//	if (nonce) {
//		CFRelease(nonce);
//	}
//    nonce = (NSString *)string;
    int r = arc4random();
    _nonce = [NSString stringWithFormat:@"randomNonce%d",r];
}

- (NSString *)signatureBaseString {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
	NSDictionary *tokenParameters = [_token parameters];
	// 5 being the number of OAuth params in the Signature Base String
	NSArray *parameters = [self parameters];
	NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(5 + [parameters count] + [tokenParameters count])];
    
	OARequestParameter *parameter;
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_consumer_key" value:_consumer.key];
	
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
	
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_signature_method" value:[_signatureProvider name]];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];

	parameter = [[OARequestParameter alloc] initWithName:@"oauth_timestamp" value:_timestamp];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];

	parameter = [[OARequestParameter alloc] initWithName:@"oauth_nonce" value:_nonce];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];

	parameter = [[OARequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"] ;
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];

	//add all the parameters in the tokenParameters
	for(NSString *k in tokenParameters) {
		[parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParameters objectForKey:k]] URLEncodedNameValuePair]];
	}
    //add all the request parameters in the request if it is NOT multipart request!!
	if (![[self valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
		for (OARequestParameter *param in parameters) {
			[parameterPairs addObject:[param URLEncodedNameValuePair]];
		}
	}
    //sort and normalize.
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];

	//	NSLog(@"Normalized: %@", normalizedRequestParameters);
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString * baseString = [NSString stringWithFormat:@"%@&%@&%@",
            [self HTTPMethod],
            [[[self URL] URLStringWithoutQuery] encodedURLParameterString],
            [normalizedRequestParameters encodedURLString]];
    //NSLog(@"base string is:%@",baseString);
    return baseString;
}

@end
