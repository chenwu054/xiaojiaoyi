//
//  TWAccessToken.m
//  xiaojiaoyi
//
//  Created by chen on 9/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "TWSession.h"

static NSString* consumer_key = @"ho97OlaynFXBYuN4mYIdVBZUb";
static NSString* consumer_secret=@"VCkBTcmJjSw4ACRWWfgNM4pWEXwwwpJskoCavy3kqx1LYf64Zl";
static NSString* callbackURL=@"http://localhost.xiaojiaoyi.com";
static NSString* twHost = @"api.twitter.com";
static NSString* twRequestTokenPath = @"/oauth/request_token";
static NSString* twAccessTokenPath = @"/oauth/access_token";
static NSString* twUserProfilePath = @"/1.1/users/show.json";
static NSString* twUpdateStatusPath = @"/1.1/statuses/update.json";
static NSString* twRequestTimelinePath=@"/1.1/statuses/user_timeline.json";
@implementation TWSession

-(NSURL*)getTimelineURLWithUserId:(NSString*)userId andScreenName:(NSString*)screenName;
{
    NSURLComponents *components=[[NSURLComponents alloc] init];
    components.scheme=@"https";
    components.host = twHost;
    components.path = twRequestTimelinePath;
    components.query=[NSString stringWithFormat:@"user_id=%@&screen_name=%@",userId,screenName];
    NSURL *url = [components URL];
    return url;

}
-(NSURL*)updateStatusURLWithStatus:(NSString*)status
{
    NSURLComponents *components=[[NSURLComponents alloc] init];
    components.scheme=@"https";
    components.host = twHost;
    components.path = twUpdateStatusPath;
    components.query=[NSString stringWithFormat:@"status=%@&display_coordinates=false",status];
    NSURL *url = [components URL];
    return url;
}

-(NSURL*) getUploadURL
{
//    NSURLComponents *components=[[NSURLComponents alloc] init];
//    components.scheme=@"https";
//    components.host = twHost;
//    components.path = twRequestTokenPath;
//    NSURL *url = [components URL];
    NSURL* url= [NSURL URLWithString:@"https://upload.twitter.com/1.1/media/upload.json"];
    
    return url;
}
-(NSURL*) getRequestTokenURL
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


-(void)getUserProfileByScreenName:(NSString *)screen_name andUserId:(NSString*) user_id withCompletionTask:(void(^)(NSURLResponse *response, NSError *error,NSString *name, NSString* URLString))completionTask
{
    NSMutableDictionary* accessTokenParams = [[NSMutableDictionary alloc] init];
    //NSLog(@"getUserProfile: _access_token is %@",_access_token);
    [accessTokenParams setValue:_access_token forKey:@"oauth_token"];
    
    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    [queryParams setValue:screen_name forKey:@"screen_name"];
    [queryParams setValue:user_id forKey:@"user_id"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = _accessToken?_accessToken:nil; //[[OAToken alloc] initWithKey:nil secret:nil];
    
    NSURL *url = [self getURLforUserProfileWithQueryParams:queryParams];
    //NSLog(@"the user profile url is %@",url);
    
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"GET"];
    [request prepareForAccessTokenWithTokenParams:accessTokenParams andQueryParams:queryParams];
    
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);

//    NSDictionary * headers = [request allHTTPHeaderFields];
//    for(NSString * k in headers){
//        NSLog(@"%@ : %@", k, [headers valueForKey:k]);
//        
//    }
    //NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    //NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"the status code: %ld",httpResponse.statusCode);
        if(httpResponse.statusCode==200){
            //NSString *string = [NSString stringWithUTF8String:[data bytes]];
            
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            for(NSString *key in dict){
//                NSLog(@"%@ = %@", key, dict[key]);
//            }
            NSString * urlString = [dict valueForKey:@"profile_image_url"];
            NSString * username = [dict valueForKey:@"name"];
            completionTask(response,error,username,urlString);
            
            //NSLog(@"the user profile data is %@",string);
            //NSLog(@"the response is %@",httpResponse);
//            NSMutableDictionary *dict = [self parseResponseData:string];
//            _access_token = [dict valueForKey:@"oauth_token"];
//            _access_token_secret = [dict valueForKey:@"oauth_token_secret"];
//            _user_id_str = [dict valueForKey:@"user_id"];
//            _screen_name=[dict valueForKey:@"screen_name"];
//            _token = [[OAToken alloc] initWithKey:_access_token secret:_access_token_secret];
        }
        else
            completionTask(response,error,nil,nil);
    }];
    [task resume];
}

