//
//  GameSummaryView.m
//  XBowling3.1
//
//  Created by Click Labs on 1/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "GameSummaryView.h"
#import "BowlingView.h"

@implementation GameSummaryView
{
    NSArray *challengesArray;
    UIScrollView *mainScrollView;
    UIScrollView *challengesScrollView;
}
@synthesize summaryDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor clearColor]];
      
    }
    return self;
}

- (void)createMainView:(NSDictionary *)json challengesArray:(NSArray *)array
{
    UILabel *headerLabel=[[UILabel alloc]init];
    headerLabel.tag=14000;
    headerLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:398/3 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:65/3 currentSuperviewDeviceSize:self.superview.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:452/3 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:88/3 currentSuperviewDeviceSize:self.superview.frame.size.height]);
    headerLabel.layer.cornerRadius=headerLabel.frame.size.height/2;
    headerLabel.clipsToBounds=YES;
    headerLabel.backgroundColor=[UIColor whiteColor];
    headerLabel.text=@"Game Summary";
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor blackColor];
    [self addSubview:headerLabel];
    
    // Game Stats View
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,headerLabel.frame.origin.y+headerLabel.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:746/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    [mainScrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:mainScrollView];
    
    @try {
        if(json.count > 0)
        {
            
            NSMutableArray *labelsArray=[[NSMutableArray alloc]initWithObjects:@"Multi-Pin Spare %",@"Open %",@"Single-Pin Spare %",@"Spare %",@"Split %",@"Strike %",@"Total Scores", nil];
            NSMutableArray *gamesummarykeysArray=[[NSMutableArray alloc]initWithObjects:@"multiPinpercent",@"openpercent",@"singlePinpercent",@"sparepercent",@"splitpercent",@"strikepercent",@"totalScores", nil];
            int ycoordinate = 0;
            UIView *clearviewLabel;
            UILabel *percentageLabel,*leftsideLabel;
            
            for(int item_count=0;item_count<gamesummarykeysArray.count;item_count++)
            {
                clearviewLabel= [[UIView alloc]init];
                clearviewLabel.userInteractionEnabled=YES;
                [clearviewLabel setFrame:CGRectMake(0, ycoordinate, mainScrollView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:184/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
                [mainScrollView addSubview:clearviewLabel];
                clearviewLabel.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
                
                leftsideLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0,1,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:690/3 currentSuperviewDeviceSize:self.superview.frame.size.width],clearviewLabel.frame.size.height - 1)];
                leftsideLabel.font =  [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
                leftsideLabel.textAlignment = NSTextAlignmentRight;
                leftsideLabel.backgroundColor=[UIColor clearColor];
                leftsideLabel.textColor = [UIColor whiteColor];
                leftsideLabel.text=[NSString stringWithFormat:@"%@",[labelsArray objectAtIndex:item_count]];
                //leftsideLabel.text=@"sdf";
                [clearviewLabel addSubview:leftsideLabel];
                
                percentageLabel=  [[UILabel alloc] initWithFrame:CGRectMake(leftsideLabel.frame.size.width+5,leftsideLabel.frame.origin.y,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:480/3 currentSuperviewDeviceSize:self.superview.frame.size.width],clearviewLabel.frame.size.height - 1)];
                percentageLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
                percentageLabel.textAlignment = NSTextAlignmentRight;
                percentageLabel.backgroundColor=[UIColor clearColor];
                percentageLabel.textColor = [UIColor whiteColor];
                NSNumberFormatter *formatterfloat = [[NSNumberFormatter alloc] init];
                [formatterfloat setNumberStyle:NSNumberFormatterDecimalStyle];
                [formatterfloat setMaximumFractionDigits:2];
                [formatterfloat setAllowsFloats:YES];
                NSNumber *numberdeci = [NSNumber numberWithFloat:[[json objectForKey:[gamesummarykeysArray objectAtIndex:item_count]] floatValue]];
                NSString  *formattedStringValue=[formatterfloat stringFromNumber:numberdeci];
                percentageLabel.text=[NSString stringWithFormat:@"%@%%",formattedStringValue];
                if(item_count == gamesummarykeysArray.count-1)
                    percentageLabel.text=[NSString stringWithFormat:@"%@",formattedStringValue];
                [clearviewLabel addSubview:percentageLabel];
                
                UIView *separatorImage=[[UIView alloc]init];
                separatorImage.frame=CGRectMake(0, 0, clearviewLabel.frame.size.width, 1);
                separatorImage.backgroundColor=separatorColor;
                [clearviewLabel addSubview:separatorImage];
                
                if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if (screenBounds.size.height == 480)
                    {
                        clearviewLabel.frame=CGRectMake( clearviewLabel.frame.origin.x-20, clearviewLabel.frame.origin.y, clearviewLabel.frame.size.width+40, clearviewLabel.frame.size.height);
                    }
                }
                ycoordinate=ycoordinate+clearviewLabel.frame.size.height;
            }
            UIView *separatorImage2=[[UIView alloc]init];
            separatorImage2.frame=CGRectMake(0, ycoordinate, clearviewLabel.frame.size.width, 1);
            separatorImage2.backgroundColor=separatorColor;
            [mainScrollView addSubview:separatorImage2];
            mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width,ycoordinate+5);
            
        }
        else
        {
            UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,0,mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
            suggestions1.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
            suggestions1.textAlignment = NSTextAlignmentCenter;
            suggestions1.textColor = [UIColor whiteColor];
            suggestions1.backgroundColor=[UIColor clearColor];
            suggestions1.text = @"You have no stats. \nPlease play more games.";
            suggestions1.numberOfLines=2;
            suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
            [mainScrollView addSubview:suggestions1];
        }

    }
    @catch (NSException *exception) {
        UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,0,mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        suggestions1.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
        suggestions1.textAlignment = NSTextAlignmentCenter;
        suggestions1.textColor = [UIColor whiteColor];
        suggestions1.backgroundColor=[UIColor clearColor];
        suggestions1.text = @"You have no stats. \nPlease play more games.";
        suggestions1.numberOfLines=2;
        suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
        [mainScrollView addSubview:suggestions1];

    }
    
    //Challenges View
    challengesScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,headerLabel.frame.origin.y+headerLabel.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:746/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    [challengesScrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:challengesScrollView];
    challengesScrollView.hidden=YES;
    challengesArray=[[NSArray alloc]initWithArray:array];
    
    @try {
        if(challengesArray.count > 0)
        {
            float challengeycordianate=0;
            float ycordinatefg=15;
            float shiftxcordinate=5;
            int datacount;
            for(int i=0;i<challengesArray.count;i++)
            {
                datacount=(int)challengesArray.count;
                //challenge selected Image view
                UIImageView * challengeImgview = [[UIImageView alloc] initWithFrame:CGRectMake(shiftxcordinate+17,challengeycordianate, 55, 55)];
                challengeImgview.layer.cornerRadius=5;
                challengeImgview.layer.masksToBounds=YES;
                NSString *challengeName =[[[[[challengesArray objectAtIndex:i] objectForKey:@"challenge"] objectForKey:@"name"] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                if([challengeName rangeOfString:@"Live H2H"].location != NSNotFound)
                {
                    challengeImgview.image = [UIImage imageNamed:@"h2h_live.png"];
                }
                if([challengeName rangeOfString:@"Posted H2H"].location != NSNotFound)
                {
                    challengeImgview.image = [UIImage imageNamed:@"h2h_posted.png"];
                }
                [challengesScrollView addSubview:challengeImgview];
                //challenge name Label
                UILabel *challengeNamelabel =  [[UILabel alloc] initWithFrame: CGRectMake(challengeImgview.frame.origin.x+challengeImgview.frame.size.width+10,challengeImgview.frame.origin.y+1+8-2.5,300, 14.5)];
                //                challengeNamelabel.backgroundColor=[UIColor redColor];
                challengeNamelabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.5];
                challengeNamelabel.textAlignment = NSTextAlignmentLeft;
                challengeNamelabel.text=[[[[[challengesArray objectAtIndex:i] objectForKey:@"challenge"] objectForKey:@"name"]stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                challengeNamelabel.textColor = [UIColor whiteColor];
                [challengesScrollView addSubview:challengeNamelabel];
                
                //wonPoints label
                UILabel *wonpointsLabel =  [[UILabel alloc] initWithFrame: CGRectMake(challengeNamelabel.frame.origin.x,challengeNamelabel.frame.origin.y+1+15-2.2,300, 30)];
                wonpointsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                wonpointsLabel.numberOfLines=0;
                //                wonpointsLabel.backgroundColor=[UIColor grayColor];
                wonpointsLabel.lineBreakMode=NSLineBreakByWordWrapping;
                wonpointsLabel.textAlignment = NSTextAlignmentLeft;
                if([challengeName rangeOfString:@"Posted H2H"].location != NSNotFound || [challengeName rangeOfString:@"Live H2H"].location != NSNotFound)
                    //                if([[challengesArray objectAtIndex:i] objectForKey:@"framePoints"] ==Nil)
                {
                    if( [[[challengesArray objectAtIndex:i] objectForKey:@"competitionGameState"] isEqualToString:@"Entered"])
                    {
                        wonpointsLabel.text=@"In Progress...";
                    }
                    else if([[[challengesArray objectAtIndex:i] objectForKey:@"competitionGameState"] isEqualToString:@"Lost"])
                    {
                        wonpointsLabel.text=@"Better luck next time.";
                    }
                    else if([[[challengesArray objectAtIndex:i] objectForKey:@"competitionGameState"] isEqualToString:@"Won"])
                    {
                        wonpointsLabel.text=[[@"You won " stringByAppendingString:[NSString stringWithFormat:@"%@",[[challengesArray objectAtIndex:i] objectForKey:@"totalPoints"] ] ] stringByAppendingString:@""] ;
                    }
                    else
                    {
                        wonpointsLabel.text=@"Its a tie!";
                    }
                    //                    }
                    wonpointsLabel.textColor = [UIColor whiteColor];
                    [challengesScrollView addSubview:wonpointsLabel];
                }
                else{
                    //  NSLog(@"valuee==%d",complete);
                    int complete =(int)[[[NSUserDefaults standardUserDefaults]objectForKey:@"completechallengecheck"]integerValue];
                    if([[NSString stringWithFormat:@"%d", complete ]isEqual:@"1"])
                    {
                        if([[[[challengesArray objectAtIndex:0] objectForKey:@"challenge"] objectForKey:@"challengeState"] isEqualToString:@"Won"]){
                            wonpointsLabel.text=[[@"You won " stringByAppendingString:[NSString stringWithFormat:@"%@",[[challengesArray objectAtIndex:i] objectForKey:@"totalPoints"] ] ] stringByAppendingString:@""] ;
                        }
                        else{
                            wonpointsLabel.text=@"Better luck next time.";
                        }
                    }
                    else
                    {
                        wonpointsLabel.text=[[@"You have earned " stringByAppendingString:[NSString stringWithFormat:@"%@",[[challengesArray objectAtIndex:i] objectForKey:@"totalPoints"] ] ] stringByAppendingString:@" Points so far."] ;
                    }
                    wonpointsLabel.textColor = [UIColor whiteColor];
                    [challengesScrollView addSubview:wonpointsLabel];
                    if([[challengesArray objectAtIndex:i] objectForKey:@"framePoints"] !=Nil)
                    {
                        ycordinatefg=challengeImgview.frame.origin.y+challengeImgview.frame.size.height+10;
                        for(int framecount=0;framecount<10;framecount++)
                        {
                            UILabel *categorylabel =  [[UILabel alloc] initWithFrame: CGRectMake(shiftxcordinate+20,ycordinatefg,200, 18)];
                            if (screenBounds.size.height == 568)
                                categorylabel.frame=CGRectMake(shiftxcordinate+20,ycordinatefg,270, 18);
                            categorylabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                            categorylabel.textAlignment = NSTextAlignmentLeft;
                            categorylabel.textColor = [UIColor whiteColor];
                            //                         categorylabel.backgroundColor=[UIColor grayColor];
                            
                            
                            //                        UILabel *scorelabel =  [[UILabel alloc] initWithFrame: CGRectMake(shiftxcordinate+20,ycordinatefg,410, 18)];
                            UILabel *scorelabel =  [[UILabel alloc] initWithFrame: CGRectMake(categorylabel.frame.origin.x+categorylabel.frame.size.width,ycordinatefg,100, 18)];
                            scorelabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                            //                        scorelabel.backgroundColor=[UIColor redColor];
                            scorelabel.textAlignment = NSTextAlignmentRight;
                            scorelabel.textColor = [UIColor whiteColor];
                            if([[NSString stringWithFormat:@"%@",[[[challengesArray objectAtIndex:i] objectForKey:@"framePoints"] objectAtIndex:framecount]]isEqualToString:@"0" ])
                            {
                                categorylabel.text = [NSString stringWithFormat:@"Frame %d ",framecount+1];
                                scorelabel.text=@"...pending";
                                
                            }
                            else
                            {
                                categorylabel.text = [NSString stringWithFormat:@"Frame %d ",framecount+1];
                                scorelabel.text=[NSString stringWithFormat:@"%@",[[[challengesArray objectAtIndex:i] objectForKey:@"framePoints"] objectAtIndex:framecount]];
                                
                            }
                            [challengesScrollView addSubview:scorelabel];
                            [challengesScrollView addSubview:categorylabel];
                            ycordinatefg=ycordinatefg+25;
                            challengeycordianate=ycordinatefg-40;
                        }
                    }
                }
                challengeycordianate=challengeycordianate+67;
                challengesScrollView.contentSize=CGSizeMake(250, challengeycordianate+ 10);
            }
        }
        else
        {
            UILabel *suggestions2 =  [[UILabel alloc] initWithFrame: CGRectMake(0,0,mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
            suggestions2.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
            suggestions2.textAlignment = NSTextAlignmentCenter;
            suggestions2.textColor = [UIColor whiteColor];
            suggestions2.backgroundColor=[UIColor clearColor];
            suggestions2.text = @"It looks like you haven't entered any Challenge yet!";
            suggestions2.numberOfLines=0;
            suggestions2.lineBreakMode=NSLineBreakByWordWrapping;
            [challengesScrollView addSubview:suggestions2];
        }
    }
    @catch (NSException *exception) {
        UILabel *suggestions2 =  [[UILabel alloc] initWithFrame: CGRectMake(0,0,mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        suggestions2.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
        suggestions2.textAlignment = NSTextAlignmentCenter;
        suggestions2.textColor = [UIColor whiteColor];
        suggestions2.backgroundColor=[UIColor clearColor];
        suggestions2.text = @"It looks like you haven't entered any Challenge yet!";
        suggestions2.numberOfLines=0;
        suggestions2.lineBreakMode=NSLineBreakByWordWrapping;
        [challengesScrollView addSubview:suggestions2];
        
    }
    
    
    //Pin View button
    RoundedRectButton *backButton=[[RoundedRectButton alloc]init];
    [backButton buttonFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:self.superview.frame.size.width], headerLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    backButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
    [backButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.5] buttonframe:backButton.frame] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:backButton.frame] forState:UIControlStateHighlighted];
//    [backButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7]];
    backButton.tag=11000;
    [backButton setTitle:@"Pin View" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    // Challenges Button
    UIButton *challengesButton=[[UIButton alloc]init];
    [challengesButton setFrame:CGRectMake(headerLabel.frame.size.width+headerLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:self.superview.frame.size.width], headerLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28.33 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    challengesButton.layer.cornerRadius=challengesButton.frame.size.height/2;
    challengesButton.clipsToBounds=YES;
    [challengesButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.5] buttonframe:challengesButton.frame] forState:UIControlStateNormal];
    [challengesButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:challengesButton.frame] forState:UIControlStateHighlighted];
    [challengesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [challengesButton setTitle:@"Challenges" forState:UIControlStateNormal];
    challengesButton.titleEdgeInsets=UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
    challengesButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
//    [challengesButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7]];
    challengesButton.tag=12000;
    challengesButton.layer.borderColor=[UIColor whiteColor].CGColor;
    challengesButton.layer.borderWidth=0.7;
    [challengesButton addTarget:self action:@selector(challengeViewFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:challengesButton];
    
    //Post As Challenge
    UIButton *postAsChallengeButton=[[UIButton alloc]init];
    [postAsChallengeButton setFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.superview.frame.size.width], mainScrollView.frame.size.height + mainScrollView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.superview.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1122/3 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    postAsChallengeButton.layer.cornerRadius=postAsChallengeButton.frame.size.height/2;
    postAsChallengeButton.clipsToBounds=YES;
    [postAsChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:postAsChallengeButton.frame] forState:UIControlStateNormal];
    [postAsChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:postAsChallengeButton.frame] forState:UIControlStateHighlighted];
    [postAsChallengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    postAsChallengeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
    [postAsChallengeButton setTitle:@"Post as a Challenge" forState:UIControlStateNormal];
    [postAsChallengeButton addTarget:self action:@selector(postAsChallengeFunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:postAsChallengeButton];

    //Bowl Again
    UIButton *bowlAgainButton=[[UIButton alloc]init];
    [bowlAgainButton setFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.superview.frame.size.width], postAsChallengeButton.frame.size.height+postAsChallengeButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.superview.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:500/3 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    [bowlAgainButton setBackgroundImage:[UIImage imageNamed:@"bordered_button.png"] forState:UIControlStateNormal];
     bowlAgainButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height]];
    [bowlAgainButton setTitle:@"Bowl Again" forState:UIControlStateNormal];
    [bowlAgainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bowlAgainButton.titleLabel.numberOfLines = 0;
    [bowlAgainButton setBackgroundImage:[UIImage imageNamed:@"bordered_button_onclick.png"] forState:UIControlStateHighlighted];
    [bowlAgainButton addTarget:self action:@selector(bowlAgainButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bowlAgainButton];

    //Share
    UIButton *shareButton=[[UIButton alloc]init];
    [shareButton setFrame:CGRectMake(bowlAgainButton.frame.size.width+bowlAgainButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:122/3 currentSuperviewDeviceSize:self.superview.frame.size.width], bowlAgainButton.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:500/3 currentSuperviewDeviceSize:self.superview.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.superview.frame.size.height])];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"bordered_button.png"] forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    //make the buttons content appear in the center
    [shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [shareButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    shareButton.contentEdgeInsets=UIEdgeInsetsMake(3.5, 0.0, 0.0, 0.0);
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"bordered_button_onclick.png"] forState:UIControlStateHighlighted];
     [shareButton addTarget:self action:@selector(shareButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:kgameComplete] == 0) {
        postAsChallengeButton.hidden=YES;
        shareButton.hidden=YES;
        bowlAgainButton.hidden=YES;
        mainScrollView.frame= CGRectMake(0,headerLabel.frame.origin.y+headerLabel.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.superview.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1075/3 currentSuperviewDeviceSize:self.superview.frame.size.height]);
    }
    
}

