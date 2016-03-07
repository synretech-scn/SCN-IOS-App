//
//  CoachViewController.m
//  XBowling3.1
//
//  Created by clicklabs on 1/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CoachViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface CoachViewController ()
@end

@implementation CoachViewController
{
    CoachView *coachViewObject;
    BOOL isCampusLandscape;
    int venue;
    int laneNumber;
    ServerCalls *callInstance;
    int apiNUmber;
    id<GAITracker> tracker;
}

#pragma mark - View Did Load

- (void)viewDidLoad {
    
    //[self rotateController:self degrees:-90];
//    [self supportedInterfaceOrientations:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     tracker = [[GAI sharedInstance] defaultTracker];
    apiNUmber=1;
    callInstance=[ServerCalls instance];
    callInstance.serverCallDelegate=self;
    
    self.view.backgroundColor=[UIColor clearColor];
    
    [self performSelector:@selector(coachUI) withObject:self afterDelay:1.0];
    
  //  [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:orientaion];
}

- (void)coachUI{
    coachViewObject=[[CoachView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size
                                                               .width, self.view.frame.size.height)];
    coachViewObject.backgroundColor=[UIColor clearColor];
    coachViewObject.coachDelegate=self;
    [self.view addSubview:coachViewObject];
}
#pragma mark - View Did Appear

-(void)viewDidAppear:(BOOL)animated {
    
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self LiveScoreCall:@"" apinumber:1];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {


}

#pragma mark - View will Appear

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self supportedInterfaceOrientations:YES];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Coach View"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
}


#pragma mark - Making Url With Current Time

-(NSString *)findingCurrentLiveScoreUrl :(int)venueIdCurrent lanenumber:(int)CurrentlaneNumber
{
    NSString *tempEnquiryUrl;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    
    NSString *toDateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSDate *fromDate=[NSDate dateWithTimeInterval:-5400 sinceDate:[NSDate date]];
    NSString *fromDateString=[dateFormat stringFromDate:fromDate];
    fromDateString=[fromDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    toDateString=[toDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"toDate=%@  fromDate=%@",toDateString,fromDateString);
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    tempEnquiryUrl=[NSString stringWithFormat:@"%@venue/%d/lane/%d?to=%@&from=%@&token=%@&apiKey=%@",serverAddress,venueIdCurrent,CurrentlaneNumber,toDateString,fromDateString,token,APIKey];
    
    return tempEnquiryUrl;
}

#pragma mark - Live Score Api Call Function

-(void)LiveScoreCall:(NSString *)enquiryUrlnotUsed apinumber:(int)currentapiNUmber
{
    apiNUmber=currentapiNUmber;
    NSString*enquiryUrl=[self findingCurrentLiveScoreUrl:venue lanenumber:laneNumber];
    NSDictionary *profileInfo =[callInstance afnetWorkingGetServerCall:enquiryUrl isAPIkeyToken:NO];
    NSLog(@"profileInfo :%@",profileInfo);
}

#pragma mark - Afnetworking Response Delegate

- (void)responseAction:(NSDictionary *)profileResponse {
    
    // [mytimer invalidate];
    if(apiNUmber==1)
    {
    if([[profileResponse objectForKey:responseCode]integerValue]==200)
    {
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];

        [coachViewObject  getLiveScoreInbackground:[profileResponse objectForKey:responseDataDic]];
    }
    }
    else if (apiNUmber==2)
    {
        if([[profileResponse objectForKey:responseCode]integerValue]==200)
        {
            [coachViewObject backGroundUpdateAction:[profileResponse objectForKey:responseDataDic]];
        }
    }
}

- (void)liveScoreVenueID:(int)venueid laneNumber:(int)lane
{
    venue=venueid;
    laneNumber=lane;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Custom function for orientation

#pragma mark - functions for rotating window

- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    isCampusLandscape = isCampusLandsc;
    if(isCampusLandscape)
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        // objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        // objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

// Default function for orientation

- (NSUInteger)supportedInterfaceOrientations
{
    if(isCampusLandscape)
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
        // objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)deviceOrientationDidChange
{
    //Obtaining the current device orientation
    if (isCampusLandscape)
    {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            return YES;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
            return NO;
        }
    }
    else
    {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            return NO;
        }
        
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            return NO;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            return YES;
        }
        
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
            return NO;
        }
    }
    return YES;
    // Do your Code using the current Orienation
}


#pragma mark - Back Button Action

-(void)backButtonAction
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
    [self performSelector:@selector(backdelay) withObject:nil afterDelay:0.01];
}

-(void)backdelay
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
