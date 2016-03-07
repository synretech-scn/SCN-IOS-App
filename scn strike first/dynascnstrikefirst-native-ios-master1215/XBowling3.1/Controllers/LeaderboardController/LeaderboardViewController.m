//
//  LeaderboardViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 1/21/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"


@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController
{
    GlobalLeaderboardView *globalLeaderboard;
    CentralLeaderboardView *centralLeaderboard;
    SelectCenterView *selectCenterView;
    SelectCenterModel *selectCenterModelInstance;
    FilterView *filterView;
    PlayerProfileView *playerProfile;
    NSMutableDictionary *selectedCenterDetails;
    NSMutableDictionary *selectedCountryDetails;
    NSMutableDictionary *selectedStateDetails;
    NSMutableDictionary *filterCenterDetails;
    NSString *leaderboardViaSection;
    int leaderboardtype;
    NSString *defaultLeaderboard;
    NSString *leaderboardCenterName;
    id<GAITracker> tracker;
}

- (id)initWithLeaderboardType:(int)type viaSection:(NSString *)section
{
    self = [super init];
    if (self) {
        defaultLeaderboard=@"";
        leaderboardtype=type;
        if (type == 1) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Global Leaderboard"
                                                                  action:@"Action"
                                                                   label:nil
                                                                   value:nil] build]];
                [self displayDefaultGlobalLeaderboardForSection:section];
            leaderboardViaSection=section;
        }
        else{
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Center Leaderboard"
                                                                  action:@"Action"
                                                                   label:nil
                                                                   value:nil] build]];
            //Central Leaderboard
            centralLeaderboard=[[CentralLeaderboardView alloc]init];
            centralLeaderboard.delegate=self;
            centralLeaderboard.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
            [self.view addSubview:centralLeaderboard];
            selectCenterView=[[SelectCenterView alloc]init];
            selectCenterView.centerSelectionDelegate=self;
            [centralLeaderboard createLeaderboardViewWithCenterView:selectCenterView];
            selectCenterModelInstance=[SelectCenterModel shared];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supportedInterfaceOrientations:NO];
    tracker = [[GAI sharedInstance] defaultTracker];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterInfo) name:@"UpdateCenterInformation" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCenterInformation" object:nil];
}

#pragma mark - Filter
- (void)showFilterView
{
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
        NSArray *filtersArray=[[NSArray alloc]initWithObjects:@"Sort By",@"Country",@"Bowlers", nil];
        NSArray *valuesArray=[[NSArray alloc]initWithObjects:@"All Time Score",@"All Countries",@"All XBowlers", nil];
        NSMutableArray *dropdownInfoArray=[NSMutableArray new];
        NSArray *sortCategoriesArray=[[NSArray alloc]initWithObjects:@"All Time Score",@"Strike King",@"Spare King",@"Points Won",@"Challenges Played",@"Challenges Won",@"XB 300 Club", nil];
        [dropdownInfoArray addObject:sortCategoriesArray];
        NSArray *bowlersArray=[[NSArray alloc]initWithObjects:@"All XBowlers",@"My Friends", nil];
        [dropdownInfoArray addObject:bowlersArray];
       
        if ([self.view.subviews containsObject:centralLeaderboard]) {
            [filterView createView:filtersArray filterInitialValues:valuesArray centerView:nil forSuperView:@"Leaderboard"];
        }
        else
        {
            if (selectCenterView) {
                [selectCenterView removeFromSuperview];
                selectCenterView=nil;
                selectCenterView.centerSelectionDelegate=nil;
            }
            if ([leaderboardViaSection isEqualToString:@"bowling"]) {
                 [filterView createView:filtersArray filterInitialValues:valuesArray centerView:selectCenterView forSuperView:@"Leaderboard"];
            }
            else
            {
                selectCenterView=[[SelectCenterView alloc]init];
                selectCenterView.centerSelectionDelegate=self;
                selectCenterModelInstance=[SelectCenterModel shared];
                [filterView createView:filtersArray filterInitialValues:valuesArray centerView:selectCenterView forSuperView:@"Leaderboard"];
            }
        }
        [filterView filterDropdownInfo:dropdownInfoArray];
        [self.view addSubview:filterView];
    }
    
}

