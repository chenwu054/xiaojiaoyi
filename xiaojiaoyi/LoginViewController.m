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
#define TWITTER_AUTHENTICATE_URL_FORMAT @"https://api.twitter.com/oauth/authenticate?oauth_token=%@"

#define LINKEDIN_API_KEY @"75iapcxav6yub5"
#define LINKEDIN_DEFAULT_SCOPE @"r_basicprofile"
#define LINKEDIN_DEFAULT_STATE @"ThisIsARandomeState"
#define LINKEDIN_REDIRECT_URL @"http://xiaojiaoyi_linkedin_redirectURL"
#define LINKEDIN_SECRET @"jUcSjy0xlLY0oaJC"
#define LINKEDIN_AUTHENTICATION_CODE_BASE_URL @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code"

#define LK_ACCESS_TOKEN @"access_token"
#define LK_EXPIRES_IN @"expires_in"
#define LK_REQUEST_TOKEN @"request_token"
#define LK_CALLBACK_CODE @"callback_code"

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
@property (nonatomic) IBOutlet UIButton *fbButton;
@property (nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (nonatomic) IBOutlet UIButton *ggLoginButton;


@property (nonatomic) NSString* redirectURL;
@property (nonatomic) NSURLSession * session;

//google private properties
@property (nonatomic) GPPSignIn *ggSignIn;
@property (nonatomic) BOOL isGGLoggedin;
@property (nonatomic) GPPSignInButton *ggSignInButton;

//linkedin private properties
@property (nonatomic) BOOL isLKLogggedin;
@property (nonatomic) NSString *lkAccessToken;
@property (nonatomic) NSString *lkExpiresIn;
@property (nonatomic) NSMutableDictionary* lkParams;

//facebook properties
@property (nonatomic) BOOL isFBLoggedin;
@property (nonatomic) MyFBSessionTokenCachingStrategy *myFBTokenCachingStrategy;
//twitter properties
@property (nonatomic) BOOL isTWLoggedin;
@property (nonatomic) NSString *twRedirectURL;


@end

@implementation LoginViewController

static NSString * const kClientId = @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";
//google OAuth login client ID
//static NSString * const kClientId= @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";
#pragma mark - login work methods
-(void)removeProfileViewOfOAuthType:(MyOAuthLoginType)oauthType
{
    CGFloat lowerBound;
    CGFloat width = _profileView.frame.size.height;
    switch (oauthType) {
        case FACEBOOK:
            lowerBound = 0 * width;
            break;
        case TWITTER:
            lowerBound = 1 * width;
            break;
        case LINKEDIN:
            lowerBound = 2 * width;
            break;
        case GOOGLE:
            lowerBound = 3 * width;
            break;
        default:
            return;
    }
    NSArray *subviews = [_profileView subviews];
    for(int i=0;i<subviews.count;i++){
        UIView *view = subviews[i];
        CGFloat originX = view.frame.origin.x;
        if(originX >= lowerBound && originX - lowerBound <= width){
            [view removeFromSuperview];
            return;
        }
    }
}
//====================================
-(GPPSignIn *)getGGSignIn
{
    if(!_ggSignIn){
        _ggSignIn=[GPPSignIn sharedInstance];
    }
    return _ggSignIn;
}
-(void)ggLoginSetup
{
    [self getGGSignIn];
    _ggSignIn.delegate = self;
    _ggSignIn.clientID = kClientId;
    _ggSignIn.scopes = @[ kGTLAuthScopePlusLogin, @"profile"];
    [_ggLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    _ggSignInButton=[[GPPSignInButton alloc] init];
    _ggSignIn.shouldFetchGooglePlusUser = YES;
    _ggSignIn.shouldFetchGoogleUserID = YES;
    _ggSignIn.shouldFetchGoogleUserEmail = YES;
    [self updateGGButton];
    
}
- (IBAction)ggLoginButtonClicked:(id)sender
{
    NSLog(@"google button clicked");
    [_spinner startAnimating];
    if(_ggSignIn.authentication){
        [self ggDisconnect];
        //[self ggSignOut];
    }
    else{
        [_ggSignInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    //[self update];
    
}
-(void)updateGGButton
{
    //NSLog(@"calling update");
    _ggSignIn = [self getGGSignIn];
    if(_ggSignIn.authentication){
        //NSLog(@"update google button after sign in");
        [_ggLoginButton setTitle:@"sign out" forState:UIControlStateNormal];
        _isGGLoggedin = YES;
    }
    else{
        //NSLog(@"update google button after sign out");
        [_ggLoginButton setTitle:@"sign in" forState:UIControlStateNormal];
        [self setGGUserProfilePicture:nil];
        _isGGLoggedin=NO;
    }
    
}
-(void)ggSignOut
{
    [[self getGGSignIn] signOut];
    [self setGGUserProfilePicture:nil];
    [self updateGGButton];
}
-(void)ggDisconnect
{
    [[self getGGSignIn] disconnect];

}
//google sign in delegate methods
-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if(error){
        [self showGGAlertView:error.description];
    }
    else{
//        NSLog(@"the auth is %@",auth);
//        NSDictionary* params = _ggSignIn.authentication.parameters;
//        for(NSString *key in params){
//            NSLog(@"key is %@ and value is %@",key,[params valueForKey:key]);
//        }
        GTLPlusPerson *user =  _ggSignIn.googlePlusUser;
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(backgroundQueue, ^{
            NSData *avatarData = nil;
            NSString *imageURLString = user.image.url;
            if (imageURLString){
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                avatarData = [NSData dataWithContentsOfURL:imageURL];
            }
            if (avatarData) {
                // Update UI from the main thread when available
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setGGUserProfilePicture:avatarData];
                });
            }
        });
        [self updateGGButton];
    }
    [_spinner stopAnimating];
}
-(void)setGGUserProfilePicture:(NSData*)data
{
    if(!data){
        [self removeProfileViewOfOAuthType:GOOGLE];
    }
    else{
        CGFloat height = _profileView.frame.size.height;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3*height, 0, height, height)];
        imageView.image = [UIImage imageWithData:data];
        [_profileView addSubview:imageView];
    }
}

