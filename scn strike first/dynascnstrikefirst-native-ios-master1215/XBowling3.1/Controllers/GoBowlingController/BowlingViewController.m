//
//  BowlingViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 11/24/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "BowlingViewController.h"
#import "ServerCalls.h"
#import "SelectCenterViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface BowlingViewController ()
{
    BowlingView *mainView;
    BOOL updatePinFallDict;
       int complete;
    BOOL congratulations;
    int tenthFrameCount; // count for 11th and 12th frame
    ASIFormDataRequest *postManualScoreRequest;
    ASIFormDataRequest *ballTypeRequest;
    LeftSlideMenu *leftMenu;
    RightSlideMenu *gameMenu;
    NSMutableDictionary *liveScorePlayerDictionary;
    NSOperationQueue *gameQueue;
     BOOL isCampusLandscape;
    ChallengesFrameView *frameView;
    NSString *urlStringForChallengers;
    int apinumber;
    ServerCalls *callInstance;
    NSTimer *h2hLiveTimer;
    NSString *liveOpponnentId;
    NSString *superViewOfFrameView;
    NSString *enteredChallenge;
    BOOL showOpponentJoinPopup;
    
    //XB Pro Frame Data
    NSMutableArray *frameDataArray;
     NSArray *ballTypeArray;
    int selectedBallTypeIndex;
    int noOfFrames; // to maintain count of frames i.e. 10 or 11 or 12 frames
    CustomActionSheet *actionSheet ;
    ChallengesViewController *challengeVC;
    NSString *enteredCategory;
    BOOL scorePanelSetupRequired;
    NSString *saveTags;
    id<GAITracker> tracker;
  
}
@end

@implementation BowlingViewController
@synthesize queue;

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Go XBowling"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];

     if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate])  {
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
         [self supportedInterfaceOrientations:NO];
         mainView.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
        
         [self updateGameView];
         [mainView initiateUpdateTimer];
         [mainView updateViewForOrientationChange];
         return;
    }
     if ([[NSUserDefaults standardUserDefaults]boolForKey:kAddedTags])  {
         [self updateGameView];
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kAddedTags];
         return;
     }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])  {
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
        return;
    }
   
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView] && !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])) {
        if ([mainView isDescendantOfView:self.view]) {
            [self addDefaultTags];
            [mainView updateBowlingViewForChallenges];
        }
        
    }
    if ([enteredCategory isEqualToString:@"MyGame"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
    }
    else{
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showBowlingView"]) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        [self supportedInterfaceOrientations:YES];
        [gameMenu updateGametags];
    }
     gameQueue = [[NSOperationQueue alloc] init];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInFSEMView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scorePanelSetupRequired=YES;
      if (!([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView] || [[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]))  {
         [self fetchUpdatedTagList];
     }
    // Do any additional setup after loading the view.
}



- (void)createGameViewforCategory:(NSString *)category
{
    for(UIView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    if ([category isEqualToString:@"MyGame"]) {
        enteredCategory=category;
        if (frameView) {
            [frameView removeFromSuperview];
        }
        mainView.currentFrame=0;
        tenthFrameCount=10;
        complete=0;
        noOfFrames=10;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        
        //Left side Menu
        leftMenu=[[LeftSlideMenu alloc]init];
        leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        leftMenu.rootViewController=self;
        leftMenu.backgroundColor=[UIColor redColor];
        leftMenu.menuDelegate=self;
        leftMenu.hidden=YES;
        [self.view addSubview:leftMenu];
        [leftMenu createMenuView];
        
        //Right side menu
       
        gameMenu=[[RightSlideMenu alloc]init];
        gameMenu.frame=CGRectMake(self.view.frame.size.width, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        gameMenu.hidden=YES;
        gameMenu.userInteractionEnabled=YES;
        gameMenu.backgroundColor=[UIColor clearColor];
        gameMenu.rootViewController=self;
        gameMenu.rightMenuDelegate=self;
        [self.view addSubview:gameMenu];
        [gameMenu createRightMenuView];
        
//        if(![mainView isDescendantOfView:self.view])
//        {
        [mainView removeFromSuperview];
        mainView=nil;
        mainView=[[BowlingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        mainView.bowlingDelgate=self;
        [self.view addSubview:mainView];
        if([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased] && !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]))
        {
            [self getFramesData];
            [self getBallTypeServerCall];
        }
        if ( !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])) {
            [self fetchUpdatedTagList];
        }
        [mainView createBowlingView];
//        }
        gameQueue = [[NSOperationQueue alloc] init];
        [self updateGameView];
        if (mainView.currentFrame != 0) {
            if(ballTypeArray.count > 0 && [[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased] && !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]))
                [self ballTypeServerCall:mainView.currentFrame];
        }
        
             
    }
    else if ([category isEqualToString:@"H2HPosted"])
    {
        superViewOfFrameView=@"Challenges";

        enteredChallenge=category;
        frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        frameView.delegate=self;
        [frameView createFrameViewforChallenge:@"H2HPosted" numberOfPlayers:2];
        [self.view addSubview:frameView];
    }
    else if ([category isEqualToString:@"H2HLive"])
    {
        superViewOfFrameView=@"Challenges";

        enteredChallenge=category;
        frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        frameView.delegate=self;
        [frameView createFrameViewforChallenge:@"H2HLive" numberOfPlayers:1];
        [self.view addSubview:frameView];
        if ([h2hLiveTimer isValid]) {
            [h2hLiveTimer invalidate];
            h2hLiveTimer=nil;
        }
        h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateH2HLive) userInfo:nil repeats:YES];
    }
    else if ([category isEqualToString:@"CreateNewGameviaH2HLive"])
    {
        superViewOfFrameView=@"Challenges";

        enteredChallenge=@"H2HLive";
        frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        frameView.delegate=self;
        [frameView createFrameViewforChallenge:@"H2HLive" numberOfPlayers:1];
        [self.view addSubview:frameView];
        if ([h2hLiveTimer isValid]) {
            [h2hLiveTimer invalidate];
            h2hLiveTimer=nil;
        }
        h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateH2HLive) userInfo:nil repeats:YES];
    }
    else if ([category isEqualToString:@"History"]){
        if (frameView) {
            [frameView removeFromSuperview];
        }
        mainView.currentFrame=0;
        tenthFrameCount=10;
        complete=0;
        noOfFrames=10;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        
        //Left side Menu
        leftMenu=[[LeftSlideMenu alloc]init];
        leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        leftMenu.rootViewController=self;
        leftMenu.menuDelegate=self;
        leftMenu.hidden=YES;
        [self.view addSubview:leftMenu];
        [leftMenu createMenuView];
        
        //Right side menu
        gameMenu=[[RightSlideMenu alloc]init];
        gameMenu.frame=CGRectMake(self.view.frame.size.width, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        gameMenu.hidden=YES;
        gameMenu.userInteractionEnabled=YES;
        gameMenu.rootViewController=self;
        gameMenu.rightMenuDelegate=self;
        [self.view addSubview:gameMenu];
        [gameMenu createRightMenuView];
        
        if(![mainView isDescendantOfView:self.view])
        {
            mainView=[[BowlingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            mainView.bowlingDelgate=self;
            [self.view addSubview:mainView];
            [mainView createBowlingView];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
         [mainView updateViewForOrientationChange];
    }
}

- (void)liveScoreData:(NSDictionary *)liveScoreDict
{
    NSLog(@"liveScoreDict=%@",liveScoreDict);
    liveScorePlayerDictionary=nil;
    liveScorePlayerDictionary=[[NSMutableDictionary alloc]initWithDictionary:liveScoreDict];
    [gameQueue cancelAllOperations];
    [self updateGameView];
}
- (void)liveScoreBackFunction
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInGameHistoryView];
    }
    else{
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - History Section Delegate methods
- (void)historyGameData:(NSDictionary *)historyGameDictionary
{
    mainView.standingPinsMutableArray = [[NSMutableArray alloc] init];
    mainView.tagsArray=[[NSMutableArray alloc]initWithArray:[historyGameDictionary objectForKey:@"gameTags"]];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
//    NSString *finalscore = [NSString stringWithFormat:@"%@",[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:kFinalScore]];
    for (int i=0; i<10; i++) {
        int pinNumber;
        pinNumber = i*2+1;
        NSString *standingPinsKey;
        if (pinNumber<10) {
            standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",pinNumber];
        }
        else{
            standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
        }
        [mainView.standingPinsMutableArray addObject:[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:standingPinsKey]];
        NSLog(@"#######pinNumber=%d",pinNumber);
        pinNumber++;
        if (pinNumber<10) {
            standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",pinNumber];
        }
        else{
            standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
        }
        [mainView.standingPinsMutableArray addObject:[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:standingPinsKey]];
        
        if (i == 9) {
            pinNumber++;
            standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
            [mainView.standingPinsMutableArray addObject:[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:standingPinsKey]];
        }
        NSLog(@"#######pinNumber=%d",pinNumber);
        
        //                    //update score labels
        //                    [mainView updateScorePanel:json];
    }
     int previous=0;
    for (int i = 0; i <= 20; i++)
    {
        int pins=(int)[[mainView.standingPinsMutableArray objectAtIndex:i] integerValue];
        int prevPin=(int)[[mainView.standingPinsMutableArray objectAtIndex:i]integerValue];
        
        if (pins == 0) {
            if([[NSString stringWithFormat:@"%@",[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i+1]]] isEqualToString:@"X"] || [[NSString stringWithFormat:@"%@",[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i+1]]] isEqualToString:@"/"] ||  [[NSString stringWithFormat:@"%@",[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i]]] isEqualToString:@"X"])
            {
                
            }
            else
            {
                pins = 1023;
                prevPin = 1023;
            }
        }
        if (pins == -1) {
            if(((i+1)&1)==0 && previous==0){
                pins = 0;
            }else {
                pins = 1023;
            }
            prevPin = 1023;
        }
        if(updatePinFallDict == NO)
        {
            [mainView.pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pins] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [mainView.pinFallPreviousStateDictionary setValue:[NSString stringWithFormat:@"%d",prevPin] forKeyPath:[NSString stringWithFormat:@"%d",i+1]];
        }
        previous=pins;
    }
    //get current frame
    int latestSquareNumber=[[[historyGameDictionary objectForKey:@"scoredGame"] objectForKey:@"latestSquareNumber"] intValue];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowFrame"] == NO) {
        if (mainView.currentFrame == 0) {
            if(latestSquareNumber > 0){
                if(latestSquareNumber % 2 == 0){
                    mainView.currentFrame=latestSquareNumber/2;
                }
                else{
                    mainView.currentFrame=latestSquareNumber/2+1;
                    if (latestSquareNumber == 21) {
                        mainView.currentFrame=10;
                    }
                }
                //                            if(mainView.currentFrame < 10)
                //                                mainView.currentFrame++;
            }
            else
                mainView.currentFrame=1;
        }
        
    }
    NSLog(@"pinfall=%@",mainView.pinFallDictionary);
    NSLog(@"standingPinsMutableArray=%@",mainView.standingPinsMutableArray);
    NSLog(@"2Jan frame=%d",mainView.currentFrame);
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"AppLaunch"])
    {
        NSDictionary *scoreDict=[[NSDictionary alloc]initWithObjectsAndKeys:[historyGameDictionary objectForKey:@"scoredGame"],@"bowlingGame", nil];
        [[DataManager shared]removeActivityIndicator];
        [mainView updateScorePanel:scoreDict];
        [mainView updatePinView:mainView.currentFrame];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AppLaunch"];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [mainView updateFrameScore:[historyGameDictionary objectForKey:@"scoredGame"]];
    }

}

