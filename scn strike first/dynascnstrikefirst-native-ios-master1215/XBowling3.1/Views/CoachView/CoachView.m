//
//  CoachView.m
//  XBowling3.1
//
//  Created by clicklabs on 1/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CoachView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.width)

@implementation CoachView
{
    NSMutableArray *laneSummaryDict;
    NSMutableArray *standingPinsArray;
    NSMutableArray *AllPlayerStandingPinsArray;
    NSMutableArray *latestSquareNumberArray;

    UIView *backview;
    UIScrollView*  addressView;
    UIImage *pinStanding;
    UIImage *pinfall;
    UIView *headerBlueBackground;
    
    NSTimer * mytimer;
    NSString *enquiryUrl;
    
    float boxSpacing;
    float firstboxXcordinate;
    int tag;
    float xcoordinate;
    int rowcount;
    float boxWidth;
    float boxHeight;
    float pinfallBackViewheight;
    NSUInteger previousLaneSummaryCount;
    float varingYcordinateofScrollView;
    int CurrentvenueId,CurrentlaneNumber;
    NSMutableArray *playerBackgroundHeights;
    
    NSMutableArray *isCompleteArray;
}
@synthesize coachDelegate=_coachDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tag=0;
        rowcount=5;
        varingYcordinateofScrollView=0;
        previousLaneSummaryCount=0;
        latestSquareNumberArray=[[NSMutableArray alloc]init];
        standingPinsArray=[NSMutableArray new];
        playerBackgroundHeights=[NSMutableArray new];
        isCompleteArray=[NSMutableArray new];
        
#pragma mark - Check For iPhone 4
        
        if(SCREEN_HEIGHT==480.0)
        {
            boxWidth=43.6;
            boxHeight=42;
            boxSpacing=4;
            firstboxXcordinate=4;
        }
        else
        {
            boxWidth=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:192/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
            boxHeight=[self getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:185/3 currentSuperviewDeviceSize:SCREEN_HEIGHT];
            boxSpacing=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
            firstboxXcordinate=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
        }
        
        xcoordinate=firstboxXcordinate;
        pinfall=[UIImage imageNamed:@"ball_down.png"];
        pinStanding=[UIImage imageNamed:@"ball_up.png"];
        
        self.backgroundColor=[UIColor redColor];
        backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
        backview.backgroundColor=[UIColor clearColor];
        [self addSubview: backview];
        
        UIImageView* mainBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
        mainBackImage.image=[UIImage imageNamed:@"mainbackground.png"];
        mainBackImage.userInteractionEnabled=YES;
        [backview addSubview:mainBackImage];
        
        headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:135/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
        headerBlueBackground.backgroundColor=XBHeaderColor;
        [backview addSubview:headerBlueBackground];
        
        UIView *headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, headerBlueBackground.frame.size.height)];
        headerwhiteBackground.backgroundColor=[UIColor clearColor];
        [backview addSubview:headerwhiteBackground];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT/2-200, headerwhiteBackground.frame.size.height+3- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:SCREEN_WIDTH]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width]-10, 400, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        headerLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kliveGameCenterName]];
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.numberOfLines=2;
        headerLabel.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerwhiteBackground addSubview:headerLabel];
        
        UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake(15, headerwhiteBackground.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
        [sideNavigationButton setImage:[UIImage imageNamed:@"back_login.png"] forState:UIControlStateNormal];
        [sideNavigationButton setImage:[UIImage imageNamed:@"back_login_onclick.png"] forState:UIControlStateHighlighted];
        [sideNavigationButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchDown];
        [headerwhiteBackground addSubview:sideNavigationButton];
    }
    return self;
}

#pragma mark - Fetch Ist Api Response & Make View Accordingly

