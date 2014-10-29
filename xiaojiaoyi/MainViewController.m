//
//  MainViewController.m
//  xiaojiaoyi
//
//  Created by chen on 9/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MainViewController.h"

#define PANEL_WIDTH 40
#define TOOL_BAR_HEIGHT 50


@interface MainViewController ()

@property (nonatomic) BOOL isReset;
@property (nonatomic) BOOL inMenuView;
@property (nonatomic) BOOL inUserMenuView;
@property (nonatomic) UIView* currentView;
@property (nonatomic) UIPageViewController* pageVC;
@property (nonatomic) NSArray *pages;
@property (nonatomic) NSMutableArray *viewStack;
@property (nonatomic) BOOL allowBeforePageView;

@property (nonatomic) UIView* centerContainerView;
@property (nonatomic) UIView* mainContainerView;

@property (nonatomic) DataModalUtils* utils;

@end

@implementation MainViewController


#pragma mark - table view delegate methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self resetWithCenterView:_centerViewController.view];
    
    //NSArray *subviews = [self.view subviews];

    if(tableView == _menuViewController.tableView){
        
        [self resetWithCenterView:self.mainContainerView];
        [self.centerViewController.view removeFromSuperview];
        [self.myDealViewController.view removeFromSuperview];
        [self.centerContainerView addSubview:self.pageVC.view];
        
        _allowBeforePageView = YES;
       
        [self.pageVC setViewControllers:_pages direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
        if([self peekViewStack]!=self.pageVC.view){
            [self pushViewStack:self.pageVC.view];
        }
        
    }
    else if(tableView == _userMenuController.userMenuTableView){
        if(indexPath.row==0){
            [self resetWithCenterView:self.mainContainerView inDuration:0.5 withCompletion:^(BOOL finished) {
                while(self.viewStack.count>0){
                    UIView* childView = [self peekViewStack];
                    [childView removeFromSuperview];
                    [self popViewStack];
                }
                [self peekViewStack];
            }];
            
        }
        else if(indexPath.row==1){
            
            __block UIView *lastView = [self peekViewStack];
            
            [self resetWithCenterView:self.mainContainerView inDuration:0.5 withCompletion:^(BOOL finished) {
                
                if(lastView == self.centerViewController.view){
                    [lastView removeFromSuperview];
                    [self.centerContainerView addSubview:self.myDealViewController.view];//!!!
                    //[self.view addSubview:self.myDealViewController.view];
                    [self pushViewStack:self.myDealViewController.view];
                }
                else if(lastView == self.myDealViewController.view){
                    nil;
                }
                else if(lastView == self.pageVC.view){
                    [lastView removeFromSuperview];
                    [self popViewStack];
                    lastView = [self peekViewStack];
//                    if(self.myDealViewController.view.superview != self.view)
//                        [self.view addSubview:self.myDealViewController.view];
                    //!!!
                    if(self.myDealViewController.view.superview!=self.centerContainerView){
                        [self.centerContainerView addSubview:self.myDealViewController.view];
                    }
                    if(lastView == self.myDealViewController.view){
                        nil;
                    }
                    else if(lastView == self.centerViewController.view){
                        [self pushViewStack:self.myDealViewController.view];
                    }
                    else{
                        NSLog(@"!!!ERROR:last view is wrong ");
                    }
                }
                else{
                    NSLog(@"!!!ERROR: NO view in the center");
                }
            }];
            
        }
        else {
            [self resetWithCenterView:self.mainContainerView];
        }
        //[self.centerViewController presentViewController:self.myDealViewController animated:YES completion:nil];
        //[self.centerViewController pushViewController:_myDealViewController animated:YES];
        //[self.centerViewController performSegueWithIdentifier:@"MyDealSegue" sender:self.centerViewController];
    }
    else{
        NSLog(@"ERROR: clicked unkown table view");
    }
    
    //NSLog(@"main controller did select table view at index path: %ld,%ld",indexPath.section,indexPath.row);
    //[_menuViewController tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"!!!prepare for segue in Main View");
    if([segue.identifier isEqualToString:@"SellDealSegue"] && [[segue destinationViewController] isKindOfClass:[SellDealViewController class]]){
        
        SellDealViewController *sellDealViewController = (SellDealViewController*)segue.destinationViewController;
        //sellDealViewController.parentVC=self;
        
        DealObject* newDeal=[[DealObject alloc] init];
        NSDate* today=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString* dealId = [NSString stringWithFormat:@"%@_%@",self.utils.userId,[dateFormatter stringFromDate:today]];
        //NSLog(@"dealId is %@",dealId);
        newDeal.deal_id = dealId;
        sellDealViewController.myNewDeal=newDeal;
        //NSLog(@"%@",newDeal);
        //sellDealViewController.newDeal=newDeal;
    }
}

