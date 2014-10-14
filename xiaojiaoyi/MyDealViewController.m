//
//  MyDealViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyDealViewController.h"

@interface MyDealViewController ()

@end

@implementation MyDealViewController

-(UINavigationBar *)navigationBar
{
    if(!_navigationBar){
        _navigationBar = [[UINavigationBar alloc] init];
    }
    UINavigationItem * item = [[UINavigationItem alloc] init];
    
    item.title = @"My Deals";
    _navigationBar.items = @[item];

    return _navigationBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    _parentView = [[GestureView alloc] init];
    _parentView.frame = [UIScreen mainScreen].bounds;
    //[self.view addSubview:_parentView];
    
    [self navigationBar];
    [_parentView addSubview:_navigationBar];
    _parentView.backgroundColor = [UIColor greenColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