- (void)removeFilterView
{
    filterView.hidden=YES;
}

- (void)filterDoneFunction:(NSMutableArray *)filterValuesDict
{
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
    BOOL friends=false;
    if ([[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:1]] isEqualToString:@"My Friends"]) {
        friends=true;
    }
    NSString *category=[[[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:0]] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (category.length == 0) {
        category=@"alltimescore";
        [filterValuesDict replaceObjectAtIndex:0 withObject:@"All Time Score"];
    }
   
    if ([[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:0]] isEqualToString:@"Points Won"]) {
        category=@"points";
        [self getLeaderboardForCenter:category friends:friends countryId:countryId administrativeAreaId:administrativeId venueId:venueId isVenueLeaderboard:false displayName:[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:0]]];
    }
    else
    {
        [self getLeaderboardForCenter:category friends:friends countryId:countryId administrativeAreaId:administrativeId venueId:venueId isVenueLeaderboard:true displayName:[NSString stringWithFormat:@"%@",[filterValuesDict objectAtIndex:0]]];
    }
}

#pragma  mark - Venue Information
- (void)venueInfo
{
    NSArray *responseArray=[selectCenterModelInstance getAllVenues:@""];
    if ([self.view.subviews lastObject]== filterView) {
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
    }
    else
        selectCenterView.countryInfoDict=[[NSMutableArray alloc]initWithArray:responseArray];
    NSLog(@"countries=%@",selectCenterView.countryInfoDict);
}

- (void)centerInfoForCountry:(NSString *)country State:(NSString *)state
{
    NSArray *responseArray=[selectCenterModelInstance getAllCentersForCountry:country State:state ScoringType:@""];
    if ([self.view.subviews lastObject]== filterView) {
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:responseArray];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"All Centers",@"name", nil];
        [temp insertObject:dict atIndex:0];
        selectCenterView.centerDetails=[[NSMutableArray alloc]initWithArray:temp];
    }
    else
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

#pragma mark - Get Leaderboard with filters
- (void)getLeaderboardForCenter:(NSString *)leaderboardName friends:(BOOL)friendsBOOL countryId:(int)countryId administrativeAreaId:(int)admId venueId:(int)venueId isVenueLeaderboard:(BOOL)isVenueLeaderboard displayName:(NSString *)name
{
    NSString *friends=@"false";
    if (friendsBOOL == YES) {
        friends=@"true";
    }
    NSString *siteurl = [NSString stringWithFormat:@"leaderboard/%@",leaderboardName];
   
    NSString *queryString =[NSString stringWithFormat:@"countryId=%d&administrativeAreaId=%d&venueId=%d&isVenueLeaderboard=%hhd&friends=%@&",countryId,admId,venueId,isVenueLeaderboard,friends];
    if ([defaultLeaderboard isEqualToString:@"bowling"]) {
          queryString =[NSString stringWithFormat:@"countryId=%ld&administrativeAreaId=%ld&venueId=%ld&isVenueLeaderboard=%hhd&friends=%@&",(long)[[NSUserDefaults standardUserDefaults]integerForKey:kcountryId],(long)[[NSUserDefaults standardUserDefaults]integerForKey:kadministrativeAreaId],(long)[[NSUserDefaults standardUserDefaults]integerForKey:kvenueId],isVenueLeaderboard,friends];
    }
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:queryString url:siteurl contentType:@"" httpMethod:@"GET"];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            if ([globalLeaderboard isDescendantOfView:self.view]) {
                 [globalLeaderboard createLeaderboardView:[json objectForKey:kResponseString] leaderboardCategory:name leaderboardType:leaderboardtype centerName:leaderboardCenterName];
            }
            else
            {
                globalLeaderboard=[[GlobalLeaderboardView alloc]init];
                globalLeaderboard.delegate=self;
                globalLeaderboard.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
                [globalLeaderboard createLeaderboardView:[json objectForKey:kResponseString] leaderboardCategory:name leaderboardType:leaderboardtype centerName:leaderboardCenterName];
                [self.view addSubview:globalLeaderboard];
            }
        }
    }
}

