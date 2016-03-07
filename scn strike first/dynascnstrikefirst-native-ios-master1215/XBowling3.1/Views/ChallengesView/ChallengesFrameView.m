//
//  ChallengesFrameView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ChallengesFrameView.h"

@implementation ChallengesFrameView
{
    NSString *challengeType;
    int firstPlayerFrame;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)createFrameViewforChallenge:(NSString *)challenge numberOfPlayers:(int)playersCount
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",challenge] forKey:kcurrentChallenge];
    challengeType=challenge;
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImage addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"H2H Posted";
    if ([challenge isEqualToString:@"H2HLive"]) {
        headerLabel.text=@"H2H Live";
    }
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
//    UIButton *MyGameButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
//    MyGameButton.backgroundColor=[UIColor clearColor];
//    MyGameButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
//    [MyGameButton setTitle:@"My Game" forState:UIControlStateNormal];
//    [MyGameButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
//    [MyGameButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
//    [MyGameButton addTarget:self action:@selector(MyGameButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:MyGameButton];
    
    // My Game Button
    RoundedRectButton *gameButton=[[RoundedRectButton alloc]init];
    [gameButton buttonFrame:CGRectMake(screenBounds.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60.0 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120.0 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height])];
    [gameButton addTarget:self action:@selector(MyGameButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    gameButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
    //   [strikeButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 0.0f, 10.0f, 0.0f)];
    [gameButton setTitle:@"My Game" forState:UIControlStateNormal];
    [self addSubview:gameButton];

    

    [self addFrameViews:playersCount];
    
    /*For New Flow*/
    /*if ([challengeType isEqualToString:@"H2HPosted"]) {
        //Add Opponent
        UIButton *addOpponentButton=[[UIButton alloc]init];
        addOpponentButton.tag=15000;
        addOpponentButton.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [addOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [addOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [addOpponentButton addTarget:self action:@selector(addOpponentFunction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addOpponentButton];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, addOpponentButton.frame.size.width, addOpponentButton.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"      Add Opponent";
        titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size ];
        [addOpponentButton addSubview:titleLabel];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(addOpponentButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, addOpponentButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [addOpponentButton addSubview:arrow];

    }*/

    
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
//    if ([[ [NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]) {
//        if([timerForGameUpdate isValid])
//        {
//            [timerForGameUpdate invalidate];
//            timerForGameUpdate=nil;
//        }
//        
//        timerForGameUpdate = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(updateFrameView) userInfo:nil repeats:YES];
//    }
//    else{
        [self updateFrameView];
//    }
}

#pragma mark - Add Opponent
- (void)addOpponentFunction
{
    [delegate showAddOpponentView];
}


#pragma mark - Show My Game
- (void)MyGameButtonFunction:(UIButton *)sender
{
  
    [delegate showMyGame];
    
}

#pragma mark - To get json for players
- (void)updateFrameView
{
    [delegate updateFramesforChallenge:challengeType];
}

#pragma mark - update frame view with json response
//Called from bowlingVC after createGame
- (void)updateViewofPlayer:(int)playerIndex scoreDict:(NSDictionary *)scoreDictionary forChallenge:(NSString *)challenge arrayForLiveChallenge:(NSArray *)challengersArray
{
//    @try {
    NSLog(@"scoreDict in frameview=%@",scoreDictionary);
        //get current frame
        if ([challenge isEqualToString:@"H2HPosted"]) {
            int frame;
            if (playerIndex == 2) {
                frame=firstPlayerFrame;
            }
            else{
                int latestSquareNumber=[[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:@"latestSquareNumber"] intValue];
                if(latestSquareNumber > 0){
                    if(latestSquareNumber % 2 == 0){
                        frame=latestSquareNumber/2;
                    }
                    else{
                        frame=latestSquareNumber/2+1;
                        if (latestSquareNumber == 21) {
                            frame=10;
                        }
                    }
                }
                else
                    frame=1;
                firstPlayerFrame=frame;
            }
            
            for (int i=0; i<10; i++) {
                int pinNumber;
                pinNumber = i*2+1;
                //        pinNumber=i;
                
                ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:10000*playerIndex+i+1];
                
                //Frame score display
                //        frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+frameNumber];
                NSString *ball1Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
                NSString *frameScore = [NSString stringWithFormat:@"frameScore%d",i+1];
                if ([NSString stringWithFormat:@"%@",[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball1Key]].length == 0 &&  [NSString stringWithFormat:@"%@",[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:frameScore]].length != 0 ) {
                    frameBaseView.ball1Score.text =@"0";
                }
                else
                {
                    frameBaseView.ball1Score.text =[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball1Key];
                }
                
                pinNumber++;
                NSString *ball2Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
                frameBaseView.ball2Score.text = [[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball2Key];
                if ([NSString stringWithFormat:@"%@",[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball2Key]].length == 0 && ![frameBaseView.ball1Score.text isEqualToString:@"X"] && [NSString stringWithFormat:@"%@",[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:frameScore]].length != 0 && frame != i) {
                    frameBaseView.ball2Score.text =@"0";
                }
                else
                    frameBaseView.ball2Score.text =[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball2Key];
                
                frameBaseView.squareScore.text = [[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:frameScore];
                if (i == 9) {
                    pinNumber++;
                    NSString *ball3Key = [NSString stringWithFormat:@"squareScore%d",i*2+3];
                    frameBaseView.ball3Score.text = [[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball3Key];
//                    if ( [NSString stringWithFormat:@"%@",[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:frameScore]].length != 0 && frame != i) {
//                        frameBaseView.ball3Score.text =@"0";
//                    }
//                    else
                        frameBaseView.ball3Score.text =[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:ball3Key];
                }
            }
            UIView *baseView=(UIView *)[self viewWithTag:1000+playerIndex];
            UILabel *rawScoreLabel=(UILabel*)[baseView viewWithTag:2];
            NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:@"finalScore"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            NSAttributedString *rawLabelText=[[NSAttributedString alloc] initWithString:@"\nRaw" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            [scoreAttributedString appendAttributedString:rawLabelText];
            rawScoreLabel.attributedText=scoreAttributedString;
            
            
            UILabel *handicapScoreLabel=(UILabel*)[baseView viewWithTag:3];
            NSMutableAttributedString *handicapAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:@"handicapScore"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            NSAttributedString *handicapLabelText=[[NSAttributedString alloc] initWithString:@"\nHandicap" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            [handicapAttributedString appendAttributedString:handicapLabelText];
            handicapScoreLabel.attributedText=handicapAttributedString;
            
            UILabel *nameLabel=(UILabel*)[baseView viewWithTag:1];
            nameLabel.text=[NSString stringWithFormat:@"%@",[[[scoreDictionary objectForKey:@"bowlingGame"] objectForKey:@"name"] stringByRemovingPercentEncoding]];
            if ([nameLabel.text isEqualToString:@"(null)"]) {
                nameLabel.text=@"";
            }
            
            
            //Change score panel color
            for(int i=0;i<10;i++){
                ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:10000*playerIndex+i+1];
                for(UILabel *subview in frameBaseView.subviews){
                    if(i+1 == frame){
                        //set background to blue color
                        [subview setBackgroundColor:[UIColor colorWithRed:11.0/255 green:91.0/255 blue:253.0/255 alpha:0.6]];
                        subview.textColor=[UIColor whiteColor];
                    }
                    else if (i+1 < frame){
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
            
        }
        else{
            //H2H Live
            for (int j=0; j < challengersArray.count; j++) {
                int frame;
                if (j != 0) {
                    frame=firstPlayerFrame;
                }
                else{
                    int latestSquareNumber=[[[[challengersArray objectAtIndex:0] objectForKey:@"scoredGame"] objectForKey:@"latestSquareNumber"] intValue];
                    if(latestSquareNumber > 0){
                        if(latestSquareNumber % 2 == 0){
                            frame=latestSquareNumber/2;
                        }
                        else{
                            frame=latestSquareNumber/2+1;
                            if (latestSquareNumber == 21) {
                                frame=10;
                            }
                        }
                    }
                    else
                        frame=1;
                    firstPlayerFrame=frame;
                }
                playerIndex=j+1;
                for (int i=0; i<10; i++) {
                    int pinNumber;
                    pinNumber = i*2+1;
                    ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:10000*playerIndex+i+1];
                    
                    //Frame score display
                    //        frameBaseView=(ScoreFrameImageView*)[self viewWithTag:5000+frameNumber];
                    NSString *ball1Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
                    NSString *frameScore = [NSString stringWithFormat:@"frameScore%d",i+1];
                    if ([NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball1Key]].length == 0 &&  [NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:frameScore]].length != 0 ) {
                        frameBaseView.ball1Score.text =@"0";
                    }
                    else
                    {
                        frameBaseView.ball1Score.text =[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball1Key];
                    }
                    
                    pinNumber++;
                    NSString *ball2Key = [NSString stringWithFormat:@"squareScore%d",pinNumber];
                    frameBaseView.ball2Score.text = [[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball2Key];
                    if ([NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball2Key]].length == 0 && ![frameBaseView.ball1Score.text isEqualToString:@"X"] && [NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:frameScore]].length != 0 && frame != i) {
                        frameBaseView.ball2Score.text =@"0";
                    }
                    else
                        frameBaseView.ball2Score.text =[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball2Key];
                    
                    frameBaseView.squareScore.text = [[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:frameScore];
                    if (i == 9) {
                        pinNumber++;
                        NSString *ball3Key = [NSString stringWithFormat:@"squareScore%d",i*2+3];
                        frameBaseView.ball3Score.text = [[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball3Key];
                        if ([NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball3Key]].length == 0 && [NSString stringWithFormat:@"%@",[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:frameScore]].length != 0 && frame != i) {
                            frameBaseView.ball3Score.text =@"0";
                        }
                        else
                            frameBaseView.ball3Score.text =[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:ball3Key];
                    }
                }
                UIView *baseView=(UIView *)[self viewWithTag:1000+j+1];
                UILabel *rawScoreLabel=(UILabel*)[baseView viewWithTag:2];
                NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:@"finalScore"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                NSAttributedString *rawLabelText=[[NSAttributedString alloc] initWithString:@"\nRaw" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                [scoreAttributedString appendAttributedString:rawLabelText];
                rawScoreLabel.attributedText=scoreAttributedString;
                
                
                UILabel *handicapScoreLabel=(UILabel*)[baseView viewWithTag:3];
                NSMutableAttributedString *handicapAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:@"handicapScore"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                NSAttributedString *handicapLabelText=[[NSAttributedString alloc] initWithString:@"\nHandicap" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                [handicapAttributedString appendAttributedString:handicapLabelText];
                handicapScoreLabel.attributedText=handicapAttributedString;
                
                UILabel *nameLabel=(UILabel*)[baseView viewWithTag:1];
                nameLabel.text=@"";
                nameLabel.text=[NSString stringWithFormat:@"%@",[[[[[challengersArray objectAtIndex:j] objectForKey:@"scoredGame"] objectForKey:@"name"] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "]];
                if ([nameLabel.text isEqualToString:@"(null)"]) {
                    nameLabel.text=@"";
                }
                
//                ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:10000*playerIndex+frame];
//                NSLog(@"frameView=%d",frameBaseView.tag);
//                for(UILabel *subview in frameBaseView.subviews){
//                        //set background to blue color
//                        subview.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
//                        [subview setBackgroundColor:[UIColor colorWithRed:11.0/255 green:91.0/255 blue:253.0/255 alpha:0.6]];
//                        subview.textColor=[UIColor whiteColor];
//                }
                
                //Change score panel color
                for(int i=0;i<10;i++){
                    ScoreFrameImageView *frameBaseView=(ScoreFrameImageView*)[self viewWithTag:10000*(j+1)+i+1];
                    for(UILabel *subview in frameBaseView.subviews){
                        if(i+1 == frame){
                            //set background to blue color
                            [subview setBackgroundColor:[UIColor colorWithRed:11.0/255 green:91.0/255 blue:253.0/255 alpha:0.6]];
                            subview.textColor=[UIColor whiteColor];
                        }
                        else if (i+1 < frame){
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
            }
        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"exception in frame view=%@",exception.description);
//    }
    
}

#pragma mark - add score panel for number of players
- (void)addFrameViews:(int)numberOfPlayers
{
    for (int i=1; i<=numberOfPlayers; i++) {
        UIView *previousView=(UIView *)[self viewWithTag:1000+i];
        [previousView removeFromSuperview];
    }
    int ycoordinateForScorePanel= [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i=1;i<=numberOfPlayers; i++) {
        UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinateForScorePanel, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60+88 currentSuperviewDeviceSize:self.frame.size.height])];
        [baseView setBackgroundColor:[UIColor clearColor]];
        baseView.tag=1000+i;
        [self addSubview:baseView];
        
        UILabel *playerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:self.frame.size.width],0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:165 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60 currentSuperviewDeviceSize:self.frame.size.height])];
        playerNameLabel.backgroundColor=[UIColor clearColor];
        if (i == 1) {
            playerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kbowlerName]];
        }
        playerNameLabel.textColor=[UIColor whiteColor];
        playerNameLabel.tag=1;
        playerNameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [baseView addSubview:playerNameLabel];
        
        UILabel *rawLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:250 currentSuperviewDeviceSize:self.frame.size.width],0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60 currentSuperviewDeviceSize:self.frame.size.height])];
        rawLabel.tag=2;
        rawLabel.backgroundColor=[UIColor clearColor];
        rawLabel.textColor=[UIColor whiteColor];
        rawLabel.numberOfLines=0;
        rawLabel.textAlignment=NSTextAlignmentCenter;
        [baseView addSubview:rawLabel];
        
        
        UILabel *handicapScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(rawLabel.frame.size.width+rawLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:7 currentSuperviewDeviceSize:self.frame.size.width],0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60 currentSuperviewDeviceSize:self.frame.size.height])];
        handicapScoreLabel.backgroundColor=[UIColor clearColor];
        handicapScoreLabel.tag=3;
        handicapScoreLabel.textColor=[UIColor whiteColor];
        handicapScoreLabel.numberOfLines=0;
        handicapScoreLabel.textAlignment=NSTextAlignmentCenter;
        [baseView addSubview:handicapScoreLabel];
        
        
        UIView *scorePanelBase=[[UIView alloc]initWithFrame:CGRectMake(0, playerNameLabel.frame.size.height+playerNameLabel.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86 currentSuperviewDeviceSize:self.frame.size.height])];
        [scorePanelBase setBackgroundColor:[UIColor clearColor]];
        scorePanelBase.userInteractionEnabled=YES;
        [baseView addSubview:scorePanelBase];
        
        //score frames
        int xcoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:3 currentSuperviewDeviceSize:self.frame.size.width];
        for(int j=0;j<10;j++){
            ScoreFrameImageView *scoreFrame=[[ScoreFrameImageView alloc]initWithFrame:CGRectMake(xcoordinate, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:38.3 currentSuperviewDeviceSize:self.frame.size.width], scorePanelBase.frame.size.height)];
            
            if(j==9){
                scoreFrame=[[ScoreFrameImageView alloc]initWithFrame:CGRectMake(xcoordinate, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:self.frame.size.width], scorePanelBase.frame.size.height)];
            }
            scoreFrame.userInteractionEnabled=YES;
            NSLog(@"scoreFrame=%f",[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:self.frame.size.width]);
            scoreFrame.tag=10000*i+j+1;
            NSLog(@"baseView.tag=%ld scoreFrame=%ld",(long)baseView.tag,(long)scoreFrame.tag);
            [scorePanelBase addSubview:scoreFrame];
            scoreFrame.frameNumber.text=[NSString stringWithFormat:@"%d",j+1];
            
            xcoordinate=scoreFrame.frame.size.width+scoreFrame.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1.5 currentSuperviewDeviceSize:self.frame.size.width];
        }
        ycoordinateForScorePanel=baseView.frame.size.height+baseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/2 currentSuperviewDeviceSize:self.frame.size.height];
    }
}

- (void)backButtonFunction
{
    [delegate removeFrameView];
}

@end
