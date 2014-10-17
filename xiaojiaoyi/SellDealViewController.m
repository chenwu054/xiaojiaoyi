//
//  SellDealViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/15/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "SellDealViewController.h"

#define BUTTON_HEIGHT 50
#define PREVIEW_MARGIN_HEIGHT 10
#define PREVIEW_MARGIN_WIDTH 8
#define PREVIEW_LENGTH 70

@interface SellDealViewController ()
@property (strong, nonatomic) IBOutlet UIView *photoPreviewParentView;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotonButton;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic) NSMutableArray *photos;

@end

@implementation SellDealViewController

//-(UIButton*)backButton
//{
//    if(!_backButton){
//        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    }
//    _backButton.backgroundColor = [UIColor grayColor];
//    _backButton.titleLabel.text =@"back";
//    [_backButton addTarget:self action:@selector(backToCenterView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backButton];
//    return _backButton;
//}
//-(void) backToCenterView
//{
//    [self performSegueWithIdentifier:@"SellDealBackSegue" sender:self];
//    
//}

-(NSMutableArray*)photos
{
    if(!_photos){
        _photos=[[NSMutableArray alloc] init];
        for(int i=0;i<4;i++){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(PREVIEW_MARGIN_WIDTH*(i+1)+i*PREVIEW_LENGTH, PREVIEW_MARGIN_HEIGHT, PREVIEW_LENGTH, PREVIEW_LENGTH)];
            button.backgroundColor=[UIColor whiteColor];
            [button setImage:[UIImage imageNamed:@"picture.png"] forState:UIControlStateNormal];
            [_photos addObject:button];
        }
    }
    return _photos;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is %ld",buttonIndex);
    if(buttonIndex==0)
        return;
    //[self performSegueWithIdentifier:@"SellDealBackSegue" sender:self];
}
-(void)crossButtonClicked
{
    [[[UIAlertView alloc] initWithTitle:@"Cancel the deal?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
     
}
-(void)takePhotoButtonClicked
{
    _checkButton.enabled=YES;
}
-(void)checkButtonClicked
{
    NSLog(@"check button clicked");
    [self performSegueWithIdentifier:@"DealIntroSegue" sender:self];
    
}
-(void)setup
{
    if(!_crossButton){
        _crossButton = [[UIButton alloc] init];
    }
    _crossButton.frame=CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT, 95, BUTTON_HEIGHT);
    [_crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    _crossButton.imageView.contentMode =UIViewContentModeScaleAspectFit;
    _crossButton.tintColor = [UIColor redColor];
    [_crossButton addTarget:self action:@selector(crossButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(!_takePhotonButton){
        _takePhotonButton=[[UIButton alloc] init];
    }
    _takePhotonButton.frame=CGRectMake(95, self.view.frame.size.height-BUTTON_HEIGHT, 130, BUTTON_HEIGHT);
    [_takePhotonButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    _takePhotonButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_takePhotonButton addTarget:self action:@selector(takePhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if(!_checkButton){
        _checkButton = [[UIButton alloc] init];
    }
    [_checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    _checkButton.frame=CGRectMake(95+130, self.view.frame.size.height-BUTTON_HEIGHT, 95, BUTTON_HEIGHT);
    _checkButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_checkButton addTarget:self action:@selector(checkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _checkButton.enabled = NO;
    
    if(!_photoPreviewParentView){
        _photoPreviewParentView = [[UIView alloc] init];
    }
    _photoPreviewParentView.frame = CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT-(PREVIEW_MARGIN_HEIGHT*2+PREVIEW_LENGTH), self.view.frame.size.width, (PREVIEW_MARGIN_HEIGHT*2+PREVIEW_LENGTH));
    _photoPreviewParentView.backgroundColor= [UIColor lightGrayColor];
    NSMutableArray *arr = self.photos;
    for(int i=0;i<arr.count;i++){
        [_photoPreviewParentView addSubview:arr[i]];
    }
    _photoPreviewParentView.backgroundColor = [UIColor grayColor];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    //[self backButton];
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
