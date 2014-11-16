//
//  CenterTabHotDealController.h
//  xiaojiaoyi
//
//  Created by chen on 10/4/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "UIView+GestureView.h"
#import "GestureView.h"
#import "MainViewController.h"
#import "GestureCollectionView.h"
#import "CenterCollectionViewFlowLayout.h"
#import "GestureCollectionReusableView.h"
#import "GestureButton.h"
#import "YelpDataSource.h"

@class  MainViewController;

@interface CenterTabHotDealController : UIViewController <UISearchBarDelegate,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic) UISearchBar *searchBar;

//@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewController *collectionVC;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) MainViewController *mainVC;
@property (nonatomic) GestureView *mainDelegateView;
@property (nonatomic) BOOL freshStart;

-(void)hideSearchBar;
@end

