//
//  DealSummaryViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/21/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealSummaryViewController.h"

#define NAVIGATION_BAR_HEIGHT 50
#define TOOL_BAR_HEIGHT 50
#define PAGE_VIEW_HEIGHT 200

@interface DealSummaryViewController ()
@property (nonatomic) UIScrollView *mainView;
@property (nonatomic) UIPageViewController* pageVC;
@property (nonatomic) NSArray* photos;
@property (nonatomic) UIView* containerView;
@property (nonatomic) UIButton* playSoundButton;
@property (nonatomic) UIButton* exchangeButton;
@property (nonatomic) UIButton* reliabilityButton;

@end

@implementation DealSummaryViewController

#pragma mark - components setup
-(UIPageViewController*)pageVC
{
    if(!_pageVC){
        _pageVC=[[UIPageViewController alloc] init];
        
    }
    return _pageVC;
}
-(UIScrollView*)mainView
{
    if(!_mainView){
        _mainView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
        
    }
    return _mainView;
}
-(void)setup
{
    [self mainView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
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
