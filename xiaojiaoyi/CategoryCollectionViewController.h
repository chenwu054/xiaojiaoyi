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

@interface CategoryCollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic) NSString* category;
@property (nonatomic) NSString* query;
@property (nonatomic) NSString* location;

@property (nonatomic) UINavigationBar* navigationBar;
@property (nonatomic) MainViewController* mainVC;
//@property (nonatomic) UICollectionViewController* collectionVC;
@property(nonatomic)UICollectionViewController* collectionVC;
@property (nonatomic) BOOL freshStart;

-(void)clear;
-(void)refreshDataWithQuery:(NSString*)query category:(NSString*)category andLocation:(NSString*)location offset:(NSString*)offset;

@end