-(void)didDisconnectWithError:(NSError *)error
{
    if (error) {
        [self showGGAlertView:error.description];
        
    }
    else {
        _ggSignIn = [GPPSignIn sharedInstance];
        [self removeProfileViewOfOAuthType:GOOGLE];
    }
    [self updateGGButton];
    [_spinner stopAnimating];
}

-(void)showGGAlertView:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    
}




//======================================
#pragma mark - twitter login methods
-(void)twitterLoginButtonClicked:(UIButton*)sender
{
    if(!_isTWLoggedin)
    {
        //1. load local cache
        [SessionManager loadTWSession];
        TWSession *twSession = [SessionManager twSession];
        if(twSession.access_token){
            NSString *userImageURL = twSession.user_image_url;
            //NSLog(@"the cached user image url is %@",userImageURL);
            
            [_twitterLoginButton setTitle:@"logout twitter" forState:UIControlStateNormal];
            _isTWLoggedin=YES;
            [self updateTwitterUserInfoWithImageURL:userImageURL withTrialNumber:0];
        }
        //2. startTWLoginByRequestToken
        else
            [self startTWLoginByRequestToken];
        
    }
    else{
        [self logoutTW];
    }
    
}

-(void)logoutTW
{
    [self removeProfileViewOfOAuthType:TWITTER];
    [_twitterLoginButton setTitle:@"login with Twitter" forState:UIControlStateNormal];
    _isTWLoggedin = NO;
}
-(void)startTWLoginByRequestToken
{
    if(!_twSession)
        _twSession = [SessionManager twSession];
    
    [_twSession getRequestTokenWithCompletionTask:^(BOOL success, NSURLResponse *response, NSError *error){
        if(success){
            _isTwitter = YES;
            _isLinkedin = NO;
            _twRedirectURL = [NSString stringWithFormat:TWITTER_AUTHENTICATE_URL_FORMAT,_twSession.request_token];
            //NSLog(@"the redirect url is %@",_redirectURL);
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
}

//twitter unwind method
-(IBAction)done:(UIStoryboardSegue *)segue
{

    //user cancelled
    if(_isTwitter && _twSession.oauth_verifier){
        [_spinner startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self getTWAccessTokenAtTrial:0];
    }
    else if(_isLinkedin && _lkCallbackCode){
        //
        //NSLog(@"going to call request access_token");
        [self getLKAccessTokenWithCode];
        
    }
}

-(void) getTWAccessTokenAtTrial:(NSInteger)numberOfTrial{
    if(numberOfTrial >= _twLoginRetryLimit){
        NSLog(@"error: exceeded trial limit and did not get user profile");
        [_spinner stopAnimating];
        [[[UIAlertView alloc] initWithTitle:@"check your internet connection"
                                    message:@"Could not obtain access token, please try again"
                                   delegate:nil
                          cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        //stop UI animation
        return;
    }
    else if(_twSession.oauth_verifier_token && _twSession.oauth_verifier){
        //send request for access_token
        [_twSession getAccessTokenWithOAuthToken:_twSession.oauth_verifier_token andOAuthVerifier:_twSession.oauth_verifier withCompletionTask:^(NSURLResponse *response, NSError *error,NSString* accessToken, NSString * accessTokenSecret, NSString* screen_name, NSString* user_id){
            //NSLog(@"in login view accessToken is %@, access secret is %@, screen name is %@, user_id is %@",accessToken,accessTokenSecret,screen_name,user_id);
            //if successful
            if(!error && user_id && screen_name){
                _twSession.access_token = accessToken;
                _twSession.access_token_secret  = accessTokenSecret;
                
                //trigger another task to get the user profile. Only after getting the user profile data or it reaches the maximum _twLoginRetryLimit, will the it stop requesting for the user's profile.
                [_twSession getUserProfileByScreenName:screen_name andUserId:user_id withCompletionTask:^(NSURLResponse *response, NSError *error,NSString *name, NSString *URLString) {
                    //NSLog(@"in the last user profile completion task");
                    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
                    //success
                    if(httpResponse.statusCode == 200 && !error && name){
                        
                        _twSession.user_name = name;
                        _twSession.user_image_url = URLString;
                        [_spinner stopAnimating];
                        [self showAlertViewWithTitle:@"Login" Message:@"You have successfully logged in with Twitter!"];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [self updateTwitterUserInfoWithImageURL:_twSession.user_image_url withTrialNumber:0];
                        _isTWLoggedin=YES;
                        [SessionManager writeTWSessionCache:nil];
                        [_twitterLoginButton setTitle:@"logout twitter" forState:UIControlStateNormal];
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

-(void) updateTwitterUserInfoWithImageURL:(NSString*)imageURL withTrialNumber:(NSInteger)num
{
    if(num>_twLoginRetryLimit){
        NSLog(@"ERROR: failed to download the user image");
        [_spinner stopAnimating];
        return;
    }
    NSURLSession * session = [NSURLSession sharedSession];
    [_spinner startAnimating];
    //may need to remove existing twitter profile picture first
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSURL *localFileLocation, NSURLResponse *response, NSError *error) {
        if(!error){
            CGRect profileFrame=[_profileView frame];
            NSData *imageData=[NSData dataWithContentsOfURL:localFileLocation];
            UIImage * image = [UIImage imageWithData:imageData];
            if(!image){
                [self updateTwitterUserInfoWithImageURL:imageURL withTrialNumber:num+1];
                return;
            }
            //NSLog(@"the image is %@ and url is %@",userImage.image,localFileLocation);
            dispatch_async(dispatch_get_main_queue(), ^{
                //remove current profile picture
                //[self removeProfileViewOfOAuthType:TWITTER];
                // add new picture
                UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((2*2.0 + profileFrame.size.height), 0, profileFrame.size.height,profileFrame.size.height)];
                userImage.layer.cornerRadius = 5.0f;
                userImage.image=image;
                [_profileView addSubview:userImage];
                [_spinner stopAnimating];
                
                //!!write to local file
                //[SessionManager writeProfileImage:imageData];
            });
        }
    }];

    [task resume];
}

#pragma mark - LinkedIn & Twitter

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Linkedin segue"]){
        //NSLog(@"about to segue");
        if([segue.destinationViewController isKindOfClass:[OAuthViewController class]]){
            OAuthViewController *webViewController = (OAuthViewController*)segue.destinationViewController;
            if(_isTwitter){
                webViewController.isLinkedin=NO;
                webViewController.isTwitter=YES;
                //NSLog(@"the redirect URL is %@",_redirectURL);
                webViewController.requestURL=_twRedirectURL;
                
            }
            else{
                if(!_isLKLogggedin){
                    _isLinkedin=YES;
                    _isTwitter = NO;
                    webViewController.isTwitter=NO;
                    webViewController.isLinkedin=YES;
                    webViewController.requestURL = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@",LINKEDIN_API_KEY,LINKEDIN_DEFAULT_SCOPE,LINKEDIN_DEFAULT_STATE,LINKEDIN_REDIRECT_URL];
                }
            }

        }
    }
}


//==============================================================
#pragma mark - linkedin methods
-(void)getLKAccessTokenWithCode
{
    //NSLog(@"calling the lk request access token");
    NSString *accessTokenRequest = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",_lkCallbackCode,LINKEDIN_REDIRECT_URL,LINKEDIN_API_KEY,LINKEDIN_SECRET];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithURL:[NSURL URLWithString:accessTokenRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        _lkExpiresIn =[result valueForKeyPath:@"expires_in"];
        _lkAccessToken =[result valueForKeyPath:@"access_token"];
        //NSLog(@"expires_in is %@, access_token is %@",_lkExpiresIn,_lkAccessToken);
        _lkParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_lkExpiresIn,LK_EXPIRES_IN,
                                _lkAccessToken,LK_ACCESS_TOKEN,
                                _lkCallbackCode,LK_CALLBACK_CODE,
                                nil];
        [self getLKUserProfile];
        [self getLKUserProfilePicture];
        
    }];
    [task resume];
}
-(void)getLKUserProfile
{
    NSString *urlStr =[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?format=json&oauth2_access_token=%@",_lkAccessToken];
    //NSLog(@"the url is %@",urlStr);
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            //NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"the result is %@",result);
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"user data is %@",userData);
            [_lkParams addEntriesFromDictionary:userData];
            
        }
        
    }];
    [task resume];
}

-(void)getLKUserProfilePicture
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_spinner startAnimating];
    });
    //NSString *userURL = [userData valueForKey:@"siteStandardProfileRequest"];
    NSString *urlStr=[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(%@)?format=json&oauth2_access_token=%@",@"picture-url",_lkAccessToken];
    //NSLog(@"the url string for profile picture is %@",urlStr);
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [_lkParams addEntriesFromDictionary:result];
            NSString *userPicURL = [result valueForKey:@"pictureUrl"];
            [self downloadUserProfilePicture:userPicURL];
            //NSLog(@"result is %@",result);
        }
        else{
            NSLog(@"error is %@",error);
        }
        
    }];
    [task resume];
}
-(void)downloadUserProfilePicture:(NSString *)userPicURL
{
    NSString *urlStr=userPicURL;
    //NSLog(@"the url string for profile picture is %@",urlStr);
    //[_spinner startAnimating];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!error){
            CGFloat height = _profileView.frame.size.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*2.0 + 2*height, 0, height, height)];
                imageView.image = image;
                [_profileView addSubview:imageView];
                [_spinner stopAnimating];
            });
        }
        else{
            NSLog(@"error is %@",error);
        }
        
        [SessionManager writeLKSessionCache:_lkParams];
        [_spinner stopAnimating];
        
    }];
    [task resume];
}

