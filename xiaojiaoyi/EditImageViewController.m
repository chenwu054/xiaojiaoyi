//
//  EditImageViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/17/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "EditImageViewController.h"

#define BUTTON_HEIGHT 50
#define BUTTON_WIDTH 110
#define EDIT_MENU_HEIGHT 70

@interface EditImageViewController ()
typedef NS_ENUM(NSInteger, MenuType)
{
    MainMenu=1,
    ChopMenu=2,
    RotateMenu=3,
};

@property (nonatomic) UIView* mainEditMenuView;
@property (nonatomic) UIView* chopMenuView;
@property (nonatomic) UIView* rotateMenuView;

@property (nonatomic) UIButton* crossButton;
@property (nonatomic) UIButton* checkButton;
@property (nonatomic) UIButton* deleteButton;
@property (nonatomic) UIButton* chopButton;
@property (nonatomic) UIButton* rotateButton;
@property (nonatomic) UIButton* chopOriginScaleButton;
@property (nonatomic) UIButton* chopSquareScaleButton;
@property (nonatomic) UIButton* rotateCounterClockButton;
@property (nonatomic) UIButton* rotateClockButton;
@property (nonatomic) MenuType menuType;
@property (nonatomic) UIScrollView* scrollView;

@end


@implementation EditImageViewController

