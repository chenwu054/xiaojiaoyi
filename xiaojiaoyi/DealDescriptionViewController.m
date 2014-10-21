//
//  DealDescriptionViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DealDescriptionViewController.h"

#define BUTTON_HEIGHT 50
#define VIEW_HEIGHT 50
#define VIEW_HEIGHT_MARGIN 10
#define DESCRIPTION_HEIGHT 50
#define VIEW_WIDTH_MARGIN 10
#define VIEW_CORNER_RADIUS 10.0
#define LABEL_WIDTH 100
#define TITLE_FIELD_MAX_CHAR 40
#define TEXT_FIELD_MARGIN 5
#define PRICE_UNIT_TEXT_LENGTH 70
#define PICKER_BUTTON_WIDTH 60
#define PICKER_BUTTON_MARGIN 12
#define SWITCH_WIDTH 80

#define NAME_LABEL_TEXT @"Deal Name"
#define PRICE_LABEL_TEXT @"Asking Price"
#define SHIPPING_LABEL_TEXT @"Need Shipping"
#define EXCHANGE_LABEL_TEXT @"Accept Exchange"


@interface DealDescriptionViewController ()
@property (nonatomic) UIView* controlView;
@property (nonatomic) UIImage* backgroundImage;
@property (nonatomic) UIView* titleView;
@property (nonatomic) UIView* priceView;
@property (nonatomic) UIView* conditionView;
@property (nonatomic) UIView* expiryView;
@property (nonatomic) UIView* shippingView;
@property (nonatomic) UIView* exchangeView;
@property (nonatomic) UIView* descriptionView;
@property (nonatomic) NSString* title;
@property (nonatomic) NSInteger price;
@property (nonatomic) UIButton* crossButton;
@property (nonatomic) UIButton* checkButton;
@property (nonatomic) UILabel* nameLabel;
@property (nonatomic) UITextField* nameTextField;
@property (nonatomic) UILabel* priceLabel;
@property (nonatomic) UITextField* priceTextField;
@property (nonatomic) UILabel* priceUnitLabel;

@property (nonatomic) UIView* conditionPickerView;
@property (nonatomic) UIButton* conditionLessEightyButton;
@property (nonatomic) UIButton* conditionEightyButton;
@property (nonatomic) UIButton* conditionNinetyButton;
@property (nonatomic) UIButton* conditionNewButton;
@property (nonatomic) UILabel* conditionTitleLabel;
@property (nonatomic) UILabel* conditionStateLabel;

@property (nonatomic) UIView* expiryPickerView;
@property (nonatomic) UIButton* expiryThreeDayButton;
@property (nonatomic) UIButton* expirySevenDayButton;
@property (nonatomic) UIButton* expiryFifteenDayButton;
@property (nonatomic) UIButton* expiryThirtyDayButton;
@property (nonatomic) UILabel* expiryTitleLabel;
@property (nonatomic) UILabel* expiryDayLabel;

@property (nonatomic) NSInteger conditionPicked;
@property (nonatomic) NSInteger expiryPicked;

@property (nonatomic) UILabel* shippingLabel;
@property (nonatomic) UILabel* exchangeLabel;

@property (nonatomic) UISwitch* shippingSwitch;
@property (nonatomic) UISwitch* acceptExchangeSwitch;

@end

@implementation DealDescriptionViewController
static NSString* numbers=@"0123456789";

