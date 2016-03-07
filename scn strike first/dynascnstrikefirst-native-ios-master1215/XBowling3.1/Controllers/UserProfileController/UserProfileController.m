//
//  UserProfileController.m
//  XBowling3.1
//
//  Created by clicklabs on 1/7/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "UserProfileController.h"
#import "DataManager.h"
#import "Keys.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface UserProfileController ()

@end

@implementation UserProfileController
{
    UserProfileView *userView;
    int currentApiNumber;
    ServerCalls *callInstance;
    SelectCenterView *selectCenterView;
    SelectCenterModel *selectCenterModelInstance;
    LeftSlideMenu *leftMenu;
    NSDictionary *homeCenterDictionary;
    id<GAITracker> tracker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tracker = [[GAI sharedInstance] defaultTracker];
    self.view.backgroundColor=[UIColor blackColor];
    currentApiNumber=5;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"inUserProfileSection"];
//    UIImageView * profileMainbackgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [profileMainbackgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
//    [self.view addSubview:profileMainbackgroundImage];
    [self supportedInterfaceOrientations:NO];
    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    leftMenu.hidden=YES;

    //Profile View
    userView=[[UserProfileView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    userView.profileDelegate=self;
    userView.profileViewController=self;
    [self.view addSubview: userView];
    
    callInstance=[ServerCalls instance];
    callInstance.serverCallDelegate=self;
    
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSDictionary *profileInfo =[callInstance afnetWorkingGetServerCall:@"userprofile" isAPIkeyToken:YES];
    NSLog(@"profileInfo :%@",profileInfo);
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterInfo) name:@"UpdateCenterInformation" object:nil];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User Profile"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    for(UIView *aView1 in self.view.subviews)
    {
        UIView *remove_object=(UIView*)aView1;
        for(UIView *aView2 in aView1.subviews)
        {
            UIView *remove_object=(UIView*)aView2;
            for(UIView *aView3 in aView2.subviews)
            {
                UIView *remove_object=(UIView*)aView3;
                for(UIView *aView4 in aView3.subviews)
                {
                    UIView *remove_object=(UIView*)aView4;
                    [remove_object removeFromSuperview];
                    remove_object=nil;
                }
                [remove_object removeFromSuperview];
                remove_object=nil;
            }
            [remove_object removeFromSuperview]; remove_object=nil;
        }
        [remove_object removeFromSuperview];
        remove_object=nil;
    }
}

#pragma mark - Common method For All Server Call

-(void)serverCallMethodurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber
{
    currentApiNumber=apiNumber;
    NSDictionary *apiResponse;
    if(currentApiNumber==0)
    {
        apiResponse=[callInstance afnetworkingPostServerCall:urlAppend postdictionary:postDict isAPIkeyToken:isTokenAppend];
    }
    else if (currentApiNumber==1)
    {
        apiResponse=[callInstance afnetworkingPostServerCall:urlAppend postdictionary:postDict isAPIkeyToken:isTokenAppend];
    }
    
    NSLog(@"apiResponse :%@",apiResponse);
}

#pragma mark - API response Delegate