#pragma mark - button methods
-(void)crossButtonClicked:(UIButton*)sender
{
    if(_menuType==MainMenu){
        
    }
    else if(_menuType==ChopMenu){
        [UIView animateWithDuration:0.2 animations:^{
            self.mainEditMenuView.frame=CGRectMake(0, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            self.chopMenuView.frame=CGRectMake(self.view.frame.size.width,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            
        } completion:^(BOOL finished) {
            _menuType=MainMenu;
        }];
    }
    else if (_menuType==RotateMenu){
        [UIView animateWithDuration:0.2 animations:^{
            self.mainEditMenuView.frame=CGRectMake(0, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            self.rotateMenuView.frame=CGRectMake(self.view.frame.size.width,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            
        } completion:^(BOOL finished) {
            _menuType=MainMenu;
        }];
    }
}
-(void)checkButtonClicked:(UIButton*)sender
{
    
}
-(void)deleteButtonClicked:(UIButton*)sender
{
    
}
-(void)chopButtonClicked:(UIButton*)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainEditMenuView.frame=CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        self.chopMenuView.frame=CGRectMake(0,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        
    } completion:^(BOOL finished) {
        _menuType=ChopMenu;
    }];
    
}
-(void)chopOriginScaleButtonClicked:(UIButton*)sender
{
    
}
-(void)chopSquareScaleButtonClicked:(UIButton*)sender
{
    
}
-(void)rotateButtonClicked:(UIButton*)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainEditMenuView.frame=CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        self.rotateMenuView.frame=CGRectMake(0,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        
    } completion:^(BOOL finished) {
        _menuType=RotateMenu;
    }];
}
-(void)rotateClockButtonClicked:(UIButton*)sender
{
    
}
-(void)rotateCounterClockButtonClicked:(UIButton*)sender
{
    
}
#pragma mark - view setup
-(UIButton*)crossButton
{
    if(!_crossButton){
        _crossButton = [[UIButton alloc] init];
    }
    _crossButton.frame=CGRectMake(0,self.view.frame.size.height-BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT);
    _crossButton.backgroundColor=[UIColor whiteColor];
    [_crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    _crossButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_crossButton addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _crossButton;
}
-(UIButton*)checkButton
{
    if(!_checkButton){
        _checkButton = [[UIButton alloc] init];
        
    }
    _checkButton.frame=CGRectMake(self.view.frame.size.width-BUTTON_WIDTH, self.view.frame.size.height-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    _checkButton.backgroundColor=[UIColor whiteColor];
    [_checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    _checkButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _checkButton;
}
-(UIButton*)deleteButton
{
    if(!_deleteButton){
        _deleteButton =[[UIButton alloc] init];
    }
    _deleteButton.frame=CGRectMake(BUTTON_WIDTH, self.view.frame.size.height-BUTTON_HEIGHT, self.view.frame.size.width-(2*BUTTON_WIDTH), BUTTON_HEIGHT);
    _deleteButton.backgroundColor=[UIColor whiteColor];
    [_deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
    _deleteButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _deleteButton;
}
-(UIButton*)chopButton
{
    if(!_chopButton){
        _chopButton=[[UIButton alloc] init];
    }
    _chopButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_chopButton setImage:[UIImage imageNamed:@"chop.png"] forState:UIControlStateNormal];
    _chopButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_chopButton addTarget:self action:@selector(chopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _chopButton;
}
-(UIButton*)chopOriginScaleButton
{
    if(!_chopOriginScaleButton){
        _chopOriginScaleButton=[[UIButton alloc] init];
    }
    _chopOriginScaleButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_chopOriginScaleButton setImage:[UIImage imageNamed:@"scaling.png"] forState:UIControlStateNormal];
    _chopOriginScaleButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_chopOriginScaleButton addTarget:self action:@selector(chopOriginScaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _chopOriginScaleButton;
}
-(UIButton*)chopSquareScaleButton
{
    if(!_chopSquareScaleButton){
        _chopSquareScaleButton=[[UIButton alloc] init];
    }
    _chopSquareScaleButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_chopSquareScaleButton setImage:[UIImage imageNamed:@"square.png"] forState:UIControlStateNormal];
    _chopSquareScaleButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_chopSquareScaleButton addTarget:self action:@selector(chopSquareScaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return _chopSquareScaleButton;
}
-(UIButton*)rotateButton
{
    if(!_rotateButton){
        _rotateButton = [[UIButton alloc] init];
    }
    _rotateButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_rotateButton setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
    _rotateButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_rotateButton addTarget:self action:@selector(rotateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _rotateButton;
}
-(UIButton*)rotateClockButton
{
    if(!_rotateClockButton){
        _rotateClockButton=[[UIButton alloc] init];
    }
    _rotateClockButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_rotateClockButton setImage:[UIImage imageNamed:@"rotateClock.png"] forState:UIControlStateNormal];
    _rotateClockButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_rotateClockButton addTarget:self action:@selector(rotateClockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _rotateClockButton;
}
-(UIButton*)rotateCounterClockButton
{
    if(!_rotateCounterClockButton){
        _rotateCounterClockButton=[[UIButton alloc] init];
    }
    _rotateCounterClockButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
    [_rotateCounterClockButton setImage:[UIImage imageNamed:@"rotateCounterClock.png"] forState:UIControlStateNormal];
    _rotateCounterClockButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_rotateCounterClockButton addTarget:self action:@selector(rotateCounterClockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return _rotateCounterClockButton;
}

-(UIView*)mainEditMenuView
{
    if(!_mainEditMenuView){
        _mainEditMenuView = [[UIView alloc] init];
    }
    _mainEditMenuView.frame = CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT-EDIT_MENU_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
    _mainEditMenuView.backgroundColor = [UIColor lightGrayColor];
    [_mainEditMenuView addSubview:self.chopButton];
    [_mainEditMenuView addSubview:self.rotateButton];
    
    return _mainEditMenuView;
}
-(UIView*)chopMenuView
{
    if(!_chopMenuView){
        _chopMenuView = [[UIView alloc] init];
    }
    _chopMenuView.frame=CGRectMake(self.view.frame.size.width, self.view.frame.size.height-BUTTON_HEIGHT-EDIT_MENU_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
    _chopMenuView.backgroundColor=[UIColor lightGrayColor];
    [_chopMenuView addSubview:self.chopOriginScaleButton];
    [_chopMenuView addSubview:self.chopSquareScaleButton];
    return _chopMenuView;
}
-(UIView*)rotateMenuView
{
    if(!_rotateMenuView){
        _rotateMenuView=[[UIView alloc] init];
    }
    _rotateMenuView.frame=CGRectMake(self.view.frame.size.width, self.view.frame.size.height-EDIT_MENU_HEIGHT-BUTTON_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
    _rotateMenuView.backgroundColor=[UIColor lightGrayColor];
    [_rotateMenuView addSubview:self.rotateClockButton];
    [_rotateMenuView addSubview:self.rotateCounterClockButton];
    
    return _rotateMenuView;
}
-(UIScrollView*)scrollView
{
    if(!_scrollView){
        _scrollView=[[UIScrollView alloc] init];
    }
    _scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT));
    
    return _scrollView;
}

-(void)setup
{
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.crossButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.mainEditMenuView];
    [self.view addSubview:self.rotateMenuView];
    [self.view addSubview:self.chopMenuView];
    _menuType = MainMenu;
    
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
