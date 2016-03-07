//
//  DetailNotificationView.m
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "DetailNotificationView.h"

@implementation DetailNotificationView
{
    UIImageView * profileMainbackgroundImage;
    UIView *headerwhiteBackground;
    NSArray *notificationDetail;
    UITableView *centertableView;
    UILabel *headerLabel;
}
@synthesize backnotificationDelegate=_backnotificationDelegate;
@synthesize centername;
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

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
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-100, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        headerLabel.text=@"Notifications";
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.numberOfLines=2;
        headerLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [headerwhiteBackground addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [backButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerwhiteBackground addSubview:backButton];
        
        
        [centertableView removeFromSuperview];
        centertableView = nil;
        centertableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerwhiteBackground.frame.size.height+headerwhiteBackground.frame.origin.y+10, SCREEN_WIDTH, SCREEN_HEIGHT-headerwhiteBackground.frame.size.height-headerwhiteBackground.frame.origin.y-10 ) style:UITableViewStylePlain];//569
        centertableView.backgroundColor = [UIColor clearColor];
        centertableView.delegate = self;
        centertableView.dataSource = self;
        centertableView.hidden = NO;
        [centertableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [profileMainbackgroundImage addSubview:centertableView];
    }
    return self;
}

#pragma mark - Menu button Action

-(void)sideMenuButtonAction
{
    [_backnotificationDelegate backButtonAction];
}

#pragma mark - Reload Only

-(void)reloadTableOnly {
    [centertableView reloadData];
}

#pragma mark - Update Table View

-(void)notificationTable:(NSDictionary *)notifcaitionresponse
{
    headerLabel.text=self.centername;
    notificationDetail=(NSArray  *)notifcaitionresponse;
    [self reloadTableOnly];
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  notificationDetail.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:230/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    cell=nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    UIView *blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:227/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    
    if([[[notificationDetail objectAtIndex:indexPath.row]objectForKey:@"status"]integerValue]==1)
    {
        blueBackground.backgroundColor=[UIColor blackColor];
        blueBackground.alpha=0.3;
    }
    else
    {
        blueBackground.backgroundColor=[UIColor grayColor];
        blueBackground.alpha=0.7;
    }
    
    blueBackground.tag=1001212+indexPath.row;
    [cell.contentView addSubview:blueBackground];
    
    UILabel*notiMessage=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-70, blueBackground.frame.size.height)];
    notiMessage.textAlignment=NSTextAlignmentLeft;
    notiMessage.backgroundColor=[UIColor clearColor];
    //notiMessage.lineBreakMode=NSLineBreakByWordWrapping;
    notiMessage.numberOfLines=2;
    notiMessage.textColor=[UIColor whiteColor];
    notiMessage.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    notiMessage.text=[[notificationDetail objectAtIndex:indexPath.row]objectForKey:@"notificationMessage"];
    [cell.contentView addSubview:notiMessage];
    
    UIImageView *arrowIcon=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-25), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:((165-63)/2)/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:63/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrowIcon.tag=indexPath.row+1;
    arrowIcon.image=[UIImage imageNamed:@"arrow.png"];
    [cell.contentView addSubview:arrowIcon];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(00,blueBackground.frame.size.height-1, SCREEN_HEIGHT,1)];
    separatorLine.backgroundColor=coachViewPlayerSeparatorLine;
    [cell.contentView addSubview:separatorLine];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self viewWithTag:1001212+indexPath.row ] setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.9]];
    
    [[self viewWithTag:1001212+indexPath.row ]setAlpha:0.7];
    
    UIImageView *arrowchange=(UIImageView *)[self viewWithTag:indexPath.row+1 ];
    arrowchange.image=[UIImage imageNamed:@"arrow_on.png"];
    
    [_backnotificationDelegate notificationSelected:[[notificationDetail objectAtIndex:indexPath.row]objectForKey:@"id"] message:[[notificationDetail objectAtIndex:indexPath.row]objectForKey:@"notificationMessage"] isalreadyReadOrNot:[[[notificationDetail objectAtIndex:indexPath.row]objectForKey:@"status"]intValue] ];
}

@end
