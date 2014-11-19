//
//  DealObject.h
//  xiaojiaoyi
//
//  Created by chen on 10/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealObject : NSObject

@property (nonatomic) NSString * deal_id;//0.deal_id
@property (nonatomic) NSString * title;//1.title
@property (nonatomic) NSNumber * price;//2.price
@property (nonatomic) NSString * describe;//3.describe
@property (nonatomic) NSString * condition;//4. condition
@property (nonatomic) NSDate * create_date;//5. expiry
@property (nonatomic) NSDate * expire_date;//5. expiry
@property (nonatomic) NSNumber * shipping;//6. shipping
@property (nonatomic) NSNumber * exchange;//7. exchange
@property (nonatomic) NSString * sound_url;//8. sound URL
@property (nonatomic) NSString *user_id_created;//9.user id created
@property (nonatomic) NSArray* photoURL;//10. photoURL

@property (nonatomic) NSNumber* latitude; //11. latitude
@property (nonatomic) NSNumber* longitude; //12. longitude
@property (nonatomic) NSString* map_image_url; //13. map image url
@property (nonatomic) NSArray* photos; //array of NSData* 
@property (nonatomic) NSNumber * insured;
@property (nonatomic) NSString * user_id_bought;



@end