#pragma mark - Global Leaderboard Delegate Methods
- (void)displayDefaultGlobalLeaderboardForSection:(NSString *)section
{
    //Global Leaderboard
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *siteurl = [NSString stringWithFormat:@"leaderboard/%@",@"alltimescore"];
    NSString *queryString =[NSString stringWithFormat:@"countryId=0&administrativeAreaId=0&venueId=0&isVenueLeaderboard=true&friends=false&"];
    if ([section isEqualToString:@"bowling"]) {
        defaultLeaderboard=section;
        queryString =[NSString stringWithFormat:@"countryId=%ld&administrativeAreaId=%ld&venueId=%ld&isVenueLeaderboard=true&friends=false&",(long)[[NSUserDefaults standardUserDefaults]integerForKey:kcountryId],(long)[[NSUserDefaults standardUserDefaults]integerForKey:kadministrativeAreaId],(long)[[NSUserDefaults standardUserDefaults]integerForKey:kvenueId]];
    }
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:queryString url:siteurl contentType:@"" httpMethod:@"GET"];
    [[DataManager shared]removeActivityIndicator];
    globalLeaderboard=[[GlobalLeaderboardView alloc]init];
    globalLeaderboard.delegate=self;
    globalLeaderboard.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    [globalLeaderboard createLeaderboardView:[json objectForKey:kResponseString] leaderboardCategory:@"All Time Score" leaderboardType:1 centerName:leaderboardCenterName];
    [self.view addSubview:globalLeaderboard];
//    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
    
//    }
//    else
//    {
//        [[DataManager shared]removeActivityIndicator];
//    }
}

- (void)showPalyerProfile:(NSString *)userid
{
    NSString *siteurl = @"bowlingstatistic/GetStats";
//    userid=@"41278"; // for Hardik's Account
    NSString *queryString =[NSString stringWithFormat:@"userId=%@&",userid];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:queryString url:siteurl contentType:@"" httpMethod:@"GET"];
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            [[DataManager shared]removeActivityIndicator];
            playerProfile=[[PlayerProfileView alloc]init];
            playerProfile.delegate=self;
            playerProfile.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
            [playerProfile createPlayerView:[json objectForKey:kResponseString]];
            [self.view addSubview:playerProfile];
        }
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
    }
    
}

-(void)removePlayerProfileView
{
    [playerProfile removeFromSuperview];
}
- (void)removeGlobalLeaderboard
{
    [globalLeaderboard removeFromSuperview];
    globalLeaderboard=nil;
    if (![filterView isHidden]) {
        filterView.hidden=YES;
    }
    if (leaderboardtype == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
//        selectCenterView=[[SelectCenterView alloc]init];
//        selectCenterView.CenterSelectionDelegate=self;
//        [centralLeaderboard createLeaderboardViewWithCenterView:selectCenterView];
    }
   
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

#pragma mark - Center Leaderboard Delegate Methods
- (void)displayLeaderboard
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    if ([selectedCenterDetails isKindOfClass:[NSDictionary class]]) {
        leaderboardCenterName=[selectedCenterDetails objectForKey:@"name"];
        int administrativeId=[[[[selectedCenterDetails objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"id"] intValue];
        int countryId=[[[[selectedCenterDetails objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"id"] intValue];
        int venueId=[[selectedCenterDetails objectForKey:@"id"] intValue];
        
        [self getLeaderboardForCenter:@"alltimescore" friends:false countryId:countryId administrativeAreaId:administrativeId venueId:venueId isVenueLeaderboard:true displayName:@"All Time Score"];

    }
 
}

- (void)leaderboardBackFunction
{
    [self.navigationController popViewControllerAnimated:YES];
    [centralLeaderboard removeFromSuperview];
    centralLeaderboard=nil;
    [selectCenterView removeFromSuperview];
    selectCenterView=nil;
    selectCenterModelInstance=nil;

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

@end