-(void)getLiveScoreInbackground:(NSArray*)response
{
    laneSummaryDict=[[NSMutableArray  alloc]initWithArray:response];
    NSLog(@"laneSummaryDict=%@",laneSummaryDict);
    [latestSquareNumberArray removeAllObjects];
    [playerBackgroundHeights removeAllObjects];
    playerBackgroundHeights=[NSMutableArray new];
    
    for(int i=0;i<laneSummaryDict.count;i++)
         {
             [isCompleteArray addObject:[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:@"isComplete"]]];
             
             if(![[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i] objectForKey:@"squareScore21"]] isEqualToString:@""])
             {
                 [playerBackgroundHeights addObject:[NSString stringWithFormat:@"%f",[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1096/3 currentSuperviewDeviceSize:SCREEN_WIDTH]]];
             }
             else
             {
                 [playerBackgroundHeights addObject:[NSString stringWithFormat:@"%f",[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:856/3 currentSuperviewDeviceSize:SCREEN_WIDTH]]];
             }
             
        if([[[laneSummaryDict objectAtIndex:i]objectForKey:@"latestSquareNumber"]integerValue]<21)
        {
            [latestSquareNumberArray addObject:[NSString stringWithFormat:@"%ld",(long)([[[laneSummaryDict objectAtIndex:i]objectForKey:@"latestSquareNumber"]integerValue]+1)/2]];
        }
        else
        {
            [latestSquareNumberArray addObject:@"10"];
        }
    }
    
    AllPlayerStandingPinsArray=[NSMutableArray new];
    for(int j=0;j<laneSummaryDict.count;j++)
    {
        standingPinsArray =[NSMutableArray new];
        for (int i=1; i<22; i++)
        {
            NSString *standingPinsKey;
            if (i<10)
            {
                standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",i];
            }
            else
            {
                standingPinsKey = [NSString stringWithFormat:@"standingPins%d",i];
            }
            [standingPinsArray addObject:[[laneSummaryDict objectAtIndex:j] objectForKey:standingPinsKey]];
        }
        [AllPlayerStandingPinsArray addObject:standingPinsArray];
    }
    [self loadView];
}

#pragma mark - Make Scroll View

-(void)loadView
{
    addressView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerBlueBackground.frame.size.height, SCREEN_HEIGHT, SCREEN_WIDTH-headerBlueBackground.frame.size.height)];
    [addressView setBackgroundColor:[UIColor colorWithRed:4/255.0f green:20/255.0f blue:36/255.0f alpha:0.6]];
    [addressView setShowsHorizontalScrollIndicator:NO];
    [addressView setShowsVerticalScrollIndicator:NO];
    [backview addSubview:addressView];
    
    addressView.contentSize=CGSizeMake(SCREEN_HEIGHT, laneSummaryDict.count*[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1096/3 currentSuperviewDeviceSize:SCREEN_WIDTH]);
    
    [self scrollViewData];
    
    
    mytimer=  [NSTimer scheduledTimerWithTimeInterval:15
                                               target:self
                                             selector:@selector(updateInbackground)
                                             userInfo:nil
                                              repeats:YES];
}

#pragma mark - Load Data On Scroll View

