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
@property (nonatomic) NSString* latitude;
@property (nonatomic) NSString* longitude;

@end

@implementation YelpDataSource
static NSString *hostname = @"api.yelp.com";
static NSString *searchPath =@"/v2/search";
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"3";

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
    if(query)
        self.query=query;
    if(category)
        self.category=category;
    if(location)
        self.locationString=location;
    if(offset)
        self.offset=offset;
}
-(void)setLocationLatitude:(NSString*)latitude andLongitude:(NSString*)longitude
{
    self.latitude=latitude;
    self.longitude=longitude;
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

-(void)fetchDataWithLocationAndOffset:(NSString*)offset andCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))handler
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    if(offset){
        self.offset=offset;
    }
    [params setValue:self.query?self.query:@"" forKey:@"term"];
   // NSLog(@"in data source: %@, %@",self.latitude,self.longitude);
    [params setValue:[NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude] forKey:@"ll"];
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

- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
    [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            completionHandler(businessResponseJSON, error);
        } else {
            completionHandler(nil, error);
        }
    }] resume];
    
}

- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {
    
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}


@end
