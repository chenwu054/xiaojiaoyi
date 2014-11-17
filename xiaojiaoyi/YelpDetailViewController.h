//
//  YelpDetailViewController.h
//  xiaojiaoyi
//
//  Created by chen on 11/16/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface YelpDetailViewController : UIViewController <MKMapViewDelegate>

@property(nonatomic) NSMutableArray* pins;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* address;
@property (nonatomic) NSString* titleString;
@property (nonatomic) NSString* review;
@property (nonatomic) NSNumber* reviewCount;
@property (nonatomic) NSString* photoNumber;
@property (nonatomic) NSString* ratingImageURL;
@property (nonatomic) NSNumber* isClosed;
@property (nonatomic) NSString* category;


-(void)clear;

@end
