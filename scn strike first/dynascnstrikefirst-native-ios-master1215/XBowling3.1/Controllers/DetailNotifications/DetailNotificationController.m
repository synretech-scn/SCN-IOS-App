//
//  DetailNotificationController.m
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "DetailNotificationController.h"
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
#import "DetailNotificationView.h"
#import "ShowNotificationText.h"

@interface DetailNotificationController ()

@end

@implementation DetailNotificationController
{
    DetailNotificationView *detailNotification;
    ServerCalls *callInstance;;
    int apiNUmber;
    NSString *notificationMessage;
    BOOL updateInViewAppear;
}
@synthesize detailResponse;
@synthesize centerNameTitle;
@synthesize venueId;

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    updateInViewAppear=YES;
    
    detailNotification=[[DetailNotificationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    detailNotification.centername=self.centerNameTitle;
    detailNotification.backnotificationDelegate=self;
    [self.view addSubview: detailNotification];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [detailNotification reloadTableOnly];
    [[DataManager shared]removeActivityIndicator];
    
    if(updateInViewAppear)
    {
        updateInViewAppear=YES;
        apiNUmber=1;
        callInstance=[ServerCalls instance];
        callInstance.serverCallDelegate=self;
        
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        
        NSString *enquiryurl=[NSString stringWithFormat:@"NotificationHistory/Notification/%@",self.venueId];
        NSDictionary *notificationInfo =[callInstance afnetWorkingGetServerCall:enquiryurl isAPIkeyToken:YES];
        NSLog(@"notificationInfo :%@",notificationInfo);
    }
}

#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)notificationInfo {
    
    [[DataManager shared]removeActivityIndicator];
    
    if(apiNUmber==0)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            NSString *updatedNotification=[NSString stringWithFormat:@"%d",([[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]intValue]-1)];
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",updatedNotification] forKey:currentUnreadAllNotification];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]integerValue];
            
            ShowNotificationText *textController =[[ShowNotificationText alloc]init];
            textController.messageNotification=notificationMessage;
            [self.navigationController pushViewController:textController animated:YES];
        }
    }
    else if(apiNUmber==1){
        
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [detailNotification notificationTable:[notificationInfo objectForKey:responseDataDic]];
        }
    }
}

#pragma mark - Notification Selected for Detail View

-(void)notificationSelected :(NSString *)notificationId message:(NSString *)MessageText isalreadyReadOrNot:(int)readValue {
    
    NSLog(@"readValue %d",readValue);
    if(readValue==2)
    {
        
        notificationMessage=MessageText;
        apiNUmber=0;
        callInstance=[ServerCalls instance];
        callInstance.serverCallDelegate=self;
        updateInViewAppear=YES;
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryUrl=[NSString stringWithFormat:@"%@",@"NotificationHistory/SetRead"];
        NSString *  urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&PushNotificationId=%@",serverAddress,enquiryUrl,token,apiKey,notificationId];
        NSDictionary *notificationInfo =[callInstance afnetworkingPostServerCall:urlHit postdictionary:nil isAPIkeyToken:NO];
        NSLog(@"notificationInfo :%@",notificationInfo);
        
    }
    else
    {
        updateInViewAppear=NO;
        
        [[DataManager shared]removeActivityIndicator];
        ShowNotificationText *textController =[[ShowNotificationText alloc]init];
        textController.messageNotification=MessageText;
        [self.navigationController pushViewController:textController animated:YES];
    }
}

#pragma mark - Back Button Action

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