-(void)updateGameView
{
    @try {
        // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus != NotReachable) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"called");
            mainView.standingPinsMutableArray = [[NSMutableArray alloc] init];
            NSString *url ;
            NSString *urlString;
            NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
            token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                [dateFormat setTimeZone:timeZone];
                NSString *toDateString = [dateFormat stringFromDate:[NSDate date]];
                NSDate *fromDate=[NSDate dateWithTimeInterval:-5400 sinceDate:[NSDate date]];
                NSString *fromDateString=[dateFormat stringFromDate:fromDate];
                fromDateString=[fromDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                toDateString=[toDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSLog(@"toDate=%@  fromDate=%@",toDateString,fromDateString);
                url = [NSString stringWithFormat:@"venue/%@/GamePerPlayer",[liveScorePlayerDictionary objectForKey:@"venueID"]];
                urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&to=%@&from=%@&laneId=%@&rowkey=%@",serverAddress,url,token,APIKey,toDateString,fromDateString,[liveScorePlayerDictionary objectForKey:@"laneID"],[liveScorePlayerDictionary objectForKey:@"rowKey"]];
            }
            else
            {
                if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
                    url = [NSString stringWithFormat:@"manuallanecheckout/%@/bowlinggameviewnew", [userDefaults objectForKey:klaneCheckOutId]];
                }
                else{
                    url = [NSString stringWithFormat:@"lanecheckout/%@/bowlinggameview", [userDefaults objectForKey:klaneCheckOutId]];
                }
                
                urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,url,token,APIKey];
            }
            NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                  timeoutInterval:kTimeoutInterval];
            NSLog(@"requestURL=%@",urlString);
            [URLrequest setHTTPMethod:@"GET"];
            [NSURLConnection sendAsynchronousRequest:URLrequest queue:gameQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                 int statusCode = (int)[httpResponse statusCode];
                 //             NSString *responseString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 //        NSLog(@"responseString = %@",responseString);
                 NSLog(@"statusCode=%ld",(long)statusCode);
                 if (statusCode == 200 || statusCode == 201)
                 {
                     NSError *error1;
                     NSDictionary *json;
                     //                 if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView] == YES) {
                     //                     //For Player's game in h2hposted
                     //                     [[DataManager shared]removeActivityIndicator];
                     //                     json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
                     //                     [frameView updateViewofPlayer:1 scoreDict:json];
                     //                 }
                     //                 else
                     //                 {
                     //For Player's Game in live score and My game section
                     if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
                         NSDictionary *responsedict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
                         json=[[NSDictionary alloc]initWithObjectsAndKeys:responsedict,@"bowlingGame", nil];
                     }
                     else
                         json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
                     
                     if (json.count > 0) {
                         NSLog(@"jonShreya = %@",json);

                         dispatch_async( dispatch_get_main_queue(), ^{
                             NSString *finalscore = [NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:kFinalScore]];
                             if (mainView.standingPinsMutableArray == NULL) {
                                 mainView.standingPinsMutableArray=[[NSMutableArray alloc]init];
                             }
                             for (int i=0; i<10; i++) {
                                 int pinNumber;
                                 pinNumber = i*2+1;
                                 NSString *standingPinsKey;
                                 if (pinNumber<10) {
                                     standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",pinNumber];
                                 }
                                 else{
                                     standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
                                 }
                                 if ([[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey] != nil) {
                                     [mainView.standingPinsMutableArray addObject:[[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey]];
                                 }
                                 NSLog(@"#######pinNumber=%d",pinNumber);
                                 pinNumber++;
                                 if (pinNumber<10) {
                                     standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",pinNumber];
                                 }
                                 else{
                                     standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
                                 }
                                  if ([[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey] != nil) {
                                      [mainView.standingPinsMutableArray addObject:[[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey]];
                                  }
                                 
                                 if (i == 9) {
                                     pinNumber++;
                                     standingPinsKey = [NSString stringWithFormat:@"standingPins%d",pinNumber];
                                      if ([[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey] != nil) {
                                          [mainView.standingPinsMutableArray addObject:[[json objectForKey:@"bowlingGame"] objectForKey:standingPinsKey]];
                                      }
                                 }
                                 NSLog(@"#######pinNumber=%d",pinNumber);
                                 
                                 //                    //update score labels
                                 //                    [mainView updateScorePanel:json];
                             }
                             if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Machine"] ||[[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                 BOOL spareyes;
                                 int priortocheck;
                                 priortocheck=0;
                                 for(int i=1;i<=21;i++)
                                 {
                                     
                                     NSString *ballKey = [NSString stringWithFormat:@"squareScore%d",i];
                                     if(( [[[json objectForKey:@"bowlingGame"] objectForKey:ballKey] isEqualToString:@"X"])&&(i>priortocheck))
                                     {
                                         priortocheck=i;
                                         spareyes=NO;
                                         
                                     }
                                     else  if( ( [[[json objectForKey:@"bowlingGame"] objectForKey:ballKey] isEqualToString:@"/"])&&(i>priortocheck))
                                     {
                                         priortocheck=i;
                                         spareyes=YES;
                                     }
                                     int pins=(int)[[mainView.standingPinsMutableArray objectAtIndex:i-1] integerValue];
                                     //                                 int prevPin = 1023;
                                     //                                 if (i> 1) {
                                     //                                     prevPin=(int)[[mainView.standingPinsMutableArray objectAtIndex:i-2]integerValue];
                                     //                                 }
                                     int prevPin=(int)[[mainView.standingPinsMutableArray objectAtIndex:i-1]integerValue];
                                     if (pins == 0) {
                                         if([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i]]] isEqualToString:@"X"] || [[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i]]] isEqualToString:@"/"])
                                         {
                                             
                                         }
                                         else if ([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i]]] isEqualToString:@""] && ([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i-1]]] isEqualToString:@"X"] || [[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i-1]]] isEqualToString:@"/"]))
                                         {
                                             pins=0;
                                             prevPin=0;
                                         }
                                         else
                                         {
                                             //                                         if (prevPin == 0) {
                                             //                                             pins=0;
                                             //                                         }
                                             //                                         else{
                                             pins = 1023;
                                             prevPin = 1023;
                                             //                                         }
                                         }
                                     }
                                     if (pins == -1) {
                                         pins=1023;
                                         prevPin = 1023;
                                     }
                                     [mainView.standingPinsMutableArray replaceObjectAtIndex:(i-1) withObject:[NSString stringWithFormat:@"%d",pins] ];
                                 }
                                 NSLog(@"%@",mainView.standingPinsMutableArray);
                                 if(updatePinFallDict ==NO)
                                 {
                                     [self updatePocketBrooklynForTenthFrame:json];
                                 }
                             }
                             else
                             {
                                 [self updatePocketBrooklynForTenthFrame:json];
                                 int previous=0;
                                 for (int i = 0; i <= 20; i++)
                                 {
                                     int pins=(int)[[mainView.standingPinsMutableArray objectAtIndex:i] integerValue];
                                     int prevPin=(int)[[mainView.standingPinsMutableArray objectAtIndex:i]integerValue];
                                     
                                     if (pins == 0) {
                                         if([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i+1]]] isEqualToString:@"X"] || [[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i+1]]] isEqualToString:@"/"] ||  [[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",i]]] isEqualToString:@"X"])
                                         {
                                             
                                         }
                                         else
                                         {
                                             pins = 1023;
                                             prevPin = 1023;
                                         }
                                     }
                                     if (pins == -1) {
                                         if(((i+1)&1)==0 && previous==0){
                                             pins = 0;
                                         }else {
                                             pins = 1023;
                                         }
                                         prevPin = 1023;
                                     }
                                     if(updatePinFallDict == NO)
                                     {
                                         [mainView.pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pins] forKey:[NSString stringWithFormat:@"%d",i+1]];
                                         [mainView.pinFallPreviousStateDictionary setValue:[NSString stringWithFormat:@"%d",prevPin] forKeyPath:[NSString stringWithFormat:@"%d",i+1]];
                                     }
                                     previous=pins;
                                 }
                                 updatePinFallDict=YES;
                             }
                             
                             //get current frame
                             int latestSquareNumber=[[[json objectForKey:@"bowlingGame"] objectForKey:@"latestSquareNumber"] intValue];
                             if ([userDefaults boolForKey:@"ShowFrame"] == NO) {
                                 if (mainView.currentFrame == 0 || [[userDefaults objectForKey:kscoringType] isEqualToString:@"Machine"]|| [userDefaults boolForKey:kliveScoreUpdate]) {
                                     if(latestSquareNumber > 0){
                                         if(latestSquareNumber % 2 == 0){
                                             mainView.currentFrame=latestSquareNumber/2;
                                         }
                                         else{
                                             mainView.currentFrame=latestSquareNumber/2+1;
                                             if (latestSquareNumber == 21) {
                                                 mainView.currentFrame=10;
                                             }
                                         }
                                     }
                                     else
                                         mainView.currentFrame=1;
                                 }
                                 
                             }
                             NSLog(@"pinfall=%@",mainView.pinFallDictionary);
                             NSLog(@"2Jan frame=%d",mainView.currentFrame);
                             //update score labels
                             dispatch_async( dispatch_get_main_queue(), ^{
                                 if([[NSUserDefaults standardUserDefaults]boolForKey:@"AppLaunch"])
                                 {
                                     if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
                                         if ( [[userDefaults objectForKey:kscoringType] isEqualToString:@"Machine"]||[[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                             [mainView updateScorePanel:json];
                                             scorePanelSetupRequired=NO;
                                         }
                                         else{
                                             [mainView updateFrameScore:json];
                                         }
                                     }
                                     else{
                                         NSLog(@"%@",[userDefaults objectForKey:kscoringType]);
                                         if (scorePanelSetupRequired || [[userDefaults objectForKey:kscoringType] isEqualToString:@"Machine"]||[[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                             [mainView updateScorePanel:json];
                                             scorePanelSetupRequired=NO;
                                         }
                                         else{
                                             [mainView updateFrameScore:json];
                                         }
                                         
                                     }
                                     [mainView updatePinView:mainView.currentFrame];
                                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AppLaunch"];
                                     [[DataManager shared]removeActivityIndicator];
                                 }
                                 else
                                 {
                                     [mainView updateFrameScore:json];
                                     
                                     [[DataManager shared]removeActivityIndicator];
                                 }
                             });
                             //update pinView
                             //                [self updateSingleFrameView: mainView.currentFrame];
                             [[NSUserDefaults standardUserDefaults]setInteger:[[[json objectForKey:@"bowlingGame"] objectForKey:@"isComplete"]integerValue] forKey:kgameComplete];
                             
                             if ([[[json objectForKey:@"bowlingGame"] objectForKey:@"isComplete"] boolValue]) {
                                 [mainView.timerforMyGameUpdateView invalidate];
                                 mainView.timerforMyGameUpdateView = nil;
                                 complete=(int)[[[json objectForKey:@"bowlingGame"] objectForKey:@"isComplete"]integerValue];
                                 [[NSUserDefaults standardUserDefaults]setValue:finalscore forKey:kFinalScore];
                                 
                                
                                     //congrats UI
                                     dispatch_async( dispatch_get_main_queue(), ^{
                                         [mainView.timerforMyGameUpdateView invalidate];
                                         mainView.timerforMyGameUpdateView=nil;
                                         [mainView updateScorePanel:json];
                                         if (![[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] && ![[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
                                             if (mainView.currentFrame == 10) {
                                                 [self showGameSummary];
                                             }
                                             
                                         }

                                         if (!congratulations ) {
                                            if (![[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
                                                 congratulations=YES;
                                                 [[[UIAlertView alloc]initWithTitle:@"Game Completed" message:[NSString stringWithFormat:@"Congratulations! You scored %@.",finalscore] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                             }
                                             [[DataManager shared]removeActivityIndicator];
                                         }
                                         else{
                                            [[DataManager shared]removeActivityIndicator];
                                         }
                                         
                                         if ([[NSUserDefaults standardUserDefaults]boolForKey:kaddLoyaltyPoints]) {
                                             //Add Wallet Points on Game End
                                             [self addPointsToWalletForVenue];
                                         }
                                     });
                                 
                             }
                         });
                     }
                     else{
                         dispatch_async( dispatch_get_main_queue(), ^{
                             [[DataManager shared]removeActivityIndicator];
                         });
                     }
                     //                 }
                     
                 }
                 else
                 {
                     dispatch_async( dispatch_get_main_queue(), ^{
                         [[DataManager shared]removeActivityIndicator];
                     });
                 }
             }];
        }
        else
        {
            [[DataManager shared] removeActivityIndicator];
            //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //        [alert show];
            //        alert=nil;
        }

    }
    @catch (NSException *exception) {
        [[DataManager shared] removeActivityIndicator];
    }
}

- (void)addPointsToWalletForVenue
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kaddLoyaltyPoints];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0", @"Points",@"Add Points", @"Notes", @"true", @"IsRedeemable", [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kvenueId]], @"VenueId",@"10000",@"BusinessBuilderItemID",  nil];
    NSDictionary *json=[[ServerCalls instance] serverCallWithPostParameters:postDict andQueryParameters:@"" url:[NSString stringWithFormat:@"venue/userpoint/0"] contentType:@"application/json" httpMethod:@"POST"];
    NSLog(@"json=%@",json);
}

