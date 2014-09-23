//
//  LoginViewController.m
//  xiaojiaoyi
//
//  Created by chen on 8/24/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "LoginViewController.h"
#import "STTwitterOAuth.h"
#import "STTwitterAPI.h"
#import "OAuthViewController.h"
//#import "STTwitter/STTwitterOAuth.h"

#define LOGIN_LABEL @"log in"
#define LOGIN_USERNAME @"username"
#define LOGIN_PASSWORD @"password"
#define TWITTER_CONSUMER_NAME @"xiaojiaoyi"
#define TWITTER_CONSUMER_KEY /*@"sRtlhqgVCwIFNooYsr8X1sptO"*/ @"PdLBPYUXlhQpt4AguShUIw"
#define TWITTER_CONSUMER_SECRET /*@"JomNUiwkkHoZ9I1jhwyUbtDBWoLrHMmBB61CoYf9t57l5z2x8h"*/ @"drdhGuKSingTbsDLtYpob4m5b5dn1abf9XXYyZKQzk"
#define LINKEDIN_API_KEY @"75iapcxav6yub5"
#define LINKEDIN_DEFAULT_SCOPE @"r_basicprofile"
#define LINKEDIN_DEFAULT_STATE @"ThisIsARandomeState"
#define LINKEDIN_REDIRECT_URL @"http://xiaojiaoyi_linkedin_redirectURL"
#define LINKEDIN_SECRET @"jUcSjy0xlLY0oaJC"
#define LINKEDIN_AUTHENTICATION_CODE_BASE_URL @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *loginForgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginLinkedinButton;

@property (weak, nonatomic) IBOutlet UILabel *loginProceedLabel;
//@property (nonatomic,weak) UITapGestureRecognizer *tapRecognizer;
//@property (weak,nonatomic) FBLoginView *fbLoginView;
@property  (nonatomic) IBOutlet FBLoginView *fbLoginView;

@property (nonatomic) IBOutlet UIView *profileView;


@property (nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (strong, nonatomic) STTwitterAPI * twitterAPI;
@property (nonatomic) NSString* redirectURL;
@property (nonatomic) NSURLSession * session;


@end

@implementation LoginViewController

- (void) setFbLoginView:(FBLoginView *)fbLoginView
{
    if(!_fbLoginView){
        _fbLoginView = [[FBLoginView alloc] init];
        _fbLoginView.delegate = self;
    }
}


#pragma mark - twitter login methods
-(void)twitterLoginButtonClicked:(UIButton*)sender
{
    //NSLog(@"twitterLoginButton clicked");
    _twAccessToken = [[TWAccessToken alloc] init];
    [_twAccessToken getRequestTokenWithCompletionTask:^(BOOL success, NSURLResponse *response, NSError *error){
        if(success){
            _isTwitter = YES;
            _isLinkedin = NO;
            _redirectURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authenticate?oauth_token=%@",_twAccessToken.request_token];
            //using a block to call the twitter login
            // should also do the UIKit thing in the main thread!
            dispatch_async(dispatch_get_main_queue(),^{
                [self performSegueWithIdentifier:@"Linkedin segue" sender:self];
            });
        }
        //TODO: error handling
        else{
        
        }
    }];
    //[accessToken userAuthorize];
    
    
}

-(void) updateTwitterUserInfo
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:_twAccessToken.user_image_url] completionHandler:^(NSURL *localFileLocation, NSURLResponse *response, NSError *error) {
        if(!error){
            CGRect buttonFrame=[_twitterLoginButton frame];
            UIView *newView = [[UIView alloc] initWithFrame:buttonFrame];
            [self.view addSubview:newView];
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonFrame.size.height,buttonFrame.size.height)];
            userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFileLocation]];
            userImage.layer.cornerRadius = 5.0f;
            [newView addSubview:userImage];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonFrame.size.height+30, 0, buttonFrame.size.width-buttonFrame.size.height-10, buttonFrame.size.height)];
            nameLabel.text = _twAccessToken.user_name;
            NSLog(@"user name is %@",_twAccessToken.user_name);
            [newView addSubview:nameLabel];
            [_twitterLoginButton removeFromSuperview];
        }
    }];
    
    [task resume];
}

