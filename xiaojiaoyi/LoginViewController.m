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
#define TWITTER_AUTHORIZE_URL_FORMAT @"https://api.twitter.com/oauth/authorize?oauth_token=%@"

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
#define LK_PROFILE_URL @"pictureUrl"

#define PROFILE_VIEW_HEIGHT 30
#define PROFILE_VIEW_WIDTH 130
#define PROFILE_SEPARATION (PROFILE_VIEW_WIDTH-4*PROFILE_VIEW_HEIGHT)/5

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *loginForgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginLinkedinButton;

@property (weak, nonatomic) IBOutlet UILabel *loginProceedLabel;
@property (nonatomic) UIActivityIndicatorView* spinner;

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
@property (nonatomic) UIActionSheet* ggActionSheet;
@property (nonatomic) BOOL ggButtonClicked;

//linkedin private properties
@property (nonatomic) BOOL isLKLogggedin;
@property (nonatomic) NSString *lkAccessToken;
@property (nonatomic) NSString *lkExpiresIn;
@property (nonatomic) NSMutableDictionary* lkParams;
@property (nonatomic) UIActionSheet* lkLogoutActionSheet;

//facebook properties
@property (nonatomic) BOOL isFBLoggedin;
@property (nonatomic) MyFBSessionTokenCachingStrategy *myFBTokenCachingStrategy;
@property (nonatomic) BOOL toLogoutFB;
@property (nonatomic) UIActionSheet* fbLogoutActionSheet;

//twitter properties
@property (nonatomic) BOOL isTWLoggedin;
@property (nonatomic) NSString *twRedirectURL;
@property (nonatomic) UIActionSheet* twLogoutActionSheet;
@property (nonatomic) NSMutableArray* twUploadMediaArray;

@end

@implementation LoginViewController

static NSString * const kClientId = @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";
//google OAuth login client ID
//static NSString * const kClientId= @"100128444749-l3hh0v0as5n6t4rnp3maciodja4oa4nc.apps.googleusercontent.com";
#pragma mark - login work methods
-(void)removeProfileViewOfOAuthType:(MyOAuthLoginType)oauthType
{
    CGFloat lowerBound;
    CGFloat width = self.profileView.frame.size.height;
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
    NSArray *subviews = [self.profileView subviews];
    for(int i=0;i<subviews.count;i++){
        UIView *view = subviews[i];
        CGFloat originX = view.frame.origin.x;
        if(originX >= lowerBound && originX - lowerBound < width){
            [view removeFromSuperview];
            //return;
        }
    }
}
//====================================
#pragma mark - google plus methods
-(UIActionSheet*)ggActionSheet
{
    if(!_ggActionSheet){
        _ggActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout",@"Logout and revoke permissions", nil];
    }
    return _ggActionSheet;
}
-(GPPSignIn *)ggSignIn
{
    if(!_ggSignIn){
        _ggSignIn=[GPPSignIn sharedInstance];
        _ggSignIn.delegate = self;
        _ggSignIn.clientID = kClientId;
        _ggSignIn.scopes = @[ kGTLAuthScopePlusLogin, @"profile"];
        _ggSignIn.shouldFetchGooglePlusUser = YES;
        _ggSignIn.shouldFetchGoogleUserID = YES;
        _ggSignIn.shouldFetchGoogleUserEmail = YES;
    }
    return _ggSignIn;
}
-(GPPSignInButton*)ggSignInButton
{
    if(!_ggSignInButton){
        _ggSignInButton=[[GPPSignInButton alloc] init];
    }
    return _ggSignInButton;
}
-(void)ggLoginSetup
{
    self.ggButtonClicked=NO;
    [self.ggSignIn trySilentAuthentication];
    //[_ggLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self updateGGButton];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[UserObject currentUserGGProfileURL].path]){
        NSData* ggProfileData = [NSData dataWithContentsOfURL:[UserObject currentUserGGProfileURL]];
        [self setGGUserProfilePicture:ggProfileData];
    }

}
- (IBAction)ggLoginButtonClicked:(id)sender
{
    NSLog(@"google button clicked");
    [self.spinner startAnimating];
    if(self.ggSignIn.authentication || [UserObject currentUser].ggLogin){
        NSLog(@"authenticated");
        [self.ggActionSheet showInView:self.view];
        //[self ggDisconnect];
        //[self ggSignOut];
    }
    else{
        self.ggButtonClicked=YES;
        [self.ggSignInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    //[self update];
    
}
-(void)updateGGButton
{
    //NSLog(@"calling update");
    if(self.ggSignIn.authentication || [UserObject currentUser].ggLogin){
        //NSLog(@"update google button after sign in");
        [_ggLoginButton setTitle:@"Logout Google+" forState:UIControlStateNormal];
        _isGGLoggedin = YES;
    }
    else{
        //NSLog(@"update google button after sign out");
        [_ggLoginButton setTitle:@"Login Google+" forState:UIControlStateNormal];
        [self setGGUserProfilePicture:nil];
        _isGGLoggedin=NO;
    }
}

-(void)ggSignOut
{
    [self.ggSignIn  signOut];
    if([self.spinner isAnimating]){
        [self.spinner stopAnimating];
    }
    [UserObject currentUser].ggLogin=NO;
    [self updateGGButton];
    //write the gg user logout to file
    [UserObject updateUserObjectToFile:nil];
}
-(void)ggSignOutAndRemokePermissions
{
    if(self.ggSignIn.authentication){
        [self.ggSignIn disconnect];
        [UserObject updateUserObjectToFile:nil];
    }
    else{
        NSLog(@"to Revoke Permission, you need to sign in first");
    }
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
        
        //silent login will not trigger updating currentUser and writing to file
        if(self.ggButtonClicked){
            GTLPlusPerson *user =  self.ggSignIn.googlePlusUser;
            
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
                    //write to the file
                    NSURL* ggProfileURL = [UserObject currentUserGGProfileURL];
//                    NSData* originalData=[NSData dataWithContentsOfURL:ggProfileURL];
                    
//                    if([UIImage imageWithData:originalData] != [UIImage imageWithData:avatarData]){
//                        NSLog(@"updating Google Plus Profile to File");
                        [avatarData writeToURL:ggProfileURL atomically:YES];
//                    }
//                    else{
//                        NSLog(@"NOT updating Google Plus Profile to File");
//                    }
                }
                else{
                    if([[NSFileManager defaultManager] fileExistsAtPath:[UserObject currentUserGGProfileURL].path]){
                        NSData* ggProfileData = [NSData dataWithContentsOfURL:[UserObject currentUserGGProfileURL]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setGGUserProfilePicture:ggProfileData];
                        });
                    }
                }
            });

            UserObject* currentUser = [UserObject currentUser];
            currentUser.ggUsername = user.displayName;
            currentUser.ggProfileURL=user.image.url;
            currentUser.ggAccessToken=self.ggSignIn.authentication.accessToken;
            currentUser.ggExpireDate=self.ggSignIn.authentication.expirationDate;
            currentUser.ggLogin=YES;
            [UserObject updateUserObjectToFile:nil];
            self.ggButtonClicked=NO;
        }
        [self updateGGButton];
    }
    [_spinner stopAnimating];
}
- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)setGGUserProfilePicture:(NSData*)data
{
    if(!data){
        [self removeProfileViewOfOAuthType:GOOGLE];
    }
    else{
        CGFloat height = self.profileView.frame.size.height;
        NSArray* arr = self.profileView.subviews;
        int i=0;
        for(;i<arr.count;i++){
            UIImageView* view = arr[i];
            if(view.frame.origin.x>=3*height){
                view.image=[UIImage imageWithData:data];
                return;
            }
        }
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3*height+2*PROFILE_SEPARATION, 0, height, height)];
        imageView.image = [UIImage imageWithData:data];
        [self.profileView addSubview:imageView];
    }
}