-(void)showSelectedFrame
{
    [self updateGameView];
}

-(void)updatePocketBrooklynForTenthFrame:(NSDictionary *)json
{
    if([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",19]]] isEqualToString:@"X"])
    {
        if([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]] isEqualToString:@"X"])
        {
            mainView.ballsDependencyState=1;
        }
        else
            mainView.ballsDependencyState=3;
    }
    else if ([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",19]]] isEqualToString:@""])
    {
        mainView.ballsDependencyState=1;
    }
    else
    {
        if([[NSString stringWithFormat:@"%@",[[json objectForKey:@"bowlingGame"] objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]] isEqualToString:@"/"])
        {
            mainView.ballsDependencyState=2;
        }
        else
            mainView.ballsDependencyState=4;
    }
    tenthFrameCount=10;
}

-(void)postManualScore:(int)frame
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            [[DataManager shared]removeActivityIndicator];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        alert=nil;
        });
    }
    else
    {
        NSError *error = NULL;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"pinFall=%@",mainView.pinFallDictionary);
        NSString *standingPins1and2 = [self calculateScore:(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2 - 1)]] integerValue] secondPins:(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2)]] integerValue] thirdPins:(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2 + 1)]] integerValue] currentFrame:frame];
        NSArray *temp=[standingPins1and2 componentsSeparatedByString:@","];
        NSLog(@"temp=%@",temp);
//        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",frame], @"frameNumber",[temp objectAtIndex:0],@"firstBall", [temp objectAtIndex:1], @"secondBall",@"",@"thirdBall",[NSString stringWithFormat:@"%ld",(long)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2 - 1)]] integerValue]],@"FirstBallStandingPin",[NSString stringWithFormat:@"%ld",(long)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2)]] integerValue]],@"SecondBallStandingPin",@"",@"ThirdBallStandingPin", nil];
        
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",frame], @"frameNumber",[temp objectAtIndex:0],@"firstBall", [temp objectAtIndex:1], @"secondBall",[temp objectAtIndex:2],@"thirdBall",[NSString stringWithFormat:@"%ld",(long)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2 - 1)]] integerValue]],@"FirstBallStandingPin",[NSString stringWithFormat:@"%ld",(long)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2)]] integerValue]],@"SecondBallStandingPin",[NSString stringWithFormat:@"%ld",(long)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame*2 + 1)]] integerValue]],@"ThirdBallStandingPin", nil];
        
        NSLog(@"dict11=%@",postDict);
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
        NSString* dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"dict11=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableData *postDataMutable=[[NSMutableData alloc]initWithData:postdata];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/manualscores?apiKey=%@&token=%@", serverAddress, [userDefaults objectForKey:kbowlingGameId]  , APIKey, token];
        NSLog(@"url of manualScore call %@",urlString);
        
        if (![self queue]) {
            [self setQueue:[[NSOperationQueue alloc] init]];
        }
        
//        postManualScoreRequest=[[ASIFormDataRequest alloc]init];
        postManualScoreRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        [postManualScoreRequest setTimeOutSeconds:kTimeoutInterval];
        postManualScoreRequest.tag=22000+frame;
        [postManualScoreRequest setDelegate:self];
        [postManualScoreRequest startAsynchronous];
        [postManualScoreRequest setRequestMethod:@"POST"];
        [postManualScoreRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [postManualScoreRequest addRequestHeader:@"Content-Length" value:postlength];
        [postManualScoreRequest setPostBody:postDataMutable];
        [[self queue] addOperation:postManualScoreRequest]; //queue is an NSOperationQueue
        
    }
}

-(void)requestStarted:(ASIHTTPRequest *)ASIrequest{
    NSLog(@"Request started %ld",(long)ASIrequest.tag);}

-(void)requestFinished:(ASIHTTPRequest *)ASIrequest
{
    NSLog(@"data in request finished=%@",[[NSString alloc]initWithData:[ASIrequest responseData] encoding:NSUTF8StringEncoding] );
    
    if(ASIrequest == postManualScoreRequest)
    {
        NSLog(@"Request tag=%ld",(long)ASIrequest.tag);
        NSLog(@"response");
        if([ASIrequest responseData])
        {
            if (ASIrequest.responseStatusCode == 200) {
                NSLog(@"response frame no %d",mainView.currentFrame);
                [self updateGameView];
                //ballType server call
                if([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased])
                    [self ballTypeServerCall:(int)(ASIrequest.tag - 22000)];

//                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                      dispatch_async( dispatch_get_main_queue(), ^{
//                        
//                    });
//                });
            }
            else
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared]removeActivityIndicator];
                    [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [[DataManager shared]removeActivityIndicator];
    NSLog(@"requestFailed for frame =%d",mainView.currentFrame);
    NSError *error = [request error];
    NSLog(@"Error: %@", [error localizedDescription]);
    NSLog(@"Request tag=%ld",(long)request.tag);
    
}

- (NSString *)calculateScore:(int)firstPins secondPins:(int)secondPins thirdPins:(int) thirdPins currentFrame:(int)frame
{
    NSLog(@"firstPins=%d  secondPin=%d  thirdPin=%d",firstPins,secondPins,thirdPins);
    int firstScore = 0;
    int secondScore = 0;
    for (int i = 1; i <= 10; i++) {
        if ((firstPins & (int)pow(2, i - 1)) == 0) {
            ++firstScore;
        }
        if ((secondPins & (int)pow(2, i - 1)) == 0) {
            ++secondScore;
        }
    }
    int thirdScore = 0;
    NSString *third = @"";
    
    if (thirdPins != -1) {
        for (int i = 1; i <= 10; i++) {
            if ((thirdPins & (int)pow(2, i - 1)) == 0) {
                ++thirdScore;
            }
        }
    }
    NSString *first = @"";
    NSString *second = @"";
    if (frame == 10) {
        if (firstScore == 10) {
            first = @"X";
            second = [NSString stringWithFormat:@"%d",(secondScore )];
            if (secondScore == 10) {
                second = @"X";
                third = [NSString stringWithFormat:@"%d",thirdScore];
                
                if (thirdScore == 10) {
                    third = @"X";
                }
            } else {
                if (thirdScore == 10) {
                    third = @"/";
                } else {
                    third = [NSString stringWithFormat:@"%d",(thirdScore - secondScore)];
                    
                }
            }
        } else {
            first = [NSString stringWithFormat:@"%d",firstScore];
            
            if (secondScore == 10) {
                second = @"/";
                if (thirdScore == 10) {
                    third = @"X";
                } else {
                    third = [NSString stringWithFormat:@"%d",thirdScore];
                    
                }
            } else {
                second = [NSString stringWithFormat:@"%d",(secondScore - firstScore)];
                
            }
        }
        
    } else {
        if (firstScore == 10) {
            first = @"X";
            second = @"";
        } else if (secondScore == 10) {
            second = @"/";
            first = [NSString stringWithFormat:@"%d",firstScore];
        } else {
            second = [NSString stringWithFormat:@"%d",(secondScore - firstScore)];
            first = [NSString stringWithFormat:@"%d",firstScore];
        }
    }
    
    return [NSString stringWithFormat:@"%@,%@,%@",first,second,third];
}

- (void)checkPreviousState:(int)frame
{
    @try {
        BOOL stateChanged = false;
        NSLog(@"previous=%@ pinFall=%@",mainView.pinFallPreviousStateDictionary,mainView.pinFallDictionary);
        NSLog(@"frame=%d",mainView.currentFrame);
        if(![[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2 - 1)]] isEqualToString:[mainView.pinFallPreviousStateDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2 - 1)]]])
        {
            stateChanged = true;
            [mainView.pinFallPreviousStateDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",(frame * 2 - 1)]];
            [mainView.pinFallPreviousStateDictionary setObject:[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2 - 1)]] forKey:[NSString stringWithFormat:@"%d",(frame * 2 - 1)]];
            
        }
        
        if (![[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2)]] isEqualToString:[mainView.pinFallPreviousStateDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2)]]]) {
            stateChanged = true;
            [mainView.pinFallPreviousStateDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",(frame * 2)]];
            [mainView.pinFallPreviousStateDictionary setObject:[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2)]] forKey:[NSString stringWithFormat:@"%d",(frame * 2)]];
        }
        if (![[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2+1)]] isEqualToString:[mainView.pinFallPreviousStateDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2+1)]]]) {
            stateChanged = true;
            [mainView.pinFallPreviousStateDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",(frame * 2 + 1)]];
            [mainView.pinFallPreviousStateDictionary setObject:[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2 + 1)]] forKey:[NSString stringWithFormat:@"%d",(frame * 2 + 1)]];
        }
        stateChanged=true;
        if (stateChanged) {
            
            int thirdPins;
            if(frame == 10)
                thirdPins=(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(frame * 2 + 1)]] integerValue];
            else
                thirdPins=-1;
