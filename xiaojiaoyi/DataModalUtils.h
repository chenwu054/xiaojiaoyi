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

-(UIManagedDocument*)getMyDealsDocumentWithUserId:(NSString*)userId;
-(NSManagedObjectContext*)getMyDealsContextWithUserId:(NSString*)userId;

-(void)deleteMyDeal:(Deal*)deal FromUserId:(NSString*)userId;


-(void)addNotificationForUserId:(NSString*)userId;
-(void)deleteNotificationForUserId:(NSString*)userId;

@end
