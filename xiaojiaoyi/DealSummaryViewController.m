//
//  DealSummaryViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/21/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealSummaryViewController.h"

#define NAVIGATION_BAR_HEIGHT 60
#define CONTROL_BUTTON_HEIGHT 50
#define PAGE_VIEW_HEIGHT 250
#define PROFILE_HEIGHT 40
#define CONTAINER_VIEW_MARGIN 10
#define USER_PROFILE_LABEL_WIDTH 180
#define SECURED_BUTTON_CORNER_RADIUS 10.0

#define INFO_VIEW_HEIGHT 80
#define INFO_BUTTON_LEFT_MARGIN 20
#define INFO_BUTTON_TOP_MARGIN 20
#define INFO_BUTTON_HEIGHT 40
#define INFO_BUTTON_WIDTH 60
#define INFO_BUTTON_CORNER_RADIUS 20.0
#define DESCRIPTION_LABEL_HEIGHT 60
#define MAP_BUTTON_HEIGHT 70

@interface DealSummaryViewController ()
@property (nonatomic) UIScrollView *mainView;
@property (nonatomic) UIPageViewController* pageVC;
@property (nonatomic) NSArray* photos;
@property (nonatomic) NSArray* photoTitles;
@property (nonatomic) NSArray* photoNames;
@property (nonatomic) UIPageControl* pageControl;
@property (nonatomic) NSInteger willTransitionToPageViewIndex;

@property (nonatomic) UIView* containerView;

@property (nonatomic) UIView* profileView;
@property (nonatomic) UIButton* userProfileButton;
@property (nonatomic) UILabel* userProfileLabel;
@property (nonatomic) NSString* userName;
@property (nonatomic) UIButton* securedButton;

@property (nonatomic) UIView* playSoundView;
@property (nonatomic) UIButton* playSoundButton;
@property (nonatomic) UILabel* playSoundLabel;

@property (nonatomic) UIView* exchangeView;
@property (nonatomic) UIButton* exchangeButton;
@property (nonatomic) UILabel* exchangeLabel;

@property (nonatomic) UIView* shippingView;
@property (nonatomic) UIButton* shippingButton;
@property (nonatomic) UILabel* shippingLabel;

@property (nonatomic) UILabel* descriptionLabel;
@property (nonatomic) UILabel* conditionLabel;
@property (nonatomic) UILabel* expiryLabel;

@property (nonatomic) UIButton* reliabilityButton;
@property (nonatomic) UIButton* mapButton;
@property (nonatomic) UIColor* infoButtonFrameColor;

@property (nonatomic) UIButton* cancelButton;
@property (nonatomic) UIButton* confirmButton;
@property (nonatomic) UIAlertView* alertView;
@end

@implementation DealSummaryViewController