//            NSString *scores=[self calculateScore:(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(mainView.currentFrame * 2 - 1)]] integerValue] secondPins:(int)[[mainView.pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",(mainView.currentFrame * 2)]] integerValue] thirdPins:thirdPins currentFrame:mainView.currentFrame];
            
            //            NSArray *scoresArray=[scores componentsSeparatedByString:@","];
            //Update score label
            [self postManualScore:frame];
        }
        else
        {
            dispatch_async( dispatch_get_main_queue(), ^{
//                   [self updateGameView];
                [[DataManager shared]removeActivityIndicator];
            });
            
            //            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                if([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased])
            //                    [self ballTypeServerCall:mainView.currentFrame];
            //
            //            });
            
        }
        
    }
    @catch (NSException *exception) {
        return;
    }
}
 - (void)endGame
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)[[userDefaults objectForKey:klaneCheckOutId] integerValue]], @"id", nil];

    NSString *urlString;
    if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
        urlString =@"manuallanecheckout";
    }
    else{
        urlString =@"lanecheckout";
    }
    NSDictionary *json = [[ServerCalls instance] serverCallWithPostParameters:postDict url:urlString contentType:@"application/json" httpMethod:@"DELETE"];
    NSLog(@"response code=%@",json);
    [[DataManager shared] removeActivityIndicator];
    if ([[json objectForKey:@"responseStatusCode"] isEqualToString:@"204"]) {
        [gameMenu removeFromSuperview];
        gameMenu=nil;
        [userDefaults removeObjectForKey:kbowlingGameId];
        [userDefaults removeObjectForKey:kliveCompetitionId];
        [userDefaults removeObjectForKey:klaneCheckOutId];
        [userDefaults setInteger:0 forKey:kgameComplete];
        [userDefaults setBool:NO forKey:kInChallengeView];
        [userDefaults removeObjectForKey:kcurrentChallenge];
        [userDefaults setBool:NO forKey:kenteredH2HLive];
        [userDefaults setBool:NO forKey:kenteredH2HPosted];
        [userDefaults setBool:NO forKey:kPostedGameTagAdded];
//        [self laneCheckout];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
        SelectCenterViewController *svc=[[SelectCenterViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else{
        
    }

}

- (void)startNewGame
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kaddLoyaltyPoints];
    [h2hLiveTimer invalidate];
    h2hLiveTimer=nil;
    mainView.currentFrame=0;
    updatePinFallDict=NO;
    congratulations=NO;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kgameComplete];

    NSString *laneString;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType] isEqualToString:@"Manual"]) {
        laneString = @"manuallanecheckout";
    }
    else{
        laneString = @"lanecheckout";
    }    NSLog(@"lanecheckout");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *venueId = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:kvenueId] intValue]];
    NSDictionary *venueDict = [[NSDictionary alloc] initWithObjectsAndKeys:venueId, @"id", nil];
    //    NSString *bowlerName=[[NSString stringWithFormat:@"%@",[userDefaults stringForKey:kbowlerName]]stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *bowlerName=[NSString stringWithFormat:@"%@",[userDefaults stringForKey:kbowlerName]];
    NSString *laneNumber = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:klaneNumber] intValue]];
    NSString *centername = [userDefaults objectForKey:kcenterName];
    NSString *competitionType = [userDefaults objectForKey:kCompetitionTypeId];
    if([[NSString stringWithFormat:@"%@",competitionType] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kCompetitionTypeId];
        competitionType=@"0";
    }
    NSString *patternLengthId= [userDefaults objectForKey:kPatternLengthId];
    if([[NSString stringWithFormat:@"%@",patternLengthId] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternLengthId];
        patternLengthId=@"0";
    }
    NSString *patternNameId=[userDefaults objectForKey:kPatternNameId];
    if([[NSString stringWithFormat:@"%@",patternNameId] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternNameId];
        patternNameId=@"0";
    }
    NSLog(@"venueId %@ bowlerName %@ laneNumber %@ centerName %@ ",venueId, bowlerName, laneNumber, centername );
    
    NSDate *currentDate=[NSDate date];
    NSLog(@"currentDate=%@",currentDate);
    NSString *format=@"MM/dd/yyyy HH:mm:ss";
    NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
    NSString *displayDate=[formatterUtc stringFromDate:currentDate];
    NSLog(@"displayDate=%@",displayDate);
    
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:venueDict, @"venue",bowlerName, @"bowlerName", laneNumber, @"laneNumber", centername, @"venueName",competitionType,@"CompetitionTypeId",patternLengthId,@"UserStatPatternLengthId",patternNameId,@"UserStatPatternNameId",displayDate,@"CreatedDate",  nil];
    
    NSDictionary *json=[[ServerCalls instance]serverCallWithPostParameters:postDict url:laneString contentType:@"application/json" httpMethod:@"POST"];
    NSLog(@"json=%@",json);
    if (json!=NULL) {
        if([[json objectForKey:kResponseStatusCode] integerValue] == 200 || [[json objectForKey:kResponseStatusCode] integerValue] == 201)
        {
            complete=0;
            // [userDefaults setBool:NO forKey:kgameCompletionBool];
            [userDefaults removeObjectForKey:kliveCompetitionId];
            [userDefaults setBool:NO forKey:kInChallengeView];
            [userDefaults removeObjectForKey:kcurrentChallenge];
            [userDefaults setBool:NO forKey:kenteredH2HLive];
            [userDefaults setBool:NO forKey:kenteredH2HPosted];
            [userDefaults setBool:NO forKey:kPostedGameTagAdded];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:ksavingGameTags];
            [userDefaults setObject:[[[json objectForKey:kResponseString]  objectForKey:@"bowlingGame"] objectForKey:@"id" ] forKey:kbowlingGameId];
            [userDefaults setObject:[[json objectForKey:kResponseString]  objectForKey:@"id"] forKey:klaneCheckOutId];
            NSLog(@"lanecheckout=%@",[userDefaults objectForKey:klaneCheckOutId]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [mainView createBowlingView];
                [self updateGameView];
                [self getFramesData];
                [self fetchUpdatedTagList];
                [[DataManager shared] removeActivityIndicator];
            });
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            [[[UIAlertView alloc]initWithTitle:@"Error!" message:[NSString stringWithFormat:@"An error occurred. Please try again later."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }

    
    /*NSString *laneString;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType ] isEqualToString:@"Manual"]) {
        laneString = @"manuallanecheckout";
    }
    else{
        laneString = @"lanecheckout";
    }
    NSLog(@"lanecheckout");
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[DataManager shared] removeActivityIndicator];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            alert=nil;
        });
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *venueId = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:kvenueId] intValue]];
        NSDictionary *venueDict = [[NSDictionary alloc] initWithObjectsAndKeys:venueId, @"id", nil];
        NSString *bowlerName = [userDefaults stringForKey:kbowlerName];
        NSString *laneNumber = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:klaneNumber] intValue]];
        NSString *centername = [userDefaults objectForKey:@"centername"];
        NSString *competitionType = @"";
        NSString *patternLengthId= @"";
        NSString *patternNameId=@"";
        NSLog(@"venueId %@ bowlerName %@ laneNumber %@ centerName %@ ",venueId, bowlerName, laneNumber, centername );
        
        NSDate *currentDate=[NSDate date];
        NSLog(@"currentDate=%@",currentDate);
        NSString *format=@"MM/dd/yyyy HH:mm:ss";
        NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
        [formatterUtc setDateFormat:format];
        [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
        NSString *displayDate=[formatterUtc stringFromDate:currentDate];
        NSLog(@"displayDate=%@",displayDate);
        
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:venueDict, @"venue",bowlerName, @"bowlerName", laneNumber, @"laneNumber", centername, @"venueName",competitionType,@"CompetitionTypeId",patternLengthId,@"UserStatPatternLengthId",patternNameId,@"UserStatPatternNameId",displayDate,@"CreatedDate",  nil];
        NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted error:nil];
        NSString* dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        //dataString = [dataString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"dict=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString = [NSString stringWithFormat:@"%@%@?apiKey=%@&token=%@", serverAddress, laneString, APIKey, token];
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@", urlString);
        [URLrequest setHTTPMethod:@"POST"];
        [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [URLrequest setHTTPBody:postdata];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        if(responseData)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            NSLog(@"json=%@",json);
            if (json!=NULL) {
                if(response.statusCode == 200 || response.statusCode == 201)
                {
                    complete=0;
                    // [userDefaults setBool:NO forKey:kgameCompletionBool];
                    [userDefaults removeObjectForKey:kliveCompetitionId];
                    [userDefaults setBool:NO forKey:kInChallengeView];
                    [userDefaults setObject:[[json  objectForKey:@"bowlingGame"] objectForKey:@"id" ] forKey:kbowlingGameId];
                    [userDefaults setObject:[json  objectForKey:@"id"] forKey:klaneCheckOutId];
                    NSLog(@"lanecheckout=%@",[userDefaults objectForKey:klaneCheckOutId]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[DataManager shared] removeActivityIndicator];
                        [mainView createBowlingView];
                        [self updateGameView];
                        [self getFramesData];
                    });
                }
                else
                {
                    [[DataManager shared]removeActivityIndicator];
                    [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        }
    }*/

}

- (void)showGameSummary
{
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Game Summary"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"UserStat/GetByGameId"];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"BowlingGameId=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId]] url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0) {
        NSDictionary *responseDict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]];
         NSString *urlString = [NSString stringWithFormat:@"bowlingchallenge/results"];
        NSDictionary *challengesJson = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"gameId=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId]] url:urlString contentType:@"" httpMethod:@"GET"];
        [[DataManager shared] removeActivityIndicator];
        if ([[challengesJson objectForKey:kResponseString] count]>0) {
            [mainView gameSummaryView:responseDict challengesArray:[challengesJson objectForKey:kResponseString]];
        }
        else{
            [mainView gameSummaryView:responseDict challengesArray:[[NSArray alloc] init]];
        }
    }
    else{
        [[DataManager shared] removeActivityIndicator];
    }
}