-(void)didDisconnectWithError:(NSError *)error
{
    if (error) {
        [self showGGAlertView:error.description];
    }
    else {
        [UserObject currentUser].ggLogin=NO;
        //_ggSignIn = [GPPSignIn sharedInstance];
        [self removeProfileViewOfOAuthType:GOOGLE];
    }
    [self updateGGButton];
    [self.spinner stopAnimating];
}

-(void)showGGAlertView:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    
}


//=============2. Twitter methods=========================
#pragma mark - twitter login methods
-(void)trySilentLoginTwitter
{
    [SessionManager loadTWSession];
    TWSession *twSession = [SessionManager twSession];
    if(twSession.access_token && twSession.access_token.length>0){
        
        [UserObject loadUserObjectFromFileToCurrentUser];
        UserObject* user = [UserObject currentUser];
        if(user.twLogin){
            [self.twitterLoginButton setTitle:@"Logout Twitter" forState:UIControlStateNormal];
            [self postTWProfileWithCachedProfile];
        }
    }
}
-(void)twitterLoginButtonClicked:(UIButton*)sender
{
    if(![UserObject currentUser].twLogin)
    {
        //1. load local cache
        [SessionManager loadTWSession];
        TWSession *twSession = [SessionManager twSession];
        if(twSession.access_token){
            //NSString *userImageURL = twSession.user_image_url;
            //NSLog(@"the cached user image url is %@",userImageURL);
            
            [self.twitterLoginButton setTitle:@"Logout Twitter" forState:UIControlStateNormal];
            //_isTWLoggedin=YES;
            [UserObject currentUser].twLogin=YES;//TODO: update the currentUser;
            [self postTWProfileWithCachedProfile];
            //[self fetchAndUpdateTwitterUserInfoWithImageURL:userImageURL withTrialNumber:0];
        }
        //2. startTWLoginByRequestToken
        else
            [self startTWLoginByRequestToken];
        
    }
    else{
        [self logoutTW];
    }
    
}
-(UIActionSheet*)twLogoutActionSheet
{
    if(!_twLogoutActionSheet){
        _twLogoutActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Log out",@"Log out and clear cache", nil];
    }
    return _twLogoutActionSheet;
}

-(void)startTWLoginByRequestToken
{
    
    [_twSession getRequestTokenWithCompletionTask:^(BOOL success, NSURLResponse *response, NSError *error){
        if(success){
            _isTwitter = YES;
            _isLinkedin = NO;
            self.twRedirectURL = [NSString stringWithFormat:/*TWITTER_AUTHENTICATE_URL_FORMAT*/TWITTER_AUTHORIZE_URL_FORMAT,_twSession.request_token];
            //NSLog(@"the redirect url is %@",self.twRedirectURL);
            //using a block to call the twitter login
            // should also do the UIKit thing in the main thread!
            dispatch_async(dispatch_get_main_queue(),^{
                //[self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
                
                //[self performSegueWithIdentifier:@"LoginWebViewPushSegue" sender:self];
                [self performSegueWithIdentifier:@"LoginModalSegue" sender:self];
            });
        }
        //TODO: error handling
        else{
            
        }
    }];
}