-(void)scrollViewData
{
    for(int playerCount=previousLaneSummaryCount;playerCount<[laneSummaryDict count];playerCount++)
    {
        UIView *cellBackView;
//        if(playerCount<[playerBackgroundHeights count])
//        {
       cellBackView =[[UIView alloc]initWithFrame:CGRectMake(00, varingYcordinateofScrollView, SCREEN_HEIGHT,[[playerBackgroundHeights objectAtIndex:playerCount]floatValue])];
       // }
       // else{
//            cellBackView =[[UIView alloc]initWithFrame:CGRectMake(00, varingYcordinateofScrollView, SCREEN_HEIGHT,[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1096/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
       // }
        
        cellBackView.tag=200+playerCount;
        NSLog(@"cellBackView.tag :%ld",(long)cellBackView.tag);
        cellBackView.backgroundColor=[UIColor clearColor];
        [addressView addSubview:cellBackView];
        
        
        UILabel *playerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([ self
                                                                           getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:SCREEN_WIDTH], [self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:self.frame.size.height], SCREEN_HEIGHT/2-20, [self getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [playerNameLabel setBackgroundColor:[UIColor clearColor]];
        playerNameLabel.text=[[[NSString stringWithFormat:@"%@",[[[laneSummaryDict objectAtIndex:playerCount]objectForKey:@"name"] stringByRemovingPercentEncoding]]componentsSeparatedByString:@"+"]componentsJoinedByString:@" "];
        playerNameLabel.textColor=[UIColor whiteColor];
        playerNameLabel.textAlignment=NSTextAlignmentLeft;
        playerNameLabel.numberOfLines=0;
        playerNameLabel.lineBreakMode=NSLineBreakByWordWrapping;
        playerNameLabel.font=[UIFont fontWithName:AvenirDemi size:[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [cellBackView addSubview:playerNameLabel];
        
        
        UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(cellBackView.frame.size.width/2+10, playerNameLabel.frame.origin.y, SCREEN_HEIGHT/2-2*[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:screenBounds.size.height], playerNameLabel.frame.size.height)];
        [scoreLabel setBackgroundColor:[UIColor clearColor]];
        scoreLabel.text=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:@"finalScore"]];
        scoreLabel.textColor=[UIColor whiteColor];
        scoreLabel.textAlignment=NSTextAlignmentRight;
        scoreLabel.tag=1212122157+playerCount;
        scoreLabel.numberOfLines=0;
        scoreLabel.lineBreakMode=NSLineBreakByWordWrapping;
        scoreLabel.font=[UIFont fontWithName:AvenirDemi size:[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [cellBackView addSubview:scoreLabel];
        
        tag=0;
        xcoordinate=firstboxXcordinate;
        
        for(int i=0;i<10;i++)
        {
            CoachScoreFrameView *coachscoreFrame;
            if(i==9){
                coachscoreFrame=[[CoachScoreFrameView alloc]initWithFrame:CGRectMake(xcoordinate, [self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:SCREEN_WIDTH], boxWidth, boxHeight)];
            }
            else{
                coachscoreFrame=[[CoachScoreFrameView alloc]initWithFrame:CGRectMake(xcoordinate, [self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:SCREEN_WIDTH], boxWidth, boxHeight)];
            }
            coachscoreFrame.userInteractionEnabled=YES;
            //NSLog(@"coach frame tag :%d",(500+(i+1))*(playerCount+1));
            coachscoreFrame.tag=(500+(i+1))*(playerCount+1);
            coachscoreFrame.layer.cornerRadius=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
            coachscoreFrame.layer.masksToBounds=YES;
            coachscoreFrame.frameNumber=[NSString stringWithFormat:@"%d",i+1];
            if((i+1)<[[latestSquareNumberArray objectAtIndex:playerCount]integerValue])
            {
                coachscoreFrame.backViewColor=[UIColor whiteColor];
                coachscoreFrame.separatorLineColor=[UIColor blackColor];
                coachscoreFrame.frameNumberTextColor=[UIColor blackColor];
            }
            else if((i+1)==[[latestSquareNumberArray objectAtIndex:playerCount]integerValue]){
                coachscoreFrame.separatorLineColor=[UIColor blackColor];
                coachscoreFrame.backViewColor=XbCurrentBoxcolor;
                coachscoreFrame.frameNumberTextColor=[UIColor whiteColor];
            }
            else
            {
                coachscoreFrame.backViewColor=unPlayedBoxcolor;
                coachscoreFrame.separatorLineColor=[UIColor colorWithRed:3/255.0f green:28/255.0f blue:46/255.0f alpha:1.0];;
                coachscoreFrame.frameNumberTextColor=[UIColor whiteColor];
            }
            
            coachscoreFrame.ball1score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",((i+1)*2)-1]]];
            coachscoreFrame.ball2score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",((i+1)*2)]]];
            if(i==9)
            {
                coachscoreFrame.ball3scoretenthFrame=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore21"]]];
            }
            coachscoreFrame.totalScore=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"frameScore%d",(i+1)]]];
            [coachscoreFrame loadViewWithText];
            
            if(  [[[laneSummaryDict objectAtIndex:playerCount]objectForKey:@"isComplete"]integerValue]==1)
            {
                coachscoreFrame.backViewColor=[UIColor whiteColor];
                coachscoreFrame.frameNumberTextColor=[UIColor blackColor];
                [coachscoreFrame updateText];
            }
            [cellBackView addSubview:coachscoreFrame];
            xcoordinate=coachscoreFrame.frame.size.width+coachscoreFrame.frame.origin.x+boxSpacing;
        }
        
        float ycordinateOfPpinRow=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:SCREEN_WIDTH]+boxHeight+boxSpacing;
        
        for(int j=0;j<3;j++)
        {
            UIView *pinFallbackView
            =[[UIView alloc]initWithFrame:CGRectMake(00, ycordinateOfPpinRow, SCREEN_HEIGHT,boxHeight)];
            pinFallbackView.tag=181818181+playerCount*(j+1);
            pinFallbackView.backgroundColor=[UIColor clearColor];
            [cellBackView addSubview:pinFallbackView];
            
            float  xcordinateBall=firstboxXcordinate;
            int count=10;
            if(j==2)
            {
                count=1;
            }
            
            for(int i=0;i<count;i++)
            {
                //first Row
                if(j!=2)
                {
                    PinFallClass *pinfallView=[[PinFallClass alloc]init];
                    
                    pinfallView.frame=CGRectMake(xcordinateBall, 0, boxWidth, boxHeight);
                    pinfallView.standingPin=pinStanding;
                    pinfallView.downPin=pinfall;
                    if(j==0)
                    {
                        [pinfallView updateSingleFrameView:0 standingPinsArray:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:(2*(i+1)-1)-1] bowlCount:6];
                        
                        pinfallView.tag=(50000+(i+1))*(playerCount+1);
                        
                        if((i+1)>[[latestSquareNumberArray objectAtIndex:playerCount]integerValue])
                        {
                            pinfallView.hidden=YES;
                        }
                        //NSLog(@"pinindex1 :%d",((2*(i+1)-1)-1));
                        [pinfallView updatePins:i+1 standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:((2*(i+1)-1)-1)]];
                    }
                    else
                    {
                        pinfallView.tag=(6000000+(i+1))*(playerCount+1);
                        [pinfallView updateSingleFrameView:0 standingPinsArray:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:(2*(i+1))-1] bowlCount:6];
                        
                        if((i+1)>[[latestSquareNumberArray objectAtIndex:playerCount]integerValue]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",((i+1)*2)-1]]]isEqualToString:@"X"])
                        {
                            if(i!=9)
                            {
                            pinfallView.hidden=YES;
                            }
                            else{
                                if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]]isEqualToString:@""])
                                {
                                    pinfallView.hidden=YES;
                                }
                                else{
                                    pinfallView.hidden=NO;
                                }
                            }
                        }
                        else if((i+1)==[[latestSquareNumberArray objectAtIndex:playerCount]integerValue])
                        {
                            if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",((i+1)*2)]]]isEqualToString:@""])
                            {
                                pinfallView.hidden=YES;
                            }
                        }
                        else if(i+1==10)
                        {
                            pinfallView.hidden=NO;
                        }
                        
                        //NSLog(@"pinindex2 :%d",((2*(i+1))-1));
                        [pinfallView updatePins:i+1 standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:((2*(i+1))-1)]];
                    }
                    
                    pinfallView .backgroundColor=[UIColor whiteColor];
                    pinfallView.layer.cornerRadius=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
                    [pinFallbackView addSubview:pinfallView];
                    
                    xcordinateBall=pinfallView.frame.size.width+pinfallView.frame.origin.x+boxSpacing;
                }
                else
                {
                    float tengthCordinate=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:36/3 currentSuperviewDeviceSize:SCREEN_WIDTH]+9*(boxWidth+boxSpacing);
                    
                    PinFallClass *pinfallView=[[PinFallClass alloc]init];
                    pinfallView.frame=CGRectMake(tengthCordinate,0, boxWidth, boxHeight);
                    
                    pinfallView.standingPin=pinStanding;
                    pinfallView.downPin=pinfall;
                    pinfallView.tag=123123123*(playerCount+1);
                    //NSLog(@"count :%lu",(unsigned long)[[AllPlayerStandingPinsArray objectAtIndex:playerCount]count]);
                    [pinfallView updateSingleFrameView:0 standingPinsArray:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:20] bowlCount:6];
                    
