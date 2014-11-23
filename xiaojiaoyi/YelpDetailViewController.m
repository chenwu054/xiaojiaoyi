//
//  YelpDetailViewController.m
//  xiaojiaoyi
//
//  Created by chen on 11/16/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "YelpDetailViewController.h"

#define LABEL_WIDTH 25
#define LEFT_MARGIN 10
#define PHONE_LABEL_HEIGHT 25
#define REVIEWER_IMAGE_WIDTH 50

@interface YelpDetailViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) UIButton* isClosedButton;
@property (nonatomic) UILabel* categoryLabel;
@property (nonatomic) UIImageView* ratingImageView;
@property (nonatomic) UIImage*ratingImage;
@property (nonatomic) UILabel* ratingCountLabel;
@property (nonatomic) UILabel* phoneLabel;
@property (nonatomic) UIView* phoneView;
@property (nonatomic) UIImageView* phoneImageView;
@property (nonatomic) UILabel* reviewCountLabel;
@property (nonatomic) UIView* reviewView;
@property (nonatomic) UIImageView* reviewerImageView;

@property (nonatomic) UILabel* reviewLabel;
@property (nonatomic) UILabel* addressLabel;

@end

@implementation YelpDetailViewController

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //this is where to set the annotation callout
    NSLog(@"YelpDetailVC: did select annotation view");
