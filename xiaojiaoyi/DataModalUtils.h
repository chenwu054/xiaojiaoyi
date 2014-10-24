//
//  DataModalUtils.h
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModalUtils : NSObject


-(NSManagedObjectContext*)myDealsContext;
-(NSManagedObjectContext*)boughtDealsContext;
-(UIManagedDocument*)myDealsManagedDocument;
-(UIManagedDocument*)boughtDealsManagedDocument;

//-(UIManagedDocument*)getMyDealsDocument;
-(UIManagedDocument*)getMyDealsDocumentWithFileName:(NSString*)filename;

-(NSManagedObjectContext*)getMyDealsContextWithFilename:(NSString*)filename;
@end
