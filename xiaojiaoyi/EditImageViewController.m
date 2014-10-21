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
#define CHOP_VIEW_LENGTH 100

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
@property (nonatomic) UIImageView* imageView;

@property (nonatomic) ChopImageView* chopView;
@property (nonatomic) CGRect chopViewRect;
@property (nonatomic) CGFloat accumulatedScale;
@property (nonatomic) NSInteger rotateCount;
@property (nonatomic) BOOL shouldReplaceImage;
@property (nonatomic) BOOL shouldDelete;
@end


@implementation EditImageViewController

-(void)reset
{
    self.accumulatedScale=1.0;
    self.scrollView.zoomScale=1.0;
    self.rotateCount=0;
}
#pragma mark - button methods
-(void)crossButtonClicked:(UIButton*)sender
{
    if(_menuType==MainMenu){
        self.imageView.image=nil;
        self.shouldReplaceImage=NO;
        self.shouldDelete=NO;
        [self performSegueWithIdentifier:@"EditImageUnwindSegue" sender:self];
    }
    else if(_menuType==ChopMenu){
        [UIView animateWithDuration:0.2 animations:^{
            self.mainEditMenuView.frame=CGRectMake(0, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            self.chopMenuView.frame=CGRectMake(self.view.frame.size.width,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            
            self.chopView.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT));
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
            if(self.rotateCount==1 || self.rotateCount==-3){
                self.imageView.frame=CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.height, self.imageView.frame.size.width);
                self.imageView.image=[self scaleAndRotateImage:self.imageView.image toOrientation:UIImageOrientationLeft];
            }
            else if(self.rotateCount==-1 || self.rotateCount==3){
                self.imageView.frame=CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.height, self.imageView.frame.size.width);
                self.imageView.image=[self scaleAndRotateImage:self.imageView.image toOrientation:UIImageOrientationRight];
            }
            else if(self.rotateCount==-2 || self.rotateCount==2){
                self.imageView.image=[self scaleAndRotateImage:self.imageView.image toOrientation:UIImageOrientationDown];
            }
            else{
                NSLog(@"!!!ERROR: rotate count is wrong");
            }
            [self reset];
        }];
    }
}
-(void)checkButtonClicked:(UIButton*)sender
{
    if(_menuType==MainMenu){
        self.shouldReplaceImage=YES;
        self.shouldDelete=NO;
        [self performSegueWithIdentifier:@"EditImageUnwindSegue" sender:self];
        //CGPoint offset = [self.scrollView contentOffset];
        //NSLog(@"offset is %f,%f",offset.x,offset.y);
    }
    else if(_menuType==ChopMenu){
        CGFloat scale = self.scrollView.zoomScale;
        _accumulatedScale=_accumulatedScale*scale;
        CGPoint offset = [self.scrollView contentOffset];
        CGRect one = self.chopView.rect;
        //realOffset is the offset in the orignial image, including the image offset within the scrollview as well as the offset of the intersection in the chopView; It is all done with respect to the original image scale.
        CGPoint realOffset=CGPointMake((offset.x+one.origin.x)/_accumulatedScale, (offset.y+one.origin.y)/_accumulatedScale);
        CGRect mask = CGRectMake(realOffset.x, realOffset.y, one.size.width/_accumulatedScale, one.size.height/_accumulatedScale);

        //NSLog(@"content size is %f,%f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
        //NSLog(@"scaling factor:%f",self.scrollView.zoomScale);
        UIImage* choppedImage=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([self.imageView.image CGImage] , mask)];
        [self crossButtonClicked:self.crossButton];
        //[self.imageView setImage:choppedImage];
        
        //NSLog(@"scale is %f, offset is %f,%f",scale,offset.x,offset.y);
        self.scrollView.zoomScale=1.0;
        self.imageView.image=choppedImage;
        //self.imageView.backgroundColor=[UIColor greenColor];
        //self.imageView.layer.borderColor= [[UIColor greenColor] CGColor];
        //self.imageView.layer.borderWidth=2.0;
        //NSLog(@"accumulatedScale is %f and image is %@",_accumulatedScale,self.imageView.image);
        self.imageView.frame=CGRectMake(0, 0, choppedImage.size.width*_accumulatedScale, choppedImage.size.height*_accumulatedScale);
        //self.imageView.image;
    }
    else if(_menuType==RotateMenu){
        [UIView animateWithDuration:0.2 animations:^{
            self.mainEditMenuView.frame=CGRectMake(0, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            self.rotateMenuView.frame=CGRectMake(self.view.frame.size.width,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
            
        } completion:^(BOOL finished) {
            _menuType=MainMenu;
        }];
    }
}
-(void)deleteButtonClicked:(UIButton*)sender
{
    self.shouldDelete=YES;
    [self performSegueWithIdentifier:@"EditImageUnwindSegue" sender:self];
    //[self reset];
    //self.imageView.image=[UIImage imageNamed:@"linkedin.jpg"];
    //self.imageView.frame=CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
}
-(void)chopButtonClicked:(UIButton*)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainEditMenuView.frame=CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        self.chopMenuView.frame=CGRectMake(0,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT), self.view.frame.size.width, EDIT_MENU_HEIGHT);
        self.chopView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT));
        
    } completion:^(BOOL finished) {
        _menuType=ChopMenu;
        [self chopSquareScaleButtonClicked:nil];
    }];
    
}
-(void)chopOriginScaleButtonClicked:(UIButton*)sender
{
    self.chopSquareScaleButton.backgroundColor=[UIColor lightGrayColor];
    self.chopOriginScaleButton.backgroundColor=[UIColor grayColor];
    CGFloat width=0.0;
    CGFloat height=0.0;
    CGFloat scale = self.originalImage.size.width/self.originalImage.size.height;
    if(self.originalImage.size.width>self.originalImage.size.height){
        height=100;
        width=scale * height;
    }
    else{
        width=100;
        height=width/scale;
    }
    self.chopViewRect=CGRectMake(self.scrollView.center.x-width/2, self.scrollView.center.y-height/2,width,height);
    self.chopView.rect=self.chopViewRect;
    [self.chopView setNeedsDisplay];
}
-(void)chopSquareScaleButtonClicked:(UIButton*)sender
{
    self.chopSquareScaleButton.backgroundColor=[UIColor grayColor];
    self.chopOriginScaleButton.backgroundColor=[UIColor lightGrayColor];
    self.chopViewRect=CGRectMake(self.scrollView.center.x-CHOP_VIEW_LENGTH/2, self.scrollView.center.y-CHOP_VIEW_LENGTH/2, CHOP_VIEW_LENGTH, CHOP_VIEW_LENGTH);
    self.chopView.rect=self.chopViewRect;
    [self.chopView setNeedsDisplay];
    
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
    self.rotateCount=self.rotateCount+1;
    self.rotateCount=self.rotateCount%4;
    self.imageView.frame=CGRectMake(0,0, self.imageView.frame.size.height, self.imageView.frame.size.width);
    self.imageView.image=[self scaleAndRotateImage:_imageView.image toOrientation:UIImageOrientationRight];
    //self.imageView.layer.borderWidth=2.0f;
    //self.imageView.layer.borderColor=[[UIColor greenColor] CGColor];
}

