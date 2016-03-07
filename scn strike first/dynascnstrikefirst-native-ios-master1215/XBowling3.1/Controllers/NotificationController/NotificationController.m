//
//  NotificationController.m
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "NotificationController.h"
#import "NotoficationView.h"
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
#import "DetailNotificationController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface NotificationController ()

@end

@implementation NotificationController
{
    LeftSlideMenu *leftMenu;
    NotoficationView *Viewnotification;
    ServerCalls *callInstance;
    NSString *centreNameOfSeletedRow;
    BOOL updateReadCentre;
    int apiNumber;
    NSString *venueId;
    id<GAITracker> tracker;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
    tracker = [[GAI sharedInstance] defaultTracker];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    updateReadCentre=true;
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification Section"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    NSLog(@"stack of navigation controller: %@",self.navigationController.viewControllers);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    leftMenu.hidden=YES;
    
    Viewnotification=[[NotoficationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    Viewnotification.notificationDelegate=self;
    [self.view addSubview: Viewnotification];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(updateReadCentre)
    {
        apiNumber=0;
        callInstance=[ServerCalls instance];
        callInstance.serverCallDelegate=self;
        
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        NSDictionary *notificationInfo =[callInstance afnetWorkingGetServerCall:@"NotificationHistory/venues" isAPIkeyToken:YES];
        NSLog(@"notificationInfo :%@",notificationInfo);
    }
}

#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)notificationInfo
{
    NSLog(@"notificationInfo :%@",notificationInfo);
    
   [Viewnotification reloadCentreTable];

    if(apiNumber==0)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [Viewnotification LoadNotificationView:[[notificationInfo objectForKey:responseDataDic] objectForKey:@"table"]];
            apiNumber=2;

            callInstance=[ServerCalls instance];
            callInstance.serverCallDelegate=self;
            NSDictionary *notificationInfo =[callInstance afnetWorkingGetServerCall:@"NotificationHistory/UnreadNotificationsCount" isAPIkeyToken:YES];
            NSLog(@"notificationInfo :%@",notificationInfo);
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
    else if(apiNumber==1)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            if([[notificationInfo objectForKey:responseDataDic]count]>0)
            {
                DetailNotificationController *detail=[[DetailNotificationController alloc]init];
                detail.centerNameTitle=centreNameOfSeletedRow;
                detail.venueId=venueId;
                detail.detailResponse=[notificationInfo objectForKey:responseDataDic];
                [self.navigationController pushViewController:detail animated:YES];
            }
            else
            {
                UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Ooops!" message:@"No notifications available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView5 show];
            }
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
    else if (apiNumber==2)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[notificationInfo objectForKey:responseStringAF]] forKey:currentUnreadAllNotification];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]integerValue];

            
            [leftMenu reloadMenuTable];
            [Viewnotification reloadCentreTable];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
            
        }
    }
}

#pragma mark - Centre Selected for All its Notifications

-(void)centreSelected:(NSString *)venueIdofSeleted centreNameSelected:(NSString *)centreName
{
    apiNumber=1;
    venueId=venueIdofSeleted;
    centreNameOfSeletedRow=centreName;
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSString *enquiryurl=[NSString stringWithFormat:@"NotificationHistory/Notification/%@",venueId];
    
    NSDictionary *notificationInfo =[callInstance afnetWorkingGetServerCall:enquiryurl isAPIkeyToken:YES];
    NSLog(@"notificationInfo :%@",notificationInfo);
}

#pragma mark - Menu Button 

-(void)menuButtonAction
{
    [self showMainMenu:nil];
}

#pragma mark - Main Menu

- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            Viewnotification.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, Viewnotification.frame.size.width, Viewnotification.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], Viewnotification.frame.size.width, Viewnotification.frame.size.height)];
            mainScreenCoverView.tag=20011;
            mainScreenCoverView.userInteractionEnabled=YES;
            [self.view addSubview:mainScreenCoverView];
        }];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftMenu.frame = CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:nil];
        
    }
    else{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            Viewnotification.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished){
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftMenu.frame = CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:^(BOOL finished){
            leftMenu.hidden=YES;
            UIView *screenCover=(UIView *)[self.view viewWithTag:20011];
            [screenCover removeFromSuperview];
            screenCover=nil;
        }];
    }
}

- (void)dismissMenu
{
    [self showMainMenu:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    BOOL isOrientationLandscape = [[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"];
    if(isOrientationLandscape)
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        //    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
