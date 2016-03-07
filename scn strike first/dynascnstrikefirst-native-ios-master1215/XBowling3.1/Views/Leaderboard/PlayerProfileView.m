//
//  PlayerProfileView.m
//  XBowling3.1
//
//  Created by Click Labs on 1/22/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "PlayerProfileView.h"

@implementation PlayerProfileView
{
    NSNumberFormatter *formatter;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createPlayerView:(NSDictionary *)playerDict
{
    
    // Display score in standard format
    formatter = [[NSNumberFormatter alloc] init];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [self addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Player Profile";
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
    
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:527/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    backImageView.image=[UIImage imageNamed:@"player_profile_bg.png"];
    [self addSubview: backImageView];
    
    //Player Profile Image and Name
    UIImageView *userImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    userImageView.backgroundColor=[UIColor grayColor];
    userImageView.layer.cornerRadius=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/6 currentSuperviewDeviceSize:screenBounds.size.height];
    userImageView.layer.masksToBounds=YES;
    userImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    userImageView.layer.borderWidth=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5 currentSuperviewDeviceSize:screenBounds.size.height];
    userImageView.image=[UIImage imageNamed:@"profile_img.png"];
    
    if ([playerDict count] > 0) {
        if ([[playerDict objectForKey:@"userProfile"] count] > 0) {
            if ([[playerDict objectForKey:@"userProfile"] objectForKey:@"pictureFile"] != [NSNull null]) {
                if ([[[playerDict objectForKey:@"userProfile"] objectForKey:@"pictureFile"]objectForKey:@"fileUrl"]) {
                    [userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[playerDict objectForKey:@"userProfile"]objectForKey:@"pictureFile"]objectForKey:@"fileUrl"]]] placeholderImage:[UIImage imageNamed:@"bg.png"]];
                }
            }
            UILabel *userName=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:303/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-333)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(282-60)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            userName.textAlignment=NSTextAlignmentCenter;
            //profileHeaderLabel.textColor=SMTextColorHeaderColor;
            userName.backgroundColor=[UIColor clearColor];
            userName.textAlignment=NSTextAlignmentLeft;
            userName.lineBreakMode=NSLineBreakByWordWrapping;
            userName.numberOfLines=0;
            NSMutableAttributedString *nameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[playerDict objectForKey:@"userProfile"] objectForKey:@"screenName"]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            //    NSAttributedString *placeLabelText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,%@",[playerDict objectForKey:@"user"]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
            //    [nameAttributedString appendAttributedString:placeLabelText];
            userName.attributedText=nameAttributedString;
            userName.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            userName.textColor=[UIColor whiteColor];
            //userName.text=@"User Profile";
            [backImageView addSubview:userName];

        }
        userImageView.userInteractionEnabled=true;
        [backImageView addSubview:userImageView];
        
        
        
        //Score Labels
        UILabel *averageScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backImageView.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:245/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:245/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        NSMutableAttributedString *avgScoreAttributedString=[[NSMutableAttributedString alloc] initWithString: [formatter stringFromNumber:[NSNumber numberWithInt:[[playerDict objectForKey:@"averageScore"] intValue]]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        NSAttributedString *averageScoreLabelText=[[NSAttributedString alloc] initWithString:@"\nAvg. Score" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [avgScoreAttributedString appendAttributedString:averageScoreLabelText];
        averageScoreLabel.attributedText=avgScoreAttributedString;
        averageScoreLabel.backgroundColor=[UIColor clearColor];
        averageScoreLabel.textColor=[UIColor whiteColor];
        averageScoreLabel.textAlignment=NSTextAlignmentCenter;
        averageScoreLabel.numberOfLines=0;
        [backImageView addSubview:averageScoreLabel];
        
        UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(averageScoreLabel.frame.size.width + averageScoreLabel.frame.origin.x , averageScoreLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], averageScoreLabel.frame.size.height)];
        NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString: [formatter stringFromNumber:[NSNumber numberWithInt:[[playerDict objectForKey:@"totalScore"] intValue]]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        NSAttributedString *scoreLabelText=[[NSAttributedString alloc] initWithString:@"\nScore" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [scoreAttributedString appendAttributedString:scoreLabelText];
        scoreLabel.backgroundColor=[UIColor clearColor];
        scoreLabel.attributedText=scoreAttributedString;
        scoreLabel.textColor=[UIColor whiteColor];
        scoreLabel.numberOfLines=0;
        scoreLabel.textAlignment=NSTextAlignmentCenter;
        [backImageView addSubview:scoreLabel];
        
        UILabel *totalGamesLabel=[[UILabel alloc]initWithFrame:CGRectMake(scoreLabel.frame.size.width + scoreLabel.frame.origin.x , averageScoreLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], averageScoreLabel.frame.size.height)];
        NSMutableAttributedString *totalGamesAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[playerDict objectForKey:@"totalGamesPlayed"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        NSAttributedString *totalGamesLabelText=[[NSAttributedString alloc] initWithString:@"\nTotal Games" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [totalGamesAttributedString appendAttributedString:totalGamesLabelText];
        totalGamesLabel.backgroundColor=[UIColor clearColor];
        totalGamesLabel.attributedText=totalGamesAttributedString;
        totalGamesLabel.textColor=[UIColor whiteColor];
        totalGamesLabel.numberOfLines=0;
        totalGamesLabel.textAlignment=NSTextAlignmentCenter;
        [backImageView addSubview:totalGamesLabel];
    }


}

-(void)backButtonFunction
{
    [delegate removePlayerProfileView];
}
@end
