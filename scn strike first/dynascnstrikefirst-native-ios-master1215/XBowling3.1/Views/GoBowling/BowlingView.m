//
//  BowlingView.m
//  XBowling3.1
//
//  Created by Click Labs on 11/24/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "BowlingView.h"
#import "Keys.h"

@implementation BowlingView
{
    NSInteger currentPinTag;
    NSInteger currentThrow;
    int maxFramePlayed;
    dispatch_queue_t queue;
    dispatch_queue_t main;
    GameSummaryView *summaryView;
    RoundedRectButton *ballTypeButton;
    NSMutableArray *ballTypeArray;
    int tenthFrameCount;
    UICollectionView *_collectionView;
    //Main Views
    UIView *pinsBackgroundView;
    UIView *pinsBase;
    UILabel *mainScoreLabel;
    UIImageView *backgroundImage;
    UIView *headerView;
    UILabel *playerNameLabel;
    UIView *scorePanelBase;
    UIView *scorePanelBaseForLandscape;
    UIScrollView *baseForTags;
    int heightForScrollView;
    int yForScroll;
    BOOL showingGameSummary;
    BOOL viaShowFrame;
    FSEMView *scoreView;
    
}
@synthesize bowlingDelgate;
@synthesize pinFallDictionary,pinFallPreviousStateDictionary,standingPinsMutableArray,currentFrame,timerforMyGameUpdateView,userStatsDataArray,ballsDependencyState,tagsArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        pinFallDictionary=[NSMutableDictionary new];
        pinFallPreviousStateDictionary=[NSMutableDictionary new];
        for(int i=1;i<=21;i++)
        {
            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",1023] forKey:[NSString stringWithFormat:@"%d",i]];
            [pinFallPreviousStateDictionary setValue:[NSString stringWithFormat:@"%d",1023] forKey:[NSString stringWithFormat:@"%d",i]];
        }

    }
    return self;
}

- (void)createBowlingView
{
    for(UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
    self.tag=10000000;
    currentThrow=1;
    // async queue for bg work
    // main queue for updating ui on main thread
    queue = dispatch_queue_create("postScoreQueue", 0);
    main = dispatch_get_main_queue();
    
      //        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView] && !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])) {
          [backgroundImage setImage:[UIImage imageNamed:@"challenges_screen_bg.png"]];
    }
    
    headerView=[[UIView alloc]init];
    //        headerView.frame=CGRectMake(0, 0, screenBounds.size.width, 82);
    headerView.frame=CGRectMake(0, 0, screenBounds.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:screenBounds.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [self addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:12 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.tag=801;
    headerLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    sideNavigationButton.tag=802;
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];
    
    UIButton *moreButton=[[UIButton alloc]initWithFrame:CGRectMake(headerLabel.frame.size.width + headerLabel.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:155/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:32 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [moreButton setBackgroundColor:[UIColor clearColor]];
    moreButton.tag=803;
    [moreButton setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"more_on.png"] forState:UIControlStateHighlighted];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6 currentSuperviewDeviceSize:screenBounds.size.width])];
    [moreButton addTarget:self action:@selector(gameMenuFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreButton];
    
    playerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:165 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height])];
    playerNameLabel.backgroundColor=[UIColor clearColor];
    playerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kbowlerName]];
    playerNameLabel.textColor=[UIColor whiteColor];
    playerNameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:playerNameLabel];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
        playerNameLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10.6 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:140 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
        // Challenge View Button
        RoundedRectButton *challengeViewButton=(RoundedRectButton *)[self viewWithTag:10000];
        [challengeViewButton removeFromSuperview];
        challengeViewButton=[[RoundedRectButton alloc]init];
        [challengeViewButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60.0 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.center.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120.0 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        challengeViewButton.tag=10000;
        challengeViewButton.center=CGPointMake(challengeViewButton.center.x,playerNameLabel.center.y);
        [challengeViewButton addTarget:self action:@selector(frameViewFunction) forControlEvents:UIControlEventTouchUpInside];
        challengeViewButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
        //   [strikeButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 0.0f, 10.0f, 0.0f)];
        [challengeViewButton setTitle:@"H2H View" forState:UIControlStateNormal];
        [self addSubview:challengeViewButton];
    }
    
    mainScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:333 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height])];
    mainScoreLabel.backgroundColor=[UIColor clearColor];
    mainScoreLabel.text=@"";
    mainScoreLabel.textColor=[UIColor whiteColor];
    mainScoreLabel.textAlignment=NSTextAlignmentCenter;
    mainScoreLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:93/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:mainScoreLabel];
    
    [self createScorePanel];
    [self createPinView];
    
    //Enter Challenge
    UIButton *enterChallengeButton=[[UIButton alloc]init];
    enterChallengeButton.tag=15000;
    enterChallengeButton.frame=CGRectMake(0,screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height]);
    [enterChallengeButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
    [enterChallengeButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
    [enterChallengeButton addTarget:self action:@selector(showChallengeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enterChallengeButton];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, enterChallengeButton.frame.size.width, enterChallengeButton.frame.size.height)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.tag=15100;
    titleLabel.text=@"      Enter Challenges";
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
        titleLabel.text=@"      View Challenges";
    }
    titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height] ];
    [enterChallengeButton addSubview:titleLabel];
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(enterChallengeButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.tag=902;
    arrow.center=CGPointMake(arrow.center.x, enterChallengeButton.frame.size.height/2);
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [enterChallengeButton addSubview:arrow];
    
    //Game summary
    UIButton *gameSummaryButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:215/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1122/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    gameSummaryButton.layer.cornerRadius=gameSummaryButton.frame.size.height/2;
    gameSummaryButton.clipsToBounds=YES;
    [gameSummaryButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:gameSummaryButton.frame] forState:UIControlStateNormal];
    [gameSummaryButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:gameSummaryButton.frame] forState:UIControlStateHighlighted];
    gameSummaryButton.tag=15001;
     gameSummaryButton.hidden=YES;
    [gameSummaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gameSummaryButton setTitle:@"Game Summary" forState:UIControlStateNormal];
    [gameSummaryButton addTarget:self action:@selector(gameSummaryButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    gameSummaryButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:gameSummaryButton];
    
     if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
         [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
         [gameSummaryButton removeFromSuperview];
         [moreButton removeFromSuperview];
         [sideNavigationButton removeFromSuperview];
         [enterChallengeButton removeFromSuperview];
         RoundedRectButton *challengeViewButton=(RoundedRectButton *)[self viewWithTag:10000];
         [challengeViewButton removeFromSuperview];
         playerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kliveGameBowlerName]];
         headerLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kliveGameCenterName]];

         UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
         [backButton setBackgroundColor:[UIColor clearColor]];
         [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
         [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
         backButton.tag=8001;
         //    [backButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
         [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
         [headerView addSubview:backButton];
         
         UIButton *coachViewButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1122/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:screenBounds.size.height])];
         coachViewButton.layer.cornerRadius=coachViewButton.frame.size.height/2;
         coachViewButton.clipsToBounds=YES;
         coachViewButton.tag=8002;
         [coachViewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:coachViewButton.frame] forState:UIControlStateNormal];
         [coachViewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:coachViewButton.frame] forState:UIControlStateHighlighted];
         [coachViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [coachViewButton setTitle:@"Coach View" forState:UIControlStateNormal];
         [coachViewButton addTarget:self action:@selector(coachViewFunction:) forControlEvents:UIControlEventTouchUpInside];
         coachViewButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height]];
         [self addSubview:coachViewButton];

         
         //Start timer
         if([timerforMyGameUpdateView isValid]){
             [timerforMyGameUpdateView invalidate];
             timerforMyGameUpdateView=nil;
         }
         timerforMyGameUpdateView = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateViewforAutomatedCenter) userInfo:nil repeats:YES];
         
     }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]) {
            if([timerforMyGameUpdateView isValid]){
                [timerforMyGameUpdateView invalidate];
                timerforMyGameUpdateView=nil;
            }
            timerforMyGameUpdateView = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateViewforAutomatedCenter) userInfo:nil repeats:YES];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
        [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
        [moreButton removeFromSuperview];
        [sideNavigationButton removeFromSuperview];
        [enterChallengeButton removeFromSuperview];
        RoundedRectButton *challengeViewButton=(RoundedRectButton *)[self viewWithTag:10000];
        [challengeViewButton removeFromSuperview];
        playerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kliveGameBowlerName]];
        headerLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kliveGameCenterName]];
        playerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kuserName]];
        headerLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kHistoryGameName]];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        backButton.tag=8001;
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        //    [backButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
    }
}

- (void)updateBowlingViewForChallenges
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
        [self updateViewForOrientationChange];
    }
    else{
            [backgroundImage setImage:[UIImage imageNamed:@"challenges_screen_bg.png"]];
            playerNameLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10.6 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:140 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
            // Challenge View Button
            RoundedRectButton *challengeViewButton=(RoundedRectButton *)[self viewWithTag:10000];
            [challengeViewButton removeFromSuperview];
            challengeViewButton=[[RoundedRectButton alloc]init];
            [challengeViewButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60.0 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.center.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120.0 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
            challengeViewButton.tag=10000;
            challengeViewButton.center=CGPointMake(challengeViewButton.center.x,playerNameLabel.center.y);
            [challengeViewButton addTarget:self action:@selector(frameViewFunction) forControlEvents:UIControlEventTouchUpInside];
            challengeViewButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
            //   [strikeButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 0.0f, 10.0f, 0.0f)];
            [challengeViewButton setTitle:@"H2H View" forState:UIControlStateNormal];
            [self addSubview:challengeViewButton];
            
            UIButton *enterChallengeButton=(UIButton *)[self viewWithTag:15000];
            UILabel *titleLabel=(UILabel *)[enterChallengeButton viewWithTag:15100];
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
                titleLabel.text=@"      View Challenges";
            }
    }
    
}

- (void)frameViewFunction
{
    [bowlingDelgate showFrameView];
}

- (void)coachViewFunction:(UIButton *)sender
{
//    sender.userInteractionEnabled=NO;
//     [self performSelector:@selector(enableCoachButton:) withObject:sender afterDelay:0.2];
    [bowlingDelgate showCoachView];
}

- (void)enableCoachButton:(UIButton *)sender
{
    sender.userInteractionEnabled=YES;
}

- (void)backButtonFunction
{
    [bowlingDelgate liveScoreBackFunction];
}
- (void)sideMenuFunction:(UIButton *)sender
{
    [bowlingDelgate showMainMenu:sender];
}

- (void)gameMenuFunction
{
    [bowlingDelgate showGameMenu];
}

- (void)updateViewforAutomatedCenter{
     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
    [bowlingDelgate showSelectedFrame];
}

-(void)createScorePanel
{
    //Base for score panel
    for (UIView *view in scorePanelBase.subviews) {
        [view removeFromSuperview];
    }
    if (![scorePanelBase isDescendantOfView:self]) {
        scorePanelBase=[[UIView alloc]init];
        [scorePanelBase setBackgroundColor:[UIColor clearColor]];
        scorePanelBase.userInteractionEnabled=YES;
        [self addSubview:scorePanelBase];
        
        scorePanelBaseForLandscape=[[UIView alloc]init];
        [scorePanelBaseForLandscape setBackgroundColor:[UIColor clearColor]];
        scorePanelBaseForLandscape.userInteractionEnabled=YES;
        [self addSubview:scorePanelBaseForLandscape];
    }

    //score frames for portrait
    int xcoordinate=0;
//    NSLog(@"");
//    if (screenBounds.size.width == 320) {
        xcoordinate =[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width];
//    }
    scorePanelBase.frame= CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:142 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86 currentSuperviewDeviceSize:screenBounds.size.height]);
    for(int i=0;i<10;i++){
        ScoreFrameImageView *scoreFrame=[[ScoreFrameImageView alloc]initWithFrame:CGRectMake(xcoordinate, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:38.3 currentSuperviewDeviceSize:screenBounds.size.width], scorePanelBase.frame.size.height)];
        scoreFrame.ball1Score.userInteractionEnabled=NO;
        scoreFrame.ball2Score.userInteractionEnabled=NO;
        scoreFrame.ball3Score.userInteractionEnabled=NO;
        if(i==9){
            scoreFrame=[[ScoreFrameImageView alloc]initWithFrame:CGRectMake(xcoordinate, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:screenBounds.size.width], scorePanelBase.frame.size.height)];
        }
        scoreFrame.userInteractionEnabled=YES;
        scoreFrame.tag=5000+i+1;
        [scorePanelBase addSubview:scoreFrame];
        scoreFrame.frameNumber.text=[NSString stringWithFormat:@"%d",i+1];
        UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFrame:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [scoreFrame addGestureRecognizer:tapRecognizer];
        
        xcoordinate=scoreFrame.frame.size.width+scoreFrame.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1.5 currentSuperviewDeviceSize:screenBounds.size.width];
    }


    //score frames for landscape
    int xcoordinateForLandscape=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width];
    scorePanelBaseForLandscape.frame= CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80 currentSuperviewDeviceSize:screenBounds.size.height]);
    int boxWidth=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:192/3 currentSuperviewDeviceSize:screenBounds.size.width];
    int boxHeight=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:185/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for(int i=0;i<10;i++)
    {
        CoachScoreFrameView *coachscoreFrame;
        if(i==9){
            coachscoreFrame=[[CoachScoreFrameView alloc]initWithFrame:CGRectMake(xcoordinateForLandscape, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], boxWidth, boxHeight)];
        }
        else{
            coachscoreFrame=[[CoachScoreFrameView alloc]initWithFrame:CGRectMake(xcoordinateForLandscape,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], boxWidth, boxHeight)];
        }
        
        //NSLog(@"coach frame tag :%d",(500+(i+1))*(playerCount+1));
        coachscoreFrame.tag=5000+100+(i+1);
        coachscoreFrame.layer.cornerRadius=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height];
        coachscoreFrame.layer.masksToBounds=YES;
        coachscoreFrame.backViewColor=[UIColor whiteColor];
        coachscoreFrame.separatorLineColor=[UIColor blackColor];
        coachscoreFrame.frameNumberTextColor=[UIColor blackColor];
        coachscoreFrame.userInteractionEnabled=YES;
        coachscoreFrame.frameNumber=[NSString stringWithFormat:@"%d",i+1];
        [coachscoreFrame loadViewWithText];
        UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFrame:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [coachscoreFrame addGestureRecognizer:tapRecognizer];

        [scorePanelBaseForLandscape addSubview:coachscoreFrame];
        xcoordinateForLandscape=coachscoreFrame.frame.size.width+coachscoreFrame.frame.origin.x+[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width];
    }

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
        scorePanelBaseForLandscape.hidden=NO;
        scorePanelBase.hidden=YES;
    }
    else{
        scorePanelBaseForLandscape.hidden=YES;
        scorePanelBase.hidden=NO;
    }
   
}



