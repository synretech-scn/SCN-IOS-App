//
//  ComparisonView.m
//  XBowling3.1
//
//  Created by Shreya on 16/03/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ComparisonView.h"

@implementation ComparisonView
{
    NSMutableArray *comparisonData;
    NSArray *labelsArray;
    NSArray *keysArray;
    NSString *oppoenent;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)createComparisonViewWithData:(NSArray *)array andOpponentName:(NSString *)name
{
    comparisonData=[[NSMutableArray alloc]initWithArray:array];
    oppoenent=name;
    labelsArray=[[NSArray alloc]initWithObjects:@"Average Score",@"High Score",@"Strike Percentage",@"Single-Pin Spare Percentage",@"Multi-Pin Spare Percentage",@"Open Percentage",@"Split Percentage", nil];
    keysArray=[[NSArray alloc]initWithObjects:@"averageScores",@"highScore",@"strikepercent",@"singlePinpercent",@"multiPinpercent",@"openpercent",@"splitpercent",nil];
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
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.text=@"Comparison";
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width/2,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    userLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    userLabel.textColor=[UIColor whiteColor];
    userLabel.textAlignment=NSTextAlignmentCenter;
    userLabel.text=@"You";
    [self addSubview:userLabel];
    
    UILabel *opponentLabel=[[UILabel alloc]initWithFrame:CGRectMake(userLabel.frame.size.width+userLabel.frame.origin.x, userLabel.frame.origin.y, self.frame.size.width/2,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    opponentLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    opponentLabel.textColor=[UIColor whiteColor];
    opponentLabel.textAlignment=NSTextAlignmentCenter;
    opponentLabel.text=[[[NSString stringWithFormat:@"%@",oppoenent] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    [self addSubview:opponentLabel];
    
    UITableView *comparisonTable=[[UITableView alloc]init];
    comparisonTable.frame=CGRectMake(0, userLabel.frame.size.height+userLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:71 currentSuperviewDeviceSize:screenBounds.size.height]));
    NSLog(@"self.frame.size.height=%f comparisonTable.frame.origin.y=%f",self.frame.size.height,comparisonTable.frame.origin.y);
    comparisonTable.backgroundColor=[UIColor clearColor];
    comparisonTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    comparisonTable.delegate=self;
    comparisonTable.dataSource=self;
    [self addSubview:comparisonTable];
    
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
    cell.backgroundColor=[UIColor clearColor];
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    [cell.contentView addSubview:cellView];
    
    UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cellView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    noteLabel.textAlignment=NSTextAlignmentCenter;
    noteLabel.text=[NSString stringWithFormat:@"%@",[labelsArray objectAtIndex:indexPath.row]];
    noteLabel.textColor=[UIColor whiteColor];
    noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
    [cellView addSubview:noteLabel];
    
    UILabel *userScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, noteLabel.frame.size.height, cellView.frame.size.width/2, cellView.frame.size.height - noteLabel.frame.size.height)];
    userScoreLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    userScoreLabel.textColor=[UIColor whiteColor];
    userScoreLabel.textAlignment=NSTextAlignmentCenter;

    float value=[[[[comparisonData objectAtIndex:0]objectAtIndex:0]objectForKey:[keysArray objectAtIndex:indexPath.row]] floatValue];
    if (indexPath.row == 0 || indexPath.row == 1) {
        userScoreLabel.text=[NSString stringWithFormat:@"%.1f",value];
    }
    else{
        userScoreLabel.text=[NSString stringWithFormat:@"%.1f%%",value];
    }
    [cellView addSubview:userScoreLabel];
    
    if ([[comparisonData objectAtIndex:1] count]> 0) {
        UILabel *opponentScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(userScoreLabel.frame.size.width+userScoreLabel.frame.origin.x, userScoreLabel.frame.origin.y, cellView.frame.size.width/2, userScoreLabel.frame.size.height)];
        opponentScoreLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        opponentScoreLabel.textColor=[UIColor whiteColor];
        opponentScoreLabel.textAlignment=NSTextAlignmentCenter;
        float value2= [[[[comparisonData objectAtIndex:1]objectAtIndex:0]objectForKey:[keysArray objectAtIndex:indexPath.row]] floatValue];
       if (indexPath.row == 0 || indexPath.row == 1) {
           opponentScoreLabel.text=[NSString stringWithFormat:@"%.1f",value2];
       }
       else{
           opponentScoreLabel.text=[NSString stringWithFormat:@"%.1f%%",value2];
       }
        [cellView addSubview:opponentScoreLabel];
    }
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return labelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:300/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

#pragma mark - UITableview Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)backButtonFunction
{
    [delegate removeComparisonView];
}


@end