-(void) getTWAccessTokenAtTrial:(NSInteger)numberOfTrial{
    if(numberOfTrial >= _twLoginRetryLimit){
        NSLog(@"error did not get user profile");
        //stop UI animation
        return;
    }
    else if(_twitterOAuthToken && _twitterOAuthTokenVerifier){
        
        //send request for access_token
        [_twAccessToken getAccessTokenWithOAuthToken:_twitterOAuthToken andOAuthVerifier:_twitterOAuthTokenVerifier withCompletionTask:^(NSURLResponse *response, NSError *error,NSString* accessToken, NSString * accessTokenSecret, NSString* screen_name, NSString* user_id){
            //NSLog(@"in login view accessToken is %@, access secret is %@, screen name is %@, user_id is %@",accessToken,accessTokenSecret,screen_name,user_id);
            //if successful
            if(!error && user_id && screen_name){
                _twAccessToken.access_token = accessToken;
                _twAccessToken.access_token_secret  = accessTokenSecret;
                
                //trigger another task to get the user profile. Only after getting the user profile data or it reaches the maximum _twLoginRetryLimit, will the it stop requesting for the user's profile.
                [_twAccessToken getUserProfileByScreenName:screen_name andUserId:user_id withCompletionTask:^(NSURLResponse *response, NSError *error,NSString *name, NSString *URLString) {
                    //NSLog(@"in the last user profile completion task");
                    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
                    //success
                    if(httpResponse.statusCode == 200 && !error && name){
                        
                        _twAccessToken.user_name = name;
                        _twAccessToken.user_image_url = URLString;
                        [_spinner stopAnimating];
                        [self showAlertViewWithTitle:@"Login" Message:@"You have successfully logged in with Twitter!"];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [self updateTwitterUserInfo];
                        NSLog(@"got user profile!!!");
                    }
                    else{
                        NSLog(@"------------refetch access token");
                        [self getTWAccessTokenAtTrial:numberOfTrial+1];
                    }
                }];
            }
        }];
        
    }
    //TODO: error handling, did not get OAuthToken
    else{
        
    }
}


#pragma mark - LinkedIn & Twitter

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Linkedin segue"]){
        //NSLog(@"about to segue");
        if([segue.destinationViewController isKindOfClass:[OAuthViewController class]]){
            OAuthViewController *webViewController = (OAuthViewController*)segue.destinationViewController;
            if(_isLinkedin){
                webViewController.isTwitter=NO;
                webViewController.isLinkedin=YES;
                webViewController.requestURL = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@",LINKEDIN_API_KEY,LINKEDIN_DEFAULT_SCOPE,LINKEDIN_DEFAULT_STATE,LINKEDIN_REDIRECT_URL];
            }
            else if(_isTwitter){
                webViewController.isLinkedin=NO;
                webViewController.isTwitter=YES;
                //NSLog(@"the redirect URL is %@",_redirectURL);
                webViewController.requestURL=_redirectURL;
                
            }
        }
    }
}

//twitter unwind method
-(IBAction)done:(UIStoryboardSegue *)segue
{
    [_spinner startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self getTWAccessTokenAtTrial:0];
    
    //NSLog(@"oauth token is %@ and verifier is %@",_twitterOAuthToken,_twitterOAuthTokenVerifier);
    //TODO: verify the _twitterOAuthToken is the same as oauth_token got in the step1.
    //if successful
    
    //NSLog(@"calling the unwind method");
    
}

#pragma mark - FB login methods

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    NSLog(@"login view fetched user info");
    NSString *profileStr = user.link;
    NSString *username = user.username;
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:profileStr] completionHandler:^(NSURL *localFileLocation, NSURLResponse *response, NSError *error) {
        if(!error){
            CGRect buttonFrame=[_profileView frame];
            //UIView *newView = [[UIView alloc] initWithFrame:buttonFrame];
            //[_profileView addSubview:newView];
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonFrame.size.height,buttonFrame.size.height)];
            userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFileLocation]];
            _profileView.layer.cornerRadius=5.0f;
            userImage.layer.cornerRadius = 5.0f;
            [_profileView addSubview:userImage];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonFrame.size.height+30, 0, buttonFrame.size.width-buttonFrame.size.height-30, buttonFrame.size.height)];
            nameLabel.text = username;
            //NSLog(@"user name is %@",_twAccessToken.user_name);
            [_profileView addSubview:nameLabel];
        }
    }];
    
    [task resume];
   
    
}
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"you are logged in as");
    
}
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"you are logged out ");
}
- (void) loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