- (void)challengeViewFunction:(RoundedRectButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Challenges"]) {
        //show Challenges
        challengesScrollView.hidden=NO;
        mainScrollView.hidden=YES;
        [sender setTitle:@"Game Stats" forState:UIControlStateNormal];
    }
    else{
        //show Game Stats
        challengesScrollView.hidden=YES;
        mainScrollView.hidden=NO;
        [sender setTitle:@"Challenges" forState:UIControlStateNormal];
    }
   
}

- (void)backButtonFunction
{
    BowlingView *parentView=(BowlingView*)[self superview];
    [parentView removeGameSummary];
}

- (void)bowlAgainButtonFunction
{
    BowlingView *parentView=(BowlingView*)[self superview];
    [parentView bowlAgainFunction];
}

- (void)postAsChallengeFunction
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"You are the Organizer" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create Game", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].placeholder=@"Game Name";
    av.delegate = self;
    av.tag=101;
    [av show];
}

-(void)postThisGame:(NSString *)gameName
{
    
    if([gameName length] >0)
    {
        
        Reachability * reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (netStatus == NotReachable)
        {
            [[DataManager shared] removeActivityIndicator];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            alert=nil;
         }
        else
        {
            
            NSError *error = NULL;
            NSDictionary *competitionDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Posted", @"competitionType", @"1", @"maxChallengersPerGroup",  gameName, @"name", @"1", @"maxGroups",  nil];
            NSDictionary *idDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:kbowlingGameId], @"id", nil];
            NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:competitionDict, @"competition", @"0", @"entryFeeCredits", idDictionary, @"bowlingGame", nil];
            NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                           options:NSJSONWritingPrettyPrinted error:&error];
            
            NSString* dataString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
            
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
            NSString *urlString = [NSString stringWithFormat:@"%@bowlingcompetition/posted?apiKey=%@&token=%@", serverAddress, APIKey, token];
            
            [URLrequest setURL:[NSURL URLWithString:urlString]];
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
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                NSLog(@"json=%@, response code",json);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Game Posted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag=103;
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"An error occurred. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
            
            
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Enter Game Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
}

