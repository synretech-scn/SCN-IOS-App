//
//  ChallengesViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ChallengesViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface ChallengesViewController ()

@end

@implementation ChallengesViewController
{
    ChallengesMainView *mainView;
     OpponentSelectionView *opponentView;
    LevelSelectionView *levelView;
    AddOpponentsView *addOpponentsView;
    NSString *urlStringForChallengers;
    NSString *challengeType;
    H2HLiveBaseView *h2hLiveBase;
    H2HLiveCreateGameView *createGameView;
    NSTimer *h2hLiveTimer;
    UIWebView *mainWebView;
    UIView *footerViewForWebview;
    id<GAITracker> tracker;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    tracker = [[GAI sharedInstance] defaultTracker];
    // Do any additional setup after loading the view.
  
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kh2hViewFlow]) {
        if (![mainView isDescendantOfView:self.view]) {
            [self createMainView];
        }
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kh2hViewFlow];
    }
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kshowOpponentsForH2HPosted]) {
        [opponentView removeFromSuperview];
        [addOpponentsView removeFromSuperview];
         [self showH2HPostedView];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kshowOpponentsForH2HPosted];
    }
    if (opponentView) {
        [opponentView reloadOpponentsTable];
    }
}
- (void)createMainView
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"bowlingchallenge/results"];
    NSDictionary *challengesJson = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"gameId=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId]] url:urlString contentType:@"" httpMethod:@"GET"];
    [[DataManager shared] removeActivityIndicator];
    if ([[challengesJson objectForKey:kResponseStatusCode] integerValue] == 200) {
        if ([[challengesJson objectForKey:kResponseString] count]>0) {
            for (int i=0; i<[[challengesJson objectForKey:kResponseString] count]; i++) {
                NSString *challengeName=[[[[challengesJson objectForKey:kResponseString] objectAtIndex:i] objectForKey:@"challenge"] objectForKey:@"name"];
                NSRange liveRange = [challengeName rangeOfString:@"Live" options:NSCaseInsensitiveSearch];
                if(liveRange.location != NSNotFound)
                {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kenteredH2HLive];
                }
                NSRange postedRange = [challengeName rangeOfString:@"Posted" options:NSCaseInsensitiveSearch];
                if(postedRange.location != NSNotFound)
                {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kenteredH2HPosted];
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
            }
        }
    }
    [[DataManager shared]removeActivityIndicator];
    mainView=[[ChallengesMainView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainView.delegate=self;
    [mainView createChallengeView];
    [self.view addSubview:mainView];

}
#pragma mark - H2H Live Methods

- (void)showH2HLiveView
{
    [h2hLiveBase removeFromSuperview];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kliveCompetitionId] != nil ) {
        NSLog(@"%@%@",kliveCompetitionId, [[NSUserDefaults standardUserDefaults] objectForKey:kliveCompetitionId]);
        [self performSelector:@selector(h2hLiveView) withObject:nil afterDelay:0.02];
    }
    else {
        h2hLiveBase=[[H2HLiveBaseView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        h2hLiveBase.delegate=self;
        [self.view addSubview:h2hLiveBase];
        [h2hLiveBase displayH2HLiveStatus:@"NotJoined"];
    }
}

-(void)h2hLiveView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self getH2HLive];
    if([h2hLiveTimer isValid])
    {
        [h2hLiveTimer invalidate];
        h2hLiveTimer=nil;
    }
    h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(getH2HLive) userInfo:nil repeats:YES];

}
- (void)joinGame
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/live/available?bowlingGameId=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],  APIKey, token];
    
    NSLog(@"urlString %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:kTimeoutInterval];
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        challengeType=@"H2HLive";
        opponentView=[[OpponentSelectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        opponentView.delegate=self;
        [opponentView displayPlayers:jsonArray searchString:@"" showingFreinds:0 challengeType:@"H2HLive"];
        [self.view addSubview:opponentView];
        [[DataManager shared]removeActivityIndicator];
    }
}

- (void)createGame
{
    [createGameView removeFromSuperview];
    createGameView=[[H2HLiveCreateGameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    createGameView.delegate=self;
    [self.view addSubview:createGameView];
}

- (void)removeh2hBaseView
{
    if ([h2hLiveTimer isValid]) {
        [h2hLiveTimer invalidate];
    }
    [h2hLiveBase removeFromSuperview];
    if (![mainView isDescendantOfView:self.view]) {
        [self createMainView];
    }
}

-(void)getH2HLive{
    
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString;
        urlString = [NSString stringWithFormat:@"%@bowlingcompetition/live/%@/challengers?apiKey=%@&token=%@", serverAddress, [userDefaults objectForKey:kliveCompetitionId], APIKey, token];
        
        
        NSLog(@"urlString %@",urlString);
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:kTimeoutInterval];
            [request setHTTPMethod: @"GET"];
            NSError *error;
            NSHTTPURLResponse *urlResponse = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            if (data)
            {
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"h2hlive response %@",json );
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared]removeActivityIndicator];
                    if (urlResponse.statusCode == 200 || urlResponse.statusCode == 201) {
                        if ([json count]>0) {
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kenteredH2HLive];
                            if(json.count  == 1)
                            {
                                NSError *error;
                                if ([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] isKindOfClass:[NSDictionary class]] ) {
                                    if ([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] objectForKey:@"waitingForApproval"]) {
                                        [h2hLiveBase removeFromSuperview];
                                        h2hLiveBase=[[H2HLiveBaseView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                                        h2hLiveBase.delegate=self;
                                        [self.view addSubview:h2hLiveBase];
                                        [h2hLiveBase displayH2HLiveStatus:@"WaitingForApproval"];
                                    }
                                }
                                else{
                                         [h2hLiveBase removeFromSuperview];
                                        [h2hLiveTimer invalidate];
                                        h2hLiveTimer=nil;
                                        BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
                                        [bowlingVC createGameViewforCategory:@"CreateNewGameviaH2HLive"];
                                        [self.navigationController pushViewController:bowlingVC animated:YES];
                                    }
                            }
                            else
                            {
                                 [h2hLiveBase removeFromSuperview];
                                [h2hLiveTimer invalidate];
                                h2hLiveTimer=nil;
                                BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
                                [bowlingVC createGameViewforCategory:@"H2HLive"];
                                [self.navigationController pushViewController:bowlingVC animated:YES];
                            }
                           
                        }
                    }
                    else if(urlResponse.statusCode == 500){
                        // Show rejection view
                        [h2hLiveBase removeFromSuperview];
                        h2hLiveBase=[[H2HLiveBaseView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                        h2hLiveBase.delegate=self;
                        [self.view addSubview:h2hLiveBase];
                        [h2hLiveBase displayH2HLiveStatus:@"OpponentRejectedYourRequest"];
                    }
              
                });
            }
        });
        
    }
    @catch (NSException *exception) {
        
    }
    
}