#pragma mark - gesture recognizer setup
-(UIPanGestureRecognizer*)getPanGestureRecognizer
{
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMaximumNumberOfTouches:1];
    return panGR;
}
-(UITapGestureRecognizer*)getTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    return tap;
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"main view tap gesture");
    //[self resetWithCenterView:[self peekViewStack]];//???
    [self resetWithCenterView:self.mainContainerView];
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint transition  = [gesture translationInView: gesture.view]; // ?
    UIView *view = gesture.view;
    if(view == self.menuViewController.view && transition.x<0){
        return;
    }
    if(view==self.userMenuController.view && transition.x>0){
        return;
    }
    //NSLog(@"calling pan in main view");
    //UIView* centerView= [self peekViewStack];
    
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan){
        //NSLog(@"calling the pan gesture recognizer");
        [self slideWithCenterView:self.mainContainerView atTransition:transition ended:NO];
        //[self slideWithCenterView:centerView atTransition:transition ended:NO];
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        [self slideWithCenterView:self.mainContainerView atTransition:transition ended:YES];
        //[self slideWithCenterView:centerView atTransition:transition ended:YES];
    }
}
//=============setup ================
#pragma mark - sub-controllers setup
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils=[DataModalUtils sharedInstance];
    }
    return _utils;
}
-(UIView*)centerContainerView
{
    if(!_centerContainerView){
        _centerContainerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    return _centerContainerView;
}
-(UIView*)mainContainerView
{
    if(!_mainContainerView){
        _mainContainerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIPanGestureRecognizer *panGestureRecognizer=[self getPanGestureRecognizer];
        [self.mainContainerView addGestureRecognizer:panGestureRecognizer];
        //[_centerViewController.view addGestureRecognizer:panGestureRecognizer];
    }
    return _mainContainerView;
}
//NOTE: One gesture recognizer can be only added to ONE view
//Adding one recognizer to multiple views will invalidate the recognizer and no view will response to the gesture.
-(void)setup
{
    [self.view addSubview:self.mainContainerView];
    [self.mainContainerView addSubview:self.centerContainerView];
    [self.mainContainerView addSubview:self.toolBar];
    
    [self centerViewController];
    //add to center container view;
    [self.centerContainerView addSubview:_centerViewController.view];
    //[self setupCenterViewController];
    [self menuViewController];
    [self.view addSubview:_menuViewController.view];
    //[self setupMenuViewController];
    [self userMenuController];
    [self.view addSubview:_userMenuController.view];
    //[self setupUserMenuViewController];
    [self myDealViewController];
    //[self setupMyDealViewController];
    [self pageVC];
    //[self setupPageView];
    
    //[self setupCategoryViewController];
    [self categoryViewControllerOne];
    [self categoryViewControllerTwo];

    
}
-(CenterViewController*)centerViewController
{
    //[self setupGestureRecognizer];
    if(!_centerViewController){
        _centerViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CenterTabBarControllerSB"];
        _centerViewController.superVC = self;
        [self addChildViewController:_centerViewController];
        //[self.view addSubview:_centerViewController.view];
        [_centerViewController didMoveToParentViewController:self];
        
        //_viewController.delegate = self;
        //[self.navigationController pushViewController:_viewController animated:YES];
        //setting up the gesture recognizer !!! CenterView already has a Pan gesture recognizer!
        
        UITapGestureRecognizer *tapGestureRecognizer=[self getTapGestureRecognizer];
        [_centerViewController.view addGestureRecognizer:tapGestureRecognizer];
        _currentView = _centerViewController.view;
        
    }
    return _centerViewController;
}
-(MenuTableController*)menuViewController
{
    if(!_menuViewController){
        _menuViewController = [MenuTableController alloc];//!!!TODO: this call may be redundent
        _menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
        
        [self addChildViewController:_menuViewController];
        _menuViewController.view.frame = CGRectMake(_menuViewController.view.frame.size.width,0, _menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        [_menuViewController didMoveToParentViewController:self];
        _menuViewController.tableView.delegate = self;
        UIPanGestureRecognizer *menuPan = [self getPanGestureRecognizer];
        [_menuViewController.view addGestureRecognizer:menuPan];
    }
    return _menuViewController;
}
-(UserMenuController*)userMenuController
{
    if(!_userMenuController){
        _userMenuController = [UserMenuController alloc];//!!!TODO: this call may be redundent
        _userMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"userMenuController"];
        
        _userMenuController.view.frame = CGRectMake(-_userMenuController.view.frame.size.width, 0, _userMenuController.view.frame.size.width , _userMenuController.view.frame.size.height);
        
        [_userMenuController didMoveToParentViewController:self];
        _userMenuController.userMenuTableView.delegate=self;
        
        UIPanGestureRecognizer *userPan = [self getPanGestureRecognizer];
        [_userMenuController.view addGestureRecognizer:userPan];
    }
    return _userMenuController;
}
-(MyDealViewController*)myDealViewController
{
    //setup my deal view controller
    if(!_myDealViewController){
        _myDealViewController = [[MyDealViewController alloc] init];
        _myDealViewController.mainVC = self;
        UIPanGestureRecognizer *myDealPan = [self getPanGestureRecognizer];
        [_myDealViewController.view addGestureRecognizer:myDealPan];
        
        UITapGestureRecognizer *myDealTap = [self getTapGestureRecognizer];
        [_myDealViewController.view addGestureRecognizer:myDealTap];
    }
    return _myDealViewController;
}
-(UIPageViewController*)pageVC
{
    if(!_pageVC){
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
        
        _pageVC.view.frame = [UIScreen mainScreen].bounds;//CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        _pageVC.delegate=self;
        _pageVC.dataSource = self;
        _pageVC.view.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.5];
        //CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [self setupCategoryViewController];
        _pages=@[self.categoryViewControllerOne];
        
        [self.pageVC setViewControllers:_pages direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        UIPanGestureRecognizer *pagePan = [self getPanGestureRecognizer];
        [_pageVC.view addGestureRecognizer:pagePan];
        
        UITapGestureRecognizer *pageTap = [self getTapGestureRecognizer];
        [_pageVC.view addGestureRecognizer:pageTap];

    }
    return _pageVC;
}
-(CategoryCollectionViewController*)categoryViewControllerOne
{
    if(!_categoryViewControllerOne){
        _categoryViewControllerOne = [[CategoryCollectionViewController alloc] init];
    }
    return _categoryViewControllerOne;
}
-(CategoryCollectionViewController*)categoryViewControllerTwo
{
    if(!_categoryViewControllerTwo){
        _categoryViewControllerTwo = [[CategoryCollectionViewController alloc] init];
    }
    return _categoryViewControllerTwo;
}
-(void)setupCategoryViewController
{
    if(!_categoryViewControllerOne){
        _categoryViewControllerOne = [[CategoryCollectionViewController alloc] init];
    }
    if(!_categoryViewControllerTwo){
        _categoryViewControllerTwo = [[CategoryCollectionViewController alloc] init];
    }
}
-(UIToolbar*)toolBar
{
    if(!_toolBar){
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TOOL_BAR_HEIGHT, self.view.frame.size.width , TOOL_BAR_HEIGHT)];
        //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
        _toolBar.translucent = YES;
        
        UIImage *mineImage = [UIImage imageNamed:@"web11.png"];
        UIBarButtonItem *mine = [[UIBarButtonItem alloc] initWithImage:mineImage style:UIBarButtonItemStylePlain target:self action:@selector(slideRightAll)];
        mine.width = 80;
        
        UIImage *postImage = [UIImage imageNamed:@"add63.png"];
        UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithImage:postImage style:UIBarButtonItemStylePlain target:self action:@selector(showPostActionSheet)];
        post.title = @"post";
        post.width = 100;
        
        UIImage *searchImage = [UIImage imageNamed:@"zoom22.png"];
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(slideLeftAll)];
        search.width = 80;
        
        NSArray *toolItems = [[NSArray alloc] initWithObjects:mine,post,search, nil];
        [_toolBar setItems:toolItems];
    
         _toolBar.delegate = self;
    }
    return _toolBar;
    
}


