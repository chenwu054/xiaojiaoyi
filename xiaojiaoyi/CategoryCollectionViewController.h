//
//  CategoryCollectionViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/14/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface CategoryCollectionViewController : UIViewController

@property (nonatomic) UINavigationBar* navigationBar;
@property (nonatomic) MainViewController* mainVC;

-(void)setBackgroundColor:(UIColor*)color;
-(CategoryCollectionViewController*)initWithBackgroundColor:(UIColor*)color;
@end