- (void)createPinView
{
    NSLog(@"%@",userStatsDataArray);
    if(pinsBackgroundView){
        [pinsBackgroundView removeFromSuperview];
        pinsBackgroundView=nil;
    }
    //Pin View
    pinsBackgroundView=[[UIView alloc]init];
    pinsBackgroundView.backgroundColor=[UIColor clearColor];
    //    pinsBackgroundView.frame=CGRectMake(0, 86+scorePanelBase.frame.origin.y+62.6,screenBounds.size.width, 283.6);
    pinsBackgroundView.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86+142 currentSuperviewDeviceSize:screenBounds.size.height],screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:350 currentSuperviewDeviceSize:screenBounds.size.height]);
    [self addSubview:pinsBackgroundView];
    
    //Previous throw
    RoundedRectButton *previousButton=[[RoundedRectButton alloc]init];
    [previousButton buttonFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:122.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
    previousButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    previousButton.tag=11000;
    [previousButton setTitle:@"Previous Frame" forState:UIControlStateNormal];
    if(currentThrow == 1 && currentFrame > 1){
        previousButton.hidden=NO;
    }
    else{
        previousButton.hidden=YES;
    }
    [previousButton addTarget:self action:@selector(changeThrow:) forControlEvents:UIControlEventTouchUpInside];
    [pinsBackgroundView addSubview:previousButton];
    
    //Throw label
    UILabel *throwLabel=[[UILabel alloc]init];
    throwLabel.tag=14000;
    throwLabel.frame=CGRectMake(previousButton.frame.size.width+previousButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], previousButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:90 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height]);
    throwLabel.layer.cornerRadius=throwLabel.frame.size.height/2;
    throwLabel.clipsToBounds=YES;
    throwLabel.backgroundColor=[UIColor whiteColor];
    if(currentThrow == 1)
        throwLabel.text=@"1st Throw";
    else
        throwLabel.text=@"2nd Throw";
    throwLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    throwLabel.textAlignment=NSTextAlignmentCenter;
    throwLabel.textColor=[UIColor blackColor];
    [pinsBackgroundView addSubview:throwLabel];
    
    //Next throw
    RoundedRectButton *nextButton=[[RoundedRectButton alloc]init];
    [nextButton buttonFrame:CGRectMake(throwLabel.frame.size.width+throwLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], previousButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:122.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
    nextButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
    if(currentThrow == 2)
        [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
    nextButton.tag=11001;
    [nextButton addTarget:self action:@selector(changeThrow:) forControlEvents:UIControlEventTouchUpInside];
    [pinsBackgroundView addSubview:nextButton];
    
    pinsBase=[[UIView alloc]init];
    pinsBase.frame=CGRectMake(0, throwLabel.frame.size.height+throwLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:2 currentSuperviewDeviceSize:screenBounds.size.width], pinsBackgroundView.frame.size.width*3, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:305 currentSuperviewDeviceSize:screenBounds.size.width]);
    pinsBase.backgroundColor=[UIColor clearColor];
    pinsBase.userInteractionEnabled=YES;
    [pinsBackgroundView addSubview:pinsBase];
    

    for (int throws=1; throws<=3; throws++) {
        int number_of_stars = 4;
        int yForStar = 20;
        int xForStar = 0;
        int pinIndex = 7;
        for (int rows=1; rows <= 4; rows++)
        {
            xForStar=((pinsBackgroundView.frame.size.width*throws)-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.width]*number_of_stars + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:19.67 currentSuperviewDeviceSize:screenBounds.size.width]*(number_of_stars-1)))/2 + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:207 currentSuperviewDeviceSize:screenBounds.size.width]*(throws-1);
            for (int star=4; star >= rows; star--) // for loop for pins
            {
                UIImageView *pin=[[UIImageView alloc]initWithFrame:CGRectMake(xForStar,yForStar, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height])];
                [pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                [pin setAccessibilityIdentifier:@"pin_down"] ;
                pin.tag=100*throws + pinIndex;
                pin.layer.cornerRadius = pin.frame.size.width/2;
                pin.layer.masksToBounds = YES;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
                    pin.userInteractionEnabled=YES;
                }
                else{
                    pin.userInteractionEnabled=NO;
                }
                if ([userDefaults boolForKey:kliveScoreUpdate]) {
                    pin.userInteractionEnabled=NO;
                }
                if ([userDefaults boolForKey:kInGameHistoryView]) {
                    pin.userInteractionEnabled=NO;
                }
                if (throws == 3) {
                    pin.hidden=YES;
                }
                [pinsBase addSubview:pin];
                NSLog(@"pinTag=%ld",(long)pin.tag);
                printf(" ");
                xForStar= pin.frame.size.width + pin.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:19.67 currentSuperviewDeviceSize:screenBounds.size.width] ;
                pinIndex++;
            }
            //coordinates for next row
            yForStar=yForStar + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16.67 currentSuperviewDeviceSize:screenBounds.size.height] +[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height];
            if(rows == 1)
                pinIndex=4;
            else if (rows == 2)
                pinIndex=2;
            else if(rows == 3)
                pinIndex=1;
            else
                pinIndex=7;
            number_of_stars = number_of_stars - 1;
        }
    }
    
    //Strike Button
    RoundedRectButton *strikeButton=[[RoundedRectButton alloc]init];
     [strikeButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8/2 currentSuperviewDeviceSize:screenBounds.size.width],pinsBackgroundView.frame.size.height+pinsBackgroundView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
    strikeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//   [strikeButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 0.0f, 10.0f, 0.0f)];
    [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
    strikeButton.tag=12000;
    [strikeButton addTarget:self action:@selector(markStrikeOrFoul:) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:strikeButton];
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType]] isEqualToString:@"Machine"]) {
        strikeButton.hidden=YES;
    }
    else{
        strikeButton.hidden=NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
    
        [strikeButton buttonFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.width],pinsBackgroundView.frame.size.height+pinsBackgroundView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        
        //Ball Type Button
        ballTypeButton=[[RoundedRectButton alloc]init];
        [ballTypeButton buttonFrame:CGRectMake(strikeButton.frame.origin.x, strikeButton.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        ballTypeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [ballTypeButton setTitle:@"Ball Type" forState:UIControlStateNormal];
        [ballTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        if ([[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName]) {
            NSDictionary *bowlingBallDict=[[NSDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName]];
            [ballTypeButton setTitle:[NSString stringWithFormat:@"%@",[bowlingBallDict objectForKey:@"userBowlingBallName"]] forState:UIControlStateNormal];
            
        [ballTypeButton addTarget:self action:@selector(selectBallType) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImage addSubview:ballTypeButton];
    
    UIImage *dropDownImage = [UIImage imageNamed:@"dropdown_icon.png"];
    UIImageView *dropDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ballTypeButton.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:28/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    dropDownImageView.image = dropDownImage;
    dropDownImageView.tag=999;
    dropDownImageView.userInteractionEnabled = NO;
    [ballTypeButton addSubview:dropDownImageView];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean]) {
        ballTypeButton.userInteractionEnabled=NO;
    }
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kBowlingBallName]);
}
     
        //Pocket Button
        RoundedRectButton *pocketButton=[[RoundedRectButton alloc]init];
        [pocketButton buttonFrame:CGRectMake(pinsBackgroundView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:127 currentSuperviewDeviceSize:screenBounds.size.width], strikeButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        pocketButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [pocketButton setTitle:@"Pocket" forState:UIControlStateNormal];
        pocketButton.tag=13000;
        [pocketButton addTarget:self action:@selector(markPocketOrBrooklyn:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImage addSubview:pocketButton];
        
        //Brooklyn Button
        RoundedRectButton *brooklynButton=[[RoundedRectButton alloc]init];
        [brooklynButton buttonFrame:CGRectMake(pocketButton.frame.origin.x, pocketButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        brooklynButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [brooklynButton setTitle:@"Brooklyn" forState:UIControlStateNormal];
        brooklynButton.tag=13001;
        [brooklynButton addTarget:self action:@selector(markPocketOrBrooklyn:) forControlEvents:UIControlEventTouchUpInside];

        [backgroundImage addSubview:brooklynButton];
        if ([[[userStatsDataArray objectAtIndex:0] objectForKey:@"PocketBrooklyn"] integerValue] == 1) {
            brooklynButton.selected=YES;
        }
        else if ([[[userStatsDataArray objectAtIndex:0] objectForKey:@"PocketBrooklyn"] integerValue] == 2){
//            pocketButton.selected=YES;
        }
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
        [strikeButton removeFromSuperview];
        [ballTypeButton removeFromSuperview];
        UIButton *pocket=(UIButton *)[self viewWithTag:13000];
        UIButton *brooklyn=(UIButton *)[self viewWithTag:13001];
        [pocket removeFromSuperview];
        [brooklyn removeFromSuperview];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
        [strikeButton removeFromSuperview];
        [ballTypeButton removeFromSuperview];
        UIButton *pocket=(UIButton *)[self viewWithTag:13000];
        UIButton *brooklyn=(UIButton *)[self viewWithTag:13001];
        [pocket removeFromSuperview];
        [brooklyn removeFromSuperview];

    }
}

- (void)showFrame:(UIGestureRecognizer *)aGesture
{
    viaShowFrame=YES;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ShowFrame"];
     UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    int selectedFrame=(int)[tapGesture view].tag - 5000;
    if (selectedFrame >= 100) {
        selectedFrame=selectedFrame-100;
    }
    if(selectedFrame < maxFramePlayed || selectedFrame == maxFramePlayed+1 || selectedFrame == maxFramePlayed)
    {
        currentThrow=1;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
        }
        if (([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]|| [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]))
        {
            if([timerforMyGameUpdateView isValid])
            {
                [timerforMyGameUpdateView invalidate];
                timerforMyGameUpdateView=nil;
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(updateViewforAutomatedCenter)
                                                           object:nil];
            }
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
            pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
            [self updatePinView:selectedFrame];
            currentFrame=selectedFrame;
            [self performSelector:@selector(initiateUpdateTimer) withObject:nil afterDelay:5.0];
            if (selectedFrame > maxFramePlayed) {
                maxFramePlayed=selectedFrame;
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
            pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
            [self updatePinView:selectedFrame];
            dispatch_async(queue,
                           ^{
                               if (currentFrame != 10) {
                                   [bowlingDelgate checkPreviousState:currentFrame];
                               }
                            dispatch_async( dispatch_get_main_queue(), ^{
                                    currentFrame=selectedFrame;
                                   [[DataManager shared]removeActivityIndicator];
                                   
                               });
                           });

            if (selectedFrame > maxFramePlayed) {
                maxFramePlayed=selectedFrame;
            }
        }
        
        if (selectedFrame != 10) {
            UIButton *rightButton=(UIButton*)[self viewWithTag:9000];
            UIButton *leftButton=(UIButton*)[self viewWithTag:9001];
            RoundedRectButton *doneButton=(RoundedRectButton *)[pinsBackgroundView viewWithTag:11003];
            [doneButton removeFromSuperview];
            [rightButton removeFromSuperview];
            [leftButton removeFromSuperview];
            
            for (int i = 1; i <= 10; i++) {
                UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
                pin.hidden=YES;
            }
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
            [self updateCursorForFSEMmodeForFrame:selectedFrame];
        }
    }
    else{
        if (([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"] || [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) && ![[NSUserDefaults standardUserDefaults]boolForKey:kgameComplete])
        {
            if(![timerforMyGameUpdateView isValid])
            {
                 timerforMyGameUpdateView = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateViewforAutomatedCenter) userInfo:nil repeats:YES];
            }
        }
    }
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType]] isEqualToString:@"Machine"] || [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
    }

}

- (void)initiateUpdateTimer
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
    if(![timerforMyGameUpdateView isValid])
    {
        timerforMyGameUpdateView = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(updateViewforAutomatedCenter) userInfo:nil repeats:YES];
    }
}

- (void)updateScorePanel:(NSDictionary*)scoreDict
{
    NSLog(@"updateScorePanel");
    if (maxFramePlayed == 0) {
          maxFramePlayed=currentFrame;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"] || [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
        if(currentFrame > maxFramePlayed)
            maxFramePlayed=currentFrame;
    }
      //Frame color change
    for (int i=0; i<maxFramePlayed; i++) {
        int pinNumber;
        pinNumber = i*2+1;
//        pinNumber=i;
        
        ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+i+1];
        CoachScoreFrameView *landscapeFrameBaseView=(CoachScoreFrameView*)[self viewWithTag:5000+100+(i+1)];
        //Frame score display
//        frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+frameNumber];
        if (viaShowFrame==YES && (i+1) == currentFrame) {
            NSLog(@"showFrame=%d  %d",currentFrame,i+1);
            NSString *frameScore = [NSString stringWithFormat:@"frameScore%d",i+1];
            frameBaseView.squareScore.text = [[scoreDict objectForKey:@"bowlingGame"] objectForKey:frameScore];
            landscapeFrameBaseView.totalScore=frameBaseView.squareScore.text;
        }
        else{
             NSLog(@"normalFrame=%d  %d",currentFrame,i+1);
            NSString *ball1Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
            if ([NSString stringWithFormat:@"%@",[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball1Key]].length == 0 ) {
                frameBaseView.ball1Score.text =@"";
            }
            else
                frameBaseView.ball1Score.text =[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball1Key];
            
            landscapeFrameBaseView.ball1score=frameBaseView.ball1Score.text;
            pinNumber++;
            NSString *ball2Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
            frameBaseView.ball2Score.text = [[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball2Key];
            if ([NSString stringWithFormat:@"%@",[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball2Key]].length == 0 && ![frameBaseView.ball1Score.text isEqualToString:@"X"]) {
                frameBaseView.ball2Score.text =@"";
            }
            else
                frameBaseView.ball2Score.text =[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball2Key];
            
            landscapeFrameBaseView.ball2score=frameBaseView.ball2Score.text;
            NSString *frameScore = [NSString stringWithFormat:@"frameScore%d",i+1];
            frameBaseView.squareScore.text = [[scoreDict objectForKey:@"bowlingGame"] objectForKey:frameScore];
            landscapeFrameBaseView.totalScore=frameBaseView.squareScore.text;
            if (i == 9) {
                pinNumber++;
                NSString *ball3Key = [NSString stringWithFormat:@"squareScore%d",i*2+3];
                frameBaseView.ball3Score.text = [[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball3Key];
                if ([[NSString stringWithFormat:@"%@",[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball3Key]] isEqualToString:@"0"] && !([frameBaseView.ball2Score.text isEqualToString:@"X"] || [frameBaseView.ball2Score.text isEqualToString:@"/"])) {
                    frameBaseView.ball3Score.text =@"";
                }
                else
                    frameBaseView.ball3Score.text =[[scoreDict objectForKey:@"bowlingGame"] objectForKey:ball3Key];
                
                landscapeFrameBaseView.ball3scoretenthFrame=frameBaseView.ball3Score.text;
            }
            [landscapeFrameBaseView updateText];
        }
     }
    mainScoreLabel.text=[NSString stringWithFormat:@"%@",[[scoreDict objectForKey:@"bowlingGame"] objectForKey:@"finalScore"]];
    viaShowFrame=NO;
}

- (void)updateFrameScore:(NSDictionary*)scoreDict
{
    NSLog(@"updateFrameScore");
    if (maxFramePlayed == 0) {
        maxFramePlayed=currentFrame;
    }
    for (int i=0; i<10; i++) {
        int pinNumber;
        pinNumber = i*2+1;
        ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+i+1];
        CoachScoreFrameView *landscapeFrameBase=(CoachScoreFrameView *)[self viewWithTag:5000+(i+1)+100];
        NSString *frameScore = [NSString stringWithFormat:@"frameScore%d",i+1];
        frameBaseView.squareScore.text = [[scoreDict objectForKey:@"bowlingGame"] objectForKey:frameScore];
        landscapeFrameBase.totalScore=frameBaseView.squareScore.text;

        if (i+1 != currentFrame ) {
            if(frameBaseView.squareScore.text.length > 0)
            {
                if ([frameBaseView.ball1Score.text isEqualToString:@""]) {
                    frameBaseView.ball1Score.text=@"0";
                }
                if ([frameBaseView.ball2Score.text isEqualToString:@""] && ![frameBaseView.ball1Score.text isEqualToString:@"X"]) {
                    frameBaseView.ball2Score.text=@"0";
                }
                if ([frameBaseView.ball3Score.text isEqualToString:@""] && ([frameBaseView.ball2Score.text isEqualToString:@"X"] || [frameBaseView.ball2Score.text isEqualToString:@"/"])) {
                    frameBaseView.ball3Score.text=@"0";
                }
                landscapeFrameBase.ball1score=frameBaseView.ball1Score.text;
                landscapeFrameBase.ball2score=frameBaseView.ball2Score.text;
                landscapeFrameBase.ball3scoretenthFrame=frameBaseView.ball3Score.text;
            }
            [landscapeFrameBase updateText];
        }
    }
    mainScoreLabel.text=[NSString stringWithFormat:@"%@",[[scoreDict objectForKey:@"bowlingGame"] objectForKey:@"finalScore"]];
}