//---------tool bar methods---------------------
-(void)showPostActionSheet
{
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sell deal",@"Buy deal", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex is %ld in action sheet is clicked",buttonIndex);
    if(buttonIndex == 2){
        return;
    }
    else if(buttonIndex == 0)
    {
        //NSLog(@"sell button clicked");
        
        [self performSegueWithIdentifier:@"SellDealSegue" sender:self];
        
    }
    else if(buttonIndex == 1){
        
    }
}


-(IBAction)unwindFromSellDealSegue:(UIStoryboardSegue*)sender
{
    NSLog(@"calling unwind from sell deal segue in center view controller");
    [self reset];
}


//================page view setup=====================
#pragma mark - page view methods
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"!calling after view controller");
        return nil;
    //return _pages[1];
    //CategoryCollectionViewController *afterPageVC = [[CategoryCollectionViewController alloc] initWithBackgroundColor:[UIColor colorWithRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:1.0]];
    
    //return afterPageVC;
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"calling before view controller1");
    if(!_allowBeforePageView)
        return nil;
    _allowBeforePageView=NO;
    NSLog(@"calling before view controller2");
    CategoryCollectionViewController *retCatogoryVC = viewController==_categoryViewControllerTwo?_categoryViewControllerOne:_categoryViewControllerTwo;
    _pages = @[(viewController==_categoryViewControllerTwo)?_categoryViewControllerOne:_categoryViewControllerTwo];
    UIColor *newColor = [UIColor colorWithRed:(arc4random()%256)/256.0 green:(arc4random()%256)/256.0 blue:(arc4random()%256)/256.0 alpha:1.0];
    retCatogoryVC.view.backgroundColor = newColor;
    //Does NOT call the categoryCollectionViewController view did load
    UINavigationItem *item =  retCatogoryVC.navigationBar.items[0];
    item.title = [NSString stringWithFormat:@"new %d",arc4random()%256];
    
    //NSLog(@"calling before view controller");
    return retCatogoryVC;
}
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    NSLog(@"will transition to");
}
/*
 slide based on the transition
 */