- (void)updateRightMenu
{
    [gameMenu reloadRightMenu:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated
{
    [gameQueue cancelAllOperations];
    [mainView.timerforMyGameUpdateView invalidate];
    mainView.timerforMyGameUpdateView = nil;
    [h2hLiveTimer invalidate];
    h2hLiveTimer=nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];

//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
//    [self supportedInterfaceOrientations:NO];
}
- (void)urlForh2hPostedChallenger:(NSString *)url
{
    urlStringForChallengers=url;
}

#pragma mark - XB Pro Related Functions

// Get Frame by frame XB Pro related data on game launch
-(void)getFramesData
{
    mainView.userStatsDataArray=[NSMutableArray new];
    frameDataArray=[[NSMutableArray alloc]init];
    NSString *params=[NSString stringWithFormat:@"bowlinggameId=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kbowlingGameId]];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kbowlingGameId]);
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:@"UserStat/getframe" contentType:@"" httpMethod:@"GET"];
    NSArray *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(response.count > 0)
            frameDataArray=[NSMutableArray arrayWithArray:response];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        //        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    for(int i =0;i<[frameDataArray count];i++)
    {
        NSMutableDictionary *temp=[NSMutableDictionary new];
        @try {
            if(![[NSString stringWithFormat:@"%@",[[frameDataArray objectAtIndex:i] objectForKey:@"bowlingBallNames"]] isEqualToString:@"<null>"])
                [temp setObject:[NSString stringWithFormat:@"%@",[[[frameDataArray objectAtIndex:i] objectForKey:@"bowlingBallNames"] objectForKey:@"userBowlingBallName"]] forKey:@"BallName"];
            else
                [temp setObject:@"Select Ball" forKey:@"BallName"];
            [temp setObject:[NSString stringWithFormat:@"%@",[[frameDataArray objectAtIndex:i] objectForKey:@"isBrooklynOrPocket"] ] forKey:@"PocketBrooklyn"];
            [temp setObject:[NSString stringWithFormat:@"%@",[[frameDataArray objectAtIndex:i] objectForKey:@"frameNo"] ] forKey:@"FrameNumber"];
            [mainView.userStatsDataArray insertObject:temp atIndex:i];
        }
        @catch (NSException *exception) {
            if([[[frameDataArray objectAtIndex:i] objectForKey:@"bowlingBallNames"] count] > 0)
                [temp setObject:[NSString stringWithFormat:@"%@",[[[frameDataArray objectAtIndex:i] objectForKey:@"bowlingBallNames"] objectForKey:@"userBowlingBallName"]] forKey:@"BallName"];
            else
                [temp setObject:@"Select Ball" forKey:@"BallName"];
            [temp setObject:[NSString stringWithFormat:@"%@",[[frameDataArray objectAtIndex:i] objectForKey:@"isBrooklynOrPocket"] ] forKey:@"PocketBrooklyn"];
            [temp setObject:[NSString stringWithFormat:@"%@",[[frameDataArray objectAtIndex:i] objectForKey:@"frameNo"] ] forKey:@"FrameNumber"];
            [mainView.userStatsDataArray insertObject:temp atIndex:i];
        }
    }
    NSString *ballName=@"Select Ball";
    if ([[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName]) {
        ballName=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName] objectForKey:@"userBowlingBallName"]];
    }
    //    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FrameNumber" ascending:YES];
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"FrameNumber" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:aSortDescriptor];
    NSArray *sortedArray = [mainView.userStatsDataArray sortedArrayUsingDescriptors:sortDescriptors];
    mainView.userStatsDataArray=[NSMutableArray arrayWithArray:sortedArray];
    
    if (mainView.userStatsDataArray.count!=0) {
        for(int i=1;i<13;i++)
        {
            if(i-1 < mainView.userStatsDataArray.count)
            {
                if([[[mainView.userStatsDataArray objectAtIndex:i-1] objectForKey:@"FrameNumber"] integerValue] == i)
                {
                    ballName=[NSString stringWithFormat:@"%@",[[mainView.userStatsDataArray objectAtIndex:i-1] objectForKey:@"BallName"]];
                }
                else
                {
                    //                    if(i > 1)
                    //                        ballName=@"Select Ball";
                    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
                    [temp setObject:[NSString stringWithFormat:@"%d",0] forKey:@"PocketBrooklyn"];
                    [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"FrameNumber"];
                    [temp setObject:ballName forKey:@"BallName"];
                    [mainView.userStatsDataArray insertObject:temp atIndex:i-1];
                    
                }
            }
            else
            {
                //                if(i > 1)
                //                    ballName=@"Select Ball";
                NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
                [temp setObject:[NSString stringWithFormat:@"%d",0] forKey:@"PocketBrooklyn"];
                [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"FrameNumber"];
                [temp setObject:ballName forKey:@"BallName"];
                [mainView.userStatsDataArray addObject:temp];
            }
            
        }
    }
    else
    {
        for(int i=1;i<13;i++)
        {
            //            if(i > 1)
            //                ballName=@"Select Ball";
            NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
            [temp setObject:[NSString stringWithFormat:@"%d",0] forKey:@"PocketBrooklyn"];
            [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"FrameNumber"];
            [temp setObject:ballName forKey:@"BallName"];
            [mainView.userStatsDataArray addObject:temp];
        }
    }
    NSLog(@"arr=%@",mainView.userStatsDataArray);
}

//Update ball type and pocket/brooklyn for a particular frame
-(void)ballTypeServerCall:(int)selectedFrame
{
    //    @try {
    NSLog(@"balltype server call for frame=%d",selectedFrame);
//    NSLog(@"array before=%@",mainView.userStatsDataArray);
    NSString *pocketBrooklyn;
    if(mainView.userStatsDataArray.count == 1)
    {
        //set selected ball index
        NSString *ballNameString=[NSString stringWithFormat:@"%@",[[mainView.userStatsDataArray objectAtIndex:0] objectForKey:@"BallName"]];
        for(int i=0;i<ballTypeArray.count;i++)
        {
            if([[[ballTypeArray objectAtIndex:i] objectForKey:@"userBowlingBallName"] isEqualToString:ballNameString])
            {
                selectedBallTypeIndex=i;
            }
        }
        if([[[mainView.userStatsDataArray objectAtIndex:0] objectForKey:@"FrameNumber"] integerValue] == selectedFrame)
        {
            if([[[mainView.userStatsDataArray objectAtIndex:0] objectForKey:@"PocketBrooklyn"] integerValue] == 2)
            {
                pocketBrooklyn = @"2";
            }
            else if ([[[mainView.userStatsDataArray objectAtIndex:0] objectForKey:@"PocketBrooklyn"] integerValue] == 0)
                pocketBrooklyn=@"0";
            else
                pocketBrooklyn = @"1";
        }
    }
    else
    {
        for(int i =0;i<mainView.userStatsDataArray.count;i++)
        {
            //set selected ball index
            if([[[mainView.userStatsDataArray objectAtIndex:i] objectForKey:@"FrameNumber"] integerValue] == selectedFrame)
            {
                NSString *ballNameString=[NSString stringWithFormat:@"%@",[[mainView.userStatsDataArray objectAtIndex:i] objectForKey:@"BallName"]];
                for(int j=0;j<ballTypeArray.count;j++)
                {
                    if([[[ballTypeArray objectAtIndex:j] objectForKey:@"userBowlingBallName"] isEqualToString:ballNameString])
                    {
                        selectedBallTypeIndex=j;
                    }
                }
                
                if([[[mainView.userStatsDataArray objectAtIndex:i] objectForKey:@"PocketBrooklyn"] integerValue] == 2)
                {
                    pocketBrooklyn = @"2";
                }
                else if ([[[mainView.userStatsDataArray objectAtIndex:i] objectForKey:@"PocketBrooklyn"] integerValue] == 0)
                    pocketBrooklyn=@"0";
                else
                    pocketBrooklyn = @"1";
            }
        }
    }
    
    NSString *ballType;
    if(ballTypeArray.count>0 && [ballTypeArray objectAtIndex:selectedBallTypeIndex] && [[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean])
        ballType=[NSString stringWithFormat:@"%@",[[ballTypeArray objectAtIndex:selectedBallTypeIndex] objectForKey:@"id"]];
    else
        ballType=@"0";
    
    if(pocketBrooklyn.length == 0)
        pocketBrooklyn=@"0";
    
    
    
    if(pocketBrooklyn.length > 0)
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSMutableArray *pocketPostArray=[NSMutableArray new];
        NSDictionary *frameDict;
        if(selectedFrame == 10)
        {
            for(int i=selectedFrame;i<=noOfFrames;i++)
            {
                
                if([[[mainView.userStatsDataArray objectAtIndex:i-1] objectForKey:@"FrameNumber"] integerValue] == i)
                {
                    if([[[mainView.userStatsDataArray objectAtIndex:i-1] objectForKey:@"PocketBrooklyn"] integerValue] == 2)
                    {
                        pocketBrooklyn = @"2";
                    }
                    else if ([[[mainView.userStatsDataArray objectAtIndex:i-1] objectForKey:@"PocketBrooklyn"] integerValue] == 0)
                        pocketBrooklyn=@"0";
                    else
                        pocketBrooklyn = @"1";
                }
                if(pocketBrooklyn.length == 0)
                    pocketBrooklyn=@"0";
                frameDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i], @"FrameNo",ballType,@"BowlingBallNameId",pocketBrooklyn,@"isBrooklynOrPocket", nil];
                [pocketPostArray addObject:frameDict];
            }
        }
        else
        {
            frameDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedFrame], @"FrameNo",ballType,@"BowlingBallNameId",pocketBrooklyn,@"isBrooklynOrPocket", nil];
            [pocketPostArray addObject:frameDict];
        }
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[userDefaults objectForKey:kbowlingGameId], @"BowlingGameId",pocketPostArray, @"BowlingThrowUserStatDataList",nil];
        NSLog(@"postDict of ballType=%@",postDict);
        
        //             NSDictionary *json = [[ServerCalls instance] serverCallWithPostParameters:postDict url:@"UserStat/CreateBowlingThrowUserStat" contentType:@"application/json" httpMethod:@"POST"];
        NSError *error = NULL;
        NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString* dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%d",(int)[postdata length]];
        
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString ;
        
        urlString = [NSString stringWithFormat:@"%@UserStat/CreateBowlingThrowUserStat?apiKey=%@&token=%@", serverAddress, APIKey, token];
        NSLog(@"url string of ballType %@", urlString);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:kTimeoutInterval];
        [request setHTTPMethod: @"POST"];
        [request setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postdata];
        
        //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        //AsynchronousRequest to grab the data
        NSOperationQueue *ballTypeQueue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:ballTypeQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             //                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
//             [self bowlingGameViewCall];
             NSString *responseString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             //        NSLog(@"responseString = %@",responseString);
             [[DataManager shared]removeActivityIndicator];
             NSLog(@"response of Ball Type Server call=%@",responseString);

         }];
    }
    [self updateBallName];
    NSLog(@"array=%@",mainView.userStatsDataArray);
    
}

