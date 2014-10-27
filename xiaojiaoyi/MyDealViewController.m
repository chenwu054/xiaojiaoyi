//
//  MyDealViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyDealViewController.h"

#define NAVIGATION_BAR_HEIGHT 60
#define TAB_BAR_HEIGHT 20
#define TAB_BAR_OFFSET 10

@interface MyDealViewController ()

@property (nonatomic) UITabBarController *tabController;

@end

@implementation MyDealViewController

-(void)backToCenterView
{
    
}
-(UINavigationBar *)navigationBar
{
    if(!_navigationBar){
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.frame = CGRectMake(0,0,self.view.frame.size.width,NAVIGATION_BAR_HEIGHT);
        UINavigationItem * item = [[UINavigationItem alloc] init];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterViewFromMyDealView)];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"main page" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterViewFromMyDealView)];
        
        item.leftBarButtonItem = leftBarButton;
        
        item.rightBarButtonItem = rightBarButton;
        item.title = @"My Deals";
        _navigationBar.items = @[item];
        _navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1];
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}

-(MyDealListViewController*)myDealListController
{
    if(!_myDealListController){
        _myDealListController=[[MyDealListViewController alloc] init];
        _myDealListController.title = @"My deals";
    }
    return _myDealListController;
}
-(BoughtDealListViewController*)boughtDealListController
{
    if(!_boughtDealListController){
        _boughtDealListController=[[BoughtDealListViewController alloc] init];

        _boughtDealListController.title = @"Deals bought";
    }
    return _boughtDealListController;
}
-(FriendDealListViewController*)friendDealListController
{
    if(!_friendDealListController){
        _friendDealListController=[[FriendDealListViewController alloc] init];
        _friendDealListController.title = @"Friends' deals";
    }
    return _friendDealListController;
}
-(UITabBarController*)tabController
{
    if(!_tabController){
        _tabController = [[UITabBarController alloc] init];
        _tabController.delegate = self;
        //tabBar controller's frame.origin.y should start from NAVIGATION_BAR_HEIGHT, otherwise it will block the navigation bar and invalidate click event
        _tabController.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT - TAB_BAR_OFFSET, self.view.frame.size.width, self.view.frame.size.height-(NAVIGATION_BAR_HEIGHT - TAB_BAR_OFFSET) -2);
        CGRect tabBarFrame = CGRectMake(0, 0, self.view.frame.size.width, TAB_BAR_HEIGHT);
        _tabController.tabBar.frame = tabBarFrame;
        //_tabController.tabBar.delegate = self;
        //_centerTabHotDealController.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200);
        NSArray* viewControllers = @[self.myDealListController,self.boughtDealListController,self.friendDealListController];
        _tabController.viewControllers = viewControllers;
        _tabController.selectedIndex = 0;
        _tabController.tabBar.tintColor = [UIColor blueColor];
        for(int i=0;i<viewControllers.count;i++){
            [_tabController.tabBar.items[i] setTitlePositionAdjustment:UIOffsetMake(i<2?-10:0,-10)];
            [_tabController.tabBar.items[i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:16.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
        
        //view controller container
        [self addChildViewController:_tabController];
        [self.view addSubview:_tabController.view];
        _tabController.view.backgroundColor=[UIColor lightGrayColor];
        [_tabController didMoveToParentViewController:self];
    }
    return _tabController;
}

-(void)setup
{
    self.view.backgroundColor = [UIColor greenColor];
    [self tabController];
    [self navigationBar];
    //NSLog(@"MyDealView has deal:%@",self.newDeal);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.frame = [UIScreen mainScreen].bounds;
    [self setup];
    
    //_parentView = [[GestureView alloc] init];
    //_parentView.frame = [UIScreen mainScreen].bounds;
    //[self.view addSubview:_parentView];
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
