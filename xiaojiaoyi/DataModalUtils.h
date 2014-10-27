//
//  DataModalUtils.h
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deal.h"

@interface DataModalUtils : NSObject

@property (nonatomic) NSString* userId;


-(UIManagedDocument*)getMyDealsDocumentWithUserId:(NSString*)userId;
-(NSManagedObjectContext*)getMyDealsContextWithUserId:(NSString*)userId;

-(void)deleteMyDeal:(Deal*)deal FromUserId:(NSString*)userId;
-(void)insertMyDeal:(Deal*)deal withAutoDealIdToUserId:(NSString *)userId;
-(NSArray*)queryForDealsWithUserId:(NSString*)userId predicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)descriptors;

-(void)addNotificationForUserId:(NSString*)userId;
-(void)deleteNotificationForUserId:(NSString*)userId;
+(DataModalUtils*)sharedInstance;
-(void)insertMyDeal:(Deal*)deal;

-(void)updateUserId:(NSString*)userId;

-(NSURL*)myDealsDataURL;

@end

