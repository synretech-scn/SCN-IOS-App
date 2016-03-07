//
//  LiveScoreLanesView.m
//  XBowling3.1
//
//  Created by Click Labs on 1/14/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LiveScoreLanesView.h"
#import "DataManager.h"
#import "Keys.h"
#import "RoundedRectButton.h"

@implementation LiveScoreLanesView
{
    NSMutableArray *openSectionsArray;   //Array of index of open sections
    ExpandableTableView *lanesTableView;
    NSArray *lanesSummaryArray;
    UILabel *noLanesLabel;
    NSDictionary *centerDetails;
    
}
@synthesize liveScoreGameplayDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createViewwithLanesInformation:(NSArray *)lanesArray centerInformation:(NSDictionary *)centerDetailsDict
{
    openSectionsArray=[NSMutableArray new];
    lanesSummaryArray=[[NSArray alloc]initWithArray:lanesArray];
    centerDetails=[[NSDictionary alloc]initWithDictionary:centerDetailsDict];
    UIImageView *backgroundView=[[UIImageView alloc]initWithFrame:self.frame];
    [backgroundView setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundView];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=XBHeaderColor;
    [self addSubview:headerView];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:35 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:194 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:35 currentSuperviewDeviceSize:self.frame.size.height])];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.center=CGPointMake(headerView.center.x, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60 currentSuperviewDeviceSize:self.frame.size.height]);
    if (centerDetailsDict.count > 0) {
        headerLabel.text=[NSString stringWithFormat:@"%@",[centerDetailsDict objectForKey:@"name"]];
    }
    else
        headerLabel.text=@"Live Scores";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];

    UIButton *collapseButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(275+20)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:285/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:self.frame.size.height])];
    [collapseButton setBackgroundColor:[UIColor clearColor]];
    [collapseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collapseButton setTitleColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    [collapseButton setTitle:@"Collapse" forState:UIControlStateNormal];
    [collapseButton addTarget:self action:@selector(collapseButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    collapseButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [headerView addSubview:collapseButton];
    
    UILabel *availableLanesLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:240 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:self.frame.size.height])];
    availableLanesLabel.backgroundColor=[UIColor clearColor];
    if (centerDetailsDict.count > 0) {
        if ([[centerDetailsDict objectForKey:@"totalLanes"] intValue] > 0) {
               availableLanesLabel.text=[NSString stringWithFormat:@"Available Lanes: %lu",(int)[[centerDetailsDict objectForKey:@"totalLanes"] intValue] - lanesSummaryArray.count];
        }
        else
            availableLanesLabel.text=[NSString stringWithFormat:@"Available Lanes: _"];
    }
    else
        availableLanesLabel.text=[NSString stringWithFormat:@"Available Lanes: _"];
    availableLanesLabel.textColor=[UIColor whiteColor];
    availableLanesLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:availableLanesLabel];

    UIButton *callButton=[[UIButton alloc]init];
    [callButton setFrame:CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width]), headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    callButton.layer.cornerRadius=callButton.frame.size.height/2;
    callButton.clipsToBounds=YES;
    callButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    callButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
    [callButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
//    callButton.hidden=YES;
    [callButton addTarget:self action:@selector(callButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:callButton];

   lanesTableView=[[ExpandableTableView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:196/3 currentSuperviewDeviceSize:self.frame.size.height],self.frame.size.width,self.frame.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:196/3 currentSuperviewDeviceSize:self.frame.size.height])) style:UITableViewStyleGrouped];
    lanesTableView.backgroundColor=[UIColor clearColor];
    [lanesTableView setDataSource:self];
    [lanesTableView setDelegate:self];
    lanesTableView.expandableTableDelegate=self;
    lanesTableView.separatorStyle=UITableViewCellSeparatorStyleNone; 
    [self addSubview:lanesTableView];
    if(lanesSummaryArray.count == 0)
    {
        [noLanesLabel removeFromSuperview];
        noLanesLabel=nil;
        noLanesLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:156/3 currentSuperviewDeviceSize:self.frame.size.height],self.frame.size.width - 40,self.frame.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:196/3 currentSuperviewDeviceSize:self.frame.size.height]))];
        if (centerDetailsDict.count > 0) {
            noLanesLabel.text=[NSString stringWithFormat:@"No active lanes at %@ !",[centerDetailsDict objectForKey:@"name"]];
        }
        else
            noLanesLabel.text=[NSString stringWithFormat:@"No active lanes."];
        noLanesLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        noLanesLabel.textAlignment=NSTextAlignmentCenter;
        noLanesLabel.textColor=[UIColor whiteColor];
        noLanesLabel.lineBreakMode=NSLineBreakByWordWrapping;
        noLanesLabel.numberOfLines=4;
        [self addSubview:noLanesLabel];
    }
}

- (void)callButtonFunction:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0]];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        if(centerDetails.count>0)
        {
            NSString *phoneNumber=[NSString stringWithFormat:@"%@",[[centerDetails objectForKey:@"phoneNumber"] objectForKey:@"number"]];
            if(phoneNumber.length>0)
            {
                NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
                NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"phnnumber=%@",escapedPhoneNumber);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:escapedPhoneNumber]]];
            }
        }

    });
   
}

- (void)backButtonFunction
{
    [liveScoreGameplayDelegate liveScoreBackButtonFunction];
}
- (void)updateViewWithLanesInformation:(NSArray *)lanesArray
{
    lanesSummaryArray=nil;
    lanesSummaryArray=[[NSArray alloc] initWithArray:lanesArray];
    [lanesTableView reloadData];
}

