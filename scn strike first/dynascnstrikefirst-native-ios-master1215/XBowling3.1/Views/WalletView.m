//
//  WalletView.m
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "WalletView.h"

@implementation WalletView
{
    NSMutableArray *centersArray;
    UITableView *centersTable;
    UIView *headerView;
    NSMutableDictionary *rewardPointsDict;
}

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){


    }
    return self;
}

- (void)createWalletView:(NSArray *)walletCentersArray forXBowlingPoints:(NSDictionary *)pointsDictionary
{
    //add
    
    
    
     [delegate addSelectedCenter];
    
    centersArray = [NSMutableArray new];
    rewardPointsDict = [[NSMutableDictionary alloc]initWithDictionary:pointsDictionary];
    if ([pointsDictionary isKindOfClass:[NSDictionary class]] && pointsDictionary !=nil) {
        NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[pointsDictionary objectForKey:@"availableRewardPoints"],@"points",@"0",@"venueId",@"XBowling",@"venueName", nil];
        [centersArray addObject:temp];
    }
    if (walletCentersArray.count > 0) {
        for (int i=0; i<walletCentersArray.count; i++) {
            [centersArray addObject:[walletCentersArray objectAtIndex:i]];
        }
    }
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
   headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImage addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Wallet";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:35 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    sideNavigationButton.tag=802;
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];
    
    UIButton *addCenterButton=[[UIButton alloc]init];
    [addCenterButton setFrame:CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width]),[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:self.frame.size.height])];
    addCenterButton.layer.cornerRadius=addCenterButton.frame.size.height/2;
    addCenterButton.clipsToBounds=YES;
//    [addCenterButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0] buttonframe:addCenterButton.frame] forState:UIControlStateNormal];
//    [addCenterButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:addCenterButton.frame] forState:UIControlStateHighlighted];
    [addCenterButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:addCenterButton.frame] forState:UIControlStateNormal];
    [addCenterButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:addCenterButton.frame] forState:UIControlStateHighlighted];
    addCenterButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    [addCenterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCenterButton setTitle:@"Add Center" forState:UIControlStateNormal];
    addCenterButton.contentEdgeInsets=UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
    //        [addCenterButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
    //    addCenterButton.hidden=YES;
    [addCenterButton addTarget:self action:@selector(addCenterFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addCenterButton];
    
    ///add
    
    addCenterButton.hidden=true;
    
    UILabel *noteLabel=(UILabel *)[self viewWithTag:4500];
    [noteLabel removeFromSuperview];
    if (centersArray.count > 0) {
        centersTable=[[UITableView alloc]init];
        centersTable.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height]));
        NSLog(@"self.frame.size.height=%f centersTable.frame.origin.y=%f",self.frame.size.height,centersTable.frame.origin.y);
        centersTable.backgroundColor=[UIColor clearColor];
        centersTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        centersTable.delegate=self;
        centersTable.dataSource=self;
        [self addSubview:centersTable];
        
        //add
        
           centersTable.hidden=true;
       
        
    }
    else{
        UILabel *centersLabel=[[UILabel alloc]init];
        centersLabel.tag=4500;
        centersLabel.textColor = [UIColor whiteColor];
        centersLabel.textAlignment=NSTextAlignmentCenter;
        centersLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH1size];
        centersLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],headerView.frame.size.height+headerView
                                      .frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
        centersLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
        centersLabel.lineBreakMode= NSLineBreakByWordWrapping;
        centersLabel.numberOfLines=2;
        centersLabel.text=@"No centers are currently added to your wallet.";
        [self addSubview:centersLabel];
        
        //add
        
        
        [delegate addSelectedCenter];

        
        
        
     centersTable.hidden=true;
        
        
        
        rewardPointsDict = [[NSMutableDictionary alloc]initWithDictionary:pointsDictionary];
        if ([pointsDictionary isKindOfClass:[NSDictionary class]] && pointsDictionary !=nil) {
            NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[pointsDictionary objectForKey:@"availableRewardPoints"],@"points",@"0",@"venueId",@"XBowling",@"venueName", nil];
            [centersArray addObject:temp];
        }
        if (walletCentersArray.count > 0) {
            for (int i=0; i<walletCentersArray.count; i++) {
                [centersArray addObject:[walletCentersArray objectAtIndex:i]];
                
                
                
                //add
                
                if ([  [[centersArray objectAtIndex:i] objectForKey:@"venueName"] isEqualToString:@"SCN Strike First"]) {
                    //rowchoose=indexPath.row;
                
                [delegate showPointsViewForCenter:[centersArray objectAtIndex:i]];
                }
                
                
                
            }
        }
        
        
    }
    
    //add
