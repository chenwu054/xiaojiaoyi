//
//  YelpDataSource.m
//  xiaojiaoyi
//
//  Created by chen on 11/12/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "YelpDataSource.h"
@interface YelpDataSource  ()

@property (nonatomic)NSString* query;
@property (nonatomic)NSString* locationString;


@end

@implementation YelpDataSource
static NSString *hostname = @"api.yelp.com";
static NSString *searchPath =@"/v2/search";

-(instancetype)initWithQuery:(NSString*)query andRegion:(NSString*)region
{
    self = [super init];
    if(self){
        self.query=query;
        self.locationString=region;
    }
    
    return self;
}

-(void)fetchDataWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))handler
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.query forKey:@"term"];
    [params setValue:self.locationString forKey:@"location"];
    //[params setValue:@"10" forKey:@"limit"];
    NSURLRequest * request = [NSURLRequest requestWithHost:hostname path:searchPath params:params];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        handler(data, response, error);
    }];
    [task resume];
}

@end
