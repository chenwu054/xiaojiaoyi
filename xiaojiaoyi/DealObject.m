//
//  DealObject.m
//  xiaojiaoyi
//
//  Created by chen on 10/26/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealObject.h"

@implementation DealObject

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@ ,%@",self.deal_id,self.title,self.price,self.describe,self.condition,self.shipping,self.exchange,self.create_date,self.expire_date,self.user_id_created];
}

@end
