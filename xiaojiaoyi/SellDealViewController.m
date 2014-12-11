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
@property (nonatomic) UIImage* defaultImage;

@property (nonatomic) DataModalUtils* utils;
@property (nonatomic) NSURL* dealBaseFolder;
@property (nonatomic) NSMutableArray* photosURL;
@property (nonatomic) BOOL imagePickerDismissed;
@property (nonatomic) DealDescriptionViewController* dealDescriptionVC;
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
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils=[DataModalUtils sharedInstance];
    }
    return _utils;
}
-(UIImage*)defaultImage
{
    if(!_defaultImage){
        _defaultImage=[UIImage imageNamed:@"picture.png"];
    }
    return _defaultImage;
}
-(UIImagePickerController*) imagePickerController
{
    if(!_imagePickerController){
        _imagePickerController = [[UIImagePickerController alloc] init];
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
            
            //NSLog(@"library is available");
        }
        else{
            NSLog(@"!!!ERROR: neither camera nor ");
        }
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
        [self.photos addObject:self.defaultImage];
        [button setImage:self.defaultImage forState:UIControlStateNormal];
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
    _crossButton.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 0);
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
    [_checkButton setImage:[UIImage imageNamed:@"correct.png"] forState:UIControlStateNormal];
    _checkButton.frame=CGRectMake(95+130, self.view.frame.size.height-BUTTON_HEIGHT, 95, BUTTON_HEIGHT);
    _checkButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _checkButton.tintColor=[UIColor greenColor];
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
    self.imagePickerDismissed=YES;
    
    //[self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

-(void)setup
{
    [self crossButton];
    [self takePhotonButton];
    [self checkButton];
    [self photoPreviewParentView];
    [self setupImagePicker];
    self.cancelDeal=NO;
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"sell deal view alert view buttonIndex is %ld",buttonIndex);
    if(buttonIndex==0)
        return;
    else if(buttonIndex==1){
        [self deleteDealArchive];
        [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
        //[self performSegueWithIdentifier:@"SellDealUnwindSegue" sender:self];
    }
    
    //[self performSegueWithIdentifier:@"SellDealBackSegue" sender:self];
}