#pragma mark - Post Score on Facebook
- (void)shareButtonFunction
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to post your score on Facebook?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag=102;
    [alertView show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (alertView.tag == 102) {
        // Share
        if(buttonIndex == 1)
        {
            [self fbPostFunction];
        }
    }
    else if(alertView.tag == 101)
    {
        //Post Challenge
        if(buttonIndex == 1)
        {
            [self postThisGame:[alertView textFieldAtIndex:0].text];
        }
    }
    else if (alertView.tag == 103)
    {
        [self performSelector:@selector(addPostedGameTag) withObject:nil afterDelay:0.2];
    }
}

- (void)addPostedGameTag
{
    NSLog(@"savedTags=%@",[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]);
    NSArray *savedTagsArray=[[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPostedGameTagAdded];
    if (![savedTagsArray containsObject:@"Posted Game"]) {
        NSString *saveTags=@"Posted Game";
        [[DataManager shared]activityIndicatorAnimate:@"Saving Tags..."];
        if (savedTagsArray.count > 0) {
            saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@",%@",[savedTagsArray componentsJoinedByString:@","]]];
        }
        else{
            saveTags=[saveTags stringByAppendingString:[NSString stringWithFormat:@"%@",[savedTagsArray componentsJoinedByString:@","]]];
        }
        [summaryDelegate updateTags:saveTags];
    }

}