-(void)updatePinView:(int)frame
{
    @try {
        if (standingPinsMutableArray == NULL) {
            standingPinsMutableArray=[[NSMutableArray alloc]init];
        }
        if (pinFallDictionary == NULL) {
            pinFallDictionary=[NSMutableDictionary new];
            pinFallPreviousStateDictionary=[NSMutableDictionary new];
            for(int i=1;i<=21;i++)
            {
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",1023] forKey:[NSString stringWithFormat:@"%d",i]];
                [pinFallPreviousStateDictionary setValue:[NSString stringWithFormat:@"%d",1023] forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
        //Update pins
        if (frame > 0) {
            pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
            UIImage *knockedPinImage=[UIImage imageNamed:@"pin_down.png"];
            [knockedPinImage setAccessibilityIdentifier:@"pin_down"];
            UIImage *remainingPinsImage=[UIImage imageNamed:@"bowling_pin.png"];
            [remainingPinsImage setAccessibilityIdentifier:@"bowling_pin"];
            //For Automated Scoring
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]|| [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                if(standingPinsMutableArray.count > 0)
                {
                    if(frame > 0)
                    {
                        unsigned ball1ref = [[standingPinsMutableArray objectAtIndex:((frame-1)*2)] intValue];
                        unsigned ball2ref = [[standingPinsMutableArray objectAtIndex:((frame-1)*2)+1] intValue];
                        NSLog(@"frame %d ball1score %d ball2score %d", frame, ball1ref, ball2ref);
                        for (int i = 100; i<110; i++) {
                            UIImageView *pin = (UIImageView *)[self viewWithTag:i+1];
                            unsigned pin1 = pow(2, i-100);
                            NSLog(@"AND %d", pin1 & ball1ref);
                            if  ((pin1 & ball1ref) >0) {
                                pin.image =  remainingPinsImage;
                            }
                            else{
                                pin.image = knockedPinImage;
                            }
                        }
                        for (int i = 200; i<210; i++) {
                            UIImageView *pin = (UIImageView *)[self viewWithTag:i+1];
                            unsigned pin2 = pow(2, i-200);
                            if  ((pin2 & ball2ref) >0) {
                                pin.image = remainingPinsImage;
                            }
                            else{
                                pin.image = knockedPinImage;
                            }
                        }
                        if (frame == 10) {
                            unsigned ball3ref = [[standingPinsMutableArray objectAtIndex:((frame-1)*2)+2] intValue];
                            for (int i = 300; i<310; i++) {
                                UIImageView *pin = (UIImageView *)[self viewWithTag:i+1];
                                unsigned pin3 = pow(2, i-300);
                                if  ((pin3 & ball3ref) >0) {
                                    pin.image = remainingPinsImage;
                                }
                                else{
                                    pin.image = knockedPinImage;
                                }
                            }
                        }
                        
                    }
                }
            }
            //For Manual Scoring
            else
            {
                if (pinFallDictionary.count > 0) {
                    int ball1ScoreValue = 0;
                    ScoreFrameImageView *latestScoreView=(ScoreFrameImageView*)[self viewWithTag:5000+frame];
                    if ([latestScoreView.ball1Score.text isEqualToString:@"X"]) {
                        ball1ScoreValue = 10;
                    }else if ([latestScoreView.ball1Score.text isEqualToString:@"F"]){
                        ball1ScoreValue = 0;
                    }
                    else {
                        ball1ScoreValue = [latestScoreView.ball1Score.text intValue];
                    }
                    
                    NSLog(@"pinFallDictionary=%@",pinFallDictionary);
                    for (int i = 101; i<111; i++) {
                        UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                        int standingPinValue1=(int)[[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",frame * 2 - 1]] integerValue];
                        if((standingPinValue1 & (int)pow(2, i - 101)) > 0)
                        {
                            pin.image = remainingPinsImage;
                        }
                        else{
                            pin.image = knockedPinImage;
                        }
                    }
                    
                    int ball2ScoreValue = ball1ScoreValue;
                    if ([latestScoreView.ball2Score.text isEqualToString:@"/"]) {
                        ball2ScoreValue = 10;
                    }else if ([latestScoreView.ball2Score.text isEqualToString:@"F"]){
                        ball2ScoreValue = ball1ScoreValue;
                    }
                    else {
                        ball2ScoreValue = [latestScoreView.ball2Score.text intValue]+ball1ScoreValue;
                    }
                    for (int i = 201; i<211; i++) {
                        UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                        int standingPinValue2=(int)[[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",frame * 2]] integerValue];
                        if((standingPinValue2 & (int)pow(2, i - 201)) > 0)
                        {
                            pin.image = remainingPinsImage;
                        }
                        else{
                            pin.image =  knockedPinImage;
                        }
                    }
                    
                    int ball3ScoreValue = 0;
                    if ([latestScoreView.ball3Score.text isEqualToString:@"X"]||[latestScoreView.ball3Score.text isEqualToString:@"/"]) {
                        ball3ScoreValue = 10;
                    }else if ([latestScoreView.ball3Score.text isEqualToString:@"F"]){
                        ball3ScoreValue = 0;
                    }
                    else {
                        ball3ScoreValue = [latestScoreView.ball3Score.text intValue];
                    }
                    for (int i = 301; i<311; i++) {
                        UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                        int standingPinValue3=(int)[[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",frame * 2 + 1]] integerValue];
                        if((standingPinValue3 & (int)pow(2, i - 301)) > 0)
                        {
                            pin.image = remainingPinsImage;
                        }
                        else{
                            pin.image =  knockedPinImage;
                        }
                    }
                    
                }
            }
            
            //Change score panel color
            for(int i=0;i<10;i++){
                ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+i+1];
                CoachScoreFrameView *landscapeLatestFrame=(CoachScoreFrameView *)[self viewWithTag:5000+100+(i+1)];
                //        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
                if(i+1 == frame){
                    //set background to blue color
                    landscapeLatestFrame.separatorLineColor=[UIColor blackColor];
                    landscapeLatestFrame.backViewColor=[UIColor colorWithRed:3.0/255.0f green:68.0/255.0f blue:144.0/255.0f alpha:1.0f];
                    landscapeLatestFrame.frameNumberTextColor=[UIColor whiteColor];
                }
                else if (i+1 <= maxFramePlayed){
                    //set background to gray color
                    landscapeLatestFrame.backViewColor=[UIColor whiteColor];
                    landscapeLatestFrame.separatorLineColor=[UIColor blackColor];
                    landscapeLatestFrame.frameNumberTextColor=[UIColor blackColor];
                }
                else{
                    //set background color to black color
                    landscapeLatestFrame.backViewColor=[UIColor colorWithRed:5.0/255.0f green:14.0/255.0f blue:23.0/255.0f alpha:1.0f];
                    landscapeLatestFrame.separatorLineColor=[UIColor colorWithRed:3/255.0f green:28/255.0f blue:46/255.0f alpha:1.0];;
                    landscapeLatestFrame.frameNumberTextColor=[UIColor whiteColor];
                }
                [landscapeLatestFrame updateText];
                //        }
                //        else{
                for(UILabel *subview in frameBaseView.subviews){
                    if([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UITextField class]])
                    {
                        if(i+1 == frame){
                            //set background to blue color
                            [subview setBackgroundColor:[UIColor colorWithRed:11.0/255 green:91.0/255 blue:253.0/255 alpha:0.6]];
                            subview.textColor=[UIColor whiteColor];
                            
                        }
                        else if (i+1 <= maxFramePlayed){
                            //set background to gray color
                            [subview setBackgroundColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.9]];
                            subview.textColor=[UIColor blackColor];
                        }
                        else{
                            //set background color to black color
                            subview.textColor=[UIColor grayColor];
                            subview.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
                        }
                    }
                }
                //        }
                
            }
            
            //Change buttons state
            RoundedRectButton *previousButton=(RoundedRectButton *)[self viewWithTag:11000];
            RoundedRectButton *nextButton=(RoundedRectButton *)[self viewWithTag:11001];
            RoundedRectButton *strikeButton=(RoundedRectButton *)[self viewWithTag:12000];
            
            [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
            
            //For LandscapeView
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
                UIButton *rightButton=(UIButton *)[self viewWithTag:9000];
                [rightButton removeFromSuperview];
                UIButton *leftButton=(UIButton *)[self viewWithTag:9001];
                [leftButton removeFromSuperview];
                UIButton *doneButton=(UIButton *)[self viewWithTag:11003];
                [doneButton removeFromSuperview];
                UILabel *firstThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14001];
                UILabel *secondThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14002];
                firstThrowLabel.text=@"1st Throw";
                secondThrowLabel.text=@"2nd Throw";
                if (frame == 10) {
                    
                    if ([secondThrowLabel.text isEqualToString:@"3rd Throw"]) {
                        //Right Arrow
                        UIButton *rightButton=(UIButton *)[self viewWithTag:9000];
                        [rightButton removeFromSuperview];
                        pinsBase.frame=CGRectMake(-pinsBackgroundView.frame.size.width/2, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                        UIButton *leftArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                        leftArrowButton.tag=9001;
                        leftArrowButton.frame=CGRectMake(5, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
                        leftArrowButton.center=CGPointMake(leftArrowButton.center.x, pinsBackgroundView.center.y);
                        [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_off.png"] forState:UIControlStateNormal];
                        [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_on.png"] forState:UIControlStateHighlighted];
                        [leftArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                        leftArrowButton.userInteractionEnabled = YES;
                        [self addSubview:leftArrowButton];
                        for (int i = 1; i <= 10; i++) {
                            UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
                            pin.hidden=NO;
                        }
                        if (![[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                            RoundedRectButton *doneButton=[[RoundedRectButton alloc]init];
                            [doneButton buttonFrame:CGRectMake(pinsBackgroundView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:940/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - 140, nextButton.frame.size.width,nextButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height])];
                            doneButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                            [doneButton setTitle:@"Done" forState:UIControlStateNormal];
                            doneButton.tag=11003;
                            [doneButton addTarget:self action:@selector(doneButtonFunction) forControlEvents:UIControlEventTouchUpInside];
                            [pinsBackgroundView addSubview:doneButton];
                            
                        }
                        
                        
                        firstThrowLabel.text=@"2nd Throw";
                        secondThrowLabel.text=@"3rd Throw";
                        
                    }
                    else{
                        RoundedRectButton *doneButton=(RoundedRectButton *)[self viewWithTag:11003];
                        UIButton *leftButton=(UIButton *)[self viewWithTag:9001];
                        [leftButton removeFromSuperview];
                        [doneButton removeFromSuperview];
                        firstThrowLabel.text=@"1st Throw";
                        secondThrowLabel.text=@"2nd Throw";
                        pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                        pinsBackgroundView.backgroundColor=[UIColor clearColor];
                        pinsBase.backgroundColor=[UIColor clearColor];
                        for (int i = 1; i <= 10; i++) {
                            UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
                            pin.hidden=YES;
                        }
                        
                        
                        UIButton *rightArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                        rightArrowButton.tag=9000;
                        rightArrowButton.frame=CGRectMake(pinsBackgroundView.frame.size.width-30, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
                        rightArrowButton.center=CGPointMake(rightArrowButton.center.x, pinsBackgroundView.center.y);
                        [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_off.png"] forState:UIControlStateNormal];
                        [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_on.png"] forState:UIControlStateHighlighted];
                        [rightArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                        rightArrowButton.userInteractionEnabled = YES;
                        [self addSubview:rightArrowButton];
                    }
                }
            }
            else{
                //Previous Frame Setup based on Frame and throw
                if (frame == 1) {
                    if (currentThrow == 1) {
                        [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                        previousButton.hidden=YES;
                    }
                    else{
                        previousButton.hidden=NO;
                    }
                }
                else{
                    previousButton.hidden=NO;
                    if (currentThrow == 1) {
                        [previousButton setTitle:@"Previous Frame" forState:UIControlStateNormal];
                    }
                    else
                        [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                }
                
                //Next Frame Setup based on Frame and Throw
                int squareNumber=(int)(2*(frame - 1)+currentThrow);
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]|| [[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]){          //For Automated game
                    if (currentThrow == 1) {
                        if (standingPinsMutableArray.count > 0) {
                            if([[standingPinsMutableArray objectAtIndex:((frame-1)*2)] intValue]==0)  //Strike in 1st throw
                                [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
                            else
                                [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                        }
                    }
                    else{
                        [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
                    }
                }
                else{       //For Manual game
                    if (currentThrow == 1) {
                        if (pinFallDictionary.count > 0) {
                            if([[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue]==0) //Strike in 1st throw
                                [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
                            else
                                [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                        }
                    }
                    else{
                        
                        if (pinFallDictionary.count > 0) {
                            if([[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue]==0) //Strike in 1st throw
                                [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
                            else
                                [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                        }
                    }
                    
                    if (currentFrame == 10) {
                        if (currentThrow == 1) {
                            [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                        }
                        else if (currentThrow == 2){
                            if ([[pinFallDictionary valueForKey:@"19"] intValue]==0 || [[pinFallDictionary valueForKey:@"20"] intValue]==0) {
                                [nextButton setTitle:@"Done" forState:UIControlStateNormal];
                            }
                            else{
                                [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                            }
                        }
                        else{
                            [nextButton setTitle:@"Done" forState:UIControlStateNormal];
                        }
                    }
                }
                NSLog(@"pinFall=%@",pinFallDictionary);
                UILabel *throwLabel=(UILabel *)[self viewWithTag:14000];
                if (currentThrow == 1) {
                    throwLabel.text=@"1st Throw";
                }
                else if (currentThrow == 2)
                {
                    throwLabel.text=@"2nd Throw";
                }
                else{
                    throwLabel.text=@"3rd Throw";
                }
            }
            //Update Pocket Brooklyn & Ball Name
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                [self updatePocketBrooklynForFrame:frame];
            }
            
            //Show tags
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                int tagsCount=(int)tagsArray.count;
                int numberOfRows=ceil(tagsCount/4.0);
                int numberOfTagsInEachRow;
                if (numberOfRows == 1) {
                    numberOfTagsInEachRow=(int)tagsCount;
                }
                else{
                    numberOfTagsInEachRow=4;
                }
                
                if (numberOfRows >= 3) {
                    heightForScrollView = screenBounds.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1780/3 currentSuperviewDeviceSize:screenBounds.size.height];
                    yForScroll=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1780/3 currentSuperviewDeviceSize:screenBounds.size.height];
                }
                else{
                    heightForScrollView =screenBounds.size.height - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1780/3 currentSuperviewDeviceSize:screenBounds.size.height]+(3 - numberOfRows)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.height]);
                    yForScroll=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1780/3 currentSuperviewDeviceSize:screenBounds.size.height]+(3 - numberOfRows)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.height];
                }
                
                @try {
                    baseForTags=[[UIScrollView alloc]initWithFrame:CGRectMake(0,yForScroll, screenBounds.size.width,heightForScrollView)];
                    baseForTags.backgroundColor=[UIColor clearColor];
                    [self addSubview:baseForTags];
                    int xcoordinate;
                    int ycoordinate =[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
                    int tagIndex=0;
                    for (int j=0; j<numberOfRows; j++) {
                        xcoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width];
                        UILabel *tagLabel;
                        tagIndex=j*4;
                        for (int i=0; i<numberOfTagsInEachRow; i++) {
                            tagLabel =  [[UILabel alloc] init];
                            tagLabel.frame=CGRectMake(xcoordinate,ycoordinate,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:273/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.height]/2);
                            [tagLabel setBackgroundColor:[UIColor whiteColor]];
                            tagLabel.textColor = [UIColor blackColor];
                            //                tagLabel.text=[NSString stringWithFormat:@"%d",j];
                            tagLabel.text=[NSString stringWithFormat:@"%@",[[tagsArray objectAtIndex:tagIndex] objectForKey:@"tag"]];
                            tagLabel.textAlignment=NSTextAlignmentCenter;
                            tagLabel.layer.cornerRadius=tagLabel.frame.size.height/2;
                            tagLabel.clipsToBounds=YES;
                            tagLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
                            [baseForTags addSubview:tagLabel];
                            
                            xcoordinate=tagLabel.frame.size.width+tagLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width];
                            tagIndex++;
                        }
                        ycoordinate=(tagLabel.frame.size.height+tagLabel.frame.origin.y) + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
                        if (j == (numberOfRows - 2)) {
                            if (tagsCount%4 != 0) {
                                numberOfTagsInEachRow=tagsCount%4;
                            }
                        }
                        
                    }
                    baseForTags.contentSize=CGSizeMake(baseForTags.frame.size.width,ycoordinate);
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Update pin view exception");
    }

}
#pragma mark - UI changes for Orientation Change
- (void)updateViewForOrientationChange
{
    UILabel *headerLabel=(UILabel *)[headerView viewWithTag:801];
    UIButton *sideNavigationButton=(UIButton *)[headerView viewWithTag:802];
    UIButton *moreButton=(UIButton *)[headerView viewWithTag:803];
     RoundedRectButton *challengeButton=(RoundedRectButton *)[self viewWithTag:10000];
     UIButton *enterChallengeButton=(UIButton *)[self viewWithTag:15000];
    [enterChallengeButton removeFromSuperview];
     UIButton *backButton=(UIButton *)[self viewWithTag:8001];
     UIButton *coachViewButton=(UIButton *)[self viewWithTag:8002];
    
#pragma mark  Landscape Changes
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {

        [bowlingDelgate removeMainMenu];
        NSLog(@"screen width=%f  screen height=%f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
        sideNavigationButton.hidden=YES;
        moreButton.hidden=YES;
        backgroundImage.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        headerView.frame=CGRectMake(0, 0, screenBounds.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:130/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        headerLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:105 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:500 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height);
        headerLabel.center=CGPointMake(headerView.center.x, headerLabel.center.y);
        playerNameLabel.frame=CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:700/3 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(36/3+75) currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
        playerNameLabel.backgroundColor=[UIColor clearColor];
        
        mainScoreLabel.frame=CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(75+30/3) currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
        
        UIButton *enterChallengeButton=[[UIButton alloc]init];
        enterChallengeButton.tag=15000;
        enterChallengeButton.frame=CGRectMake(screenBounds.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width],screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:155/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        enterChallengeButton.layer.cornerRadius=enterChallengeButton.frame.size.height/2;
        enterChallengeButton.clipsToBounds=YES;
        [enterChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:enterChallengeButton.frame] forState:UIControlStateNormal];
        [enterChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:enterChallengeButton.frame] forState:UIControlStateHighlighted];
        enterChallengeButton.titleEdgeInsets=UIEdgeInsetsMake(1.0, 0, 0, 0);
        [enterChallengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterChallengeButton setTitle:@"Enter Challenges" forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
            [enterChallengeButton setTitle:@"View Challenges" forState:UIControlStateNormal];
        }
        enterChallengeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [enterChallengeButton addTarget:self action:@selector(showChallengeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterChallengeButton];
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {

            backButton.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            enterChallengeButton.hidden=YES;
//            coachViewButton.frame=CGRectMake(screenBounds.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width],screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:127/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
            [moreButton removeFromSuperview];
            [sideNavigationButton removeFromSuperview];
            [enterChallengeButton removeFromSuperview];
            [challengeButton removeFromSuperview];
            backButton.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            baseForTags.frame=CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:736/3 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.frame.size.height+playerNameLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:736/3 currentSuperviewDeviceSize:screenBounds.size.width],heightForScrollView);
            baseForTags.backgroundColor=[UIColor clearColor];
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
            // Challenge View Button
              [backgroundImage setImage:[UIImage imageNamed:@"challenges_screen_bg_landscape.png"]];
            challengeButton.hidden=YES;
//            [challengeButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60.0 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.center.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120.0 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kgameComplete]) {
            summaryView.hidden=YES;
            pinsBackgroundView.hidden=NO;
            [enterChallengeButton removeFromSuperview];
            UIButton *gameSummaryButton=(UIButton*)[self viewWithTag:15001];
            if (![gameSummaryButton isHidden]) {
                gameSummaryButton.hidden=YES;
            }
        }
    }
#pragma mark  Portrait Changes
    else{
        moreButton.hidden=NO;
        sideNavigationButton.hidden=NO;
        backgroundImage.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        headerView.frame=CGRectMake(0, 0, screenBounds.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:screenBounds.size.height]);
        headerLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:12 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height);
        sideNavigationButton.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height]);
         moreButton.frame= CGRectMake(headerLabel.frame.size.width + headerLabel.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:155/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:32 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height]);
        mainScoreLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:333 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
        playerNameLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:165 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55 currentSuperviewDeviceSize:screenBounds.size.height]);
        UIButton *enterChallengeButton=[[UIButton alloc]init];
        enterChallengeButton.tag=15000;
        enterChallengeButton.frame=CGRectMake(0,screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [enterChallengeButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [enterChallengeButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [enterChallengeButton addTarget:self action:@selector(showChallengeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterChallengeButton];
         enterChallengeButton.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0, 0, 0);
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, enterChallengeButton.frame.size.width, enterChallengeButton.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.tag=15100;
        titleLabel.text=@"      Enter Challenges";
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]) {
            titleLabel.text=@"      View Challenges";
        }
        titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height] ];
        [enterChallengeButton addSubview:titleLabel];
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(enterChallengeButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, enterChallengeButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [enterChallengeButton addSubview:arrow];
        summaryView.hidden=NO;
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
            backButton.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            enterChallengeButton.hidden=YES;
//            coachViewButton.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1122/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInChallengeView]  && !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])) {
              [backgroundImage setImage:[UIImage imageNamed:@"challenges_screen_bg.png"]];
            challengeButton.hidden=NO;
            [self bringSubviewToFront:coachViewButton];

//                [challengeButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60.0 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.center.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120.0 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
            baseForTags.frame= CGRectMake(0,yForScroll, screenBounds.size.width,heightForScrollView);
            [moreButton removeFromSuperview];
            [sideNavigationButton removeFromSuperview];
            [enterChallengeButton removeFromSuperview];
            [challengeButton removeFromSuperview];
            backButton.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height]);

        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kgameComplete] && !([[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView] || [[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate])) {
            [enterChallengeButton removeFromSuperview];
            UIButton *gameSummaryButton=(UIButton*)[self viewWithTag:15001];
            if (showingGameSummary == YES) {
                summaryView.hidden=NO;
                pinsBackgroundView.hidden=YES;
                gameSummaryButton.hidden=YES;
            }
            else{
                summaryView.hidden=YES;
                pinsBackgroundView.hidden=NO;
                gameSummaryButton.hidden=NO;
            }
            
        }
    }

    [self updatePinViewForOrientationChange];
}

- (void)updatePinViewForOrientationChange
{
    UIButton *rightArrowButton=(UIButton *)[self viewWithTag:9000];
    [rightArrowButton removeFromSuperview];
    UIButton *leftArrowButton=(UIButton *)[self viewWithTag:9001];
    [leftArrowButton removeFromSuperview];
    RoundedRectButton *previousButton=(RoundedRectButton *)[self viewWithTag:11000];
    UILabel *throwLabel=(UILabel *)[self viewWithTag:14000];
    RoundedRectButton *nextButton=(RoundedRectButton *)[self viewWithTag:11001];
     RoundedRectButton *doneButton=(RoundedRectButton *)[self viewWithTag:11003];
    [doneButton removeFromSuperview];
    RoundedRectButton *strikeButton=(RoundedRectButton *)[self viewWithTag:12000];
    RoundedRectButton *pocketButton=(RoundedRectButton *)[self viewWithTag:13000];
    RoundedRectButton *brooklynButton=(RoundedRectButton *)[self viewWithTag:13001];
    UILabel *firstThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14001];
    UILabel *secondThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14002];

#pragma mark  Landscape Changes
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
            scoreView.hidden=YES;
            pinsBase.hidden=NO;
            ballTypeButton.hidden=NO;
            strikeButton.hidden=NO;
            pocketButton.hidden=NO;
            brooklynButton.hidden=NO;
            for(int i=0;i<10;i++){
                ScoreFrameImageView *scoreFrame=(ScoreFrameImageView *)[self viewWithTag:5000+i+1];
                scoreFrame.ball1Score.userInteractionEnabled=NO;
                scoreFrame.ball2Score.userInteractionEnabled=NO;
                scoreFrame.ball3Score.userInteractionEnabled=NO;
                if ([scoreFrame isFirstResponder]) {
                    [scoreFrame resignFirstResponder];
                }
            }
            
        }
        scorePanelBaseForLandscape.frame= CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80 currentSuperviewDeviceSize:screenBounds.size.height]);
        int xcoordinateForLandscape=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width];
        int boxWidth=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:192/3 currentSuperviewDeviceSize:screenBounds.size.width];
        int boxHeight=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:185/3 currentSuperviewDeviceSize:screenBounds.size.height];
        for(int i=0;i<10;i++)
        {
            CoachScoreFrameView *coachscoreFrame=(CoachScoreFrameView *)[scorePanelBaseForLandscape viewWithTag:5000+(i+1)+100];
            [coachscoreFrame viewFrame:CGRectMake(xcoordinateForLandscape, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], boxWidth, boxHeight)];
            coachscoreFrame.layer.cornerRadius=[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height];
            xcoordinateForLandscape=coachscoreFrame.frame.size.width+coachscoreFrame.frame.origin.x+[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width];
            [coachscoreFrame loadViewWithText];
        }

        scorePanelBaseForLandscape.hidden=NO;
        scorePanelBase.hidden=YES;
        
        pinsBackgroundView.frame=CGRectMake(0, scorePanelBaseForLandscape.frame.size.height+scorePanelBaseForLandscape.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1500/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height - (scorePanelBaseForLandscape.frame.size.height+scorePanelBaseForLandscape.frame.origin.y));
        pinsBackgroundView.backgroundColor=[UIColor clearColor];
        if (currentFrame == 10 && currentThrow == 3) {
            pinsBase.frame=CGRectMake(- pinsBackgroundView.frame.size.width/2,throwLabel.frame.size.height+throwLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:2 currentSuperviewDeviceSize:screenBounds.size.height], pinsBackgroundView.frame.size.width+ pinsBackgroundView.frame.size.width/2, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:305 currentSuperviewDeviceSize:screenBounds.size.height]);
            for (int i = 1; i <= 10; i++) {
                UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
                pin.hidden=NO;
            }
            
        }
        else{
            pinsBase.frame=CGRectMake(0,throwLabel.frame.size.height+throwLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:2 currentSuperviewDeviceSize:screenBounds.size.height], pinsBackgroundView.frame.size.width+pinsBackgroundView.frame.size.width/2, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:305 currentSuperviewDeviceSize:screenBounds.size.height]);
        }
        pinsBase.tag=2;
        pinsBase.backgroundColor=[UIColor clearColor];
        
        [firstThrowLabel removeFromSuperview];
        UILabel *firstThrowLabel=[[UILabel alloc]init];
        firstThrowLabel.tag=14001;
        firstThrowLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:233/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:25/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:270/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        firstThrowLabel.layer.cornerRadius=firstThrowLabel.frame.size.height/2;
        firstThrowLabel.clipsToBounds=YES;
        firstThrowLabel.backgroundColor=[UIColor whiteColor];
        firstThrowLabel.text=@"1st Throw";
        firstThrowLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        firstThrowLabel.textAlignment=NSTextAlignmentCenter;
        firstThrowLabel.textColor=[UIColor blackColor];
        [pinsBackgroundView addSubview:firstThrowLabel];
        
        [secondThrowLabel removeFromSuperview];
        UILabel *secondThrowLabel=[[UILabel alloc]init];
        secondThrowLabel.tag=14002;
        secondThrowLabel.frame=CGRectMake(firstThrowLabel.frame.size.width+firstThrowLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:25/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:270/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        secondThrowLabel.layer.cornerRadius=secondThrowLabel.frame.size.height/2;
        secondThrowLabel.clipsToBounds=YES;
        secondThrowLabel.backgroundColor=[UIColor whiteColor];
        secondThrowLabel.text=@"2nd Throw";
        secondThrowLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        secondThrowLabel.textAlignment=NSTextAlignmentCenter;
        secondThrowLabel.textColor=[UIColor blackColor];
        [pinsBackgroundView addSubview:secondThrowLabel];
        
        [ballTypeButton buttonFrame:CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:553/3 currentSuperviewDeviceSize:screenBounds.size.width], playerNameLabel.frame.origin.y+playerNameLabel.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        UIImageView *dropDown=(UIImageView *)[ballTypeButton viewWithTag:999];
        dropDown.frame=CGRectMake(ballTypeButton.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        
        //Pocket Button
        [pocketButton buttonFrame:CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:553/3 currentSuperviewDeviceSize:screenBounds.size.width], ballTypeButton.frame.origin.y+ballTypeButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], ballTypeButton.frame.size.width, ballTypeButton.frame.size.height)];
        
        //Brooklyn Button
        [brooklynButton buttonFrame:CGRectMake(screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:553/3 currentSuperviewDeviceSize:screenBounds.size.width], pocketButton.frame.origin.y+pocketButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], ballTypeButton.frame.size.width, ballTypeButton.frame.size.height)];
        if ([pocketButton isHidden]) {
            pocketButton.hidden=NO;
            brooklynButton.hidden=NO;
            ballTypeButton.hidden=NO;
           
        }
        throwLabel.hidden=YES;
        nextButton.hidden=YES;
        previousButton.hidden=YES;
        strikeButton.hidden=YES;
        
        if (currentFrame == 10) {
            
            if (currentThrow == 3) {
                firstThrowLabel.text=@"2nd Throw";
                secondThrowLabel.text=@"3rd Throw";
                UIButton *leftArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                leftArrowButton.tag=9001;
                leftArrowButton.frame=CGRectMake(5, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
                leftArrowButton.center=CGPointMake(leftArrowButton.center.x, pinsBackgroundView.center.y);
                [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_off.png"] forState:UIControlStateNormal];
                [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_on.png"] forState:UIControlStateHighlighted];
                [leftArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                leftArrowButton.userInteractionEnabled = YES;
                [self addSubview:leftArrowButton];
            }
            else{
                rightArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                rightArrowButton.tag=9000;
                rightArrowButton.frame=CGRectMake(pinsBackgroundView.frame.size.width-30, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
                rightArrowButton.center=CGPointMake(rightArrowButton.center.x, pinsBackgroundView.center.y);
                [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_off.png"] forState:UIControlStateNormal];
                [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_on.png"] forState:UIControlStateHighlighted];
                [rightArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                rightArrowButton.userInteractionEnabled = YES;
                [self addSubview:rightArrowButton];
                
            }
        }
        
        if (screenBounds.size.width == 480) {
             firstThrowLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            secondThrowLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        }
        
        //Update pins
        for (int throws=1; throws<=3; throws++) {
            int number_of_stars = 4;
            int yForStar = 8;
            int xForStar = 0;
            int pinIndex = 7;
            for (int rows=1; rows <= 4; rows++)
            {
                xForStar=(([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:736/3 currentSuperviewDeviceSize:screenBounds.size.width]*throws)-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:117/3 currentSuperviewDeviceSize:screenBounds.size.width]*number_of_stars + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width]*(number_of_stars-1)))/2 + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:380/3 currentSuperviewDeviceSize:screenBounds.size.width]*(throws-1);
                 if (screenBounds.size.width == 480) {
                        xForStar=(([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:746/3 currentSuperviewDeviceSize:screenBounds.size.width]*throws)-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:127/3 currentSuperviewDeviceSize:screenBounds.size.width]*number_of_stars + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width]*(number_of_stars-1)))/2 + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:390/3 currentSuperviewDeviceSize:screenBounds.size.width]*(throws-1);
                 }
                for (int star=4; star >= rows; star--) // for loop for pins
                {
                    UIImageView *pin=(UIImageView *)[pinsBase viewWithTag:(100*throws + pinIndex)];
                    pin.frame= CGRectMake(xForStar,yForStar, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:117/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:117/3 currentSuperviewDeviceSize:screenBounds.size.height]);
                    pin.layer.cornerRadius = pin.frame.size.width/2;
                    //                    [pin  setImage:[UIImage imageNamed:@"pin_down_landscape.png"]];
                    //                    [pin setAccessibilityIdentifier:@"pin_down"] ;
                    NSLog(@"pinTag=%ld",(long)pin.tag);
                    printf(" ");
                    xForStar= pin.frame.size.width + pin.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width] ;
                    pinIndex++;
                }
                //coordinates for next row
                yForStar=yForStar + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:37/3 currentSuperviewDeviceSize:screenBounds.size.height] +[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:117/3 currentSuperviewDeviceSize:screenBounds.size.height];
                if(rows == 1)
                    pinIndex=4;
                else if (rows == 2)
                    pinIndex=2;
                else if(rows == 3)
                    pinIndex=1;
                else
                    pinIndex=7;
                number_of_stars = number_of_stars - 1;
            }
        }

    }