#pragma mark - Create Game Delegate MEthods
- (void)removeh2hCreateGameView
{
    [createGameView removeFromSuperview];
}

-(void)createGame:(NSDictionary *)postDictionary
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        NSError *error=nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:postDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
        NSString* dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSLog(@"dict11=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        
        NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
        [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *urlString = [NSString stringWithFormat:@"%@bowlingcompetition/live?apiKey=%@&token=%@", serverAddress, APIKey, token];
            [URLrequest setURL:[NSURL URLWithString:urlString]];
            NSLog(@"requestURL=%@", urlString);
            [URLrequest setHTTPMethod:@"POST"];
            [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
            [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [URLrequest setHTTPBody:postdata];
            NSError *error1=nil;
            NSHTTPURLResponse *response=nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
            if (responseData) {
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
                NSLog(@"live data %@ response code %ld", [[json objectForKey:@"competition"] objectForKey:@"id"], (long)response.statusCode);
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    if ([[json objectForKey:@"competition"] objectForKey:@"id"]) {
                        //                            [self cancelSelection];
                        [createGameView removeFromSuperview];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kenteredH2HLive];
                        [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"competition"] objectForKey:@"id"] forKey:kliveCompetitionId];
                        [self showH2HLiveView];
                    }
                    else{
                        [[DataManager shared] removeActivityIndicator];
                        
                        if(((long)response.statusCode)==409)
                        {
                            // [self cancelSelection];
                            UIAlertView *Conflict = [[UIAlertView alloc]
                                                     initWithTitle:nil
                                                     message:@"You have already entered this Challenge."
                                                     delegate:self
                                                     cancelButtonTitle: nil
                                                     otherButtonTitles:@"OK", nil ];
                            [Conflict show];
                        }
                        
                        if(((long)response.statusCode)==402)
                        {
                            NSString *text=@"You do not have enough credits to create this game. Do you want to purchase more credits now?";
                            UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Uh oh!" message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                            [alert1 setTag:198];
                            [alert1 show];
                            
                        }
                    }
                });
            }
        });
    }
}


