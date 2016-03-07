//
//  BuyCreditsViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 4/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "BuyCreditsViewController.h"


@interface BuyCreditsViewController ()

@end

@implementation BuyCreditsViewController
{
    BuyCreditsView *creditsView;
    NSArray *creditsArray;
    LeftSlideMenu *leftMenu;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
    

 }

- (void)creditsMainViewAddedToBaseView:(NSString *)parentViewName
{
    [self getAllPackages];
    creditsView=[[BuyCreditsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    creditsView.delegate=self;
    [creditsView creditPackages:creditsArray];
    [creditsView createCreditsViewForBaseView:parentViewName];
    [creditsView getCredits];
    [self.view addSubview:creditsView];
    [[DataManager shared]removeActivityIndicator];
    
    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.backgroundColor=[UIColor redColor];
    leftMenu.menuDelegate=self;
    leftMenu.hidden=YES;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];


}
#pragma mark - Get Users Credit Balance
-(NSDictionary *)userCredits
{
    NSDictionary *json;

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSLog(@"called");
        //  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString = [NSString stringWithFormat:@"%@userprofile/wallet?apiKey=%@&token=%@", serverAddress, APIKey, token];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:kTimeoutInterval];
        [request setHTTPMethod: @"GET"];
        NSError *error;
        NSURLResponse *urlResponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if (data)
        {
            NSLog(@"url string ==%@",urlString);
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"credits response %@",json);
        }
    }
    return json;
}


#pragma mark - Get All Credit Packages
- (void)getAllPackages
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSString *urlString = [NSString stringWithFormat:@"%@creditpackage/",serverAddress];
        NSLog(@"url=%@",urlString);
        NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
        [URLrequest setTimeoutInterval:kTimeoutInterval];
        [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@Venue?venueid=15103&token=%@&apiKey=%@",urlString,token,apiKey];
        NSLog(@"enquiryurl=%@",enquiryurl);
        [URLrequest setURL:[NSURL URLWithString:enquiryurl]];
        [URLrequest setHTTPMethod:@"GET"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 200 && responseData)
        {
            //redirect to main view
            NSError *jsonError=nil;
            creditsArray =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            NSLog(@"creditsArray=%@",creditsArray);
            NSLog(@"count==%lu",(unsigned long)creditsArray.count);
        }
        else
        {
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"An error occurred. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }

}

#pragma mark - Buy Credits Delegate Methods
- (void)removeBuyCreditsView
{
    [creditsView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buyPackageAtIndex:(int)selectedPackageIndex
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        [InAppManager sharedHelper].Delegate=self;
        if ([SKPaymentQueue canMakePayments]) {
            // Display a store to the user.
        } else {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Can't make payment" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        
        NSLog(@"%@",[[creditsArray objectAtIndex:selectedPackageIndex] objectForKey:@"productId"]);
        [[NSUserDefaults standardUserDefaults]setValue:[[creditsArray objectAtIndex:selectedPackageIndex] objectForKey:@"productId"] forKey:kSelectedPackageId];
        if(![InAppManager sharedHelper].Products || [InAppManager sharedHelper].Products)
        {
            NSString *productId=[NSString stringWithFormat:@"%@",[[creditsArray objectAtIndex:selectedPackageIndex] objectForKey:@"productId"]];
            [[InAppManager sharedHelper]RequestProductWithIdentifier:[NSSet setWithObjects:productId,nil] ];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }
        else
        {
            [[DataManager shared] removeActivityIndicator];
        }

    }
    else{
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
}

#pragma mark - Buy Package Server Post
-(void)buyPackage
{

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSString *dataString=[NSString stringWithFormat:@"productId=%@&transactionId=%@&receiptId=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"productId"],[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionId"],[[NSUserDefaults standardUserDefaults]objectForKey:@"TransactionReceipt"]];
        NSLog(@"dataString=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%d",(int)[postdata length]];
        NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
        [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        [URLrequest setTimeoutInterval:kTimeoutInterval];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@creditpackagepurchase/itunes?token=%@&apiKey=%@",serverAddress,token,APIKey]]];
        NSLog(@"url==%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@creditpackagepurchase/itunes?token=%@&apiKey=%@",serverAddress,token,APIKey]]);
        [URLrequest setHTTPMethod:@"POST"];
        [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [URLrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [URLrequest setHTTPBody:postdata];
        NSHTTPURLResponse *response=nil;
        NSError *error2=nil;
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        //    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [[DataManager shared]removeActivityIndicator];
        if(response.statusCode == 200)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Purchase is successful." delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
            alert.tag=900;
            [alert show];
        }
        else if (response.statusCode == 402)
        {
            UIAlertView *alertleftButton=[[UIAlertView alloc]initWithTitle:@"Something went wrong!" message:@"Please contact support@xbowling.com." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
            [alertleftButton show];
        }
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [self.view bringSubviewToFront:leftMenu];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            creditsView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, creditsView.frame.size.width, creditsView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], creditsView.frame.size.width, creditsView.frame.size.height)];
            mainScreenCoverView.tag=20011;
            mainScreenCoverView.userInteractionEnabled=YES;
            [self.view addSubview:mainScreenCoverView];
        }];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftMenu.frame = CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:nil];
        
    }
    else{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            creditsView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftMenu.frame = CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:^(BOOL finished){
            leftMenu.hidden=YES;
            UIView *screenCover=(UIView *)[self.view viewWithTag:20011];
            [screenCover removeFromSuperview];
            screenCover=nil;
        }];
    }
}