//fetch the Access Token after User successfully logged in and call fetch image once get the access token
-(void) getTWAccessTokenAtTrial:(NSInteger)numberOfTrial{
    if(numberOfTrial >= _twLoginRetryLimit){
        NSLog(@"error: exceeded trial limit and did not get user profile");
        [_spinner stopAnimating];
        [[[UIAlertView alloc] initWithTitle:@"check your internet connection"
                                    message:@"Could not obtain access token, please try again later"
                                   delegate:nil
                          cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        //stop UI animation
        return;
    }
    else if(self.twSession.oauth_verifier_token && self.twSession.oauth_verifier){
        //send request for access_token
        [self.twSession getAccessTokenWithOAuthToken:self.twSession.oauth_verifier_token andOAuthVerifier:self.twSession.oauth_verifier withCompletionTask:^(NSURLResponse *response, NSError *error,NSString* accessToken, NSString * accessTokenSecret, NSString* screen_name, NSString* user_id){
            //NSLog(@"in login view accessToken is %@, access secret is %@, screen name is %@, user_id is %@",accessToken,accessTokenSecret,screen_name,user_id);
            //if successful
            if(!error && user_id && screen_name){
                self.twSession.access_token = accessToken;
                self.twSession.access_token_secret  = accessTokenSecret;
                
                //trigger another task to get the user profile. Only after getting the user profile data or it reaches the maximum _twLoginRetryLimit, will the it stop requesting for the user's profile.
                [self.twSession getUserProfileByScreenName:screen_name andUserId:user_id withCompletionTask:^(NSURLResponse *response, NSError *error,NSString *name, NSString *URLString) {
                    //NSLog(@"in the last user profile completion task");
                    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
                    //success
                    if(httpResponse.statusCode == 200 && !error && name){
                        
                        self.twSession.user_name = name;
                        self.twSession.user_image_url = URLString;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.spinner stopAnimating];
                            [self showAlertViewWithTitle:@"Login" Message:@"You have successfully logged in with Twitter!"];
                        });
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [UserObject currentUser].twLogin=YES;
                        [self fetchAndUpdateTwitterUserInfoWithImageURL:self.twSession.user_image_url withTrialNumber:0];
                        [UserObject currentUser].twUsername = self.twSession.user_name;
                        [UserObject currentUser].twProfileURL = self.twSession.user_image_url;
                        [UserObject currentUser].twAccessToken = self.twSession.access_token;
                        [UserObject updateUserObjectToFile:nil];
                        
                        //_isTWLoggedin=YES;
                        //cache the twitter session
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
//make API call to download the image from imageURL and post onto profileView
-(void)fetchAndUpdateTwitterUserInfoWithImageURL:(NSString*)imageURL withTrialNumber:(NSInteger)num
{
    if(num>_twLoginRetryLimit){
        NSLog(@"!!! ERROR: failed to download the user image");
        [self.spinner stopAnimating];
        return;
    }
    NSURLSession * session = [NSURLSession sharedSession];
    [self.spinner startAnimating];
    //may need to remove existing twitter profile picture first
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSURL *localFileLocation, NSURLResponse *response, NSError *error) {
        if(!error){
            
            NSData *imageData=[NSData dataWithContentsOfURL:localFileLocation];
            UIImage * image = [UIImage imageWithData:imageData];
            if(!image){
                [self fetchAndUpdateTwitterUserInfoWithImageURL:imageURL withTrialNumber:num+1];
                return;
            }
            //NSLog(@"the image is %@ and url is %@",userImage.image,localFileLocation);
            dispatch_async(dispatch_get_main_queue(), ^{
                //remove current profile picture
                //[self removeProfileViewOfOAuthType:TWITTER];
                // add new picture
                [self postTWProfileWithImage:image];
                
                //!!write to local file
                //[SessionManager writeProfileImage:imageData];
            });
            
            //write to cached location!
            NSURL* url = [UserObject currentUserTWProfileURL];
            [imageData writeToURL:url atomically:YES];
            
        }
    }];

    [task resume];
}
-(void)postTWProfileWithCachedProfile
{
    NSURL* url = [UserObject currentUserTWProfileURL];
    if([[NSFileManager defaultManager] fileExistsAtPath:url.path]){
        [self postTWProfileWithImage:[UIImage imageWithContentsOfFile:url.path]];
    }
    
}
-(void)postTWProfileWithImage:(UIImage*)image
{
    
    CGFloat width = self.profileView.frame.size.height;
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((2.0 + width), 0, width,width)];
    userImage.layer.cornerRadius = 5.0f;
    userImage.image=image;
    [self.profileView addSubview:userImage];
    
    if([self.spinner isAnimating])
        [self.spinner stopAnimating];
}

-(void)logoutTW
{
    [self.twLogoutActionSheet showInView:self.view];
    
//    //1. remove the twitter profile picture
//    [self removeProfileViewOfOAuthType:TWITTER];
//    //2. reset the twitter login button
//    [_twitterLoginButton setTitle:@"login with Twitter" forState:UIControlStateNormal];
//    //3. UserObject.currentUser set twitter not login
//    [UserObject currentUser].twLogin=NO;
////    [UserObject clearUserTwitterInfo];
////    [UserObject updateUserObjectToFile:nil];
////    [UserObject clearUserTWProfile];
    
}
-(void)logoutTWAndClearCache:(BOOL)clearCache
{
    //1. remove the twitter profile picture
    [self removeProfileViewOfOAuthType:TWITTER];
    //2. reset the twitter login button
    [_twitterLoginButton setTitle:@"login Twitter" forState:UIControlStateNormal];
    //3. UserObject.currentUser set twitter not login
    [UserObject currentUser].twLogin=NO;
    if(clearCache){
        //1. UserObject's cache
        [UserObject clearUserTwitterInfo];
        [UserObject updateUserObjectToFile:nil];
        [UserObject clearUserTWProfile];
        
        //2.Twitter/LoginToken.plist
        [SessionManager clearTwitterLocalCache];
    }
    
}

#pragma mark - LinkedIn & Twitter
//twitter unwind method
-(IBAction)done:(UIStoryboardSegue *)segue
{
    //user cancelled
    if(_isTwitter && self.twSession.oauth_verifier){
        [self.spinner startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self getTWAccessTokenAtTrial:0];
    }
    else if(self.isLinkedin && self.lkCallbackCode){
        //
        //NSLog(@"going to call request access_token");
        [self.lkParams setObject:self.lkCallbackCode forKey:LK_CALLBACK_CODE];
        
        [self getLKAccessTokenWithCode];
        
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LoginModalSegue"] || [segue.identifier isEqualToString:@"LoginWebViewPushSegue"]){
        //NSLog(@"about to segue");
        if([segue.destinationViewController isKindOfClass:[OAuthViewController class]]){
            OAuthViewController *webViewController = (OAuthViewController*)segue.destinationViewController;
            webViewController.superVC=self;
            if(self.isTwitter){
                webViewController.isLinkedin=NO;
                webViewController.isTwitter=YES;
                NSLog(@"the redirect URL is %@",_redirectURL);
                webViewController.requestURL=self.twRedirectURL;
                
            }
            else if(self.isLinkedin){
                NSLog(@"linkedin login prepare for segue");
                
//                if(!_isLKLogggedin){
                    self.isLinkedin=YES;
                    self.isTwitter = NO;
                    webViewController.isTwitter=NO;
                    webViewController.isLinkedin=YES;
                    webViewController.requestURL = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@",LINKEDIN_API_KEY,LINKEDIN_DEFAULT_SCOPE,LINKEDIN_DEFAULT_STATE,LINKEDIN_REDIRECT_URL];
//                }
            }

        }
    }
}


//==============================================================
#pragma mark - linkedin methods
-(UIActionSheet*)lkLogoutActionSheet
{
    if(!_lkLogoutActionSheet){
        _lkLogoutActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout",@"Logout and clear cache", nil];
    }
    return _lkLogoutActionSheet;
}
-(NSMutableDictionary*)lkParams
{
    if(!_lkParams){
        _lkParams = [[NSMutableDictionary alloc] init];
    }
    return _lkParams;
}
-(void)getLKAccessTokenWithCode
{
    //NSLog(@"calling the lk request access token");
    NSString *accessTokenRequest = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",self.lkCallbackCode,LINKEDIN_REDIRECT_URL,LINKEDIN_API_KEY,LINKEDIN_SECRET];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithURL:[NSURL URLWithString:accessTokenRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //put UI code on main thread
        if(error){
            NSLog(@"ERROR: fetching Linkedin access token");
        }
        else{
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.lkExpiresIn =[result valueForKeyPath:@"expires_in"];
            self.lkAccessToken =[result valueForKeyPath:@"access_token"];
            //NSLog(@"expires_in is %@, access_token is %@",_lkExpiresIn,_lkAccessToken);
            if(self.lkExpiresIn && self.lkAccessToken){
                [self.lkParams setObject:self.lkAccessToken forKey:LK_ACCESS_TOKEN];
                NSDate* today = [NSDate date];
                NSDate* expireDate = [today dateByAddingTimeInterval:[self.lkExpiresIn doubleValue]];
                [self.lkParams setObject:expireDate forKey:LK_EXPIRES_IN];
                //1. get LK user profile
                [self getLKUserProfile];
                //2. get LK user profile picture
                [self getLKUserProfilePicture];
            }
            else{
                NSLog(@"!!! ERROR: after LK user logged in, NO access token or expiration is fetched!");
            }
        }
    }];
    [task resume];
}
-(void)getLKUserProfile
{
    NSString *urlStr =[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?format=json&oauth2_access_token=%@",self.lkAccessToken];
    //NSLog(@"the url is %@",urlStr);
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            //NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"the result is %@",result);
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"user data is %@",userData);
            [self.lkParams addEntriesFromDictionary:userData];
            
            if([self.lkParams valueForKey:LK_PROFILE_URL]){
                //NSLog(@"calling update UserObject linkedin from profile");
                //1.1 update LK user info
                [self updateCurrentUserLKInfo];
            }
        }
        
    }];
    [task resume];
}
//2. get LK user profile picture URL
-(void)getLKUserProfilePicture
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_spinner startAnimating];
    });
    //NSString *userURL = [userData valueForKey:@"siteStandardProfileRequest"];
    NSString *urlStr=[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(%@)?format=json&oauth2_access_token=%@",@"picture-url",self.lkAccessToken];
    //NSLog(@"the url string for profile picture is %@",urlStr);
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [self.lkParams addEntriesFromDictionary:result];
            
            NSString *userPicURL = [result valueForKey:@"pictureUrl"];
            //2.2 download user's picture
            [self downloadUserProfilePicture:userPicURL];
            //NSLog(@"result is %@",result);
        }
        else{
            NSLog(@"!!!error is %@",error);
        }
        
    }];
    [task resume];
}
-(void)downloadUserProfilePicture:(NSString *)userPicURL
{
    //NSLog(@"the url string for profile picture is %@",urlStr);
    //[_spinner startAnimating];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:userPicURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                [self addLinkedinProfileWithImage:image];
                NSLog(@"calling update UserObject linkedin from profile picture");
                [UserObject currentUser].lkLogin=YES;
                [self updateCurrentUserLKInfo];
                [_spinner stopAnimating];
            });
            //write to local lkProfile file
            NSURL* lkProfileURL= [UserObject currentUserLKProfileURL];
            [data writeToURL:lkProfileURL atomically:YES];
           
