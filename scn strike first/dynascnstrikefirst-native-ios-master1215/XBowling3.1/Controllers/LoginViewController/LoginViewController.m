//
//  LoginViewController.m
//  XBowling3.1
//
//  Created by clicklabs on 1/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LoginViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    int currentApiNUmber;
    ServerCalls *serverCall;
    TermsAndConditionsView *termsView;
    LoginView *loginView;
    NSDictionary *loginCredentialsDictionary;
    id<GAITracker> tracker;
}

-(void)viewWillAppear:(BOOL)animated {
    tracker = [[GAI sharedInstance] defaultTracker];

    if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]) {
        
        UIImageView*  mainBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        mainBackImage.image=[UIImage imageNamed:@"splash_screen_ip_6.png"];
        mainBackImage.userInteractionEnabled=YES;
        [self.view addSubview:mainBackImage];
        
      //add
         [NSThread sleepForTimeInterval:4];
        
       // [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:4];
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"viaPushNotification"]) {
            [self navigateToNotificationController];
        }
        else{
            [self pushToHomeController];
        }
    }
    else
    {
        currentApiNUmber=0;
        self.view.backgroundColor=[UIColor blackColor];
        serverCall= [ServerCalls instance];
        serverCall.serverCallDelegate=self;
        
       loginView=[[LoginView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        loginView.loginDelegate=self;
        [self.view addSubview: loginView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self supportedInterfaceOrientations:NO];

}
#pragma mark - Notification Center
- (void)navigateToNotificationController
{
    NSLog(@"navigateToNotificationController called");
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"viaPushNotification"];
    NotificationController *notificationVC=[[NotificationController alloc]init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}
#pragma mark - Global Server Call Method
- (void)checkFirstSignInurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber calltype:(BOOL)isPostType
{
    loginCredentialsDictionary=[[NSDictionary alloc]initWithDictionary:postDict];
    NSDictionary *json = [[ServerCalls instance] serverCallForLoginWithPostParameters:postDict url:urlAppend contentType:@"application/json" httpMethod:@"POST"];
    NSLog(@"response code=%@",json);
   
     NSString *responseString=[[NSString stringWithFormat:@"%@",[json objectForKey:kResponseString]] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if ([responseString length] > 0) {
        if ([responseString isEqualToString:@"False"]) {
            //show terms & conditions
             [[DataManager shared] removeActivityIndicator];
            if ([urlAppend isEqualToString:@"user/CheckIsthisFirstLogin"]) {
                [self signUpTermsAndConditions:@"emailLogin"];
            }
            else{
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Facebook SignUp"
                                                                      action:@"Action"
                                                                       label:nil
                                                                       value:nil] build]];
                [self signUpTermsAndConditions:@"facebook"];
            }
        }
        else if ([responseString isEqualToString:@"True"]) {
            //go for login
            if ([urlAppend isEqualToString:@"user/CheckIsthisFirstLogin"]) {
               [self loginViewServerCallurlAppend:[NSString stringWithFormat:@"%@user/authenticate",serverAddress] postDictionary:postDict isKeyTokenAppend:NO apinumber:apiNumber calltype:YES];
            }
            else{
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Facebook SignIn"
                                                                      action:@"Action"
                                                                       label:nil
                                                                       value:nil] build]];
                [self fbSignUpServerCall];
            }
        }
        else if ([responseString isEqualToString:@"Invalid username or password."]){
            //invalid error
            if ([urlAppend isEqualToString:@"user/CheckIsthisFirstLogin"]) {
             [[DataManager shared] removeActivityIndicator];
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
            }
            else{
                //Facebook SignUp with new account
                [[DataManager shared]removeActivityIndicator];
                 [self signUpTermsAndConditions:@"facebook"];
            }
        }
        else{
            [[DataManager shared] removeActivityIndicator];
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"An error ocurred. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
    else{
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"An error ocurred. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview2 show];
    }
}
-(void)loginViewServerCallurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber calltype:(BOOL)isPostType
{
    currentApiNUmber=apiNumber;
    NSDictionary *apiLoginResponse;
    if(isPostType)
    {
        apiLoginResponse=[serverCall afnetworkingPostServerCall:urlAppend postdictionary:postDict isAPIkeyToken:isTokenAppend];
        NSLog(@"apiLoginResponse :%@",apiLoginResponse);
    }
    else{
        apiLoginResponse=[serverCall afnetWorkingGetServerCall:urlAppend isAPIkeyToken:isTokenAppend];
        NSLog(@"apiLoginResponse :%@",apiLoginResponse);
    }
}

