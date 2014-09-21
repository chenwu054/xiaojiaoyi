//
//  TWAccessToken.m
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "TWAccessToken.h"

static NSString* consumer_key = @"sRtlhqgVCwIFNooYsr8X1sptO";
static NSString* consumer_secret=@"JomNUiwkkHoZ9I1jhwyUbtDBWoLrHMmBB61CoYf9t57l5z2x8h";
static NSString* callbackURL=@"http://localhost.xiaojiaoyi.com";
static NSString* twHost = @"api.twitter.com";
static NSString* twRequestTokenPath = @"/oauth/request_token";
static NSString* twAccessTokenPath = @"/oauth/access_token";
static NSString* twUserProfilePath = @"/1.1/users/show.json";

@implementation TWAccessToken

-(NSURL*) getURL
{
    NSURLComponents *components=[[NSURLComponents alloc] init];
    components.scheme=@"https";
    components.host = twHost;
    components.path = twRequestTokenPath;
    NSURL *url = [components URL];
    return url;
}

-(NSURL*) getURLforAccessToken
{
    NSURLComponents *components=[[NSURLComponents alloc] init];
    components.scheme=@"https";
    components.host = twHost;
    components.path = twAccessTokenPath;
    NSURL *url = [components URL];
    return url;
}

-(NSURL*) getURLforUserProfileWithQueryParams:(NSDictionary*) queryParams
{
    NSMutableArray *queryParts = [[NSMutableArray alloc] init];
    for (NSString *key in [queryParams allKeys]) {
        NSString *queryPart = [NSString stringWithFormat:@"%@=%@", key, queryParams[key]];
        //NSLog(@"part is %@",queryPart);
        [queryParts addObject:queryPart];
    }
    NSURLComponents *components=[[NSURLComponents alloc] init];
    components.scheme=@"https";
    components.host = twHost;
    components.path = twUserProfilePath;
    components.query = [queryParts componentsJoinedByString:@"&"];

    NSURL *url = [components URL];
    return url;
}
-(void) userAuthorize
{
    
    
    
}

-(void)getUserProfileByScreenName:(NSString *)screen_name andUserId:(NSString*) user_id withCompletionTask:(void(^)(NSString *name,NSString* URLString))completionTask
{
    NSMutableDictionary* accessTokenParams = [[NSMutableDictionary alloc] init];
    NSLog(@"getUserProfile: _access_token is %@",_access_token);
    [accessTokenParams setValue:_access_token forKey:@"oauth_token"];
    
    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    [queryParams setValue:screen_name forKey:@"screen_name"];
    [queryParams setValue:user_id forKey:@"user_id"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = _token?_token:nil; //[[OAToken alloc] initWithKey:nil secret:nil];
    
    NSURL *url = [self getURLforUserProfileWithQueryParams:queryParams];
    NSLog(@"the user profile url is %@",url);
    
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"GET"];
    [request prepareForAccessTokenWithTokenParams:accessTokenParams andQueryParams:queryParams];
    
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    //NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    NSDictionary * headers = [request allHTTPHeaderFields];
    for(NSString * k in headers){
        NSLog(@"%@ : %@", k, [headers valueForKey:k]);
        
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"the status code: %ld",httpResponse.statusCode);
        if(httpResponse.statusCode==200){
            NSString *string = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"the user profile data is %@",string);
            //NSLog(@"the response is %@",httpResponse);
//            NSMutableDictionary *dict = [self parseResponseData:string];
//            _access_token = [dict valueForKey:@"oauth_token"];
//            _access_token_secret = [dict valueForKey:@"oauth_token_secret"];
//            _user_id_str = [dict valueForKey:@"user_id"];
//            _screen_name=[dict valueForKey:@"screen_name"];
//            _token = [[OAToken alloc] initWithKey:_access_token secret:_access_token_secret];
//            
//            completionTask(_access_token,_access_token_secret);
        }
    }];
    [task resume];
}

// get access token
-(void) getAccessTokenWithOAuthToken:(NSString*) oauth_token andOAuthVerifier:(NSString*)oauth_verifier withCompletionTask:(void (^)(NSString* accessToken, NSString * accessTokenSecret,NSString* screen_name, NSString* user_id))completionTask
{
    NSMutableDictionary* tokenParams = [[NSMutableDictionary alloc] init];
    [tokenParams setValue:oauth_token forKey:@"oauth_token"];
    NSMutableDictionary* bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setValue:oauth_verifier forKey:@"oauth_verifier"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = _token?_token:nil; //[[OAToken alloc] initWithKey:nil secret:nil];
    NSURL *url = [self getURLforAccessToken];
    NSLog(@"the access token url is %@",url);
    
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    [request prepareForAccessTokenWithTokenParams:tokenParams andBodyParams:bodyParams];
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    //NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    NSDictionary * headers = [request allHTTPHeaderFields];
    for(NSString * k in headers){
        NSLog(@"%@ : %@", k, [headers valueForKey:k]);
        
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"the status code: %ld",httpResponse.statusCode);
        if(httpResponse.statusCode==200){
            NSString *string = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"the data is %@",string);
            //NSLog(@"the response is %@",httpResponse);
            NSMutableDictionary *dict = [self parseResponseData:string];
            _access_token = [dict valueForKey:@"oauth_token"];
            _access_token_secret = [dict valueForKey:@"oauth_token_secret"];
            if(!_token)
                _token = [[OAToken alloc] init];
            _token.key = _access_token;
            _token.secret = _access_token_secret;
            _user_id_str = [dict valueForKey:@"user_id"];
            _screen_name=[dict valueForKey:@"screen_name"];
            completionTask(_access_token,_access_token_secret,_screen_name,_user_id_str);
        }
    }];
    [task resume];

}

-(void) getRequestTokenWithCompletionTask:(void (^)())completionTask
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:nil secret:nil];
    NSURL *url = [self getURL];
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:callbackURL signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    [request prepare];
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    //NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode==200){
            NSString *string = [NSString stringWithUTF8String:[data bytes]];
            NSMutableDictionary *dict = [self parseResponseData:string];
            _oauth_token = [dict valueForKey:@"oauth_token"];
            _oauth_token_secret = [dict valueForKey:@"oauth_token_secret"];
            //NSLog(@"oauth token is %@, oauth token secret is %@",_oauth_token, _oauth_token_secret);
            //NSLog(@"the response body is %@", [NSString stringWithUTF8String:[data bytes]]);
            
            completionTask();
        }
    }];
    [task resume];
}

#pragma  mark - utils methods

-(NSMutableDictionary*) parseResponseData:(NSString*)string
{
    NSArray *compnents = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for(int i=0;i<compnents.count;i++){
        NSString *subString = compnents[i];
        NSArray * keyVal = [subString componentsSeparatedByString:@"="];
        [dict setValue:keyVal[1] forKey:keyVal[0]];
    }
    return dict;
}

@end