#pragma mark - UI component respond
- (void) textFieldDidEndEditing:(UITextField *)sender
{
    if(sender == self.loginUsernameTextField){
        [sender resignFirstResponder];
    }
    else if(sender == self.loginPasswordTextField){
        [sender resignFirstResponder];
    }
    else{
        NSLog(@"text field did end editing: invalid text field");
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
    return YES;
}

- (IBAction)onLoginButtonClicked:(id)sender
{
    [self login];
}
- (IBAction)onRegisterButtonClicked:(id)sender
{
    NSLog(@"register button clicked");
}


- (IBAction)onForgetPasswordButtonClicked:(id)sender
{
    NSLog(@"forget password button clicked");
}

-(void) showAlertViewWithTitle:(NSString *)title Message:(NSString*)message{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle: @"OK"otherButtonTitles: nil];
    [alertView show];
}

#pragma mark UI gesture recognizer methods
- (IBAction)tapOutsideToDismissKeyboard:(id)sender
{
    //NSLog(@"tap gesture recognized");
    if([self.loginUsernameTextField isFirstResponder])
        [self.loginUsernameTextField resignFirstResponder];
    if([self.loginPasswordTextField isFirstResponder])
        [self.loginPasswordTextField resignFirstResponder];
}

//- (IBAction)onTwitterLoginButtonClicked:(UIButton *)sender
//{
//    //[STTwitterAPI twitterAPIAppOnlyWithConsumerName:TWITTER_CONSUMER_NAME consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
//    
//    self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
//    if(!self.twitterAPI){
//        NSLog(@"twitter API is not null");
//        NSLog(@"%@", _twitterAPI.userName);
//    }
//    
//    [_twitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken) {
//        NSLog(@"-- url: %@", url);
//        NSLog(@"-- oauthToken: %@", oauthToken);
//        
//        [[UIApplication sharedApplication] openURL:url];
//
//    } oauthCallback:@"https://dev.twitter.com/apps/new" errorBlock:^(NSError *error) {
//        NSLog(@"there is an error during token request");
//    }];
//    
//}


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitterAPI postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        /*
         At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {

        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

#pragma mark - login logic

- (void)login
{
    NSLog(@"perform login logic");
    
}

#pragma mark - view controller lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI components
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [self.view addSubview:_spinner];
    
    
    /*
     login button setup
     */
    //self.view.backgroundColor = [UIColor grayColor];
    self.loginLoginButton.backgroundColor = [UIColor blueColor];
    self.loginLoginButton.titleLabel.textColor = [UIColor whiteColor];
    self.loginLoginButton.titleLabel.text = LOGIN_LABEL;
    
    /*
     username text field setup
     */
    self.loginUsernameTextField.delegate = self;
    self.loginUsernameTextField.placeholder = LOGIN_USERNAME;
    self.loginUsernameTextField.clearsOnBeginEditing = YES;
    //self.loginUsernameTextField.clearsOnBeginEditing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
    /*
     password text field setup
     */
    self.loginPasswordTextField.delegate = self;
    self.loginPasswordTextField.placeholder = LOGIN_PASSWORD;
    self.loginPasswordTextField.clearsOnBeginEditing = YES;
    self.loginPasswordTextField.secureTextEntry = YES;
    /*
     Twitter login
     */
    
    _twitterLoginButton.frame = CGRectMake(20, 370, 280, 70);
    _twitterLoginButton.layer.cornerRadius = 10.0f;
    [_twitterLoginButton addTarget:self action:@selector(twitterLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _twLoginRetryLimit = 5;
    /*
     fb login view
     */
    
    _fbLoginView = [[FBLoginView alloc] init];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