//                    if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",19]]]isEqualToString:@"X"]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]]isEqualToString:@"/"]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]]isEqualToString:@"X"])
//                    {
                        if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:playerCount]objectForKey:[NSString stringWithFormat:@"squareScore%d",21]]]isEqualToString:@""])
                        {
                            pinfallView.hidden=YES;
                        }
                        else
                        {
                            pinfallView.hidden=NO;
                        }
                    
                    [pinfallView updatePins:i+1 standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:playerCount]objectAtIndex:20]];
                    
                    pinfallView .backgroundColor=[UIColor whiteColor];
                    pinfallView.layer.cornerRadius=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
                    [pinFallbackView addSubview:pinfallView];
                }
            }
            ycordinateOfPpinRow=ycordinateOfPpinRow+ boxHeight+boxSpacing;
        }
        
        varingYcordinateofScrollView=cellBackView.frame.origin.y+cellBackView.frame.size.height;
        
        UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(00,cellBackView.frame.size.height-2, SCREEN_HEIGHT,1)];
        separatorLine.tag=11111111+playerCount;
        separatorLine.backgroundColor=coachViewPlayerSeparatorLine;
        [cellBackView addSubview:separatorLine];
        
        if(playerCount==[laneSummaryDict count]-1)
        {
            [[DataManager shared]removeActivityIndicator];
            previousLaneSummaryCount=[laneSummaryDict count];
            addressView.contentSize=CGSizeMake(SCREEN_HEIGHT, varingYcordinateofScrollView);
        }
    }
}

