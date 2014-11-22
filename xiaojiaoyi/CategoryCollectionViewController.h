//
//  CategoryCollectionViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/14/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "YelpDataSource.h"
#import "GestureCollectionView.h"
#import "YelpDetailViewController.h"

@interface CategoryCollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic) NSString* category;
@property (nonatomic) NSString* query;
@property (nonatomic) NSString* location;

@property (nonatomic) UINavigationBar* navigationBar;
@property (nonatomic) MainViewController* mainVC;
//@property (nonatomic) UICollectionViewController* collectionVC;
@property(nonatomic)UICollectionViewController* collectionVC;
@property (nonatomic) BOOL freshStart;
@property (nonatomic) NSInteger offset;

-(void)clear;
-(void)setLatitude:(NSString*)latitude andLongtitude:(NSString*)longitude;
//-(void)refreshDataWithQuery:(NSString*)query category:(NSString*)category andLocation:(NSString*)location offset:(NSString*)offset;
-(void)refreshDataWithLocationAndQuery:(NSString*)query category:(NSString*)category offset:(NSString*)offset;

-(void)pushToYelpDetailViewController:(YelpDetailViewController*)yelpDetailVC;
@end
