//
//  XBProViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 3/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "XBProViewController.h"

@interface XBProViewController ()
{
    UserStatsClass *view;
    LeftSlideMenu *leftMenu;
    FilterView *filterView;
    SelectCenterView *selectCenterView;
    SelectCenterModel *selectCenterModelInstance;
    BuyXBProPackage *buyPackageView;
    NSMutableDictionary *commonStandardsDictionary;
    NSMutableDictionary *selectedCenterDetails;
    NSMutableDictionary *selectedCountryDetails;
    NSMutableDictionary *selectedStateDetails;
    NSMutableDictionary *filterCenterDetails;
    NSMutableArray *tagsArray;
     BOOL isOrientationLandscape;
    int subscriptionCount;
    NSArray *packageArray;
    BOOL resetFilterBool;
    NSString *filterSection;
    BOOL viaScoresAndStatistics;
    id<GAITracker> tracker;
}
@end

@implementation XBProViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    resetFilterBool=YES;
     tracker = [[GAI sharedInstance] defaultTracker];
//     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInChallengeView];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kfilterVenueId];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:koilPattern];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kpatternLength];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"0"] forKey:kGameType];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kduration];
     [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kfilterTag];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterCountryIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterStateIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterVenueIndex];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kselectedGraph];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showFilter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFilterforGraph) name:@"showFilter" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"graphRemoved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMethodAfterGraphIsRemoved) name:@"graphRemoved" object:nil];
    subscriptionCount=0;
    // Do any additional setup after loading the view.

    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    leftMenu.hidden=YES;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    NSDictionary *json=[[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/CommonStandardsNew" contentType:@"" httpMethod:@"GET"];
    NSLog(@"response in MainVC=%@",json);
    NSDictionary *responseDictionary;
    if([[json objectForKey:kResponseStatusCode] integerValue] == 200)
    {
        responseDictionary=[json objectForKey:@"responseString"];
        NSLog(@"responseDict=%@",responseDictionary);
        if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
            commonStandardsDictionary=[[NSMutableDictionary alloc]initWithDictionary:[responseDictionary objectForKey:@"commonStatsStandards"]];
        }
        int subscription=[[responseDictionary objectForKey:@"subcriptionStatus"] intValue];
        if(subscription == 1)
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserStatsPackagePurchased];
            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/UserStatSettingsList" contentType:@"" httpMethod:@"GET"];
            NSDictionary *response=[json objectForKey:kResponseString];
            NSLog(@"responseDict=%@",response);
            if([[json objectForKey:kResponseStatusCode] intValue] == 200 && [response isKindOfClass:[NSDictionary class]])
            {
                [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"ballType"] integerValue] forKey:kBallTypeBoolean];
                [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"oilPattern"] integerValue] forKey:kOilPatternBoolean];
                [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"brooklynPercentage"] integerValue] forKey:kPocketBrooklynBoolean];
            }
        }
        else
        {
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kUserStatsPackagePurchased];
            NSDictionary *json=[[ServerCalls instance] serverCallWithQueryParameters:@"venueid=15103&" url:@"userstat/PlanList/Venue" contentType:@"" httpMethod:@"GET"];
            NSLog(@"response in MainVC=%@",json);
            if([[json objectForKey:kResponseStatusCode] integerValue] == 200)
            {
                NSArray *response=[json objectForKey:@"responseString"];
                subscriptionCount=(int)response.count;
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kUserStatsPackagePurchased];
//                [[DataManager shared]removeActivityIndicator];
            }
        }
    }
    [self getAllTags];
    filterSection=@"XBPro";
    view=[[UserStatsClass alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.delegate=self;
    view.subscriptionCount=subscriptionCount;
    [self.view addSubview:view];
    [view myStats];
    
    if (viaScoresAndStatistics) {
        [view showMyGames];
        viaScoresAndStatistics=NO;
    }

}

#pragma mark - Get All Tags
- (void)getAllTags
{
    NSDictionary *json=[[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"Tags/TagListUserSpecific" contentType:@"" httpMethod:@"GET"];
    NSLog(@"response in MainVC=%@",json);
    if([[json objectForKey:kResponseStatusCode] integerValue] == 200)
    {
        NSArray *response=[json objectForKey:@"responseString"];
        tagsArray=[[NSMutableArray alloc]initWithArray:response];
    }
    [[DataManager shared]removeActivityIndicator];
}

#pragma mark - My Games Delegate Methods
- (void)showGamePlayforPlayer:(NSDictionary *)playerInfoDictionary
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[playerInfoDictionary objectForKey:@"scoredGame"] objectForKey:@"name"]] forKey:kHistoryGameName];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kInGameHistoryView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kliveScoreUpdate];
    BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
    [bowlingVC createGameViewforCategory:@"History"];
    [self.navigationController pushViewController:bowlingVC animated:YES];
    [bowlingVC historyGameData:playerInfoDictionary];
}

