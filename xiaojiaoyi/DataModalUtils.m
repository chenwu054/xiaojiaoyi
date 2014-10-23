//
//  DataModalUtils.m
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DataModalUtils.h"
#import "Deal.h"
#import "User.h"
#import "OAuthToken.h"

@interface DataModalUtils ()
@property (nonatomic) NSURL* documentsURL;
@property (nonatomic) NSURL* myDealsURL;
@property (nonatomic) NSURL* boughtDealsURL;

@property (nonatomic) UIManagedDocument* myDealsManagedDocument;
@property (nonatomic) UIManagedDocument* boughtDealsManagedDocument;


@end

@implementation DataModalUtils


#pragma mark - setup methods
-(UIManagedDocument*)myDealsManagedDocument
{
    if(!_myDealsManagedDocument){
        _myDealsManagedDocument=[[UIManagedDocument alloc] initWithFileURL:self.myDealsURL];
    }
    return _myDealsManagedDocument;
}
-(UIManagedDocument*)boughtDealsManagedDocument
{
    if(!_boughtDealsManagedDocument){
        _boughtDealsManagedDocument = [[UIManagedDocument alloc] initWithFileURL:self.boughtDealsURL];
    }
    return _boughtDealsManagedDocument;
}

-(NSURL*)getDocumentDir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    if (![fileManager fileExistsAtPath:url.path])
        [fileManager createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:NULL];
    return url;
}
-(NSURL*)getMyDealDir
{
    NSString* myDealDir=@"Deals/MyDeals";
    NSURL* docDir=[self getDocumentDir];
    NSURL* myDealURL = [docDir URLByAppendingPathComponent:myDealDir isDirectory:YES];
    if (![[NSFileManager defaultManager] fileExistsAtPath:myDealURL.path])
        [[NSFileManager defaultManager] createDirectoryAtPath:myDealURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
    
    return myDealURL;
}


-(void)insertDeal:(Deal*)deal
{
    
}


@end