//[delegate showPointsViewForCenter:[centersArray objectAtIndex:1]];
    //[delegate showRewardPointsView];


}
#pragma mark - Reload list
- (void)reloadListWithCenters:(NSMutableArray *)updatedCentersArray andRewardPoints:(NSDictionary *)pointsDictionary
{
    UILabel *noteLabel=(UILabel *)[self viewWithTag:4500];
    [noteLabel removeFromSuperview];

    @try {
        [centersArray removeAllObjects];
        rewardPointsDict= nil;
        rewardPointsDict = [[NSMutableDictionary alloc]initWithDictionary:pointsDictionary];
        NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[rewardPointsDict objectForKey:@"availableRewardPoints"],@"points",@"0",@"venueId",@"XBowling",@"venueName", nil];
        [centersArray addObject:temp];
        
        if (updatedCentersArray.count > 0) {
            for (int i=0; i<updatedCentersArray.count; i++) {
                [centersArray addObject:[updatedCentersArray objectAtIndex:i]];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }

   //    centersArray=updatedCentersArray;
    if (centersTable == nil) {
        centersTable=[[UITableView alloc]init];
        centersTable.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height]));
        NSLog(@"self.frame.size.height=%f centersTable.frame.origin.y=%f",self.frame.size.height,centersTable.frame.origin.y);
        centersTable.backgroundColor=[UIColor clearColor];
        centersTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        centersTable.delegate=self;
        centersTable.dataSource=self;
        [self addSubview:centersTable];
    }
    [centersTable reloadData];
}

- (void)reloadList
{
    [centersTable reloadData];
}

#pragma mark - Add Center
- (void)addCenterFunction:(UIButton *)sender
{
    [delegate showAddCenterView];
}

#pragma mark - Side Menu
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}
#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //int rowchoose=0;
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
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *centerNameLabel=[[UILabel alloc]init];
    centerNameLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
    centerNameLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    centerNameLabel.textColor=[UIColor whiteColor];
    centerNameLabel.text=[NSString stringWithFormat:@"%@",[[centersArray objectAtIndex:indexPath.row] objectForKey:@"venueName"]];
    //add
    if ([  [[centersArray objectAtIndex:indexPath.row] objectForKey:@"venueName"] isEqualToString:@"SCN Strike First"]) {
        //rowchoose=indexPath.row;
        centerNameLabel.text=[NSString stringWithFormat:@"1%@",[[centersArray objectAtIndex:indexPath.row] objectForKey:@"venueName"]];
        
        [delegate showPointsViewForCenter:[centersArray objectAtIndex:indexPath.row]];
        
    }
    centerNameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    centerNameLabel.numberOfLines=2;
    centerNameLabel.backgroundColor=[UIColor clearColor];
    [cellView addSubview:centerNameLabel];
    
    UILabel *pointsLabel=[[UILabel alloc]init];
    pointsLabel.frame=CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
    pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    pointsLabel.textColor=[UIColor whiteColor];
    pointsLabel.textAlignment=NSTextAlignmentRight;
    pointsLabel.text=[NSString stringWithFormat:@"%@",[[centersArray objectAtIndex:indexPath.row] objectForKey:@"points"]];
    pointsLabel.backgroundColor=[UIColor clearColor];
    [cellView addSubview:pointsLabel];
    //add
   // [delegate showPointsViewForCenter:[centersArray objectAtIndex:rowchoose]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return centersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *cellView=(UIView*)[cell viewWithTag:(indexPath.row+100)];
    if (centersArray.count > 0) {
        [cellView setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
        if (indexPath.row > 0) {
            [delegate showPointsViewForCenter:[centersArray objectAtIndex:indexPath.row]];
        }
        else{
            [delegate showRewardPointsView];
        }
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