//            for(NSString* k in self.lkParams){
//                NSLog(@"k:%@ and v:%@",k,_lkParams[k]);
//            }
        }
        else{
            NSLog(@"error is %@",error);
        }
        
        [SessionManager writeLKSessionCache:_lkParams];
        [_spinner stopAnimating];
        
    }];
    [task resume];
}
-(void)addLinkedinProfileWithImage:(UIImage*)image
{
    NSArray* views = self.profileView.subviews;
    CGFloat height = self.profileView.frame.size.height;
    int i=0;
    for(;i<views.count;i++){
        UIImageView* view = views[i];
        if(view.frame.origin.x>=height*2 && view.frame.origin.x<height*3){
            view.image=image;
        }
    }
    if(i == views.count){
        UIImageView* lkView = [[UIImageView alloc] initWithFrame:CGRectMake(height*2+2, 0, height, height)];
        lkView.image=image;
        [self.profileView addSubview:lkView];
    }
    if([self.spinner isAnimating]){
       [self.spinner stopAnimating];
    }
}
-(void)updateCurrentUserLKInfo
{
    UserObject* user = [UserObject currentUser];
    user.lkLogin=YES;
    user.lkAccessToken=self.lkParams[LK_ACCESS_TOKEN];
    user.lkExpireDate=self.lkParams[LK_EXPIRES_IN];
    user.lkProfileURL=self.lkParams[LK_PROFILE_URL];
    user.lkUsername=[NSString stringWithFormat:@"%@ %@",self.lkParams[@"firstName"],self.lkParams[@"lastName"]];
    [UserObject updateUserObjectToFile:nil];
    [self updateLKButton];
}
-(void)trySilentLoginLinkedin
{
    UserObject*user=  [UserObject currentUser];
    if(user.lkLogin){
        UIImage* image = [UIImage imageWithContentsOfFile:[UserObject currentUserLKProfileURL].path];
        [self addLinkedinProfileWithImage:image];
    }
    [self updateLKButton];
    
}
-(void)linkedinLoginTask
{
    [_loginLinkedinButton setTitle:@"logout" forState:UIControlStateNormal];
    _isLKLogggedin = YES;
    
}
-(void)updateLKButton
{
    NSLog(@"updating LK button");
    UserObject* user = [UserObject currentUser];
    if(user.lkLogin){
        [self.loginLinkedinButton setTitle:@"Logout Linkedin" forState:UIControlStateNormal];
        
    }
    else{
        [self.loginLinkedinButton setTitle:@"Login Linkedin" forState:UIControlStateNormal];
    }
}
- (IBAction)linkedinButtonClicked:(id)sender
{
    
    UserObject* user = [UserObject currentUser];
    if(user.lkLogin){
        [self.lkLogoutActionSheet showInView:self.view];
//        [self.loginLinkedinButton setTitle:@"login Linkedin" forState:UIControlStateNormal];
        
    }
    else{
        //segue is set by storyboard
        //[self performSegueWithIdentifier:@"LoginModalSegue" sender:self];
        self.isLinkedin=YES;
        self.isTwitter = NO;
        [self performSegueWithIdentifier:@"LoginModalSegue" sender:self];
        
    }
    
//    if(_isLKLogggedin){
//        
//    }
//    else{
//        
//    }
    
}
-(void)linkedinLogout
{
    if([UserObject currentUser].lkLogin){
        [UserObject currentUser].lkLogin=NO;
        [self removeProfileViewOfOAuthType:LINKEDIN];
        if([self.spinner isAnimating]){
            [self.spinner stopAnimating];
        }
        [UserObject updateUserObjectToFile:nil];
        [self updateLKButton];
    }
    else{
        NSLog(@"warning: linkedin user is NOT logged in before logging out ");
    }
}
-(void)linkedinLogoutAndClearCache
{
    if([UserObject currentUser].lkLogin){
        [UserObject currentUser].lkLogin=NO;
        [UserObject updateUserObjectToFile:nil];
        [self removeProfileViewOfOAuthType:LINKEDIN];
        [self updateLKButton];
    }
    else{
        NSLog(@"warning: linkedin user is NOT logged in before logging out ");
    }
}