#pragma mark - Updating Score in Background

- (void)backGroundUpdateAction:(NSArray *)profileResponse {
    
    [playerBackgroundHeights removeAllObjects];
    playerBackgroundHeights=[NSMutableArray new];
    [isCompleteArray removeAllObjects];
    isCompleteArray=[NSMutableArray new];
    NSArray*  tempToCheck=profileResponse;
    NSLog(@"previousLaneSummaryCount :%lu  tempToCheck :%lu",(unsigned long)previousLaneSummaryCount,(unsigned long)tempToCheck.count);
    // NSLog(@"laneSummaryDict=%@",laneSummaryDict);
    if(tempToCheck.count>previousLaneSummaryCount)
    {
        NSMutableArray *lane=[[NSMutableArray alloc]initWithArray:laneSummaryDict];
        for(NSUInteger i=laneSummaryDict.count;i<tempToCheck.count;i++)
        {
            [lane  addObject:[tempToCheck objectAtIndex:i]];
        }
        laneSummaryDict=lane;
    }
    else
    {
        laneSummaryDict=[[NSMutableArray alloc]initWithArray:tempToCheck];;
    }
    
    [latestSquareNumberArray removeAllObjects];
    
    for(int i=0;i<laneSummaryDict.count;i++)
    {
        [isCompleteArray addObject:[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:@"isComplete"]]];

        if([[[laneSummaryDict objectAtIndex:i]objectForKey:@"latestSquareNumber"]integerValue]<21)
        {
            [latestSquareNumberArray addObject:[NSString stringWithFormat:@"%ld",([[[laneSummaryDict objectAtIndex:i]objectForKey:@"latestSquareNumber"]integerValue]+1)/2]];
            
            [playerBackgroundHeights addObject:[NSString stringWithFormat:@"%f",[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:856/3 currentSuperviewDeviceSize:SCREEN_WIDTH]]];
        }
        else
        {
            [latestSquareNumberArray addObject:@"10"];
          if(![[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i] objectForKey:@"squareScore21"]] isEqualToString:@""])
          {
            [playerBackgroundHeights addObject:[NSString stringWithFormat:@"%f",[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1096/3 currentSuperviewDeviceSize:SCREEN_WIDTH]]];
          }
          else
          {
              [playerBackgroundHeights addObject:[NSString stringWithFormat:@"%f",[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:856/3 currentSuperviewDeviceSize:SCREEN_WIDTH]]];
          }
        }
    }
    
    [AllPlayerStandingPinsArray removeAllObjects];
    AllPlayerStandingPinsArray=[NSMutableArray new];
    
    
    for(int j=0;j<laneSummaryDict.count;j++)
    {
        standingPinsArray =[NSMutableArray new];
        
        for (int i=1; i<22; i++) {
            NSString *standingPinsKey;
            if (i<10)
            {
                standingPinsKey = [NSString stringWithFormat:@"standingPins0%d",i];
            }
            else
            {
                standingPinsKey = [NSString stringWithFormat:@"standingPins%d",i];
            }
            [standingPinsArray addObject:[[laneSummaryDict objectAtIndex:j] objectForKey:standingPinsKey]];
        }
        [AllPlayerStandingPinsArray addObject:standingPinsArray];
    }
    
    if(previousLaneSummaryCount<[laneSummaryDict count])
    {
        [self scrollViewData];
    }
    else
    {
        previousLaneSummaryCount=[laneSummaryDict count];
    }
    
    for(int i=0;i<laneSummaryDict.count;i++)
    {
        
              UIView *mainBackView=(UIView *)   [self viewWithTag:200+i];
            UIView *mainBackViewprevious=(UIView *)   [self viewWithTag:200+i-1];
            float ycprdinate;
            if(i==0)
            {
                ycprdinate=mainBackView.frame.origin.y;
            }
            else{
                ycprdinate= mainBackViewprevious.frame.origin.y+mainBackViewprevious.frame.size.height;
            }
            
        if(![[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i] objectForKey:@"squareScore21"]] isEqualToString:@""])
        {
            mainBackView.frame=CGRectMake(mainBackView.frame.origin.x, ycprdinate
                                          , mainBackView.frame.size.width, [self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1096/3 currentSuperviewDeviceSize:SCREEN_WIDTH]);
        }
        else{
            mainBackView.frame=CGRectMake(mainBackView.frame.origin.x, ycprdinate
                                          , mainBackView.frame.size.width, [self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:856/3 currentSuperviewDeviceSize:SCREEN_WIDTH]);
        }
                UIView *mainBackView12=(UIView *)   [self viewWithTag:11111111+i];

                mainBackView12.frame=CGRectMake(mainBackView12.frame.origin.x, mainBackView.frame.size.height-2
                                              , mainBackView12.frame.size.width, mainBackView12.frame.size.height);
                
            }
    
    UIView*  mainBackViewNext=(UIView *)   [self viewWithTag:200+laneSummaryDict.count-1];
    addressView.contentSize=CGSizeMake(addressView.frame.size.width, mainBackViewNext.frame.size.height+mainBackViewNext.frame.origin.y+10);
    
    
