//
//  xjyViewController.m
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CenterViewController.h"
#import "YPAPISample.h"
#import "NSURLRequest+OAuth.h"
#import "YelpViewController.h"
#import "DealObject.h"

#define YELP_CONSUMER_KEY @"f1UUkqY-ArXOelq_hGKBOg"
#define YELP_CONSUMER_SECRET @"J-aIV0DJDUOJ4cBdGyBkIKmcdoY"
#define YELP_TOKEN @"-At-okxmS72TvU8_-y1iiO3wU57dzvVY"
#define YELP_TOKEN_SECRET @"cb9FGc7X_WrsbEjihdqZ5y7Hz2Y"
#define TOOL_BAR_HEIGHT 50
#define TAB_BAR_HEIGHT 50

@interface CenterViewController ()

@property (nonatomic) NSString *requestStr;
@property (nonatomic) NSDate *touchStartTime;
//@property (nonatomic) UIImagePickerController* imagePickerController;

@end

@implementation CenterViewController

#pragma  mark - touch events overrides
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchStartTime = [NSDate date];
    //NSLog(@"delivered to Center View Controller! begin");
}
-(void)touchesEnd:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSTimeInterval timePeriod = [[NSDate date] timeIntervalSinceDate:self.touchStartTime];
    //NSLog(@"time is %f",timePeriod);
    
    [self.superVC resetWithCenterView:self.view];
    //NSLog(@"delivered to Center View Controller! ended");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval timePeriod = [[NSDate date] timeIntervalSinceDate:self.touchStartTime];
    //NSLog(@"time is %f",timePeriod);
    if(timePeriod < 0.5){
        [self.superVC resetWithCenterView:self.view];
    }
    
    //NSLog(@"delivered to Center View Controller! canncelled");
}

#pragma mark - propertys setup
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils=[DataModalUtils sharedInstance];
    }
    return _utils;
}
-(MainViewController*)superVC
{
    if(!_superVC){
        _superVC =(MainViewController*)[self presentingViewController];
    }
    return _superVC;
}
//-(MyDealViewController*)myDealViewController
//{
//    if(!_myDealViewController){
//        _myDealViewController = [[MyDealViewController alloc] init];
//        _myDealViewController.mainVC = _superVC;
//        NSLog(@"setting main vc in centerview %@",_superVC);
//        UIPanGestureRecognizer *myDealPan = [_superVC getPanGestureRecognizer];
//        [_myDealViewController.view addGestureRecognizer:myDealPan];
//        
//        UITapGestureRecognizer *myDealTap = [_superVC getTapGestureRecognizer];
//        [_myDealViewController.view addGestureRecognizer:myDealTap];
//    }
//    return _myDealViewController;
//}
-(SellDealViewController*)sellDealController
{
    if(!_sellDealController){
        _sellDealController = [[SellDealViewController alloc] init];
        
    }
    return _sellDealController;
}

-(CenterTabBuddyDealController*)centerTabBuddyDealController
{
    if(!_centerTabBuddyDealController){
        _centerTabBuddyDealController=[[CenterTabBuddyDealController alloc] init];
        _centerTabBuddyDealController.title = @"Buddies'";
    }
    return  _centerTabBuddyDealController;
}
-(CenterTabHotDealController*)centerTabHotDealController
{
    if(!_centerTabHotDealController){
        //_centerTabHotDealController=[[CenterTabHotDealController alloc] init];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        NSLog(@"storyboard is %@",storyboard);
        _centerTabHotDealController = [storyboard instantiateViewControllerWithIdentifier:@"CenterTabHotDealController"];
        _centerTabHotDealController.mainVC = _superVC;
        [_centerTabHotDealController setup];
        _centerTabHotDealController.title = @"Hot Deals";
    }
    return _centerTabHotDealController;
}
-(CenterTabNearbyDealController*)centerTabNearbyDealController
{
    if(!_centerTabNearbyDealController){
        _centerTabNearbyDealController=[[CenterTabNearbyDealController alloc] init];
        _centerTabNearbyDealController.title = @"Nearby";
    }
    return _centerTabNearbyDealController;
}

