//
//  YelpDataSource.h
//  xiaojiaoyi
//
//  Created by chen on 11/12/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OADataFetcher.h"
#import "NSURLRequest+OAuth.h"
@interface YelpDataSource : NSObject

-(instancetype)initWithQuery:(NSString*)query andRegion:(NSString*)region;
-(void)fetchDataWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))handler;


@end
