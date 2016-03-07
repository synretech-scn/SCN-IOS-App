//
//  ChallengesMainView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ChallengesMainView.h"

@implementation ChallengesMainView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {


    }
    return self;
}

- (void)createChallengeView
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
    headerLabel.text=@"Challenges";
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
    
    //H2H Live Button
    UIView *H2HLiveSectionBackground=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:248/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    H2HLiveSectionBackground.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    [self addSubview:H2HLiveSectionBackground];
    
    UIImageView *liveIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 10, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:172/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:172/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    liveIcon.center=CGPointMake(liveIcon.center.x, H2HLiveSectionBackground.frame.size.height/2);
    [liveIcon setImage:[UIImage imageNamed:@"h2h live icon.png"]];
    [H2HLiveSectionBackground addSubview:liveIcon];
    
//    NSString *string = @"H2H Live \nCredits Required: Varies";
//    //        NSString *string = @"H2H Live";
//    NSRange range = [string rangeOfString:@"\n"];
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH3size] range:NSMakeRange(0,string.length)];
//    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH1size] range:NSMakeRange(0, range.location)];
//    if (screenBounds.size.height == 480)
//        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH3size] range:NSMakeRange(0, range.location)];
//    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
//    //To add line Spacing
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    UILabel *textLabel1=[[UILabel alloc]initWithFrame:CGRectMake(liveIcon.frame.size.width+liveIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:580/3 currentSuperviewDeviceSize:screenBounds.size.width],H2HLiveSectionBackground.frame.size.height)];
    textLabel1.backgroundColor=[UIColor clearColor];
    textLabel1.text=@"H2H Live";
    textLabel1.textColor=[UIColor whiteColor];
    textLabel1.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
//    textLabel1.attributedText=attrString;
    textLabel1.numberOfLines=2;
    [H2HLiveSectionBackground addSubview:textLabel1];
    
    UIButton *liveChallengeButton=[[UIButton alloc]initWithFrame:CGRectMake( self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:378/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:318/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    liveChallengeButton.center=CGPointMake(liveChallengeButton.center.x, H2HLiveSectionBackground.frame.size.height/2);
    liveChallengeButton.layer.cornerRadius=liveChallengeButton.frame.size.height/2;
    liveChallengeButton.clipsToBounds=YES;
    liveChallengeButton.tag=100;
    [liveChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:liveChallengeButton.frame] forState:UIControlStateNormal];
    [liveChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:liveChallengeButton.frame] forState:UIControlStateHighlighted];
    [liveChallengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    liveChallengeButton.contentEdgeInsets=UIEdgeInsetsMake(3.5, 0.0, 0.0, 0.0);
    [liveChallengeButton setTitle:@"Enter" forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HLive]) {
        [liveChallengeButton setTitle:@"View" forState:UIControlStateNormal];
    }
    [liveChallengeButton addTarget:self action:@selector(enterChallengeFunction:) forControlEvents:UIControlEventTouchUpInside];
    liveChallengeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [H2HLiveSectionBackground addSubview:liveChallengeButton];
    
    //H2H Posted Button
    UIView *H2HPostedSectionBackground=[[UIView alloc]initWithFrame:CGRectMake(0, H2HLiveSectionBackground.frame.size.height+H2HLiveSectionBackground.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:248/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    H2HPostedSectionBackground.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    [self addSubview:H2HPostedSectionBackground];
    
    UIImageView *postedIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 10, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:172/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:172/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    postedIcon.center=CGPointMake(liveIcon.center.x, H2HPostedSectionBackground.frame.size.height/2);
    [postedIcon setImage:[UIImage imageNamed:@"h2h posted icon.png"]];
    [H2HPostedSectionBackground addSubview:postedIcon];
    
//    NSString *string2 = @"H2H Posted \nCredits Required: Varies";
//    //         NSString *string2 = @"H2H Posted";
//    NSRange range2 = [string2 rangeOfString:@"\n"];
//    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:string2];
//    [attrString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH3size] range:NSMakeRange(0,string2.length)];
//    [attrString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH1size] range:NSMakeRange(0, range2.location)];
//    if (screenBounds.size.height == 480)
//        [attrString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH3size] range:NSMakeRange(0, range2.location)];
//    [attrString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string2.length)];
//    //To add line Spacing
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle2 setLineSpacing:5];
//    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [string2 length])];
    
    UILabel *textLabel2=[[UILabel alloc]initWithFrame:CGRectMake(liveIcon.frame.size.width+liveIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:580/3 currentSuperviewDeviceSize:screenBounds.size.width],H2HLiveSectionBackground.frame.size.height)];
    textLabel2.backgroundColor=[UIColor clearColor];
    textLabel2.text=@"H2H Posted";
    textLabel2.textColor=[UIColor whiteColor];
    textLabel2.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
