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


#pragma mark - table view delegate methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self resetWithCenterView:_centerViewController.view];
    
    NSArray *subviews = [self.view subviews];
    
    if([subviews containsObject:self.centerViewController.view]){
        [self resetWithCenterView:self.centerViewController.view inDuration:0.2 withCompletion:^(BOOL finished) {
            
            //NSLog(@"calling completion handler");
            [self.centerViewController.view removeFromSuperview];
            [self.view addSubview:self.myDealViewController.view];
        }];
        
    }
    else{
        [self resetWithCenterView:self.myDealViewController.view];
    }

    if(tableView == _menuViewController.tableView){
        
        
    }
    else if(tableView == _userMenuController.userMenuTableView){
        
        //[self.centerViewController presentViewController:self.myDealViewController animated:YES completion:nil];
        //[self.centerViewController pushViewController:_myDealViewController animated:YES];
        //[self.centerViewController performSegueWithIdentifier:@"MyDealSegue" sender:self.centerViewController];
        //use different views
        
        
        if(_myDealViewController)
            NSLog(@"push view controller");
    }
    else{
        NSLog(@"ERROR: clicked unkown table view");
    }
    
    //NSLog(@"main controller did select table view at index path: %ld,%ld",indexPath.section,indexPath.row);
    //[_menuViewController tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"!!!prepare for segue");
    
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
    NSLog(@"main view tap gesture");
    [self resetWithCenterView:_centerViewController.view];//???
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"calling pan in main view");
    UIView* view= gesture.view;
    CGPoint transition  = [gesture translationInView: view]; // ?
    
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan){
        //NSLog(@"calling the pan gesture recognizer");
        [self slideWithCenterView:view atTransition:transition ended:NO];
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        [self slideWithCenterView:view atTransition:transition ended:YES];
    }
}

#pragma mark - sub-controllers setup
//NOTE: One gesture recognizer can be only added to ONE view
//Adding one recognizer to multiple views will invalidate the recognizer and no view will response to the gesture.
-(void)setup
{
    [self setupCenterViewController];
    [self setupMenuViewController];
    [self setupUserMenuViewController];
    [self setupMyDealViewController];
    
}
-(void)setupCenterViewController
{
    //[self setupGestureRecognizer];
    if(!_centerViewController){
        _centerViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CenterTabBarControllerSB"];
        _centerViewController.superVC = self;
        [self addChildViewController:_centerViewController];
        [self.view addSubview:_centerViewController.view];
        [_centerViewController didMoveToParentViewController:self];
        
        //_viewController.delegate = self;
        //[self.navigationController pushViewController:_viewController animated:YES];
    }
    //setting up the gesture recognizer !!! CenterView already has a Pan gesture recognizer!
    UIPanGestureRecognizer *panGestureRecognizer=[self getPanGestureRecognizer];
    [_centerViewController.view addGestureRecognizer:panGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer=[self getTapGestureRecognizer];
    [_centerViewController.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)setupMenuViewController
{
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
}
-(void)setupUserMenuViewController
{
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
-(void)setupMyDealViewController
{
    //setup my deal view controller
    if(!_myDealViewController){
        _myDealViewController = [[MyDealViewController alloc] init];
    }
    UIPanGestureRecognizer *myDealPan = [self getPanGestureRecognizer];
    [_myDealViewController.view addGestureRecognizer:myDealPan];
    
    UITapGestureRecognizer *myDealTap = [self getTapGestureRecognizer];
    [_myDealViewController.view addGestureRecognizer:myDealTap];
}

/*
 slide based on the transition
 */
#pragma mark - transition animation methods
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

/*
 slide all the way to the left
 */
-(void) slideLeftAllWithCenterView:(UIView*)centerView
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        
        //_centerViewController.view.frame = CGRectMake(PANEL_WIDTH-_centerViewController.view.frame.size.width, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        centerView.frame = CGRectMake(PANEL_WIDTH-_centerViewController.view.frame.size.width, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
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

-(void) slideRightAllWithCenterView:(UIView*)centerView
{
    //NSLog(@"calling main view slide");
    [UIView animateWithDuration:0.2 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        centerView.frame = CGRectMake(_centerViewController.view.frame.size.width-PANEL_WIDTH, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
        
        //_centerViewController.view.frame = CGRectMake(_centerViewController.view.frame.size.width-PANEL_WIDTH, 0,_centerViewController.view.frame.size.width, _menuViewController.view.frame.size.height);
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
    reset methods
 */
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
        NSLog(@"duration is %f",duration);
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
    
    return (_centerViewController.view.frame.origin.x == 0) || (_myDealViewController.view.frame.origin.x==0);
}

-(BOOL) isResetWithCenterView:(UIView*)centerView
{
    
    return (centerView.frame.origin.x == 0);
}


#pragma mark - life cycle methods

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