-(UITabBarController*)tabController
{
    if(!_tabController){
        _tabController = [[UITabBarController alloc] init];
        _tabController.delegate = self;
        _tabController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tabBar = _tabController.tabBar;
        CGRect tabBarFrame = CGRectMake(0, 0, self.view.frame.size.width, TAB_BAR_HEIGHT);
        _tabController.tabBar.frame = tabBarFrame;
        
        //_tabController.tabBar.delegate = self;
        //_centerTabHotDealController.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200);
        NSArray* viewControllers = @[self.centerTabBuddyDealController,self.centerTabHotDealController, self.centerTabNearbyDealController];
        _tabController.viewControllers = viewControllers;
        _tabController.selectedIndex = 1;
        _tabController.tabBar.tintColor = [UIColor blueColor];
        for(int i=0;i<viewControllers.count;i++){
            [_tabController.tabBar.items[i] setTitlePositionAdjustment:UIOffsetMake(0, -5)];
            [_tabController.tabBar.items[i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:16.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
        //view controller container
        [self addChildViewController:_tabController];
        [self.view addSubview:_tabController.view];
        [_tabController didMoveToParentViewController:self];
    }
    return _tabController;
}

//-(UIToolbar*)toolBar
//{
//    if(!_toolBar){
//        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TOOL_BAR_HEIGHT, self.view.frame.size.width , TOOL_BAR_HEIGHT)];
//        //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [_toolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
//        _toolBar.translucent = YES;
//        
//        UIImage *mineImage = [UIImage imageNamed:@"web11.png"];
//        UIBarButtonItem *mine = [[UIBarButtonItem alloc] initWithImage:mineImage style:UIBarButtonItemStylePlain target:self.superVC action:@selector(slideRightAll)];
//        mine.width = 80;
//        
//        UIImage *postImage = [UIImage imageNamed:@"add63.png"];
//        UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithImage:postImage style:UIBarButtonItemStylePlain target:self action:@selector(showPostActionSheet)];
//        post.title = @"post";
//        post.width = 100;
//        
//        UIImage *searchImage = [UIImage imageNamed:@"zoom22.png"];
//        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:_superVC action:@selector(slideLeftAll)];
//        search.width = 80;
//        
//        NSArray *toolItems = [[NSArray alloc] initWithObjects:mine,post,search, nil];
//        [_toolBar setItems:toolItems];
//        
//        [self.view addSubview:_toolBar];
//        
//    }
//    _toolBar.delegate = self;
//    return _toolBar;
//    
//}

//-(void)showPostActionSheet
//{
//    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sell deal",@"Buy deal", nil];
//    [actionSheet showInView:self.view];
//    
//}
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //NSLog(@"buttonIndex is %ld in action sheet is clicked",buttonIndex);
//    if(buttonIndex == 2){
//        return;
//    }
//    else if(buttonIndex == 0)
//    {
//        //NSLog(@"sell button clicked");
//        
//        [self performSegueWithIdentifier:@"SellDealSegue" sender:self];
//        
//    }
//    else if(buttonIndex == 1){
//    
//    }
//}
//
//
//-(IBAction)unwindFromSellDealSegue:(UIStoryboardSegue*)sender
//{
//    NSLog(@"calling unwind from sell deal segue in center view controller");
//    [self.superVC reset];
//}


-(IBAction)doneWithSellDealSegue:(UIStoryboardSegue*)sender
{
    
}


-(void)tabBarController:tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(_tabController == tabBarController){
        NSLog(@"did select view controller: %@",viewController);
        
        
    }
}


- (void) setYelpButton:(UIButton *)yelpButton
{
    if(!_yelpButton){
        _yelpButton = yelpButton;
        [_yelpButton addTarget:self action:@selector(shouldPerformSegueWithIdentifier:sender:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(sender == _yelpButton){
        return YES;
    }
    return false;
}

-(void) setDataFetcher:(OADataFetcher*)aDataFetcher;
{
    if(!_dataFetcher){
        _dataFetcher = aDataFetcher;
        _dataFetcher.delegate = self;
    }
}

//- (IBAction)onYelpButtonClicked:(UIButton *)sender
//{
//    
////
//    
//}

-(void)connection:(NSURLConnection*)connection
 didFailWithError:(NSError*) error
       withTicket:(OAServiceTicket*)ticket
{
    NSLog(@"calling did fail with error delegate");
    NSLog(@"%@",ticket);
}

-(void)connection:(NSURLConnection *)connection finishLoadingWithTicket:(OAServiceTicket*)ticket
{
    //NSLog(@"calling did finish loading ");
    //NSLog(@"%@",ticket);
    //NSLog(@"%@",ticket.response);
    NSHTTPURLResponse * response = (NSHTTPURLResponse *)[ticket response];
    if([response statusCode]==200){
        //NSLog(@"is successful");
        //NSLog(@"data is:%@",[[NSString alloc] initWithData:[ticket data] encoding:NSUTF8StringEncoding] );
        //NSString *responses = [[NSString alloc] initWithData:[ticket data] encoding:NSUTF8StringEncoding];
        NSError * error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[ticket data] options:0 error: &error];
        //NSLog(@"%@",json);
        NSArray * buses = [json valueForKey:@"businesses"];
        for(int i=0;i<[buses count];i++){
            NSLog(@"name is: %@",[buses[i] valueForKey:@"name"]);
        }
        
    }
    
    //NSLog(@"%@",[[NSString alloc] initWithData:ticket.data encoding:NSUTF8StringEncoding]);
    
}

#pragma mark - segue methods
-(void)pushMyDealViewController
{
    
    //[self pushViewController:self.myDealViewController animated:YES];
    
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"calling center view prepare for segue %ld,%ld",[segue.identifier isEqualToString:@"SellDealSegue"], [[segue destinationViewController] isKindOfClass:[MyDealViewController class]]);
    if([[segue destinationViewController] isKindOfClass:[YelpViewController class]] ){
        YelpViewController* yelpController = (YelpViewController*)segue.destinationViewController;
        //NSLog(@"will perform segue");
        //yelpController.delegate = self.delegate;
        yelpController.term = _term;
        yelpController.limit = _limit;
        yelpController.query = _query;
        yelpController.location = _location;
    }
    else if([segue.identifier isEqualToString:@"SellDealSegue"] && [[segue destinationViewController] isKindOfClass:[SellDealViewController class]]){
        
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

#pragma mark - controller lifecycle
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"center view gesture recognizer delegate");
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return YES;
    }
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
        return YES;
    
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"centerview simultaneous GR"); 
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[GestureView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    NSArray * gestures = [self.view gestureRecognizers];
    for(UIGestureRecognizer * gesture in gestures){
        gesture.delegate = self;
    }
    
    //self.view = [[GestureView alloc] init];
    //self.view.userInteractionEnabled = YES;
    //NSLog(@"default GR count is %ld",self.view.gestureRecognizers.count);
    //self.view.frame = [UIScreen mainScreen].bounds;
    //NSLog(@"center view is %@",self.view);
    
    [self tabController];

    //[self myDealViewController];
    
    //[self toolBar];
	//[self setupGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
