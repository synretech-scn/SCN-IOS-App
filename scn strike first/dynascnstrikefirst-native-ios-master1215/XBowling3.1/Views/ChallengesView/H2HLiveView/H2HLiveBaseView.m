//
//  H2HLiveself.m
//  XBowling3.1
//
//  Created by Click Labs on 2/20/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "H2HLiveBaseView.h"

@implementation H2HLiveBaseView
{
    UILabel *noteLabel;
    UIButton *createGameButton;
    UIButton *joinGameButton;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
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
        headerLabel.text=@"H2H Live";
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
        
        noteLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:500/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:300/3 currentSuperviewDeviceSize:self.frame.size.height] )];
        noteLabel.backgroundColor=[UIColor clearColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        NSMutableAttributedString *noteText=[[NSMutableAttributedString alloc]initWithString:@"You are currently not entered \nin any live game." attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH1size]}];
        [noteText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteText length])];
        noteLabel.attributedText=noteText;
        noteLabel.numberOfLines=3;
        noteLabel.textAlignment=NSTextAlignmentCenter;
        noteLabel.textColor=[UIColor whiteColor];
        [self addSubview:noteLabel];
        
        createGameButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], noteLabel.frame.size.height+noteLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:620/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        createGameButton.layer.cornerRadius=createGameButton.frame.size.height/2;
        createGameButton.clipsToBounds=YES;
        createGameButton.center=CGPointMake(self.frame.size.width/2, createGameButton.center.y);
        [createGameButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5] buttonframe:createGameButton.frame] forState:UIControlStateNormal];
        [createGameButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0] buttonframe:createGameButton.frame] forState:UIControlStateHighlighted];
        [createGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createGameButton setTitle:@"Create Game" forState:UIControlStateNormal];
        [createGameButton addTarget:self action:@selector(createGameFunction) forControlEvents:UIControlEventTouchUpInside];
        createGameButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [self addSubview:createGameButton];
        
        joinGameButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], createGameButton.frame.size.height+createGameButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:620/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        joinGameButton.layer.cornerRadius=joinGameButton.frame.size.height/2;
        joinGameButton.clipsToBounds=YES;
        joinGameButton.center=CGPointMake(self.frame.size.width/2, joinGameButton.center.y);
        [joinGameButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5] buttonframe:joinGameButton.frame] forState:UIControlStateNormal];
        [joinGameButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0] buttonframe:joinGameButton.frame] forState:UIControlStateHighlighted];
        [joinGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinGameButton setTitle:@"Join Game" forState:UIControlStateNormal];
        [joinGameButton addTarget:self action:@selector(joinGameFunction) forControlEvents:UIControlEventTouchUpInside];
        joinGameButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [self addSubview:joinGameButton];

        //Initial setup
        createGameButton.hidden=YES;
        joinGameButton.hidden=YES;
    }
    return self;
}

- (void)joinGameFunction
{
    [delegate joinGame];
}

- (void)createGameFunction
{
    [delegate createGame];
}

- (void)backButtonFunction{
    [delegate removeh2hBaseView];
}

- (void)displayH2HLiveStatus:(NSString *)status
{
    if ([status isEqualToString:@"NotJoined"]) {
        createGameButton.hidden=NO;
        joinGameButton.hidden=NO;
     }
    else if ([status isEqualToString:@"WaitingForApproval"]) {
        noteLabel.text=@"Waiting for the Organizer to \n approve you...";
        createGameButton.hidden=YES;
        joinGameButton.hidden=YES;
//        UILabel *labelForText = [[UILabel alloc] initWithFrame:CGRectMake(0, 2,screenBounds.size.width, screenBounds.size.height)];
//        labelForText.backgroundColor = [UIColor clearColor];
//        labelForText.numberOfLines = 2;
//        labelForText.textAlignment = NSTextAlignmentCenter;
//        labelForText.text = @"Waiting for the Organizer to \n approve you...";
//        labelForText.textColor = [UIColor whiteColor];
//        labelForText.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
//        [self addSubview:labelForText];
    }
    else{
        noteLabel.text=@"Oh no! The Organizer rejected your entry into the live game. \nFind another game by tapping the join game button below!";
        createGameButton.hidden=NO;
        joinGameButton.hidden=NO;
    }
    
}

@end
