//
//  MyFBSessionTokenCachingStrategy.m
//  xiaojiaoyi
//
//  Created by chen on 9/23/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyFBSessionTokenCachingStrategy.h"
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
        NSString * dir = [self documentPath];
        NSString *parentDir=[NSString stringWithFormat:@"%@/%@",dir,_filePath];
        _file = [NSString stringWithFormat:@"%@/%@",parentDir,_filename];
        
        //if the path does not exist, create a new one
        if (![[NSFileManager defaultManager] fileExistsAtPath:_file])
            [[NSFileManager defaultManager] createDirectoryAtPath:parentDir withIntermediateDirectories:YES attributes:nil error:NULL];
        
    }
    return self;
}

-(NSString *)documentPath
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return documentsDirectory;
}
- (NSString *) filePath {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void) writeData:(NSDictionary *) data {
    //NSLog(@"write File = %@ and Data = %@", _file, data);
    BOOL success = [data writeToFile:_file atomically:YES];
    if (!success) {
        NSLog(@"Error writing to file");
    }
    
//    NSLog(@"-----------");
//    NSDirectoryEnumerator * enumerator= [[NSFileManager defaultManager] enumeratorAtPath: [self documentPath]];
//    for(NSURL * url in enumerator){
//        NSLog(@"file is %@",url);
//    }
}

- (NSDictionary *) readData {
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
    if (nil == tokenInformation) {
        return nil;
    } else {
        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
    }
}

- (void)clearToken
{
    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
}


@end