#pragma mark  Portrait Changes
    else{
        scorePanelBaseForLandscape.hidden=YES;
        scorePanelBase.hidden=NO;
        [firstThrowLabel removeFromSuperview];
        [secondThrowLabel removeFromSuperview];
        pinsBackgroundView.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86+142 currentSuperviewDeviceSize:screenBounds.size.height],screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:350 currentSuperviewDeviceSize:screenBounds.size.height]);
        pinsBackgroundView.backgroundColor=[UIColor clearColor];
        [previousButton buttonFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:122.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        throwLabel.frame=CGRectMake(previousButton.frame.size.width+previousButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], previousButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:90 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height]);
        [nextButton buttonFrame:CGRectMake(throwLabel.frame.size.width+throwLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width], previousButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:122.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        nextButton.center=CGPointMake(nextButton.center.x, nextButton.center.y);
        pinsBase.frame=CGRectMake(0, throwLabel.frame.size.height+throwLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:2 currentSuperviewDeviceSize:screenBounds.size.width], pinsBackgroundView.frame.size.width*3, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:305 currentSuperviewDeviceSize:screenBounds.size.width]);
        pinsBase.backgroundColor=[UIColor clearColor];
        throwLabel.hidden=NO;
        nextButton.hidden=NO;
        if (currentFrame == 1 && currentThrow == 1) {
            previousButton.hidden=YES;
        }
        else
            previousButton.hidden=NO;
        if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType]] isEqualToString:@"Machine"]) {
            strikeButton.hidden=YES;
        }
        else{
            strikeButton.hidden=NO;
        }
        pocketButton.hidden=NO;
        brooklynButton.hidden=NO;
        ballTypeButton.hidden=NO;
        [strikeButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8/2 currentSuperviewDeviceSize:screenBounds.size.width],pinsBackgroundView.frame.size.height+pinsBackgroundView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
            [strikeButton buttonFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.width],pinsBackgroundView.frame.size.height+pinsBackgroundView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        }
        
        [ballTypeButton buttonFrame:CGRectMake(strikeButton.frame.origin.x, strikeButton.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        UIImageView *dropDown=(UIImageView *)[ballTypeButton viewWithTag:999];
        dropDown.frame=CGRectMake(ballTypeButton.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:28/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        
        //Pocket Button
        [pocketButton buttonFrame:CGRectMake(pinsBackgroundView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:127 currentSuperviewDeviceSize:screenBounds.size.width], strikeButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        
        //Brooklyn Button
        [brooklynButton buttonFrame:CGRectMake(pocketButton.frame.origin.x, pocketButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:96.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
        
        //Update pins
        for (int throws=1; throws<=3; throws++) {
            int number_of_stars = 4;
            int yForStar = 20;
            int xForStar = 0;
            int pinIndex = 7;
            for (int rows=1; rows <= 4; rows++)
            {
                xForStar=((pinsBackgroundView.frame.size.width*throws)-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.width]*number_of_stars + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:19.67 currentSuperviewDeviceSize:screenBounds.size.width]*(number_of_stars-1)))/2 + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:207 currentSuperviewDeviceSize:screenBounds.size.width]*(throws-1);
                for (int star=4; star >= rows; star--) // for loop for pins
                {
                    UIImageView *pin=(UIImageView *)[pinsBase viewWithTag:(100*throws + pinIndex)];
                    pin.frame= CGRectMake(xForStar,yForStar, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height]);
                    pin.layer.cornerRadius = pin.frame.size.width/2;
                    //                    [pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    //                    [pin setAccessibilityIdentifier:@"pin_down"] ;
                    NSLog(@"pinTag=%ld",(long)pin.tag);
                    printf(" ");
                    xForStar= pin.frame.size.width + pin.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:19.67 currentSuperviewDeviceSize:screenBounds.size.width] ;
                    pinIndex++;
                }
                //coordinates for next row
                yForStar=yForStar + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16.67 currentSuperviewDeviceSize:screenBounds.size.height] +[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height];
                if(rows == 1)
                    pinIndex=4;
                else if (rows == 2)
                    pinIndex=2;
                else if(rows == 3)
                    pinIndex=1;
                else
                    pinIndex=7;
                number_of_stars = number_of_stars - 1;
            }
        }
        
        for (int i = 1; i <= 10; i++) {
            UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
            pin.hidden=YES;
        }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kgameComplete]) {
            if (showingGameSummary == YES) {
                strikeButton.hidden=YES;
                ballTypeButton.hidden=YES;
                pocketButton.hidden=YES;
                brooklynButton.hidden=YES;
                [self bringSubviewToFront:summaryView];
            }
            else{
                strikeButton.hidden=NO;
                ballTypeButton.hidden=NO;
                pocketButton.hidden=NO;
                brooklynButton.hidden=NO;

            }
    }
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
            scoreView.hidden=NO;
            pinsBase.hidden=YES;
            ballTypeButton.hidden=YES;
            strikeButton.hidden=YES;
            pocketButton.hidden=YES;
            brooklynButton.hidden=YES;
            if (summaryView) {
                [summaryView removeFromSuperview];
                summaryView=nil;
            }
            for(int i=0;i<10;i++){
                ScoreFrameImageView *scoreFrame=(ScoreFrameImageView *)[self viewWithTag:5000+i+1];
                scoreFrame.ball1Score.userInteractionEnabled=YES;
                scoreFrame.ball2Score.userInteractionEnabled=YES;
                scoreFrame.ball3Score.userInteractionEnabled=YES;
                UIView *overlay1 = [[UIView alloc] init];
                overlay1.backgroundColor=[UIColor clearColor];
                overlay1.userInteractionEnabled=YES;
                [overlay1 setFrame:scoreFrame.ball1Score.frame];
                [scoreFrame addSubview:overlay1];
                
                UIView *overlay2 = [[UIView alloc] init];
                overlay2.backgroundColor=[UIColor clearColor];
                overlay2.userInteractionEnabled=YES;
                [overlay2 setFrame:scoreFrame.ball2Score.frame];
                [scoreFrame addSubview:overlay2];
                
                UIView *overlay3 = [[UIView alloc] init];
                overlay3.backgroundColor=[UIColor clearColor];
                overlay3.userInteractionEnabled=YES;
                [overlay3 setFrame:scoreFrame.ball3Score.frame];
                [scoreFrame addSubview:overlay3];

            }
        }
        NSLog(@"scoreView=%@",scoreView);

    }
    
    //UI changes for Live Score View & Game History View
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
        [strikeButton removeFromSuperview];
        [ballTypeButton removeFromSuperview];
        [pocketButton removeFromSuperview];
        [brooklynButton removeFromSuperview];
    }
}