#pragma mark - Updating View With Tags
    
    for(int i=0;i<[laneSummaryDict count];i++)
    {
        UILabel *scoreLabel=(UILabel *)   [self viewWithTag:1212122157+i];
        scoreLabel.text=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:@"finalScore"]];
        
        for(CoachScoreFrameView *subviews in [addressView viewWithTag:(200+i)
                                              ].subviews)
        {
            if(subviews.tag==(500+[[latestSquareNumberArray objectAtIndex:i]integerValue])*(i+1))
            {
                //updating Current Frame
                NSLog(@"subviews  %ld latest square %ld",(long)subviews.tag,(long)[[latestSquareNumberArray objectAtIndex:i]integerValue]);
                
                CoachScoreFrameView *tempView=(CoachScoreFrameView *)subviews;
                tempView.ball1score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",(([[latestSquareNumberArray objectAtIndex:i]intValue])*2)-1]]];
                tempView.ball2score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",(([[latestSquareNumberArray objectAtIndex:i]intValue])*2)]]];
                tempView.ball3scoretenthFrame=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore21"]]];
                tempView.backViewColor=XbCurrentBoxcolor;
                tempView.frameNumberTextColor=[UIColor whiteColor];
                tempView.totalScore=[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"frameScore%@",[latestSquareNumberArray objectAtIndex:i]]];
                
                NSLog(@"update text  are ball1 :%@ ball2 :%@ total :%@",tempView.ball1score,tempView.ball2score,tempView.totalScore);
                [tempView updateText];
                
                if(  [[[laneSummaryDict objectAtIndex:i]objectForKey:@"isComplete"]integerValue]==1)
                {
                    tempView.backViewColor=[UIColor whiteColor];
                    tempView.frameNumberTextColor=[UIColor blackColor];
                    [tempView updateText];
                }
            }
            else  if(subviews.tag==(500+[[latestSquareNumberArray objectAtIndex:i]integerValue]-1)*(i+1))
            {
                //updating previous frame
                
                NSLog(@"subviews  %ld previous square %ld",(long)subviews.tag,[[latestSquareNumberArray objectAtIndex:i]integerValue]-1);
                CoachScoreFrameView *tempView=(CoachScoreFrameView *)subviews;
                tempView.ball1score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%ld",((([[latestSquareNumberArray objectAtIndex:i]integerValue]-1))*2)-1]]];
                tempView.ball2score=[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%ld",((([[latestSquareNumberArray objectAtIndex:i]integerValue]-1))*2)]]];
                // tempView.ball3scoretenthFrame=@"45";
                tempView.backViewColor=[UIColor whiteColor];
                tempView.frameNumberTextColor=[UIColor blackColor];
                tempView.totalScore=[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"frameScore%d",([[latestSquareNumberArray objectAtIndex:i]integerValue]-1)]];
                
                NSLog(@"update text  are ball1 :%@ ball2 :%@ total :%@",tempView.ball1score,tempView.ball2score,tempView.totalScore);
                [tempView updateText];
                
                if(  [[[laneSummaryDict objectAtIndex:i]objectForKey:@"isComplete"]integerValue]==1)
                {
                    tempView.backViewColor=[UIColor whiteColor];
                    tempView.frameNumberTextColor=[UIColor blackColor];
                    [tempView updateText];
                }
            }
        }
        
        // Updating Pins
        
        int latestFrame=[[latestSquareNumberArray objectAtIndex:i]integerValue];
        int lastFrame=[[latestSquareNumberArray objectAtIndex:i]integerValue]-1;
        
        PinFallClass *tempView=(PinFallClass *)[self viewWithTag:(50000+latestFrame)*(i+1)];
        tempView.hidden=NO;
        [tempView updatePins:latestFrame standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:i]objectAtIndex:((2*(latestFrame)-1)-1)]];
        
        tempView=(PinFallClass *)[self viewWithTag: (6000000+latestFrame)*(i+1)];
        if(latestFrame!=10)
        {
            if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",((latestFrame)*2)-1]]]isEqualToString:@"X"]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",((latestFrame)*2)]]]isEqualToString:@""])
            {
                tempView.hidden=YES;
            }
            else
            {
                tempView.hidden=NO;
            }
        }
        else{
            if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",((latestFrame)*2)]]]isEqualToString:@""])
            {
                tempView.hidden=YES;
            }
            else
            {
                tempView.hidden=NO;
            }
        }
        [tempView updatePins:latestFrame standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:i]objectAtIndex:((2*(latestFrame)-1))]];
        
        if(latestFrame>1)
        {
            //last pin fall update
            tempView=(PinFallClass *)[self viewWithTag: (50000+lastFrame)*(i+1)];
            tempView.hidden=NO;
            [tempView updatePins:lastFrame standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:i]objectAtIndex:((2*(lastFrame)-1)-1)]];
            
            tempView=(PinFallClass *)[self viewWithTag:(6000000+lastFrame)*(i+1)];
            if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",((lastFrame)*2)-1]]]isEqualToString:@"X"])
            {
                tempView.hidden=YES;
            }
            else
            {
                tempView.hidden=NO;
            }
            [tempView updatePins:[[latestSquareNumberArray objectAtIndex:i]integerValue] standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:i]objectAtIndex:((2*(lastFrame)-1))]];
        }
        
        //3 rd ball update
        
        tempView=(PinFallClass *)[self viewWithTag:123123123*(i+1)];
        if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",19]]]isEqualToString:@"X"]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]]isEqualToString:@"/"]||[[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",20]]]isEqualToString:@"X"])
        {
            if([[NSString stringWithFormat:@"%@",[[laneSummaryDict objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"squareScore%d",21]]]isEqualToString:@""])
            {
                tempView.hidden=YES;
            }
            else
            {
                tempView.hidden=NO;
            }
        }
        else
        {
            tempView.hidden=YES;
        }
        [tempView updatePins:10 standingPinValue:[[AllPlayerStandingPinsArray objectAtIndex:i]objectAtIndex:20]];
    }
    
    if(![isCompleteArray containsObject:@"0"])
    {
        [mytimer invalidate];
        mytimer=nil;
    }
}

#pragma mark - Background Update Api Call

-(void)updateInbackground
{
    [_coachDelegate LiveScoreCall:@"" apinumber:2];
    
}

#pragma mark - Common Size function

- (CGFloat)getValueFromTargetSize:(CGFloat)targetSuperviewSize targetSubviewSize:(CGFloat)targetSubviewSize currentSuperviewDeviceSize:(CGFloat)currentSizeOfSuperview
{
    return currentSizeOfSuperview/(targetSuperviewSize/targetSubviewSize);
    
}

#pragma mark - Back button Action

- (void)sideMenuButtonAction{
    
    [mytimer invalidate]; mytimer=nil;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    
    [_coachDelegate backButtonAction];
}

@end