//    textLabel2.attributedText=attrString2;
    textLabel2.numberOfLines=2;
    [H2HPostedSectionBackground addSubview:textLabel2];
    
    UIButton *postedChallengeButton=[[UIButton alloc]initWithFrame:CGRectMake( self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:378/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:318/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    postedChallengeButton.center=CGPointMake(liveChallengeButton.center.x, H2HPostedSectionBackground.frame.size.height/2);
    postedChallengeButton.layer.cornerRadius=liveChallengeButton.frame.size.height/2;
    postedChallengeButton.clipsToBounds=YES;
    postedChallengeButton.tag=101;
    [postedChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:postedChallengeButton.frame] forState:UIControlStateNormal];
    [postedChallengeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:liveChallengeButton.frame] forState:UIControlStateHighlighted];
    [postedChallengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postedChallengeButton.contentEdgeInsets=UIEdgeInsetsMake(3.5, 0.0, 0.0, 0.0);
    [postedChallengeButton setTitle:@"Enter" forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HPosted]) {
        [postedChallengeButton setTitle:@"View" forState:UIControlStateNormal];
    }
    [postedChallengeButton addTarget:self action:@selector(enterChallengeFunction:) forControlEvents:UIControlEventTouchUpInside];
    postedChallengeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [H2HPostedSectionBackground addSubview:postedChallengeButton];
    
    NSString *string = @"Go Head-to-Head Against \nAny Bowler in the World";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirDemi size:XbH1size] range:NSMakeRange(0,string.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
    //To add line Spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment=NSTextAlignmentCenter;
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];

    UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, H2HPostedSectionBackground.frame.size.height+H2HPostedSectionBackground.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width-40, H2HPostedSectionBackground.frame.size.height)];
    noteLabel.backgroundColor=[UIColor clearColor];
    noteLabel.attributedText=attrString;
    noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
    noteLabel.numberOfLines=2;
    [self addSubview:noteLabel];
    
    UIButton *learnButton=[[UIButton alloc] init];
    learnButton.frame=CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], noteLabel.frame.size.height+noteLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:155/3 currentSuperviewDeviceSize:self.frame.size.height]);
    learnButton.titleEdgeInsets=UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
    learnButton.center=CGPointMake(self.center.x, learnButton.center.y);
    learnButton.titleLabel.font =[UIFont fontWithName:AvenirDemi size:XbH2size];
    [learnButton setTitle:@"LEARN ABOUT CHALLENGES" forState:UIControlStateNormal];
    [learnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    learnButton.exclusiveTouch=YES;
    learnButton.layer.borderColor= [UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0].CGColor;
    learnButton.layer.borderWidth=3.0;
    [learnButton setBackgroundColor:[UIColor clearColor]];
//    [learnButton setBackgroundImage:[[DataManager shared]setColor:[UIColor clearColor] buttonframe:learnButton.frame] forState:UIControlStateNormal];
    [learnButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0] buttonframe:learnButton.frame] forState:UIControlStateHighlighted];
    learnButton.layer.cornerRadius=learnButton.frame.size.height/2;
    learnButton.clipsToBounds=YES;
    learnButton.alpha=0.8;
    [learnButton addTarget:self action:@selector(learnButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:learnButton];


}
#pragma mark - Enter Challenge
- (void)enterChallengeFunction:(UIButton *)sender
{
    [delegate enterChallenge:(int)(sender.tag - 100)];
}

- (void)backButtonFunction
{
    [delegate removeChallengeMainView];
}

- (void)updateChallengeButtonsState
{
    UIButton *postedChallengeButton=(UIButton *)[self viewWithTag:101];
    UIButton *liveChallengeButton=(UIButton *)[self viewWithTag:100];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HPosted]) {
        [postedChallengeButton setTitle:@"View" forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kenteredH2HLive]) {
        [liveChallengeButton setTitle:@"View" forState:UIControlStateNormal];
    }
}

- (void)learnButtonFunction
{
    [delegate showH2HWebView];
}
@end
