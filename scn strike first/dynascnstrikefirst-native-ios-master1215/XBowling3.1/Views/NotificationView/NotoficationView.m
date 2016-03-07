//
//  NotoficationView.m
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "NotoficationView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation NotoficationView
{
    UIImageView * profileMainbackgroundImage;
    UIView *headerwhiteBackground;
    NSMutableArray *notificationCentreResponse;
    UITableView *centretableView;
    UILabel *unreadLabel;
    UIButton *sideNavigationButton;
}
@synthesize notificationDelegate=_notificationDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"email %@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId]);
        
        profileMainbackgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        profileMainbackgroundImage.userInteractionEnabled=YES;
        [profileMainbackgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
        [self addSubview:profileMainbackgroundImage];
        
        UIView *headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerBlueBackground.backgroundColor=XBHeaderColor;
        [profileMainbackgroundImage addSubview:headerBlueBackground];
        
        headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerwhiteBackground.backgroundColor=[UIColor clearColor];
        [self addSubview:headerwhiteBackground];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.width], headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        headerLabel.text=@"Notifications";
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.numberOfLines=2;
        headerLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [headerwhiteBackground addSubview:headerLabel];
        
        sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake(5, headerLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
        [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
        [sideNavigationButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchDown];
        [headerwhiteBackground addSubview:sideNavigationButton];
        
        
        sideNavigationButton.userInteractionEnabled=true;
        [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

        
        UIView *centreHeaderBackground=[[UIView alloc]initWithFrame:CGRectMake(0, headerwhiteBackground.frame.origin.y+headerwhiteBackground.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], SCREEN_WIDTH,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:105/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        centreHeaderBackground.backgroundColor=[UIColor blackColor];
        centreHeaderBackground.alpha=0.8;
        [profileMainbackgroundImage addSubview: centreHeaderBackground];
        
        
        UILabel*homeCentreHeader=[[UILabel alloc]initWithFrame:CGRectMake(20, headerwhiteBackground.frame.origin.y+headerwhiteBackground.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.height], 200, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        homeCentreHeader.textAlignment=NSTextAlignmentLeft;
        homeCentreHeader.backgroundColor=[UIColor clearColor];
        homeCentreHeader.lineBreakMode=NSLineBreakByWordWrapping;
        homeCentreHeader.numberOfLines=0;
        homeCentreHeader.textColor=[UIColor whiteColor];
        homeCentreHeader.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
        homeCentreHeader.text=@"Select Bowling Center";
        [profileMainbackgroundImage addSubview:homeCentreHeader];
        
        
        [centretableView removeFromSuperview];
        centretableView = nil;
        centretableView = [[UITableView alloc] initWithFrame:CGRectMake(0, homeCentreHeader.frame.size.height+homeCentreHeader.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT-homeCentreHeader.frame.size.height-homeCentreHeader.frame.origin.y ) style:UITableViewStylePlain];//569
        centretableView.backgroundColor = [UIColor clearColor];
        centretableView.delegate = self;
        centretableView.dataSource = self;
        centretableView.hidden = NO;
        [centretableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [profileMainbackgroundImage addSubview:centretableView];
    }
    return self;
}

#pragma mark - Side Menu Button Action

-(void)sideMenuButtonAction
{
    [_notificationDelegate menuButtonAction];
}

-(void)reloadCentreTable {
    
    [centretableView reloadData];
    
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

//    NSLog(@"current :%ld",(long)[[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]integerValue]);
//    if([[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]integerValue]<=0)
//    {
//        unreadLabel.hidden=true;
//    }
//    else{
//        unreadLabel.hidden=false;
//        unreadLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]];
//    }
}

#pragma mark - Load All Centre For Notification

-(void)LoadNotificationView:(NSDictionary *)notifcaitionresponse
{
    if([[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]integerValue]<=0)
    {
        unreadLabel.hidden=true;
    }
    else{
          unreadLabel.hidden=false;
    }
   // unreadLabel.text
    NSArray *tempResponse=(NSArray *)notifcaitionresponse;
    notificationCentreResponse=[NSMutableArray new];
    
    for(int i=0;i<notifcaitionresponse.count;i++)
    {
        if([[tempResponse objectAtIndex:i]objectForKey:@"venueId"]==nil||[[tempResponse objectAtIndex:i]objectForKey:@"venueId"]==[NSNull null]||[[NSString stringWithFormat:@"%@",[[tempResponse objectAtIndex:i]objectForKey:@"venueId"]] isEqualToString:@"<null>"])
        {
            
        }
            else
            {
               [notificationCentreResponse addObject:[tempResponse objectAtIndex:i]];
            }
    }
    [centretableView reloadData];
}

#pragma mark - Tabel View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return  notificationCentreResponse.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:165/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    cell=nil;
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    UIView *blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:165/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    blueBackground.backgroundColor=[UIColor blackColor];
    blueBackground.alpha=0.3;
    blueBackground.tag=1001212+indexPath.row;
    [cell.contentView addSubview:blueBackground];
    
    UILabel*centreName=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-20-50, blueBackground.frame.size.height)];
    centreName.textAlignment=NSTextAlignmentLeft;
    centreName.backgroundColor=[UIColor clearColor];
    centreName.lineBreakMode=NSLineBreakByWordWrapping;
    centreName.numberOfLines=0;
    centreName.textColor=[UIColor whiteColor];
    centreName.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    centreName.text=[[notificationCentreResponse objectAtIndex:indexPath.row]objectForKey:@"venueName"];
    [cell.contentView addSubview:centreName];
    
    UIImageView *arrowIcon=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-25), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:((165-63)/2)/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:63/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrowIcon.tag=indexPath.row+1;
    arrowIcon.image=[UIImage imageNamed:@"arrow.png"];
    [cell.contentView addSubview:arrowIcon];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(00,blueBackground.frame.size.height-1.5, SCREEN_HEIGHT,1)];
    separatorLine.backgroundColor=coachViewPlayerSeparatorLine;
    [cell.contentView addSubview:separatorLine];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for(int i=0;i<3;i++)
    {
        [[self viewWithTag:1001212+i ] setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0]];
        [[self viewWithTag:1001212+i ] setAlpha:0.3];
        UIImageView *arrowchange=(UIImageView *)[self viewWithTag:i+1 ];
        arrowchange.image=[UIImage imageNamed:@"arrow.png"];
    }
    
        [[self viewWithTag:1001212+indexPath.row ] setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
    UIImageView *arrowchange=(UIImageView *)[self viewWithTag:indexPath.row+1 ];
    arrowchange.image=[UIImage imageNamed:@"arrow_on.png"];
    
    
    [_notificationDelegate centreSelected:[[notificationCentreResponse objectAtIndex:indexPath.row]objectForKey:@"venueId"] centreNameSelected:[[notificationCentreResponse objectAtIndex:indexPath.row]objectForKey:@"venueName"]];
}


@end
