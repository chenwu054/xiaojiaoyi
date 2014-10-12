//
//  MainViewController.m
//  xiaojiaoyi
//
//  Created by chen on 9/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MainViewController.h"


#define PANEL_WIDTH 40

@interface MainViewController ()

@property (nonatomic) BOOL isReset;
@property (nonatomic) BOOL inMenuView;
@property (nonatomic) BOOL inUserMenuView;

@end

@implementation MainViewController


#pragma mark - gesture recognizer
//
//-(void)setupSubViewGestureRecognizer
//{
//    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
//    [swipeGR setNumberOfTouchesRequired:1];
//    [swipeGR setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
//    
//    [self.view addGestureRecognizer:swipeGR];
//    
//    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(subviewPan:)];
//    [panGR setMaximumNumberOfTouches:1];
//    [panGR setMinimumNumberOfTouches:1];
//
//   // [self.viewController.view addGestureRecognizer:panGR];
//
//}
//
//-(void)subviewPan:(UIPanGestureRecognizer*)gesture
//{
//    NSLog(@"subview pan");
//}
//-(void)swipe:(UISwipeGestureRecognizer*)gesture
//{
//    NSLog(@"main swipe");
//}


#pragma mark - table view delegate methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _menuViewController.tableView){
    
    }
    else if(tableView == _userMenuController.userMenuTableView){
        
    }
    else{
        NSLog(@"ERROR: clicked unkown table view");
    }
    
    [self reset];
    NSLog(@"main controller did select table view at index path: %ld,%ld",indexPath.section,indexPath.row);
    [_menuViewController tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath];
    
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
    [self reset];
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan){
        //NSLog(@"calling the pan gesture recognizer");
        CGPoint transition  = [gesture translationInView: _viewController.view]; // ?
        [self slideWithTransition:transition ended:NO];
        
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        CGPoint transition = [gesture translationInView: self.view];
        [self slideWithTransition:transition ended:YES];
    }
}

#pragma mark - sub-controllers setup
//NOTE: One gesture recognizer can be only added to ONE view
//Adding one recognizer to multiple views will invalidate the recognizer and no view will response to the gesture.
-(void)setup
{
    //[self setupGestureRecognizer];
    if(!_viewController){
        _viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CenterTabBarControllerSB"];
        _viewController.superVC = self;
        [self addChildViewController:_viewController];
        [self.view addSubview:_viewController.view];
        //_viewController.delegate = self;
        //[self.navigationController pushViewController:_viewController animated:YES];
        
        //[self.viewController presentViewController:_viewController animated:YES completion:nil];
        [_viewController didMoveToParentViewController:self];
        
    }
    //setting up the gesture recognizer !!! CenterView already has a Pan gesture recognizer!
    UIPanGestureRecognizer *panGestureRecognizer=[self getPanGestureRecognizer];
    [_viewController.view addGestureRecognizer:panGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer=[self getTapGestureRecognizer];
    [_viewController.view addGestureRecognizer:tapGestureRecognizer];
    
    if(!_menuViewController){
        _menuViewController = [MenuTableController alloc];
        _menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
        
        [self.view addSubview:_menuViewController.view];
        [self addChildViewController:_menuViewController];
        _menuViewController.view.frame = CGRectMake(_menuViewController.view.frame.size.width,0, _menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        [_menuViewController didMoveToParentViewController:self];
        _menuViewController.tableView.delegate = self;
    }
    UIPanGestureRecognizer *menuPan = [self getPanGestureRecognizer];
    [_menuViewController.view addGestureRecognizer:menuPan];
    
    if(!_userMenuController){
        _userMenuController = [UserMenuController alloc];
        _userMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"userMenuController"];
        
        [self.view addSubview:_userMenuController.view];
        _userMenuController.view.frame = CGRectMake(-_userMenuController.view.frame.size.width, 0, _userMenuController.view.frame.size.width , _userMenuController.view.frame.size.height);
        [_userMenuController didMoveToParentViewController:self];
        _userMenuController.userMenuTableView.delegate=self;
    }
    UIPanGestureRecognizer *userPan = [self getPanGestureRecognizer];
    [_userMenuController.view addGestureRecognizer:userPan];
    
}


/*
slide all the way to the left
 */
-(void) slideLeftAll
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        
        _viewController.view.frame = CGRectMake(PANEL_WIDTH-_viewController.view.frame.size.width, 0,_viewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        _menuViewController.view.frame = CGRectMake(PANEL_WIDTH, 0,_menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if(finished)
            nil;
        //NSLog(@"menu navigation view from main view moved main frame successfully");
    }];
    _isReset=NO;
    _inMenuView = YES;
    _inUserMenuView = NO;
}