#pragma mark - H2H Posted Methods
- (void)showH2HPostedView
{
    /*For New Flow*/
//    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
//    NSMutableArray *challengers=[self getChallengers];
//    if (challengers.count > 0) {
//        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"checkForH2HPosted"];
//        [self showFrameViewForH2HPosted:[self getChallengers]];
//    }
//    else{
//        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"checkForH2HPosted"];
//        [self addMoreOpponents];
//    }
    
    /*Temp Change*/
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSMutableArray *challengersArray=[self getChallengers];
    if (challengersArray.count == 0) {
        //show select opponent view
        [opponentView removeFromSuperview];
        opponentView=[[OpponentSelectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        opponentView.delegate=self;
        [opponentView displayPlayers:[self getListOfOpponents] searchString:@"" showingFreinds:0 challengeType:@"H2HPosted"];
        [self.view addSubview:opponentView];
    }
    else{
        //add opponent
        [addOpponentsView removeFromSuperview];
        addOpponentsView=[[AddOpponentsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        addOpponentsView.delegate=self;
        [addOpponentsView displayOpponents:challengersArray];
        [self.view addSubview:addOpponentsView];
    }
    [[DataManager shared]removeActivityIndicator];

}
#pragma mark - Get list of added opponents
- (NSMutableArray *)getChallengers
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *jsonArray=[[NSMutableArray alloc]init];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"bowlinggame/%@/challengers",[userDefaults objectForKey:kbowlingGameId]];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            jsonArray=[[NSMutableArray alloc]initWithArray:[json objectForKey:kResponseString]];
        }
    }
    return jsonArray;
}

#pragma mark - Get list of all Opponents
- (NSMutableArray *)getListOfOpponents
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
     NSMutableArray *jsonArray=[[NSMutableArray alloc]init];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    NSString *urlString = [NSString stringWithFormat:@"bowlinggame/%@/competition/posted/available",[userDefaults objectForKey:kbowlingGameId]];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"bowlingGameId=%@&",[userDefaults objectForKey:kbowlingGameId]] url:urlString contentType:@"" httpMethod:@"GET"];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            jsonArray=[[NSMutableArray alloc]initWithArray:[json objectForKey:kResponseString]];
        }
    }
    return jsonArray;
}

