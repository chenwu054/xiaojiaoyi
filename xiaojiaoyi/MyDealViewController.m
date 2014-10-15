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

-(void)backToCenterView
{
    
}
-(UINavigationBar *)navigationBar
{
    if(!_navigationBar){
        _navigationBar = [[UINavigationBar alloc] init];
    }
    _navigationBar.frame = CGRectMake(0,0,self.view.frame.size.width,60);
    UINavigationItem * item = [[UINavigationItem alloc] init];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterView)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"main page" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterView)];
    
    item.leftBarButtonItem = leftBarButton;
    item.rightBarButtonItem = rightBarButton;
    item.title = @"My Deals";
    _navigationBar.items = @[item];
    _navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1];
    
    return _navigationBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    //_parentView = [[GestureView alloc] init];
    //_parentView.frame = [UIScreen mainScreen].bounds;
    //[self.view addSubview:_parentView];
    
    [self navigationBar];
    [self.view addSubview:_navigationBar];
    //for(UIView* view in self.view.subviews) 
       // NSLog(@"subview is %@",view);
    
    //_parentView.backgroundColor = [UIColor greenColor];
    
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