- (void)arrowButtonFunction:(UIButton *)sender
{
    UILabel *firstThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14001];
    UILabel *secondThrowLabel=(UILabel *)[pinsBackgroundView viewWithTag:14002];
     RoundedRectButton *doneButton=(RoundedRectButton *)[self viewWithTag:11003];
    RoundedRectButton *nextButton=(RoundedRectButton *)[self viewWithTag:11001];
    if (sender.tag == 9000) {
        //Right Arrow
        UIButton *rightButton=(UIButton *)[self viewWithTag:9000];
        [rightButton removeFromSuperview];
         pinsBase.frame=CGRectMake(-pinsBackgroundView.frame.size.width/2, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
        UIButton *leftArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        leftArrowButton.tag=9001;
        leftArrowButton.frame=CGRectMake(5, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
        leftArrowButton.center=CGPointMake(leftArrowButton.center.x, pinsBackgroundView.center.y);
        [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_off.png"] forState:UIControlStateNormal];
        [leftArrowButton setBackgroundImage:[UIImage imageNamed:@"left_arrow_on.png"] forState:UIControlStateHighlighted];
        [leftArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        leftArrowButton.userInteractionEnabled = YES;
        [self addSubview:leftArrowButton];
        for (int i = 1; i <= 10; i++) {
            UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
            pin.hidden=NO;
        }
////        if ([nextButton.titleLabel.text isEqualToString:@"Done"]) {
//            nextButton.hidden=NO;
//            nextButton.titleLabel.text=@"Done";
//            [nextButton buttonFrame:CGRectMake(pinsBackgroundView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:940/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - 140, nextButton.frame.size.width,nextButton.frame.size.height)];
//            [pinsBackgroundView bringSubviewToFront:nextButton];
////        }
         if (![[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
        RoundedRectButton *doneButton=[[RoundedRectButton alloc]init];
       [doneButton buttonFrame:CGRectMake(pinsBackgroundView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:940/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - 140, nextButton.frame.size.width,nextButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height])];
        doneButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        doneButton.tag=11003;
        [doneButton addTarget:self action:@selector(doneButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [pinsBackgroundView addSubview:doneButton];
         }


        firstThrowLabel.text=@"2nd Throw";
        secondThrowLabel.text=@"3rd Throw";

    }
    else{
        //Left Arrow
        UIButton *leftButton=(UIButton *)[self viewWithTag:9001];
        [leftButton removeFromSuperview];
        [doneButton removeFromSuperview];
        pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
        UIButton *rightArrowButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        rightArrowButton.tag=9000;
        rightArrowButton.frame=CGRectMake(pinsBackgroundView.frame.size.width-30, pinsBackgroundView.frame.size.height/2-12.5, 25, 25);
        rightArrowButton.center=CGPointMake(rightArrowButton.center.x, pinsBackgroundView.center.y);
        [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_off.png"] forState:UIControlStateNormal];
        [rightArrowButton setBackgroundImage:[UIImage imageNamed:@"right_arrow_on.png"] forState:UIControlStateHighlighted];
        [rightArrowButton addTarget:self action:@selector(arrowButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        rightArrowButton.userInteractionEnabled = YES;
        [self addSubview:rightArrowButton];
        for (int i = 1; i <= 10; i++) {
            UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
            pin.hidden=YES;
        }
        firstThrowLabel.text=@"1st Throw";
        secondThrowLabel.text=@"2nd Throw";
    }
}

- (void)doneButtonFunction
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"]){
            ScoreFrameImageView *frameScoreView=(ScoreFrameImageView*)[self viewWithTag:5010];
            CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5110];
            if ([frameScoreView.ball1Score.text isEqualToString:@""]) {
                frameScoreView.ball1Score.text=@"0";
            }
            if ([frameScoreView.ball2Score.text isEqualToString:@""] && ![frameScoreView.ball1Score.text isEqualToString:@"X"]) {
                frameScoreView.ball2Score.text=@"0";
            }
            if ([frameScoreView.ball3Score.text isEqualToString:@""] && ([frameScoreView.ball2Score.text isEqualToString:@"X"] || [frameScoreView.ball2Score.text isEqualToString:@"/"])) {
                frameScoreView.ball3Score.text=@"0";
            }
            landscapeFrameBaseView.ball1score=frameScoreView.ball1Score.text;
            landscapeFrameBaseView.ball2score=frameScoreView.ball2Score.text;
            landscapeFrameBaseView.ball3scoretenthFrame=frameScoreView.ball3Score.text;
            [landscapeFrameBaseView updateText];
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            //  do the long running work in bg async queue
            // within that, call to update UI on main thread.
            dispatch_async(queue,
                           ^{
                               if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
                                   [bowlingDelgate checkPreviousState:currentFrame];
                               dispatch_async(main, ^{
                                   
                               });
                           });
        }
    }
}

#pragma mark -

- (void)tenthFrameCountValue:(int)count
{
    tenthFrameCount=count;
}
- (void)updatePocketBrooklynForFrame:(int)frame
{
    @try {
        RoundedRectButton *brooklyn=(RoundedRectButton *)[self viewWithTag:13001];
        RoundedRectButton *pocket=(RoundedRectButton *)[self viewWithTag:13000];
        if (frame==10) {
            if ([[[userStatsDataArray objectAtIndex:tenthFrameCount-1] objectForKey:@"PocketBrooklyn"] integerValue] == 2) {
                pocket.selected=YES;
                brooklyn.selected=NO;
            }
            else if ([[[userStatsDataArray objectAtIndex:tenthFrameCount-1] objectForKey:@"PocketBrooklyn"] integerValue] == 1) {
                brooklyn.selected=YES;
                pocket.selected=NO;
            }
            else{
                pocket.selected=NO;
                brooklyn.selected=NO;
            }
            
        }
        else{
            if ([[[userStatsDataArray objectAtIndex:frame - 1] objectForKey:@"PocketBrooklyn"] integerValue] == 2) {
                pocket.selected=YES;
                brooklyn.selected=NO;
            }
            else if ([[[userStatsDataArray objectAtIndex:frame - 1] objectForKey:@"PocketBrooklyn"] integerValue] == 1) {
                brooklyn.selected=YES;
                pocket.selected=NO;
            }
            else{
                pocket.selected=NO;
                brooklyn.selected=NO;
            }
            
        }
        [ballTypeButton setTitle:[NSString stringWithFormat:@"%@",[[userStatsDataArray objectAtIndex:frame-1] objectForKey:@"BallName"]] forState:UIControlStateNormal];
        @try {
            if(ballTypeArray.count > 0 && (userStatsDataArray.count > 0))
            {
                
                for(int j=0;j<[userStatsDataArray count];j++)
                {
                    if([[[userStatsDataArray objectAtIndex:j] objectForKey:@"FrameNumber"] integerValue] == currentFrame)
                    {
                        if([[NSString stringWithFormat:@"%@",[[userStatsDataArray objectAtIndex:j] objectForKey:@"BallName"]] isEqualToString:@"Select Ball"])
                        {
                            [ballTypeButton setTitle:[NSString stringWithFormat:@"%@",[[userStatsDataArray objectAtIndex:j-1] objectForKey:@"BallName"]] forState:UIControlStateNormal];
                            NSMutableDictionary *temp=[userStatsDataArray objectAtIndex:j];
                            @try {
                                
                                [temp setObject:[NSString stringWithFormat:@"%ld",(long)[[[userStatsDataArray objectAtIndex:j]objectForKey:@"PocketBrooklyn"] integerValue]] forKey:@"PocketBrooklyn"];
                                [temp setObject:[NSString stringWithFormat:@"%d",j+1] forKey:@"FrameNumber"];
                                [temp setObject:[NSString stringWithFormat:@"%@",[[userStatsDataArray objectAtIndex:j-1] objectForKey:@"BallName"]] forKey:@"BallName"];
                                [userStatsDataArray replaceObjectAtIndex:j withObject:temp];
                                break;
                                
                            }
                            @catch (NSException *exception) {
                                
                            }
                        }
                        else
                        {
                            [ballTypeButton setTitle:[NSString stringWithFormat:@"%@",[[userStatsDataArray objectAtIndex:j] objectForKey:@"BallName"]] forState:UIControlStateNormal];
                            break;
                        }
                    }
                }
                
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ball type exception in update %d",currentFrame);
            [ballTypeButton setTitle:@"Select Ball" forState:UIControlStateNormal];
        }
        //        if(ballTypeArray.count > 0 && [[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean])
        //        {
        //            UITapGestureRecognizer  *ballTypetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textfieldlist:)] ;
        //            ballTypetapRecognizer.numberOfTapsRequired = 1;
        //            [ballTypeDropdown addGestureRecognizer:ballTypetapRecognizer];
        //        }
        //        else
        //        {
        //            ballTypeDropdown.textLabel.textColor=[UIColor grayColor];
        //            ballTypeDropdown.textLabel.text=@"Select Ball";
        //
        //        }
        
        @try {
            if(userStatsDataArray.count > 0)
            {
                for(int j=0;j<[userStatsDataArray count];j++)
                {
                    if([[[userStatsDataArray objectAtIndex:j] objectForKey:@"FrameNumber"] integerValue] == currentFrame)
                    {
                        if([[[userStatsDataArray objectAtIndex:j] objectForKey:@"PocketBrooklyn"] integerValue] == 2)
                        {
                            //                        if(i == 0)
                            //                        {
                            //                            [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
                            //                            [comparisonItemselectArray addObject:[NSString stringWithFormat:@"%d",1510]];
                            //                        }
                            
                        }
                        else  if([[[userStatsDataArray objectAtIndex:j] objectForKey:@"PocketBrooklyn"] integerValue] == 0){
                            
                        }
                        else{
                            //                        if(i == 1)
                            //                        {
                            //                            [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
                            //                            [comparisonItemselectArray addObject:[NSString stringWithFormat:@"%d",1511]];
                            //                        }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            pocket.selected=NO;
            brooklyn.selected=NO;
        }
        if(![[NSUserDefaults standardUserDefaults]boolForKey:kPocketBrooklynBoolean])
        {
            pocket.userInteractionEnabled=NO;
            brooklyn.userInteractionEnabled=NO;
        }
        else{
            pocket.userInteractionEnabled=YES;
            brooklyn.userInteractionEnabled=YES;
        }

    }
    @catch (NSException *exception) {
        
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0,0,screenBounds.size.width,screenBounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context,0.3);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)selectBallType
{
//    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    [bowlingDelgate ballTypeSelectionFunction];
}
//- (void)changeDropdownIconImage:(UIImageView *)dropDownImageView
//{
//    dropDownImageView.image=[UIImage imageNamed:@"dropdown_icon.png"];
//}

- (void)displayBallName:(NSString *)name
{
    [ballTypeButton setTitle:name forState:UIControlStateNormal];
}

- (void)setBallTypeArray:(NSArray *)array
{
    ballTypeArray=[[NSMutableArray alloc]initWithArray:array];
}
#pragma mark - Swipe Functionality
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%ld",(long)touch.view.tag);
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* viewYouWishToObtain = [self hitTest:locationPoint withEvent:event];
//    NSLog(@"currentTag=%ld",(long)viewYouWishToObtain.tag);
    if(viewYouWishToObtain.tag<=3000 && viewYouWishToObtain.tag>=100){
        if(viewYouWishToObtain.tag != currentPinTag){
//            UIImageView *pinImage=(UIImageView *) [pinsBackgroundView viewWithTag:viewYouWishToObtain.tag];
//            NSString *file_name = [pinImage accessibilityIdentifier] ;
            [self pinTapFunction:(int)viewYouWishToObtain.tag];
        }
    }
    currentPinTag=viewYouWishToObtain.tag;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    NSLog(@"Moved: touch=%ld",(long)touch.view.tag);
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* viewYouWishToObtain = [self hitTest:locationPoint withEvent:event];
//    NSLog(@"currentTag=%ld",(long)viewYouWishToObtain.tag);
    if(viewYouWishToObtain.tag<=3000 && viewYouWishToObtain.tag>=100)
    {
//        NSLog(@"viewTag=%d  currentPinTag=%d",viewYouWishToObtain.tag,currentPinTag);
        if(viewYouWishToObtain.tag != currentPinTag){
//            NSLog(@"pinTap");
             [self pinTapFunction:(int)viewYouWishToObtain.tag];
//            currentPinTag=viewYouWishToObtain.tag;
        }
    }
    currentPinTag=viewYouWishToObtain.tag;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
//    NSLog(@"End: touch=%ld",(long)touch.view.tag);
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView*viewYouWishToObtain = [self hitTest:locationPoint withEvent:event];
//    NSLog(@"currentTag=%ld",(long)viewYouWishToObtain.tag);
    if(viewYouWishToObtain.tag<=3000 && viewYouWishToObtain.tag>=100){
        if(viewYouWishToObtain.tag != currentPinTag){
             [self pinTapFunction:(int)viewYouWishToObtain.tag];
        }
    }
    currentPinTag=0;
}

-(void)pinTapFunction:(int)pinImageTag
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
        return;
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
        currentThrow=pinImageTag/100;
    }
    //to store value of tapped pin in pinFallDictionary
    NSLog(@"framenum=%d",currentFrame);
    int currentFrameOfTappedPin=(int)currentThrow;
    int pinNumber=pinImageTag%100;
    UIImageView *pinImage=(UIImageView *) [pinsBackgroundView viewWithTag:pinImageTag];
    int squareNumber = currentFrame * 2 - (currentFrameOfTappedPin % 2);
    if (currentFrameOfTappedPin == 3) {
        squareNumber = 21;
    }
    
    // Last Frame
    if (squareNumber >= 19) {
          [self lastFrameHandling:pinImage squareNumber:squareNumber fillColor:0];
        return;
    }
    int pinFall = [[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue];
    int mask = 1 << (pinNumber - 1);
    int value = pinFall ^ mask;
    //to check the current pin status if YES then pin is knocked if NO then pin is standing(acc to old logic)
    BOOL firstStanding = (pinFall & mask) > 0;
    
    
    //to prevent 1st ball knocked pin from being changed by second ball
    if (currentFrameOfTappedPin == 2)
    {
        int squareNumber1 = currentFrame * 2 - 1;
        int pinFall1 = [[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber1]] intValue];
        int mask1 = (int)pow(2, pinNumber - 1);
        //to check the same pin of first ball if YES then pin is knocked if NO then pin is standing(acc to old logic)
        BOOL firstStand = (pinFall1 & mask1) > 0;
        if (firstStand)
        {
            firstStanding = !firstStanding;
            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",value] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
            if(firstStanding == YES){
                //dropped down
                [pinImage  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                [pinImage setAccessibilityIdentifier:@"bowling_pin"] ;
                
            }
            else{
                //standing so drop it
                [pinImage  setImage:[UIImage imageNamed:@"pin_down.png"]];
                [pinImage setAccessibilityIdentifier:@"pin_down"] ;
            }
        }
     }
    else
    {
        firstStanding = !firstStanding;
        [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",value] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
        if(firstStanding == YES){
            //dropped down
            [pinImage  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
            [pinImage setAccessibilityIdentifier:@"bowling_pin"] ;
            
        }
        else{
            //standing so  drop the pin
            [pinImage  setImage:[UIImage imageNamed:@"pin_down.png"]];
            [pinImage setAccessibilityIdentifier:@"pin_down"] ;
        }
        
        //link first ball pins to second ball pins
        squareNumber = currentFrame * 2;
        pinFall = [[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue];
        UIImageView *ball2pin=(UIImageView *)[pinsBackgroundView viewWithTag:pinImageTag+100];
        NSLog(@"mask=%d",mask);
        NSLog(@"ball2pin = %@",ball2pin);
        if (firstStanding)
        {
            
            [ball2pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
            [ball2pin setAccessibilityIdentifier:@"bowling_pin"] ;
            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall | mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
        }
        else
        {
            [ball2pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
            [ball2pin setAccessibilityIdentifier:@"pin_down"] ;
            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall & ~mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
        }
    }
  NSString *ballScores = [bowlingDelgate calculateScore:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2 - 1]] intValue] secondPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2]] intValue] thirdPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2+1]] intValue] currentFrame:currentFrame];
    NSArray *temp=[ballScores componentsSeparatedByString:@","];
    ScoreFrameImageView *frameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
    CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5000+currentFrame+100];
    frameBaseView.ball1Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
    frameBaseView.ball2Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:1]];
    landscapeFrameBaseView.ball1score=frameBaseView.ball1Score.text;
    landscapeFrameBaseView.ball2score=frameBaseView.ball2Score.text;
    if(currentFrame == 10){
        frameBaseView.ball3Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:2]];
        landscapeFrameBaseView.ball3scoretenthFrame=frameBaseView.ball3Score.text;
    }
    [landscapeFrameBaseView updateText];
    UIButton *nextButton=(UIButton*)[self viewWithTag:11001];
    if(currentThrow == 1)
    {
        if ([[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue]==0) {
            [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
    ////        currentThrow++;
    }
    else{
            [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
        }
    }
}


-(void)lastFrameHandling:(UIImageView *) v squareNumber:(int)squareNumber fillColor:(int)fillColor
{
    int pinFall =(int) [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",squareNumber]] integerValue];
    int pinNumber=v.tag%100;
    int mask = 1 << (pinNumber-1); // pow(2,pinNumber - 1)
    BOOL firstStanding = (pinFall & mask) > 0;
    int previousState =(int) [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",squareNumber]] integerValue];
    
    // 1st Ball
    if(squareNumber == 19)
    {
        if(firstStanding)
        {
            [v  setImage:[UIImage imageNamed:@"pin_down.png"]];
            [v setAccessibilityIdentifier:@"pin_down"] ;
        }
        else
        {
            [v  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
            [v setAccessibilityIdentifier:@"bowling_pin"] ;
        }
        [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall ^ mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
        
//        if (!([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] == 0 || [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] == 0))
//        {
//            for (int i = 301; i<311; i++)
//            {
//                UIImageView *pin = (UIImageView *)[self viewWithTag:i];
//                [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
//                [pin setAccessibilityIdentifier:@"bowling_pin"] ;
//            }
//            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",21]];
//            
//        }
        if (previousState == 0 && [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] != 0)
        {
            //second ball dependent on 1st ball
            ballsDependencyState=4;
            for (int i = 1; i < 11; i++)
            {
                UIImageView *pin = (UIImageView *)[self viewWithTag:200 + i];
                if(i == pinNumber)
                {
                    [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [pin setAccessibilityIdentifier:@"bowling_pin"] ;
                }
                else
                {
                   
                    [pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    [pin setAccessibilityIdentifier:@"pin_down"] ;
                }
            }
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",20]];
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",0 | mask] forKey:[NSString stringWithFormat:@"%d",20]];
        }
        else
        {
            //second and first independent
            ballsDependencyState=1;
            squareNumber=currentFrame * 2;
            pinFall = [[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue];
            if(!firstStanding)  //if(!firstStanding)
            {
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall | mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                UIImageView *secondPin=(UIImageView *)[self viewWithTag:200 + pinNumber];
                [secondPin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                [secondPin setAccessibilityIdentifier:@"bowling_pin"] ;
            }
            else
            {
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall & ~mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                UIImageView *secondPin=(UIImageView *)[self viewWithTag:200 + pinNumber];
                [secondPin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                [secondPin setAccessibilityIdentifier:@"pin_down"] ;
            }
        }
        if ([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] == 0) {
            ballsDependencyState=1;
            [pinFallDictionary setValue:@"1023" forKey:@"20"];
            for (int i = 201; i<211; i++)
            {
                UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                [pin setAccessibilityIdentifier:@"bowling_pin"] ;
            }
        }
        
    }
    else if (squareNumber == 20)
    {
        if ([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] != 0)
        {
            int squareNumber1 = currentFrame * 2 - 1;
            int pinFall1 = [[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber1]] intValue];
            int mask1 = (int)pow(2, pinNumber - 1);
            //to check the same pin of first ball if YES then pin is knocked if NO then pin is standing(acc to old logic)
            BOOL firstStand = (pinFall1 & mask1) > 0;
            if (firstStand)
            {
                if(firstStanding == NO)
                {
                    [v  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [v setAccessibilityIdentifier:@"bowling_pin"] ;
                 }
                else
                {
                    [v  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    [v setAccessibilityIdentifier:@"pin_down"] ;
                }
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall ^ mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                if ([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] != 0)
                {
                    //3rd disabled 1st & 2nd dependent
                    ballsDependencyState=4;
                    for (int i = 301; i<311; i++)
                    {
                        UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                        [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                        [pin setAccessibilityIdentifier:@"bowling_pin"] ;
                    }
                    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",1023] forKey:[NSString stringWithFormat:@"%d",21]];
                }
                else
                    ballsDependencyState=2;
                UIButton *nextButton=(UIButton *)[self viewWithTag:11001];
                BOOL temp = [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] == 0
                || [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] == 0;
                if(temp){
                    [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                }
                else{
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
                        nextButton.hidden=YES;
                    }
                    else
                    {
                        if ([nextButton isHidden]) {
                            nextButton.hidden=NO;
                        }
                        [nextButton setTitle:@"Done" forState:UIControlStateNormal];
                        
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]|| [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                            nextButton.hidden=YES;
                        }
                    }

                }
            }
        }
        else
        {
            
            if (firstStanding)
            {
                [v  setImage:[UIImage imageNamed:@"pin_down.png"]];
                [v setAccessibilityIdentifier:@"pin_down"] ;
            }
            else
            {
                [v  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                [v setAccessibilityIdentifier:@"bowling_pin"] ;
            }
            [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall ^ mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
            if (previousState == 0  && [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] != 0)
            {
                //second and third ball dependency
                ballsDependencyState=3;
                for (int i = 1; i<11; i++)
                {
                    UIImageView *pin = (UIImageView *)[self viewWithTag:300+i];
                    if(i == pinNumber)
                    {
                        [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                        [pin setAccessibilityIdentifier:@"bowling_pin"] ;
                    }
                    else
                    {
                        [pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                        [pin setAccessibilityIdentifier:@"pin_down"] ;
                    }
                }
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",21]];
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",0 | mask] forKey:[NSString stringWithFormat:@"%d",21]];
            }
            else
            {
                //second and third ball dependency
                ballsDependencyState=3;
                squareNumber = currentFrame *2 + 1;
                pinFall=[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue];
                UIImageView *thirdPin=(UIImageView *)[self viewWithTag:300 + pinNumber];
                if(!firstStanding)
                {
                    [thirdPin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [thirdPin setAccessibilityIdentifier:@"bowling_pin"] ;
                    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall | mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                }
                else
                {
                    [thirdPin  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    [thirdPin setAccessibilityIdentifier:@"pin_down"] ;
                    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall & ~mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                }
                
                if([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] == 0)
                {
                    //second and third independent
                    ballsDependencyState=1;
                     [pinFallDictionary setValue:@"1023" forKey:@"21"];
                    for (int i = 301; i<311; i++)
                    {
                        UIImageView *pin = (UIImageView *)[self viewWithTag:i];
                        [pin  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                        [pin setAccessibilityIdentifier:@"bowling_pin"] ;
                    }

                }
            }
        }
    }
    else if (squareNumber == 21)
    {
        if([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] == 0 || [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] == 0)
        {
            if ([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] != 0)
            {
                int squareNumber1 = currentFrame *2;
                int pinFall1= (int)[[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",squareNumber1]] integerValue];
                int mask1 = 1 << (pinNumber - 1);
                BOOL firstStand=(pinFall1 & mask1) > 0;
                if(firstStand)
                {
                    if (firstStanding)
                    {
                        //second and third ball dependent
                        ballsDependencyState=3;
                        [v  setImage:[UIImage imageNamed:@"pin_down.png"]];
                        [v setAccessibilityIdentifier:@"pin_down"] ;
                    }
                    else
                    {
                        [v  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                        [v setAccessibilityIdentifier:@"bowling_pin"] ;
                    }
                    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall ^ mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
                }
            }
            else
            {
                if (firstStanding)
                {
                    [v  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    [v setAccessibilityIdentifier:@"pin_down"] ;
                }
                else
                {
                    [v  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [v setAccessibilityIdentifier:@"bowling_pin"] ;
                }
                [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",pinFall ^ mask] forKey:[NSString stringWithFormat:@"%d",squareNumber]];
            }
        }
    }
    NSString *ballScores = [bowlingDelgate calculateScore:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2 - 1]] intValue] secondPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2]] intValue] thirdPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2+1]] intValue] currentFrame:currentFrame];
    NSArray *temp=[ballScores componentsSeparatedByString:@","];
    //update score label
    ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
    CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5000+currentFrame+100];
    frameBaseView.ball1Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
    frameBaseView.ball2Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:1]];
    landscapeFrameBaseView.ball1score=frameBaseView.ball1Score.text;
    landscapeFrameBaseView.ball2score=frameBaseView.ball2Score.text;
    if(currentFrame == 10)
    {
        frameBaseView.ball3Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:2]];
        landscapeFrameBaseView.ball3scoretenthFrame=frameBaseView.ball3Score.text;
    }
    [landscapeFrameBaseView updateText];
}

#pragma mark - Change Throw Method
- (void)changeThrow:(UIButton*)sender
{
    NSLog(@"changeFrame from frame = %d",currentFrame);
    @try {
        if (currentFrame >= 0) {
            int gameOver = 0;
            int latestFrame = currentFrame;
            UILabel *throwLabel=(UILabel*)[pinsBackgroundView viewWithTag:14000];
            UIButton *strikeButton=(UIButton*)[self viewWithTag:12000];
            int squareNumber=2*(currentFrame -1)+(int)currentThrow;
            if(sender.tag == 11000){
                UIButton *nextButton=(UIButton*)[self viewWithTag:11001];
                if(currentThrow == 2){
                    //Previous throw
                    currentThrow=1;
                    throwLabel.text=@"1st Throw";
                    pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                    nextButton.hidden=NO;
                    if(currentFrame != 10){
                        if (currentFrame == 1) {
                            [sender setTitle:@"Previous Frame" forState:UIControlStateNormal];
                            sender.hidden=YES;
                        }
                        else{
                            [sender setTitle:@"Previous Frame" forState:UIControlStateNormal];
                            sender.hidden=NO;
                        }
                        [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                    }
                    else{
                        [sender setTitle:@"Previous Frame" forState:UIControlStateNormal];
                        [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                    }
                    [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                        [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                    }
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                        [bowlingDelgate managePocketBrooklynForIndividualThrows:(int)currentThrow];
                        [self updatePocketBrooklynForFrame:currentFrame];
                        [bowlingDelgate updateBallNameForNextThrow];
                    }
                }
                else if(currentThrow == 3){
                    currentThrow=2;
                    throwLabel.text=@"2nd Throw";
                    pinsBase.frame=CGRectMake(-screenBounds.size.width, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                    [sender setTitle:@"Previous Throw" forState:UIControlStateNormal];
                    if([[pinFallDictionary valueForKey:@"19"] intValue]!=0)
                    {
                        [strikeButton setTitle:@"Spare" forState:UIControlStateNormal];
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                        }
                    }
                    else{
                        [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                        }
                    }
                    nextButton.hidden=NO;
                    [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                        [bowlingDelgate managePocketBrooklynForIndividualThrows:(int)currentThrow];
                        [self updatePocketBrooklynForFrame:currentFrame];
                        [bowlingDelgate updateBallNameForNextThrow];
                    }
                    //            }
                }
                else{
                    //Previous frame
                    //            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                    dispatch_async(queue,
                                   ^{
                                       if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                           if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"] && currentFrame !=10)
                                               [bowlingDelgate checkPreviousState:currentFrame];
                                       }
                                       dispatch_async( dispatch_get_main_queue(), ^{
                                           currentFrame--;
                                       });
                                   });
                    currentThrow=1;
                    pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                     latestFrame=(currentFrame-1);
                    [self updatePinView:latestFrame];
                }
            }
            else{
                UIButton *previousButton=(UIButton*)[self viewWithTag:11000];
                if([previousButton isHidden])
                    previousButton.hidden=NO;
                if(currentThrow == 1){
                    //Next throw
                    if(currentFrame != 10){
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate] || [[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]) {
                            NSLog(@"value=%ld",(long)[[standingPinsMutableArray objectAtIndex:((currentFrame-1)*2)] integerValue]);
                            if([[standingPinsMutableArray objectAtIndex:((currentFrame-1)*2)] integerValue] == 0 )
                            {
                                //Next Frame
                                currentThrow=1;
                                pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                                 latestFrame=(currentFrame+1);
                                [self updatePinView:latestFrame];
                                [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                                }
                                currentFrame++;
                                if(currentFrame > maxFramePlayed)
                                    maxFramePlayed=currentFrame;
                            }
                            else
                            {
                                currentThrow=2;
                                throwLabel.text=@"2nd Throw";
                                pinsBase.frame=CGRectMake(-screenBounds.size.width, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                                [sender setTitle:@"Next Frame" forState:UIControlStateNormal];
                                [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                                [strikeButton setTitle:@"Spare" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                                }
                            }
                        }
                        else{
                            if([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue] == 0 )
                            {
                                //Next Frame
                                currentThrow=1;
                                pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                                 latestFrame=(currentFrame+1);
                                [self updatePinView:latestFrame];
                                [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                                }
                                //  do the long running work in bg async queue
                                // within that, call to update UI on main thread.
                                dispatch_async(queue,
                                               ^{
                                                   if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                                       if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
                                                           [bowlingDelgate checkPreviousState:currentFrame];
                                                   }
                                                   
                                                   dispatch_async(main, ^{
                                                       currentFrame++;
                                                       if(currentFrame > maxFramePlayed)
                                                           maxFramePlayed=currentFrame;
                                                   });
                                               });
                            }
                            else
                            {
                                currentThrow=2;
                                throwLabel.text=@"2nd Throw";
                                pinsBase.frame=CGRectMake(-screenBounds.size.width, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                                [sender setTitle:@"Next Frame" forState:UIControlStateNormal];
                                [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                                [strikeButton setTitle:@"Spare" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                                }
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                                    [bowlingDelgate managePocketBrooklynForIndividualThrows:(int)currentThrow];
                                    [self updatePocketBrooklynForFrame:currentFrame];
                                    [bowlingDelgate updateBallNameForNextThrow];
                                }
                            }
                        }
                        
                        
                    }
                    else{
                        currentThrow=2;
                        throwLabel.text=@"2nd Throw";
                        pinsBase.frame=CGRectMake(-screenBounds.size.width, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                        
                        [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"]) {
                            if(currentThrow == 3 || !([[pinFallDictionary valueForKey:@"19"] intValue]==0 || [[pinFallDictionary valueForKey:@"20"] intValue]==0)){
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                                    sender.hidden=YES;
                                }
                                else
                                {
                                    [sender setTitle:@"Done" forState:UIControlStateNormal];
                                    
                                }
                            }
                            else{
                                [sender setTitle:@"Next Throw" forState:UIControlStateNormal];
                            }
                            if([[pinFallDictionary valueForKey:@"19"] intValue]!=0)
                            {
                                [strikeButton setTitle:@"Spare" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                                }
                            }
                            else{
                                [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                                }
                            }
                        }
                        else{
                            if(currentThrow == 3 || !([[standingPinsMutableArray objectAtIndex:18] intValue]==0 || [[standingPinsMutableArray objectAtIndex:19] intValue]==0)){
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                                    sender.hidden=YES;
                                }
                                else
                                {
                                    [sender setTitle:@"Done" forState:UIControlStateNormal];
                                    
                                }
                            }
                            else{
                                [sender setTitle:@"Next Throw" forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]&& !([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView])) {
                            [bowlingDelgate managePocketBrooklynForIndividualThrows:(int)currentThrow];
                            [self updatePocketBrooklynForFrame:currentFrame];
                            [bowlingDelgate updateBallNameForNextThrow];
                        }
                    }
                }
                else if(currentThrow == 2){
                    //Next throw
                    if(currentFrame == 10){
                        
                        if(([[pinFallDictionary valueForKey:@"19"] intValue]!=0 && [[pinFallDictionary valueForKey:@"20"] intValue]!=0)){
                            //Done Function
                            gameOver=1;
//                            if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
//                                return;
//                            }
//                            else{
                                if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"]){
                                        ScoreFrameImageView *frameScoreView=(ScoreFrameImageView*)[self viewWithTag:5010];
                                        CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5110];
                                        if ([frameScoreView.ball1Score.text isEqualToString:@""]) {
                                            frameScoreView.ball1Score.text=@"0";
                                        }
                                        if ([frameScoreView.ball2Score.text isEqualToString:@""] && ![frameScoreView.ball1Score.text isEqualToString:@"X"]) {
                                            frameScoreView.ball2Score.text=@"0";
                                        }
                                        if ([frameScoreView.ball3Score.text isEqualToString:@""]&& ([frameScoreView.ball2Score.text isEqualToString:@"X"] || [frameScoreView.ball2Score.text isEqualToString:@"/"])) {
                                            frameScoreView.ball3Score.text=@"0";
                                        }
                                        landscapeFrameBaseView.ball1score=frameScoreView.ball1Score.text;
                                        landscapeFrameBaseView.ball2score=frameScoreView.ball2Score.text;
                                        landscapeFrameBaseView.ball3scoretenthFrame=frameScoreView.ball3Score.text;
                                        [landscapeFrameBaseView updateText];
                                        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                                        //  do the long running work in bg async queue
                                        // within that, call to update UI on main thread.
                                        dispatch_async(queue,
                                                       ^{
                                                           if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
                                                           {
                                                               Reachability * reach = [Reachability reachabilityForInternetConnection];
                                                               NetworkStatus netStatus = [reach currentReachabilityStatus];
                                                               if (netStatus == NotReachable)
                                                               {
                                                                   dispatch_async( dispatch_get_main_queue(), ^{
                                                                       [[DataManager shared]removeActivityIndicator];
                                                                       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                                       [alert show];
                                                                       alert=nil;
                                                                   });
                                                               }
                                                               else
                                                               {
                                                                   [bowlingDelgate checkPreviousState:currentFrame];
                                                               }
                                                           }
                                                           dispatch_async(main, ^{
                                                               
                                                           });
                                                       });
                                    }
                                }
//                            }
                        }
                        else{
                            if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate] || [[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                                sender.hidden=YES;
                            }
                            else
                            {
                                [sender setTitle:@"Done" forState:UIControlStateNormal];
                            }
                            [previousButton setTitle:@"Previous Throw" forState:UIControlStateNormal];
                            currentThrow=3;
                            throwLabel.text=@"3rd Throw";
                            pinsBase.frame=CGRectMake(-screenBounds.size.width*2, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                            if (![[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]) {
                                for (int i = 1; i <= 10; i++) {
                                    UIImageView *pin=(UIImageView *)[self viewWithTag:300+i];
                                    pin.hidden=NO;
                                }
                            }
                            if([[pinFallDictionary valueForKey:@"19"] intValue]==0){
                                if([[pinFallDictionary valueForKey:@"20"] intValue]==0 || [[pinFallDictionary valueForKey:@"20"] intValue]== 1023){
                                    [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                        [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                                    }
                                }
                                else{
                                    [strikeButton setTitle:@"Spare" forState:UIControlStateNormal];
                                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                        [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                                    }
                                }
                            }
                            else{
                                [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                                if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                                }
                            }
                        }
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                            [bowlingDelgate managePocketBrooklynForIndividualThrows:(int)currentThrow];
                            [self updatePocketBrooklynForFrame:currentFrame];
                            [bowlingDelgate updateBallNameForNextThrow];
                        }
                    }
                    else{
                        //  do the long running work in bg async queue
                        // within that, call to update UI on main thread.
                        dispatch_async(queue,
                                       ^{
                                           if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                               if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
                                                   [bowlingDelgate checkPreviousState:currentFrame];
                                           }
                                           
                                           dispatch_async(main, ^{
                                               currentFrame++;
                                               if(currentFrame > maxFramePlayed)
                                                   maxFramePlayed=currentFrame;
                                           });
                                       });
                        
                        currentThrow=1;
                        pinsBase.frame=CGRectMake(0, pinsBase.frame.origin.y, pinsBase.frame.size.width, pinsBase.frame.size.height);
                        latestFrame=currentFrame+1;
                        [self updatePinView:latestFrame];
                        [previousButton setTitle:@"Previous Frame" forState:UIControlStateNormal];
                        [strikeButton setTitle:@"Strike" forState:UIControlStateNormal];
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                        }
                    }
                    
                }
                else
                {
                    //Current Throw=3
                    if(currentFrame == 10)
                    {
                        //Done Function
                        gameOver=1;
//                        if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
//                            return;
//                        }
//                        else{
                            if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"]){
                                    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                                    ScoreFrameImageView *frameScoreView=(ScoreFrameImageView*)[self viewWithTag:5010];
                                    CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5110];
                                    if ([frameScoreView.ball1Score.text isEqualToString:@""]) {
                                        frameScoreView.ball1Score.text=@"0";
                                    }
                                    if ([frameScoreView.ball2Score.text isEqualToString:@""] && ![frameScoreView.ball1Score.text isEqualToString:@"X"]) {
                                        frameScoreView.ball2Score.text=@"0";
                                    }
                                    if ([frameScoreView.ball3Score.text isEqualToString:@""]&& ([frameScoreView.ball2Score.text isEqualToString:@"X"] || [frameScoreView.ball2Score.text isEqualToString:@"/"])) {
                                        frameScoreView.ball3Score.text=@"0";
                                    }
                                    landscapeFrameBaseView.ball1score=frameScoreView.ball1Score.text;
                                    landscapeFrameBaseView.ball2score=frameScoreView.ball2Score.text;
                                    landscapeFrameBaseView.ball3scoretenthFrame=frameScoreView.ball3Score.text;
                                    [landscapeFrameBaseView updateText];
                                    
                                    //  do the long running work in bg async queue
                                    // within that, call to update UI on main thread.
                                    dispatch_async(queue,
                                                   ^{
                                                       if (![[NSUserDefaults standardUserDefaults] boolForKey:kliveScoreUpdate]) {
                                                           if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Manual"])
                                                           {
                                                               Reachability * reach = [Reachability reachabilityForInternetConnection];
                                                               NetworkStatus netStatus = [reach currentReachabilityStatus];
                                                               if (netStatus == NotReachable)
                                                               {
                                                                   dispatch_async( dispatch_get_main_queue(), ^{
                                                                       [[DataManager shared]removeActivityIndicator];
                                                                       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                                       [alert show];
                                                                       alert=nil;
                                                                   });
                                                               }
                                                               else
                                                               {
                                                                   [bowlingDelgate checkPreviousState:currentFrame];
                                                               }
                                                           }
                                                           
                                                       }
                                                       dispatch_async(main, ^{
                                                       });
                                                   });
                                }
                            }
//                        }
                        
                    }
                    
                }
            }
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
                if (gameOver !=1) {
                    [self updateCursorForFSEMmodeForFrame:latestFrame];
                    gameOver=0;
                }
            }
        }
       
    }
    @catch (NSException *exception) {
        
    }

}

- (void)markStrikeOrFoul:(UIButton *)sender
{
    NSLog(@"markStrikeOrFoul sender=%@",sender);
    if(sender.tag == 12000){
        UIButton *nextButton=(UIButton*)[self viewWithTag:11001];
        int squareNumber=2*(currentFrame -1)+(int)currentThrow;
        NSLog(@"squareNumber=%d",squareNumber);
        [pinFallDictionary setValue:@"0" forKey:[NSString stringWithFormat:@"%d",squareNumber]];
        if([sender.titleLabel.text isEqualToString:@"Strike"]){
             //strike
            if(squareNumber<19){
              [pinFallDictionary setValue:@"0" forKey:[NSString stringWithFormat:@"%d",squareNumber+1]];
              [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
                for (int i = 1; i <= 10; i++) {
                    UIImageView *pin2 = (UIImageView *)[self viewWithTag:2*100+i];
                    [pin2  setImage:[UIImage imageNamed:@"pin_down.png"]];
                    [pin2 setAccessibilityIdentifier:@"pin_down"] ;
                }
            }
            else if (squareNumber == 19) {
                [pinFallDictionary setValue:@"1023" forKey:@"20"];
                for (int i = 1; i <= 10; i++) {
                    UIImageView *pin2 = (UIImageView *)[self viewWithTag:2*100+i];
                    [pin2  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [pin2 setAccessibilityIdentifier:@"bowling_pin"] ;
                }
            } else if (squareNumber == 20) {
                [pinFallDictionary setValue:@"1023" forKey:@"21"];
                for (int i = 1; i <= 10; i++) {
                    UIImageView *pin2 = (UIImageView *)[self viewWithTag:3*100+i];
                    [pin2  setImage:[UIImage imageNamed:@"bowling_pin.png"]];
                    [pin2 setAccessibilityIdentifier:@"bowling_pin"] ;
                }
            }
        }
        else if([sender.titleLabel.text isEqualToString:@"Spare"]){
            //spare
            if (currentFrame == 10) {
                BOOL temp = ([[pinFallDictionary valueForKey:@"19"] intValue] == 0)
                || ([[pinFallDictionary valueForKey:@"20"] intValue] == 0);
                if(temp && currentThrow!=3){
                    [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
                }
                else{
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:kliveScoreUpdate]) {
                        nextButton.hidden=YES;
                    }
                    else
                    {
                        if ([nextButton isHidden]) {
                            nextButton.hidden=NO;
                        }
                        [nextButton setTitle:@"Done" forState:UIControlStateNormal];
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"]||[[NSUserDefaults standardUserDefaults]boolForKey:kInGameHistoryView]) {
                            nextButton.hidden=YES;
                        }
                    }
                }
            }
        }
        for (int i = 1; i <= 10; i++) {
            // change pin images
            UIImageView *pin = (UIImageView *)[self viewWithTag:currentThrow*100+i];
            [pin  setImage:[UIImage imageNamed:@"pin_down.png"]];
            [pin setAccessibilityIdentifier:@"pin_down"] ;
            
            
        }
        NSString *ballScores = [bowlingDelgate calculateScore:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2 - 1]] intValue] secondPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2]] intValue] thirdPins:[[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",currentFrame*2+1]] intValue] currentFrame:currentFrame];
        NSArray *temp=[ballScores componentsSeparatedByString:@","];
        //update score label
        ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
        frameBaseView.ball1Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
        frameBaseView.ball2Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:1]];

        if(currentFrame == 10)
            frameBaseView.ball3Score.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:2]];

        CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5000+100+currentFrame];
        landscapeFrameBaseView.ball1score=frameBaseView.ball1Score.text;
        landscapeFrameBaseView.ball2score=frameBaseView.ball2Score.text;
        landscapeFrameBaseView.ball3scoretenthFrame=frameBaseView.ball3Score.text;
        [landscapeFrameBaseView updateText];
    }
    else{
        //for foul
    }
}