#pragma mark - components setup
-(UIColor*)infoButtonFrameColor
{
    if(!_infoButtonFrameColor){
        _infoButtonFrameColor=[UIColor orangeColor];
    }
    return _infoButtonFrameColor;
}
-(UIPageViewController*)pageVC
{
    if(!_pageVC){
        _pageVC=[[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.delegate=self;
        _pageVC.dataSource=self;
        _pageVC.view.frame = CGRectMake(0,0,self.view.frame.size.width,PAGE_VIEW_HEIGHT);
        //self.pageVC.view.layer.borderWidth = 4.0;
        _pageVC.view.layer.borderColor = [[UIColor greenColor] CGColor];
        _pageVC.doubleSided = true;
        
        DetailPageContentViewController *startingVC = [self contentViewAtIndex:0];
        NSArray * contentArray=@[startingVC];
        [_pageVC setViewControllers:contentArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    }
    return _pageVC;
}
-(UIScrollView*)mainView
{
    if(!_mainView){
        _mainView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
        //_mainView.contentSize=CGSizeMake(self.view.frame.size.width, PAGE_VIEW_HEIGHT+600);
        _mainView.contentSize=CGSizeMake(self.view.frame.size.width, self.containerView.frame.origin.y+self.containerView.frame.size.height+CONTROL_BUTTON_HEIGHT);
        _mainView.backgroundColor=[UIColor lightGrayColor];
        [_mainView addSubview:self.pageVC.view];
        [_mainView addSubview:self.pageControl];
    }
    return _mainView;
}
-(UIPageControl*)pageControl
{
    if(!_pageControl){
        _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(142, 190, 40, 37)];
        _pageControl.numberOfPages=self.photoTitles.count;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    return _pageControl;
}
//-------container view---------------
-(UIView*)containerView
{
    if(!_containerView){
        _containerView=[[UIView alloc] init];
        [_containerView addSubview:self.profileView];
        [_containerView addSubview:self.playSoundView];
        [_containerView addSubview:self.exchangeView];
        [_containerView addSubview:self.shippingView];
        [_containerView addSubview:self.descriptionLabel];
        [_containerView addSubview:self.conditionLabel];
        [_containerView addSubview:self.expiryLabel];
        [_containerView addSubview:self.mapButton];
        _containerView.frame=CGRectMake(CONTAINER_VIEW_MARGIN, PAGE_VIEW_HEIGHT+10, self.view.frame.size.width-CONTAINER_VIEW_MARGIN*2, self.mapButton.frame.origin.y+self.mapButton.frame.size.height+CONTAINER_VIEW_MARGIN);
        _containerView.backgroundColor=[UIColor whiteColor];
        _containerView.layer.cornerRadius=5.0;

    }
    return _containerView;
}
-(UIView*)profileView
{
    if(!_profileView){
        _profileView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN, PROFILE_HEIGHT)];
        
        [_profileView addSubview:self.userProfileButton];
        [_profileView addSubview:self.userProfileLabel];
        [_profileView addSubview:self.securedButton];
    }
    return _profileView;
}
-(UIButton*)userProfileButton
{
    if(!_userProfileButton){
        _userProfileButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 0, PROFILE_HEIGHT, PROFILE_HEIGHT)];
        [_userProfileButton setImage:[UIImage imageNamed:@"twitter small icon.jpg"] forState:UIControlStateNormal];
        _userProfileButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_userProfileButton addTarget:self action:@selector(userProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _userProfileButton.layer.cornerRadius= 10.0;
        _userProfileButton.layer.borderColor=[[UIColor whiteColor] CGColor];
        _userProfileButton.layer.borderWidth=2.0f;
    }
    return _userProfileButton;
}
-(UILabel*)userProfileLabel
{
    if(!_userProfileLabel){
        _userProfileLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.userProfileButton.frame.origin.x+self.userProfileButton.frame.size.width+5, 0, USER_PROFILE_LABEL_WIDTH, PROFILE_HEIGHT)];
        _userProfileLabel.attributedText=[[NSAttributedString alloc] initWithString:@"this is a very long user name" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],NSForegroundColorAttributeName:[UIColor blackColor]}];

        _userProfileLabel.numberOfLines=1;
        [_userProfileLabel adjustsFontSizeToFitWidth];
    }
    return _userProfileLabel;
}
-(UIButton*)securedButton
{
    if(!_securedButton){
        _securedButton=[[UIButton alloc] initWithFrame:CGRectMake(self.userProfileLabel.frame.origin.x + self.userProfileLabel.frame.size.width+5, 5, self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN-(self.userProfileLabel.frame.origin.x + self.userProfileLabel.frame.size.width+5), PROFILE_HEIGHT-2*5)];
        _securedButton.layer.cornerRadius=15.0;
        _securedButton.layer.borderWidth=2.0;
        _securedButton.layer.borderColor=[[UIColor whiteColor] CGColor];
        NSAttributedString* title=[[NSAttributedString alloc] initWithString:@"secured" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [_securedButton setAttributedTitle:title forState:UIControlStateNormal];
        _securedButton.backgroundColor=[UIColor orangeColor];
    }
    return _securedButton;
}
//------------------------
-(UIView*)playSoundView
{
    if(!_playSoundView){
        _playSoundView=[[UIView alloc] initWithFrame:CGRectMake(0, PROFILE_HEIGHT, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3,INFO_VIEW_HEIGHT)];
        _playSoundView.layer.borderWidth=2.0;
        _playSoundView.layer.borderColor=[self.infoButtonFrameColor CGColor];
        _playSoundView.backgroundColor=[UIColor lightGrayColor];
        [_playSoundView addSubview:self.playSoundButton];
    }
    return _playSoundView;
}
-(UIButton*)playSoundButton
{
    if(!_playSoundButton){
        _playSoundButton=[[UIButton alloc] initWithFrame:CGRectMake(INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_TOP_MARGIN, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3 - 2*INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_HEIGHT)];
        _playSoundButton.layer.cornerRadius = INFO_BUTTON_CORNER_RADIUS;
        _playSoundButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _playSoundButton.layer.borderWidth=2.0;
        [_playSoundButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_playSoundButton setBackgroundColor:[UIColor whiteColor]];
        [_playSoundButton setTintColor:[UIColor blueColor]];
        [_playSoundButton addTarget:self action:@selector(playSoundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playSoundButton;
}
//-------------------------
-(UIView*)exchangeView
{
    if(!_exchangeView){
        _exchangeView=[[UIView alloc] initWithFrame:CGRectMake(self.playSoundView.frame.origin.x+self.playSoundView.frame.size.width, PROFILE_HEIGHT, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3,INFO_VIEW_HEIGHT)];
        _exchangeView.layer.borderWidth=2.0;
        _exchangeView.layer.borderColor=[self.infoButtonFrameColor CGColor];
        _exchangeView.backgroundColor=[UIColor lightGrayColor];
        [_exchangeView addSubview:self.exchangeButton];
    }
    return _exchangeView;
}
-(UIButton*)exchangeButton
{
    if(!_exchangeButton){
        _exchangeButton=[[UIButton alloc] initWithFrame:CGRectMake(INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_TOP_MARGIN, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3 - 2*INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_HEIGHT)];
        _exchangeButton.layer.cornerRadius = INFO_BUTTON_CORNER_RADIUS;
        _exchangeButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _exchangeButton.layer.borderWidth=2.0;
        [_exchangeButton setImage:[[UIImage imageNamed:@"exchange.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _exchangeButton.tintColor=[UIColor colorWithRed:000/255.0 green:200/255.0 blue:000/255.0 alpha:1.0];
        _exchangeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_exchangeButton setBackgroundColor:[UIColor whiteColor]];
        [_exchangeButton addTarget:self action:@selector(exchangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}
//-------------------------
-(UIView*)shippingView
{
    if(!_shippingView){
        _shippingView=[[UIView alloc] initWithFrame:CGRectMake(self.exchangeView.frame.origin.x+self.exchangeView.frame.size.width, PROFILE_HEIGHT, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3,INFO_VIEW_HEIGHT)];
        _shippingView.layer.borderWidth=2.0;
        _shippingView.layer.borderColor=[self.infoButtonFrameColor CGColor];
        _shippingView.backgroundColor=[UIColor lightGrayColor];
        [_shippingView addSubview:self.shippingButton];
    }
    return _shippingView;
}
-(UIButton*)shippingButton
{
    if(!_shippingButton){
        _shippingButton=[[UIButton alloc] initWithFrame:CGRectMake(INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_TOP_MARGIN, (self.view.frame.size.width-2*CONTAINER_VIEW_MARGIN)/3 - 2*INFO_BUTTON_LEFT_MARGIN, INFO_BUTTON_HEIGHT)];
        _shippingButton.layer.cornerRadius = INFO_BUTTON_CORNER_RADIUS;
        _shippingButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _shippingButton.layer.borderWidth=2.0;
        [_shippingButton setImage:[[UIImage imageNamed:@"delivery.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _shippingButton.tintColor=[UIColor magentaColor];
        _shippingButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_shippingButton setBackgroundColor:[UIColor whiteColor]];
        [_shippingButton addTarget:self action:@selector(shippingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shippingButton;
}
//-------------------------------
-(UILabel*)descriptionLabel
{
    if(!_descriptionLabel){
        _descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(CONTAINER_VIEW_MARGIN, self.playSoundView.frame.origin.y+self.playSoundView.frame.size.height + CONTAINER_VIEW_MARGIN, self.view.frame.size.width-4*CONTAINER_VIEW_MARGIN, 0)];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
        NSAttributedString* text= [[NSAttributedString alloc] initWithString:self.descriptionStr attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
        _descriptionLabel.attributedText=text;
        _descriptionLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _descriptionLabel.textAlignment=NSTextAlignmentJustified;
        _descriptionLabel.numberOfLines=0;
        //_descriptionLabel.backgroundColor=[UIColor whiteColor];
        [_descriptionLabel sizeToFit];
        
    }
    return _descriptionLabel;
}
-(UILabel*)conditionLabel
{
    if(!_conditionLabel){
        _conditionLabel=[[UILabel alloc] initWithFrame:CGRectMake(CONTAINER_VIEW_MARGIN, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height + CONTAINER_VIEW_MARGIN, self.view.frame.size.width-4*CONTAINER_VIEW_MARGIN, 0)];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
        NSAttributedString* text= [[NSAttributedString alloc] initWithString:self.conditionStr attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
        _conditionLabel.attributedText=text;
        _conditionLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _conditionLabel.numberOfLines=0;
        [_conditionLabel sizeToFit];
        
    }
    return _conditionLabel;
}
-(UILabel*)expiryLabel
{
    if(!_expiryLabel){
        _expiryLabel=[[UILabel alloc] initWithFrame:CGRectMake(CONTAINER_VIEW_MARGIN, self.conditionLabel.frame.origin.y+self.conditionLabel.frame.size.height, self.view.frame.size.width-4*CONTAINER_VIEW_MARGIN, 0)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm"];
        NSString* expireDate=[dateFormatter stringFromDate:self.expireDate];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
        NSAttributedString* text= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"expire by %@", expireDate] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
        _expiryLabel.attributedText=text;
        _expiryLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _expiryLabel.numberOfLines=0;
        [_expiryLabel sizeToFit];
        
    }
    return _expiryLabel;
}

-(UIButton*)mapButton
{
    if(!_mapButton){
        _mapButton =[[UIButton alloc] initWithFrame:CGRectMake(CONTAINER_VIEW_MARGIN, self.expiryLabel.frame.origin.y+self.expiryLabel.frame.size.height + CONTAINER_VIEW_MARGIN, self.view.frame.size.width-4*CONTAINER_VIEW_MARGIN, MAP_BUTTON_HEIGHT)];
        _mapButton.layer.cornerRadius=10.0;
        _mapButton.layer.borderColor=[[UIColor whiteColor] CGColor];
        _mapButton.layer.borderWidth=2.0;
        _mapButton.backgroundColor=[UIColor lightGrayColor];
    }
    return _mapButton;
}
//------cancel and confirm button---------
-(UIButton*)cancelButton
{
    if(!_cancelButton){
        //_cancelButton=[[UIButton alloc] init];
        _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, self.view.frame.size.height-CONTROL_BUTTON_HEIGHT, self.view.frame.size.width/2, CONTROL_BUTTON_HEIGHT);
        UIImage* image = [UIImage imageNamed:@"cross.png"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//always tint
        //[_cancelButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [_cancelButton setImage:image forState:UIControlStateNormal];
        _cancelButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        _cancelButton.tintColor=[UIColor redColor];
        //_cancelButton.tintColor=
        _cancelButton.backgroundColor=[UIColor whiteColor];
        _cancelButton.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 0);
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    _cancelButton.tintColor=[UIColor redColor];
    return _cancelButton;
}
-(UIButton*)confirmButton
{
    if(!_confirmButton){
        _confirmButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-CONTROL_BUTTON_HEIGHT, self.view.frame.size.width/2, CONTROL_BUTTON_HEIGHT)];
        UIImage* image = [UIImage imageNamed:@"correct.png"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_confirmButton setImage:image forState:UIControlStateNormal];
        //[_confirmButton setImage:[UIImage imageNamed:@"correct.png"] forState:UIControlStateNormal];
        _confirmButton.tintColor=[UIColor greenColor];
        _confirmButton.backgroundColor=[UIColor whiteColor];
        _confirmButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
-(UIAlertView*)alertView
{
    if(!_alertView){
        _alertView=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to delete the deal?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    }
    return _alertView;
}
-(void)setup
{
    if(!self.descriptionStr){
        self.descriptionStr=@"description: this is a description about a deal posted by this app. this item is almost new and used only a couple of times. I am located in san francisco. shipping will be provided at buyer's expense.";
    }
    if(!self.conditionStr){
        self.conditionStr=@"condition: <80%";
    }
    if(!self.expireDate){
        self.expireDate=[NSDate date];
    }
    self.photoTitles =@[@"This is google icon",@"This is facebook icon", @"this is linkedin"];
    self.photoNames=@[@"google.jpg",@"facebook.jpg",@"linkedin.jpg"];
    [self pageVC];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.containerView];
    self.mainView.contentSize=CGSizeMake(self.view.frame.size.width, self.containerView.frame.origin.y+self.containerView.frame.size.height+CONTROL_BUTTON_HEIGHT);

    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
}


#pragma mark - button clicked methods
-(void)userProfileButtonClicked:(UIButton*)sender
{
    
}
-(void)playSoundButtonClicked:(UIButton*)sender
{
    NSLog(@"play button clicked");
}
-(void)exchangeButtonClicked:(UIButton*)sender
{
    NSLog(@"exchange button clicked");
}
-(void)shippingButtonClicked:(UIButton*)sender
{
    NSLog(@"shipping button clicked");
}
-(void)cancelButtonClicked:(UIButton*)sender
{
    [self.alertView show];
}
-(void)confirmButtonClicked:(UIButton*)sender
{
    NSLog(@"confirmed and calling core data");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSLog(@"0 clicked");
    }
    else if(buttonIndex==1){
        NSLog(@"1 clicked");
        [self performSegueWithIdentifier:@"DealSummaryUnwindSegue" sender:self];
    }
}
#pragma mark - pageview methods
//------data source-----------------
-(DetailPageContentViewController*) contentViewAtIndex:(NSUInteger)index
{
    DetailPageContentViewController *contentVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailPageContentController"];
    contentVC.contentImage = self.photoNames[index];
    contentVC.contentTitle = self.photoTitles[index];
    contentVC.index = index;
    return contentVC;
}
-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index =((DetailPageContentViewController*)viewController).index;
    if(index==0 || index == NSNotFound)
        return nil;
    return [self contentViewAtIndex:--index];
}
-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    DetailPageContentViewController *pVC = (DetailPageContentViewController*)viewController;
    NSUInteger idx = pVC.index;
    if(idx == NSNotFound || idx == self.photoTitles.count - 1)
        return nil;
    return [self contentViewAtIndex:++idx];
}

//-----------delegate------------
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    self.willTransitionToPageViewIndex = ((DetailPageContentViewController*)pendingViewControllers[0]).index;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //completed meaning it the transition to a new page view is completed
    self.pageControl.currentPage = completed?self.willTransitionToPageViewIndex:((DetailPageContentViewController*)previousViewControllers[0]).index;
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