#pragma mark - User Stats Delegate Methods
- (MyGamesView *)showMyGames:(int)yCoordinate
{
    filterSection=@"MyGames";
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    //current date
    NSDate *currentDate=[NSDate date];
    NSLog(@"currentDate=%@",currentDate);
    NSString *format=@"MM/dd/yyyy";
    NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
    NSString *displayDate=[formatterUtc stringFromDate:currentDate];
    NSLog(@"displayDate=%@",displayDate);
    NSString *queryParameter=[[NSString stringWithFormat:@"timeDuration=%@&Tag=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kduration]] isEqualToString:@"daily"]) {
        queryParameter=[[NSString stringWithFormat:@"timeDuration=%@&Tag=%@&currentDate=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag],displayDate] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    NSDictionary *json=[[ServerCalls instance] serverCallWithQueryParameters:queryParameter url:@"scoredbowlinggame/getmygameHistory" contentType:@"" httpMethod:@"GET"];
    NSLog(@"response in MainVC=%@",json);
    NSArray *response;
    [[DataManager shared]removeActivityIndicator];
    if([[json objectForKey:kResponseStatusCode] integerValue] == 200)
    {
        response=[json objectForKey:@"responseString"];
    }
    MyGamesView *gameView=[[MyGamesView alloc]initWithFrame:CGRectMake(0, yCoordinate, self.view.frame.size.width, self.view.frame.size.height)];
    gameView.delegate=self;
    [gameView createMyGames:response];
    return gameView;
}

- (void)showMyGamesSection
{
    viaScoresAndStatistics=YES;
}

- (void)removeUserStats
{
    [view removeFromSuperview];
    view=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startTrialFunction
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Start Trial of XB Pro"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/FreeSubscription" contentType:@"" httpMethod:@"POST"];
    if([[json objectForKey:kResponseStatusCode] integerValue] == 201)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserStatsPackagePurchased];
        [view myStats];
        [[DataManager shared] removeActivityIndicator];
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
        
    }
}

- (void)showGraphsView
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
    //        [[UIDevice currentDevice] setValue:
    //         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
    //                                    forKey:@"orientation"];
    [self supportedInterfaceOrientations:YES];
    [self performSelector:@selector(pushToGraphsViewController) withObject:nil afterDelay:0.0];
}

- (void)pushToGraphsViewController
{
    GraphsViewController *graphVC=[[GraphsViewController alloc]init];
    [self.navigationController pushViewController:graphVC animated:NO];
}

