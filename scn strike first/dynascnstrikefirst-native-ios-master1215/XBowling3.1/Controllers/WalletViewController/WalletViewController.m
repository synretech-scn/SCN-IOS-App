//
//  WalletViewController.m
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "WalletViewController.h"

@interface WalletViewController ()
{
    WalletView *mainView;
    LeftSlideMenu *leftMenu;
    AddCenterView *centerView;
    PointsView *pointsView;
    OfferingsListView *offeringsView;
    SelectCenterModel *selectCenterModelInstance;
    PasscodeView *passcodeView;
    NSUInteger selectedVenueId;
    NSMutableArray *loyaltyCentersArray;
    ServerCalls *serverCallInstance;
    ImageVerificationView *barcodeImageView;
    OfferingsListView *offeringsViewForItemLists;
    ShippingInformationView *addressView;
    NSMutableArray *countryInfoDict;
    int countryIndex;
}
@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    serverCallInstance=[ServerCalls instance];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
}

#pragma mark - Main View
- (void)createMainWalletView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSArray *walletCenters=[self getListOfLoyaltyCentersForUser:[[NSUserDefaults standardUserDefaults]valueForKey:kuserId]];
    NSDictionary *pointsDictionary = [self userCredits];
    mainView=[[WalletView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainView.delegate=self;
    [mainView createWalletView:walletCenters forXBowlingPoints:pointsDictionary];
    [self.view addSubview:mainView];
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

#pragma mark - Server Calls
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
            [[NSUserDefaults standardUserDefaults]setValue:[json objectForKey:@"availableRewardPoints"] forKey:kRewardPoints];
        }
    }
    return json;
}

- (NSArray *)getListOfLoyaltyCentersForUser:(NSString *)userId
{
    if (serverCallInstance == nil) {
        serverCallInstance=[ServerCalls instance];
    }
    NSArray *jsonArray=[NSArray new];
    NSString *urlString = [NSString stringWithFormat:@"venue/venuepointslist"];
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0) {
//        NSDictionary *responseDict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]];
        jsonArray=[json objectForKey:kResponseString];
        loyaltyCentersArray=[[NSMutableArray alloc]initWithArray:jsonArray];
    }
    return jsonArray;
}

- (NSDictionary *)getPointsForVenue:(NSUInteger)venueId
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"venue/%lu/userpointPair",(unsigned long)venueId];
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    return json;
}

- (NSDictionary *)getListOfOfferings:(NSUInteger)venueId status:(NSString *)status
{
//    venueId=10977; //only center with offerings
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"businessbuildervault/%lu",(unsigned long)venueId];
    if ([status isEqualToString:@"Redeem"]) {
        urlString = [NSString stringWithFormat:@"businessbuildervault/redemption/%lu",(unsigned long)venueId];
    }
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    return json;
}



#pragma mark - Main View Delegate Methods
- (void)showAddCenterView
{
    centerView=[[AddCenterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    centerView.delegate=self;
    [centerView createMainView];
    [self.view addSubview:centerView];
    selectCenterModelInstance=[SelectCenterModel shared];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterInfo) name:@"UpdateCenterInformation" object:nil];
    
}

- (void)showPointsViewForCenter:(NSDictionary *)centerDictionary
{
    NSUInteger venueId=[[centerDictionary objectForKey:@"venueId"] integerValue];
    selectedVenueId=venueId;
    NSString *venueName=[centerDictionary objectForKey:@"venueName"];
    NSDictionary *json= [self getPointsForVenue:venueId];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0) {
        NSDictionary *responseDict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]];
        NSMutableArray *pointsArray=[NSMutableArray new];
        NSString *lifetimePoints=[[responseDict objectForKey:@"lifeTimePoint"] stringValue];
        NSString *availablePoints=[[responseDict objectForKey:@"totalAvaliablePoints"] stringValue];
        [pointsArray addObject:lifetimePoints];
        [pointsArray addObject:availablePoints];
        pointsView=[[PointsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        pointsView.delegate=self;
        [pointsView createViewForCenter:venueName venueId:venueId pointsArray:pointsArray];
        [self.view addSubview:pointsView];
    }
   
}