-(void) slideRightAll
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{

        _viewController.view.frame = CGRectMake(_viewController.view.frame.size.width-PANEL_WIDTH, 0,_viewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
        _userMenuController.view.frame = CGRectMake(-PANEL_WIDTH, 0,_userMenuController.view.frame.size.width, _userMenuController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if(finished)
            nil;
        //NSLog(@"menu navigation view from main view moved main frame successfully");
    }];
    _isReset=NO;
    _inUserMenuView = YES;
    _inMenuView = NO;
}

/*
 slide based on the transition
 */
-(void) slideWithTransition:(CGPoint)transition ended:(BOOL)ended
{
    /*
     this is done because, there is push segue from xjyViewController to the YelpViewController
     therefore, in the !_isReset state, if the 
     */
    
    CGFloat centerX = 0.0;
    if(_isReset){
        centerX = _viewController.view.frame.size.width/2;
    }
    else if(_inMenuView){
        centerX = PANEL_WIDTH - _viewController.view.frame.size.width/2;

    }
    else{
        centerX = _viewController.view.frame.size.width * 3/2 - PANEL_WIDTH;
    }

    //user view.center to instantly move the view
    _viewController.view.center=CGPointMake(centerX+transition.x,_viewController.view.center.y);
    
    _menuViewController.view.center=CGPointMake(centerX + _menuViewController.view.frame.size.width + transition.x,_menuViewController.view.center.y);
    
    _userMenuController.view.center = CGPointMake(centerX - (_userMenuController.view.frame.size.width/2 + _viewController.view.frame.size.width/2) + transition.x, _userMenuController.view.center.y);
    
    if(ended){
        if(_isReset){
            if(transition.x < -_viewController.view.frame.size.width/2){
                [self slideLeftAll];
            }
            else if(transition.x > _viewController.view.frame.size.width/2){
                [self slideRightAll];
            }
            else{
                [self reset];
            }

        }
        else if(_inMenuView){
            if(transition.x > _viewController.view.frame.size.width/2)
                [self reset];
            else
                [self slideLeftAll];
        }
        else{
            if(transition.x < - _viewController.view.frame.size.width/2){
                [self reset];
            }
            else{
                [self slideRightAll];
            }
        }
    }
    
}

-(void)reset
{
    [self resetWithDuration:0.2];
}
/*
 slide the view back to original setting
 */
-(void)resetWithDuration:(CGFloat)duration
{
    //NSLog(@"calling main view controller reset");
    [UIView animateWithDuration:duration delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _viewController.view.frame = CGRectMake(0, 0,_viewController.view.frame.size.width, _viewController.view.frame.size.height);
        
        _menuViewController.view.frame = CGRectMake(_viewController.view.frame.size.width, 0,_menuViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
        _userMenuController.view.frame = CGRectMake(-_userMenuController.view.frame.size.width, 0, _userMenuController.view.frame.size.width, _userMenuController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if(finished)
            nil;
            //NSLog(@"menu navigation view from main view reset successfully");
    }];
    _isReset = YES;
    _inUserMenuView = NO;
    _inMenuView= NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    self.isReset = true;
    //[self setupSubViewGestureRecognizer];
    //[UIView recursivePrintViewTree:self.view];

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