- (void)notificationMethodAfterGraphIsRemoved
{
    [view graphViewRemoved];
}
- (void)showBuyPackageView
{
    packageArray=[[NSArray alloc] initWithObjects:@"network.sportschallenge.scnstrikefirst.xbpsmonthlyfixed",@"network.sportschallenge.scnstrikefirst.xbpsannualfixed",nil];
    buyPackageView=[[BuyXBProPackage alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    buyPackageView.delegate=self;
    [self.view addSubview:buyPackageView];
}

- (void)shareOnFacebook
{
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/scn-strike-first/id1060911495?l=zh&ls=1&mt=8"];
    content.contentDescription=@"Hey!! I am using SCN Strike First XB PRO Stats to analyze my advanced stats to gain better insights into my performance. Try it.";
    content.contentTitle=@"SCN Strike First XB PRO Stats";
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
    [[DataManager shared]removeActivityIndicator];
    if(results!=nil){
        if([[results allKeys] containsObject:@"postId"]){
            UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully posted on Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
        }
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    [[DataManager shared]removeActivityIndicator];

    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
    [[DataManager shared]removeActivityIndicator];

}

#pragma mark - Buy XBPro Package Delegate
- (void)removeBuyPackageView
{
    [buyPackageView removeFromSuperview];
    buyPackageView=nil;
}

#pragma mark - In App Purchase Methods
-(void)inAppPurchaseFunction:(int)selectedSubscriptionPackage
{
    
    if(selectedSubscriptionPackage == 99)
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Please select some option." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        [InAppManager sharedHelper].Delegate=self;
//        if ([SKPaymentQueue canMakePayments]) {
//            // Display a store to the user.
//            
//        } else {
//          
//            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Can't make payment" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//        }
             [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        
        NSString *productId=[NSString stringWithFormat:@"%@",[packageArray objectAtIndex:selectedSubscriptionPackage]];
        NSLog(@"productId=%@",productId);
        if ([productId isEqualToString:@"network.sportschallenge.scnstrikefirst.xbpsmonthlyfixed"]) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"XB Pro Monthly Package"
                                                                  action:@"Action"
                                                                   label:nil
                                                                   value:nil] build]];
        }
        else{
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"XB Pro Yearly Package"
                                                                  action:@"Action"
                                                                   label:nil
                                                                   value:nil] build]];

        }
        [[NSUserDefaults standardUserDefaults]setValue:[packageArray objectAtIndex:selectedSubscriptionPackage] forKey:kSelectedPackageId];
        [[InAppManager sharedHelper]RequestProductWithIdentifier:[NSSet setWithObjects:productId,nil] ];
        [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
    }
}

-(void)InAppPurchaseProductLoaded:(NSArray *)Products
{
    [[DataManager shared] removeActivityIndicator];
    if (Products == nil || [Products count] == 0)
    {
        UIAlertView *alertleftButton=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Can't Load From Server" delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alertleftButton setTag:1];
        [alertleftButton show];
        
    }
    else
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        
        if (netStatus == NotReachable) {
            // not connected
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failure" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [[DataManager shared] removeActivityIndicator];
            
        }
        else {
            //connected
            
            [[InAppManager sharedHelper] BuyProductAtIndex:0];
            [[DataManager shared] activityIndicatorAnimate:@"Requesting..."];
            
        }
    }
    //[[DataManager shared] removeActivityIndicator];
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
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserStatsPackagePurchased];
    }
}

-(void)transactionCompleted
{
    //    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self buyPackage];
}

-(void)buyPackage
{


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
    [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Userstatsubscription/itunes?token=%@&apiKey=%@",serverAddress,token,APIKey]]];
    NSLog(@"url==%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@Userstatsubscription/itunes?token=%@&apiKey=%@",serverAddress,token,APIKey]]);
    [URLrequest setHTTPMethod:@"POST"];
    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [URLrequest setHTTPBody:postdata];
    NSHTTPURLResponse *response=nil;
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:nil];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    
    if(response.statusCode == 200)
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Purchase is successful."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil] ;
            alert.tag=900;
            [alert show];
        });
    }
    else if (response.statusCode == 402)
    {
        UIAlertView *alertleftButton=[[UIAlertView alloc]initWithTitle:@"Something went wrong!" message:@"Please contact support@xbowling.com." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alertleftButton show];
    }
    else{
        UIAlertView *alertleftButton=[[UIAlertView alloc]initWithTitle:@"Something went wrong!" message:@"Please contact support@xbowling.com." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alertleftButton show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];

    if(alertView.tag == 900)
    {
        [self removeBuyPackageView];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserStatsPackagePurchased];
        [view myStats];
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

// Call This Function

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

#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    isOrientationLandscape = [[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"];
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

- (NSUInteger)supportedInterfaceOrientations
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"])
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        // objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        // objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)deviceOrientationDidChange
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"])
    {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            return YES;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
            return NO;
        }
    }
    else
    {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
            return YES;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
            return NO;
        }
    }
    return YES;
    // Do your Code using the current Orienation
}

-(void) rotateController:(UIViewController *)controller degrees:(NSInteger)aDgrees
{
    UIScreen *screen = [UIScreen mainScreen];
    if(aDgrees>0)
        controller.view.bounds = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    else
    {
        controller.view.bounds = CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height);
    }
    controller.view.transform = CGAffineTransformConcat(controller.view.transform, CGAffineTransformMakeRotation(M_PI_2/90));
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
}


