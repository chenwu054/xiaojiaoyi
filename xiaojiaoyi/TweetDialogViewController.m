//
//  TweetDialogViewController.m
//  xiaojiaoyi
//
//  Created by chen on 11/11/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "TweetDialogViewController.h"

#define BUTTON_WIDTH 100
#define BUTTON_HEIGHT 50
#define TEXTVIEW_HEIGHT 200
#define TEXTVIEW_WIDTH 200
#define CONTAINER_VIEW_HEIGHT 220
@interface TweetDialogViewController ()

@property (nonatomic) UIView* containerView;
@property (nonatomic) UIButton* cancelButton;
@property (nonatomic) UIButton* shareButton;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UITextView* textView;
@property (nonatomic) BOOL shouldTweet;

@end

@implementation TweetDialogViewController

-(UIButton*)cancelButton
{
    if(!_cancelButton){
        UIImage* cancelImage = [UIImage imageNamed:@"twitterCancel2.png"];
        _cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(TEXTVIEW_WIDTH + 10, 10, BUTTON_WIDTH, BUTTON_WIDTH /cancelImage.size.width * cancelImage.size.height)];
        
        [_cancelButton setImage:cancelImage forState:UIControlStateNormal];
        _cancelButton.layer.borderColor=[[UIColor redColor] CGColor];
        _cancelButton.layer.borderWidth=1.0;
        _cancelButton.layer.cornerRadius=5.0;
        _cancelButton.backgroundColor=[UIColor clearColor];
//        [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
//        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        //[_cancelButton setTintColor:[UIColor blueColor]];
//        _cancelButton.backgroundColor=[UIColor grayColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(UIButton*)shareButton
{
    if(!_shareButton){
        UIImage* shareImage = [UIImage imageNamed:@"twitterShare.jpg"];
        _shareButton=[[UIButton alloc] initWithFrame:CGRectMake(TEXTVIEW_WIDTH + 10, CONTAINER_VIEW_HEIGHT - 10 - (BUTTON_WIDTH /shareImage.size.width * shareImage.size.height), BUTTON_WIDTH, BUTTON_WIDTH /shareImage.size.width * shareImage.size.height)];
        [_shareButton setImage:shareImage forState:UIControlStateNormal];
        _shareButton.layer.borderWidth=0.0;
        _shareButton.layer.borderColor = [[UIColor cyanColor] CGColor];
        _shareButton.backgroundColor=[UIColor clearColor];
//        [_shareButton setTitle:@"share" forState:UIControlStateNormal];
//        [_shareButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_shareButton setTintColor:[UIColor redColor]];
//        _shareButton.backgroundColor=[UIColor grayColor];
        
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

-(UIView*)containerView
{
    if(!_containerView){
        _containerView=[[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, CONTAINER_VIEW_HEIGHT)];
        _containerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"twitterBackground.jpg"]];
        //_containerView.backgroundColor=[UIColor whiteColor];
        _containerView.layer.cornerRadius=10.0f;
        [_containerView addSubview:self.cancelButton];
        [_containerView addSubview:self.shareButton];
        [_containerView addSubview:self.textView];
        
        //[_containerView addSubview:self.textField];
        [_containerView addSubview:self.imageView];
    }
    return _containerView;
}
-(UITextView*)textView
{
    if(!_textView){
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(5, 10, TEXTVIEW_WIDTH - 5, TEXTVIEW_HEIGHT)];
        _textView.editable=YES;
        //_textView.text=@"asfjasd\nfa\nsdf\nasd\nfa";
        _textView.text=self.placeholder;
        _textView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        _textView.font=[UIFont fontWithName:@"Georgia" size:20];
        _textView.layer.cornerRadius=10.0;
        
    }
    return _textView;
}
-(UIImageView*)imageView
{
    if(!_imageView){
       // UIImage* image = [UIImage imageNamed:@"linkedin.jpg"];
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(TEXTVIEW_WIDTH+5, self.cancelButton.frame.origin.y + self.cancelButton.frame.size.height + 10, self.view.frame.size.width-TEXTVIEW_WIDTH-10, CONTAINER_VIEW_HEIGHT - 2* BUTTON_HEIGHT - 20)];
        _imageView.image=[UIImage imageNamed:@"linkedin.jpg"];
        _imageView.layer.borderColor=[[UIColor brownColor] CGColor];
        _imageView.layer.borderWidth=2.0;
        _imageView.layer.cornerRadius=5.0;
        _imageView.backgroundColor=[UIColor clearColor];
        //_imageView.image=self.image;
    }
    return _imageView;
}
-(void)shareButtonClicked:(UIButton*)sender
{
    //DealSummaryEditViewController* dealSummaryEditVC = (DealSummaryEditViewController*)self.presentingViewController;
    self.shouldTweet=YES;
    [self performSegueWithIdentifier:@"TweetDialogUnwindSegue" sender:self];
    
}
-(void)cancelButtonClicked:(UIButton*)sender
{
    //NSLog(@"");
    self.shouldTweet=NO;
    [self performSegueWithIdentifier:@"TweetDialogUnwindSegue" sender:self];
    
}
-(void)tap:(UITapGestureRecognizer*)gesture
{

    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TweetDialogUnwindSegue"]){
        if([segue.destinationViewController isKindOfClass:[DealSummaryEditViewController class]]){
            DealSummaryEditViewController* dealEditVC=(DealSummaryEditViewController*)segue.destinationViewController;
            dealEditVC.shouldTweet=self.shouldTweet;
            dealEditVC.tweetString=self.textView.text;
        }
    }
}
-(void)setup
{
    self.view.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.35];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.containerView];
    self.shouldTweet=NO;
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