#pragma mark - TableView data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [lanesSummaryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:190/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(noLanesLabel)
    {
        [noLanesLabel removeFromSuperview];
        noLanesLabel=nil;
    }
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBase=(UIButton*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBase removeFromSuperview];
        cellBase=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    @try {
        nameLabel.text=[[[NSString stringWithFormat:@"%@",[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"name"]] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    @catch (NSException *exception) {
        nameLabel.text=@"player";
    }
    [cellView addSubview:nameLabel];
    
    @try {
        UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:690/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
        NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"latestFrame"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        NSString *temp;
        if ([[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"latestFrame"] intValue] > 1) {
            temp=@"\nFrames";
        }
        else
            temp=@"\nFrame";
        NSAttributedString *frameLabelText=[[NSAttributedString alloc] initWithString:temp attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
        frameLabel.attributedText=latestPlayedFrameAttributedString;
        frameLabel.backgroundColor=[UIColor clearColor];
        frameLabel.textColor=[UIColor whiteColor];
        frameLabel.textAlignment=NSTextAlignmentCenter;
        frameLabel.numberOfLines=0;
        [cellView addSubview:frameLabel];
        
        UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(frameLabel.frame.size.width + frameLabel.frame.origin.x , 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
        NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"totalScore"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        NSAttributedString *scoreLabelText=[[NSAttributedString alloc] initWithString:@"\nScore" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [scoreAttributedString appendAttributedString:scoreLabelText];
        scoreLabel.backgroundColor=[UIColor clearColor];
        scoreLabel.attributedText=scoreAttributedString;
        scoreLabel.textColor=[UIColor whiteColor];
        scoreLabel.numberOfLines=0;
        scoreLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:scoreLabel];

    }
    @catch (NSException *exception) {
        
    }
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(cellView.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.tag=1000+indexPath.row;
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
    return [[[lanesSummaryArray objectAtIndex:section] objectForKey:@"numberPlayers"] integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     NSLog(@"%f",[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView *myHeader =[[UITableViewHeaderFooterView alloc]init];
    if(myHeader == nil)
    {
        myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    }
    else
    {
        UIView *headerBase=(UIView*)[myHeader viewWithTag:200+section];
        [headerBase removeFromSuperview];
        headerBase=nil;
    }
//    static NSString *HeaderIdentifier = @"header";
//    
//    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
//    if(!myHeader) {
//        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
//    }
     CGRect frame = [tableView rectForSection:section];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    headerView.tag=200+section;
    headerView.backgroundColor=XBHeaderColor;
    UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width],headerView.frame.size.height)];
    headerlabel.backgroundColor=[UIColor clearColor];
    headerlabel.textColor=[UIColor whiteColor];
    headerlabel.text=[NSString stringWithFormat:@"Lane %d",[[[lanesSummaryArray objectAtIndex:section] objectForKey:@"laneNumber"] intValue]];
    headerlabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerlabel];
    UIImageView *plusIndicator=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(115+30)/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    plusIndicator.tag=300;
    if ([openSectionsArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [plusIndicator setImage:[UIImage imageNamed:@"minus.png"]];
    }
    else
    {
         [plusIndicator setImage:[UIImage imageNamed:@"plus.png"]];
    }
    [headerView addSubview:plusIndicator];
    [myHeader addSubview:headerView];
    myHeader.tag=headerView.tag;
    return myHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kliveScoreUpdate];
        [[NSUserDefaults standardUserDefaults]setValue:[[[NSString stringWithFormat:@"%@",[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"name"]] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "] forKey:kliveGameBowlerName];
        [liveScoreGameplayDelegate showGameplayForPlayer:[NSString stringWithFormat:@"%@",[[[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"playerList"]objectAtIndex:indexPath.row] objectForKey:@"rowKey"]] laneID:[NSString stringWithFormat:@"%@",[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"laneNumber"]]                                                                                                                                    venueID:[NSString stringWithFormat:@"%@",[[lanesSummaryArray objectAtIndex:indexPath.section] objectForKey:@"venueId"]]];

    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
  
}

#pragma mark - Expandable TableView Delegate Methods
- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    UIView *headerView=(UIView *)[view viewWithTag:200+sectionIndex];
//    headerView.backgroundColor=[UIColor clearColor];
    UIImageView *plusIndicator=(UIImageView *)[headerView viewWithTag:300];
    [plusIndicator setImage:[UIImage imageNamed:@"plus_onclick.png"]];
    [openSectionsArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
    [self performSelector:@selector(onClickForIndicatorImage:) withObject:plusIndicator afterDelay:0.1];
}

- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    UIView *headerView=(UIView *)[view viewWithTag:200+sectionIndex];
    UIImageView *plusIndicator=(UIImageView *)[headerView viewWithTag:300];
    [plusIndicator setImage:[UIImage imageNamed:@"minus_onclick.png"]];
    [openSectionsArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
    [self performSelector:@selector(onClickForIndicatorImage:) withObject:plusIndicator afterDelay:0.1];
}

- (void)onClickForIndicatorImage:(UIImageView *)indicatorImage
{
    NSUInteger section=indicatorImage.superview.tag - 200;
    if ([openSectionsArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [indicatorImage setImage:[UIImage imageNamed:@"minus.png"]];
    }
    else
    {
        [indicatorImage setImage:[UIImage imageNamed:@"plus.png"]];
    }
    
}
#pragma mark - Collapse Function
- (void)collapseButtonFunction
{
    [openSectionsArray removeAllObjects];
    [lanesTableView collapseAllSections];
}


@end