#pragma mark - Filter
- (void)showFilterforGraph{
    [self showFilterViewforSection:@"XBPro"];
}

- (void)showFilterViewforSection:(NSString *)section
{
    [filterView updateFiltersInteractionForSection:section];
    if ([filterView isHidden]) {
        filterView.hidden=NO;
        [self.view bringSubviewToFront:filterView];
    }
    else
    {
        [filterView removeFromSuperview];
        filterView=[[FilterView alloc]init];
        filterView.delegate=self;
        filterView.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        NSArray *filtersArray=[[NSArray alloc]initWithObjects:@"Time",@"Location",@"Oil Pattern",@"Pattern Length",@"Game Type",@"Tag", nil];
        NSArray *valuesArray=[[NSArray alloc]initWithObjects:@"All Time ",@"Everywhere",@"All",@"All",@"All",@"All", nil];
        NSMutableArray *dropdownInfoArray=[NSMutableArray new];
        NSArray *timeArray=[[NSArray alloc]initWithObjects:@"All Time",@"Today",@"This Week",@"This Month",@"This Year", nil];
        [dropdownInfoArray addObject:timeArray];
        NSMutableArray *oilPatternValuesArray=[[NSMutableArray alloc]init];
        NSMutableArray *patternLengthValuesArray=[[NSMutableArray alloc]init];
        NSMutableArray *gameTypeValuesArray=[[NSMutableArray alloc]init];
        NSLog(@"%@",commonStandardsDictionary);
        if ([commonStandardsDictionary isKindOfClass:[NSDictionary class]]) {
            if (commonStandardsDictionary.count > 0) {
                if ([[commonStandardsDictionary objectForKey:@"userStatPatternNameList"] isKindOfClass:[NSArray class]]) {
                    NSArray *oilPatternArray=[[NSArray alloc]initWithArray:[commonStandardsDictionary objectForKey:@"userStatPatternNameList"]];
                    [oilPatternValuesArray addObject:@"Select Oil Pattern"];
                    for (int i=0; i<oilPatternArray.count; i++) {
                        [oilPatternValuesArray addObject:[NSString stringWithFormat:@"%@",[[oilPatternArray objectAtIndex:i] objectForKey:@"patternName"]]];
                    }
                }
                if ([[commonStandardsDictionary objectForKey:@"userStatPatternLengthList"] isKindOfClass:[NSArray class]]) {
                    NSArray *patternLengthArray=[[NSArray alloc]initWithArray:[commonStandardsDictionary objectForKey:@"userStatPatternLengthList"]];
                    [patternLengthValuesArray addObject:@"Select Pattern Length"];
                    for (int i=0; i<patternLengthArray.count; i++) {
                        [patternLengthValuesArray addObject:[NSString stringWithFormat:@"%@",[[patternLengthArray objectAtIndex:i] objectForKey:@"patternLength"]]];
                    }
                }
                if ([[commonStandardsDictionary objectForKey:@"userStatCompetitionTypeList"] isKindOfClass:[NSArray class]]) {
                    NSArray *gameTypeArray=[[NSArray alloc]initWithArray:[commonStandardsDictionary objectForKey:@"userStatCompetitionTypeList"]];
                    [gameTypeValuesArray addObject:@"Select Game Type"];
                    for (int i=0; i<gameTypeArray.count; i++) {
                        [gameTypeValuesArray addObject:[NSString stringWithFormat:@"%@",[[gameTypeArray objectAtIndex:i] objectForKey:@"competition"]]];
                    }
                }
               

            }
        }
        
        [dropdownInfoArray addObject:oilPatternValuesArray];
        [dropdownInfoArray addObject:patternLengthValuesArray];
        [dropdownInfoArray addObject:gameTypeValuesArray];

        NSMutableArray *tagsNamesArray=[[NSMutableArray alloc]init];
        if ([tagsArray isKindOfClass:[NSArray class]]) {
            [tagsNamesArray addObject:[NSString stringWithFormat:@"All Tags"]];
            for (int i=0; i<tagsArray.count; i++) {
                [tagsNamesArray addObject:[NSString stringWithFormat:@"%@",[[tagsArray objectAtIndex:i] objectForKey:@"tag"]]];
            }
        }
        [dropdownInfoArray addObject:tagsNamesArray];
        if (selectCenterView) {
            [selectCenterView removeFromSuperview];
            selectCenterView=nil;
            selectCenterView.centerSelectionDelegate=nil;
        }
        selectCenterView=[[SelectCenterView alloc]init];
        selectCenterView.centerSelectionDelegate=self;
        selectCenterModelInstance=[SelectCenterModel shared];
        [filterView createView:filtersArray filterInitialValues:valuesArray centerView:selectCenterView forSuperView:section];
        [filterView filterDropdownInfo:dropdownInfoArray];
        [self.view addSubview:filterView];
    }
    
}