#pragma mark - Enter Challenge Post Call
- (void)enterChallengeAfterLevelSelection:(int)creditsRequired view:(UIView *)viewToRemove postedOrLive:(NSString *)postedOrLive
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *idDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:kbowlingGameId], @"id", nil];
    NSDictionary *postDict;
    NSString *urlString;
    NSLog(@"idDict=%@ postDict=%@",idDictionary,postDict);
    if ([postedOrLive isEqualToString:@"posted"]) {
        postDict=[[NSDictionary alloc]initWithObjectsAndKeys:idDictionary, @"bowlingGame", [NSString stringWithFormat:@"%d",creditsRequired], @"creditWager", nil];
        urlString = [NSString stringWithFormat:@"bowlingcompetition/%@/%@/game",postedOrLive,[userDefaults objectForKey:kopponentId]];
    }
    else{
        postDict = [[NSDictionary alloc]initWithDictionary:idDictionary];
        urlString = [NSString stringWithFormat:@"bowlingcompetition/%@/%@/game",postedOrLive,[userDefaults objectForKey:kliveCompetitionId]];
    }

    NSDictionary *json = [[ServerCalls instance] serverCallWithPostParameters:postDict url:urlString contentType:@"application/json" httpMethod:@"POST"];
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 201 || [[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            [viewToRemove removeFromSuperview];
             if ([postedOrLive isEqualToString:@"posted"]) {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
                 /*For New Flow*/
                 [self showFrameViewForH2HPosted:[self getChallengers]];
                
                 /*Temp Change*/
//                 [addOpponentsView removeFromSuperview];
//                 addOpponentsView=[[AddOpponentsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                 addOpponentsView.delegate=self;
//                 [self.view addSubview:addOpponentsView];
//                 [addOpponentsView displayOpponents: [self getChallengers]];
//                 [[DataManager shared] removeActivityIndicator];
                 
             }
             else{
                 [self getH2HLive];
                 if([h2hLiveTimer isValid])
                 {
                     [h2hLiveTimer invalidate];
                     h2hLiveTimer=nil;
                 }
                 h2hLiveTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutIntervalForTimer target:self selector:@selector(getH2HLive) userInfo:nil repeats:YES];
             }
        }
        else
            [[DataManager shared] removeActivityIndicator];
    }
    else{
        [[DataManager shared] removeActivityIndicator];
        if([[json objectForKey:kResponseStatusCode] integerValue]==409)
        {
            UIAlertView *Conflict = [[UIAlertView alloc]
                                     initWithTitle:nil
                                     message:@" User Already Entered "
                                     delegate:self
                                     cancelButtonTitle: nil
                                     otherButtonTitles:@"OK", nil ];
            [Conflict show];
            
        }
        else if([[json objectForKey:kResponseStatusCode] integerValue]==402)
        {
            NSString *text=@"You do not have enough credits to enter this level. Do you want to purchase more credits now?";
            
            UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Uh oh!" message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            [alert1 setTag:198];
            [alert1 show];
        }
        else{
            UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Uh oh!" message:@"An error occurred." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert1 show];

        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==198)
    {
        if(buttonIndex == 0)
        {
            
        }
        if(buttonIndex == 1)
        {
//            [self buyCredits];
        }
    }
}

-(NSMutableArray *)jsonArray
{
    NSMutableArray *json=[[NSMutableArray alloc]init];

    NSDictionary *temp=[NSDictionary dictionaryWithObjectsAndKeys:@"132",@"creatorAverage",@"70",@"creatorHandicap",@"IN",@"creatorRegion",@"HarrisonDraves",@"creatorUserName",@"0",@"creditWager",@"2015-02-11T23:08:57",@"expirationDateTime",@"38751",@"id",@"1",@"isComplete",@"170",@"name",@"0",@"playersEntered",@"0",@"playersRemaining", nil];
    for (int i=0; i < 4; i++) {
        [json addObject:temp];
    }
    return json;
}