- (void)updateBallNameForNextThrow
{
    [self updateBallName];
}
-(void)updateBallName
{
    @try {
        NSLog(@"ball type %d",mainView.currentFrame);
        if(ballTypeArray.count > 0 && (mainView.userStatsDataArray.count > 0))
        {
            for(int j=0;j<[mainView.userStatsDataArray count];j++)
            {
                if([[[mainView.userStatsDataArray objectAtIndex:j] objectForKey:@"FrameNumber"] integerValue] == mainView.currentFrame)
                {
                    if([[NSString stringWithFormat:@"%@",[[mainView.userStatsDataArray objectAtIndex:j] objectForKey:@"BallName"]] isEqualToString:@"Select Ball"])
                    {
                        NSMutableDictionary *temp=[mainView.userStatsDataArray objectAtIndex:j];
                        @try {
                            [temp setObject:[NSString stringWithFormat:@"%ld",(long)[[[mainView.userStatsDataArray objectAtIndex:j]objectForKey:@"PocketBrooklyn"] integerValue]] forKey:@"PocketBrooklyn"];
                            [temp setObject:[NSString stringWithFormat:@"%d",j+1] forKey:@"FrameNumber"];
                            [temp setObject:[NSString stringWithFormat:@"%@",[[mainView.userStatsDataArray objectAtIndex:j-1] objectForKey:@"BallName"]] forKey:@"BallName"];
                            [mainView.userStatsDataArray replaceObjectAtIndex:j withObject:temp];
                            break;
                        }
                        @catch (NSException *exception) {
                            
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ball type exception in update %d",mainView.currentFrame);
    }
}

//Get list of all the ball names added by user
-(void)getBallTypeServerCall
{
    ballTypeArray =[NSArray new];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/BowlingBallNamesList" contentType:@"" httpMethod:@"GET"];
    NSArray *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        ballTypeArray =[NSArray arrayWithArray:response];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        //        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userBowlingBallName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray *sortedArray = [ballTypeArray sortedArrayUsingDescriptors:sortDescriptors];
    ballTypeArray=[NSArray arrayWithArray:sortedArray];
    [mainView setBallTypeArray:ballTypeArray];
    NSString *ballNameString;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName]) {
        ballNameString=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName] objectForKey:@"userBowlingBallName"]];
    }
    for(int i=0;i<ballTypeArray.count;i++)
    {
        if([[[ballTypeArray objectAtIndex:i] objectForKey:@"userBowlingBallName"] isEqualToString:ballNameString])
        {
            selectedBallTypeIndex=i;
        }
    }
    
}

- (void)pocketBrooklynFunction:(UIButton *)sender
{
    @try {
        if (mainView.userStatsDataArray.count!=0)
        {
            //        for(int i=0;i<userStatsDataArray.count;i++)
            //        {
            if(mainView.currentFrame == 10)
            {
                NSMutableDictionary *temp=[mainView.userStatsDataArray objectAtIndex:tenthFrameCount-1];
                if([[temp objectForKey:@"FrameNumber"] integerValue] == tenthFrameCount)
                {
                    if(sender.tag == 13000)     //Pocket
                        [temp setObject:[NSString stringWithFormat:@"%d",2] forKey:@"PocketBrooklyn"];
                    else if(sender.tag == 13001)
                        [temp setObject:[NSString stringWithFormat:@"%d",1] forKey:@"PocketBrooklyn"];
                    else
                        [temp setObject:[NSString stringWithFormat:@"%d",0] forKey:@"PocketBrooklyn"];
                    [mainView.userStatsDataArray replaceObjectAtIndex:tenthFrameCount-1 withObject:temp];
                }
            }
            else
            {
                NSMutableDictionary *temp=[mainView.userStatsDataArray objectAtIndex:mainView.currentFrame-1];
                if([[temp objectForKey:@"FrameNumber"] integerValue] == mainView.currentFrame)
                {
                    if(sender.tag == 13000)         //Pocket
                        [temp setObject:[NSString stringWithFormat:@"%d",2] forKey:@"PocketBrooklyn"];
                    else if(sender.tag == 13001)
                        [temp setObject:[NSString stringWithFormat:@"%d",1] forKey:@"PocketBrooklyn"];
                    else
                        [temp setObject:[NSString stringWithFormat:@"%d",0] forKey:@"PocketBrooklyn"];
                    [mainView.userStatsDataArray replaceObjectAtIndex:mainView.currentFrame-1 withObject:temp];
                }
                
            }
            //        }
        }
        else
        {
            NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
            if(sender.tag == 13000)
                [temp setObject:[NSString stringWithFormat:@"%d",2] forKey:@"PocketBrooklyn"];
            else
                [temp setObject:[NSString stringWithFormat:@"%d",1] forKey:@"PocketBrooklyn"];
            
            [temp setObject:[NSString stringWithFormat:@"%d",mainView.currentFrame] forKey:@"FrameNumber"];
            if(ballTypeArray.count > 0 && [[ballTypeArray objectAtIndex:selectedBallTypeIndex] objectForKey:@"userBowlingBallName"])
                [temp setObject:[NSString stringWithFormat:@"%@",[[ballTypeArray objectAtIndex:selectedBallTypeIndex]  objectForKey:@"userBowlingBallName"]] forKey:@"BallName"];
            else
                [temp setObject:@"Select Ball" forKey:@"BallName"];
            [mainView.userStatsDataArray addObject:temp];
        }
        
        NSLog(@" mainView.currentFrame=%d Array=%@",mainView.currentFrame,mainView.userStatsDataArray);

    }
    @catch (NSException *exception) {
        
    }
}

//ballNameButtonFunction from XBowling 3.0
- (void)managePocketBrooklynForIndividualThrows:(int)throw
{
    if( mainView.currentFrame== 10)
    {
        if(mainView.ballsDependencyState == 1)
        {
            noOfFrames=12;
            if(throw == 1)
            {
                tenthFrameCount=10;
            }
            else if(throw == 2)
            {
                tenthFrameCount=11;
            }
            else
            {
                tenthFrameCount=12;
            }
        }
        else if (mainView.ballsDependencyState == 2)
        {
            noOfFrames=11;
            if(throw == 1)
            {
                tenthFrameCount=10;
            }
            else if(throw == 2)
            {
                tenthFrameCount=10;
            }
            else
            {
                tenthFrameCount=11;
            }
        }
        else if(mainView.ballsDependencyState == 3)
        {
            
            noOfFrames=11;
            if(throw == 1)
            {
                tenthFrameCount=10;
            }
            else if(throw == 2)
            {
                tenthFrameCount=11;
            }
            else
            {
                tenthFrameCount=11;
            }
            
        }
        else
        {
            noOfFrames=10;
            if(throw == 1)
            {
                tenthFrameCount=10;
            }
            else if(throw == 2)
            {
                tenthFrameCount=10;
            }
        }
        @try {
            if(mainView.userStatsDataArray.count > 0)
            {
                if([[[mainView.userStatsDataArray objectAtIndex:tenthFrameCount-1] objectForKey:@"PocketBrooklyn"] integerValue] == 2)
                {
                    //set selected pocket/brooklyn btn
                    
                }
                else if([[[mainView.userStatsDataArray objectAtIndex:tenthFrameCount-1] objectForKey:@"PocketBrooklyn"] integerValue] == 0)
                {
                    
                }
                else
                {
                    
                }
            }
            
        }
        @catch (NSException *exception) {
        }
    }
    [mainView tenthFrameCountValue:tenthFrameCount];
}

#pragma mark - Ball type Selection
- (void)ballTypeSelectionFunction
{
    if (ballTypeArray.count > 0) {
        NSString *titleString;
        titleString = @"Bowling Ball";
        CGRect pickerFrame = CGRectMake(0, 30, 0, 100);
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        pickerView.backgroundColor=[UIColor whiteColor];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        actionSheet.customActionSheetDelegate = self;
        [self.view addSubview:actionSheet];
        [actionSheet updateTitleLabel:titleString];
        NSLog(@"actionView=%@",actionSheet.actionSheet);
        NSLog(@"actionSheet");
        [actionSheet showPicker];
        actionSheet.tag = 200;
        pickerView.tag = 200;
        @try {
            if (mainView.userStatsDataArray.count > 0) {
                for(int i=0;i<ballTypeArray.count;i++)
                {
                    if([[[ballTypeArray objectAtIndex:i] objectForKey:@"userBowlingBallName"] isEqualToString:[[mainView.userStatsDataArray objectAtIndex:mainView.currentFrame - 1] objectForKey:@"BallName"]])
                    {
                        selectedBallTypeIndex=i;
                    }
                }
            }
        }
        @catch (NSException *exception) {
            selectedBallTypeIndex=0;
        }
        
        [pickerView selectRow:selectedBallTypeIndex inComponent:0 animated:NO];
        [actionSheet.actionSheet addSubview:pickerView];
    }
}

- (void)dismissActionSheet
{
    [mainView displayBallName:[NSString stringWithFormat:@"%@",[[ballTypeArray objectAtIndex:selectedBallTypeIndex] objectForKey:@"userBowlingBallName"]]];
    [[NSUserDefaults standardUserDefaults]setInteger:selectedBallTypeIndex forKey:kBallType];
    if ( mainView.userStatsDataArray.count!=0) {
        for(int i=0;i< mainView.userStatsDataArray.count;i++)
        {
            NSMutableDictionary *temp=[ mainView.userStatsDataArray objectAtIndex:i];
            if([[temp objectForKey:@"FrameNumber"] integerValue] ==  mainView.currentFrame)
            {
                [temp setObject:[NSString stringWithFormat:@"%@",[[ballTypeArray objectAtIndex:selectedBallTypeIndex] objectForKey:@"userBowlingBallName"]] forKey:@"BallName"];
                [ mainView.userStatsDataArray replaceObjectAtIndex:i withObject:temp];
            }
        }
    }
    else {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
        [temp setObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[ballTypeArray objectAtIndex:selectedBallTypeIndex] objectForKey:@"userBowlingBallName"]]] forKey:@"BallName"];
        [temp setObject:[NSString stringWithFormat:@"%d", mainView.currentFrame] forKey:@"FrameNumber"];
        [mainView.userStatsDataArray addObject:temp];
    }
}

#pragma mark - UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ballTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[ballTypeArray objectAtIndex:row] objectForKey:@"userBowlingBallName"];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedBallTypeIndex = (int)row;
}

#pragma mark - Bowling View Delegate
- (void)showChallengeView
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kh2hViewFlow];
     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    //        [[UIDevice currentDevice] setValue:
    //         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
    //                                    forKey:@"orientation"];
    [self supportedInterfaceOrientations:NO];

    ChallengesViewController *challengeView=[[ChallengesViewController alloc]init];
    [challengeView createMainView];
    [self.navigationController pushViewController:challengeView animated:YES];
}

- (void)showFrameView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kshowOpponentsForH2HPosted];
    [self supportedInterfaceOrientations:NO];

    superViewOfFrameView=@"MyGame";
     NSLog(@"subviews=%@",self.view.subviews);
