//
//  SelectCenterViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "SelectCenterViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface SelectCenterViewController ()

@end

@implementation SelectCenterViewController
{
    LeftSlideMenu *leftMenu;
    VenueSelectionModel *modelInstance;
    VenueSelectionView *mainView;
    SelectCenterModel *selectCenterModelInstance;
    SelectCenterView *selectCenterView;
    SelectUserStatsPropertiesView *propertiesView;
    id<GAITracker> tracker;
    BOOL checkForWelcomePopup;
    ServerCalls *serverCall;
    int apiNumber;
    BOOL showWelcomePopup;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self supportedInterfaceOrientations:NO];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Select Center for Bowling"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     tracker = [[GAI sharedInstance] defaultTracker];
    NSLog(@"mainframe=%f %f",self.view.frame.origin.x,self.view.frame.origin.y);
    serverCall=[ServerCalls instance];
    serverCall.serverCallDelegate=self;
    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    leftMenu.hidden=YES;
    showWelcomePopup=YES;

    
    if(![mainView isDescendantOfView:self.view])
    {
        mainView=[[VenueSelectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        mainView.venueDelegate=self;
        [self.view addSubview:mainView];
        selectCenterView=[[SelectCenterView alloc]init];
        selectCenterView.centerSelectionDelegate=self;
        [mainView createMainViewWithCenterView:selectCenterView];
    }
    modelInstance=[VenueSelectionModel shared];
    selectCenterModelInstance=[SelectCenterModel shared];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterInfo) name:@"UpdateCenterInformation" object:nil];
}

#pragma  mark - Venue Information
- (void)venueInfo
{    
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@""];
    selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:responseArray];
    NSLog(@"");
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@""];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
  
}

- (void)getNearbyCenter
{
    NSMutableArray *indexArray=[selectCenterModelInstance getNearbyCenterIndex:@""];
    [selectCenterView nearbyCenter:indexArray];
}

-(void)updateCenterInfo
{
    NSArray *responseArray=[selectCenterModelInstance updatedCenterArray];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
}

- (void)updateCenterInformation:(int)totalLanes selectedCountry:(NSString *)country selectedState:(NSString *)state selectedCenter:(NSString *)center
{
    [mainView updateVenue:totalLanes country:country state:state center:center];
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
#pragma mark - Bowl Now
- (void)bowlNowServerCall
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *responseDictionary = [modelInstance laneCheckout];
    if(([[responseDictionary objectForKey:kResponseStatusCode] intValue] == 200 || [[responseDictionary objectForKey:kResponseStatusCode] intValue] == 201) && [responseDictionary objectForKey:kResponseString])
    {
        //                    complete=0;
        // [userDefaults setBool:NO forKey:kgameCompletionBool];
        [userDefaults removeObjectForKey:kliveCompetitionId];
//        [userDefaults setBool:NO forKey:kInChallengeView];
        [userDefaults setObject:[[[responseDictionary objectForKey:kResponseString] objectForKey:@"bowlingGame"] objectForKey:@"id" ] forKey:kbowlingGameId];
        //                    [userDefaults setObject:[[json objectForKey:@"bowlingGame"] objectForKey:@"createdDateTime"] forKey:kcheckoutTimestamp];
        [userDefaults setObject:[[responseDictionary objectForKey:kResponseString] objectForKey:@"id"] forKey:klaneCheckOutId];
        [userDefaults setObject:[[[responseDictionary objectForKey:kResponseString] objectForKey:@"user"] objectForKey:@"id"] forKey:kuserId];
        [userDefaults setObject:[[[responseDictionary objectForKey:kResponseString] objectForKey:@"bowlingGame"] objectForKey:@"scoringType"] forKey:kscoringType];
        NSLog(@"LaneCheckoutId=%@",[userDefaults objectForKey:kscoringType]);
        [self welcomeNoteGetServerCall];
        
        
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

}

- (void)bowlNow
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kaddLoyaltyPoints];
    [self performSelector:@selector(bowlNowIntermediate) withObject:nil afterDelay:0.2];

}

