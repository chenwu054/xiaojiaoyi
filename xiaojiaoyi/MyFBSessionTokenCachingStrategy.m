//
//  MyFBSessionTokenCachingStrategy.m
//  xiaojiaoyi
//
//  Created by chen on 9/23/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyFBSessionTokenCachingStrategy.h"

#define USER_DEFAULT_CACHE_KEY @"FBAccessTokenInformationKey"
static NSString* kFilename = @"TokenInfo.plist";

@implementation MyFBSessionTokenCachingStrategy

- (id) init
{
    self = [super init];
    if (self) {
        _filePath = [self filePath];
    }
    return self;
}
-(instancetype) initWithFilePath:(NSString *)filepath andFileName:(NSString*)filename
{
    self = [super init];
    if(self){
        _filename = filename;
        _filePath = filepath;
        _file = [NSString stringWithFormat:@"%@/%@",_filePath,_filename];
        //if the path does not exist, create a new one
        if (![[NSFileManager defaultManager] fileExistsAtPath:_file])
            [[NSFileManager defaultManager] createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return self;
}


- (void) writeData:(NSDictionary *)data {
    //NSLog(@"write File = %@ and Data = %@", _file, data);
    BOOL success = [data writeToFile:_file atomically:YES];
    if (!success) {
        NSLog(@"Error writing to file");
    }
}

- (NSDictionary *)readData {
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:_file];
    //NSLog(@"read File = %@ and data = %@", _file, data);
    return data;
}

- (void)cacheFBAccessTokenData:(FBAccessTokenData *)accessToken {
    NSDictionary *tokenInformation = [accessToken dictionary];
    //NSLog(@"about to cache FB Token data:%@",tokenInformation);

    [self writeData:tokenInformation];
}

- (void)cacheTokenInformation:(NSDictionary *)tokenInformation
{
    //NSLog(@"calling cache Token Information");
    [self writeData:tokenInformation];
}

- (FBAccessTokenData *)fetchFBAccessTokenData
{
    NSDictionary *tokenInformation = [self readData];
//    for(NSString* k in tokenInformation){
//        NSLog(@"k:%@, v:%@",k,tokenInformation[k]);
//    }
    if (nil == tokenInformation) {
        return nil;
    } else {
        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
    }
}
-(NSDictionary*)getFBAccessTokenDataDictionary
{
    return [self readData];
}

- (void)clearToken
{
    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
}

@end
