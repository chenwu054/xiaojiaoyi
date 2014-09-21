//
//  OAuthViewController.m
//  xiaojiaoyi
//
//  Created by chen on 9/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "OAuthViewController.h"

#define LINKEDIN_REDIRECT_URL @"http://xiaojiaoyi_linkedin_redirectURL"
#define LINKEDIN_API_KEY @"75iapcxav6yub5"
#define LINKEDIN_SECRET @"jUcSjy0xlLY0oaJC"

@interface OAuthViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak,nonatomic) NSURLConnection *connection;
@property (strong,nonatomic) NSString *accessToken;
@property (strong,nonatomic) NSNumber* expiration;
@end

@implementation OAuthViewController

#pragma mark - property setup
- (void) setWebView:(UIWebView *)webView
{
    if(!_webView){
        _webView = webView;
        _webView.delegate = self;
        _webView.userInteractionEnabled=true;
    }
}
- (void) setConnection:(NSURLConnection *)connection
{
    if(!_connection){
        _connection = connection;
    }
}


//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"connection:didReceiveResponse : %@",response);
//}

//-(void) requestForAccessToken:(NSString*) authCode
//{
//    NSString *newRequest = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",authCode,LINKEDIN_REDIRECT_URL,LINKEDIN_API_KEY,LINKEDIN_SECRET];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newRequest]];
//
//    NSOperationQueue* q = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"%@",response);
//        NSLog(@"------------");
//        //NSLog(@"%@",data);
//        //[self.webView loadRequest:request];
//    }];
//}


#pragma mark - business logic methods
-(void) requestForAuthToken
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
    /*
     this method sends a request to the URL
     and load the response to the webview for user authentication.
     */
    [self.webView loadRequest:request];
}

-(IBAction)doneInWebview:(UIStoryboardSegue *)segue
{
    //TODO: verify the _twitterOAuthToken is the same as oauth_token got in the step1.
    NSLog(@"calling the unwind method");
    
}

#pragma mark - UIWebView delegate methods
/*
 this method is used whenever the user clicks something in the webview causing the webview to send an HTTP request or redirect.
 this method is called before the request is send, therefore, the request can be replaced.
 This is the UIWebViewDelegate methods
 */
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
    NSString * requestStr = [request description];
    NSString * url = [request.URL description];
    //NSLog(@"about to send request : %@ ",requestStr);
    //TODO: take care of all the corner cases!
    
    /*
     Upon successful authorization by the user, the url will be redirected by Twitter to the callback URL with oauth_token and oauth_verifier included in the request.
     This url is intercepted and segue back to LoginViewController for further steps with oauth_token and verifer passed
     */
    if(_isTwitter){
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        NSMutableDictionary *dict = nil;
        if(arr.count>1){
            dict = [self parseResponseData:arr[1]];
        }
        if([dict valueForKey:@"oauth_verifier"]!=nil){
            LoginViewController *loginVC = (LoginViewController *)[self presentingViewController];
            loginVC.twitterOAuthToken = [dict valueForKey:@"oauth_token"];
            loginVC.twitterOAuthTokenVerifier = [dict valueForKey:@"oauth_verifier"];
            [self performSegueWithIdentifier:@"unwind Linkedin segue" sender:self];
            return NO;
        }
    }
    //Linkedin login
    /*
     upon successful authorization by the user, the url will be redirected by Linkedin to a new URL indicating auth code and state.
     This url is intercepted and replaced by a new url requesting for access token.
     */
    else if(_isLinkedin && [requestStr rangeOfString:@"code="].location!= NSNotFound && [requestStr rangeOfString:@"&state="].location!= NSNotFound){
        int start = (int)[requestStr rangeOfString:@"code="].location+5;
        int stateStart = (int)[requestStr rangeOfString:@"&state="].location+7;
        NSLog(@"%d, %d",start,stateStart);
        NSString * authCode = [requestStr substringWithRange:NSMakeRange(start, stateStart-7-start)];
        NSString * state = [requestStr substringFromIndex:stateStart];
        NSLog(@"auth code is %@ : and state is %@", authCode, state);
        //[self requestForAccessToken:authCode];
        
        /*
         this is a new request for access token using the auth code from last redirect.
         */
        NSString *newRequest = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",authCode,LINKEDIN_REDIRECT_URL,LINKEDIN_API_KEY,LINKEDIN_SECRET];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:newRequest]];
        
        NSLog(@"the new request is : %@",newRequest);
        /*
         the request is put on a different queue.
         */
        NSOperationQueue* q = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSLog(@"------------");

            //NSLog(@"%@",response); response is the HTTP header
            // data is the HTTP body, access token is in the body.
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([responseBody rangeOfString:@"access_token"].location!=NSNotFound){
                NSMutableCharacterSet * delimiters = [NSMutableCharacterSet characterSetWithCharactersInString:@"\" ,:{}"];
                NSArray * components = [responseBody componentsSeparatedByCharactersInSet:delimiters];
//                for(int i=0;i<components.count;i++){
//                    NSLog(@"%d : %@",i,components[i]);
//                }
                self.accessToken = [NSString stringWithString:components[5]];
                //long number = [components[10] longValue];
                NSNumber *number = @([components[10] intValue]);
                NSLog(@"%@  %@",number,self.accessToken);
                
                //self.expiration = [NSNumber numberWithLong:components[10]];
                //int accessTokenStart =[responseBody rangeOfString:@"access_token"].location;
                
                /*
                 programetically unwind the segue to its presenting segue.
                 */
                [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                //[self dismissViewControllerAnimated:YES completion:nil];
                
            }
            //NSLog(@"response body: %@",responseBody);
        }];

        //[self.webView loadRequest:request];
    }
    return YES;
}

#pragma mark - utils methods
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

#pragma mark - view controller lifecycle methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"the identifier: %@",segue.identifier);
    //NSLog(@"destination controller: %@",segue.destinationViewController);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestForAuthToken];
    
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