- (void)selectBallType:(UIButton*)sender
{
    
}

- (void)markPocketOrBrooklyn:(UIButton*)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        UIButton *btn=[[UIButton alloc]init];
        [bowlingDelgate pocketBrooklynFunction:btn];
        return;
    }
    else{
        sender.selected=YES;
    }
    if(sender.tag == 13000){
        //for pocket
        RoundedRectButton *brooklynBtn=(RoundedRectButton *)[self viewWithTag:13001];
        [brooklynBtn setSelected:NO];
    }
    else{
        //for brooklyn
        RoundedRectButton *pocketBtn=(RoundedRectButton *)[self viewWithTag:13000];
        [pocketBtn setSelected:NO];
    }
    [bowlingDelgate pocketBrooklynFunction:sender];
}

#pragma mark - Enter Challenge
- (void)showChallengeView:(UIButton*)sender
{
    [bowlingDelgate showChallengeView];
}

- (void)endGame
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    maxFramePlayed=1;
    if([timerforMyGameUpdateView isValid])
    {
        [timerforMyGameUpdateView invalidate];
        timerforMyGameUpdateView=nil;
    }
    [bowlingDelgate endGame];
    [[DataManager shared]removeActivityIndicator];
    
}

#pragma mark - Game Summary
- (void)gameSummaryButtonFunction:(UIButton *)sender
{
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
            [self gameSummaryView:responseDict challengesArray:[challengesJson objectForKey:kResponseString]];
        }
        else{
            [self gameSummaryView:responseDict challengesArray:[[NSArray alloc] init]];
        }
    }
    else{
        [[DataManager shared] removeActivityIndicator];
    }
}

