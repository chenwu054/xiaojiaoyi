//
//  TWMutableURLRequest.m
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "TWMutableURLRequest.h"

@interface TWMutableURLRequest (Private)
- (void)_generateTimestamp;
- (void)_generateNonce;
@end

@implementation TWMutableURLRequest


#pragma mark init

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
      callbackURL:(NSString*)callbackURL
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider {
    self = [super initWithURL:aUrl
                  cachePolicy:NSURLRequestReloadIgnoringCacheData
              timeoutInterval:10.0];
    
    if(!_consumer)
        _consumer = aConsumer;
    // empty token for Unauthorized Request Token transaction
    if(aToken == nil) {
        _token = [[OAToken alloc] init];
    }
    else{
        _token = aToken;
    }
    
    if(callbackURL)
        _callbackURL = callbackURL;
    
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
      callbackURL:(NSString*)callbackURL
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider
            nonce:(NSString *)aNonce
        timestamp:(NSString *)aTimestamp {
    
    self = [self initWithURL:aUrl
                    consumer:aConsumer
                       token:aToken
                 callbackURL:callbackURL
           signatureProvider:aProvider];
    
    _nonce = [aNonce copy];
    _timestamp = [aTimestamp copy];
    
    return self;
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

#pragma mark - prepare for TWMutableURLRequest 

//this the for the request token
- (void)prepare {
    // sign
    _signature = [_signatureProvider signClearText:[self signatureBaseString]
                                        withSecret:[NSString stringWithFormat:@"%@&%@",
                                                    [_consumer.secret encodedURLParameterString],
                                                    (_token && _token.secret) ? [_token.secret encodedURLParameterString] : @""]];
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	//[chunks addObject:[NSString stringWithFormat:@"realm=\"%@\"", _realm]];
    if(_callbackURL)
    [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [_callbackURL encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
	
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}


- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)tokenParams andBodyParams:(NSMutableDictionary*)bodyParams {
    // sign
    _signature = [_signatureProvider signClearText:[self signatureBaseStringWithTokenParameters:tokenParams andBodyParams:bodyParams]
                                        withSecret:[NSString stringWithFormat:@"%@&%@",
                                                    [_consumer.secret encodedURLParameterString],
                                                    _token.secret ? [_token.secret encodedURLParameterString] : @""]];
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    //	NSDictionary *tokenParameters = [_token parameters];
    for (NSString *k in tokenParams) {
        [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParams objectForKey:k] encodedURLParameterString]]];
    }
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    //
    [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //this is particular to the access token retrival
    NSString* body = [NSString stringWithFormat:@"oauth_verifier=%@",[bodyParams valueForKey:@"oauth_verifier"]];
    //put data in the request body, always use encoding with UTF-8
    [self setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *length = [NSString stringWithFormat:@"%ld",body.length];
    [self setValue: length forHTTPHeaderField:@"Content-Length"];
}

- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)accessTokenParams andQueryParams:(NSMutableDictionary*)queryParams{
    // sign
    _signature = [_signatureProvider signClearText:[self signatureBaseStringWithTokenParameters:accessTokenParams andQueryParams:queryParams]
                                        withSecret:[NSString stringWithFormat:@"%@&%@",
                                                    [_consumer.secret encodedURLParameterString],
                                                    _token.secret ? [_token.secret encodedURLParameterString] : @""]];
    //NSLog(@"%@",[NSString stringWithFormat:@"%@&%@",[_consumer.secret encodedURLParameterString],_token.secret ? [_token.secret encodedURLParameterString] : @""]);
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    //	NSDictionary *tokenParameters = [_token parameters];
    for (NSString *k in accessTokenParams) {
        //contains access_token
        [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[accessTokenParams objectForKey:k] encodedURLParameterString]]];
    }
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    
}

/*
 1. sign the base string 
    1.1 base string includes al oauth_* fields, request body params and query params
    1.2 the signing key is consumer_key_secret&access_token_secret, both percent-encoded before concatenation
 
 2. generate request header
    2.1 include oauth_* fields, query fields, but NOT body fields
 */
