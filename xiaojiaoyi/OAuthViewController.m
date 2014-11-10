//
//  OAuthViewController.m
//  xiaojiaoyi
//
//  Created by chen on 9/1/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "OAuthViewController.h"

#define LINKEDIN_REDIRECT_URL @"http://localhost.xiaojiaoyi"
#define LINKEDIN_API_KEY @"75iapcxav6yub5"
#define LINKEDIN_SECRET @"jUcSjy0xlLY0oaJC"

@interface OAuthViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *accessToken;
@property (strong,nonatomic) NSNumber* expiration;
@end

@implementation OAuthViewController

#pragma mark - OAuth logic methods
-(void) requestForAuthToken
{
    //NSLog(@"request is: %@",_requestURL);
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
    /*
     this method sends a request to the URL
     and load the response to the webview for user authentication.
     */
    [self.webView loadRequest:request];
}
- (IBAction)cancelButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
    
}

#pragma mark - UIWebView delegate methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
/*
 this method is used whenever the user clicks something in the webview causing the webview to send an HTTP request or redirect.
 this method is called before the request is send, therefore, the request can be replaced.
 This is the UIWebViewDelegate methods
 */
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * requestStr = [request description];
    NSString * url = [request.URL description];
    
//    NSLog(@"------------------");
//    NSLog(@"about to send request : %@ ",requestStr);
//    NSLog(@"method %@",[request HTTPMethod]);
//    NSDictionary* headers = [request allHTTPHeaderFields];
//    for(NSString* k in headers){
//        NSLog(@"k is%@ and v is %@",k,headers[k]);
//        
//    }
//    if([request HTTPBody]){
//        
//       // NSData* baseData = [[NSData alloc] initWithBase64EncodedData:[request HTTPBody] options:0];
//        NSString* baesString = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
//
//        NSLog(@"base string is %@",baesString);
//        
//    }
//    else{
//        NSLog(@"body is null");
//    }
    
    //NSLog(@"body is %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    //TODO: take care of all the corner cases!
    
    /*
     Upon successful authorization by the user, the url will be redirected by Twitter to the callback URL with oauth_token and oauth_verifier included in the request.
     This url is intercepted and segue back to LoginViewController for further steps with oauth_token and verifer passed
     */
    if(self.isTwitter){
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        NSMutableDictionary *dict = nil;
        if([requestStr rangeOfString:@"logout"].location!=NSNotFound){
            NSLog(@"found logout!");
            request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mobile.twitter.com/session/new"]];
            
            return YES;
        }
        else if([requestStr rangeOfString:@"authenticate"].location!=NSNotFound){
            NSLog(@"found authenticate key word!!");
            return  YES;
        }
        else if(arr.count>1){
            NSString *data = arr[1];
            NSRange cancelRange = [data rangeOfString:@"Cancel"];
            if(cancelRange.location != NSNotFound){
                [self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
                return NO;
            }
            dict = [self parseResponseData:data];
            if([dict valueForKey:@"oauth_verifier"]!=nil){
                //LoginViewController *loginVC = (LoginViewController *)[self presentingViewController];
                
                //NSLog(@"loginVC is %@",loginVC);
                self.superVC.twSession.oauth_verifier_token=[dict valueForKey:@"oauth_token"];
                self.superVC.twSession.oauth_verifier=[dict valueForKey:@"oauth_verifier"];

                //NSLog(@"visible %d",self.superVC.navigationController.visibleViewController == self);
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    //[[[UIAlertView alloc] initWithTitle:nil message:@"Thank you for signing in Twitter!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                //});
                //[self.superVC dismissViewControllerAnimated:YES completion:nil];
                
                //[self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
                
                NSLog(@"performed after alert view");
                return NO;
            }
        }
       
        return YES;
    }
    //Linkedin login
    /*
     upon successful authorization by the user, the url will be redirected by Linkedin to a new URL indicating auth code and state.
     This url is intercepted and replaced by a new url requesting for access token.
     */
    else if(self.isLinkedin){
        NSLog(@"the request str is %@",requestStr);
        
        NSRange xjyRange = [requestStr rangeOfString:@"https://www.linkedin.com"];
        //NSRange xjyRange = [requestStr rangeOfString:@"http://xiaojiaoyi_linkedin_redirecturl"];
        
        //TODO: take care of cancel and error senarios
        if(xjyRange.location == NSNotFound){
            NSArray *info = [requestStr componentsSeparatedByString:@"?"];
            
            if(info.count>1){
                NSMutableDictionary * data = [self parseResponseData:info[1]];
                if([data valueForKey:@"error"]){
                    [self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Linkedin login failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    
                    return NO;
                }
                else{
                    NSString *code= [data valueForKeyPath:@"code"];
                    NSString *state = [data valueForKeyPath:@"state"];
                    //LoginViewController *loginVC= (LoginViewController*)[self presentingViewController];
                    self.superVC.lkCallbackCode = code;
                    self.superVC.lkCallbackState = state;
                    [self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
                    return NO;
                }
            }
        }
    }
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self performSegueWithIdentifier:@"LoginUnwindSegue" sender:self];
}


#pragma mark - view controller lifecycle methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"unwind Linkedin segue"]){
//        if([segue.destinationViewController isKindOfClass:[LoginViewController class]]){
//            LoginViewController *loginVC = (LoginViewController*)segue.destinationViewController;
//            if(_isTwitter){
//
//                
//            }
//        }
//    }
    NSLog(@"performing unwind segue the identifier: %@",segue.identifier);
    //NSLog(@"destination controller: %@",segue.destinationViewController);
    
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

#pragma mark - property setup
- (void) setWebView:(UIWebView *)webView
{
    if(!_webView){
        _webView = webView;
        _webView.delegate = self;
        _webView.userInteractionEnabled=true;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestForAuthToken];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
