//
//  LiveScoreVenueSelection.m
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LiveScoreVenueSelection.h"

@implementation LiveScoreVenueSelection
{
    NSString *venueID;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createViewWithCenterView:(SelectCenterView *)selectCenterView
{
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=XBHeaderColor;
    [self addSubview:headerView];
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:194 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Live Scores";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    noteLabel.text=@"    View Live Scores of any XBowling enabled center.";
    noteLabel.textColor=[UIColor whiteColor];
    noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:noteLabel];
    
    selectCenterView.frame=CGRectMake(0, noteLabel.frame.size.height+noteLabel.frame.origin.y, screenBounds.size.width, 100);
    [selectCenterView createView];
    [self addSubview:selectCenterView];
    
    UIButton *liveScoreButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], selectCenterView.frame.size.height+selectCenterView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
    liveScoreButton.layer.cornerRadius=liveScoreButton.frame.size.height/2;
    liveScoreButton.clipsToBounds=YES;
    [liveScoreButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
    [liveScoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveScoreButton setTitle:@"Get Live Scores" forState:UIControlStateNormal];
    [liveScoreButton addTarget:self action:@selector(liveScoreButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    liveScoreButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:liveScoreButton];
    
    UILabel *leaderboardNoteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, liveScoreButton.frame.origin.y+liveScoreButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    leaderboardNoteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    leaderboardNoteLabel.text=@"    See who's on top";
    leaderboardNoteLabel.textColor=[UIColor whiteColor];
    leaderboardNoteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:leaderboardNoteLabel];
    
    int yCoordinate=leaderboardNoteLabel.frame.size.height+leaderboardNoteLabel.frame.origin.y;
    for (int i=0; i<2; i++) {
        UIButton *leaderboardButton=[[UIButton alloc]initWithFrame:CGRectMake(0, yCoordinate,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [leaderboardButton setBackgroundImage:[[DataManager shared]setColor:kCellNormalColor buttonframe:leaderboardButton.frame] forState:UIControlStateNormal];
        [leaderboardButton setBackgroundImage:[[DataManager shared]setColor:kCellHighlightedColor buttonframe:leaderboardButton.frame] forState:UIControlStateHighlighted];
        [leaderboardButton addTarget:self action:@selector(leaderboardButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
         [leaderboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            [leaderboardButton setTitle:@"Global Leaderboard" forState:UIControlStateNormal];
        }
        else
            [leaderboardButton setTitle:@"Center Leaderboard" forState:UIControlStateNormal];
        leaderboardButton.contentEdgeInsets=UIEdgeInsetsMake(0.0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], 0.0, 0.0);

        leaderboardButton.tag=6000+i;
        //make the buttons content appear in the center
        [leaderboardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [leaderboardButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        leaderboardButton.titleLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [leaderboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:leaderboardButton];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(leaderboardButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=903;
        arrow.center=CGPointMake(arrow.center.x, leaderboardButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [leaderboardButton addSubview:arrow];
        
        UIView *separatorImage=[[UIView alloc]init];
        separatorImage.frame=CGRectMake(0,  leaderboardButton.frame.size.height - 0.5, leaderboardButton.frame.size.width, 0.5);
        separatorImage.backgroundColor=separatorColor;
        [leaderboardButton addSubview:separatorImage];
        yCoordinate=leaderboardButton.frame.size.height+leaderboardButton.frame.origin.y;

    }
}

- (void)leaderboardButtonFunction:(UIButton *)sender
{
    UIImageView *arrow=(UIImageView *)[sender viewWithTag:903];
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [self performSelector:@selector(changeArrowOfLeaderboardButton:) withObject:arrow afterDelay:0.2];
    int type=(int)(sender.tag - 6000);
    [delegate showLeaderboard:type];
}

- (void)changeArrowOfLeaderboardButton:(UIImageView *)arrowImageView
{
     [arrowImageView setImage:[UIImage imageNamed:@"arrow.png"]];
}
- (void)updateVenueforLiveCenter:(NSString *)venueId country:(NSString *)country state:(NSString *)state center:(NSString *)center
{

    venueID= venueId;
}

#pragma mark - Fetch Live Score Summary for a particular Center
- (void)liveScoreButtonFunction:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0]];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
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
            [delegate getLiveScoreforSelectedCenter:venueID];
        }
    });
}

- (void)changeButtonBackgroundColor:(UIButton *)sender
{
}

#pragma mark - Side Menu Function
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}

@end
