//
//  DealIntroController.m
//  xiaojiaoyi
//
//  Created by chen on 10/16/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealIntroController.h"
#define CONTROL_VIEW_HEIGHT 70
#define BUTTON_HEIGHT_MARGIN 10
#define LABEL_HEIGHT 50
#define BACK_BUTTON_WIDTH 50
#define SWITCH_BUTTON_WIDTH 70

@interface DealIntroController ()

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIView* controlView;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) IBOutlet UILabel* label;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton* recordButton;
@property (nonatomic) UIButton* switchButton;
@property (nonatomic) UITextField* textField;

@end

@implementation DealIntroController

-(void)tapMainView:(UITapGestureRecognizer*)gesture
{
    NSLog(@"main view tapped");
}
#pragma mark - setup
-(UIView*)mainView
{
    if(!_mainView){
        _mainView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-CONTROL_VIEW_HEIGHT)];
        UITapGestureRecognizer *mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainView:)];
        [_mainView addGestureRecognizer:mainTap];
        
    }
    return _mainView;
}
-(UIView*)controlView
{
    if(!_controlView){
        _controlView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-CONTROL_VIEW_HEIGHT, self.view.frame.size.width, CONTROL_VIEW_HEIGHT)];
        _controlView.backgroundColor=[UIColor whiteColor];
    }
    return _controlView;
}
-(UIImageView*)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
-(UILabel*)label
{
    if(!_label){
        _label=[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-(LABEL_HEIGHT+CONTROL_VIEW_HEIGHT), self.view.frame.size.width, LABEL_HEIGHT)];
        _label.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        _label.textColor=[UIColor whiteColor];
    }
    return _label;
}
-(UIButton*)backButton
{
    if(!_backButton){
        _backButton=[[UIButton alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT_MARGIN, BACK_BUTTON_WIDTH, CONTROL_VIEW_HEIGHT-2*BUTTON_HEIGHT_MARGIN)];
        [_backButton setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
        _switchButton.contentMode=UIViewContentModeScaleAspectFit;
        [_backButton setTintColor:[UIColor blueColor]];
    }
    return _backButton;
}
-(UIButton*)recordButton
{
    if(!_recordButton){
        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(BACK_BUTTON_WIDTH, BUTTON_HEIGHT_MARGIN, self.view.frame.size.width-(BACK_BUTTON_WIDTH+SWITCH_BUTTON_WIDTH), CONTROL_VIEW_HEIGHT-2*(BUTTON_HEIGHT_MARGIN))];
        _recordButton.layer.cornerRadius = 5.0f;
        _recordButton.backgroundColor=[UIColor blueColor];
        _recordButton.tintColor = [UIColor whiteColor];
        _recordButton.titleLabel.text=@"press down to record description";
    }
    return _recordButton;
}
-(UIButton*)switchButton
{
    if(!_switchButton){
        _switchButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-SWITCH_BUTTON_WIDTH, BUTTON_HEIGHT_MARGIN, SWITCH_BUTTON_WIDTH, CONTROL_VIEW_HEIGHT-2*BUTTON_HEIGHT_MARGIN)];
        [_switchButton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        _switchButton.contentMode=UIViewContentModeScaleAspectFit;
        _switchButton.layer.cornerRadius = 5.0f;
    }
    
    return _switchButton;
}
-(UITextField*)textField
{
    if(!_textField){
        _textField=[[UITextField alloc] initWithFrame:CGRectMake(BACK_BUTTON_WIDTH, 0, self.view.frame.size.width-(SWITCH_BUTTON_WIDTH+BACK_BUTTON_WIDTH), CONTROL_VIEW_HEIGHT)];
    }
    return _textField;
}

-(void)setup
{
    self.imageView.image=self.image;
    [self.mainView addSubview:self.imageView];
    self.label.text=@"Talk about the purchase time, brand, make, features, etc. The more details, the faster to sell.";
    [self.mainView addSubview:self.label];
    [self.view addSubview:self.mainView];
    [self.controlView addSubview:self.backButton];
    [self.controlView addSubview:self.switchButton];
    [self.controlView addSubview:self.recordButton];
    [self.view addSubview:self.controlView];
    

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
