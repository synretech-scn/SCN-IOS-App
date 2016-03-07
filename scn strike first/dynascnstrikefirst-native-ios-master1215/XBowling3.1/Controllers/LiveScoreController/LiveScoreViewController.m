//
//  LiveScoreViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LiveScoreViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface LiveScoreViewController ()

@end

@implementation LiveScoreViewController
{
    LiveScoreVenueModel *mainViewModelInstance;
    LiveScoreVenueSelection *mainView;
    SelectCenterView *selectCenterView;
    SelectCenterModel *selectCenterModelInstance;
    LeftSlideMenu *leftMenu;
    LiveScoreLanesView *lanesView;
    NSDictionary *centerInfoDictionary;
    NSTimer *laneSummaryTimer;
    id<GAITracker> tracker;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterInfo) name:@"UpdateCenterInformation" object:nil];
    if ([[self.view subviews] lastObject] == lanesView) {
        //start Live Score timer
        laneSummaryTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateLanesView) userInfo:nil repeats:YES];
        [self updateLanesView];
    }
    [self supportedInterfaceOrientations:NO];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Live Score Section"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInChallengeView];
    tracker = [[GAI sharedInstance] defaultTracker];
    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    leftMenu.hidden=YES;
    
    
    if(![mainView isDescendantOfView:self.view])
    {
        mainView=[[LiveScoreVenueSelection alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        mainView.delegate=self;
        [self.view addSubview:mainView];
        selectCenterView=[[SelectCenterView alloc]init];
        selectCenterView.centerSelectionDelegate=self;
        [mainView createViewWithCenterView:selectCenterView];
    }
    mainViewModelInstance=[LiveScoreVenueModel shared];
    selectCenterModelInstance=[SelectCenterModel shared];

}
#pragma  mark - Venue Information
- (void)venueInfo
{
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@"Machine"];
    selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:responseArray];
    NSLog(@"");
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@"Machine"];
    selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:responseArray];
    
}

- (void)getNearbyCenter
{
    NSMutableArray *indexArray=[selectCenterModelInstance getNearbyCenterIndex:@"Machine"];
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
    if(dictionary)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"id"] forKey:kliveGameCenterId];
        NSLog(@"id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:kliveGameCenterId]);
        [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"name"] forKey:kliveGameCenterName];
    }

    NSString *venue;
    if(dictionary.count > 0)
        venue=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
    else
        venue=@"0";
    [mainView updateVenueforLiveCenter:venue country:@"" state:@"" center:@""];
    centerInfoDictionary=[[NSDictionary alloc]initWithDictionary:dictionary];
}

#pragma mark - Player Gameplay

- (void)showGameplayForPlayer:(NSString *)rowkey laneID:(NSString *)laneID venueID:(NSString *)venueID
{
    [laneSummaryTimer invalidate];
    laneSummaryTimer=nil;
    NSDictionary *playerDetails=[[NSDictionary alloc]initWithObjectsAndKeys:rowkey,@"rowKey",laneID,@"laneID",venueID,@"venueID", nil];
    //    NSDictionary *responseDictionary=[mainViewModelInstance getGameplayForPlayer:rowkey LaneID:laneID VenueID:venueID];
    //    if([[responseDictionary objectForKey:kResponseStatusCode] intValue] == 200 && [responseDictionary objectForKey:kResponseString])
    //    {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
//    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
    [bowlingVC createGameViewforCategory:@"MyGame"];
    [self.navigationController pushViewController:bowlingVC animated:YES];
    [bowlingVC liveScoreData:playerDetails];
    //    }
    
}

#pragma mark - Leaderboard Function
- (void)showLeaderboard:(int)leaderboardType
{
    leaderboardType++;
    LeaderboardViewController *leaderboardVC=[[LeaderboardViewController alloc]initWithLeaderboardType:leaderboardType viaSection:@""];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}


#pragma mark - Get Live Score for Selected Center
- (void)getLiveScoreforSelectedCenter:(NSString *)venueId
{
    NSLog(@"get live score");
     if (![laneSummaryTimer isValid])
     {
         Reachability *reach = [Reachability reachabilityForInternetConnection];
         NetworkStatus netStatus = [reach currentReachabilityStatus];
         if (netStatus != NotReachable) {
             dispatch_async( dispatch_get_main_queue(), ^{
                 [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
             });

         }
         else{
             return;
         }
     }
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *responseDictionary = [mainViewModelInstance getLiveScore:venueId];
    NSLog(@"live score response");
    if ([responseDictionary objectForKey:kResponseString]) {
        dispatch_async( dispatch_get_main_queue(), ^{
            [[DataManager shared]removeActivityIndicator];
            if(([[responseDictionary objectForKey:kResponseStatusCode] intValue] == 200 || [[responseDictionary objectForKey:kResponseStatusCode] intValue] == 201))
            {
                if ([laneSummaryTimer isValid]) {
                    if ([[responseDictionary objectForKey:kResponseString] isKindOfClass:[NSArray class]]) {
                         [lanesView updateViewWithLanesInformation:[responseDictionary objectForKey:kResponseString]];
                    }
                   
                }
                else
                {
                     if ([[responseDictionary objectForKey:kResponseString] isKindOfClass:[NSArray class]]) {
                         [self showLanesView:[responseDictionary objectForKey:kResponseString]];
                     }
                }
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        });
       
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
             [[DataManager shared]removeActivityIndicator];
        });
       
    }
}

- (void)showLanesView:(NSArray *)lanesArray
{
    lanesView=[[LiveScoreLanesView alloc]init];
    lanesView.frame=CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:lanesView];
    lanesView.liveScoreGameplayDelegate=self;
    [lanesView createViewwithLanesInformation:lanesArray centerInformation:centerInfoDictionary];
    [self.view bringSubviewToFront:lanesView];
    //start Live Score timer
    laneSummaryTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateLanesView) userInfo:nil repeats:YES];
    
}
- (void)liveScoreBackButtonFunction
{
    [laneSummaryTimer invalidate];
    laneSummaryTimer=nil;
    [lanesView removeFromSuperview];
    lanesView=nil;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kliveScoreUpdate];
}

- (void)updateLanesView
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLiveScoreforSelectedCenter:[NSString stringWithFormat:@"%@",[centerInfoDictionary objectForKey:@"id"]]];
    });
}

- (void)removeCenterSelectionView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
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
            mainScreenCoverView.backgroundColor=[UIColor clearColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [mainView removeFromSuperview];
    mainView.delegate=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
    [leftMenu removeFromSuperview];
    leftMenu=nil;
}
@end