// get access token
-(void) getAccessTokenWithOAuthToken:(NSString*) oauth_token andOAuthVerifier:(NSString*)oauth_verifier withCompletionTask:(void (^)(NSURLResponse *response, NSError *error, NSString* accessToken, NSString * accessTokenSecret,NSString* screen_name, NSString* user_id))completionTask
{
    NSMutableDictionary* tokenParams = [[NSMutableDictionary alloc] init];
    [tokenParams setValue:oauth_token forKey:@"oauth_token"];
    NSMutableDictionary* bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setValue:oauth_verifier forKey:@"oauth_verifier"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = _accessToken?_accessToken:nil; //[[OAToken alloc] initWithKey:nil secret:nil];
    NSURL *url = [self getURLforAccessToken];
    //NSLog(@"the access token url is %@",url);
    
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    [request prepareForAccessTokenWithTokenParams:tokenParams andBodyParams:bodyParams];
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    //NSLog(@"the headers are %@",request.allHTTPHeaderFields);
//    NSDictionary * headers = [request allHTTPHeaderFields];
//    for(NSString * k in headers){
//        NSLog(@"%@ : %@", k, [headers valueForKey:k]);
//        
//    }
    //NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    //NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        //NSLog(@"getAccessToken: the status code: %ld",httpResponse.statusCode);
        if(httpResponse.statusCode==200){
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"the data is %@",string);
            //NSLog(@"the response is %@",httpResponse);
            NSMutableDictionary *dict = [self parseResponseData:string];
            _access_token = [dict valueForKey:@"oauth_token"];
            _access_token_secret = [dict valueForKey:@"oauth_token_secret"];
            if(!_accessToken)
                _accessToken = [[OAToken alloc] init];
            _accessToken.key = _access_token;
            _accessToken.secret = _access_token_secret;
            _user_id_str = [dict valueForKey:@"user_id"];
            _screen_name=[dict valueForKey:@"screen_name"];
            completionTask(response, error, _access_token,_access_token_secret,_screen_name,_user_id_str);
        }
    }];
    [task resume];

}

-(void) getRequestTokenWithCompletionTask:(void (^)(BOOL success, NSURLResponse *response, NSError *error))completionTask
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:nil secret:nil];
    NSURL *url = [self getRequestTokenURL];
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
            self.request_token = [dict valueForKey:@"oauth_token"];
            self.request_token_secret = [dict valueForKey:@"oauth_token_secret"];
            //NSLog(@"request token is %@, request token secret is %@",_request_token, _request_token_secret);
            //NSLog(@"the response body is %@", [NSString stringWithUTF8String:[data bytes]]);
            completionTask(YES, response, error);
        }
        else{
        //TODO: error handling
            completionTask(NO, response, error);
        }
    }];
    [task resume];
}
-(void)uploadWithImageURL:(NSURL*)imageURL withCompletionHandler:(void(^)())handler
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:self.access_token secret:self.access_token_secret];// add access token and secret
    NSURL *url = [self getUploadURL];
    
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request prepareForUpload];
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    NSLog(@"request is %@",request);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionUploadTask* uploadTask = [session uploadTaskWithRequest:request fromFile:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"after upload task");
        NSLog(@"upload response is %@",httpResponse);

        NSLog(@"upload data is %@",[NSString stringWithUTF8String:[data bytes]]);
        if(httpResponse.statusCode==200){
            NSString *string = [NSString stringWithUTF8String:[data bytes]];
            NSMutableDictionary *dict = [self parseResponseData:string];
            for(NSString* k in dict){
                NSLog(@"k:%@, v:%@",k,dict[k]);
            }
            if(handler)
                handler();
        }
        else{
            //TODO: error handling
            
        }
    }];
    [uploadTask resume];
}

-(void)requestUserTimeline
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:self.access_token secret:self.access_token_secret];// add access token and secret
    NSURL *url = [self getTimelineURLWithUserId:self.user_id_str andScreenName:self.screen_name];
    
    //NSURL* updateURL = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"?status=%@&display_coordinates=false",status]];
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"GET"];
    //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request prepareForTimelineWithUserId:self.user_id_str andScreenName:self.screen_name];
    
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    NSLog(@"request is %@",request);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"request user timeline response is %@",httpResponse);
        //NSLog(@"request user timeline is %@",[NSString stringWithUTF8String:[data bytes]]);
        
        if(httpResponse.statusCode==200){
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"dict is%@",dict);
            for(NSString* k in dict){
                NSDictionary* info = (NSDictionary*)k;
                NSLog(@"text is \"%@\"",info[@"text"]);
            }
            //NSLog(@"text is %@",[dict objectForKey:@"text"]);
        }
        else{
            //TODO: error handling
            
        }
    }];
    
    [dataTask resume];
}

-(void)updateStatus:(NSString*)status withCompletionHandler:(void(^)())handler
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:self.access_token secret:self.access_token_secret];// add access token and secret
    NSURL *url = [self updateStatusURLWithStatus:status];
    
    //NSURL* updateURL = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"?status=%@&display_coordinates=false",status]];
    TWMutableURLRequest *request = [[TWMutableURLRequest alloc] initWithURL: url consumer:consumer token:token callbackURL:nil signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    [request prepareForStatusUpdate:status];
    //NSLog(@"the request body is %@, %@",request.HTTPMethod, request.URL);
    NSLog(@"the headers are %@",request.allHTTPHeaderFields);
    NSLog(@"request is %@",request);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        //NSLog(@"update status is %@",httpResponse);
        NSLog(@"update status is %@",[NSString stringWithUTF8String:[data bytes]]);
        if(httpResponse.statusCode==200){
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            NSString *string = [NSString stringWithUTF8String:[data bytes]];
//            NSMutableDictionary *dict = [self parseResponseData:string];
            for(NSString* k in dict){
                NSLog(@"k:%@, v:%@",k,dict[k]);
            }
            if(handler)
                handler();
        }
        else{
            //TODO: error handling
            
        }
    }];
    
    [dataTask resume];
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