- (void)dismissMenu
{
    [self showMainMenu:nil];
}

#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    BOOL isOrientationLandscape = [[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"];
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

#pragma mark - In App Purchase Methods

-(void)InAppPurchaseProductLoaded:(NSArray *)Products
{
    [[DataManager shared] removeActivityIndicator];
    if (Products == nil || [Products count] == 0)
    {
        UIAlertView *alertleftButton=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Can't Load From Server" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alertleftButton setTag:1];
        [alertleftButton show];
    }
    else
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            // not connected
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failure" message:@"Internet connection is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [[DataManager shared] removeActivityIndicator];
            
        }
        else {
            //connected
            [[InAppManager sharedHelper] BuyProductAtIndex:0];
            [[DataManager shared] activityIndicatorAnimate:@"Requesting..."];
        }
    }
}

-(void)InAppPurchaseSuccessFull:(NSString *)ProductIdentifier
{
    NSLog(@"inApp success=%@",ProductIdentifier);
    [[DataManager shared] removeActivityIndicator];
    [[DataManager shared] activityIndicatorAnimate:@"Purchasing..."];
    NSString *productId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kSelectedPackageId]];
    if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"Product.productIdentifier"] isEqualToString:productId])
    {
        [[DataManager shared] removeActivityIndicator];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Purchase"];
    }
}

-(void)transactionCompleted
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self buyPackage];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if(alertView.tag==900 || alertView.tag == 901)
        {
//            UIButton *btn=(UIButton *)[self.view viewWithTag:9001];
//            NSLog(@"btn=%@",btn);
//            [btn setHighlighted:NO];
//            btn.userInteractionEnabled = NO;
//            btn.enabled = NO;
            [creditsView getCredits];
        }
    }
}

-(void)InAppPurchaseFailed:(SKPaymentTransaction *)Transaction
{
    [[DataManager shared] removeActivityIndicator];
    if (Transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:Transaction.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil] ;
        [alert show];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if ([self respondsToSelector:@selector(restoreTransaction:)])
    {
        // [self restoreTransaction:transactions];
        return;
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    // NSLog(@"%@",error);
}

- (void) checkPurchasedItems
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"productIdentifier"]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    // NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog(@"%@",purchasedItemIDs);
    }
}

- (void)timeout:(id)arg
{
    if([InAppManager sharedHelper].Products.count==0)
        [SVProgressHUD showErrorWithStatus:@"Timeout"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