#pragma mark - Opponent Selection Delegate Methods
- (void)selectedOpponent:(NSDictionary *)opponentDictionary
{
    //Show select level view
    if ( [challengeType isEqualToString:@"H2HLive"]) {
        [[NSUserDefaults standardUserDefaults]setValue:[opponentDictionary objectForKey:@"id"] forKey:kliveCompetitionId];
        [self enterChallengeAfterLevelSelection:[[opponentDictionary objectForKey:@"creditWager"] intValue] view:opponentView postedOrLive:@"live"];
    }
    else{
        [[DataManager shared]removeActivityIndicator];
        [[NSUserDefaults standardUserDefaults]setValue:[opponentDictionary objectForKey:@"id"] forKey:kopponentId];
        [levelView removeFromSuperview];
        levelView =[[LevelSelectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        levelView.delegate=self;
        [self.view addSubview:levelView];
        [levelView getCredits];
    }
}

- (void)removeOpponentSelectionView
{
    /*For New Flow*/
//    [opponentView removeFromSuperview];
//    opponentView=nil;
//     NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
//    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"checkForH2HPosted"] == 1) {
//        //REmove ChallengesVeiwController
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else{
//        
//    }
    
     /*Temp Change */
    [opponentView removeFromSuperview];
    opponentView=nil;
    if ([challengeType isEqualToString:@"H2HPosted"]) {
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        [addOpponentsView displayOpponents: [self getChallengers]];
        [[DataManager shared]removeActivityIndicator];
    }
}
#pragma mark - Level view Delegate Methods
- (void)selectedLevel:(int)creditsRequired
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInChallengeView];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kenteredH2HPosted];
//    [addOpponentsView removeFromSuperview];
    [self enterChallengeAfterLevelSelection:creditsRequired view:levelView postedOrLive:@"posted"];
//    frameView=[[ChallengesFrameView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    frameView.delegate=self;
//    [self.view addSubview:frameView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeLevelView
{
    [levelView removeFromSuperview];
    levelView=nil;
    [opponentView reloadOpponentsTable];
}

-(NSDictionary *)userCredits
{
    NSDictionary *json;
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
    return json;
}

- (void)showBuyCreditsView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    BuyCreditsViewController *buyCreditsVC=[[BuyCreditsViewController alloc]init];
    [buyCreditsVC creditsMainViewAddedToBaseView:@"Challenges"];
    [self.navigationController pushViewController:buyCreditsVC animated:YES];
    [[DataManager shared]removeActivityIndicator];

}
#pragma mark - Main View Delegate Methods

#pragma mark Enter Selected Challenge
- (void)enterChallenge:(int)typeOfChallenge
{
    mainView.hidden=NO;
    if (typeOfChallenge == 0) {
        //h2h live
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"H2H Live"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
        [self showH2HLiveView];
    }
    else{
        //h2h posted
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"H2H Posted"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
        [self showH2HPostedView];
     }
}

- (void)removeChallengeMainView
{
     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
//    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showLandscape"];
//    [self supportedInterfaceOrientations:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
//    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
//    for (int i = 0; i <[allViewControllers count]; i++) {
//        UIViewController *vc = [allViewControllers objectAtIndex:i];
//        if ([vc isKindOfClass:[BowlingViewController class]]) {
//            [allViewControllers removeObjectAtIndex:i];
//            break;
//        }
//    }
//    self.navigationController.viewControllers = allViewControllers;
//    
//    BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
//    [bowlingVC createGameViewforCategory:@"H2HPosted"];
//    [self.navigationController pushViewController:bowlingVC animated:YES];
//    [bowlingVC urlForh2hPostedChallenger:urlStringForChallengers];
//    NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);

}

- (void)showH2HWebView
{
    if(mainWebView)
    {
        [mainWebView removeFromSuperview];
        mainWebView.delegate=nil;
        mainWebView=nil;
    }
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    mainWebView.delegate=self;
    NSURL *url=[NSURL URLWithString:@"https://www.xbowling.com/mobile/head2head.html"];
    NSLog(@"url=%@",url);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:requestObj];
    [self.view addSubview:mainWebView];
    
    footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    //    [footerViewForWebview setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    closeButton.frame = CGRectMake(self.view.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.layer.borderWidth=0.2;
    closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
    [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [footerViewForWebview addSubview:closeButton];
    [self.view addSubview:footerViewForWebview];
}

