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
@property (nonatomic)NSString* category;
@property (nonatomic)NSString* offset;

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

-(void)setQuery:(NSString*)query category:(NSString*)category andLocation:(NSString*)location
{
    [self setQuery:query category:category location:location offset:@"0"];
}
-(void)setQuery:(NSString*)query category:(NSString*)category location:(NSString*)location offset:(NSString*)offset
{
    self.query=query;
    self.category=category;
    self.locationString=location;
    self.offset=offset;
}
-(void)fetchDataWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))handler
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];

    [params setValue:self.query?self.query:@"" forKey:@"term"];
    [params setValue:self.locationString forKey:@"location"];
    if(self.category){
        [params setValue:self.category forKey:@"category_filter"];
    }
    [params setValue:self.offset?self.offset:@"0" forKey:@"offset"];
    
    //[params setValue:@"10" forKey:@"limit"];
    NSURLRequest * request = [NSURLRequest requestWithHost:hostname path:searchPath params:params];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        handler(data, response, error);
    }];
    [task resume];
}


@end