#pragma mark - transition animation methods
-(void)backToCenterViewFromMyDealView
{
    NSLog(@"calling back to center view from my deal view");
    if([self peekViewStack] == self.myDealViewController.view){
        [self popViewStack];
    }
    [self.pageVC.view removeFromSuperview];
    [self.myDealViewController.view removeFromSuperview];
    
    if(self.centerViewController.view.superview != self.centerContainerView){
        [self.centerContainerView addSubview:self.centerViewController.view];
    }
//    if(self.centerViewController.view.superview != self.view){
//        [self.view addSubview:self.centerViewController.view];
//    }
    _currentView = self.centerViewController.view;
}
-(void)backToCenterViewFromCategoryView
{
    [self.pageVC.view removeFromSuperview];
    [self popViewStack];
    UIView *lastView = [self peekViewStack];
    if(lastView == self.centerViewController.view){
        [self.myDealViewController.view removeFromSuperview];
        if([lastView superview] != self.centerContainerView){
            [self.centerContainerView addSubview:self.centerViewController.view];
        }
//        if([lastView superview] != self.view){
//            [self.view addSubview:self.centerViewController.view];
//        }
        
    }
    else if(lastView ==self.myDealViewController.view){
        [self.centerViewController.view removeFromSuperview];
        if([self.myDealViewController.view superview]!=self.centerContainerView){
            [self.centerContainerView addSubview:self.myDealViewController.view];
        }
//        if([self.myDealViewController.view superview]!=self.view){
//            [self.view addSubview:self.myDealViewController.view];
//        }
    }
    else{
        NSLog(@"!!!ERROR: coming back from category view");
    }
    
}