//    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    view.leftCalloutAccessoryView =  imageView;
//    imageView.image = self.image;
//    view.leftCalloutAccessoryView.frame= CGRectMake(0, 0, 40, 40);
//    view.rightCalloutAccessoryView  = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
//    //Location * ann = (Location*) view.annotation;
//    //ann.name=nil;
//    view.enabled = YES;
    //NSLog(@"%d",view.isSelected);
    
}
-(MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"YelpDetailVC: calling viewForAnnotation");
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:@"Location"];
    if(!aView){
        NSLog(@"aView is nil");
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Location"];
        aView.pinColor = MKPinAnnotationColorGreen;
        aView.animatesDrop = YES;
        aView.canShowCallout=YES;
        aView.enabled = YES;
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(disclosureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    aView.rightCalloutAccessoryView = rightButton;
    // Add a custom image to the left side of the callout.
    UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:self.image];
    //myCustomImage.frame = CGRectMake(-2, -2, 20, 20);
    aView.leftCalloutAccessoryView = myCustomImage;
    aView.leftCalloutAccessoryView.frame =CGRectMake(0, -2, 40, 40);
    aView.annotation = annotation;
    return aView;
}
-(void)disclosureButtonClicked:(UIButton*)sender
{
    NSLog(@"disclosure button clicked");
    
}
-(UILabel*)titleLabel
{
    if(!_titleLabel){
        CGFloat width =  [self.titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f]}].width;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 0, 0, width, 20)];
        _titleLabel.attributedText=[[NSAttributedString alloc] initWithString:self.titleString==nil?@"no title":self.titleString attributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f]}];
        //_titleLabel.backgroundColor=[UIColor cyanColor];
    }
    return _titleLabel;
}
-(UIButton*)isClosedButton
{
    if(!_isClosedButton){
        _isClosedButton =[[UIButton alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, 5, 60, 15)];
        if(self.isClosed==[NSNumber numberWithInteger:1]){
            [_isClosedButton setTitle:@"closed" forState:UIControlStateNormal];
            
            [_isClosedButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        else{
            [_isClosedButton setTitle:@"open" forState:UIControlStateNormal];
            [_isClosedButton setBackgroundColor:[UIColor greenColor]];
        }
        _isClosedButton.layer.cornerRadius = 6.0f;
    }
    return _isClosedButton;
}
-(UILabel*)categoryLabel
{
    if(!_categoryLabel){
        CGFloat width =  [self.category sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AppleGothic" size:10.0f]}].width;
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + LEFT_MARGIN, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height,MAX(width,self.scrollView.frame.size.width), 20)];
        _categoryLabel.textColor=[UIColor blueColor];
        _categoryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.category attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AppleGothic" size:12.0f]}];
        //_categoryLabel.backgroundColor=[UIColor redColor];
    }
    return _categoryLabel;
}
-(UIImageView*)ratingImageView
{
    if(!_ratingImageView){
        _ratingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-105, self.categoryLabel.frame.origin.y + self.categoryLabel.frame.size.height, self.scrollView.frame.size.width, 15)];
        _ratingImageView.contentMode=UIViewContentModeLeft;
        _ratingImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _ratingImageView;
}
-(UILabel*)addressLabel
{
    if(!_addressLabel){
        
        CGSize size = [self.address sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier-Bold" size:14.0f]}];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN+ 0, 5 + self.ratingImageView.frame.origin.y + self.ratingImageView.frame.size.height, size.width,size.height)];
        _addressLabel.numberOfLines = 0;
//        _addressLabel.lineBreakMode = UILineBreakModeWordWrap;
        _addressLabel.attributedText=[[NSAttributedString alloc] initWithString:self.address attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier-Bold" size:14.0f]}];
        //_addressLabel.backgroundColor=[UIColor blueColor];
    }
    return _addressLabel;
}
-(UIView*)phoneView
{
    if(!_phoneView){
        _phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 0, self.addressLabel.frame.origin.y + self.addressLabel.frame.size.height, self.phoneImageView.frame.size.width + self.phoneImageView.frame.origin.x + self.phoneLabel.frame.size.width, PHONE_LABEL_HEIGHT)];
        [_phoneView addSubview:self.phoneImageView];
        [_phoneView addSubview:self.phoneLabel];
    }
    return _phoneView;
}
-(UIImageView*)phoneImageView
{
    if(!_phoneImageView){
        _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_LABEL_HEIGHT, PHONE_LABEL_HEIGHT)];
        _phoneImageView.image=[UIImage imageNamed:@"call.png"];
    }
    return _phoneImageView;
}
-(UILabel*)phoneLabel
{
    if(!_phoneLabel){
        CGSize size = [self.photoNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier-Bold" size:14.0f]}];
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.phoneImageView.frame.size.width, 0, size.width, PHONE_LABEL_HEIGHT)];
        _phoneLabel.attributedText=[[NSAttributedString alloc] initWithString:self.photoNumber?self.photoNumber:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier-Bold" size:14.0f]}];
        //_phoneLabel.backgroundColor = [UIColor purpleColor];
    }
    return _phoneLabel;
}
-(UILabel*)reviewCountLabel
{
    if(!_reviewCountLabel){
        
        _reviewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + LEFT_MARGIN, self.phoneView.frame.origin.y + self.phoneView.frame.size.height, self.scrollView.frame.size.width, PHONE_LABEL_HEIGHT)];
        _reviewCountLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"review: (%@)",self.reviewCount] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier-Bold" size:12.0f]}];
        //_reviewCountLabel.backgroundColor=[UIColor greenColor];
    }
    return _reviewCountLabel;
}
-(UIView*)reviewView
{
    if(!_reviewView){
        _reviewView = [[UIView alloc] initWithFrame:CGRectMake(0, self.reviewCountLabel.frame.origin.y+self.reviewCountLabel.frame.size.height, self.scrollView.frame.size.width, self.reviewLabel.frame.size.height+20)];
        [_reviewView addSubview:self.reviewerImageView];
        [_reviewView addSubview:self.reviewLabel];
    }
    return _reviewView;
}
-(UIImageView*)reviewerImageView
{
    if(!_reviewerImageView){
        _reviewerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1*LEFT_MARGIN, 0, REVIEWER_IMAGE_WIDTH, 70)];
        [_reviewerImageView setContentMode:UIViewContentModeScaleAspectFit];
        //_reviewerImageView.backgroundColor=[UIColor redColor];
        
    }
    return _reviewerImageView;
}
-(UILabel*)reviewLabel
{
    if(!_reviewLabel){
        NSLog(@"review is %@",self.review);
        NSString* newReview = [NSString stringWithFormat:@"review: \r\n%@",self.review];
//        CGFloat maxWidth = MAX(self.isClosedButton.frame.origin.x + self.isClosedButton.frame.size.width, self.categoryLabel.frame.size.width);
//        maxWidth=MAX(maxWidth,self.phoneView.frame.size.width);
//        maxWidth=MAX(maxWidth,self.addressLabel.frame.size.width);
        CGSize maximumLabelSize = CGSizeMake(self.scrollView.frame.size.width-REVIEWER_IMAGE_WIDTH-10,9999);
        CGSize expectedLabelSize = [newReview sizeWithFont:[UIFont fontWithName:@"Georgia" size:14.0f]
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
//        CGRect rect = [newReview boundingRectWithSize:maximumLabelSize options:0 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:14.0f]} context:nil];
        
        _reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(REVIEWER_IMAGE_WIDTH + 1*LEFT_MARGIN, 0, expectedLabelSize.width, expectedLabelSize.height+20)];
        _reviewLabel.numberOfLines=0;
        [_reviewLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _reviewLabel.attributedText=[[NSAttributedString alloc] initWithString:newReview attributes: @{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:14.0f]}];
        
        //_reviewLabel.backgroundColor=[UIColor greenColor];
    }
    return _reviewLabel;
}
-(void)setup
{
    self.view.backgroundColor= [UIColor whiteColor];
    self.mapView.delegate=self;
    [self.mapView addAnnotations: [self.pins copy]];
    CLLocationCoordinate2D center;
    center.latitude = ((id<MKAnnotation>)([self.mapView.annotations firstObject])).coordinate.latitude;
    center.longitude = ((id<MKAnnotation>)([self.mapView.annotations firstObject])).coordinate.longitude;
    CLLocationDistance width = 2000;
    CLLocationDistance height = 2000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, width, height);
    [self.mapView setRegion:region animated:YES];
    
    if(self.ratingImageURL){
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.ratingImageURL]];
        
        NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse* r = (NSHTTPURLResponse*)response;
            if(r.statusCode==200){
                NSData* data = [NSData dataWithContentsOfURL:location];
                UIImage* image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.ratingImageView.image=[image copy];
                });
            }
        }];
        [downloadTask resume];
    }
    if(self.reviewImageURLString && self.reviewImageURLString.length>0){
        NSLog(@"url is %@",self.reviewImageURLString);
        NSURL* url =[NSURL URLWithString:self.reviewImageURLString];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask* task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse* r = (NSHTTPURLResponse*)response;
            //NSLog(@"response is %@",r);
            if(r.statusCode==200){
                NSData* data = [NSData dataWithContentsOfURL:location];
                __block UIImage* image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.reviewerImageView.image=[image copy]; //[[UIImage imageWithContentsOfFile:location.path] copy];
                    NSLog(@"location is %@",image);
                    //NSLog(@"self label frame %f,%f,%f,%f",self.reviewLabel.frame.origin.x,self.reviewLabel.frame.origin.y,self.reviewLabel.frame.size.width,self.reviewLabel.frame.size.height);
                    //NSLog(@"self image frame %f,%f,%f,%f",self.reviewerImageView.frame.origin.x,self.reviewerImageView.frame.origin.y,self.reviewerImageView.frame.size.width,self.reviewerImageView.frame.size.height);
                });
            }
        }];
        [task resume];
    }