//    if ([frameView isDescendantOfView:self.view]) {
//        frameView.hidden=NO;
//        [self.view bringSubviewToFront:frameView];
//    }
//    else{
        if ([enteredChallenge isEqualToString:@"H2HLive"] ) {
            frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            frameView.delegate=self;
            [frameView createFrameViewforChallenge:enteredChallenge numberOfPlayers:1];
            [self.view addSubview:frameView];
            if ([h2hLiveTimer isValid]) {
                [h2hLiveTimer invalidate];
                h2hLiveTimer=nil;
            }
            h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateH2HLive) userInfo:nil repeats:YES];

        }
        else if([enteredChallenge isEqualToString:@"H2HPosted"]){
            
            /*For New Flow*/
            challengeVC=[[ChallengesViewController alloc]init];
            BOOL inNavigationStack = false;
            for(UIViewController *controller in self.navigationController.viewControllers)
            {
                NSLog(@"%@", controller);
                if ([controller isKindOfClass:[challengeVC class]]) {
                    inNavigationStack=YES;
                    break;
                } else {
                    inNavigationStack=NO;
                }
            }
            if (inNavigationStack) {
                [self.navigationController popViewControllerAnimated:YES];

            }
            else{
                [self.navigationController pushViewController:challengeVC animated:YES];
            }
            
//            frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            frameView.delegate=self;
//            [frameView createFrameViewforChallenge:enteredChallenge numberOfPlayers:2];
//            [self.view addSubview:frameView];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            [self supportedInterfaceOrientations:NO];
            if (challengeVC == nil) {
                challengeVC=[[ChallengesViewController alloc]init];
            }
            NSString *challenge=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kcurrentChallenge]];
            if ([challenge isEqualToString:@"H2HLive"] ) {
//                [challengeVC showH2HLiveView];
                frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                frameView.delegate=self;
                [frameView createFrameViewforChallenge:challenge numberOfPlayers:1];
                [self.view addSubview:frameView];
                if ([h2hLiveTimer isValid]) {
                    [h2hLiveTimer invalidate];
                    h2hLiveTimer=nil;
                }
                h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateH2HLive) userInfo:nil repeats:YES];
            }
            else{
                /*New Flow 11/6*/
                if ([challenge isEqualToString:@"H2HPosted"]) {
                    BOOL inNavigationStack = false;
                    for(UIViewController *controller in self.navigationController.viewControllers)
                    {
                        NSLog(@"%@", controller);
                        if ([controller isKindOfClass:[challengeVC class]]) {
                            inNavigationStack=YES;
                            break;
                        } else {
                            inNavigationStack=NO;
                        }
                    }
                    if (inNavigationStack) {
                         [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [self.navigationController pushViewController:challengeVC animated:YES];
                    }
                   
                }
                else{
                    [frameView removeFromSuperview];
                    frameView=nil;
                    frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    frameView.delegate=self;
                    [frameView createFrameViewforChallenge:challenge numberOfPlayers:1];
                    [self.view addSubview:frameView];

                }
                [[DataManager shared]removeActivityIndicator];
                /*Actual*/
//                [frameView removeFromSuperview];
//                frameView=nil;
//                frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                frameView.delegate=self;
//                [frameView createFrameViewforChallenge:challenge numberOfPlayers:1];
//                [self.view addSubview:frameView];
            }
        }
    
//    }
}

- (void)updateTagForPostedGame:(NSString *)tags
{
    saveTags=tags;
    [self updateEdittedTags:tags];
}
#pragma mark - Score Post
- (void)postOnFacebook
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/scn-strike-first/id1060911495?l=zh&ls=1&mt=8"];
    content.contentDescription=[NSString stringWithFormat:@"I just bowled a %@ at %@ using the SCN Strike First app! You should download SCN Strike First so we can compete against each other while we bowl!",[[NSUserDefaults standardUserDefaults]valueForKey:kFinalScore],[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
    content.contentTitle=@"Bowl. Have Fun. Win Prizes.";
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
    NSLog(@"%@",sharer);
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

#pragma mark - Challenge Frame View Delegate Methods
- (void)updateFramesforChallenge:(NSString *)challengeType
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
    if ([challengeType isEqualToString:@"H2HPosted"]) {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateGameViewForChallenge];
        });
    }
    else{
        //h2h Live
        [self updateH2HLive];
    }
}

- (void)showMyGame
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
    [self supportedInterfaceOrientations:YES];
    [self performSelector:@selector(backToMyGame) withObject:nil afterDelay:0.2];
}

- (void)showAddOpponentView
{
     NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
    ChallengesViewController *challengeView=[[ChallengesViewController alloc]init];
    [challengeView addMoreOpponents];
    [self.navigationController pushViewController:challengeView animated:NO];
     NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
}

- (void)backToMyGame
{
    scorePanelSetupRequired=YES;
    NSLog(@"subviews=%@",self.view.subviews);
    if ([mainView isDescendantOfView:self.view]) {
        [self.view bringSubviewToFront:mainView];
    }
    else{
            [self createGameViewforCategory:@"MyGame"];
    }
    frameView.hidden=YES;
    mainView.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    [self addDefaultTags];
}

- (void)addDefaultTags
{
    NSString *tagToBeSaved;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HLive]) {
        tagToBeSaved=@"H2H Live";
        saveTags=@"H2H Live";
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HPosted]) {
        tagToBeSaved=@"H2H Posted";
        saveTags=@"H2H Posted";
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HLive] && [[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HPosted]) {
        tagToBeSaved=@"both";
    }
    NSLog(@"savedTags=%@",[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]);
    NSArray *savedTagsArray=[[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]];
    if ([tagToBeSaved isEqualToString:@"both"]) {
        if (![savedTagsArray containsObject:@"H2H Live"] && ![savedTagsArray containsObject:@"H2H Posted"]) {
            saveTags=@"H2H Live,H2H Posted";
            [[DataManager shared]activityIndicatorAnimate:@"Saving Tags..."];
            if (savedTagsArray.count > 0) {
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@",%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            else{
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@"%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            [self updateEdittedTags:saveTags];
            
        }
        else if (![savedTagsArray containsObject:@"H2H Live"])
        {
            saveTags=@"H2H Live";
            [[DataManager shared]activityIndicatorAnimate:@"Saving Tags..."];
            if (savedTagsArray.count > 0) {
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@",%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            else{
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@"%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            [self updateEdittedTags:saveTags];
            
        }
        else if (![savedTagsArray containsObject:@"H2H Posted"])
        {
            saveTags=@"H2H Posted";
            [[DataManager shared]activityIndicatorAnimate:@"Saving Tags..."];
            if (savedTagsArray.count > 0) {
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@",%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            else{
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@"%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            [self updateEdittedTags:saveTags];
            
        }
        
    }
    else{
        if (![savedTagsArray containsObject:saveTags]) {
            [[DataManager shared]activityIndicatorAnimate:@"Saving Tags..."];
            if (savedTagsArray.count > 0) {
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@",%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            else{
                saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@"%@",[savedTagsArray componentsJoinedByString:@","]]];
            }
            [self updateEdittedTags:saveTags];
        }
    }
}

-(void)updateEdittedTags :(NSString *)tagsEditted
{
    NSString * editString = [tagsEditted stringByAddingPercentEscapesUsingEncoding:
                             NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"Tags/UpdateAllTags"];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"GameId=%@&Tags=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId],editString] url:urlString contentType:@"" httpMethod:@"POST"];
    NSLog(@"response code=%@",json);
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"]) {
        [[DataManager shared]removeActivityIndicator];
        NSLog(@"array=:%@",[saveTags componentsSeparatedByString:@","]);
        if([saveTags  length]>0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[saveTags componentsSeparatedByString:@","] forKey:ksavingGameTags];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:[NSArray new] forKey:ksavingGameTags];
            
        }
        [gameMenu reloadRightMenu:0];
    }
    else{
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView5 show];
    }
}


#pragma mark - Frame View Delegate
- (void)removeFrameView
{
     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:YES];

    if ([h2hLiveTimer isValid]) {
        [h2hLiveTimer invalidate];
        h2hLiveTimer=nil;
    }
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kh2hViewFlow];
//    if ([superViewOfFrameView isEqualToString:@"Challenges"]) {
        [self performSelector:@selector(hideFrameView) withObject:nil afterDelay:0.02];
    
//    }
//    else{
//        [frameView removeFromSuperview];
//    }
    if ([enteredChallenge length] == 0) {
        ChallengesViewController *challengeView=[[ChallengesViewController alloc]init];
        [challengeView createMainView];
        [self.navigationController pushViewController:challengeView animated:NO];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)hideFrameView
{
    [frameView removeFromSuperview];
    frameView=nil;
}
- (void)updateGameViewForChallenge
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *json;
        NSLog(@"called");
        mainView.standingPinsMutableArray = [[NSMutableArray alloc] init];
        NSString *url ;
        NSString *urlString;
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
            url = [NSString stringWithFormat:@"manuallanecheckout/%@/bowlinggameviewnew", [userDefaults objectForKey:klaneCheckOutId]];
        }
        else{
            url = [NSString stringWithFormat:@"lanecheckout/%@/bowlinggameview", [userDefaults objectForKey:klaneCheckOutId]];
        }
        urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,url,token,APIKey];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:@"GET"];
        NSError *error;
        NSHTTPURLResponse *urlResponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&urlResponse error:&error];
        NSLog(@"status=%ld",(long)[urlResponse statusCode]);
        if (data){
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"response %@",json);
            if([urlResponse statusCode] == 200 || [urlResponse statusCode] == 201){
                dispatch_async( dispatch_get_main_queue(), ^{
                    @try {
                        if ([json isKindOfClass:[NSDictionary class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"bowlingGame"] objectForKey:@"name"] forKey:kbowlerName];
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                    [[DataManager shared]removeActivityIndicator];
                    [frameView updateViewofPlayer:1 scoreDict:json forChallenge:@"H2HPosted" arrayForLiveChallenge:nil];
                    [self updateOpponentsView];
                });
            }
            else{
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared]removeActivityIndicator];
                });
            }
        }
        else{
            dispatch_async( dispatch_get_main_queue(), ^{
                [[DataManager shared]removeActivityIndicator];
            });
        }
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
            [[DataManager shared]removeActivityIndicator];
        });
    }
}

- (void)updateH2HLive
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"called");
        mainView.standingPinsMutableArray = [[NSMutableArray alloc] init];
        NSString *urlString;
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        urlString = [NSString stringWithFormat:@"%@bowlingcompetition/live/%@/challengers?apiKey=%@&token=%@", serverAddress, [userDefaults objectForKey:kliveCompetitionId], APIKey, token];
        
        
        NSLog(@"urlString %@",urlString);
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:kTimeoutInterval];
            [request setHTTPMethod: @"GET"];
            NSError *error;
            NSHTTPURLResponse *urlResponse=nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            if (data)
            {
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"h2hlive response %@",json );
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared]removeActivityIndicator];
                    if(urlResponse.statusCode == 200 || urlResponse.statusCode == 201)
                    {
                        if ([json count]>0) {
                            if(json.count  == 1)
                            {
                                NSError *error;
                                if ([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] isKindOfClass:[NSDictionary class]] ) {
                                if ([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] objectForKey:@"waitingForApproval"]) {
                                }
                                }
                                else{
                                    //                                        [userDefaults removeObjectForKey:kliveCompetitionId];
                                    [frameView updateViewofPlayer:(int)[json count] scoreDict:nil forChallenge:@"H2HLive" arrayForLiveChallenge:json];
                                }
                            }
                            else
                            {
                                NSMutableArray *liveChallengesArray=[[NSMutableArray alloc]init];
                                 for (int j= 0; j<[json count]; j++) {
                                     if ([[[json objectAtIndex:j] objectForKey:@"state"] isEqualToString:@"Pending"]) {
                                         
                                         if (([[[json objectAtIndex:0] objectForKey:@"isHost"] integerValue] == 1)) {
                                             if([h2hLiveTimer isValid])
                                             {
                                                 [h2hLiveTimer invalidate];
                                                 h2hLiveTimer=nil;
                                             }
                                             NSString *alertString = [NSString stringWithFormat:@"%@ wants to join this game",[[[json objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:@"name"]];
                                             NSLog(@"liveOpponnentId=%@",liveOpponnentId);
                                             if ([NSString stringWithFormat:@"%@",liveOpponnentId].length == 0 || [[NSString stringWithFormat:@"%@",liveOpponnentId] isEqualToString:@"(null)"] ) {
                                                 NSLog(@"Show alert");
                                                 liveOpponnentId = [[[json objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:@"bowlingGameId"];
                                                 if (!showOpponentJoinPopup) {
                                                     UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"" message:alertString delegate:self cancelButtonTitle:@"Allow" otherButtonTitles:@"Don't Allow",nil];
                                                     [alert1 setTag:195];
                                                     [alert1 show];
                                                     showOpponentJoinPopup=YES;
                                                 }
                                                
                                             }
                                             break;
                                         }
                                     }
                                     else{
                                         [liveChallengesArray addObject:[json objectAtIndex:j]];
                                     }
                                 }
                                [frameView addFrameViews:(int)[liveChallengesArray count]];
                                [frameView updateViewofPlayer:(int)[liveChallengesArray count] scoreDict:nil forChallenge:@"H2HLive" arrayForLiveChallenge:liveChallengesArray];
                               
                            }
                        }
                    }
                    else{
                        
                    }
                });
            }
        });
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    showOpponentJoinPopup=NO;
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (alertView.tag == 195){
        if(buttonIndex == 0)
        {
            [self changeState:@"Entered"];
        }
        if(buttonIndex == 1)
        {
            [self changeState:@"Rejected"];
        }
    }
}

