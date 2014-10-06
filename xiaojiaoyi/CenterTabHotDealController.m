//
//  CenterTabHotDealController.m
//  xiaojiaoyi
//
//  Created by chen on 10/4/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CenterTabHotDealController.h"

#define SEARCH_BAR_HEIGHT 50
#define TAB_BAR_HEIGHT 50
#define TRANSITION_THRESHOLD 2

@interface CenterTabHotDealController ()

@end

@implementation CenterTabHotDealController

#pragma mark - collection view setup
-(UICollectionView*)collectionView
{
    if(!_collectionView){
        CGFloat originY = _searchBar.frame.size.height + _searchBar.frame.origin.y;
        CGRect collectionViewFrame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame];
    }
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    return _collectionView;
}


#pragma mark - search bar methods
-(void)setupSearchBar
{
    if(!_searchBar){
        CGRect searchBarFrame = CGRectMake(0,TAB_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
        _searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    }
    
    [self.view addSubview:_searchBar];
}
-(void)setupGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHighSearchbarBySwipeGesture:)];
    [swipeGR setNumberOfTouchesRequired:1];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideSearchBarByPanGesture:)];
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:swipeGR];
    [self.view addGestureRecognizer:panGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGR];
}

-(void)showSearchBar
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, TAB_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
    } completion:nil];
    
}
-(void)hideSearchBar
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
    } completion:nil];
    
}
-(void)tap:(UITapGestureRecognizer*)gesture
{
    if([_searchBar isFirstResponder])
        [_searchBar resignFirstResponder];
}

-(void)showOrHighSearchbarBySwipeGesture:(UISwipeGestureRecognizer*)gesture
{
   // NSLog(@"calling swipe recognizer");
    
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown){
        [self showSearchBar];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionUp){
        [self hideSearchBar];
    }
}
-(void)showOrHideSearchBarByPanGesture:(UIPanGestureRecognizer*)gesture
{
    //NSLog(@"calling pan recognizer");
    if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint transition  = [gesture translationInView: self.view];
        if(transition.y > TRANSITION_THRESHOLD){
            [self showSearchBar];
        }
        else if(transition.y < -TRANSITION_THRESHOLD){
            [self hideSearchBar];
        }
    }
}


#pragma mark - overall setup
-(void)setup
{
    [self setupSearchBar];
    
}


#pragma mark - life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupGestureRecognizer];
    
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