#pragma mark - WebView Methods
-(void)dismissWebView
{
    [footerViewForWebview removeFromSuperview];
    footerViewForWebview=nil;
    
    [mainWebView loadHTMLString:@"" baseURL:nil];
    [mainWebView stopLoading];
    [mainWebView setDelegate:nil];
    
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[DataManager shared]removeActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *) portal
{
    [[DataManager shared]removeActivityIndicator];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [self performSelector:@selector(removeIndicator) withObject:nil afterDelay:1.2];
}

#pragma mark - Add Opponents Delegate Methods
- (void)removeAddOpponentView
{
    [addOpponentsView removeFromSuperview];
    addOpponentsView=nil;
    if (![mainView isDescendantOfView:self.view]) {
        [self createMainView];
    }
    [mainView updateChallengeButtonsState];
}
- (void)addMoreOpponents
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
     challengeType=@"H2HPosted";
    [opponentView removeFromSuperview];
    opponentView=[[OpponentSelectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    opponentView.delegate=self;
    [opponentView displayPlayers:[self getListOfOpponents] searchString:@"" showingFreinds:0 challengeType:@"H2HPosted"];
    [self.view addSubview:opponentView];
    [[DataManager shared]removeActivityIndicator];
}

- (void)showFrameViewOfPlayer:(NSDictionary *)playerDict
{
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    urlStringForChallengers = [NSString stringWithFormat:@"%@bowlinggame/%@/challengers/posted/%@/bowlinggame/%@?apiKey=%@&token=%@", serverAddress, [[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId], [playerDict objectForKey:@"competitionId"],[playerDict objectForKey:@"opponentBowlingGameId"], APIKey, token];
    BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
    [bowlingVC createGameViewforCategory:@"H2HPosted"];
    [self.navigationController pushViewController:bowlingVC animated:YES];
    [bowlingVC urlForh2hPostedChallenger:urlStringForChallengers];
}

- (void)showFrameViewForH2HPosted:(NSMutableArray *)playersArray
{
    
    NSDictionary *playerDict=[[NSDictionary alloc]initWithDictionary:[playersArray lastObject]];  /*For New Flow - 11/6*/
    if (playerDict.count > 0) {
//        [opponentView removeFromSuperview];
//         [addOpponentsView removeFromSuperview];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        urlStringForChallengers = [NSString stringWithFormat:@"%@bowlinggame/%@/challengers/posted/%@/bowlinggame/%@?apiKey=%@&token=%@", serverAddress, [[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId], [playerDict objectForKey:@"competitionId"],[playerDict objectForKey:@"opponentBowlingGameId"], APIKey, token];
        //    [self.navigationController popViewControllerAnimated:YES];
        
        //    NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
        //    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        //    for (int i = 0; i <[allViewControllers count]; i++) {
        //        UIViewController *vc = [allViewControllers objectAtIndex:i];
        //        if ([vc isKindOfClass:[BowlingViewController class]]) {
        //                [allViewControllers removeObjectAtIndex:i];
        //            break;
        //        }
        //    }
        //    self.navigationController.viewControllers = allViewControllers;
        
        BowlingViewController *bowlingVC=[[BowlingViewController alloc]init];
        [bowlingVC createGameViewforCategory:@"H2HPosted"];
        [self.navigationController pushViewController:bowlingVC animated:YES];
        [bowlingVC urlForh2hPostedChallenger:urlStringForChallengers];
        NSLog(@"navigationController stack=%@",self.navigationController.viewControllers);
    }
    else{
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView5 show];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    if ([h2hLiveTimer isValid]) {
        [h2hLiveTimer invalidate];
        h2hLiveTimer=nil;
    }
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