- (void)showRewardPointsView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"geolocation"];
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    [[DataManager shared] removeActivityIndicator];
     [mainView reloadList];
    if ([json objectForKey:kResponseString] != nil) {
        if([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"countryCode"]] isEqualToString:@"US"])
        {
            if(([[[NSUserDefaults standardUserDefaults]objectForKey:kRewardPoints ] integerValue]>110000)&&([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"AZ"]))
            {
                NSString * usalertmessage=@"In accordance with certain restrictions in Arizona state law, XBowlers from the great State of Arizona are not allowed to redeem SCN Reward Points for any single prize with a value in excess of 110,000 Points.Please adjust your seletions accordingly.  Happy shopping!";
                UIAlertView *usalert=[[UIAlertView alloc]initWithTitle:@"Who would have guessed?" message:usalertmessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [usalert show];
                
            }
            else if(([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"AK"])||([[self convertToString:[json objectForKey:@"regionCode"]] isEqualToString:@"HI"])||([[self convertToString:[json objectForKey:@"regionCode"]] isEqualToString:@"VT"]))
            {
                NSString *apologize1message=@"For regulatory reasons, we are currently not able to allow the redemption of SCN Reward Points for prizes in scn.location().regionName +  to XBowlers accessing our service from within that State. We have noted your request and will contact you if/when XBowling begins offering the redemption opportunity within the State of  + scn.location().regionName";
                UIAlertView *apologiz1ealert=[[UIAlertView alloc]initWithTitle:@"We apologize!" message:apologize1message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [apologiz1ealert show];
                
            }
            else if(([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"MT"])||([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"SC"])||([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"NJ"])||([[self convertToString:[json objectForKey:@"regionCode"]] isEqualToString:@"TN"])||([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"WA"])||([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"SD"])||([[self convertToString:[[json objectForKey:kResponseString] objectForKey:@"regionCode"]] isEqualToString:@"NH"]))
            {
                NSString *apologize2message=@"For regulatory reasons, we are currently not able to allow the redemption of SCN Reward Points for prizes in your state.  We are working with regulatory authorities so we can provide you with this feature, although there is no guarantee that we will be able to do so.  We will notify you as soon as this option is available in your state.  In the meantime, please enjoy XBowling!";
                UIAlertView *apologize2alert=[[UIAlertView alloc]initWithTitle:@"We apologize!" message:apologize2message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [apologize2alert show];
            }
            else{
                //show list of categories
                    NSMutableArray *categoryvalue=[[NSMutableArray alloc]initWithObjects:@"Browse All",@"Sporting+Goods",@"Games",@"Bowling+Balls",@"Bowling+Pins",@"Bowling+Bags",@"Toys",@"Clothing",@"Electronics",@"Watches",@"Home+Goods", nil];
                offeringsView=[[OfferingsListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                offeringsView.delegate=self;
                [offeringsView createViewForList:categoryvalue forCategory:@"RewardPointsMainCategories" userAvailablePoints:[[[NSUserDefaults standardUserDefaults]valueForKey:kRewardPoints] intValue]];
                [self.view addSubview:offeringsView];
                
            }
        }
        else{
            [[DataManager shared]removeActivityIndicator];
            NSString *apologize3message=@"We currently offer our prize redemption capability only in the United States.  An expanded international redemption program is coming soon!  Keep playing and winning!";
            UIAlertView *apologize3alert=[[UIAlertView alloc]initWithTitle:@"We apologize!" message:apologize3message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [apologize3alert show];
            
        }
    }
    else {
        UIAlertView *apologiz1ealert=[[UIAlertView alloc]initWithTitle:@"We apologize!" message:@"This service is not currently available. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [apologiz1ealert show];
    }
}

#pragma mark - String Conversion
-(NSString *)convertToString:(id)string
{
    return [NSString stringWithFormat:@"%@",string];
}

#pragma mark - Shipping Information Delegate
- (void)removeAddressView
{
    [addressView removeFromSuperview];
    addressView=nil;
}
- (void)submitAddressInformation:(NSDictionary *)address
{
    NSError *error = NULL;
    NSData* data = [NSJSONSerialization dataWithJSONObject:address
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    NSString* dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postlength=[NSString stringWithFormat:@"%d",(int)[postdata length]];
    NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
    [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [URLrequest setTimeoutInterval:kTimeoutInterval];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@redemptionrequest?token=%@&apiKey=%@",serverAddress,token,APIKey]]];
    NSLog(@"url==%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@redemptionrequest?token=%@&apiKey=%@",serverAddress,token,APIKey]]);
    [URLrequest setHTTPMethod:@"POST"];
    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [URLrequest setHTTPBody:postdata];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    //    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
        [[DataManager shared] removeActivityIndicator];
        if((response.statusCode == 200 || response.statusCode == 201) && responseData)
        {
              [[[UIAlertView alloc]initWithTitle:@"Reward Points Redeemed" message:[NSString stringWithFormat:@"Points are redeemed successfully."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
        }
        else if(((long)response.statusCode)==406)
        {
            UIAlertView *NotAcceptablealert = [[UIAlertView alloc]
                                               initWithTitle:nil
                                               message:@"Not Acceptable "
                                               delegate:nil
                                               cancelButtonTitle: nil
                                               otherButtonTitles:@"OK", nil ];
            [NotAcceptablealert show];
        }
        else if(((long)response.statusCode)==403)
        {
            UIAlertView *Forbiddon = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:@"Forbidden"
                                      delegate:nil
                                      cancelButtonTitle: nil
                                      otherButtonTitles:@"OK", nil ];
            [Forbiddon show];
        }
        else if(((long)response.statusCode)==400)
        {
            UIAlertView *BadRequest = [[UIAlertView alloc]
                                       initWithTitle:nil
                                       message:@"Bad Request"
                                       delegate:nil
                                       cancelButtonTitle: nil
                                       otherButtonTitles:@"OK", nil ];
            [BadRequest show];
        }
        else if(((long)response.statusCode)==409)
        {
            UIAlertView *Conflict = [[UIAlertView alloc]
                                     initWithTitle:nil
                                     message:@"Conflict"
                                     delegate:nil
                                     cancelButtonTitle: nil
                                     otherButtonTitles:@"Ok", nil ];
            [Conflict show];
        }

}


#pragma mark - Offerings Delegates
- (void)submitSelection:(NSDictionary *)selectedItemDictionary forCategory:(NSString *)category
{
    passcodeView=[[PasscodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    passcodeView.delegate=self;
    [passcodeView createPasscodeViewFor:category item:selectedItemDictionary];
    [self.view addSubview:passcodeView];
}

- (void)removeOfferingsViewForCategory:(NSString *)category
{
    if ([category isEqualToString:@"rewardPointsItems"]) {
        [offeringsViewForItemLists removeFromSuperview];
        offeringsViewForItemLists = nil;
    }
    else if ([category isEqualToString:@"RewardPointsMainCategories"]){
        [offeringsView removeFromSuperview];
        offeringsView=nil;
        [mainView reloadList];
    }
    else{
        [offeringsView removeFromSuperview];
        offeringsView=nil;
        [[DataManager shared]showActivityIndicator:@"Loading..."];
        NSDictionary *json= [self getPointsForVenue:selectedVenueId];
        if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0) {
            NSDictionary *responseDict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]];
            NSMutableArray *pointsArray=[NSMutableArray new];
            NSString *lifetimePoints=[[responseDict objectForKey:@"lifeTimePoint"] stringValue];
            NSString *availablePoints=[[responseDict objectForKey:@"totalAvaliablePoints"] stringValue];
            [pointsArray addObject:lifetimePoints];
            [pointsArray addObject:availablePoints];
            [pointsView updatePoints:pointsArray];
        }
        [[DataManager shared]removeActivityIndicator];
    }
}

- (void)showItemsForRewardPointCategory:(NSString *)category
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"redemptionproduct"];
    NSString *queryParameters = @"";
    if (![category isEqualToString:@"Browse All"]) {
        queryParameters = [NSString stringWithFormat:@"category=%@&",[category stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    }
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:queryParameters url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    //show list of categories
    offeringsViewForItemLists=[[OfferingsListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    offeringsViewForItemLists.delegate=self;
    [offeringsViewForItemLists createViewForList:[json objectForKey:kResponseString] forCategory:@"rewardPointsItems" userAvailablePoints:[[[NSUserDefaults standardUserDefaults]valueForKey:kRewardPoints] intValue]];
    [self.view addSubview:offeringsViewForItemLists];
//    [offeringsView reloadTableForCategory:@"rewardPointsItems" withOfferings:[json objectForKey:kResponseString]];
    [[DataManager shared]removeActivityIndicator];
}

- (void)redeemRewardPointsItem:(NSDictionary *)itemDictionary
{

         [self venueinfo];
    [[DataManager shared]removeActivityIndicator];
        addressView=[[ShippingInformationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        addressView.delegate=self;
        [addressView createViewForItem:itemDictionary forStates:[[countryInfoDict objectAtIndex:2] objectForKey:@"states"]];
        [self.view addSubview:addressView];
}

-(void)venueinfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@venue/locations?apiKey=%@", serverAddress,APIKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:kTimeoutInterval];
    
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        countryInfoDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    
    NSMutableArray *unitedIndex=(NSMutableArray *)countryInfoDict;
    for(int i=0;i<unitedIndex.count;i++)
    {
        if([[[unitedIndex objectAtIndex:i]objectForKey:@"displayName"]isEqualToString:@"United States"])
        {
            countryIndex=i;
        }
    }
    
    NSLog(@"returnDict: %@",countryInfoDict);
}

#pragma mark - Add Center Delegates

- (void)submitSelectedCenter:(NSDictionary *)centerDictionary
{
    NSString *centerName=[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"name"]];
    BOOL centerAlreadyAdded=NO;
    for (int i=0; i<loyaltyCentersArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@",[[loyaltyCentersArray objectAtIndex:i] objectForKey:@"venueId"]] isEqualToString:[NSString stringWithFormat:@"%@", [centerDictionary objectForKey:@"id"]]]) {
            centerAlreadyAdded=YES;
            break;
        }
        else{
            centerAlreadyAdded=NO;
        }
    }
    if (centerAlreadyAdded == YES) {
         [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@ is already added to wallet.",centerName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView5 show];
    }
    else{
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0", @"Points",@"Add Center", @"Notes", @"true", @"IsRedeemable", [NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"id"]], @"VenueId",@"0",@"BusinessBuilderItemID",  nil];
        
        NSDictionary *json=[serverCallInstance serverCallWithPostParameters:postDict andQueryParameters:@"" url:@"venue/userpoint/12345" contentType:@"application/json" httpMethod:@"POST"];
        NSLog(@"json=%@",json);
        [[DataManager shared]removeActivityIndicator];
        if (json!=NULL) {
            if([[json objectForKey:kResponseStatusCode] integerValue] == 200 || [[json objectForKey:kResponseStatusCode] integerValue] == 201)
            {
                [[[UIAlertView alloc]initWithTitle:@"Center Added" message:[NSString stringWithFormat:@"%@ added to list successfully.",centerName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
            }
            else if ([[json objectForKey:kResponseStatusCode] integerValue] == 400)
            {
                UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"" message:@"This center cannot be added to Wallet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView5 show];
            }
            else{
                UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView5 show];
            }
        }
        else{
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
}



- (void)addSelectedCenter
{
    NSString *centerName=@"SCN Strike First";//[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"name"]];
    BOOL centerAlreadyAdded=NO;
    for (int i=0; i<loyaltyCentersArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@",[[loyaltyCentersArray objectAtIndex:i] objectForKey:@"venueId"]] isEqualToString: @"15103"]) {
            centerAlreadyAdded=YES;
            break;
        }
        else{
            centerAlreadyAdded=NO;
        }
    }
    if (centerAlreadyAdded == YES) {
        [[DataManager shared]removeActivityIndicator];
       /* UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@ is already added to wallet.",centerName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView5 show];
        */
    }
    else{
       // NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0", @"Points",@"Add Center", @"Notes", @"true", @"IsRedeemable",@"SCN Strike First", @"VenueId",@"0",@"BusinessBuilderItemID",  nil];
        
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0", @"Points",@"Add Center", @"Notes", @"true", @"IsRedeemable",@"15103", @"VenueId",@"0",@"BusinessBuilderItemID",  nil];
        
        NSDictionary *json=[serverCallInstance serverCallWithPostParameters:postDict andQueryParameters:@"" url:@"venue/userpoint/12345" contentType:@"application/json" httpMethod:@"POST"];
        NSLog(@"json=%@",json);
        [[DataManager shared]removeActivityIndicator];
        if (json!=NULL) {
            if([[json objectForKey:kResponseStatusCode] integerValue] == 200 || [[json objectForKey:kResponseStatusCode] integerValue] == 201)
            {
               /*
             [[[UIAlertView alloc]initWithTitle:@"Center Added" message:[NSString stringWithFormat:@"%@ added to list successfully.",centerName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                */
                
            [self performSelector:@selector(reloadCentersListAfterAddCenter) withObject:nil afterDelay:0.2];
                
            }
            else if ([[json objectForKey:kResponseStatusCode] integerValue] == 400)
            {
               
                /*UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"" message:@"This center cannot be added to Wallet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView5 show];
                 */
            }
            else{
                UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView5 show];
            }
        }
        else{
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if ([alertView.title isEqualToString:@"Points Added"] || [alertView.title isEqualToString:@"Point Added"] || [alertView.title isEqualToString:@"Points Redeemed"] || [alertView.title isEqualToString:@"Point Redeemed"] ) {
        [self performSelector:@selector(returnsToPointsView) withObject:nil afterDelay:0.2];
    }
    else  if ([alertView.title isEqualToString:@"Center Added"]){
        [self performSelector:@selector(reloadCentersListAfterAddCenter) withObject:nil afterDelay:0.2];
    }
    else if ([alertView.title isEqualToString:@"Reward Points Redeemed"])
    {
        [addressView removeFromSuperview];
        [offeringsViewForItemLists removeFromSuperview];
        [offeringsView removeFromSuperview];
        [self performSelector:@selector(reloadCentersListAfterAddCenter) withObject:nil afterDelay:0.2];
    }
}

- (void)returnsToPointsView
{
    [passcodeView removeFromSuperview];
    passcodeView=nil;
    [barcodeImageView removeFromSuperview];
    barcodeImageView=nil;
    [self removeOfferingsViewForCategory:@""];
}

- (void)reloadCentersListAfterAddCenter
{
    [offeringsView removeFromSuperview];
    [centerView removeFromSuperview];
    centerView=nil;
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    //Server call to get updated list of centers
    NSMutableArray *centers=[[NSMutableArray alloc]initWithArray: [self getListOfLoyaltyCentersForUser:[[NSUserDefaults standardUserDefaults]valueForKey:kuserId]]];
    NSDictionary *points=[self userCredits];
    //Refresh main list
    if (centers.count > 0) {
        [mainView reloadListWithCenters:centers andRewardPoints:points];
    }

}
- (void)removeCenterView
{
    [centerView removeFromSuperview];
    centerView=nil;
    
}
#pragma mark - Points Delegates
- (void)redeemOrEarnPointsFunction:(NSString *)status points:(int)points venue:(NSUInteger)venueId
{
    NSDictionary *json=[self getListOfOfferings:venueId status:status];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"]) {
        NSArray *responseArray;
        if ( [[json objectForKey:kResponseString] count]>0) {
            responseArray=[[NSArray alloc]initWithArray:[json objectForKey:kResponseString]];
        }
        else{
            responseArray=[[NSArray alloc]init];
        }
        offeringsView=[[OfferingsListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        offeringsView.delegate=self;
        [offeringsView createViewForList:responseArray forCategory:status userAvailablePoints:points];
        [self.view addSubview:offeringsView];
       
    }
}

- (void)removePointsView
{
    [pointsView removeFromSuperview];
    pointsView=nil;
//    [mainView reloadList];
    
    ///modi add
    
    [mainView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    /*
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    //Server call to get updated list of centers
    NSMutableArray *centers=[[NSMutableArray alloc]initWithArray: [self getListOfLoyaltyCentersForUser:[[NSUserDefaults standardUserDefaults]valueForKey:kuserId]]];
    NSDictionary *points=[self userCredits];
    //Refresh main list
    if (centers.count > 0) {
          [mainView reloadListWithCenters:centers andRewardPoints:points];
    }
    [[DataManager shared]removeActivityIndicator];
     */
    
}

#pragma mark - Passcode Delegates
- (void)removePasscodeView
{
    [passcodeView removeFromSuperview];
    passcodeView=nil;
}

- (void)submitPasscode:(NSDictionary *)itemDictionary userEnteredPasscode:(NSString *)passcode forCategory:(NSString *)category
{
//    if ([passcode isEqualToString:[NSString stringWithFormat:@"%@",[itemDictionary objectForKey:@"itemPasscode"]]]) {
        if ([category isEqualToString:@"showImageVerification"]) {
            //show image view
            NSDictionary *json=[serverCallInstance serverCallWithQueryParameters:@"" url:[NSString stringWithFormat:@"bizvltimg/%@/%@",[itemDictionary objectForKey:@"venueId"],[itemDictionary objectForKey:@"itemId"]] contentType:@"application/json" httpMethod:@"GET"];
            NSLog(@"json=%@",json);
            if (json!=NULL) {
                if(([[json objectForKey:kResponseStatusCode] integerValue] == 200 || [[json objectForKey:kResponseStatusCode] integerValue] == 201) && [[json objectForKey:kResponseString] isKindOfClass:[NSDictionary class]])
                {
                    barcodeImageView=[[ImageVerificationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    [barcodeImageView createViewWithBarcodeImageURL:[[json objectForKey:kResponseString] objectForKey:@"itemImage"] ];
                    [barcodeImageView passscodeData:itemDictionary userEnteredPasscode:passcode];
                    barcodeImageView.delegate=self;
                    [self.view addSubview:barcodeImageView];
                     [[DataManager shared]removeActivityIndicator];
                }
                else{
                    [[DataManager shared]removeActivityIndicator];
                    UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Unable to load the barcode image. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView5 show];
                }
            }
            else{
                [[DataManager shared]removeActivityIndicator];
//                UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Unable to load the barcode image. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alertView5 show];
            }
        }
        else{
            NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[itemDictionary objectForKey:@"itemPoint"], @"Points",@"Add Points", @"Notes", @"true", @"IsRedeemable", [NSString stringWithFormat:@"%@",[itemDictionary objectForKey:@"venueId"]], @"VenueId",[NSString stringWithFormat:@"%@",[itemDictionary objectForKey:@"itemId"]],@"BusinessBuilderItemID",  nil];
            if ([category isEqualToString:@"Redeem"]) {
                postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"-%@",[itemDictionary objectForKey:@"itemPoint"]], @"Points",@"Redeem Points", @"Notes", @"true", @"IsRedeemable", [NSString stringWithFormat:@"%@",[itemDictionary objectForKey:@"venueId"]], @"VenueId",[NSString stringWithFormat:@"%@",[itemDictionary objectForKey:@"itemId"]],@"BusinessBuilderItemID",  nil];
            }
            
            NSDictionary *json=[serverCallInstance serverCallWithPostParameters:postDict url:[NSString stringWithFormat:@"venue/userpoint/%@",passcode] contentType:@"application/json" httpMethod:@"POST"];
            NSLog(@"json=%@",json);
            [[DataManager shared]removeActivityIndicator];
            if (json!=NULL) {
                if([[json objectForKey:kResponseStatusCode] integerValue] == 200 || [[json objectForKey:kResponseStatusCode] integerValue] == 201)
                {
                    if ([category isEqualToString:@"Redeem"]) {
                        [self submitPasscode:itemDictionary userEnteredPasscode:passcode forCategory:@"showImageVerification"];
                    }
                    else{
                        if ([[itemDictionary objectForKey:@"itemPoint"] integerValue] > 1) {
                              [[[UIAlertView alloc]initWithTitle:@"Points Added" message:[NSString stringWithFormat:@"%@ points are added successfully.",[itemDictionary objectForKey:@"itemPoint"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        }
                        else{
                              [[[UIAlertView alloc]initWithTitle:@"Point Added" message:[NSString stringWithFormat:@"%@ point is added successfully.",[itemDictionary objectForKey:@"itemPoint"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        }
                      
                    }
                    
                }
                else{
                    UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView5 show];
                }
            }
        }

//    }
//    else{
//        [[DataManager shared]removeActivityIndicator];
//         [[[UIAlertView alloc]initWithTitle:@"Passcode Mismatch" message:@"Please enter the correct passcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//    }
    
}

#pragma mark - Barcode Image Verification Delegates
- (void)removeImageVerificationView
{
    [barcodeImageView removeFromSuperview];
    barcodeImageView=nil;
}

- (void)submitPasscodeAfterImageScan:(NSDictionary *)itemDictionary enteredPasscode:(NSString *)passcode
{
      if ([[itemDictionary objectForKey:@"itemPoint"] integerValue] > 1) {
          [[[UIAlertView alloc]initWithTitle:@"Points Redeemed" message:[NSString stringWithFormat:@"%@ points are redeemed successfully.",[itemDictionary objectForKey:@"itemPoint"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
      }
      else{
            [[[UIAlertView alloc]initWithTitle:@"Point Redeemed" message:[NSString stringWithFormat:@"%@ point is redeemed successfully.",[itemDictionary objectForKey:@"itemPoint"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
      }
}

#pragma  mark - Venue Information
- (void)venueInfo
{
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@"Wallet"];
    centerView.countryInfoDict=[[NSMutableArray alloc]initWithArray:responseArray];
    NSLog(@"");
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@"Wallet"];
    centerView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
    
}

- (void)getNearbyCenter
{
    NSMutableArray *indexArray=[selectCenterModelInstance getNearbyCenterIndex:@"Wallet"];
    [centerView nearbyCenter:indexArray];
}

-(void)updateCenterInfo
{
    NSArray *responseArray=[selectCenterModelInstance updatedCenterArray];
    centerView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
}

- (void)selectedCenterDictionary:(NSDictionary *)dictionary
{
    if(dictionary)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[dictionary objectForKey:@"scoringType"] forKey:kscoringType];
        [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"id"] forKey:kvenueId];
        NSLog(@"center name=%@",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]);
        [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"name"] forKey:kcenterName];
        [[NSUserDefaults standardUserDefaults] setInteger:[[[[dictionary objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"id"] intValue] forKey:kadministrativeAreaId];
        [[NSUserDefaults standardUserDefaults] setInteger:[[[[dictionary objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"id"] intValue] forKey:kcountryId];
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
            mainView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, mainView.frame.size.width, mainView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], mainView.frame.size.width, mainView.frame.size.height)];
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
            mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
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

@end