- (void)removeFilterView
{
    filterView.hidden=YES;
    if (resetFilterBool) {
        [view applyFilters];
        [view resetFiltersFunction];
        [filterView resetButtonFunction];
        resetFilterBool=NO;
    }
    else{
        [view applyFilters];
    }
}
- (void)filterDoneFunction:(NSMutableArray *)filterValuesDict
{
    @try {
        resetFilterBool=YES;
        NSLog(@"Filter done function=%@",filterValuesDict);
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        filterView.hidden=YES;
        int administrativeId,countryId,venueId;

        if (selectedCenterDetails.count > 0) {
            if ([[selectedCenterDetails objectForKey:@"id"] intValue] == 0) {
                administrativeId=[[selectedStateDetails objectForKey:@"administrativeAreaId"] intValue];
                countryId=[[selectedCountryDetails objectForKey:@"countryId"] intValue];
                venueId=0;
            }
            else
            {
                filterCenterDetails=[[NSMutableDictionary alloc]initWithDictionary:selectedCenterDetails];
                administrativeId=[[[[filterCenterDetails objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"id"] intValue];
                countryId=[[[[filterCenterDetails objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"id"] intValue];
                venueId=[[filterCenterDetails objectForKey:@"id"] intValue];
            }
        }
        else
        {
            administrativeId=[[selectedStateDetails objectForKey:@"administrativeAreaId"] intValue];
            countryId=[[selectedCountryDetails objectForKey:@"countryId"] intValue];
            venueId=0;
        }
        NSLog(@"Filter done function=%@",filterCenterDetails);
//        NSLog(@"Filter done function=%@",commonStandardsDictionary);
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",venueId] forKey:kfilterVenueId];
        int oilPatternId=0;
        int patternLengthId=0;
        int gameId=0;
        int check=[[filterValuesDict objectAtIndex:0] intValue];
        if (check == 0) {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kduration];
        }
        else if(check == 1)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"daily" forKey:kduration];
        }
        else if (check ==2)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"week" forKey:kduration];
        }
        else if (check ==3)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"month" forKey:kduration];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"year" forKey:kduration];
        }
        if ([[filterValuesDict objectAtIndex:1] integerValue] != 0) {
            oilPatternId=[[[[commonStandardsDictionary objectForKey:@"userStatPatternNameList"] objectAtIndex:([[filterValuesDict objectAtIndex:1] integerValue] - 1)] objectForKey:@"id"] intValue];
        }
        if ([[filterValuesDict objectAtIndex:2] integerValue] != 0) {
            NSLog(@"%@",[[[commonStandardsDictionary objectForKey:@"userStatPatternLengthList"] objectAtIndex:([[filterValuesDict objectAtIndex:2] integerValue] - 1)] objectForKey:@"id"]);
            patternLengthId=[[[[commonStandardsDictionary objectForKey:@"userStatPatternLengthList"] objectAtIndex:([[filterValuesDict objectAtIndex:2] integerValue] - 1)] objectForKey:@"id"] intValue];
            NSLog(@"%d",patternLengthId);

        }
        if ([[filterValuesDict objectAtIndex:3] integerValue] != 0) {
            int index=([[filterValuesDict objectAtIndex:3] intValue] - 1);
            if (index == 0) {
                //League
                gameId=2;
            }
            else if (index == 1){
                //Practice
                gameId=1;
            }
            else{
                //Tournament
                gameId=3;
            }
        }
        if ([[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:4]] length]>0) {
            if ([[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:4]] isEqualToString:@"0"]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kfilterTag];
            }
            else
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[tagsArray objectAtIndex:([[filterValuesDict objectAtIndex:4] integerValue]-1)] objectForKey:@"tag"]] forKey:kfilterTag];
        }
        
    
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",oilPatternId] forKey:koilPattern];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",gameId] forKey:kGameType];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",patternLengthId] forKey:kpatternLength];
        [view applyFilters];
        [[DataManager shared]removeActivityIndicator];

    }
    @catch (NSException *exception) {
        [[DataManager shared]removeActivityIndicator];
    }
    
}