-(void)rotateCounterClockButtonClicked:(UIButton*)sender
{
    self.rotateCount=self.rotateCount-1;
    if(self.rotateCount==-4)
        self.rotateCount=0;
    self.imageView.frame=CGRectMake(0,0, self.imageView.frame.size.height, self.imageView.frame.size.width);
    self.imageView.image=[self scaleAndRotateImage:_imageView.image toOrientation:UIImageOrientationLeft];
}

//very important to rotate and scale CGImage!!
//http://blog.logichigh.com/2008/06/05/uiimage-fix/
-(UIImage *)scaleAndRotateImage:(UIImage *)image toOrientation:(UIImageOrientation)orientation
{
    int kMaxResolution = self.view.frame.size.width; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    //UIImageOrientation orient = image.imageOrientation;
    //two coordinate systems
    UIImageOrientation orient=orientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    
    return imageCopy;  
}


#pragma mark - view setup
-(UIButton*)crossButton
{
    if(!_crossButton){
        _crossButton = [[UIButton alloc] init];
        _crossButton.frame=CGRectMake(0,self.view.frame.size.height-BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT);
        _crossButton.backgroundColor=[UIColor whiteColor];
        [_crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        _crossButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_crossButton addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _crossButton;
}
-(UIButton*)checkButton
{
    if(!_checkButton){
        _checkButton = [[UIButton alloc] init];
        _checkButton.frame=CGRectMake(self.view.frame.size.width-BUTTON_WIDTH, self.view.frame.size.height-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
        _checkButton.backgroundColor=[UIColor whiteColor];
        [_checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        _checkButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
-(UIButton*)deleteButton
{
    if(!_deleteButton){
        _deleteButton =[[UIButton alloc] init];
        _deleteButton.frame=CGRectMake(BUTTON_WIDTH, self.view.frame.size.height-BUTTON_HEIGHT, self.view.frame.size.width-(2*BUTTON_WIDTH), BUTTON_HEIGHT);
        _deleteButton.backgroundColor=[UIColor whiteColor];
        [_deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        _deleteButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
-(UIButton*)chopButton
{
    if(!_chopButton){
        _chopButton=[[UIButton alloc] init];
        _chopButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_chopButton setImage:[UIImage imageNamed:@"chop.png"] forState:UIControlStateNormal];
        _chopButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_chopButton addTarget:self action:@selector(chopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chopButton;
}
-(UIButton*)chopOriginScaleButton
{
    if(!_chopOriginScaleButton){
        _chopOriginScaleButton=[[UIButton alloc] init];
        _chopOriginScaleButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_chopOriginScaleButton setImage:[UIImage imageNamed:@"scaling.png"] forState:UIControlStateNormal];
        _chopOriginScaleButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_chopOriginScaleButton addTarget:self action:@selector(chopOriginScaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chopOriginScaleButton;
}
-(UIButton*)chopSquareScaleButton
{
    if(!_chopSquareScaleButton){
        _chopSquareScaleButton=[[UIButton alloc] init];
        _chopSquareScaleButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_chopSquareScaleButton setImage:[UIImage imageNamed:@"square.png"] forState:UIControlStateNormal];
        _chopSquareScaleButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_chopSquareScaleButton addTarget:self action:@selector(chopSquareScaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chopSquareScaleButton;
}
-(UIButton*)rotateButton
{
    if(!_rotateButton){
        _rotateButton = [[UIButton alloc] init];
        _rotateButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_rotateButton setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
        _rotateButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_rotateButton addTarget:self action:@selector(rotateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateButton;
}
-(UIButton*)rotateClockButton
{
    if(!_rotateClockButton){
        _rotateClockButton=[[UIButton alloc] init];
        _rotateClockButton.frame=CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_rotateClockButton setImage:[UIImage imageNamed:@"rotateClock.png"] forState:UIControlStateNormal];
        _rotateClockButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_rotateClockButton addTarget:self action:@selector(rotateClockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateClockButton;
}
-(UIButton*)rotateCounterClockButton
{
    if(!_rotateCounterClockButton){
        _rotateCounterClockButton=[[UIButton alloc] init];
        _rotateCounterClockButton.frame=CGRectMake(0, 0, self.view.frame.size.width/2, EDIT_MENU_HEIGHT);
        [_rotateCounterClockButton setImage:[UIImage imageNamed:@"rotateCounterClock.png"] forState:UIControlStateNormal];
        _rotateCounterClockButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_rotateCounterClockButton addTarget:self action:@selector(rotateCounterClockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateCounterClockButton;
}

-(UIView*)mainEditMenuView
{
    if(!_mainEditMenuView){
        _mainEditMenuView = [[UIView alloc] init];
        _mainEditMenuView.frame = CGRectMake(0, self.view.frame.size.height-BUTTON_HEIGHT-EDIT_MENU_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
        _mainEditMenuView.backgroundColor = [UIColor lightGrayColor];
        [_mainEditMenuView addSubview:self.chopButton];
        [_mainEditMenuView addSubview:self.rotateButton];

    }
    return _mainEditMenuView;
}
-(UIView*)chopMenuView
{
    if(!_chopMenuView){
        _chopMenuView = [[UIView alloc] init];
        _chopMenuView.frame=CGRectMake(self.view.frame.size.width, self.view.frame.size.height-BUTTON_HEIGHT-EDIT_MENU_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
        _chopMenuView.backgroundColor=[UIColor lightGrayColor];
        [_chopMenuView addSubview:self.chopOriginScaleButton];
        [_chopMenuView addSubview:self.chopSquareScaleButton];
    }
    return _chopMenuView;
}
-(UIView*)rotateMenuView
{
    if(!_rotateMenuView){
        _rotateMenuView=[[UIView alloc] init];
        _rotateMenuView.frame=CGRectMake(self.view.frame.size.width, self.view.frame.size.height-EDIT_MENU_HEIGHT-BUTTON_HEIGHT, self.view.frame.size.width, EDIT_MENU_HEIGHT);
        _rotateMenuView.backgroundColor=[UIColor lightGrayColor];
        [_rotateMenuView addSubview:self.rotateClockButton];
        [_rotateMenuView addSubview:self.rotateCounterClockButton];
    }
    return _rotateMenuView;
}
-(ChopImageView*)chopView
{
    if(!_chopView){
        _chopView = [[ChopImageView alloc] init];
        _chopView.backgroundColor=[UIColor clearColor];
        _chopView.frame = CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT));
        UIPanGestureRecognizer* chopPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(chopViewPan:)];
        //_chopView.rect=_chopViewRect;
        [_chopView addGestureRecognizer:chopPan];
        UIPinchGestureRecognizer* chopPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(chopViewPinch:)];
        [_chopView addGestureRecognizer:chopPinch];
    }

    return _chopView;
}

-(void)chopViewPan:(UIPanGestureRecognizer*)gesture
{
    
    CGPoint transition = [gesture translationInView:self.chopView];
    CGFloat offsetX=transition.x;
    CGFloat offsetY=transition.y;
    if(_chopViewRect.origin.x+offsetX<0){
        offsetX=0-_chopViewRect.origin.x;
    }
    else if(_chopViewRect.origin.x+offsetX+_chopViewRect.size.width>self.view.frame.size.width){
        offsetX=self.view.frame.size.width-_chopViewRect.origin.x-_chopViewRect.size.width;
    }
    if(_chopViewRect.origin.y+offsetY<0){
        offsetY=0-_chopViewRect.origin.y;
    }
    else if(_chopViewRect.origin.y+offsetY + _chopViewRect.size.height >self.view.frame.size.height - (BUTTON_HEIGHT+EDIT_MENU_HEIGHT)){
        offsetY=self.view.frame.size.height - (BUTTON_HEIGHT+EDIT_MENU_HEIGHT)-(_chopViewRect.origin.y)-_chopViewRect.size.height;
    }
    
    if(gesture.state==UIGestureRecognizerStateChanged){
        _chopView.rect=CGRectMake(_chopViewRect.origin.x+offsetX, _chopViewRect.origin.y+offsetY, _chopViewRect.size.width,_chopViewRect.size.height);
        
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        _chopViewRect.origin.x=_chopViewRect.origin.x+offsetX;
        _chopViewRect.origin.y=_chopViewRect.origin.y+offsetY;
        _chopView.rect=_chopViewRect;

    }
    [_chopView setNeedsDisplay];
    
}
-(void)chopViewPinch:(UIPinchGestureRecognizer*)gesture
{
    CGFloat scale= gesture.scale;
    //NSLog(@"scale is %f",scale);
    CGPoint center =CGPointMake(self.chopViewRect.origin.x+self.chopViewRect.size.width/2,self.chopViewRect.origin.y+self.chopViewRect.size.height/2);
    CGFloat lengthX=self.chopViewRect.size.width * scale;
    CGFloat lengthY=self.chopViewRect.size.height * scale;
    if(gesture.state==UIGestureRecognizerStateChanged){
        _chopView.rect=CGRectMake(center.x-lengthX/2, center.y-lengthY/2, lengthX, lengthY);
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        _chopViewRect=CGRectMake(center.x-lengthX/2, center.y-lengthY/2, lengthX, lengthY);
        _chopView.rect=_chopViewRect;
    }
    [_chopView setNeedsDisplay];
    
}
-(UIScrollView*)scrollView
{
    if(!_scrollView){
        _scrollView=[[UIScrollView alloc] init];
        _scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(BUTTON_HEIGHT+EDIT_MENU_HEIGHT)-5);
        _scrollView.backgroundColor=[UIColor lightGrayColor];
        //_originalImage = [UIImage imageNamed:@"linkedin.jpg"];
        _imageView=[[UIImageView alloc] initWithImage:[_originalImage copy]];
        _imageView.frame = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
        [_scrollView addSubview:_imageView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator=YES;
        _scrollView.showsVerticalScrollIndicator=YES;
        _scrollView.contentSize=_imageView.bounds.size;
        _scrollView.minimumZoomScale=0.8;
        _scrollView.maximumZoomScale=5.0;
        _scrollView.scrollEnabled=YES;
        _accumulatedScale=1.0;
        _rotateCount=0;
    }
    return _scrollView;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //NSLog(@"calling view for zooming scale:%f",_scrollView.zoomScale);
    
    return _imageView;
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
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.chopView];
    
}

#pragma mark - segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditImageUnwindSegue"]){
        if([segue.destinationViewController isKindOfClass:[SellDealViewController class]]){
            SellDealViewController *sellDealVC = (SellDealViewController*)segue.destinationViewController;
            NSLog(@"the image is %@",self.imageView.image);
            if(self.shouldDelete){
                sellDealVC.shouldDelete=YES;
            }
            else{
                sellDealVC.shouldDelete=NO;
                sellDealVC.editImage=self.shouldReplaceImage?self.imageView.image:nil;
            }
        }
    }
    //NSLog(@"segue from Edit image View controller is %@",segue.identifier);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view. d
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