//========================Action sheet ====================================
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet==self.lkLogoutActionSheet){
        if(buttonIndex==0){
            [self linkedinLogout];
        }
        else if(buttonIndex==1){
            [self linkedinLogoutAndClearCache];
        }
        else{
            [self.spinner stopAnimating];
        }
    }
    else if(actionSheet==self.ggActionSheet){
        if(buttonIndex==0){
            [self ggSignOut];
        }
        else if(buttonIndex==1){
            [self ggSignOutAndRemokePermissions];
        }
        else{
            if([self.spinner isAnimating]){
                [self.spinner stopAnimating];
            }
        }
    }
    else if(actionSheet==self.twLogoutActionSheet){
        if(buttonIndex == 0){
            [self logoutTWAndClearCache:NO];
        }
        else if(buttonIndex == 1){
            [self logoutTWAndClearCache:YES];
        }
        else{
            return;
        }
    }
    else if(actionSheet==self.fbLogoutActionSheet){
        if(buttonIndex == 3){
            //NSUserDefaults*defaults =[NSUserDefaults standardUserDefaults];
            //NSDictionary* dict = [defaults objectForKey:@"FBAccessTokenInformationKey"];
            //        if(!dict){
            //            NSLog(@"dict is null");
            //        }
            //        for(NSString* k in dict){
            //            NSLog(@"k:%@ and v:%@",k,dict[k]);
            //        }
            return;
        }
        else if(buttonIndex == 0){
            [SessionManager logoutFacebookCleanCache:NO revokePermissions:NO WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if([self.spinner isAnimating])
                    [self.spinner stopAnimating];
                if(!([SessionManager fbSession].state & FB_SESSIONSTATEOPENBIT)){
                    [UserObject currentUser].fbLogin = NO;
                }
                [self updateFBLoginButton];
            }];
        }
        else if(buttonIndex == 1){
            [SessionManager logoutFacebookCleanCache:YES revokePermissions:NO WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if([self.spinner isAnimating])
                    [self.spinner stopAnimating];
                if(!([SessionManager fbSession].state & FB_SESSIONSTATEOPENBIT)){
                    [UserObject currentUser].fbLogin = NO;
                }
                [self updateFBLoginButton];
            }];
        }
        else if(buttonIndex == 2){
            [_spinner startAnimating];
            [SessionManager logoutFacebookCleanCache:YES revokePermissions:YES WithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if([self.spinner isAnimating])
                    [self.spinner stopAnimating];
                if(!([SessionManager fbSession].state & FB_SESSIONSTATEOPENBIT)){
                    [UserObject currentUser].fbLogin = NO;
                }
                [self updateFBLoginButton];
            }];
        }
        
    }
    else{
    
    }
}



#pragma mark - FB login methods
- (IBAction)fbLoginButtonClicked:(id)sender{
    //NSLog(@"fb button clicked");
    if(![UserObject currentUser].fbLogin){
        self.toLogoutFB=NO;
        [self fbLogin];
    }
    else{
        self.toLogoutFB=YES;
        [self fbLogout];
    }
}

