//
//  CenterTabHotDealController.h
//  xiaojiaoyi
//
//  Created by chen on 10/4/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterTabHotDealController : UIViewController <UISearchBarDelegate,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic) UISearchBar *searchBar;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewController *collectionVC;




@end
