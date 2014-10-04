//
//  UserMenuController.h
//  xiaojiaoyi
//
//  Created by chen on 10/3/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMenuController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView* userMenuTableView;
@property (nonatomic) IBOutlet UIView *containerView;

@end