-(void)linkedinLoginTask
{
    [_loginLinkedinButton setTitle:@"logout" forState:UIControlStateNormal];
    _isLKLogggedin = YES;
    
}
-(void)refreshLKAccessToken
{
    
}
- (IBAction)linkedinButtonClicked:(id)sender
{
    if(_isLKLogggedin){
        [_loginLinkedinButton setTitle:@"login Linkedin" forState:UIControlStateNormal];
        _isLKLogggedin = NO;
    }
    else{
        _isLinkedin=YES;
        _isTwitter = NO;
    }
    
}



//====================================================================
#pragma mark - FB login methods
- (IBAction)fbLoginButtonClicked:(id)sender {
    //NSLog(@"fb button clicked");
    if(!_isFBLoggedin){
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
            _isFBLoggedin = YES;
            
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
        _isFBLoggedin = NO;
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

//=====================================================================
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
//    [SessionManager refreshFBSessionFromLocalCacheWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        NSLog(@"3. the session is %@",session);
//    }];
    
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


//=================================================================
#pragma mark - login logic

- (void)login
{
    
    NSLog(@"perform login logic");
}


//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
//    BOOL openSessionResult = NO;
//    // Set up token strategy, if needed
//    if (nil == _myFBTokenCachingStrategy) {
//        _myFBTokenCachingStrategy = [[MyFBSessionTokenCachingStrategy alloc] init];
//    }
//    // Initialize a session object with the tokenCacheStrategy
//    NSLog(@"initial in before open session, state is: %@", FBSession.activeSession);
//    FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:@[@"public_profile"]
//                                          urlSchemeSuffix:nil
//                                       tokenCacheStrategy:_myFBTokenCachingStrategy];
//    [FBSession setActiveSession:session];
//    NSLog(@"initial in open session, state is: %@", FBSession.activeSession);
//    //    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//    //        NSLog(@"");
//    //    }];
//    
//    // If showing the login UI, or if a cached token is available,
//    // then open the session.
//    if (allowLoginUI || session.state == FBSessionStateCreatedTokenLoaded) {
//        // For debugging purposes log if cached token was found
//        if (session.state == FBSessionStateCreatedTokenLoaded){
//            NSLog(@"Cached token found.");
//        }
//        // Set the active session
//        [FBSession setActiveSession:session];
//        // Open the session.
//        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
//                completionHandler:^(FBSession *session,
//                                    FBSessionState state,
//                                    NSError *error) {
//                    [self sessionStateChanged:session
//                                        state:state
//                                        error:error];
//                }];
//        // Return the result - will be set to open immediately from the session
//        // open call if a cached token was previously found.
//        openSessionResult = session.isOpen;
//    }
//    return openSessionResult;
//}


//=================================================================
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
    
    _twSession = [SessionManager twSession];
    
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
     google plus login
     */
    [self ggLoginSetup];
    
    
    /*
     Twitter login
     */
    _twitterLoginButton.frame = CGRectMake(20, 370, 280, 70);
    _twitterLoginButton.layer.cornerRadius = 10.0f;
    [_twitterLoginButton addTarget:self action:@selector(twitterLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _twLoginRetryLimit = 5;
    _isTWLoggedin = NO;
    /*
     fb login view
     */

    //xjyAppDelegate * app = [UIApplication sharedApplication].delegate;
    //app.sessionManager=_sessionManager;
    _isFBLoggedin =NO;
    _fbButton.titleLabel.text = @"login";
    
    //[self FBSetup];
    //[self openSessionWithAllowLoginUI:NO];
    
    /*
     Linkedin login
     */
    _isLKLogggedin = NO;
    
    
}

-(NSMutableDictionary*) parseResponseData:(NSString*)string
{
    NSArray *compnents = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for(int i=0;i<compnents.count;i++){
        NSString *subString = compnents[i];
        NSArray * keyVal = [subString componentsSeparatedByString:@"="];
        [dict setValue:keyVal[1] forKey:keyVal[0]];
    }
    return dict;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