-(void)resetControlView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSInteger height= 6*VIEW_HEIGHT+7*VIEW_HEIGHT_MARGIN +BUTTON_HEIGHT + DESCRIPTION_HEIGHT;
        self.controlView.frame=CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width,  6*VIEW_HEIGHT+7*VIEW_HEIGHT_MARGIN +BUTTON_HEIGHT);
    } completion:nil];
}
-(void)controlPan:(UIPanGestureRecognizer*)gesture
{
    CGPoint transition=[gesture translationInView:self.view];
    //NSLog(@"transition in view is %f,%f",transition.x,transition.y);
    if(transition.y<0)
        return;
    if(gesture.state==UIGestureRecognizerStateChanged){
        self.controlView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-BUTTON_HEIGHT-self.controlView.frame.size.height/2+transition.y/2);
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        [self resetControlView];
    }
}
-(void)backgroundTap:(UITapGestureRecognizer*)gesture
{
    if([self.nameTextField isFirstResponder]){
        [self.nameTextField resignFirstResponder];
    }
    else if([self.priceTextField isFirstResponder]){
        [self.priceTextField resignFirstResponder];
    }
    
}
-(void)conditionViewTap:(UIGestureRecognizer*)gesture
{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.conditionView.frame=CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*2+3*VIEW_HEIGHT_MARGIN,0, VIEW_HEIGHT);
    } completion:nil];
    
}
-(void)expiryViewTap:(UIGestureRecognizer*)gesture
{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.expiryView.frame=CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*3+4*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, 0);
    } completion:nil];
    
}
-(void)conditionButtonClicked:(UIButton*)sender
{
    switch (self.conditionPicked) {
        case 0:
            [self.conditionLessEightyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.conditionLessEightyButton.backgroundColor=[UIColor clearColor];
            break;
        case 1:
            [self.conditionEightyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.conditionEightyButton.backgroundColor=[UIColor clearColor];
            break;
        case 2:
            [self.conditionNinetyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.conditionNinetyButton.backgroundColor=[UIColor clearColor];
            break;
        case 3:
            [self.conditionNewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.conditionNewButton.backgroundColor=[UIColor clearColor];
            break;
        default:
            NSLog(@"!!!ERROR:condition button picked wrong");
            break;
    }
    
    if(sender==self.conditionLessEightyButton){
        [self.conditionLessEightyButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.conditionLessEightyButton.backgroundColor=[UIColor blueColor];
        self.conditionPicked=0;
        self.conditionStateLabel.text=@"<80%";
    }
    else if(sender==self.conditionEightyButton){
        [self.conditionEightyButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.conditionEightyButton.backgroundColor=[UIColor blueColor];
        self.conditionPicked=1;
        self.conditionStateLabel.text=@"80%";
    }
    else if(sender==self.conditionNinetyButton){
        [self.conditionNinetyButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.conditionNinetyButton.backgroundColor=[UIColor blueColor];
        self.conditionPicked=2;
        self.conditionStateLabel.text=@"90%";
    }
    else if(sender==self.conditionNewButton){
        [self.conditionNewButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.conditionNewButton.backgroundColor=[UIColor blueColor];
        self.conditionPicked=3;
        self.conditionStateLabel.text=@"new";
    }
    else{
        NSLog(@"!!!ERROR: condition button clicked wrong");
    }
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.conditionView.frame=CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*2+3*VIEW_HEIGHT_MARGIN,self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT);
        self.conditionTitleLabel.frame=CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3);
        self.conditionStateLabel.frame=CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-LABEL_WIDTH, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3);
    } completion:nil];
    //update condition view 's date
}

-(void)expiryButtonClicked:(UIButton*)sender
{
    switch (self.expiryPicked) {
        case 0:
            [self.expiryThreeDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.expiryThreeDayButton.backgroundColor=[UIColor clearColor];
            break;
        case 1:
            [self.expirySevenDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.expirySevenDayButton.backgroundColor=[UIColor clearColor];
            break;
        case 2:
            [self.expiryFifteenDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.expiryFifteenDayButton.backgroundColor=[UIColor clearColor];
            break;
        case 3:
            [self.expiryThirtyDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.expiryThirtyDayButton.backgroundColor=[UIColor clearColor];
            break;
        default:
            NSLog(@"!!!ERROR: expiry button picked wrong");
            break;
    }
    
    if(sender==self.expiryThreeDayButton){
        [self.expiryThreeDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.expiryThreeDayButton.backgroundColor=[UIColor blueColor];
        self.expiryPicked=0;
        self.expiryDayLabel.text=@"3days";
    }
    else if(sender==self.expirySevenDayButton){
        [self.expirySevenDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.expirySevenDayButton.backgroundColor=[UIColor blueColor];
        self.expiryPicked=1;
        self.expiryDayLabel.text=@"7days";
    }
    else if(sender==self.expiryFifteenDayButton){
        [self.expiryFifteenDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.expiryFifteenDayButton.backgroundColor=[UIColor blueColor];
        self.expiryPicked=2;
        self.expiryDayLabel.text=@"15days";
    }
    else if(sender==self.expiryThirtyDayButton){
        [self.expiryThirtyDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.expiryThirtyDayButton.backgroundColor=[UIColor blueColor];
        self.expiryPicked=3;
        self.expiryDayLabel.text=@"30days";
    }
    else{
        NSLog(@"!!!ERROR: condition button clicked wrong");
    }
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.expiryView.frame=CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*3+4*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT);
        self.expiryTitleLabel.frame=CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3);
        self.expiryDayLabel.frame=CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-LABEL_WIDTH, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3);
    } completion:nil];
    //update condition view 's date
    
}

#pragma mark - setup

-(UIView*)controlView
{
    if(!_controlView){
        _controlView=[[UIView alloc] init];
        NSInteger height= 6*VIEW_HEIGHT+7*VIEW_HEIGHT_MARGIN +BUTTON_HEIGHT + DESCRIPTION_HEIGHT;
        _controlView.frame=CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width,  6*VIEW_HEIGHT+7*VIEW_HEIGHT_MARGIN +BUTTON_HEIGHT);
        UIPanGestureRecognizer* controlPan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(controlPan:)];
        [_controlView addGestureRecognizer:controlPan];
        _controlView.backgroundColor=[UIColor blackColor];
    }
    return _controlView;
}
-(UIImage*)backgroundImage
{
    if(!_backgroundImage){
        _backgroundImage=[UIImage imageNamed:@"linkedin.jpg"];
    }
    return _backgroundImage;
}
-(UIButton*)crossButton
{
    if(!_crossButton){
        _crossButton=[[UIButton alloc] init];
    }
    _crossButton.frame=CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT, self.view.frame.size.width/2, BUTTON_HEIGHT);
    [_crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    _crossButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _crossButton.backgroundColor=[UIColor whiteColor];
    return _crossButton;
}
-(UIButton*)checkButton
{
    if(!_checkButton){
        _checkButton=[[UIButton alloc] init];
    }
    _checkButton.frame=CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-BUTTON_HEIGHT, self.view.frame.size.width/2, BUTTON_HEIGHT);
    [_checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    _checkButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _checkButton.backgroundColor=[UIColor whiteColor];
    return _checkButton;

}
-(UIView*)titleView
{
    if(!_titleView){
        _titleView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _titleView.backgroundColor=[UIColor blueColor];
        _titleView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        _titleView.layer.borderColor= [[UIColor whiteColor] CGColor];
        _titleView.layer.borderWidth=1.0;
    }
    return _titleView;
}
-(UIView*)priceView
{
    if(!_priceView){
        _priceView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT_MARGIN*2+VIEW_HEIGHT, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _priceView.backgroundColor=[UIColor blueColor];
        _priceView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        _titleView.layer.borderColor= [[UIColor whiteColor] CGColor];
        _titleView.layer.borderWidth=1.0;
    }
    return _priceView;
}
-(UIView*)conditionView
{
    if(!_conditionView){
        _conditionView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*2+3*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _conditionView.backgroundColor=[UIColor whiteColor];
        _conditionView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(conditionViewTap:)];
        [_conditionView addGestureRecognizer:tapGesture];
        [_conditionView addSubview:self.conditionTitleLabel];
        [_conditionView addSubview:self.conditionStateLabel];
        _conditionView.backgroundColor=[UIColor yellowColor];
        _conditionView.autoresizesSubviews=YES;
    }
    return _conditionView;
}
- (UILabel*) conditionTitleLabel
{
    if(!_conditionTitleLabel){
        _conditionTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _conditionTitleLabel.text=@"Condition";
        _conditionTitleLabel.textColor=[UIColor grayColor];
        _conditionTitleLabel.textAlignment=NSTextAlignmentRight;
        _conditionTitleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _conditionTitleLabel;
}

-(UILabel*)conditionStateLabel
{
    if(!_conditionStateLabel){
        _conditionStateLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-LABEL_WIDTH, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _conditionStateLabel.text=@"new";
        _conditionStateLabel.textColor=[UIColor grayColor];
        _conditionStateLabel.textAlignment=NSTextAlignmentLeft;
        _conditionStateLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _conditionStateLabel;
}
-(UIView*)expiryView
{
    if(!_expiryView){
        _expiryView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*3+4*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _expiryView.backgroundColor=[UIColor whiteColor];
        _expiryView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expiryViewTap:)];
        [_expiryView addGestureRecognizer:tapGesture];
        [_expiryView addSubview:self.expiryTitleLabel];
        [_expiryView addSubview:self.expiryDayLabel];
        _expiryView.backgroundColor=[UIColor yellowColor];
        _expiryView.autoresizesSubviews=YES;
    }
    
    return _expiryView;
}
-(UILabel*)expiryTitleLabel
{
    if(!_expiryTitleLabel){
        _expiryTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _expiryTitleLabel.text=@"Expire In";
        _expiryTitleLabel.textColor=[UIColor grayColor];
        _expiryTitleLabel.textAlignment=NSTextAlignmentRight;
        _expiryTitleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _expiryTitleLabel;
}
-(UILabel*)expiryDayLabel
{
    if(!_expiryDayLabel){
        _expiryDayLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-LABEL_WIDTH, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _expiryDayLabel.text=@"30days";
        _expiryDayLabel.textColor=[UIColor grayColor];
        _expiryDayLabel.textAlignment=NSTextAlignmentLeft;
        _expiryDayLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _expiryDayLabel;
}
-(UIView*)descriptionView
{
    if(!_descriptionView){
        _descriptionView=[[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT*6+7*VIEW_HEIGHT_MARGIN, self.view.frame.size.width, DESCRIPTION_HEIGHT)];
        _descriptionView.backgroundColor=[UIColor lightGrayColor];
        _descriptionView.layer.cornerRadius=0;
    }
    return _descriptionView;
}
-(UILabel*)nameLabel
{
    if(!_nameLabel){
        _nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _nameLabel.text=NAME_LABEL_TEXT;
        _nameLabel.textColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont fontWithName:@"Arial" size:15.0f];
        _nameLabel.textAlignment=NSTextAlignmentRight;
    }
    return _nameLabel;
}
-(UITextField*)nameTextField
{
    if(!_nameTextField){
        _nameTextField=[[UITextField alloc] initWithFrame:CGRectMake(LABEL_WIDTH + TEXT_FIELD_MARGIN, VIEW_HEIGHT/5, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN - LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _nameTextField.delegate=self;
        NSAttributedString* placeholder = [[NSAttributedString alloc] initWithString:@"e.g. iPhone6 plus(max 50)" attributes:@{NSFontAttributeName:@"Arial", @"size":@"15",NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _nameTextField.attributedPlaceholder=placeholder;
        _nameTextField.textColor=[UIColor whiteColor];
        _nameTextField.font=[UIFont fontWithName:@"Arial" size:15.f];
        
    }
    return _nameTextField;
}
-(UILabel*)priceLabel
{
    if(!_priceLabel){
        _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _priceLabel.text=PRICE_LABEL_TEXT;
        _priceLabel.textColor=[UIColor whiteColor];
        _priceLabel.font=[UIFont fontWithName:@"Arial" size:15.0f];
        _priceLabel.textAlignment=NSTextAlignmentRight;
    }
    return _priceLabel;
}
-(UILabel*)priceUnitLabel
{
    if(!_priceUnitLabel){
        _priceUnitLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-PRICE_UNIT_TEXT_LENGTH+10, VIEW_HEIGHT/5, PRICE_UNIT_TEXT_LENGTH, VIEW_HEIGHT/5*3)];
        _priceUnitLabel.text=@"dollars";
        _priceUnitLabel.textColor=[UIColor whiteColor];
        _priceUnitLabel.font=[UIFont fontWithName:@"Arial" size:15.0f];
        //_priceUnitLabel.textAlignment=NSTextAlignmentRight;
    }
    return _priceUnitLabel;
}
-(UITextField*)priceTextField
{
    if(!_priceTextField){
        _priceTextField=[[UITextField alloc] initWithFrame:CGRectMake(LABEL_WIDTH + TEXT_FIELD_MARGIN, VIEW_HEIGHT/5, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN - LABEL_WIDTH-PRICE_UNIT_TEXT_LENGTH, VIEW_HEIGHT/5*3)];
        _priceTextField.delegate=self;
        NSAttributedString* placeholder = [[NSAttributedString alloc] initWithString:@"e.g. 100" attributes:@{NSFontAttributeName:@"Arial", @"size":@"15",NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _priceTextField.attributedPlaceholder=placeholder;
        _priceTextField.textColor=[UIColor whiteColor];
        _priceTextField.font=[UIFont fontWithName:@"Arial" size:15.f];
        _priceTextField.textAlignment=NSTextAlignmentRight;
    }
    return _priceTextField;
}
-(UIView*) conditionPickerView
{
    if(!_conditionPickerView){
        _conditionPickerView =[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*2+3*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _conditionPickerView.backgroundColor=[UIColor whiteColor];
        _conditionPickerView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        self.conditionPicked=3;
        [_conditionPickerView addSubview:self.conditionLessEightyButton];
        [_conditionPickerView addSubview:self.conditionEightyButton];
        [_conditionPickerView addSubview:self.conditionNinetyButton];
        [_conditionPickerView addSubview:self.conditionNewButton];
    }
    return _conditionPickerView;
}
-(UIButton*)conditionLessEightyButton
{
    if(!_conditionLessEightyButton){
        _conditionLessEightyButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_conditionLessEightyButton setTitle:@"<80%" forState:UIControlStateNormal];
        [_conditionLessEightyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //_conditionLessEightyButton.backgroundColor=[UIColor whiteColor];
        //_conditionLessEightyButton.tintColor=[UIColor blueColor];
        _conditionLessEightyButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _conditionLessEightyButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_conditionLessEightyButton addTarget:self action:@selector(conditionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionLessEightyButton;
}
-(UIButton*)conditionEightyButton
{
    if(!_conditionEightyButton){
        _conditionEightyButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN, VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_conditionEightyButton setTitle:@"80%" forState:UIControlStateNormal];
        [_conditionEightyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //_conditionEightyButton.backgroundColor=[UIColor whiteColor];
        //_conditionEightyButton.tintColor=[UIColor grayColor];
        _conditionEightyButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _conditionEightyButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_conditionEightyButton addTarget:self action:@selector(conditionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionEightyButton;
}
-(UIButton*)conditionNinetyButton
{
    if(!_conditionNinetyButton){
        _conditionNinetyButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+2*(PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN), VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_conditionNinetyButton setTitle:@"90%" forState:UIControlStateNormal];
        [_conditionNinetyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //_conditionNinetyButton.backgroundColor=[UIColor whiteColor];
        //_conditionNinetyButton.tintColor=[UIColor grayColor];
        _conditionNinetyButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _conditionNinetyButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_conditionNinetyButton addTarget:self action:@selector(conditionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionNinetyButton;
}
-(UIButton*)conditionNewButton
{
    if(!_conditionNewButton){
        _conditionNewButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+3*(PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN), VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_conditionNewButton setTitle:@"new" forState:UIControlStateNormal];
        [_conditionNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _conditionNewButton.backgroundColor=[UIColor blueColor];
        //_conditionNewButton.tintColor=[UIColor whiteColor];
        _conditionNewButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _conditionNewButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_conditionNewButton addTarget:self action:@selector(conditionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionNewButton;
}


-(UIView*)expiryPickerView
{
    if(!_expiryPickerView){
        _expiryPickerView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*3+4*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _expiryPickerView.backgroundColor=[UIColor whiteColor];
        _expiryPickerView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        self.expiryPicked=3;
        [_expiryPickerView addSubview:self.expiryThreeDayButton];
        [_expiryPickerView addSubview:self.expirySevenDayButton];
        [_expiryPickerView addSubview:self.expiryFifteenDayButton];
        [_expiryPickerView addSubview:self.expiryThirtyDayButton];
    }
    return _expiryPickerView;
}
-(UIButton*)expiryThreeDayButton
{
    if(!_expiryThreeDayButton){
        _expiryThreeDayButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_expiryThreeDayButton setTitle:@"3days" forState:UIControlStateNormal];
        [_expiryThreeDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _expiryThreeDayButton.backgroundColor=[UIColor whiteColor];
        _expiryThreeDayButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _expiryThreeDayButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_expiryThreeDayButton addTarget:self action:@selector(expiryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expiryThreeDayButton;
}
-(UIButton*)expirySevenDayButton
{
    if(!_expirySevenDayButton){
        _expirySevenDayButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN, VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_expirySevenDayButton setTitle:@"7days" forState:UIControlStateNormal];
        [_expirySevenDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _expirySevenDayButton.backgroundColor=[UIColor whiteColor];
        _expirySevenDayButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _expirySevenDayButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_expirySevenDayButton addTarget:self action:@selector(expiryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expirySevenDayButton;
}
-(UIButton*)expiryFifteenDayButton
{
    if(!_expiryFifteenDayButton){
        _expiryFifteenDayButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+2*(PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN), VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_expiryFifteenDayButton setTitle:@"15days" forState:UIControlStateNormal];
        [_expiryFifteenDayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _expiryFifteenDayButton.backgroundColor=[UIColor whiteColor];
        _expiryFifteenDayButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _expiryFifteenDayButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_expiryFifteenDayButton addTarget:self action:@selector(expiryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expiryFifteenDayButton;
}

-(UIButton*)expiryThirtyDayButton
{
    if(!_expiryThirtyDayButton){
        _expiryThirtyDayButton=[[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN+3*(PICKER_BUTTON_WIDTH+PICKER_BUTTON_MARGIN), VIEW_HEIGHT/5, PICKER_BUTTON_WIDTH, VIEW_HEIGHT/5*3)];
        [_expiryThirtyDayButton setTitle:@"30days" forState:UIControlStateNormal];
        [_expiryThirtyDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _expiryThirtyDayButton.backgroundColor=[UIColor blueColor];
        _expiryThirtyDayButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _expiryThirtyDayButton.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_expiryThirtyDayButton addTarget:self action:@selector(expiryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expiryThirtyDayButton;
}

-(UIView*)shippingView
{
    if(!_shippingView){
        _shippingView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*4+5*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _shippingView.backgroundColor=[UIColor whiteColor];
        _shippingView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_shippingView addSubview:self.shippingSwitch];
        [_shippingView addSubview:self.shippingLabel];
    }
    return _shippingView;
}
-(UISwitch*)shippingSwitch
{
    if(!_shippingSwitch){
        _shippingSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-SWITCH_WIDTH-VIEW_WIDTH_MARGIN, VIEW_HEIGHT/5, SWITCH_WIDTH, VIEW_HEIGHT/5*3)];
    }
    return _shippingSwitch;
}
-(UILabel*)shippingLabel
{
    if(!_shippingLabel){
        _shippingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _shippingLabel.text=SHIPPING_LABEL_TEXT;
        _shippingLabel.textAlignment=NSTextAlignmentRight;
        
    }
    return _shippingLabel;
}

-(UIView*)exchangeView
{
    if(!_exchangeView){
        _exchangeView=[[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH_MARGIN, VIEW_HEIGHT*5+6*VIEW_HEIGHT_MARGIN, self.view.frame.size.width-2*VIEW_WIDTH_MARGIN, VIEW_HEIGHT)];
        _exchangeView.backgroundColor=[UIColor whiteColor];
        _exchangeView.layer.cornerRadius=VIEW_CORNER_RADIUS;
        [_exchangeView addSubview:self.exchangeLabel];
        [_exchangeView addSubview:self.acceptExchangeSwitch];
    }
    return _exchangeView;
}
-(UILabel*)exchangeLabel
{
    if(!_exchangeLabel){
        _exchangeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT/5, LABEL_WIDTH, VIEW_HEIGHT/5*3)];
        _exchangeLabel.text=EXCHANGE_LABEL_TEXT;
        _exchangeLabel.textAlignment=NSTextAlignmentRight;
        
    }
    return _exchangeLabel;
}
-(UISwitch*)acceptExchangeSwitch
{
    if(!_acceptExchangeSwitch){
        _acceptExchangeSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2*VIEW_WIDTH_MARGIN-SWITCH_WIDTH-VIEW_WIDTH_MARGIN, VIEW_HEIGHT/5, SWITCH_WIDTH, VIEW_HEIGHT/5*3)];
    }
    return _acceptExchangeSwitch;
}

#pragma mark - delegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(textField==self.nameTextField){
        //NSLog(@"range is %ld,%ld,%@",range.location,range.length,string);
        return (newLength > TITLE_FIELD_MAX_CHAR) ? NO : YES;
    }
    else if(textField == self.priceTextField){
        if(newLength>5)
            return NO;
        if(string.length==0)
            return YES;
        if([numbers rangeOfString:string].location==NSNotFound)
            return NO;
        //TODO: check does not start with "0"!
        return YES;
    }
    
    return YES;
}
-(void) setup
{
    UIPanGestureRecognizer* panMainView=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(controlPan:)];
    [self.view addGestureRecognizer:panMainView];
    UITapGestureRecognizer* tapMainView=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapMainView];
    UIImageView* imageView=[[UIImageView alloc] initWithImage:self.backgroundImage];
    imageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    imageView.image=self.backgroundImage;
    [self.view addSubview:imageView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.crossButton];
    [self.view addSubview:self.checkButton];
    [self.controlView addSubview:self.titleView];
    [self.controlView addSubview:self.priceView];
    
    [self.controlView addSubview:self.shippingView];
    [self.controlView addSubview:self.exchangeView];
    [self.controlView addSubview:self.descriptionView];
    [self.titleView addSubview:self.nameLabel];
    [self.titleView addSubview:self.nameTextField];
    [self.priceView addSubview:self.priceLabel];
    [self.priceView addSubview:self.priceTextField];
    [self.priceView addSubview:self.priceUnitLabel];
    
    [self.controlView addSubview:self.conditionPickerView];
    [self.controlView addSubview:self.conditionView];
    [self.controlView addSubview:self.expiryPickerView];
    [self.controlView addSubview:self.expiryView];
    
    //[self.shippingView addSubview:self.shippingLabel];
    //[self.exchangeView addSubview:self.exchangeLabel];
    
    
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