-(UIImage*)trySilentLoadFBProfile
{
    NSURL* fbURL =[UserObject currentUserFBProfileURL];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fbURL.path]){
        return nil;
    }
    return [UIImage imageWithContentsOfFile:fbURL.path];
}
-(void)trySilentOpenFBSession
{
    [self trySilentOpenFBSessionWithCompletionHandler:nil];
}
-(void)trySilentOpenFBSessionWithCompletionHandler:(void(^)(FBSession* session, FBSessionState status, NSError*error))handler
{
    
    FBSession* session = [SessionManager fbSession];
    ////NSLog(@"silent:fbsession initial state is %ld has handler",session.state);
    //1. if initial state is closed or login failed, NOTE:no need to worry about StateOpening
    if(session.state ==FBSessionStateClosedLoginFailed || session.state==FBSessionStateClosed){
        ////NSLog(@"session state is closed!");
        FBSession* newSession = [[FBSession alloc] initWithAppID:nil permissions:@[@"public_profile"] urlSchemeSuffix:nil tokenCacheStrategy:[SessionManager myFBTokenCachingStrategy]];
        [FBSession setActiveSession:newSession];
        session=[FBSession activeSession];
        [SessionManager setFBSession:session];
    }
    //2. if initial state is created
    FBAccessTokenData* tokenData  = [[SessionManager myFBTokenCachingStrategy] fetchFBAccessTokenData];
    if(session.state==FBSessionStateCreated){
        ////NSLog(@"silent: session state is then created!");
        //note: this method only works when the state is created
        //NSLog(@"session is %@",session);
        if(tokenData.accessToken && tokenData.accessToken.length>5){
            [session openFromAccessTokenData:tokenData completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if(status!=FBSessionStateOpen && status!=FBSessionStateOpenTokenExtended){
                    NSLog(@"!!! ERROR: open FB session failed");
                }
                else{
                    NSLog(@"FB session is opened successfully!");
                    UIImage* image = [self trySilentLoadFBProfile];
                    
                    //load the user profile
                    [self postFBProfileImage:image];
                    
                    //notify the app that FB user is logged in
                    if(session.state == FBSessionStateOpen || session.state==FBSessionStateOpenTokenExtended){
                        [UserObject currentUser].fbLogin=YES;
                        [FBSession setActiveSession:session];
                    }
                    [self updateFBLoginButton];
                }
                
                if(handler){
                    handler(session,status,error);
                }
                
            }];
        }
        else{
            ////NSLog(@"silent in else!");
            if(handler)
                handler(session,session.state,NULL);
            
            //NoFallbackToWebView will pop up webview anyway !!
            //            [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            //                if(status!=FBSessionStateOpen && status!=FBSessionStateOpenTokenExtended){
            //                    NSLog(@"!!! ERROR: open FB session failed");
            //                }
            //                else{
            //                    NSLog(@"FB session is opened successfully!");
            //                    UIImage* image = [self trySilentLoadFBProfile];
            //
            //                    //load the user profile
            //                    [self postFBProfileImage:image];
            //                    //notify the app that FB user is logged in
            //                    [UserObject currentUser].fbLogin=YES;
            //                    [FBSession setActiveSession:session];
            //                    [self updateFBLoginButton];
            //                }
            //
            //                if(handler)
            //                    handler(session,status,error);
            //            }];
        }
    }
    else if(session.state==FBSessionStateCreatedTokenLoaded){
        ////NSLog(@"silent: in created token loaded");
        //this opens the fession too!!
        [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(status!=FBSessionStateOpen && status!=FBSessionStateOpenTokenExtended){
                ////NSLog(@"!!! ERROR: open FB session failed in login view");
            }
            else{
                //load user profile
                [self postFBProfileImage:[self trySilentLoadFBProfile]];
                ////NSLog(@"FB session is opened successfully!");
            }
            //fb user login
            if(session.state == FBSessionStateOpen || session.state==FBSessionStateOpenTokenExtended){
                [UserObject currentUser].fbLogin=YES;
                [FBSession setActiveSession:session];
                
            }
            [self updateFBLoginButton];
            if(handler)
                handler(session,status,error);
        }];
        
        //this opens fb session too!