#pragma mark - button clicked methods
-(void)crossButtonClicked
{
    [[[UIAlertView alloc] initWithTitle:@"Cancel the deal?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
     
}
-(void)takePhotoButtonClicked
{
    _checkButton.enabled=YES;
}
-(DealDescriptionViewController*)dealDescriptionVC
{
    if(!_dealDescriptionVC){
        _dealDescriptionVC=[[DealDescriptionViewController alloc] init];
        
    }
    return _dealDescriptionVC;
}
-(void)checkButtonClicked
{
    //NSLog(@"check button clicked");
    //self.dealDescriptionVC.modalPresentationStyle = UIModalPresentationFormSheet;
    //self.dealDescriptionVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:self.dealDescriptionVC animated:YES completion:nil];
    
    //DO NOT CALL this method, there is already segue in the storyboard.
    //Calling this twice, will cause view not in the windows hierarchy warning!
    //[self performSegueWithIdentifier:@"DealDescriptionSegue" sender:self];
    
}
-(void)photoButtonClicked:(UIButton*)sender
{
    for(int i=0;i<_buttons.count;i++){
        if(sender==_buttons[i]){
            //NSLog(@"button %d clicked",i);
            self.buttonToEdit=i;
            break;
        }
    }
    if(sender.imageView.image==self.defaultImage){
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        self.imagePickerDismissed=NO;
    }
    else{
        [self performSegueWithIdentifier:@"EditImageSegue" sender:self];
    }
    
}

#pragma mark - button image CRUD
//similar to insert image but with a starting index
-(void)insertImage:(UIImage*)image fromButtonIndex:(NSInteger)index
{
    if(index<0||index>=4)
        return;
    for(NSInteger i = index;i<_photos.count;i++){
        if(_photos[i]==self.defaultImage){
            _photos[i]=image;
            [_buttons[i] setImage:image forState:UIControlStateNormal];
            break;
        }
    }
}
//insert image to the first button that has default image currently
-(void)insertImage:(UIImage*)image
{
    for(int i=0;i<_photos.count;i++){
        UIButton* button = _buttons[i];
        if(button.imageView.image == self.defaultImage){
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
    UIButton* button = _buttons[index];
    if(image){
        [button setImage:image forState:UIControlStateNormal];
        [_photos replaceObjectAtIndex:index withObject:image];
    }
}

-(void)deletePhotoAtButtonIndex:(NSInteger)index
{
    if(index<0||index>=4)
        return;
    NSInteger i = index;
    
    while(i<self.photos.count-1 && self.photos[i+1]!=self.defaultImage){
        _photos[i]=_photos[i+1];
        UIButton* button = self.buttons[i];
        [button setImage:_photos[i] forState:UIControlStateNormal];
        i=i+1;
    }
    self.photos[i]=self.defaultImage;
    UIButton* button = self.buttons[i];
    [button setImage:self.defaultImage forState:UIControlStateNormal];

}


#pragma mark - callback methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"picker source type is %ld",picker.sourceType);
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //NSLog(@"image data is %@",image);
    [self insertImage:image];
    //[self updateButtonWithImage:image];
//    for(NSString * k in info){
//        NSLog(@" %@ is %@",k, [info objectForKey:k]);
//    }
    //NSLog(@"=--------------------");
    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
        self.imagePickerDismissed=YES;
    }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
   // NSLog(@"photo library picker cancelled");
}

#pragma mark - segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditImageSegue"]){
        if([segue.destinationViewController isKindOfClass:[EditImageViewController class]]){
            EditImageViewController *editVC = (EditImageViewController*)segue.destinationViewController;
            if(self.buttonToEdit>=0 && self.buttonToEdit<4){
                editVC.originalImage=_photos[self.buttonToEdit];
            }
            else{
                NSLog(@"!!!ERROR: button to edit is wrong");
            }
            
        }
    }
    else if([segue.identifier isEqualToString:@"DealDescriptionSegue"]){
        //NSLog(@"deal description segue");
        if([segue.destinationViewController isKindOfClass:[DealDescriptionViewController class]]){
            DealDescriptionViewController* dealDescribeVC = (DealDescriptionViewController*)segue.destinationViewController;
            [self savePhotosToDisk];
            self.myNewDeal.photoURL= self.photosURL;
            dealDescribeVC.myNewDeal = self.myNewDeal;
        }
        NSLog(@"deal description segue");
        if(!self.imagePickerDismissed){
            NSLog(@"image picker is NOT dismissed!");
        }
    }
    else if([segue.identifier isEqualToString:@"SellDealUnwindSegue"]){
        if([segue.destinationViewController isKindOfClass:[CenterViewController class]]){
            CenterViewController*centerVC = (CenterViewController*)segue.destinationViewController;
            [centerVC.superVC reset];
        }
    }
    
}
//---------------------------------------
-(void)savePhotosToDisk
{
    NSURL* docURL = [self.utils documentsURL];
    //self.dealBaseFolder = [[self.utils myDealsDataURL] URLByAppendingPathComponent:self.myNewDeal.deal_id];
    self.dealBaseFolder = [[docURL URLByAppendingPathComponent:[self.utils myDealsDataRelativeURL]] URLByAppendingPathComponent:self.myNewDeal.deal_id];
    NSMutableArray* photoArr= [[NSMutableArray alloc] init];
    self.photosURL=[[NSMutableArray alloc] init];
    BOOL isDir = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.dealBaseFolder.path isDirectory: &isDir]){
        [[NSFileManager defaultManager] createDirectoryAtURL:self.dealBaseFolder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    for(int i=0;i<self.photos.count;i++){
        if(self.photos[i]==self.defaultImage)
            break;
        NSURL* url = [self.dealBaseFolder URLByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",i]];
        UIImage* image = self.photos[i];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToURL:url atomically:YES];
        [self.photosURL addObject:url.path];
        [photoArr addObject:self.photos[i]];
    }
    self.myNewDeal.photos=photoArr;
}
-(IBAction)unwindFromEditImageView:(UIStoryboardSegue*)sender
{
    if(self.shouldDelete){
        [self deletePhotoAtButtonIndex:self.buttonToEdit];
    }
    else if(self.editImage!=nil){
        if(self.buttonToEdit>=0 && self.buttonToEdit<4){
            [self updateButtonWithImage:self.editImage atIndex:self.buttonToEdit];
        }
        else{
            NSLog(@"!!!ERROR: button to edit is wrong");
        }
    }
   // NSLog(@"calling unwind edit view");
}

-(void)deleteDealArchive
{
    if(!self.myNewDeal.deal_id){
        NSLog(@"!!!ERROR: deal id is missing in sell deal delete deal archive");
    }
//    if(!self.dealBaseFolder){
//        self.dealBaseFolder = [[[self.utils documentsURL] URLByAppendingPathComponent:[self.utils myDealsDataRelativeURL]] URLByAppendingPathComponent:self.myNewDeal.deal_id];
//    }
    
    //[[NSFileManager defaultManager] removeItemAtURL:self.dealBaseFolder error:NULL];
    
    [self.utils deleteMyDealStoredDataWithDealId:self.myNewDeal.deal_id];
    
}
-(IBAction)unwindFromDealDescriptionView:(UIStoryboardSegue*)sender
{
    // NSLog(@"calling unwind description View);
    if(self.cancelDeal){
        [self deleteDealArchive];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:@"SellDealUnwindSegue" sender:self];
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self setup];
//    self.dealBaseFolder=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    self.dealBaseFolder=nil;
    
    //[self backButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
