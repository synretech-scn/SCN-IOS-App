//
//  AppDelegate.m
//  XBowling3.1
//
//  Created/Users/clicklabs/Desktop/Xbowl_with-Logout&CoachView/Crashlytics.framework by Click Labs on 11/21/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NotificationController.h"
//#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "GAI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSString *notificationId;
    NSString *previousNotificationId;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    /*pay call back*/
   /* NSString *urlString=[url absoluteString];
    
    UIAlertView *payAlertView=[[UIAlertView alloc]initWithTitle:@"XBowling" message:[NSString stringWithFormat:@"Pay Check Call Back Url is: “%@”",urlString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    payAlertView.tag=550;
    [payAlertView show];
    
    */
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kh2hViewFlow];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppLaunch"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ShowFrame"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"viaPushNotification"];
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInChallengeView];
      [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kliveScoreUpdate];
      [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInGameHistoryView];
    //This key is for main page ads
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kAdsServerCall];
    //Crashlytics key
  //  [Crashlytics startWithAPIKey:@"9a344ba4644c7661f8ee12e1e5573f21396bbaf0"];
    
    //Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker. 
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-58998820-1"];

    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
    {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert)
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge
                                                                                | UIRemoteNotificationTypeSound
                                                                                | UIRemoteNotificationTypeAlert)];
        
    }
    if(launchOptions!= nil)
    {
        NSLog(@"launch options %@", launchOptions);
        if([[launchOptions allKeys] containsObject:@"UIApplicationLaunchOptionsRemoteNotificationKey"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"viaPushNotification"];
        }
    }
    return   [[FBSDKApplicationDelegate sharedInstance] application:application
                                      didFinishLaunchingWithOptions:launchOptions];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"tokenAsString: %@",tokenAsString);
    
    
    [[NSUserDefaults standardUserDefaults] setValue:tokenAsString forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error=>%@",error.description);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"userinfo :%@",userInfo);
    NSLog(@"notificationid : %@",[[userInfo objectForKey:@"aps"]objectForKey:@"notificationid"] );
    notificationId=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"]objectForKey:@"notificationid"]];
    
    if ( application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *notificationAlertView=[[UIAlertView alloc]initWithTitle:@"XBowling" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        notificationAlertView.tag=500;
        [notificationAlertView show];
    }
    else{
        NSLog(@"previous notificationid : %@",previousNotificationId);
        if (![previousNotificationId isEqualToString:notificationId]) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            NotificationController *notificationVC=[[NotificationController alloc]init];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            [navigationController pushViewController:notificationVC animated:YES];
            previousNotificationId=notificationId;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)[[[userInfo objectForKey:@"aps"]objectForKey:@"badge"]integerValue]] forKey:currentUnreadAllNotification];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"]objectForKey:@"badge"]integerValue];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag==500)
    {
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryUrl=[NSString stringWithFormat:@"%@",@"NotificationHistory/SetRead"];
        NSString *  urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&PushNotificationId=%@",serverAddress,enquiryUrl,token,apiKey,notificationId];
        [[DataManager shared]setNotifcationRead:urlHit];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  
    NSUInteger orientations;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showBowlingView"]) {
        orientations=UIInterfaceOrientationMaskAll;
    }
    else{
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"])
        {
            orientations= UIInterfaceOrientationMaskLandscape;
        }
        else
        {
            orientations= UIInterfaceOrientationMaskPortrait;
        }
    }
    // Only allow portrait (standard behaviour)
    return orientations;
}

@end
