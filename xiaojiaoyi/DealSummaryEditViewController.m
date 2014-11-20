//
//  DealSummaryEditViewController.m
//  xiaojiaoyi
//
//  Created by chen on 11/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealSummaryEditViewController.h"

#define NAVIGATION_BAR_HEIGHT 65
#define CONTROL_BUTTON_HEIGHT 50
#define PAGE_VIEW_HEIGHT 250
#define PROFILE_HEIGHT 40
#define CONTAINER_VIEW_MARGIN 10
#define USER_PROFILE_LABEL_WIDTH 180
#define SECURED_BUTTON_CORNER_RADIUS 10.0
#define TITLE_VIEW_HEIGHT 40
#define TITLE_WIDTH 280

#define INFO_VIEW_HEIGHT 80
#define INFO_BUTTON_LEFT_MARGIN 20
#define INFO_BUTTON_TOP_MARGIN 20
#define INFO_BUTTON_HEIGHT 40
#define INFO_BUTTON_WIDTH 60
#define INFO_BUTTON_CORNER_RADIUS 20.0
#define DESCRIPTION_LABEL_HEIGHT 60
#define MAP_BUTTON_HEIGHT 70

#define SHARE_COLLECTION_VIEW_HEIGHT 100
#define SHARE_BUTTON_WIDTH 50

@interface DealSummaryEditViewController ()
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

@property (nonatomic) UIButton* deleteButton;
@property (nonatomic) UIButton* shareButton;
@property (nonatomic) UIAlertView* deleteAlertView;
@property (nonatomic) UIView* titleView;

@property (nonatomic) UIView* shareCollectionView;
@property (nonatomic) DataModalUtils* utils;
@property (nonatomic) UIButton* ggButton;
@property (nonatomic) UIButton* fbButton;
@property (nonatomic) UIButton* twButton;
@property (nonatomic) UIButton* lkButton;
@property (nonatomic) NSMutableArray* uploadPhotoURI;

//twitter tweet placeholder
@property (nonatomic) NSMutableString* statusString;
@end

@implementation DealSummaryEditViewController