- (void)prepareForAccessTokenWithTokenParams:(NSMutableDictionary*)tokenParams queryParams:(NSMutableDictionary*)queryParams andBodyParams:(NSMutableDictionary*)bodyParams
{
    NSString *baseString =[self signatureBaseStringWithTokenParameters:tokenParams andBodyParams:bodyParams];
    NSString *signingKey =[NSString stringWithFormat:@"%@&%@", [_consumer.secret encodedURLParameterString], _token.secret ? [_token.secret encodedURLParameterString] : @""];
    _signature = [_signatureProvider signClearText:baseString withSecret:signingKey];
    
    // set OAuth headers, chuncks has all the header fields. There should be 7 fields in the general case including the oauth_token = access_token
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    //
    for (NSString *k in tokenParams) {
        [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParams objectForKey:k] encodedURLParameterString]]];
    }
    //adding the access_token
    if(_token && _token.key){
        [chunks addObject:[NSString stringWithFormat:@"oauth_token=\"%@\"", [_signature encodedURLParameterString]]];
    }
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    //NSLog(@"Authorization: %@",oauthHeader);
    
    if(bodyParams.count>0){
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSMutableArray *bodyArr = [[NSMutableArray alloc] init];
        for(NSString * key in bodyParams){
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,bodyParams[key]];
            [bodyArr addObject:str];
        }
        NSString *body = [bodyArr componentsJoinedByString:@"&"];
        //NSString* body = [NSString stringWithFormat:@"oauth_verifier=%@",[bodyParams valueForKey:@"oauth_verifier"]];
        //put data in the request body, always use encoding with UTF-8
        [self setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *length = [NSString stringWithFormat:@"%ld",body.length];
        [self setValue: length forHTTPHeaderField:@"Content-Length"];
    }
}
-(void)prepareForStatusUpdate:(NSString*)status
{
    NSString* baseString =[self signatureBaseStringWithTokenParameters:nil andBodyParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:status,@"status", nil]];
    NSString* signingSecret =[NSString stringWithFormat:@"%@&%@",
                              [_consumer.secret encodedURLParameterString],
                              (_token && _token.secret) ? [_token.secret encodedURLParameterString] : @""];
    
    _signature = [_signatureProvider signClearText:baseString
                                        withSecret:signingSecret];
    NSLog(@"basestring is: %@ and signature is: %@",baseString,_signature);
    NSLog(@"signing secret:%@",signingSecret);
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	//[chunks addObject:[NSString stringWithFormat:@"realm=\"%@\"", _realm]];
    if(_callbackURL)
        [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [_callbackURL encodedURLParameterString]]];
    
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_token=\"%@\"",_token.key]];//requires oauth_token!!
	[chunks	addObject:@"oauth_version=\"1.0\""];
	
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}
- (void)prepareForUpload{
    // sign
    NSString* baseString =[self signatureBaseStringForUpload];
    NSString* signingSecret =[NSString stringWithFormat:@"%@&%@",
                              [_consumer.secret encodedURLParameterString],
                              (_token && _token.secret) ? [_token.secret encodedURLParameterString] : @""];
    
    _signature = [_signatureProvider signClearText:baseString
                                        withSecret:signingSecret];
    NSLog(@"basestring is: %@ and signature is: %@",baseString,_signature);
    NSLog(@"signing secret:%@",signingSecret);
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
	//[chunks addObject:[NSString stringWithFormat:@"realm=\"%@\"", _realm]];
    if(_callbackURL)
        [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [_callbackURL encodedURLParameterString]]];
    
	[chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [_consumer.key encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", _nonce]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [_signature encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[_signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", _timestamp]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_token=\"%@\"",_token.key]];//requires oauth_token!!
	[chunks	addObject:@"oauth_version=\"1.0\""];
	
	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}

#pragma mark - generate base string
- (NSString *)signatureBaseStringForUpload {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
	//NSDictionary *tokenParameters = [_token parameters];
	// 5 being the number of OAuth params in the Signature Base String
	//NSArray *parameters = [self parameters];
    
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:6];
	OARequestParameter *parameter;
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_consumer_key" value:_consumer.key];
	
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
	
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_signature_method" value:[_signatureProvider name]];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_timestamp" value:_timestamp];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
    if(_callbackURL!=nil){
        parameter = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:_callbackURL];
        [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    }
    
    parameter = [[OARequestParameter alloc] initWithName:@"oauth_token" value:_token.key];//oauth token
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_nonce" value:_nonce];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"] ;
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	//add all the parameters in the tokenParameters
    
    //	for(NSString *k in tokenParameters) {
    //		[parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParameters objectForKey:k]] URLEncodedNameValuePair]];
    //	}
    
    //add all the request parameters in the request if it is NOT multipart request!!
    //	if (![[self valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
    //		for (OARequestParameter *param in parameters) {
    //			[parameterPairs addObject:[param URLEncodedNameValuePair]];
    //		}
    //	}
    
    //sort and normalize. to build parameter string
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
//    NSString * baseString = [NSString stringWithFormat:@"%@&%@&%@",
//                             [self HTTPMethod],
//                             [[[self URL] URLStringWithoutQuery] encodedURLParameterString],
//                             [normalizedRequestParameters encodedURLString]];
    //NO POST method is included! and no '&'
    NSString * baseString = [NSString stringWithFormat:@"%@&%@&%@",[self HTTPMethod], [[[self URL] URLStringWithoutQuery] encodedURLParameterString], [normalizedRequestParameters encodedURLString]];
    //NSLog(@"base string is:%@",baseString);
    return baseString;
}