-(void)fbPostFunction
{
    [summaryDelegate fbScorePost];
}
/*-(void)fbPostFunction
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        //        [FBSession.activeSession closeAndClearTokenInformation];
        
        NSArray *permissions=[[NSArray alloc]initWithObjects:@"publish_stream", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             //             NSLog(@"session=%hhd  status=%d",session.isOpen,session.state);
             if(error)
             {
                 //                 NSLog(@"error=%d   %hhd",error.fberrorCategory,error.fberrorShouldNotifyUser);
                 [[DataManager shared]removeActivityIndicator];
                 if (error.fberrorCategory == FBErrorCategoryUserCancelled)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"" message:@"App could not get the desired permissions to use your Facebook account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                     
                 }
                 else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Session Error" message:@"Your current session is no longer valid. Please log in again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                 }
                 if(error.fberrorShouldNotifyUser == 1)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Failed to login" message:[NSString stringWithFormat:@"%@",error.fberrorUserMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                 }
                 
             }
             
             else if(FBSession.activeSession.isOpen)
             {
                 
                 FBRequest *me = [FBRequest requestForMe];
                 
                 [me startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my,NSError *error)
                  {
                      [[NSUserDefaults standardUserDefaults]setValue:session.accessTokenData.accessToken forKey:@"FB_ACCESSTOKEN"];
                      if (!error)  {
                          [self fbPostServerCall];
                      }
                      else {
                          [[DataManager shared]removeActivityIndicator];
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"An error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                          NSLog(@"fb login failed");
                      }
                  }];
                 
                 
             }
             
             else {
                 
                 NSLog(@"fb login failed");
                 
             }
         }];
    }
    
}
-(void)fbPostServerCall
{
    
    NSMutableURLRequest *URLrequest=[[NSMutableURLRequest alloc] init];
    [URLrequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [URLrequest setTimeoutInterval:kTimeoutInterval];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //    [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@social/facebookPost/bowlinggame/%@?token=%@&apiKey=%@&accessToken=%@&MessageText=Hey!",serverAddress,[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId],token,APIKey,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ACCESSTOKEN"]]]]];
    [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@social/facebook/bowlinggame/%@?token=%@&apiKey=%@&accessToken=%@",serverAddress,[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId],token,APIKey,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ACCESSTOKEN"]]]]];
    NSLog(@"enquiryURL=%@",[NSString stringWithFormat:@"%@social/facebook/bowlinggame/%@?token=%@&apiKey=%@&accessToken=%@",serverAddress,[[NSUserDefaults standardUserDefaults] objectForKey:kbowlingGameId],token,APIKey,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ACCESSTOKEN"]]]);
    [URLrequest setHTTPMethod:@"POST"];
    //    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [URLrequest setHTTPBody:postdata];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    
    if (response.statusCode==200) {
        UIAlertView *fbAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Your score was posted to Facebook and you receive 5 credits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [fbAlert show];
        
    }
    else if (response.statusCode == 400)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post the same message twice in a row to Facebook. Please try again after you have posted a different post at least once!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else if (response.statusCode == 403 || response.statusCode == 409)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post to social media more than 6 times in a 1 month period.  Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred posting to Facebook. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        
    }
     [[DataManager shared]removeActivityIndicator];
    
    
}*/

@end
