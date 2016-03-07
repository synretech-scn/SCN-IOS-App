//
//  MyGamesView.m
//  XBowling3.1
//
//  Created by Click Labs on 3/18/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "MyGamesView.h"

@implementation MyGamesView
{
    NSMutableArray *gamesArray;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)createMyGames:(NSArray *)gamesData
{
    gamesArray=[[NSMutableArray alloc]initWithArray:gamesData];
    if ([gamesData count] == 0) {
        UILabel *noFriendsLabel=[[UILabel alloc]init];
        noFriendsLabel.tag=4500;
        noFriendsLabel.textColor = [UIColor whiteColor];
        noFriendsLabel.backgroundColor=[UIColor clearColor];
        noFriendsLabel.textAlignment=NSTextAlignmentCenter;
        noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
//        noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
        noFriendsLabel.text=@"No games found.";
        [self addSubview:noFriendsLabel];
    }
    else
    {
        UITableView *gamesTable=[[UITableView alloc]init];
        gamesTable.frame=CGRectMake(0, 0, self.frame.size.width, screenBounds.size.height - (self.frame.origin.y));
        NSLog(@"self.frame.size.height=%f gamesTable.frame.origin.y=%f",self.frame.size.height,gamesTable.frame.origin.y);
        gamesTable.backgroundColor=[UIColor clearColor];
        gamesTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        gamesTable.delegate=self;
        gamesTable.dataSource=self;
        [self addSubview:gamesTable];
    }
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

    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:750/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height/2)];
    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.text=[[[NSString stringWithFormat:@"%@",[[[gamesArray objectAtIndex:indexPath.row] objectForKey:@"scoredGame"] objectForKey:@"name"]] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    [cellView addSubview:nameLabel];
    
    NSArray *tagsArray=[[NSArray alloc]initWithArray:[[gamesArray objectAtIndex:indexPath.row] objectForKey:@"gameTags"]];
    int numberOfTags=2;
    if (tagsArray.count < numberOfTags) {
        numberOfTags=(int)tagsArray.count;
    }
    int xcoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width];
    for (int i=0; i<numberOfTags; i++) {
        UILabel *tagLabel =  [[UILabel alloc] init];
        tagLabel.frame=CGRectMake(xcoordinate, nameLabel.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:280/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [tagLabel setBackgroundColor:[UIColor whiteColor]];
        tagLabel.textColor = [UIColor blackColor];
        tagLabel.text=[NSString stringWithFormat:@"%@",[[tagsArray objectAtIndex:i] objectForKey:@"tag"]];
        tagLabel.textAlignment=NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius=tagLabel.frame.size.height/2;
        tagLabel.clipsToBounds=YES;
        tagLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
        [cellView addSubview:tagLabel];
        
        xcoordinate=tagLabel.frame.size.width+tagLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width];
    }
    if (tagsArray.count > 2) {
        UILabel *dotsLabel =  [[UILabel alloc] init];
        dotsLabel.frame=CGRectMake(xcoordinate, nameLabel.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:280/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [dotsLabel setBackgroundColor:[UIColor clearColor]];
        dotsLabel.textColor = [UIColor whiteColor];
        dotsLabel.text=@"...";
        dotsLabel.textAlignment=NSTextAlignmentLeft;
        dotsLabel.font = [UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [cellView addSubview:dotsLabel];
    }
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:280/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    // Display score in standard format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[[gamesArray objectAtIndex:indexPath.row] objectForKey:@"scoredGame"] objectForKey:@"finalScore"] floatValue]]];
    
    NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",formattedString] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    
    
    NSMutableAttributedString *frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Score"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
    [latestPlayedFrameAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"\n%@",@"Score"] length])];
    
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
    return gamesArray.count;
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
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    UIImageView *arrow=(UIImageView *)[cellBackground viewWithTag:902];
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [cellBackground setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2]];
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [delegate showGamePlayforPlayer:[gamesArray objectAtIndex:indexPath.row]];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
}

@end
