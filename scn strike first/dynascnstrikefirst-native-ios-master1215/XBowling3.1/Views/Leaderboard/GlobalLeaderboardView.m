//
//  GlobalLeaderboardView.m
//  XBowling3.1
//
//  Created by Click Labs on 1/21/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "GlobalLeaderboardView.h"
#import "Keys.h"
#import "DataManager.h"

@implementation GlobalLeaderboardView
{
    NSArray *playersArray;
    NSString *leaderboardCategory;
    NSString *scoreTitle;
    int leaderboardType;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createLeaderboardView:(NSDictionary *)leaderboardDictionary leaderboardCategory:(NSString *)category leaderboardType:(int)type centerName:(NSString *)center
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    leaderboardCategory=category;
    [self getScoreTitleforLeaderbaord:leaderboardCategory];
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
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:255 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    NSLog(@"center name=%@",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]);
    if (type == 1) {
        headerLabel.text=@"Global Leaders";
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kglobalLeaderboradViaBowlingView]) {
            headerLabel.text=[NSString stringWithFormat:@"%@ Leaders",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
        }
    }
    else
    {
        headerLabel.text=[NSString stringWithFormat:@"%@ Leaders",center];
    }
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *filterButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:255/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:255/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    filterButton.backgroundColor=[UIColor clearColor];
    filterButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [filterButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [filterButton addTarget:self action:@selector(filterButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:filterButton];
    
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    if (leaderboardDictionary && [leaderboardDictionary isKindOfClass:[NSDictionary class]]) {
        playersArray=[[NSArray alloc]initWithArray:[leaderboardDictionary objectForKey:@"leaderboardResults"]];
        
        UIView *noteBaseView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        noteBaseView.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
        [self addSubview:noteBaseView];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],1, self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        noteLabel.backgroundColor=[UIColor clearColor];
        noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        noteLabel.textColor=[UIColor whiteColor];
        noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
        noteLabel.numberOfLines=2;
        NSString *noteString;
        if([leaderboardDictionary objectForKey:@"currentUserResult"])
        {
            if([leaderboardDictionary objectForKey:@"currentUserResult"] == [NSNull null])
                noteString=[NSString stringWithFormat:@"You have not been ranked on the %@ Leaderboard.",category];
            else
                noteString=[NSString stringWithFormat:@"You have been ranked %@ on %@ Leaderboard.",[[leaderboardDictionary objectForKey:@"currentUserResult"] objectForKey:@"rank"],category];
        }
        else
            noteString=[NSString stringWithFormat:@"You have not been ranked on the %@ Leaderboard.",category];
        
        NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:noteString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]]}];
        [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
        noteLabel.attributedText=nameString;
        [noteBaseView addSubview:noteLabel];
        
        if((UILabel *)[self viewWithTag:4500])
        {
            UILabel *friendsLabel=(UILabel *)[self viewWithTag:4500];
            [friendsLabel removeFromSuperview];
            friendsLabel=nil;
        }
        if ([[leaderboardDictionary objectForKey:@"leaderboardResults"] count] == 0) {
            UILabel *noFriendsLabel=[[UILabel alloc]init];
            noFriendsLabel.tag=4500;
            noFriendsLabel.textColor = [UIColor whiteColor];
            noFriendsLabel.textAlignment=NSTextAlignmentCenter;
            noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],noteBaseView.frame.size.height+noteBaseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
            noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
            noFriendsLabel.lineBreakMode= NSLineBreakByWordWrapping;
            noFriendsLabel.numberOfLines=2;
            noFriendsLabel.text=@"No record found. \nLeaderboard is wide open.";
            [self addSubview:noFriendsLabel];

        }
        else
        {
            UITableView *playersTable=[[UITableView alloc]init];
            playersTable.frame=CGRectMake(0, noteBaseView.frame.size.height+noteBaseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (noteBaseView.frame.size.height+noteBaseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height]));
            NSLog(@"self.frame.size.height=%f playersTable.frame.origin.y=%f",self.frame.size.height,playersTable.frame.origin.y);
            playersTable.tag=100;
            playersTable.backgroundColor=[UIColor clearColor];
            playersTable.separatorStyle=UITableViewCellSeparatorStyleNone;
            playersTable.delegate=self;
            playersTable.dataSource=self;
            [self addSubview:playersTable];
        }
    }
}

- (void)getScoreTitleforLeaderbaord:(NSString *)leaderboard
{
    if ([leaderboard isEqualToString:@"All Time Score"]) {
        scoreTitle=@"Score";
    }
    else if ([leaderboard isEqualToString:@"Spare King"]) {
        scoreTitle=@"Spares";
    }
    else if ([leaderboard isEqualToString:@"Strike King"]) {
        scoreTitle=@"Strikes";
    }
    else if ([leaderboard isEqualToString:@"Points Won"]) {
        scoreTitle=@"Points";
    }
    else if ([leaderboard isEqualToString:@"Challenges Won"] || [leaderboard isEqualToString:@"Challenges Played"]) {
        scoreTitle=@"Challenges";
    }
    else if ([leaderboard isEqualToString:@"XB 300 Club"]) {
        scoreTitle=@"Games";
    }
}

- (void)filterButtonFunction:(UIButton *)sender
{
    [delegate showFilterView];
}

- (void)backButtonFunction
{
     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kglobalLeaderboradViaBowlingView];
    [delegate removeGlobalLeaderboard];
}

#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBckgd=(UIView*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBckgd removeFromSuperview];
        cellBckgd=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.text=[[[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:indexPath.row] objectForKey:@"name"]] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    [cellView addSubview:nameLabel];
    
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:837/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:320/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    
    // Display score in standard format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
     NSString *formattedString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[playersArray objectAtIndex:indexPath.row] objectForKey:@"score"] floatValue]]];
    
    NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",formattedString] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];

    
    NSMutableAttributedString *frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",scoreTitle] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
    [latestPlayedFrameAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"\n%@",scoreTitle] length])];

    frameLabel.attributedText=latestPlayedFrameAttributedString;
    frameLabel.backgroundColor=[UIColor clearColor];
    frameLabel.textColor=[UIColor whiteColor];
    frameLabel.textAlignment=NSTextAlignmentCenter;
    frameLabel.numberOfLines=0;
    [cellView addSubview:frameLabel];
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(cellView.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.tag=902;
    arrow.center=CGPointMake(arrow.center.x, cellView.frame.size.height/2);
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [cellView addSubview:arrow];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *cellBackground=(UIView *)[cell viewWithTag:100+indexPath.row];
    [cellBackground setBackgroundColor:kCellHighlightedColor];
    UIImageView *arrow=(UIImageView *)[cellBackground viewWithTag:902];
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [self performSelector:@selector(deSelectRowAtIndexPath:) withObject:indexPath afterDelay:0.3];
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [delegate showPalyerProfile:[[playersArray objectAtIndex:indexPath.row] objectForKey:@"userId"]];
    [cellBackground setBackgroundColor:kCellNormalColor];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    
}

- (void)deSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *playerTable=(UITableView *)[self viewWithTag:100];
    UITableViewCell *cell = [playerTable cellForRowAtIndexPath:indexPath];
    UIView *cellBackground=(UIView *)[cell viewWithTag:100+indexPath.row];
    [cellBackground setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2]];
    UIImageView *arrow=(UIImageView *)[cellBackground viewWithTag:902];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