#pragma mark - SignUp Terms & Conditions
- (void)signUpTermsAndConditions:(NSString *)signupVia
{
        [self.view endEditing:YES];
        [termsView removeFromSuperview];
        termsView=nil;
        termsView=[[TermsAndConditionsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        termsView.delegate=self;
        [termsView signUpMethod:signupVia];
        [self.view addSubview:termsView];
}

- (void)continueSignUpFor:(NSString *)facebookOrEmail
{
    [self removeTermsAndConditionsView];
    if ([facebookOrEmail isEqualToString:@"facebook"]) {
     
        [self fbSignUpServerCall];
    }
    else if ([facebookOrEmail isEqualToString:@"emailLogin"]){
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Email SignIn"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
          [self loginViewServerCallurlAppend:[NSString stringWithFormat:@"%@user/authenticate",serverAddress] postDictionary:loginCredentialsDictionary isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];
    }
    else{
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Email SignUp"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
        [loginView continueSignUpWithEmail];
    }

}

- (void)removeTermsAndConditionsView{
    [termsView removeFromSuperview];
    termsView=nil;
}

#pragma mark - Facebook Login Actions

-(void)fbSignUpFunction
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared ]removeActivityIndicator];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        
        NSArray *permissions=[[NSArray alloc]initWithObjects:@"email", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if(error)
             {
                 if (error.fberrorCategory == FBErrorCategoryUserCancelled)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Failed to login" message:@"App could not get the desired permissions to use your Facebook account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                     [[DataManager shared ]removeActivityIndicator];
                     
                 }
                 else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
                 {
                     [[DataManager shared ]removeActivityIndicator];
                     
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Session Error" message:@"Your current session is no longer valid. Please log in again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                 }
                 if(error.fberrorShouldNotifyUser == 1)
                 {
                     [[DataManager shared ]removeActivityIndicator];
                     
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Failed to login" message:[NSString stringWithFormat:@"%@",error.fberrorUserMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                 }
             }
             else if(FBSession.activeSession.isOpen)
             {
                 [[FBRequest requestForMe] startWithCompletionHandler:
                  ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                  {
                      if (!error)
                      {
                          NSLog(@"user=%@",user);
                          NSString *fbMailID=[user objectForKey:@"email"];
                          [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"first_name"] forKey:facebookFirstName];
                          [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"last_name"] forKey:facebooklastname];
                          NSLog(@"fbEmail=%@",fbMailID);
                          [[NSUserDefaults standardUserDefaults]setValue:fbMailID forKey:@"fbEmailAddress"];
                          NSString *token=[[[FBSession activeSession] accessTokenData] accessToken];
                          NSLog(@"token=%@",[[[FBSession activeSession] accessTokenData] accessToken]);
                          [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"fbAccessToken"];
                          [self checkFirstLoginStatusForFacebook];
//                          [self fbSignUpServerCall];
                      }
                  }];
             }
         }];
    }
}

#pragma mark -Check T&C Status for Facebook Login
-(void)checkFirstLoginStatusForFacebook
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
     NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"fbAccessToken"]],@"token",[NSString stringWithFormat:@"%@",APIKey],@"apiKey", nil];
    NSLog(@"dict=%@",postDict);
    NSString *enquiryurl=[NSString stringWithFormat:@"user/CheckIsthisFirstLogin/facebook"];
    [self checkFirstSignInurlAppend:enquiryurl postDictionary:postDict isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];
}



#pragma mark - push view Controller with delay

-(void)pushToHomeController
{
    [[DataManager shared]removeActivityIndicator];
    ViewController *mainVC=[[ViewController alloc]init];
    
    
    //add
    
    
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"VenueId=%@&",@"15103"] url:@"MyCenter" contentType:@"" httpMethod:@"POST"];
    NSDictionary *response=[json objectForKey:kResponseString];
    NSLog(@"responseDict=%@",response);
    
    
    
    [self.navigationController pushViewController:mainVC animated:YES];
    
}