#pragma mark - components setup
-(NSMutableArray*)uploadPhotoURI
{
    if(!_uploadPhotoURI){
        _uploadPhotoURI = [[NSMutableArray alloc] init];
    }
    return _uploadPhotoURI;
}
-(UIButton*)ggButton
{
    if(!_ggButton){
        _ggButton=[[UIButton alloc] init];
    }
    return _ggButton;
}
-(UIButton*)twButton
{
    if(!_twButton){
        _twButton = [[UIButton alloc] init];
    }
    return _twButton;
}
-(UIButton*)lkButton
{
    if(!_lkButton){
        _lkButton = [[UIButton alloc] init];
    }
    return _lkButton;
}
-(UIButton*)fbButton
{
    if(!_fbButton){
        _fbButton = [[UIButton alloc] init];
    }
    return _fbButton;
}
-(UIView*)shareCollectionView
{
    if(!_shareCollectionView){
        _shareCollectionView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, SHARE_COLLECTION_VIEW_HEIGHT)];
        _shareCollectionView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        CGFloat sep = (_shareCollectionView.frame.size.width - 4*SHARE_BUTTON_WIDTH)/5;
        CGFloat heightMargin = (_shareCollectionView.frame.size.height - SHARE_BUTTON_WIDTH)/2;
        self.fbButton.frame= CGRectMake(sep, heightMargin, SHARE_BUTTON_WIDTH, SHARE_BUTTON_WIDTH);
        [self.fbButton setImage:[[UIImage imageNamed:@"facebook.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.fbButton setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
        self.fbButton.tintColor = [UIColor blueColor];
        self.fbButton.backgroundColor=[UIColor whiteColor];
        self.fbButton.layer.cornerRadius = 10.0;
        [self.fbButton addTarget:self action:@selector(fbButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.twButton.frame=CGRectMake(sep*2 + 1*SHARE_BUTTON_WIDTH, heightMargin, SHARE_BUTTON_WIDTH, SHARE_BUTTON_WIDTH);
        [self.twButton setImage:[[UIImage imageNamed:@"twitter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.twButton.backgroundColor=[UIColor whiteColor];
        self.twButton.layer.cornerRadius = 10.0;
        [self.twButton addTarget:self action:@selector(twButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.ggButton.frame=CGRectMake(sep*3 + 2*SHARE_BUTTON_WIDTH, heightMargin, SHARE_BUTTON_WIDTH, SHARE_BUTTON_WIDTH);
        [self.ggButton setImage:[[UIImage imageNamed:@"googlePlus.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.ggButton.tintColor = [UIColor redColor];
        self.ggButton.backgroundColor= [UIColor whiteColor];
        self.ggButton.layer.cornerRadius = 10.0;
        [self.ggButton addTarget:self action:@selector(ggButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.lkButton.frame=CGRectMake(sep*4 + 3*SHARE_BUTTON_WIDTH, heightMargin, SHARE_BUTTON_WIDTH, SHARE_BUTTON_WIDTH);
        [self.lkButton setImage:[[UIImage imageNamed:@"linkedin.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.lkButton.backgroundColor = [UIColor whiteColor];
        self.lkButton.layer.cornerRadius = 10.0;
        [self.lkButton addTarget:self action:@selector(lkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_shareCollectionView addSubview:self.fbButton];
        [_shareCollectionView addSubview:self.ggButton];
        [_shareCollectionView addSubview:self.twButton];
        [_shareCollectionView addSubview:self.lkButton];
        
        [_shareCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareCollectionViewTapped:)]];
    }
    return _shareCollectionView;
}
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils = [DataModalUtils sharedInstance];
    }
    return _utils;
}
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
//        NSMutableArray *contentArray = [[NSMutableArray alloc] init];
//        if(startingVC){
//            [contentArray addObject:startingVC];
//        }

        NSArray * contentArray=@[startingVC];
        [_pageVC setViewControllers:contentArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageVC;
}
-(UIView*)titleView
{
    if(!_titleView){
        _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, PAGE_VIEW_HEIGHT-TITLE_VIEW_HEIGHT, self.view.frame.size.width, TITLE_VIEW_HEIGHT)];
        _titleView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];//[UIColor colorWithWhite:0.5 alpha:0.5];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_WIDTH, TITLE_VIEW_HEIGHT)];
        
        titleLabel.attributedText=[[NSAttributedString alloc] initWithString:self.myNewDeal.title?self.myNewDeal.title:@"default title" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        titleLabel.tintColor=[UIColor whiteColor];
        
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_WIDTH, 0, self.view.frame.size.width-TITLE_WIDTH, TITLE_VIEW_HEIGHT)];
        priceLabel.attributedText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",self.myNewDeal.price] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [_titleView addSubview:titleLabel];
        [_titleView addSubview:priceLabel];
    }
    return _titleView;
}
-(UIScrollView*)mainView
{
    if(!_mainView){
        _mainView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
        //_mainView.contentSize=CGSizeMake(self.view.frame.size.width, PAGE_VIEW_HEIGHT+600);
        _mainView.contentSize=CGSizeMake(self.view.frame.size.width, self.containerView.frame.origin.y+self.containerView.frame.size.height+CONTROL_BUTTON_HEIGHT);
        _mainView.backgroundColor=[UIColor lightGrayColor];
        [_mainView addSubview:self.pageVC.view];
        [_mainView addSubview:self.titleView];
        [_mainView addSubview:self.pageControl];
    }
    return _mainView;
}
-(UIPageControl*)pageControl
{
    if(!_pageControl){
        _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(142, 210, 40, 37)];
        _pageControl.numberOfPages=self.myNewDeal.photos.count; //self.photoTitles.count;
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
        _userProfileLabel.attributedText=[[NSAttributedString alloc] initWithString:self.myNewDeal.user_id_created?self.myNewDeal.user_id_created:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],NSForegroundColorAttributeName:[UIColor blackColor]}];
        
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
        [_playSoundButton setBackgroundColor:self.myNewDeal.sound_url?[UIColor orangeColor]:[UIColor lightGrayColor]];
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
        _exchangeButton.backgroundColor=self.myNewDeal.exchange?[UIColor orangeColor]:[UIColor lightGrayColor];
        _exchangeButton.tintColor=[UIColor blueColor];
        _exchangeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
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
        _shippingButton.backgroundColor=self.myNewDeal.shipping?[UIColor orangeColor]:[UIColor lightGrayColor];
        _shippingButton.tintColor=[UIColor blueColor];
        _shippingButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
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
        NSAttributedString* text= [[NSAttributedString alloc] initWithString:self.myNewDeal.describe?self.myNewDeal.describe:@"" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
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
        NSAttributedString* text= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"condition: %@",self.myNewDeal.condition?self.myNewDeal.condition:@""] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
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
        //[dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm"];
        [dateFormatter setDateFormat:@" MMM/dd/yyyy"];
        NSString* expireDate=[dateFormatter stringFromDate:self.myNewDeal.expire_date];
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
        if(self.myNewDeal.map_image_url){
            NSString* urlPath = self.myNewDeal.map_image_url;
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:urlPath]];
            [_mapButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    return _mapButton;
}
//------cancel and confirm button---------
-(UIButton*)deleteButton
{
    if(!_deleteButton){
        //_cancelButton=[[UIButton alloc] init];
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, self.view.frame.size.height-CONTROL_BUTTON_HEIGHT, self.view.frame.size.width/2, CONTROL_BUTTON_HEIGHT);
        UIImage* image = [UIImage imageNamed:@"trash.png"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//always tint
        //[_cancelButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:image forState:UIControlStateNormal];
        _deleteButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        _deleteButton.tintColor=[UIColor redColor];
        //_cancelButton.tintColor=
        _deleteButton.backgroundColor=[UIColor whiteColor];
        _deleteButton.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 0);
        [_deleteButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
-(UIButton*)shareButton
{
    if(!_shareButton){
        _shareButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-CONTROL_BUTTON_HEIGHT, self.view.frame.size.width/2, CONTROL_BUTTON_HEIGHT)];
        UIImage* image = [UIImage imageNamed:@"share.png"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_shareButton setImage:image forState:UIControlStateNormal];
        //[_confirmButton setImage:[UIImage imageNamed:@"correct.png"] forState:UIControlStateNormal];
        _shareButton.tintColor=[UIColor greenColor];
        _shareButton.backgroundColor=[UIColor whiteColor];
        _shareButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        _shareButton.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 0);
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
-(UIAlertView*)deleteAlertView
{
    if(!_deleteAlertView){
        _deleteAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to delete the deal?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    }
    return _deleteAlertView;
}
-(void)setup
{
    if(self.myNewDeal){
        self.cancelDeal=NO;
    }
    if(self.myNewDeal.photos){
        self.photos=self.myNewDeal.photos;
    }
    else if(self.myNewDeal.photoURL){
        NSMutableArray* photos = [[NSMutableArray alloc] init];
        for(NSString* url in self.myNewDeal.photoURL){
            NSData* imageData = [NSData dataWithContentsOfFile:url];
            UIImage* image = [UIImage imageWithData:imageData];
            [photos addObject:image];
        }
        self.photos = photos;
    }
    else{
        NSLog(@"!!!ERROR: in DealSummaryEditViewController, there is no snapshots to be shown!");
    }
    [self pageVC];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.containerView];
    
    self.mainView.contentSize=CGSizeMake(self.view.frame.size.width, self.containerView.frame.origin.y+self.containerView.frame.size.height+CONTROL_BUTTON_HEIGHT);
    
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.shareCollectionView];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
    
}


#pragma mark - share methods
//===================Facebook methods===================
-(void)createFBGraphObject
{

    NSLog(@"starting to create graph object");
    NSMutableDictionary<FBOpenGraphObject>* object= [FBGraphObject openGraphObjectForPost];
    object.provisionedForPost=YES;
    object[@"title"]=[NSString stringWithFormat:@"%@,%d",self.myNewDeal.title,rand()%100];
    object[@"description"]=self.myNewDeal.describe;
    object[@"type"]=@"xiaojiaoyi:item";
    object[@"url"] = @"http://exampleurl.com/idk";
    NSMutableArray* urls= [[NSMutableArray alloc] init];
    for(int i=0;i<self.uploadPhotoURI.count;i++){
        NSDictionary* dict = [[NSDictionary alloc] initWithObjects:@[@"false",self.uploadPhotoURI[i]] forKeys:@[@"user_generated",@"url"]];
        [urls addObject:dict];
    }
    object[@"image"]=urls;
    object[@"retailer_item_id"]=@"random_retailID";
    object[@"price"]=self.myNewDeal.price;
    object[@"availability"]=@"true";
    object[@"condition"]=@"new";

    for(int i=0;i<self.uploadPhotoURI.count;i++){
        nil;
        // NSLog(@"uri to be uploaded:%@",self.uploadPhotoURI[i]);
    }
    [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            NSString* objectId=[result objectForKey:@"id"];
            NSLog(@"objId is %@",objectId);
        }
        else{
            NSLog(@"posting graph error!:%@",error);
        }
    }];
    
    //===========================================
//    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject openGraphObjectForPostWithType:nil title:@"Sample Item"
//                                            image:@"https://fbstatic-a.akamaihd.net/images/devsite/attachment_blank.png"
//                                              url:@"http://samples.ogp.me/612460332144487"
//                                      description:@"this is a description"];
    
//    [FBRequestConnection startForPostWithGraphPath:@"me/objects/product.item"
//                                       graphObject:object
//                                 completionHandler:^(FBRequestConnection *connection,
//                                                     id result,
//                                                     NSError *error) {
//                                     // handle the result
//                                     if(!error){
//                                         NSString* objectId=[result objectForKey:@"id"];
//                                         NSLog(@"objId is %@",objectId);
//                                     }
//                                     else{
//                                         NSLog(@"posting graph error!:%@",error);
//                                     }
//
//                                 }];
    
    
    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"337462276428867", @"fb:app_id",
//                            @"xiaojiaoyi.item", @"og:type",
//                            @"Put your own URL to the object here", @"og:url",
//                            @"Sample Item", @"og:title",
//                            @"https://fbstatic-a.akamaihd.net/images/devsite/attachment_blank.png", @"og:image",
//                            @"randome sample id", @"product:retailer_item_id",
//                            @"Sample Shipping Cost: ", @"product:shipping_cost:amount",
//                            @"Sample Shipping Cost: ", @"product:shipping_cost:currency",
//                            @"Sample Shipping Weight: Value", @"product:shipping_weight:value",
//                            @"Sample Shipping Weight: Units", @"product:shipping_weight:units",
//                            @"Sample Sale Price: ", @"product:sale_price:amount",
//                            @"Sample Sale Price: ", @"product:sale_price:currency",
//                            @"Sample Sale Price Dates: Start", @"product:sale_price_dates:start",
//                            @"Sample Sale Price Dates: End", @"product:sale_price_dates:end",
//                            @"Sample Availability", @"product:availability",
//                            @"Sample Condition", @"product:condition",
//                            nil
//                            ];
//
//    [FBRequestConnection startForPostWithGraphPath:@"me/objects/product.item"
//                                       graphObject:object
//                                 completionHandler:^(FBRequestConnection *connection,
//                                                     id result,
//                                                     NSError *error) {
//                                     if(!error){
//                                         NSString* objectId=[result objectForKey:@"id"];
//                                         NSLog(@"objId is %@",objectId);
//                                     }
//                                     else{
//                                         NSLog(@"posting graph error!:%@",error);
//                                     }

//                                     // handle the result
//                                 }];
    
//    [FBRequestConnection startWithGraphPath:@"/me/objects/xiaojiaoyi.item"
//                                 parameters:params
//                                 HTTPMethod:@"POST"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              
//                              if(!error){
//                                  NSString* objectId=[result objectForKey:@"id"];
//                                  NSLog(@"objId is %@",objectId);
//                              }
//                              else{
//                                  NSLog(@"posting graph error!:%@",error);
//                              }
//                              /* handle the result */
//                          }];
    
    
}

-(void)shareFBWithShareDialog
{
    NSLog(@"in share FB with Share Dialog");
    id<FBGraphObject> object = [FBGraphObject openGraphObjectForPostWithType:@"xiaojiaoyi:dish"
                                            title:self.myNewDeal.title
                                            image:self.uploadPhotoURI[0] //@"http://i.imgur.com/g3Qc1HN.png"
                                              url:@"http://example.com/roasted_pumpkin_seeds"
                                      description:self.myNewDeal.describe];
    // Create an action
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    
    
    NSMutableArray* urls= [[NSMutableArray alloc] init];
    for(int i=0;i<self.uploadPhotoURI.count;i++){
        NSDictionary* dict = [[NSDictionary alloc] initWithObjects:@[@"true",self.uploadPhotoURI[i]] forKeys:@[@"user_generated",@"url"]];
        [urls addObject:dict];
    }
    NSArray* image = @[@{@"url": self.uploadPhotoURI[0], @"user_generated": @"true"}];
    // Set image on the action
    [action setObject:image forKey:@"image"];
    
    // Link the object to the action
    [action setObject:object forKey:@"dish"];
    
    // Tag one or multiple users using the users' ids
    //[action setTags:@[<user-ids>]];
    
    // Tag a place using the place's id
//    id<FBGraphPlace> place = (id<FBGraphPlace>)[FBGraphObject graphObject];
//    [place setId:@"141887372509674"]; // Facebook Seattle
//    [action setPlace:place];
    
    // Dismiss the image picker off the screen
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
    params.action = action;
    params.actionType = @"xiaojiaoyi:eat";
    
    NSLog(@"before dialog");
    // If the Facebook app is installed and we can present the share dialog
    if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
        // Show the share dialog
        [FBDialogs presentShareDialogWithOpenGraphAction:action
                                              actionType:@"xiaojiaoyi:eat"
                                     previewPropertyName:@"dish"
                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                     if(error) {
                                                         // An error occurred, we need to handle the error
                                                         // See: https://developers.facebook.com/docs/ios/errors
                                                         NSLog(@"Error publishing story: %@", error.description);
                                                     } else {
                                                         // Success
                                                         NSLog(@"result %@", results);
                                                     }
                                                 }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.myNewDeal.title, @"name",
                                      [self.myNewDeal.price stringValue], @"caption",
                                       self.myNewDeal.describe, @"description",
                                       @"http://example.com/roasted_pumpkin_seeds", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
}

// A function for parsing URL parameters.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)postFBOpenGraphObject
{
    NSMutableArray* images= [[NSMutableArray alloc] init];
    for(int i=0;i<self.uploadPhotoURI.count;i++){
        [images addObject:@{@"url": self.uploadPhotoURI[i], @"user_generated" : @"true" }];
    }
    
    // Create an object
    NSMutableDictionary<FBOpenGraphObject> *restaurant = [FBGraphObject openGraphObjectForPost];
    
    // specify that this Open Graph object will be posted to Facebook
    restaurant.provisionedForPost = YES;
    
    // Add the standard object properties
    restaurant[@"og"] = @{ @"title":self.myNewDeal.title, @"type":@"restaurant.restaurant", @"description":self.myNewDeal.describe, @"image":images};
    
    // Add the properties restaurant inherits from place
    restaurant[@"place"] = @{ @"location" : @{ @"longitude": @"-58.381667", @"latitude":@"-34.603333"} };
    
    // Add the properties particular to the type restaurant.restaurant
    restaurant[@"restaurant"] = @{@"category": @[@"Mexican"],
                                  @"contact_info": @{@"street_address": @"123 Some st",
                                                     @"locality": @"Menlo Park",
                                                     @"region": @"CA",
                                                     @"phone_number": @"555-555-5555",
                                                     @"website": @"http://www.example.com"}};
    
    // Make the Graph API request to post the object
    FBRequest *request = [FBRequest requestForPostWithGraphPath:@"me/objects/restaurant.restaurant"
                                                    graphObject:@{@"object":restaurant}];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"result: %@", result);
            NSString* idString = [result objectForKey:@"id"];
            NSLog(@"object is uploaded: %@",idString);
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];

}
-(void)uploadPhotos
{
    if(self.uploadPhotoURI.count>0){
        [self.uploadPhotoURI removeAllObjects];
    }
    for(int i=0;i<self.photos.count;i++){
        UIImage* image = self.photos[i];
        [SessionManager uploadImage:image withCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error) {
                // Log the uri of the staged image
                NSString* uri =[result objectForKey:@"uri"];
                NSLog(@"Successfuly staged image with staged URI: %@", uri);
                [self.uploadPhotoURI addObject:uri];
                // Further code to post the OG story goes here
            } else {
                // An error occurred
                NSLog(@"Error staging an image: %@", error);
            }
            if(self.uploadPhotoURI.count==self.photos.count){
                //[self createFBGraphObject];
                [self postFBOpenGraphObject];
                
                //[self shareFBWithShareDialog];
            }
        }];
    }
    
}
-(void)getFBPermission
{
    [SessionManager requestPublicActionPermissionWithCompletionHandler:^(FBSession *session, NSError *error) {
        __block NSString *alertText;
        __block NSString *alertTitle;
        if (!error) {
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound){
                // Permission not granted, tell the user we will not publish
                alertTitle = @"Permission not granted";
                alertText = @"Your action will not be published to Facebook.";
                [[[UIAlertView alloc] initWithTitle:alertTitle
                                            message:alertText
                                           delegate:self
                                  cancelButtonTitle:@"OK!"
                                  otherButtonTitles:nil] show];
            } else {
                // Permission granted, publish the OG story
                NSLog(@"granted publish permission");
                [self uploadPhotos];
                // start publish using open graph
                
            }
            
        } else {
            NSLog(@"request publish_actions permission with error:%@",error);
            // There was an error, handle it
            // See https://developers.facebook.com/docs/ios/errors/
        }
        
    }];
}
-(void)fbButtonClicked:(UIButton*)sender
{
    
    UserObject* user = [UserObject currentUser];
    [self.uploadPhotoURI removeAllObjects];
    if(!user.fbLogin){
        [[[UIAlertView alloc] initWithTitle:nil message:@"Facebook account not logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    }
    else{
        [SessionManager checkFBPermissionsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error){
                NSDictionary *permissions= [(NSArray *)[result data] objectAtIndex:0];
                if(!permissions[@"publish_actions"]){
                    [self getFBPermission];
                }
                else{
                    [self uploadPhotos];
                }
//                for(NSString* k in permissions){
//                    NSLog(@"k:%@ value:%@",k,permissions[k]);
//                }
            }
            NSLog(@"done checking permissions!");
        }];
        nil;
    }
    //NSLog(@"fb button clicked");
    
}


//============Twitter methods================
-(void)uploadTWImagePath:(NSString*)path withStatus:(NSString*)status
{
    TWSession* session = [SessionManager twSession];
    NSLog(@"session is %@",session);
    //NSLog(@"url is %@",url);
    [session uploadWithImagePath:path AndStatus:status withCompletionHandler:^(NSString *idString, NSError *error) {
        if(idString){
            NSLog(@"twitter upload image and status succeeded");
        }
        else{
            NSLog(@"!!!Image upload failed");
        }
    }];
//    [session uploadWithImageURL:url AndStatus:status withCompletionHandler:^(NSString *idString, NSError *error) {
//        if(idString){
//            NSLog(@"twitter upload image and status succeeded");
//        }
//        else{
//            NSLog(@"!!!Image upload failed");
//        }
//    }];
}
-(void)twButtonClicked:(UIButton*)sender
{
    UserObject* user = [UserObject currentUser];
    if(!user.twLogin){
        [[[UIAlertView alloc] initWithTitle:nil message:@"You are not logged in with Twitter" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    }
    else{
        self.statusString = [[NSMutableString alloc] init];
        [self.statusString appendString:[NSString stringWithFormat:@"%@\r\n",self.myNewDeal.title]];
        [self.statusString appendString:[NSString stringWithFormat:@"%@\r\n",self.myNewDeal.describe]];
        [self.statusString appendString:[NSString stringWithFormat:@"price:%@\r\n",self.myNewDeal.price]];
        [self.statusString appendString:[NSString stringWithFormat:@"condition:%@\r\n",self.myNewDeal.condition]];
        [self.statusString appendString:[NSString stringWithFormat:self.myNewDeal.exchange?@"willing to exchange":@"do not accept exchange"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm"];
        [dateFormatter setDateFormat:@" MMM/dd/yyyy"];
        NSString* expireDate=[dateFormatter stringFromDate:self.myNewDeal.expire_date];
        
        [self.statusString appendString:[NSString stringWithFormat:@"\r\ngood until %@",expireDate]];
        [self performSegueWithIdentifier:@"TweetDealModalSegue" sender:self];
    }

    NSLog(@"tw button clicked");
}
-(void)tweetDealWithStatus:(NSString*)status
{
    
    NSString* urlString = nil;
    if([self.myNewDeal.photoURL[0] hasPrefix:@"file://"]){
        urlString = self.myNewDeal.photoURL[0];
    }
    else{
        urlString = [NSString stringWithFormat:@"file://%@",self.myNewDeal.photoURL[0]];
    }
    NSLog(@"photourl is %@",urlString);
    NSLog(@"photo url path is %@",[NSURL URLWithString:urlString]);
    //[self uploadTWImage:[NSURL URLWithString:self.myNewDeal.photoURL[0]] withStatus:status];
    [self uploadTWImagePath:self.myNewDeal.photoURL[0] withStatus:status];
}
-(IBAction)unwindFromTweetDialog:(UIStoryboardSegue *)segue
{
    if(self.shouldTweet){
        [self tweetDealWithStatus:self.tweetString];
        self.shouldTweet=NO;
    }
}
-(void)ggButtonClicked:(UIButton*)sender
{
    GPPSignIn* signIn = [GPPSignIn sharedInstance];
    if(signIn.authentication){
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        // The share preview, which includes the title, description, and a thumbnail,
        // is generated from the page at the specified URL location.
        //[shareBuilder setURLToShare:[NSURL URLWithString:@"https://www.example.com/restaurant/sf/1234567/"]];
        
        
        NSString* shipping = self.myNewDeal.shipping?@"provide shipping":@"exclude shipping";
        NSString* exchange = self.myNewDeal.exchange?@"willing to exchange":@"no exchange";
        NSString* dealDescription=[NSString stringWithFormat:@"new deal: %@\r\ndescription: %@\r\nprice: %@\r\ncondition: %@\r\nexpire on: %@\r\n%@\r\n%@\r\n",self.myNewDeal.title,self.myNewDeal.describe,self.myNewDeal.price,self.myNewDeal.condition,self.myNewDeal.expire_date,shipping,exchange];
        [shareBuilder setPrefillText:dealDescription];
        
        // This line passes the string "rest=1234567" to your native application
        // if somebody opens the link on a supported mobile device
        //[shareBuilder setContentDeepLinkID:@"rest=1234567"];
        
        // This method creates a call-to-action button with the label "RSVP".
        // - URL specifies where people will go if they click the button on a platform
        // that doesn't support deep linking.
        // - deepLinkID specifies the deep-link identifier that is passed to your native
        // application on platforms that do support deep linking
//        [shareBuilder setCallToActionButtonWithLabel:@"RSVP"
//                                                 URL:[NSURL URLWithString:@"https://www.example.com/reservation/4815162342/"]
//                                          deepLinkID:@"rsvp=4815162342"];
 
        NSString* filename = self.myNewDeal.photoURL[0];
        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
            [shareBuilder attachImage:[UIImage imageWithContentsOfFile:filename]];
            [shareBuilder open];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:nil message:@"there is no photo of the deal!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
        //this setTitle:description:thumbnailURL requires a content deep-link ID
        //[shareBuilder setTitle:self.myNewDeal.title description:self.myNewDeal.describe thumbnailURL:[NSURL URLWithString:filename]];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:nil message:@"You are not signed in with Google+" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    //NSLog(@"gg button clicked");
}
-(void)lkButtonClicked:(UIButton*)sender
{
    NSLog(@"lk button clicked");
}

-(void)shareCollectionViewTapped:(UITapGestureRecognizer*)gesture
{
    nil;
    
}
-(void)tapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"tapped");
    
    [UIView animateKeyframesWithDuration:0.2 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.shareCollectionView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, SHARE_COLLECTION_VIEW_HEIGHT);
        
    } completion:nil];
}
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
    [self.deleteAlertView show];
}
-(void)shareButtonClicked:(UIButton*)sender
{
    [UIView animateKeyframesWithDuration:0.2 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.shareCollectionView.frame = CGRectMake(0, self.view.frame.size.height - SHARE_COLLECTION_VIEW_HEIGHT, self.view.frame.size.width, SHARE_COLLECTION_VIEW_HEIGHT);
        
    } completion:nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSLog(@"0 clicked");
    }
    else if(buttonIndex==1){
        NSLog(@"1 clicked");
        self.cancelDeal=YES;
        [self performSegueWithIdentifier:@"DealSummaryUnwindSegue" sender:self];
        
    }
}

//------------prepare for segue---------------------
#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"DealSummaryUnwindSegue"]){
        if([segue.destinationViewController isKindOfClass:[DealDescriptionViewController class]]){
            DealDescriptionViewController* dealDescriptionVC=(DealDescriptionViewController*)segue.destinationViewController;
            dealDescriptionVC.cancelDeal=self.cancelDeal;
            
        }
    }
    else if([segue.identifier isEqualToString:@"TweetDealModalSegue"]){
        if([segue.destinationViewController isKindOfClass:[TweetDialogViewController class]]){
            TweetDialogViewController* tweetVC = (TweetDialogViewController*)segue.destinationViewController;
            tweetVC.placeholder=self.statusString;
            tweetVC.image=self.myNewDeal.photos[0];
        }
    }
}
#pragma mark - pageview methods
//------data source-----------------
-(DetailPageContentViewController*)contentViewAtIndex:(NSUInteger)index
{
    DetailPageContentViewController *contentVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailPageContentController"];
    //contentVC.contentImage = self.photoNames[index];
    contentVC.image=self.photos[index];
    //contentVC.contentTitle = self.myNewDeal.photoURL[index]; //self.photoTitles[index];
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
    if(idx == NSNotFound || idx == self.photos.count - 1)
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
