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
@property (nonatomic) UIImagePickerController *imagePickerController;


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


#pragma mark - setup
-(UIImagePickerController*) imagePickerController
{
    if(!_imagePickerController){
        _imagePickerController = [[UIImagePickerController alloc] init];
    }
    _imagePickerController.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        _imagePickerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(PREVIEW_LENGTH+2*PREVIEW_MARGIN_HEIGHT+BUTTON_HEIGHT));
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.view addSubview:_imagePickerController.view];
        //have to manually call these two lifecycle methods to add initiate the picker view.
        [_imagePickerController viewWillAppear:YES];
        [_imagePickerController viewDidAppear:YES];
        
        NSLog(@"camera is available");
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        _imagePickerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(PREVIEW_LENGTH+2*PREVIEW_MARGIN_HEIGHT+BUTTON_HEIGHT));
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSLog(@"library is available");
    }
    else{
        NSLog(@"!!!ERROR: neither camera nor ");
    }
    
    return _imagePickerController;
}

-(NSMutableArray*)buttons
{
    
    if(!_buttons){
        _buttons=[[NSMutableArray alloc] init];
    }
    for(int i=0;i<4;i++){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(PREVIEW_MARGIN_WIDTH*(i+1)+i*PREVIEW_LENGTH, PREVIEW_MARGIN_HEIGHT, PREVIEW_LENGTH, PREVIEW_LENGTH)];
        button.backgroundColor=[UIColor whiteColor];
        UIImage*image = [UIImage imageNamed:@"picture.png"];
        [self.photos addObject:image];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
    }
    return _buttons;
}
-(NSMutableArray*)photos
{
    if(!_photos){
        _photos=[[NSMutableArray alloc] init];
    }
    return _photos;
}
-(UIButton*)crossButton
{
    if(!_crossButton){
        _crossButton = [[UIButton alloc] init];
    }
    _crossButton.frame=CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT, 95, BUTTON_HEIGHT);
    [_crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    _crossButton.imageView.contentMode =UIViewContentModeScaleAspectFit;
    _crossButton.tintColor = [UIColor redColor];
    [_crossButton addTarget:self action:@selector(crossButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _crossButton;
}
-(UIButton*)takePhotonButton
{
    if(!_takePhotonButton){
        _takePhotonButton=[[UIButton alloc] init];
    }
    _takePhotonButton.frame=CGRectMake(95, self.view.frame.size.height-BUTTON_HEIGHT, 130, BUTTON_HEIGHT);
    [_takePhotonButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    _takePhotonButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_takePhotonButton addTarget:self action:@selector(takePhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _takePhotonButton;
}
-(UIButton*)checkButton
{
    if(!_checkButton){
        _checkButton = [[UIButton alloc] init];
    }
    [_checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    _checkButton.frame=CGRectMake(95+130, self.view.frame.size.height-BUTTON_HEIGHT, 95, BUTTON_HEIGHT);
    _checkButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_checkButton addTarget:self action:@selector(checkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _checkButton.enabled = NO;
    return _checkButton;
}
-(UIView*)photoPreviewParentView
{
    if(!_photoPreviewParentView){
        _photoPreviewParentView = [[UIView alloc] init];
    }
    _photoPreviewParentView.frame = CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT-(PREVIEW_MARGIN_HEIGHT*2+PREVIEW_LENGTH), self.view.frame.size.width, (PREVIEW_MARGIN_HEIGHT*2+PREVIEW_LENGTH));
    _photoPreviewParentView.backgroundColor= [UIColor lightGrayColor];
    NSMutableArray *arr = self.buttons;
    for(int i=0;i<arr.count;i++){
        [_photoPreviewParentView addSubview:arr[i]];
    }
    _photoPreviewParentView.backgroundColor = [UIColor grayColor];
    
    return _photoPreviewParentView;
}

-(void)setupImagePicker
{
    [self imagePickerController];
    //[self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

-(void)setup
{
    [self crossButton];
    [self takePhotonButton];
    [self checkButton];
    [self photoPreviewParentView];
    [self setupImagePicker];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is %ld",buttonIndex);
    if(buttonIndex==0)
        return;
    //[self performSegueWithIdentifier:@"SellDealBackSegue" sender:self];
}

#pragma mark - button methods
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
-(void)photoButtonClicked:(UIButton*)sender
{
    for(int i=0;i<_buttons.count;i++){
        if(sender==_buttons[i]){
            NSLog(@"button %d clicked",i);
            self.buttonToEdit=i;
            break;
        }
    }
    if(sender.imageView.image==[UIImage imageNamed:@"picture.png"]){
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"EditImageSegue" sender:self];
    }
    
}

-(void)updateButtonWithImage:(UIImage*)image
{
    for(int i=0;i<self.buttons.count;i++){
        UIButton* button = self.buttons[i];
        if(button.imageView.image == [UIImage imageNamed:@"picture.png"]){
            [button setImage:image forState:UIControlStateNormal];
            [self.photos replaceObjectAtIndex:i withObject:image];
            break;
        }
    }
}

-(void)updateButtonWithImage:(UIImage*)image atIndex:(NSInteger)index
{
    if(index<0 || index>=4)
        return;
    UIButton* button = self.buttons[index];
    if(image){
        [button setImage:image forState:UIControlStateNormal];
        [self.photos replaceObjectAtIndex:index withObject:image];
    }
}

-(void)deletePhotoAtButtonIndex:(NSInteger)index
{
    if(index<0||index>=4)
        return;
    NSInteger i = index;
    UIImage* defaultImage=[UIImage imageNamed:@"picture.png"];
    
    while(i<self.photos.count-1 && self.photos[i+1]!=defaultImage){
        self.photos[i]=self.photos[i+1];
        UIButton* button = self.buttons[i];
        button.imageView.image=self.photos[i];
        i=i+1;
    }
    self.photos[i]=defaultImage;
    UIButton* button = self.buttons[i];
    button.imageView.image=defaultImage;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"picker source type is %ld",picker.sourceType);
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //NSLog(@"image data is %@",image);
    [self updateButtonWithImage:image];
//    for(NSString * k in info){
//        NSLog(@" %@ is %@",k, [info objectForKey:k]);
//    }
    //NSLog(@"=--------------------");
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"photo library picker cancelled");
}

#pragma mark - segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditImageSegue"]){
        if([segue.destinationViewController isKindOfClass:[EditImageViewController class]]){
            EditImageViewController *editVC = (EditImageViewController*)segue.destinationViewController;
            if(self.shouldDelete){
                [self deletePhotoAtButtonIndex:self.buttonToEdit];
            }
            else if(self.buttonToEdit>=0 && self.buttonToEdit<4){
                editVC.originalImage=self.photos[self.buttonToEdit];
            }
            else{
                NSLog(@"!!!ERROR: button to edit is wrong");
            }
            
        }
    }
}

-(IBAction)unwindFromEditImageView:(UIStoryboardSegue*)sender
{
    if(self.editImage!=nil){
        if(self.buttonToEdit>=0 && self.buttonToEdit<4){
            self.photos[self.buttonToEdit]=self.editImage;
            [self updateButtonWithImage:self.photos[self.buttonToEdit]];
        }
        else{
            NSLog(@"!!!ERROR: button to edit is wrong");
        }
    }
    NSLog(@"calling unwind edit view");
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