//sliding methods
-(void) slideWithCenterView:(UIView*)centerView atTransition:(CGPoint)transition ended:(BOOL)ended
{
    /*
     this is done because, there is push segue from xjyViewController to the YelpViewController
     therefore, in the !_isReset state, if the 
     */
    CGFloat centerX = 0.0;
    if(_isReset){
        centerX = centerView.frame.size.width/2;
        //centerX = _centerViewController.view.frame.size.width/2;
    }
    else if(_inMenuView){
        centerX = PANEL_WIDTH - centerView.frame.size.width/2;
        //centerX = PANEL_WIDTH - _centerViewController.view.frame.size.width/2;
    }
    else{
        centerX = centerView.frame.size.width * 3/2 - PANEL_WIDTH;
        //centerX = _centerViewController.view.frame.size.width * 3/2 - PANEL_WIDTH;
    }

    //user view.center to instantly move the view
    centerView.center=CGPointMake(centerX+transition.x,centerView.center.y);
    //_centerViewController.view.center=CGPointMake(centerX+transition.x,_centerViewController.view.center.y);

    _menuViewController.view.center=CGPointMake(centerX + _menuViewController.view.frame.size.width + transition.x,_menuViewController.view.center.y);
    
    _userMenuController.view.center = CGPointMake(centerX - (_userMenuController.view.frame.size.width/2 + _centerViewController.view.frame.size.width/2) + transition.x, _userMenuController.view.center.y);
    
    //NSLog(@"calling the transition");
    if(ended){
        if(_isReset){
            if(transition.x < -centerView.frame.size.width/2){
                [self slideLeftAllWithCenterView:centerView];
            }
            else if(transition.x > centerView.frame.size.width/2){
                [self slideRightAllWithCenterView:centerView];
            }
            else{
                [self resetWithCenterView:centerView];
            }

        }
        else if(_inMenuView){
            if(transition.x > centerView.frame.size.width/2)
                [self resetWithCenterView:centerView];
            else
                [self slideLeftAllWithCenterView:centerView];
        }
        else{
            if(transition.x < - centerView.frame.size.width/2){
                [self resetWithCenterView:centerView];
            }
            else{
                [self slideRightAllWithCenterView:centerView];
            }
        }
    }
    
}
-(void) slideLeftAll
{
    [self slideLeftAllWithCenterView:self.mainContainerView];
    //[self slideLeftAllWithCenterView:[self peekViewStack]];
}
-(void) slideRightAll
{
    [self slideRightAllWithCenterView:self.mainContainerView];
    //[self slideRightAllWithCenterView:[self peekViewStack]];
}
/*
 slide all the way to the left
 */