- (void)resetFilters
{
    resetFilterBool=YES;
    selectedCenterDetails=nil;
    [view resetFiltersFunction];
}

#pragma  mark - Venue Information
- (void)venueInfo
{
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@""];
    if ([self.view.subviews lastObject]== filterView) {
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:responseArray];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"countryId",@"All Countries",@"displayName", nil];
        [temp insertObject:dict atIndex:0];
//        for (int i=1; i<=responseArray.count; i++) {
//            NSDictionary *stateDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"All States",@"displayName",@"0",@"administrativeAreaId", nil];
//            NSMutableArray *statesArray=[[NSMutableArray alloc]initWithArray:[[temp objectAtIndex:i]objectForKey:@"states"]];
//            [statesArray insertObject:stateDict atIndex:0];
//            NSMutableDictionary *countryDict=[[NSMutableDictionary alloc]initWithDictionary:[temp objectAtIndex:i]];
//            [countryDict removeObjectForKey:@"states"];
//            [countryDict setValue:statesArray forKey:@"states"];
//            [temp replaceObjectAtIndex:i withObject:countryDict];
//            NSLog(@"temp=%@",temp);
//        }
        
        selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:temp];
    }
    else
        selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:responseArray];
    NSLog(@"countries=%@",selectCenterView.countryInfoDict);
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@""];
//    if ([self.view.subviews lastObject]== filterView) {
//        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:responseArray];
//        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"All Centers",@"name", nil];
//        [temp insertObject:dict atIndex:0];
//        selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:temp];
//    }
//    else
        selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
    
}

- (void)getNearbyCenter
{
    NSMutableArray *indexArray=[[NSMutableArray alloc]init];
    if ([self.view.subviews lastObject]== filterView) {
        for (int i=0; i<3; i++) {
            [indexArray addObject:@"0"];
        }
        //        if (filterCenterDetails.count > 0) {
        //            indexArray=[selectCenterModelInstance setInitialVenue:[filterCenterDetails objectForKey:@"countryDisplayName"] state:[filterCenterDetails objectForKey:@"longName"] center:[filterCenterDetails objectForKey:@"name"]];
        //        }
        //        else
        //        {
        //            indexArray=[selectCenterModelInstance getNearbyCenterIndex:@""];
        //        }
        //        [selectCenterView nearbyCenter:indexArray];
        
    }
    else
    {
        indexArray =[selectCenterModelInstance getNearbyCenterIndex:@""];
    }
    [selectCenterView nearbyCenter:indexArray];
}

-(void)updateCenterInfo
{
    NSArray *responseArray=[selectCenterModelInstance updatedCenterArray];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
}

- (void)removeCenterSelectionView{
    
}

#pragma mark - Select Center Delegate Methods

- (void)selectedCenterDictionary:(NSDictionary *)dictionary
{
    selectedCenterDetails=[[NSMutableDictionary alloc]initWithDictionary:dictionary];
}

- (void)updateCenterInformation:(int)totalLanes selectedCountry:(NSString *)country selectedState:(NSString *)state selectedCenter:(NSString *)center
{
    
}

- (void)selectedCountryDictionary:(NSDictionary *)countryDictionary state:(NSDictionary *)stateDictionary
{
    selectedCountryDetails=[[NSMutableDictionary alloc]initWithDictionary:countryDictionary];
    selectedStateDetails=[[NSMutableDictionary alloc]initWithDictionary:stateDictionary];
    
}

-(void)updateFilterView:(int)height
{
    [filterView updateFilterView:height];
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [self.view bringSubviewToFront:leftMenu];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            view.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, view.frame.size.width, view.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], view.frame.size.width, view.frame.size.height)];
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
            view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
