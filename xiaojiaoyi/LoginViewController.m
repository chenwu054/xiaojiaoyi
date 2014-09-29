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
#define PROFILE_VIEW_HEIGHT 30;
#define PROFILE_VIEW_WIDTH 130;
#define PROFILE_SEPARATION (PROFILE_VIEW_WIDTH-4*PROFILE_VIEW_HEIGHT)/5;

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
//@property  (nonatomic) IBOutlet FBLoginView *fbLoginView;

@property (nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (strong, nonatomic) STTwitterAPI * twitterAPI;
@property (nonatomic) NSString* redirectURL;
@property (nonatomic) NSURLSession * session;
@property (nonatomic) BOOL isFBLogedin;

@end

@implementation LoginViewController

//google OAuth login client ID
//static NSString * const kClientId= @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";
#pragma mark - login work methods



//======================================

-(void) setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier
{
    
}

#pragma mark - twitter login methods
-(void)twitterLoginButtonClicked:(UIButton*)sender
{
    //NSLog(@"twitterLoginButton clicked");
    _twAccessToken = [[TWSession alloc] init];
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
                webViewController.isFacebook=NO;
                webViewController.requestURL = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@",LINKEDIN_API_KEY,LINKEDIN_DEFAULT_SCOPE,LINKEDIN_DEFAULT_STATE,LINKEDIN_REDIRECT_URL];
            }
            else if(_isTwitter){
                webViewController.isLinkedin=NO;
                webViewController.isTwitter=YES;
                webViewController.isFacebook=NO;
                //NSLog(@"the redirect URL is %@",_redirectURL);
                webViewController.requestURL=_redirectURL;
                
            }
            else if(_isFacebook){
                NSLog(@"isFacebook");
                webViewController.isLinkedin=NO;
                webViewController.isFacebook=YES;
                webViewController.isTwitter=NO;
                webViewController.requestURL=@"https://www.facebook.com/dialog/oauth?client_id=337462276428867&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=public_profile,email";
                
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
- (IBAction)fbLoginButtonClicked:(id)sender {
    //NSLog(@"fb button clicked");
    if(!_isFBLogedin){
        [self testFBLogin];
    }
    else{
        [self testFBLogout];
    }
}

-(void) testFBLogin
{
    
    [SessionManager loginFacebookWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        //NSLog(@"session state is %@",session);
        if(status != FBSessionStateOpen && status != FBSessionStateOpenTokenExtended){
            NSLog(@"FB login failed or logged out");
        }
        else{
            [_fbButton setTitle:@"logout" forState:UIControlStateNormal];
            [_fbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _isFBLogedin = YES;
            
            [_spinner startAnimating];
            //FB request to get the profile information.
            FBSession.activeSession = [SessionManager fbSession];
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSDictionary * dict = (NSDictionary *)result;
                NSString * idStr = [dict valueForKey:@"id"];
                NSLog(@"id is %@ ", idStr);
                
                //download the profile data
                //check internet, if suddenly no internet for fetching profile picture, still login but no profile picture/or use local cache.
                NSURLSession *urlSession = [NSURLSession sharedSession];
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",idStr]];
                NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, _profileView.frame.size.height, _profileView.frame.size.height)];
                    imageView.image = image;
                    [_profileView addSubview:imageView];
                    [_spinner stopAnimating];
                    
                    //should write to local file and cache it.
                }];
                [task resume];
                
            }];
        }
    }];
}

-(void)testFBLogout
{
    [self showFBActionSheet];
    
}
-(void)fbLogoutUpdate:(FBSession*) session
{
    if(session.state != FBSessionStateOpen && session.state != FBSessionStateOpenTokenExtended){
        [_fbButton setTitle:@"login" forState:UIControlStateNormal];
        [_fbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _isFBLogedin = NO;
    }
    else
        NSLog(@"logout failed");
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [SessionManager logoutFacebookCleanCache:NO revokePermissions:NO WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self fbLogoutUpdate:session];
        }];
    }
    else if(buttonIndex == 1){
        [SessionManager logoutFacebookCleanCache:YES revokePermissions:NO WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self fbLogoutUpdate:session];
        }];
    }
    else if(buttonIndex == 2){
        [_spinner startAnimating];
        [SessionManager logoutFacebookCleanCache:YES revokePermissions:YES WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self fbLogoutUpdate:session];
            [_spinner stopAnimating];
        }];
    }
    else if(buttonIndex == 3){
        return;
    }
   // NSLog(@"action sheet at %ld is clicked",buttonIndex);
}
    


-(void)showFBActionSheet
{
    UIActionSheet * aSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"logout",@"logout & clean cache",@"logout & revoke permissions", nil];
    [aSheet showInView:self.view];
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    NSLog(@"login view fetched user info");
    
}



- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"In Login view, FB session state changed to %@", session);
    
    
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
    [SessionManager refreshFBSessionFromLocalCacheWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"3. the session is %@",session);
    }];
    
    //[self login];
}


// this method is temporarily used for revoking FB permissions
- (IBAction)onRegisterButtonClicked:(id)sender
{
    [SessionManager logoutFacebook];
    
}

//temparorily used as enumerator of files
- (IBAction)onForgetPasswordButtonClicked:(id)sender
{
    [SessionManager loginFacebook];
    
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

#pragma mark - login logic

- (void)login
{
    
    NSLog(@"perform login logic");
}


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    BOOL openSessionResult = NO;
    // Set up token strategy, if needed
    if (nil == _myFBTokenCachingStrategy) {
        _myFBTokenCachingStrategy = [[MyFBSessionTokenCachingStrategy alloc] init];
    }
    // Initialize a session object with the tokenCacheStrategy
    NSLog(@"initial in before open session, state is: %@", FBSession.activeSession);
    FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:@[@"public_profile"]
                                          urlSchemeSuffix:nil
                                       tokenCacheStrategy:_myFBTokenCachingStrategy];
    [FBSession setActiveSession:session];
    NSLog(@"initial in open session, state is: %@", FBSession.activeSession);
    //    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    //        NSLog(@"");
    //    }];
    
    // If showing the login UI, or if a cached token is available,
    // then open the session.
    if (allowLoginUI || session.state == FBSessionStateCreatedTokenLoaded) {
        // For debugging purposes log if cached token was found
        if (session.state == FBSessionStateCreatedTokenLoaded){
            NSLog(@"Cached token found.");
        }
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session.
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                completionHandler:^(FBSession *session,
                                    FBSessionState state,
                                    NSError *error) {
                    [self sessionStateChanged:session
                                        state:state
                                        error:error];
                }];
        // Return the result - will be set to open immediately from the session
        // open call if a cached token was previously found.
        openSessionResult = session.isOpen;
    }
    return openSessionResult;
}

#pragma mark - view controller lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI components
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    _spinner.frame = self.view.frame;
    _spinner.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    
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

    //xjyAppDelegate * app = [UIApplication sharedApplication].delegate;
    //app.sessionManager=_sessionManager;
    _isFBLogedin =NO;
    _fbButton.titleLabel.text = @"login";
    
    //[self FBSetup];
    //[self openSessionWithAllowLoginUI:NO];
    
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