-(void) slideLeftAllWithCenterView:(UIView*)centerView
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        centerView.frame = CGRectMake(PANEL_WIDTH-_centerViewController.view.frame.size.width, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        _menuViewController.view.frame = CGRectMake(PANEL_WIDTH, 0,_menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        if(finished)
            nil;
    }];
    _isReset=NO;
    _inMenuView = YES;
    _inUserMenuView = NO;
}

-(void) slideRightAllWithCenterView:(UIView*)centerView
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        centerView.frame = CGRectMake(_centerViewController.view.frame.size.width-PANEL_WIDTH, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
        _userMenuController.view.frame = CGRectMake(-PANEL_WIDTH, 0,_userMenuController.view.frame.size.width, _userMenuController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if(finished)
            nil;
    }];
    _isReset=NO;
    _inUserMenuView = YES;
    _inMenuView = NO;
}

/*
    reset methods
*/
-(void) reset
{
    [self resetWithCenterView:[self peekViewStack]];
}
-(void)resetWithCenterView:(UIView*)centerView
{
    [self resetWithCenterView:centerView inDuration:0.2];
}
-(void)resetWithCenterView:(UIView*)centerView inDuration:(CGFloat)duration
{
    //NSLog(@"calling main view controller reset");
    [self resetWithCenterView:centerView inDuration:duration withCompletion:nil];
}

/*
 slide the view back to original setting
 */
-(void)resetWithCenterView:(UIView*)centerView inDuration:(CGFloat)duration withCompletion:(void(^)(BOOL finished))handler
{
    //NSLog(@"calling main view controller reset");
    
    [UIView animateWithDuration:duration delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //NSLog(@"duration is %f",duration);
        centerView.frame = CGRectMake(0, 0,centerView.frame.size.width, centerView.frame.size.height);
        
        _menuViewController.view.frame = CGRectMake(_centerViewController.view.frame.size.width, 0,_menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
        _userMenuController.view.frame = CGRectMake(-_userMenuController.view.frame.size.width, 0, _userMenuController.view.frame.size.width, _userMenuController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        //NSLog(@"calling  handler");
        if(handler)
            handler(finished);
    }];
    _isReset = YES;
    _inUserMenuView = NO;
    _inMenuView= NO;
}

-(BOOL) isReset
{
    return (self.mainContainerView.frame.origin.x==0 || self.mainContainerView.frame.origin.x == 0);
    //return (_currentView.frame.origin.x==0 || _centerViewController.view.frame.origin.x == 0) || (_myDealViewController.view.frame.origin.x==0);
}

-(BOOL) isResetWithCenterView:(UIView*)centerView
{
    return (centerView.frame.origin.x == 0);
}
//view stack methods
-(NSMutableArray*)viewStack
{
    if(!_viewStack){
        _viewStack=[[NSMutableArray alloc] initWithCapacity:3];
    }
    return _viewStack;
}
-(UIView*)peekViewStack
{
    if([self.viewStack count]>0){
        return [self.viewStack objectAtIndex:self.viewStack.count-1];
    }
    
    if(self.centerViewController.view.superview != self.view){
        
        [self.centerContainerView addSubview:self.centerViewController.view];
        //[self.view addSubview:self.centerViewController.view];
    }
    
    [self pushViewStack:self.centerViewController.view];
    
    return self.centerViewController.view;
}
-(UIView*)popViewStack
{
    if(self.viewStack.count==0)
        return self.centerViewController.view;
    
    UIView* retView = [self.viewStack lastObject];
    [self.viewStack removeLastObject];
    //NSLog(@"popped new view now stack size is %ld",_viewStack.count);
    return retView;
}
-(void)pushViewStack:(UIView*)newView
{
    if(newView)
        [self.viewStack addObject:newView];
    
    //NSLog(@"pushed new view now stack size is %ld",_viewStack.count);
}

#pragma mark - life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    self.isReset = true;


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