//            [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                if(status!=FBSessionStateOpen && status!=FBSessionStateOpenTokenExtended){
//                    NSLog(@"!!! ERROR: open FB session failed in login view");
//                }
//                else{
//                    //load user profile
//                    [self postFBProfileImage:[self trySilentLoadFBProfile]];
//                    NSLog(@"FB session is opened successfully!");
//                }
//                //fb user login
//                if(session.state == FBSessionStateOpen || session.state==FBSessionStateOpenTokenExtended){
//                    [UserObject currentUser].fbLogin=YES;
//                    [FBSession setActiveSession:session];
//                    
//                }
//                [self updateFBLoginButton];
//                if(handler)
//                    handler(session,status,error);
//
//            }];
        
        //this method will open the login dialog for login if initial state is created, will NOT open is initial state is tokenLoaded
        //        [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        //            NSLog(@"after open with completion handler:");
        //            if(error){
        //                NSLog(@"error is %@",error);
        //            }
        //            else{
        //                NSLog(@"state is %ld",session.state);
        //            }
        //        }];
    }
    
    if(session.state == FBSessionStateOpen||session.state==FBSessionStateOpenTokenExtended){
        [FBSession setActiveSession:session];
        [self updateFBLoginButton];
    }
    //    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:NO completionHandler:nil];
    //    session = [FBSession activeSession];
    //    NSLog(@"after open with read permission fbsession state is %ld",session.state);
    //
    //    [FBSession openActiveSessionWithAllowLoginUI:NO];
    //    session=[FBSession activeSession];
    //    NSLog(@"after open with allow login UI:NO state is %ld",session.state);
    
    //    FBAccessTokenData* tokenData  = [FBAccessTokenData createTokenFromDictionary:[[SessionManager myFBTokenCachingStrategy] getFBAccessTokenDataDictionary]];
}
-(void) fbLogin
{
    if([[UserObject currentUser] fbLogin]){
        return;
    }
    [self trySilentOpenFBSessionWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        /*
         this is a flag indicating if the user intends to logout. If
         */
        if(self.toLogoutFB){
            self.toLogoutFB=NO;
            return;
        }
        ////NSLog(@"handler :session state is %ld",status);
        if(error || !(session.state & FB_SESSIONSTATEOPENBIT)){
            ////NSLog(@"handler: session2 state is %ld",status);
            
            [SessionManager loginFacebookWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                
                if(!(status & FB_SESSIONSTATEOPENBIT)){
                    NSLog(@"FB login failed or logged out");
                }
                else{
                    //user has login
                    [_fbButton setTitle:@"logout" forState:UIControlStateNormal];
                    [_fbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _isFBLoggedin = YES;
                    //FB request to get the profile information.
                    if([FBSession activeSession]!=[SessionManager fbSession]){
                        [FBSession setActiveSession:[SessionManager fbSession]];
                    }
                    
                    [_spinner startAnimating];
                    //fetch the profile !
                    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        //1. parse result
                        NSDictionary * dict = (NSDictionary *)result;
                        //                for(NSString* key in dict){
                        //                    NSLog(@"key:%@, value:%@",key,dict[key]);
                        //                }
                        NSString * idStr = [dict valueForKey:@"id"]; //NSLog(@"id is %@ ", idStr);
                        NSString* pictureURLString =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",idStr];
                        NSURL * imageURL = [NSURL URLWithString:pictureURLString];
                        
                        
                        //2. download the profile data
                        //check internet, if suddenly no internet for fetching profile picture, still login but no profile picture/or use local cache.
                        NSURLSession *urlSession = [NSURLSession sharedSession];
                        // download the user profile image
                        NSURLSessionDataTask *task = [urlSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if(!error){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIImage *image = [UIImage imageWithData:data];
                                    //write the image file to local disk
                                    [self postFBProfileImage:image];
                                });
                                [data writeToURL:[UserObject currentUserFBProfileURL] atomically:YES];
                            }
                            else{
                                NSLog(@"!!ERROR: fetching FB user profile failed, please try again!");
                            }
                            
                        }];
                        [task resume];
                    
                        
                        //3. update the current user Info and write to userDefaults and file
                        //MyFBSessionTokenCachingStrategy* strategy = [SessionManager myFBTokenCachingStrategy];
                        //FBAccessTokenData* tokenInfo = [strategy fetchFBAccessTokenData];
                        
                        //get the access token info from the session, the same as the myFBTokenCachingStrategy;
                        FBAccessTokenData* tokenInfo = session.accessTokenData;
                        NSMutableDictionary* fbNewInfo = [[NSMutableDictionary alloc] init];
                        [fbNewInfo setObject:pictureURLString forKey:@"fbProfileURL"];
                        [fbNewInfo setObject:[NSNumber numberWithBool:YES] forKey:@"fbLogin"];
                        [fbNewInfo setObject:idStr forKey:@"fbID"];
                        [fbNewInfo setObject:dict[@"name"] forKey:@"fbUsername"];
                        NSString* accessToken = tokenInfo.accessToken;
                        if(accessToken){
                            [fbNewInfo setObject:accessToken forKey:@"fbAccessToken"];
                        }
                        NSDate* expireDate =tokenInfo.expirationDate;
                        if(expireDate){
                            [fbNewInfo setObject:expireDate forKey:@"fbExpireDate"];
                        }
                        [UserObject updateCurrentUserWithNewInfo:fbNewInfo];
                        [UserObject updateUserObjectToFile:nil];
                        //[UserObject updateUserObjectInUserDefaults:nil];
                    }];
                }
            }];
            
        }
    }];
    
}
-(void)fetchFBUserProfileAndUpdate
{
    NSString* file = [SessionManager myFBTokenCachingStrategy].file;
    NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:file];
    //1. find the fb access token data to get url
    NSString * idStr = [info valueForKey:@"com.facebook.sdk:TokenInformationUserFBIDKey"]; //NSLog(@"id is %@ ", idStr);
    NSURL* url = nil;
    if(idStr && idStr.length>1){
        NSString* pictureURLString =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",idStr];
        url = [NSURL URLWithString:pictureURLString];
    }
    else{
        //find the current user's data
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[UserObject currentUserInfoURL]];
        if(dict){
            url = [NSURL URLWithString:dict[@"fbProfileURL"]];
        }
    }
    if(url){
        NSURLSession* session = [NSURLSession sharedSession];
        [self.spinner startAnimating];
        [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    [self postFBProfileImage:image];
                    [self.spinner stopAnimating];
                });
                [data writeToURL:[UserObject currentUserFBProfileURL] atomically:YES];
            }
            else{
                NSLog(@"fetching FB User profile failed !");
            }
        }] resume];
        
    }

}
-(void)removeFBProfile
{
    NSArray* subviews = [self.profileView subviews];
    for(UIView *view in subviews){
        if(view.frame.origin.x>=0 && view.frame.origin.x< PROFILE_VIEW_HEIGHT){
            [view removeFromSuperview];
            //break;
        }
    }
}
-(void)postFBProfile
{
    NSURL* url = [UserObject currentUserFBProfileURL];
    UIImage* image = [UIImage imageWithContentsOfFile:url.path];
    if(image){
        [self postFBProfileImage:image];
    }
    else{
        [self fetchFBUserProfileAndUpdate];
    }
}
-(void)postFBProfileImage:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _profileView.frame.size.height, _profileView.frame.size.height)];
    imageView.image = image;
    [_profileView addSubview:imageView];
    
    if([_spinner isAnimating])
        [_spinner stopAnimating];
}
-(void)fbLogout
{
    //[self showFBActionSheet];
    [self.fbLogoutActionSheet showInView:self.view];
}
-(void)fbLogoutUpdate:(FBSession*) session
{
    if(session.state != FBSessionStateOpen && session.state != FBSessionStateOpenTokenExtended){
        [_fbButton setTitle:@"Login Facebook" forState:UIControlStateNormal];
        [_fbButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _isFBLoggedin = NO;
    }
    else
        NSLog(@"logout failed");
}

-(void)fbSetup
{
    [self trySilentOpenFBSession];
    self.toLogoutFB=NO;
}

-(void)updateFBLoginButton
{
    if([SessionManager fbSession].state & FB_SESSIONSTATEOPENBIT){
        ////NSLog(@"update FB login Button to logoug");
        [_fbButton setTitle:@"Logout Facebook" forState:UIControlStateNormal];
        [_fbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UserObject currentUser].fbLogin=YES;
        NSArray* subview = [self.profileView subviews];
        int i=0;
        BOOL noImage=NO;
        for(;i<subview.count;i++){
            UIImageView* view  = subview[i];
            if(view.frame.origin.x>=0 && view.frame.origin.x<PROFILE_VIEW_HEIGHT){
                if(!view.image){
                    noImage=YES;
                }
            }
        }
        if(i==subview.count || noImage){
            [self postFBProfile];
        }
    }
    else{
        ////NSLog(@"update FB login Button to Login");
        [_fbButton setTitle:@"login" forState:UIControlStateNormal];
        [_fbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UserObject currentUser].fbLogin=NO;
        [self removeFBProfile];
    }
}
-(UIActionSheet*)fbLogoutActionSheet
{
    if(!_fbLogoutActionSheet){
        _fbLogoutActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"logout",@"logout & clean cache",@"logout & revoke permissions", nil];
    }
    return _fbLogoutActionSheet;
}

//- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
//{
//    
//    NSLog(@"login view fetched user info");
//    
//}

//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
//{
//    NSLog(@"In Login view, FB session state changed to %@", session);
//    
//}


//======================native UI methods=========================
#pragma mark - native UI methods

- (IBAction)onLoginButtonClicked:(id)sender
{
    [self trySilentOpenFBSession];
    FBSession* session = [FBSession activeSession];
    if(session.state == FBSessionStateOpen || session.state==FBSessionStateOpenTokenExtended){
        [UserObject currentUser].fbLogin=YES;
    }

//    [SessionManager refreshFBSessionFromLocalCacheWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        NSLog(@"3. the session is %@",session);
//    }];
    
    //[self login];
}

// this method is temporarily used for revoking FB permissions
- (IBAction)onRegisterButtonClicked:(id)sender
{
   // [SessionManager logoutFacebook];
    
//    FBSession * session = [FBSession activeSession];
//    NSLog(@"session.state is %ld",session.state);
//    [self fetchFBUserProfileAndUpdate];
    TWSession* session = [SessionManager twSession];
    int r = arc4random()%256;
    //VERY IMPORTANT!!! CAN NOT have Special characters in the status such as :()!* etc.
    [session updateStatus:[NSString stringWithFormat:@"this is a new status%d",r] withCompletionHandler:nil];
    //[session requestUserTimeline];
    
}

-(NSMutableArray*)twUploadMediaArray
{
    if(!_twUploadMediaArray){
        _twUploadMediaArray=[[NSMutableArray alloc] init];
    }
    return _twUploadMediaArray;
}
//temparorily used as enumerator of files
- (IBAction)onForgetPasswordButtonClicked:(id)sender
{
    //NSLog(@"access key %@ and secret:%@",session.access_token,session.access_token_secret);
    int r = arc4random()%256;
    NSString* status = [NSString stringWithFormat:@"this is a new status%d",r];
    NSArray* urls = [NSArray arrayWithObjects:[UserObject currentUserFBProfileURL],[UserObject currentUserGGProfileURL],[UserObject currentUserTWProfileURL], nil];
    for(int i =0;i<urls.count;i++){
        [self uploadTWImage:urls[i] withStatus:status];
    }

    //NSLog(@"forget password button clicked");
}
-(void)uploadTWImage:(NSURL*)url withStatus:(NSString*)status
{
    TWSession* session = [SessionManager twSession];
    [session uploadWithImageURL:url AndStatus:status withCompletionHandler:^(NSString *idString, NSError *error) {
        if(idString){
            [self.twUploadMediaArray addObject:idString];
            if(self.twUploadMediaArray.count==3){
                [self updateStatus:status withMedias:self.twUploadMediaArray];
            }
        }
        else{
            NSLog(@"!!!Image upload failed");
        }
    }];
}
-(void)updateStatus:(NSString*)status withMedias:(NSArray*)ids
{
    TWSession* session = [SessionManager twSession];
    [session updateStatus:status withMediaIds:ids andCompletionHandler:^{
        
        nil;
    }];
}

-(void) showAlertViewWithTitle:(NSString *)title Message:(NSString*)message{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle: @"OK"otherButtonTitles: nil];
    [alertView show];
}

#pragma mark UI gesture recognizer methods
-(void)spinnerTapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"spinner tapped");
    
}
- (IBAction)tapOutsideToDismissKeyboard:(id)sender
{
    //NSLog(@"tap gesture recognized");
    if([self.loginUsernameTextField isFirstResponder])
        [self.loginUsernameTextField resignFirstResponder];
    if([self.loginPasswordTextField isFirstResponder])
        [self.loginPasswordTextField resignFirstResponder];
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
-(UIActivityIndicatorView*)spinner
{
    if(!_spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        _spinner.frame = self.view.frame;
        _spinner.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
        [_spinner addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spinnerTapped:)]];
        [self.view addSubview:_spinner];
    }
    return _spinner;
}
-(void)setup
{
    [self spinner];
    self.twSession = [SessionManager twSession];
    [self fbSetup];

    [self trySilentLoginTwitter];
    [self trySilentLoginLinkedin];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UI components
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
    
    [self setup];
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
