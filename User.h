//
//  User.h
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deal, OAuthToken;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * user_last_login;
@property (nonatomic, retain) NSSet *deals_bought;
@property (nonatomic, retain) NSSet *deals_created;
@property (nonatomic, retain) OAuthToken *user_id;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDeals_boughtObject:(Deal *)value;
- (void)removeDeals_boughtObject:(Deal *)value;
- (void)addDeals_bought:(NSSet *)values;
- (void)removeDeals_bought:(NSSet *)values;

- (void)addDeals_createdObject:(Deal *)value;
- (void)removeDeals_createdObject:(Deal *)value;
- (void)addDeals_created:(NSSet *)values;
- (void)removeDeals_created:(NSSet *)values;

@end
