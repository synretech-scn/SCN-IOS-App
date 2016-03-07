//
//  RightSlideMenu.m
//  XBowling3.1
//
//  Created by Click Labs on 1/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "RightSlideMenu.h"
#import "BowlingViewController.h"

@implementation RightSlideMenu
{
    BowlingViewController *bowlingVC;
    NSArray *sectionsArray;
    int selectedRow;
    UITableView *menuTable;

}
@synthesize rightMenuDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createRightMenuView
{
    bowlingVC=[[BowlingViewController alloc]init];
    [self setBackgroundColor:[UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0]];
    
    menuTable=[[UITableView alloc]init];
    menuTable.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:78/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1723/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    menuTable.delegate=self;
    menuTable.dataSource=self;
    menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [menuTable setBackgroundColor:[UIColor clearColor]];
    [self addSubview:menuTable];
    
   if ([[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType] isEqualToString:@"Machine"]) {
        sectionsArray=[[NSArray alloc]initWithObjects:@"Game Menu",@"",@"Game Summary",@"Leaderboard",@"Tags : ",@"Quit Game",nil];
    }
    else{
        sectionsArray=[[NSArray alloc]initWithObjects:@"Game Menu",@"",@"Game Summary",@"Enter Fast Score Entry Mode",@"Leaderboard",@"Tags : ",@"Quit Game",nil];
    }
    
    
}