-(void)changeState:(NSString *)state{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
        
    }
    else
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = NULL;
            NSLog(@"state %@",state);
            NSString* dataString = [NSString stringWithFormat:@"state=%@",state];;
            //dataString = [dataString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"dict=%@",dataString);
            NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
            NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
            [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
            [URLrequest setTimeoutInterval:kTimeoutInterval];
            NSString *token = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:kUserAccessToken]];
            token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *urlString = [NSString stringWithFormat:@"%@bowlingcompetition/live/%@/game/%@/state?apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kliveCompetitionId], liveOpponnentId, APIKey, token];
            [URLrequest setURL:[NSURL URLWithString:urlString]];
            NSLog(@"requestURL=%@", urlString);
            [URLrequest setHTTPMethod:@"POST"];
            [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
            [URLrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [URLrequest setHTTPBody:postdata];
            NSError *error1=nil;
            NSHTTPURLResponse *response=nil;
            NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
//            if (responseData) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                NSLog(@"json=%@, response code",json);
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                    [self updateH2HLive];
                    if ([h2hLiveTimer isValid]) {
                        [h2hLiveTimer invalidate];
                        h2hLiveTimer=nil;
                    }
                    h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateH2HLive) userInfo:nil repeats:YES];
                    
                });
//            }
//            else{
//                dispatch_async( dispatch_get_main_queue(), ^{
//                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
//                });
//            }
            
        });
    }
    
}

#pragma mark - Update view of opponent
- (void)updateOpponentsView
{
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"urlStringForChallengers %@",urlStringForChallengers);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStringForChallengers]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:kTimeoutInterval];
        [request setHTTPMethod: @"GET"];
        NSError *error;
        NSURLResponse *urlResponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"response %@",json);
            if(json)
            {
//                dispatch_async( dispatch_get_main_queue(), ^{
                    NSLog(@"json");
                    NSDictionary *scoreDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"bowlingGame", nil];
                    [frameView updateViewofPlayer:2 scoreDict:scoreDict forChallenge:@"H2HPosted" arrayForLiveChallenge:nil];
                    [[DataManager shared]removeActivityIndicator];
                    if ([[ [NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]) {
                        [self performSelector:@selector(updateGameViewForChallenge) withObject:nil afterDelay:20.0];
                    }
                }
//                });
        }
//    });
}

#pragma mark - Orientation Change Functions
// Custom function for orientation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //update your view's subviews
    NSLog(@"orientation=%ld",(long)toInterfaceOrientation);
    [self UIChangesForOrientationChange];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)UIChangesForOrientationChange{
    NSLog(@"height=%f",[[UIScreen mainScreen] bounds].size.height);
    mainView.frame=CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        [self removeMainMenu];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
         [mainView updateViewForOrientationChange];
    }
    else if (deviceOrientation == UIDeviceOrientationPortrait)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
        [mainView updateViewForOrientationChange];
    }
}


- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showBowlingView"]) {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationMaskAll]
                                    forKey:@"orientation"];
        return UIInterfaceOrientationMaskAll;
    }
    else{
        isCampusLandscape = [[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"];
        if(isCampusLandscape)
        {
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationMaskLandscape]
                                        forKey:@"orientation"];
//            objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
            return UIInterfaceOrientationMaskLandscape;
        }
        else
        {
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                        forKey:@"orientation"];
            //        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
            return UIInterfaceOrientationMaskPortrait;
        }
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

- (void)orientationChanged:(NSNotification *)notification
{
    
}

#pragma mark - Coach View Functions
- (void)coachview
{
    CoachViewController *coachObject=[[CoachViewController alloc]init];
    [coachObject liveScoreVenueID:[[liveScorePlayerDictionary objectForKey:@"venueID"]intValue] laneNumber:[[liveScorePlayerDictionary objectForKey:@"laneID"] intValue]];
    [self.navigationController pushViewController:coachObject animated:YES];
}

- (void)showCoachView
{
    [mainView.timerforMyGameUpdateView invalidate];
    mainView.timerforMyGameUpdateView=nil;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [self supportedInterfaceOrientations:YES];
    [self performSelector:@selector(coachview) withObject:nil afterDelay:0.2];
}

- (void)removeMainMenu
{
    leftMenu.hidden=YES;
    gameMenu.hidden=YES;
}
#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
//        [self supportedInterfaceOrientations:NO];
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
//        [[NSUserDefaults standardUserDefaults]setBool:previousStateOfBowlingViewBool forKey:@"showBowlingView"];
//        if ([enteredCategory isEqualToString:@"MyGame"]) {
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
//        }
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showBowlingView"]) {
//             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
//            [self supportedInterfaceOrientations:YES];
//        }
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

#pragma mark - Right Menu
- (void)showGameMenu
{
    if([gameMenu isHidden] == YES)
    {
        gameMenu.hidden=NO;
        [self.view bringSubviewToFront:gameMenu];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            mainView.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, mainView.frame.size.width, mainView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], mainView.frame.size.width, mainView.frame.size.height)];
            mainScreenCoverView.tag=20011;
            mainScreenCoverView.userInteractionEnabled=YES;
            [self.view addSubview:mainScreenCoverView];
            
        }];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            gameMenu.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:192/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
            gameMenu.layer.zPosition=1.0;

        } completion:nil];
        
    }
    else{

        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished){
        }];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            gameMenu.frame = CGRectMake(self.view.frame.size.width, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:^(BOOL finished){
            gameMenu.hidden=YES;
            [self.view bringSubviewToFront:mainView];
            UIView *screenCover=(UIView *)[self.view viewWithTag:20011];
            [screenCover removeFromSuperview];
            screenCover=nil;
        }];
    }

}

- (void)dismissRightMenu
{
    [self showGameMenu];
}

- (void)gameMenuQuitGameFunction
{
     [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self dismissRightMenu];
    [self endGame];
}

- (void)gameMenuSummaryFunction
{
    [self dismissRightMenu];
//    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self showGameSummary];
}

- (void)gameMenuLeaderboardFunction
{
    [self dismissRightMenu];
    [self showLeaderboard:1];
}

- (void)fastScoreEntryMode:(int)showOrHide
{
     [self dismissRightMenu];
    [mainView fastScoreEntryModeView:showOrHide];
}

#pragma mark - Leaderboard Function
- (void)showLeaderboard:(int)leaderboardType
{
    LeaderboardViewController *leaderboardVC=[[LeaderboardViewController alloc]initWithLeaderboardType:leaderboardType viaSection:@"bowling"];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch= [touches anyObject];
    NSLog(@"view=%@",[touch view]);
    NSLog(@"%f %f %f %f",self.view.superview.frame.origin.x,self.view.superview.frame.origin.y,self.view.superview.frame.size.width,self.view.superview.frame.size.height);
}

#pragma mark - Show Game Tags & Update

-(void)showGameTagsUpdate:(NSString *)bowlingGameId {
    
    TagsController *tagObject=[[TagsController alloc]init];
    tagObject.gameId=bowlingGameId;
    [self.navigationController pushViewController:tagObject animated:YES];
}

-(void)fetchUpdatedTagList
{
    apinumber=0;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:ksavingGameTags];
//    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
//    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSString *enquiryUrl=[NSString stringWithFormat:@"%@",@"Tags/TagList"];
      NSString *queryParams=[NSString stringWithFormat:@"GameId=%@&",[[NSUserDefaults standardUserDefaults]objectForKey:kbowlingGameId]];
    NSDictionary *response = [[ServerCalls instance] serverCallWithQueryParameters:queryParams url:enquiryUrl contentType:@"" httpMethod:@"GET"];
    NSLog(@"responseDict=%@",response);
    @try {
        if ([[response objectForKey:kResponseStatusCode] integerValue] == 200 || [[response objectForKey:kResponseStatusCode] integerValue] == 201) {
            NSArray* tagsDetail=[response objectForKey:kResponseString];
            NSMutableArray *tagsStrings=[[NSMutableArray alloc]init];
            for(int i=0;i<tagsDetail.count;i++)
            {
                [tagsStrings addObject:[[tagsDetail objectAtIndex:i]objectForKey:@"tag"]];
            }
            [[NSUserDefaults standardUserDefaults]setObject:tagsStrings forKey:ksavingGameTags];
            [[DataManager shared]removeActivityIndicator];
        }

    }
    @catch (NSException *exception) {
        [[NSUserDefaults standardUserDefaults]setObject:[[NSArray alloc] init] forKey:ksavingGameTags];
    }
   
  //    callInstance=[ServerCalls instance];
//    callInstance.serverCallDelegate=self;
//    
//    NSDictionary *TAGInfo =[callInstance afnetWorkingGetServerCall:urlHit isAPIkeyToken:NO];
//    NSLog(@"tagsInfo :%@",TAGInfo);
}

#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)notificationInfo
{
    if(apinumber==0)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            
            NSArray* tagsDetail=(NSArray  *)[notificationInfo objectForKey:responseDataDic];
            
            NSMutableArray *tagsStrings=[[NSMutableArray alloc]init];
            for(int i=0;i<tagsDetail.count;i++)
            {
                [tagsStrings addObject:[[tagsDetail objectAtIndex:i]objectForKey:@"tag"]];
            }
            [[NSUserDefaults standardUserDefaults]setObject:tagsStrings forKey:ksavingGameTags];
            
            [gameMenu updateGametags];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
    else if(apinumber==1)
    {
        //Add tags
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            NSLog(@"array=:%@",[saveTags componentsSeparatedByString:@","]);
            if([saveTags  length]>0)
            {
                [[NSUserDefaults standardUserDefaults]setObject:[saveTags componentsSeparatedByString:@","] forKey:ksavingGameTags];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray new] forKey:ksavingGameTags];
                
            }
            // [self fetchUpdatedTagList];
        }
        else{
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }

    }
}

@end
