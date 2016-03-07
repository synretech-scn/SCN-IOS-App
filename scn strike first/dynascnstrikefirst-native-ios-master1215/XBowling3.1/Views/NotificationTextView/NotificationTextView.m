//
//  NotificationTextView.m
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "NotificationTextView.h"
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
#import "DetailNotificationView.h"
#import "ShowNotificationText.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation NotificationTextView
{
    UIImageView * profileMainbackgroundImage;
    UIView *headerwhiteBackground;
    NSArray *notificationDetail;
    UITableView *centretableView;
    UILabel *headerLabel;

}
@synthesize backShownotificationDelegate=_backShownotificationDelegate;
@synthesize notificationMessage;

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
        headerLabel.text=@"Notification";
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
    }
    return self;
}

#pragma mark - Show Notification message

-(void)loadMessage
{
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(10,headerwhiteBackground.frame.size.height+30,self.frame.size.width-20,self.frame.size.height-headerwhiteBackground.frame.size.height-40)];
    textView.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = YES;
    textView.pagingEnabled = YES;
    textView.text=self.notificationMessage;
    textView.editable = NO;
    textView.textAlignment=NSTextAlignmentCenter;
    textView.textColor=[UIColor whiteColor];
    [self addSubview:textView];
}

#pragma mark - Menu Button Action

-(void)sideMenuButtonAction
{
    [_backShownotificationDelegate backButtonAction];
}


@end