#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    NSLog(@" display");
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *line=(UIView*)[cell.contentView viewWithTag:901];
        [line removeFromSuperview];
        line=nil;
    }
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cell.contentView addSubview:separatorLine];
    NSLog(@"row height : %f", frame.size.height);
    NSString *string = [sectionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text=string;
    NSLog(@"saving Tags :%@",[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]);
    
    if([string isEqualToString:@"Tags : "])
    {
        NSMutableArray *tagname=[[NSMutableArray alloc]init];
        for(int i=0;i<[[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]count];i++)
        {
            [tagname addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]objectAtIndex:i]];
        }
        
        NSString *tagsString;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:ksavingGameTags]count]==0)
        {
            tagsString=@"Add Tags";
        }
        else
        {
            tagsString=[tagname componentsJoinedByString:@" | "];
        }
        NSMutableAttributedString *stringAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[sectionsArray objectAtIndex:indexPath.row],tagsString]];
        NSRange selectedRange = NSMakeRange(0, [[sectionsArray objectAtIndex:indexPath.row]length]); // 4 characters, starting at index 22
        [stringAttr beginEditing];
        [stringAttr addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]]
                           range:selectedRange];
        [stringAttr addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:XbH2size]
                           range:NSMakeRange([[sectionsArray objectAtIndex:indexPath.row]length], [tagsString length])];
        [stringAttr endEditing];

        cell.textLabel.attributedText=stringAttr;
        //[cell.contentView addSubview:tagNameLabel];
    }

    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.highlightedTextColor=[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:1.0];
    if(indexPath.row == 0)
    {
        cell.userInteractionEnabled=NO;
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        separatorLine.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58/3 currentSuperviewDeviceSize:screenBounds.size.width],frame.size.height-0.5, tableView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58/3 currentSuperviewDeviceSize:screenBounds.size.width], 0.5);
    }
    else if (indexPath.row == 1)
    {
        cell.userInteractionEnabled=NO;
        UILabel *centerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:64/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:993/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:99/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        centerNameLabel.backgroundColor=[UIColor clearColor];
        centerNameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        centerNameLabel.textColor=[UIColor whiteColor];
        centerNameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kcenterName]];
        [cell.contentView addSubview:centerNameLabel];
        
        UILabel *laneLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58/3 currentSuperviewDeviceSize:screenBounds.size.width], centerNameLabel.frame.size.height+centerNameLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:993/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:99/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        laneLabel.backgroundColor=[UIColor clearColor];
        laneLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        laneLabel.textColor=[UIColor whiteColor];
        laneLabel.text=[NSString stringWithFormat:@"Lane: %@",[[NSUserDefaults standardUserDefaults]valueForKey:klaneNumber]];
        [cell.contentView addSubview:laneLabel];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:58/3 currentSuperviewDeviceSize:screenBounds.size.width], laneLabel.frame.size.height+laneLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:993/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:99/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.text=[NSString stringWithFormat:@"Name: %@",[[NSUserDefaults standardUserDefaults]valueForKey:kbowlerName]];
        [cell.contentView addSubview:nameLabel];
        
        
    }
    else if (indexPath.row == sectionsArray.count - 1)
    {
        //Quit Game
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:0.5];
        [cell setSelectedBackgroundView:bgColorView];
        cell.userInteractionEnabled=YES;
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        cell.textLabel.textColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];
        cell.textLabel.highlightedTextColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];
    }
    else
    {
        if(![[sectionsArray objectAtIndex:indexPath.row] isEqualToString:@"Tags : "])
           {
        cell.userInteractionEnabled=YES;
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
           }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"will display cell=%@",cell);
    
    //Highlight the open section
    NSLog(@"views=%@",[self.superview subviews]);
    switch (indexPath.row) {
        case 2:
        {
            if (selectedRow == 2)
            {
                NSLog(@"cell=%@",cell);
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [cell.selectedBackgroundView removeFromSuperview];
                cell.selectedBackgroundView=nil;
                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
                
            }
            break;
        }
        default:
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sectionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(indexPath.row == 1)
    {
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:417/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    else
    {
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    return height;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedBackgroundView removeFromSuperview];
    cell.selectedBackgroundView=nil;
    NSString *sectionTitle=[sectionsArray objectAtIndex:indexPath.row];
    
    if ([sectionTitle isEqualToString:@"Game Menu"]) {
        
    }
    else if ([sectionTitle isEqualToString:@""]){
        
    }
    else if ([sectionTitle isEqualToString:@"Game Summary"]){
        selectedRow=2;
        cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
        [rightMenuDelegate gameMenuSummaryFunction];

    }
    else if ([sectionTitle isEqualToString:@"Enter Fast Score Entry Mode"]){
        if (![[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
            cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
            [rightMenuDelegate fastScoreEntryMode:0];
            cell.textLabel.text=@"Exit Fast Score Entry Mode";
        }
        else{
            //                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:0.5];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
            [rightMenuDelegate fastScoreEntryMode:1];
            cell.textLabel.text=@"Enter Fast Score Entry Mode";
        }

    }
    else if ([sectionTitle isEqualToString:@"Leaderboard"]){
        cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kglobalLeaderboradViaBowlingView];
        [rightMenuDelegate gameMenuLeaderboardFunction];

    }
    else if ([sectionTitle isEqualToString:@"Tags : "]){
        cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
        [rightMenuDelegate showGameTagsUpdate:[[NSUserDefaults standardUserDefaults]objectForKey:kbowlingGameId]];
    }
    else if ([sectionTitle isEqualToString:@"Quit Game"]){
        cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [rightMenuDelegate gameMenuQuitGameFunction];
    }
    else{
        
    }
    
//    switch (indexPath.row) {
//        case 0:
//        {
//        }
//        case 2:
//        {
//            selectedRow=2;
//            cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//            [rightMenuDelegate gameMenuSummaryFunction];
//            break;
//        }
//        case 3:
//        {
//            if (![[NSUserDefaults standardUserDefaults]boolForKey:kInFSEMView]) {
//                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//                [rightMenuDelegate fastScoreEntryMode:0];
//                cell.textLabel.text=@"Exit Fast Score Entry Mode";
//            }
//            else{
////                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:0.5];
//                [tableView beginUpdates];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [tableView endUpdates];
//                 [rightMenuDelegate fastScoreEntryMode:1];
//                cell.textLabel.text=@"Enter Fast Score Entry Mode";
//            }
//            break;
//        }
//        case 4:
//        {
//            cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kglobalLeaderboradViaBowlingView];
//            [rightMenuDelegate gameMenuLeaderboardFunction];
//            break;
//        }
//        case 5:
//        {
//            //Tags
//            cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//             [rightMenuDelegate showGameTagsUpdate:[[NSUserDefaults standardUserDefaults]objectForKey:kbowlingGameId]];
//            
//            break;
//        }
//        case 6:
//        {
//            cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//            [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            [rightMenuDelegate gameMenuQuitGameFunction];
//            break;
//        }
//            
//        default:
//            break;
//    }
}

#pragma mark - Update game tags 

-(void)updateGametags {
    
    [menuTable reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor clearColor];
//    cell.textLabel.textColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];

}

- (void)reloadRightMenu:(int)updatedRow
{
    if(updatedRow == 2)
    {
        selectedRow=0;
    }
    [menuTable reloadData];
}
@end