- (void)gameSummaryView:(NSDictionary *)summaryDict challengesArray:(NSArray *)array
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
        scoreView.hidden=NO;
    }
    showingGameSummary=YES;
    NSLog(@"summaryDict=%@",summaryDict);
    [pinsBackgroundView setHidden:YES];
    RoundedRectButton *strikeButton=(RoundedRectButton *)[self viewWithTag:12000];
    RoundedRectButton *pocketButton=(RoundedRectButton *)[self viewWithTag:13000];
    RoundedRectButton *brooklynButton=(RoundedRectButton *)[self viewWithTag:13001];
    strikeButton.hidden=YES;
    pocketButton.hidden=YES;
    brooklynButton.hidden=YES;
    ballTypeButton.hidden=YES;
    if (summaryView) {
        [summaryView removeFromSuperview];
        summaryView=nil;
    }
    if (scoreView) {
        scoreView.hidden=YES;
    }
    UIButton *bowlingButton=(UIButton*)[self viewWithTag:15001];
    if (![bowlingButton isHidden]) {
        bowlingButton.hidden=YES;
    }
    if ([[NSUserDefaults standardUserDefaults]integerForKey:kgameComplete] == 0) {
         summaryView=[[GameSummaryView alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86+143 currentSuperviewDeviceSize:screenBounds.size.height],screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:446.2 currentSuperviewDeviceSize:screenBounds.size.height])];
        
      
    }
    else
    {
        UIButton *challengeButton=(UIButton*)[self viewWithTag:15000];
        challengeButton.hidden=YES;
        summaryView=[[GameSummaryView alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86+143 currentSuperviewDeviceSize:screenBounds.size.height],screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1475/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    }
    summaryView.backgroundColor=[UIColor clearColor];
    summaryView.summaryDelegate=self;
    [self addSubview:summaryView];
    [summaryView createMainView:summaryDict challengesArray:array];
    
}