- (void)bowlNowIntermediate
{
    [[DataManager shared]showActivityIndicator:@"Loading..."];
    [self performSelector:@selector(bowlNowServerCall) withObject:nil afterDelay:0.2];
}
- (void)showBowlingView
{
    [[DataManager shared]removeActivityIndicator];
    BowlingViewController *bowlingView=[[BowlingViewController alloc]init];
    [bowlingView createGameViewforCategory:@"MyGame"];
    [self.navigationController pushViewController:bowlingView animated:YES];
    if ( !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) && showWelcomePopup) {

        NSString *message=[NSString stringWithFormat:@"Welcome to XBowling at %@! As you bowl, just swipe the pins you knock down each time, then press the 'Next Throw' or 'Next Frame' button.",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType] isEqualToString:@"Machine"]) {
            message=[NSString stringWithFormat:@"Welcome to XBowling at %@! As you bowl, your scores will automatically be recorded in XBowling.",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
        }
        checkForWelcomePopup=NO;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Getting Started" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        av.tag = 100;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        [av setValue:v forKey:@"accessoryView"];
        //    v.backgroundColor = [UIColor greenColor];
        UIButton *checkboxButton=[[UIButton alloc]init];
        //    checkboxButton.backgroundColor=[UIColor redColor];
        checkboxButton.frame=CGRectMake(10,5, 30, 30);
        [checkboxButton setImage:[UIImage imageNamed:@"black_uncheck_box.png"] forState:UIControlStateNormal];
        [checkboxButton setImage:[UIImage imageNamed:@"balck_checkbox.png"] forState:UIControlStateSelected];
        [checkboxButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [checkboxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:checkboxButton];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        NSMutableAttributedString *noteString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Do not show this message again at %@",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH3size]}];
        [noteString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteString length])];
        
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(checkboxButton.frame.size.width+checkboxButton.frame.origin.x+2, 0, 200, 40);
        label.attributedText=noteString;
        label.textColor=[UIColor blackColor];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=3;
        [v addSubview:label];
        [av show];
        
    }
    [propertiesView removeFromSuperview];
    propertiesView=nil;
}

-(void)checkboxSelected:(UIButton *)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        checkForWelcomePopup=NO;
    }
    else{
        sender.selected=YES;
        checkForWelcomePopup=YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if(alertView.tag==100)
        {
            [self welcomeNotePostServerCall];
        }
    }
}

#pragma mark - Welcome note Server Calls

- (void)welcomeNotePostServerCall
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
       NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:kvenueId],@"VenueId",[NSNumber numberWithBool:checkForWelcomePopup],@"IsVenueChecked", nil];
        NSString *urlAppend=[NSString stringWithFormat:@"venue/uservenuecomp"];
        apiNumber=0;
        NSDictionary *apiResponse=[serverCall afnetworkingPostServerCall:urlAppend postdictionary:postDict isAPIkeyToken:YES];
        NSLog(@"response=%@",apiResponse);
    }
}

- (void)welcomeNoteGetServerCall
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSString *enquiryUrl=[NSString stringWithFormat:@"venue/%@/uservenuecomp",[[NSUserDefaults standardUserDefaults]valueForKey:kvenueId]];
        apiNumber=1;
        NSDictionary *apiResponse =[serverCall afnetWorkingGetServerCall:enquiryUrl isAPIkeyToken:YES];
        NSLog(@"response=%@",apiResponse);
        
    }
   
}

#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)notificationInfo
{
    if(apiNumber==1)
    {
        
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            @try {
                NSDictionary *responseDictionary=[notificationInfo objectForKey:responseDataDic];
                showWelcomePopup=![responseDictionary objectForKey:@"isVenueChecked"];
                [self performSelector:@selector(showBowlingView) withObject:nil afterDelay:0.2];
            }
            @catch (NSException *exception) {
                
            }
        }
        
    }
}
#pragma  mark - User Stats Equipment Details

- (void)showUserStatsView:(NSDictionary *)contentDictionary
{
    propertiesView=[[SelectUserStatsPropertiesView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    propertiesView.delegate=self;
    [self.view addSubview:propertiesView];
    [propertiesView createMainView];
    [propertiesView equipmentDropdownInfo:contentDictionary];
    
}

- (void)removeEquipmentDetails
{
    [propertiesView removeFromSuperview];
    propertiesView=nil;
}

- (void)skipEquipmentDetails
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kBowlingBallName];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kCompetitionTypeId];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternLengthId];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternNameId];
//    [propertiesView removeFromSuperview];
//    propertiesView=nil;
    [self bowlNow];
}

- (void)setEquipmentDetails
{
    [self bowlNow];
}

- (void)removeCenterSelectionView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [mainView removeFromSuperview];
    mainView.venueDelegate=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            mainView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, mainView.frame.size.width, mainView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], mainView.frame.size.width, mainView.frame.size.height)];
            mainScreenCoverView.tag=20011;
            mainScreenCoverView.userInteractionEnabled=YES;
            [self.view addSubview:mainScreenCoverView];
        }];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            NSLog(@"mainframe2=%f %f",self.view.frame.origin.x,self.view.frame.origin.y);
             leftMenu.frame = CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:self.view.frame.size.width], self.view.frame.size.height);
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

- (void)viewWillDisappear:(BOOL)animated
{
    [leftMenu removeFromSuperview];
    leftMenu=nil;
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