-(void)fbSignUpServerCall
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    currentApiNUmber=0;
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"fbAccessToken"]],@"token",[NSString stringWithFormat:@"%@",APIKey],@"apiKey", nil];
    NSLog(@"dict=%@",postDict);
    
    NSDictionary *facebookResponse;
    NSString *facebookUrl=[NSString stringWithFormat:@"%@user/authenticate/facebook",serverAddress];
    facebookResponse=[serverCall afnetworkingPostServerCall:facebookUrl postdictionary:postDict isAPIkeyToken:NO];
}


#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)profileResponse
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:KIsFacebookLogin];
    
    NSLog(@"currentApiNUmber :%d",currentApiNUmber);
    if(currentApiNUmber==0)
    {
        if([[profileResponse objectForKey:responseCode]integerValue]==200 && [[profileResponse objectForKey:responseStringAF]length]>0)
        {
            //account already exists so login
            NSString *  responseString = [[profileResponse objectForKey:@"responseString"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [[NSUserDefaults standardUserDefaults]setValue:responseString forKey:kUserAccessToken];
            if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:KIsFacebookLogin];
                [self performSelector:@selector(pushToHomeController) withObject:nil afterDelay:0.0];
            }
            else{
                [[DataManager shared ]removeActivityIndicator];
                [self ShowErrorAlertView:@""];
            }
        }
        else if ([[profileResponse objectForKey:responseCode]integerValue]== 201 &&  [[profileResponse objectForKey:responseStringAF]length]>0)
        {
            NSString *  responseString = [[profileResponse objectForKey:@"responseString"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [[NSUserDefaults standardUserDefaults]setValue:responseString forKey:kUserAccessToken];
            if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]) {
                [self performSelector:@selector(pushToHomeController) withObject:nil afterDelay:0.0];
            }
            else{
                [[DataManager shared ]removeActivityIndicator];
                [self ShowErrorAlertView:@""];
            }
        }
        else
        {
            [[DataManager shared ]removeActivityIndicator];
            
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"An error occurred. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
    else if(currentApiNUmber==1)
    {
        if ([[profileResponse objectForKey:responseCode]integerValue]==200)
        {
            [[NSUserDefaults standardUserDefaults]setValue:[[profileResponse objectForKey:responseStringAF] stringByReplacingOccurrencesOfString:@"\"" withString:@""] forKey:kUserAccessToken];
            if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]) {
                [self performSelector:@selector(pushToHomeController) withObject:nil afterDelay:0.0];
            }
            else{
                [[DataManager shared ]removeActivityIndicator];
            }
        }
        else
        {
            [[DataManager shared ]removeActivityIndicator];
            
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:[profileResponse objectForKey:responseStringAF] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
    else if(currentApiNUmber==2)
    {
        [[DataManager shared ]removeActivityIndicator];
        
        if ([[profileResponse objectForKey:responseCode]integerValue]==200)
        {
            UIAlertView *alertView4=[[UIAlertView alloc]initWithTitle:@"" message:@"Please check your mail for the new password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView4 show];
        }
        else
        {
            [self ShowErrorAlertView:@""];
            
        }
        
    }
    else if(currentApiNUmber==3)
    {
        [[DataManager shared ]removeActivityIndicator];
        
        if ([[profileResponse objectForKey:responseCode]integerValue]!=200)
        {
            if([profileResponse objectForKey:responseStringAF]!=nil&&[profileResponse objectForKey:responseStringAF]!=[NSNull null]&&![[profileResponse objectForKey:responseStringAF] isEqualToString:@""])
            {
                UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:[profileResponse objectForKey:responseStringAF] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertview2 show];
            }
            else{
                [self ShowErrorAlertView:@""];
            }
        }
        else{
            [[NSUserDefaults standardUserDefaults]setValue:[[profileResponse objectForKey:responseStringAF] stringByReplacingOccurrencesOfString:@"\"" withString:@""] forKey:kUserAccessToken];
            if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]) {
                [self performSelector:@selector(pushToHomeController) withObject:nil afterDelay:0.0];
            }
            else{
                [[DataManager shared ]removeActivityIndicator];
            }
        }
    }
   
}

#pragma mark - Alert Error Message

-(void)ShowErrorAlertView:(NSString *)errorMessage {
    
    errorMessage=@"Some error occurred.";
    
    UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview2 show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginbackButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    BOOL isOrientationLandscape = isCampusLandsc;
    if(isOrientationLandscape)
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        //    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