// the general case
- (NSString *)signatureBaseStringWithTokenParameters:(NSDictionary*)tokenParams queryParams:(NSDictionary*)queryParams andBodyParams:(NSDictionary*) bodyParams{
    
	// Typically 5 fields being the number of OAuth params in the Signature Base String
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(5 + tokenParams.count + queryParams.count + bodyParams.count)];
    
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
    if(!tokenParams || tokenParams.count == 0){
        //in the case of access_token is already obtained
        if(_token.key){
            [parameterPairs addObject:[[OARequestParameter requestParameter:@"oauth_token" value:_token.key] URLEncodedNameValuePair]];
        }
    }
    else{
        for(NSString *k in tokenParams) {
            [parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParams objectForKey:k]] URLEncodedNameValuePair]];
        }
    }
    for(NSString * key in queryParams){
        [parameterPairs addObject:[[OARequestParameter requestParameter:key value:[queryParams objectForKey:key]] URLEncodedNameValuePair]];
    }
    for(NSString * key in bodyParams){
        [parameterPairs addObject:[[OARequestParameter requestParameter:key value:[bodyParams objectForKey:key]] URLEncodedNameValuePair]];
    }

    //sort and normalize.
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
	//NSLog(@"Normalized: %@", normalizedRequestParameters);
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString * baseString = [NSString stringWithFormat:@"%@&%@&%@",
                             [self HTTPMethod],
                             [[[self URL] URLStringWithoutQuery] encodedURLParameterString],
                             [normalizedRequestParameters encodedURLString]];
    //NSLog(@"base string is:%@",baseString);
    return baseString;
}

- (NSString *)signatureBaseStringWithTokenParameters:(NSMutableDictionary*)tokenParams andQueryParams:(NSMutableDictionary*)queryParams {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
	//NSDictionary *tokenParameters = [_token parameters];
	// 5 being the number of OAuth params in the Signature Base String
	//NSArray *parameters = [self parameters];
    
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(5 + [tokenParams count] + [queryParams count])];
    //NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:6];
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
    
    for(NSString *k in tokenParams) {
        [parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParams objectForKey:k]] URLEncodedNameValuePair]];
    }
    
    for(NSString * key in queryParams){
        [parameterPairs addObject:[[OARequestParameter requestParameter:key value:[queryParams objectForKey:key]] URLEncodedNameValuePair]];
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

- (NSString *)signatureBaseStringWithTokenParameters:(NSMutableDictionary*)tokenParams andBodyParams:(NSMutableDictionary*)bodyParams {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
	//NSDictionary *tokenParameters = [_token parameters];
	// 5 being the number of OAuth params in the Signature Base String
	//NSArray *parameters = [self parameters];
    
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(5 + [tokenParams count] + [bodyParams count])];
    //NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:6];
	OARequestParameter *parameter;
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_consumer_key" value:_consumer.key];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
	
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_signature_method" value:[_signatureProvider name]];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_timestamp" value:_timestamp];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_nonce" value:_nonce];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
    if(_token.key){
        parameter = [[OARequestParameter alloc] initWithName:@"oauth_token" value:_token.key] ;
        [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    }
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"] ;
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	//add all the parameters in the tokenParameters
    
    for(NSString *k in tokenParams) {
        [parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParams objectForKey:k]] URLEncodedNameValuePair]];
    }
    
    for(NSString * key in bodyParams){
        [parameterPairs addObject:[[OARequestParameter requestParameter:key value:[bodyParams objectForKey:key]] URLEncodedNameValuePair]];

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


- (NSString *)signatureBaseString {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
	//NSDictionary *tokenParameters = [_token parameters];
	// 5 being the number of OAuth params in the Signature Base String
	//NSArray *parameters = [self parameters];
    
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:6];
	OARequestParameter *parameter;
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_consumer_key" value:_consumer.key];
	
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
	
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_signature_method" value:[_signatureProvider name]];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_timestamp" value:_timestamp];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
    if(_callbackURL!=nil){
        parameter = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:_callbackURL];
        [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    }
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_nonce" value:_nonce];
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	parameter = [[OARequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"] ;
    [parameterPairs addObject:[parameter URLEncodedNameValuePair]];
    
	//add all the parameters in the tokenParameters
    
//	for(NSString *k in tokenParameters) {
//		[parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParameters objectForKey:k]] URLEncodedNameValuePair]];
//	}
    
    //add all the request parameters in the request if it is NOT multipart request!!
//	if (![[self valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
//		for (OARequestParameter *param in parameters) {
//			[parameterPairs addObject:[param URLEncodedNameValuePair]];
//		}
//	}
    //sort and normalize.
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString * baseString = [NSString stringWithFormat:@"%@&%@&%@",
                             [self HTTPMethod],
                             [[[self URL] URLStringWithoutQuery] encodedURLParameterString],
                             [normalizedRequestParameters encodedURLString]];
    //NSLog(@"base string is:%@",baseString);
    return baseString;
}

@end