- (void)responseAction:(NSDictionary *)profileResponse {
    
    if(currentApiNumber==0)
    {
        NSLog(@"profileResponse :%@",profileResponse);
        [[DataManager shared]removeActivityIndicator];
        
        if([[profileResponse objectForKey:responseCode] integerValue]==200)
        {
            UIAlertView *alertView4=[[UIAlertView alloc]initWithTitle:@"" message:@"Profile updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView4 show];
            
            [userView updateProfileParameters];
            [userView cancelEditButtonAction];
        }
        else if ([[profileResponse objectForKey:responseCode] integerValue] == 401)
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"Authentication failure" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
        else if ([[profileResponse objectForKey:responseCode] integerValue] == 409)
        {
            [[DataManager shared]removeActivityIndicator];
            
            NSDictionary *json =[profileResponse objectForKey:responseDataDic];
            NSString *message;
            if([[json objectForKey:@"message"] isEqualToString:@"ScreenName"])
            {
                message=@"Screen name is invalid.";
            }
            else if ([[json objectForKey:@"message"] isEqualToString:@"Email"])
            {
                message=@"Email id is invalid.";
            }
            else
                message=@"An error occurred.";
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"An error occurred." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
    else if(currentApiNumber==1)
    {
        [[DataManager shared]removeActivityIndicator];
        if([[profileResponse objectForKey:responseCode] integerValue]==200)
        {
            [userView cancelChangePasswordButtonAction];
            UIAlertView *alertView4=[[UIAlertView alloc]initWithTitle:@"" message:@"Password changed successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView4 show];
        }
        else{
            
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
    else if(currentApiNumber==5)
    {
        if([[profileResponse objectForKey:responseCode]integerValue]==200)
        {
            userView.profileInfo=[profileResponse objectForKey:responseDataDic];
            [self getHomeCenter];
            selectCenterView=[[SelectCenterView alloc]init];
            selectCenterView.CenterSelectionDelegate=self;
            selectCenterModelInstance=[SelectCenterModel shared];
            [selectCenterView createView];
            [userView loadViewWithCenterSelectionView:selectCenterView];
        }
        else{
            if([profileResponse objectForKey:responseStringAF]!=nil&&[profileResponse objectForKey:responseStringAF]!=[NSNull null]&&![[profileResponse objectForKey:responseStringAF] isEqualToString:@""])
            {
                [[DataManager shared]removeActivityIndicator];
                
                UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:[profileResponse objectForKey:responseStringAF] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertview2 show];
            }
            else
            {
                [[DataManager shared]removeActivityIndicator];
//                UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alertview2 show];
            }
        }
    }
}

#pragma mark - Menu Button Action

- (void)backButtonAction
{
    [self showMainMenu:nil];
}

#pragma mark - Get Home Center
- (void)getHomeCenter
{
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"MyCenter" contentType:@"" httpMethod:@"GET"];
    NSDictionary *response=[json objectForKey:kResponseString];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:kResponseStatusCode] intValue] == 200)
    {
        if ([[json objectForKey:kResponseString] isKindOfClass:[NSDictionary class]]) {
            if ([[[json objectForKey:kResponseString] objectForKey:@"table"] count] > 0)
            {
                homeCenterDictionary=[[NSDictionary alloc]initWithDictionary:[[[json objectForKey:kResponseString] objectForKey:@"table"] objectAtIndex:0]];
                [userView selectedHomeCenter:homeCenterDictionary updated:NO];
            }
        }
    }
}

#pragma  mark - Venue Information
- (void)venueInfo
{
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@""];
    NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:responseArray];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"countryId",@"All Countries",@"displayName", nil];
    [temp insertObject:dict atIndex:0];
    for (int i=1; i<=responseArray.count; i++) {
        NSDictionary *stateDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"All States",@"displayName",@"0",@"administrativeAreaId", nil];
        NSMutableArray *statesArray=[[NSMutableArray alloc]initWithArray:[[temp objectAtIndex:i]objectForKey:@"states"]];
        [statesArray insertObject:stateDict atIndex:0];
        NSMutableDictionary *countryDict=[[NSMutableDictionary alloc]initWithDictionary:[temp objectAtIndex:i]];
        [countryDict removeObjectForKey:@"states"];
        [countryDict setValue:statesArray forKey:@"states"];
        [temp replaceObjectAtIndex:i withObject:countryDict];
        NSLog(@"temp=%@",temp);
    }
    selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:temp];
    NSLog(@"");
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@""];
    NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:responseArray];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"All Centers",@"name", nil];
    [temp insertObject:dict atIndex:0];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:temp];
    
}

- (void)getNearbyCenter
{
    NSMutableArray *indexArray=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0", nil];
    if (homeCenterDictionary.count > 0) {
        indexArray=[selectCenterModelInstance setInitialVenue:[homeCenterDictionary objectForKey:@"countryDisplayName"] state:[homeCenterDictionary objectForKey:@"longName"] center:[homeCenterDictionary objectForKey:@"name"]];
    }
    else
    {
        indexArray=[selectCenterModelInstance getNearbyCenterIndex:@""];
    }
    [selectCenterView nearbyCenter:indexArray];
}

-(void)updateCenterInfo
{
    NSArray *responseArray=[selectCenterModelInstance updatedCenterArray];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
}

- (void)updateCenterInformation:(int)totalLanes selectedCountry:(NSString *)country selectedState:(NSString *)state selectedCenter:(NSString *)center
{
}

- (void)selectedCenterDictionary:(NSDictionary *)dictionary
{
    [userView selectedHomeCenter:dictionary updated:YES];
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            userView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, userView.frame.size.width, userView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], userView.frame.size.width, userView.frame.size.height)];
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
            userView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
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

#pragma mark - View Did Disappear Removing Views

-(void)viewDidDisappear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"inUserProfileSection"];
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