- (void)removeGameSummary
{
    showingGameSummary=NO;
    pinsBackgroundView.hidden=NO;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
        scoreView.hidden=NO;
    }
    else{
        pinsBase.hidden=NO;
        RoundedRectButton *strikeButton=(RoundedRectButton *)[self viewWithTag:12000];
        RoundedRectButton *pocketButton=(RoundedRectButton *)[self viewWithTag:13000];
        RoundedRectButton *brooklynButton=(RoundedRectButton *)[self viewWithTag:13001];
        if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType]] isEqualToString:@"Machine"]) {
            strikeButton.hidden=YES;
        }
        else{
            strikeButton.hidden=NO;
        }
        pocketButton.hidden=NO;
        brooklynButton.hidden=NO;
        ballTypeButton.hidden=NO;
 
    }
    if ([[NSUserDefaults standardUserDefaults]integerForKey:kgameComplete] == 1) {
        UIButton *bowlingButton=(UIButton*)[self viewWithTag:15001];
        bowlingButton.hidden=NO;
    }
   else
   {
       UIButton *challengeButton=(UIButton*)[self viewWithTag:15000];
       challengeButton.hidden=NO;
   }
    [summaryView removeFromSuperview];
    summaryView=nil;
    [bowlingDelgate updateRightMenu];
}

#pragma mark - Game Summary Delegate
- (void)updateTags:(NSString *)edittedTags
{
    [bowlingDelgate updateTagForPostedGame:edittedTags];
}

- (void)bowlAgainFunction
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInFSEMView];
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    maxFramePlayed=0;
    [self removeGameSummary];
    UIButton *bowlingButton=(UIButton*)[self viewWithTag:15001];
    bowlingButton.hidden=YES;
    UIButton *challengeButton=(UIButton*)[self viewWithTag:15000];
    challengeButton.hidden=NO;
    [bowlingDelgate startNewGame];

}

- (void)fbScorePost
{
    [bowlingDelgate postOnFacebook];
}

#pragma mark - FSEM
- (void)fastScoreEntryModeView:(int)showOrHide
{
    RoundedRectButton *strikeButton=(RoundedRectButton *)[self viewWithTag:12000];
    RoundedRectButton *pocketButton=(RoundedRectButton *)[self viewWithTag:13000];
    RoundedRectButton *brooklynButton=(RoundedRectButton *)[self viewWithTag:13001];
    if (showOrHide == 0) {
        //Show FSEM View
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kInFSEMView];
        pinsBackgroundView.hidden=NO;
        pinsBase.hidden=YES;
        ballTypeButton.hidden=YES;
        strikeButton.hidden=YES;
        pocketButton.hidden=YES;
        brooklynButton.hidden=YES;
        if (summaryView) {
            [summaryView removeFromSuperview];
            summaryView=nil;
        }
        [scoreView removeFromSuperview];
        scoreView = nil;
        scoreView=[[FSEMView alloc]initWithFrame:CGRectMake(0, pinsBackgroundView.frame.origin.y+pinsBase.frame.origin.y, self.frame.size.width, 290)];
        scoreView.delegate=self;
        scoreView.userInteractionEnabled=YES;
        [self addSubview:scoreView];
        for(int i=0;i<10;i++){
            ScoreFrameImageView *scoreFrame=(ScoreFrameImageView *)[self viewWithTag:5000+i+1];
            scoreFrame.ball1Score.userInteractionEnabled=YES;
            scoreFrame.ball2Score.userInteractionEnabled=YES;
            scoreFrame.ball3Score.userInteractionEnabled=YES;
            UIView *overlay1 = [[UIView alloc] init];
            overlay1.backgroundColor=[UIColor clearColor];
            overlay1.userInteractionEnabled=YES;
            [overlay1 setFrame:scoreFrame.ball1Score.frame];
            [scoreFrame addSubview:overlay1];
            
            UIView *overlay2 = [[UIView alloc] init];
            overlay2.backgroundColor=[UIColor clearColor];
            overlay2.userInteractionEnabled=YES;
            [overlay2 setFrame:scoreFrame.ball2Score.frame];
            [scoreFrame addSubview:overlay2];
            
            UIView *overlay3 = [[UIView alloc] init];
            overlay3.backgroundColor=[UIColor clearColor];
            overlay3.userInteractionEnabled=YES;
            [overlay3 setFrame:scoreFrame.ball3Score.frame];
            [scoreFrame addSubview:overlay3];

        }

        [self performSelector:@selector(setUpFSEMscorepad) withObject:nil afterDelay:1.0];
//        [self updateCursorForFSEMmodeForFrame:currentFrame];
        
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Fast Score Entry Mode lets you quickly type your scores into XBowling. \nFast entry skips recording which specific pins you hit, what ball you are using, and pocket/brooklyn details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInFSEMView];
        pinsBase.hidden=NO;
        ballTypeButton.hidden=NO;
        strikeButton.hidden=NO;
        pocketButton.hidden=NO;
        brooklynButton.hidden=NO;
        [scoreView removeFromSuperview];
        [self updatePinView:currentFrame];
        if (![summaryView isHidden] && [summaryView isDescendantOfView:self]) {
            [pinsBackgroundView setHidden:YES];
            strikeButton.hidden=YES;
            pocketButton.hidden=YES;
            brooklynButton.hidden=YES;
            ballTypeButton.hidden=YES;
        }
        for(int i=0;i<10;i++){
            ScoreFrameImageView *scoreFrame=(ScoreFrameImageView *)[self viewWithTag:5000+i+1];
            scoreFrame.ball1Score.userInteractionEnabled=NO;
            scoreFrame.ball2Score.userInteractionEnabled=NO;
            scoreFrame.ball3Score.userInteractionEnabled=NO;
            if ([scoreFrame isFirstResponder]) {
                [scoreFrame resignFirstResponder];
            }
        }
    }
}

- (void)setUpFSEMscorepad
{
    [self updateCursorForFSEMmodeForFrame:currentFrame];
    ScoreFrameImageView *frameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
    if (currentFrame == 10) {
        if (currentThrow == 1) {
            [frameBaseView.ball1Score becomeFirstResponder];
            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
        }
        else if (currentThrow == 2){
            if([[pinFallDictionary valueForKey:@"19"] intValue]!=0)
            {
                [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
            }
            else{
                [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
            }
        }
        else{
            if([[pinFallDictionary valueForKey:@"19"] intValue]==0){
                if([[pinFallDictionary valueForKey:@"20"] intValue]==0){
                        [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
                }
                else{
                        [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
                }
            }
            else{
                    [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
            }
        }
    }
    else{
        if (currentThrow == 1) {
            [frameBaseView.ball1Score becomeFirstResponder];
            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];
        }
        else{
            [frameBaseView.ball2Score becomeFirstResponder];
            [scoreView updateStrikeOrSpareBasedOnCurrentThrow:@"disableStrike"];
        }
    }
   
    
}

- (void)updateCursorForFSEMmodeForFrame:(int)frameNumber
{
    
     [self endEditing:YES];
     ScoreFrameImageView *frameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+frameNumber];
    NSString *score;
    if (currentFrame == 10) {
        if (currentThrow == 1) {
            [frameBaseView.ball1Score becomeFirstResponder];
            score=frameBaseView.ball1Score.text;
        }
        else if(currentThrow > 1){
          
            score=frameBaseView.ball2Score.text;
            if (currentThrow == 2) {
                 [frameBaseView.ball2Score becomeFirstResponder];
            }
            else
            {
                 [frameBaseView.ball3Score becomeFirstResponder];
            }
        }

    }
    else{
        score=frameBaseView.ball1Score.text;
        if (currentThrow == 1) {
            if ( [frameBaseView.ball2Score isFirstResponder]) {
                [frameBaseView.ball2Score resignFirstResponder];
            }
            [frameBaseView.ball1Score becomeFirstResponder];
        }
        else if(currentThrow == 2){
            if ( [frameBaseView.ball1Score isFirstResponder]) {
                [frameBaseView.ball1Score resignFirstResponder];
            }
            [frameBaseView.ball2Score becomeFirstResponder];
        }
    }
    if (currentThrow == 2 && frameBaseView.ball2Score.text.length > 0) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showScoreForSecondThrow"];
        [[NSUserDefaults standardUserDefaults]setValue:frameBaseView.ball2Score.text forKey:@"secondThrowScore"];
    }
    if (frameNumber == 10 && [frameBaseView.ball2Score.text isEqualToString:@"/"]) {
        if (currentThrow == 2) {
             score=frameBaseView.ball1Score.text;
        }
        else if (currentThrow == 3)
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showScoreForThirdThrow"];
            [[NSUserDefaults standardUserDefaults]setValue:frameBaseView.ball3Score.text forKey:@"thirdThrowScore"];
        }
       
    }
    [scoreView updateScoreFrameBasedOnPreviousThrowScore:score currentFrame:frameNumber currentThrow:currentThrow];
}

#pragma  mark FSEM delegate methods
- (void)selectedScore:(NSString *)score
{
    UIButton *nextButton=(UIButton*)[self viewWithTag:11001];
    int  squareNumber = currentFrame * 2;
    ScoreFrameImageView *frameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
    CoachScoreFrameView *landscapeFrameBaseView = (CoachScoreFrameView*)[self viewWithTag:5000+currentFrame+100];

    if (currentThrow == 1) {
        if ([[pinFallDictionary valueForKey:[NSString stringWithFormat:@"%d",squareNumber]] intValue]==0) {
            [nextButton setTitle:@"Next Frame" forState:UIControlStateNormal];
            [self updatePinView:currentFrame];
        }
        else{
            [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
        }
        frameBaseView.ball1Score.text=[NSString stringWithFormat:@"%@",score];
        frameBaseView.ball2Score.text=@"0";
        frameBaseView.ball3Score.text=@"";
        [self toBinary:currentFrame ball1:frameBaseView.ball1Score.text ball2:frameBaseView.ball2Score.text ball3:@""];
        [self changeThrow:nextButton];
        [frameBaseView.ball2Score becomeFirstResponder];
        [scoreView updateScoreFrameBasedOnPreviousThrowScore:score currentFrame:currentFrame currentThrow:currentThrow];
        landscapeFrameBaseView.ball1score=frameBaseView.ball1Score.text;

    }
    else if(currentThrow == 2){
        frameBaseView.ball2Score.text=[NSString stringWithFormat:@"%@",score];
        landscapeFrameBaseView.ball2score=frameBaseView.ball2Score.text;
          frameBaseView.ball3Score.text=@"";
        if (currentFrame == 10) {
             [self toBinary:currentFrame ball1:frameBaseView.ball1Score.text ball2:frameBaseView.ball2Score.text ball3:@""];
            if([[pinFallDictionary valueForKey:@"19"] intValue]!=0 && [[pinFallDictionary valueForKey:@"20"] intValue]!=0){
                //Do nothing
                [nextButton setTitle:@"Done" forState:UIControlStateNormal];
//                if ([[standingPinsMutableArray objectAtIndex:19] intValue]==0) {
//                    
//                }
//                else{
//                   [nextButton setTitle:@"Next Throw" forState:UIControlStateNormal];
//                }
            }
            else{
                //Change throw
                [self changeThrow:nextButton];
            }
        }
        else{
            [self toBinary:currentFrame ball1:frameBaseView.ball1Score.text ball2:frameBaseView.ball2Score.text ball3:@""];
             [self changeThrow:nextButton];
            ScoreFrameImageView *nextFrameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame+1];
            [nextFrameBaseView.ball1Score becomeFirstResponder];
        }
    }
    else{
        if(currentFrame == 10){
            frameBaseView.ball3Score.text=[NSString stringWithFormat:@"%@",score];
            landscapeFrameBaseView.ball3scoretenthFrame=frameBaseView.ball3Score.text;
            [self toBinary:currentFrame ball1:frameBaseView.ball1Score.text ball2:frameBaseView.ball2Score.text ball3:frameBaseView.ball3Score.text];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showScoreForThirdThrow"];
            [[NSUserDefaults standardUserDefaults]setValue:frameBaseView.ball3Score.text forKey:@"thirdThrowScore"];
             [scoreView updateScoreFrameBasedOnPreviousThrowScore:score currentFrame:currentFrame currentThrow:currentThrow];
        }
    }
    [landscapeFrameBaseView updateText];
}

- (void)deleteScoreEntry
{
    
    if (currentFrame > 1) {
        [self endEditing:YES];
        UIButton *previousButton=(UIButton*)[self viewWithTag:11000];
        [self changeThrow:previousButton];
    }
    else if(currentFrame == 1){
        if (currentThrow == 2) {
            [self endEditing:YES];
            UIButton *previousButton=(UIButton*)[self viewWithTag:11000];
            [self changeThrow:previousButton];
        }
    }

//    NSString *score;
//    ScoreFrameImageView *frameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];
//    if (currentThrow == 1) {
//        [frameBaseView.ball1Score becomeFirstResponder];
//        score=frameBaseView.ball1Score.text;
//    }
//    else if (currentThrow == 2){
//            [frameBaseView.ball2Score becomeFirstResponder];
//            score=frameBaseView.ball2Score.text;
//    }
//    else{
//        [frameBaseView.ball3Score becomeFirstResponder];
//         score=frameBaseView.ball3Score.text;
//    }
//    [scoreView updateScoreFrameBasedOnPreviousThrowScore:score currentFrame:currentFrame currentThrow:currentThrow];
}

- (void)markStrikeOrSpare:(NSString *)value
{
    RoundedRectButton *tempStrikeSpareButton=(RoundedRectButton *)[self viewWithTag:12000];
    if ([value isEqualToString:@"X STRIKE"]) {
       [tempStrikeSpareButton setTitle:@"Strike" forState:UIControlStateNormal];
        if (currentFrame < 10) {
            currentThrow=1;
        }
        else{
            
        }
    }
    else
    {
        [tempStrikeSpareButton setTitle:@"Spare" forState:UIControlStateNormal];
        if (currentFrame < 10) {
            currentThrow=2;
        }
    }
    NSLog(@"markStrikeOrSpare throw=%ld frame=%d",(long)currentThrow,currentFrame);
    [self markStrikeOrFoul:tempStrikeSpareButton];
    tempStrikeSpareButton=nil;
    ScoreFrameImageView *nextFrameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame];

        UIButton *nextButton=(UIButton*)[self viewWithTag:11001];
        if (currentFrame == 10) {
            if (currentThrow == 1) {
                [self changeThrow:nextButton];
                [nextFrameBaseView.ball2Score becomeFirstResponder];
            }
            else if (currentThrow == 2) {
                [self changeThrow:nextButton];
                [nextFrameBaseView.ball3Score becomeFirstResponder];
            }
            else{
                if ([value isEqualToString:@"X STRIKE"]) {
                    [scoreView updateScoreFrameBasedOnPreviousThrowScore:@"X" currentFrame:currentFrame currentThrow:currentThrow];
                }
                else{
                    [scoreView updateScoreFrameBasedOnPreviousThrowScore:@"/" currentFrame:currentFrame currentThrow:currentThrow]; 
                }
                
            }
        }
        else{
            [self changeThrow:nextButton];
            ScoreFrameImageView *nextFrameBaseView = (ScoreFrameImageView*)[self viewWithTag:5000+currentFrame+1];
            [nextFrameBaseView.ball1Score becomeFirstResponder];
        }
}

-(void)toBinary:(int)frameCount ball1:(NSString *)throw1 ball2:(NSString *)throw2 ball3:(NSString *)throw3
{
    NSLog(@"throw1=%@ throw2=%@ throw3=%@",throw1,throw2,throw3);
    int score1 = [self getPinsCount:throw1];
    int num = 0;
    for (int i = 10; i > score1; i--)
    {
        num |= 1 << (i-1);
    }
    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",num] forKey:[NSString stringWithFormat:@"%d",frameCount * 2 - 1]];
    
    int score2;
    if ([throw2 isEqualToString:@"/"]) {
        score2 = 10;
    } else {
        score2 = [self getPinsCount:throw2];
    }
    if(currentFrame == 10)
    {
        if([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] != 0)
            score2 += score1;
    }
    else
    {
        score2 += score1;
    }
    num = 0;
    for (int i = 10; i > score2; i--)
    {
        num |= 1 << (i-1);
    }
    [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",num] forKey:[NSString stringWithFormat:@"%d",frameCount * 2]];
    
    if (frameCount == 10) {
        
        int score3 = [self getPinsCount:throw3];
        if([[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",20]] integerValue] != 0 && [[pinFallDictionary objectForKey:[NSString stringWithFormat:@"%d",19]] integerValue] == 0)
        {
            if([throw3 isEqualToString:@"/"])
                score3 = 10;
            else
                score3 += score2;
        }
        num = 0;
        for (int i = 10; i > score3; i--) {
            num |= 1 << (i-1);
        }
        [pinFallDictionary setValue:[NSString stringWithFormat:@"%d",num] forKey:[NSString stringWithFormat:@"%d",frameCount * 2 + 1]];
    }
    NSLog(@"pinFallDictionary toBinary():%@",pinFallDictionary);
    
}

-(int)getPinsCount:(NSString *)score
{
    int pinCount;
    if ([score isEqualToString:@"X"]) {
        pinCount = 10;
    } else if ([score isEqualToString:@"F"] || [score isEqualToString:@"/"] || [score isEqualToString:@""]) {
        pinCount = 0;
    } else {
        pinCount = [score intValue];
    }
    return pinCount;
}

    
@end