//    self.imageView.image=self.image;
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.isClosedButton];
    [self.scrollView addSubview:self.categoryLabel];
    [self.scrollView addSubview:self.ratingImageView];
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.reviewCountLabel];
    //[self.scrollView addSubview:self.reviewLabel];
    [self.scrollView addSubview:self.reviewView];
    
//    CGFloat maxWidth = MAX(self.isClosedButton.frame.origin.x + self.isClosedButton.frame.size.width, self.categoryLabel.frame.size.width);
//    maxWidth=MAX(maxWidth,self.phoneView.frame.origin.x+self.phoneView.frame.size.width);
//    maxWidth=MAX(maxWidth,self.addressLabel.frame.origin.x +self.addressLabel.frame.size.width);
//    
    //maxWidth=MAX(maxWidth,self.reviewLabel.frame.size.width);
    CGFloat maxHeight = self.titleLabel.frame.size.height
                    + self.categoryLabel.frame.size.height
                    + self.ratingImageView.frame.size.height
                    + self.addressLabel.frame.size.height
                    + self.phoneLabel.frame.size.height
                    + self.reviewCountLabel.frame.size.height
                    + self.reviewLabel.frame.size.height + 20;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,maxHeight);
}
-(void)clear
{
    if(!self.pins){
        self.pins = [[NSMutableArray alloc] init];
    }
    [self.pins removeAllObjects];

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
