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


#define YELP_CONSUMER_KEY @"f1UUkqY-ArXOelq_hGKBOg"
#define YELP_CONSUMER_SECRET @"J-aIV0DJDUOJ4cBdGyBkIKmcdoY"
#define YELP_TOKEN @"-At-okxmS72TvU8_-y1iiO3wU57dzvVY"
#define YELP_TOKEN_SECRET @"cb9FGc7X_WrsbEjihdqZ5y7Hz2Y"
#define TOOL_BAR_HEIGHT 50
#define TAB_BAR_HEIGHT 50

@interface CenterViewController ()

@property NSString *requestStr;

@end

@implementation CenterViewController

-(MainViewController*)superVC
{
    if(!_superVC){
        _superVC =(MainViewController*)[self presentingViewController];
    }
    return _superVC;
}

-(void)initTabBarAndController
{
    if(!_tabController){
        _tabController = [[UITabBarController alloc] init];
    }
    _tabController.delegate = self;
    _tabController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _tabBar = _tabController.tabBar;
    CGRect tabBarFrame = CGRectMake(0, 0, self.view.frame.size.width, TAB_BAR_HEIGHT);
    _tabController.tabBar.frame = tabBarFrame;

    //_tabController.tabBar.delegate = self;
    
    if(!_centerTabHotDealController){
        _centerTabHotDealController = [[CenterTabHotDealController alloc] init];
    }
    if(!_centerTabBuddyDealController){
        _centerTabBuddyDealController = [[CenterTabBuddyDealController alloc] init];
    }
    if(!_centerTabNearbyDealController){
        _centerTabNearbyDealController = [[CenterTabNearbyDealController alloc] init];
    }
    //_centerTabHotDealController.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200);
    
    _centerTabHotDealController.title = @"Hot Deals";
    _centerTabHotDealController.mainVC = self.superVC;
    
    _centerTabBuddyDealController.title = @"Buddies'";
    _centerTabNearbyDealController.title = @"Nearby";
    NSArray* viewControllers = @[_centerTabBuddyDealController,_centerTabHotDealController, _centerTabNearbyDealController];
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

-(UIToolbar*)toolBar
{
    if(!_toolBar){
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TOOL_BAR_HEIGHT, self.view.frame.size.width , TOOL_BAR_HEIGHT)];
        //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
        _toolBar.translucent = YES;
        
        UIImage *mineImage = [UIImage imageNamed:@"web11.png"];
        UIBarButtonItem *mine = [[UIBarButtonItem alloc] initWithImage:mineImage style:UIBarButtonItemStylePlain target:self.superVC action:@selector(slideRightAll)];
        mine.width = 80;
        
        UIImage *postImage = [UIImage imageNamed:@"add63.png"];
        UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithImage:postImage style:UIBarButtonItemStylePlain target:self action:@selector(showPostActionSheet)];
        post.title = @"post";
        post.width = 100;
        
        UIImage *searchImage = [UIImage imageNamed:@"zoom22.png"];
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:_superVC action:@selector(slideLeftAll)];
        search.width = 80;
        
        NSArray *toolItems = [[NSArray alloc] initWithObjects:mine,post,search, nil];
        [_toolBar setItems:toolItems];
        
        [self.view addSubview:_toolBar];
        
    }
    _toolBar.delegate = self;
    return _toolBar;
    
}
-(void)showPostActionSheet
{
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sell deal",@"Buy deal", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is %ld in action sheet is clicked",buttonIndex);
    if(buttonIndex == 3){
        return;
    }
    else if(buttonIndex == 1)
    {
    
    }
    else if(buttonIndex == 2){
    
    }
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

- (IBAction)onYelpButtonClicked:(UIButton *)sender
{
    
//
    
}

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

#pragma mark - collection view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[YelpViewController class]] ){
        YelpViewController* yelpController = (YelpViewController*)segue.destinationViewController;
        //NSLog(@"will perform segue");
        //yelpController.delegate = self.delegate;
        yelpController.term = _term;
        yelpController.limit = _limit;
        yelpController.query = _query;
        yelpController.location = _location;
    }
}

#pragma mark - controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBarAndController];
    [self toolBar];
	//[self setupGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
