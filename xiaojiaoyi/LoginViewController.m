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

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    NSLog(@"login view fetched user info");
    
//    NSString *profileStr = user.link;
//    NSString *username = user.username;
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:profileStr] completionHandler:^(NSURL *localFileLocation, NSURLResponse *response, NSError *error) {
//        if(!error){
//            CGRect buttonFrame=[_profileView frame];
//            //UIView *newView = [[UIView alloc] initWithFrame:buttonFrame];
//            //[_profileView addSubview:newView];
//            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonFrame.size.height,buttonFrame.size.height)];
//            userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFileLocation]];
//            _profileView.layer.cornerRadius=5.0f;
//            userImage.layer.cornerRadius = 5.0f;
//            [_profileView addSubview:userImage];
//            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonFrame.size.height+30, 0, buttonFrame.size.width-buttonFrame.size.height-30, buttonFrame.size.height)];
//            nameLabel.text = username;
//            //NSLog(@"user name is %@",_twAccessToken.user_name);
//            [_profileView addSubview:nameLabel];
//        }
//    }];
//    
//    [task resume];
   
    
}
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"you are logged in as");
    
}
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    
    NSLog(@"you are logged out ");
    
    
    
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"In Login view, FB session state changed to %@", session);
    
    
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
// this method is temporarily used for revoking FB permissions
- (IBAction)onRegisterButtonClicked:(id)sender
{
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions/public_profile" parameters:nil HTTPMethod:@"delete"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              __block NSString *alertText;
                              __block NSString *alertTitle;
                              NSDictionary * dict = (NSDictionary*)result;//[NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
                              
                              NSLog(@"dict is %@",dict);
                              NSString * value = [dict valueForKeyPath:@"success"];
                              NSLog(@"value is %@",value);
                              if (!error ) {
                                  // Revoking the permission worked
                                  alertTitle = @"Permission successfully revoked";
                                  alertText = @"This app will no longer post to Facebook on your behalf.";
                                  
                              } else {
                                  NSLog(@"error is %@",error);
                                  NSLog(@"request is %@",connection);
                                  NSLog(@"result is %@",result);
                                  // There was an error, handle it
                                  // See https://developers.facebook.com/docs/ios/errors/
                              }
                              
                              [[[UIAlertView alloc] initWithTitle:alertTitle
                                                          message:alertText
                                                         delegate:self
                                                cancelButtonTitle:@"OK!"
                                                otherButtonTitles:nil] show];
                          }];
    
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    //NSLog(@"%@",[userDefault dictionaryRepresentation]);
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    NSDictionary * dict = [userDefault dictionaryRepresentation];
//    
//    NSLog(@"user default's value for FBAccessToken: %@",[dict valueForKeyPath:@"FBAccessToken"]);
//    FBSession * session = FBSession.activeSession;
//    NSLog(@"now session state is: %@",session);
//    
//    [userDefault removeObjectForKey:@"FBAccessTokenInformationKeyUUID"];
//    [userDefault synchronize];
//    
//    NSLog(@"after delete, the defaults is %@", [userDefault objectForKey:@"FBAccessTokenInformationKeyUUID"]);
    

//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        NSString *domainName = [cookie domain];
//        NSRange domainRange = [domainName rangeOfString:@"facebook"];
//        if(domainRange.length > 0) {
//            [storage deleteCookie:cookie];
//        }
//    }
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

#pragma mark - login logic

- (void)login
{
    
    NSLog(@"perform login logic");
}


-(void) FBSetup
{
    FBSessionTokenCachingStrategy *myStratety = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:@"FBAccessToken"];
    FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:myStratety];
    
    //NSLog(@"initial session state is: %@",session);
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDefault dictionaryRepresentation];
    //NSLog(@"user default: %@",dict);
    NSLog(@"user default's value for FBAccessToken: %@",[dict valueForKeyPath:@"FBAccessToken"]);
    if (session.state ==FBSessionStateCreated || session.state == FBSessionStateCreatedTokenLoaded) {
        // For debugging purposes log if cached token was found
        if (session.state == FBSessionStateCreatedTokenLoaded) {
            NSLog(@"Cached token found.");
        }
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session.
        [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState state,
                                    NSError *error) {
                    [self sessionStateChanged:session
                                        state:state
                                        error:error];
                }];
        NSLog(@"after opening session state is: %@",session);
        // Return the result - will be set to open immediately from the session
        // open call if a cached token was previously found.
    }
    
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];

        NSLog(@"after calling close and clear token information in the viewDidLoad");
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        NSLog(@"if not open, the activeSession state is: %@",FBSession.activeSession);
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             xjyAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
    
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
    
    self.fbLoginView = [[FBLoginView alloc] init];
   
    _fbLoginView.delegate = self;
    
   // [self FBSetup];

    //NSString * FBtoken = [userDefault stringForKey:@"FBAccessTokenInformationKey"];
    //NSLog(@"fb token is %@",FBtoken);
//    /NSLog(@"active session is open ? %d",[FBSession.activeSession isOpen]);

//    if(!FBSession.activeSession.isOpen){
//        NSLog(@"is not open");
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//            NSLog(@"in the completion handler");
//            if(status == FBSessionStateClosedLoginFailed || status == FBSessionStateClosed)
//                NSLog(@"session state is failded");
//            else if(status == FBSessionStateCreated)
//                NSLog(@"status is created");
//            else if(status == FBSessionStateOpen || status == FBSessionStateOpenTokenExtended)
//                NSLog(@"status is open");
//            else if(status ==FBSessionStateCreatedTokenLoaded)
//                NSLog(@"status is token loaded");
//            else if(status ==FBSessionStateCreatedOpening)
//                NSLog(@"status is created opening");
//            
//        }];
//    }
    
    
//    
//    if(FBSession.activeSession ==nil){
//        NSLog(@"active session is nil");
//    }
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//        
//        // Close the session and remove the access token from the cache
//        // The session state handler (in the app delegate) will be called automatically
//        NSLog(@"calling the clear method");
//        [FBSession.activeSession closeAndClearTokenInformation];
//        [FBSession.activeSession close];
//        [FBSession setActiveSession:nil];
//        NSLog(@"session now is: %@", FBSession.activeSession);
//        
//    }
//    else if (FBSession.activeSession.state == FBSessionStateClosed || FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//    }
    
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
