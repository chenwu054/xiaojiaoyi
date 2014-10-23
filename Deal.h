//
//  Deal.h
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Deal : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * expire_date;
@property (nonatomic, retain) NSNumber * exchange;
@property (nonatomic, retain) NSNumber * shipping;
@property (nonatomic, retain) NSString * sound_url;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSNumber * dealId;
@property (nonatomic, retain) NSNumber * insured;
@property (nonatomic, retain) User *user_id_bought;
@property (nonatomic, retain) User *user_id_created;

@end
