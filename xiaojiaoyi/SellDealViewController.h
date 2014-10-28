//
//  SellDealViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/15/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageViewController.h"
#import "DealObject.h"
#import "DataModalUtils.h"
#import "DealDescriptionViewController.h"
#import "CenterViewController.h"

@class CenterViewController;
@interface SellDealViewController : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic) UIButton *backButton;
@property (nonatomic) NSInteger buttonToEdit;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray* photos;
@property (nonatomic) UIImage* editImage;
@property (nonatomic) BOOL shouldDelete;
@property (nonatomic) CenterViewController* parentVC;

@property (nonatomic) DealObject* myNewDeal;
@property (nonatomic) BOOL cancelDeal;

@end
