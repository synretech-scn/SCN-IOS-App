//
//  TagsController.m
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "TagsController.h"
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
#import "DetailNotificationView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"




@interface TagsController ()

@end

@implementation TagsController
{
    TagsView *showTags;
    ServerCalls *callInstance;
    int apinumber;
    LeftSlideMenu *leftMenu;;
    BOOL updateViewAlso;
    NSString *saveTags;
    id<GAITracker> tracker;
}

@synthesize gameId;

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    tracker = [[GAI sharedInstance] defaultTracker];
}

- (void)viewDidLoad {
    
    updateViewAlso=YES;
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Adding Tags"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    [super viewDidLoad];
//    leftMenu=[[LeftSlideMenu alloc]init];
//    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
//    leftMenu.rootViewController=self;
//    leftMenu.menuDelegate=self;
//    [self.view addSubview:leftMenu];
//    [leftMenu createMenuView];
//    leftMenu.hidden=YES;

    showTags=[[TagsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    showTags.tagControllerDelegate=self;
    [self.view addSubview: showTags];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    callInstance=[ServerCalls instance];
    callInstance.serverCallDelegate=self;
    
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    [self fetchUpdatedTagList];
}

#pragma mark - Save Button Update All

-(void)updateEdittedTags :(NSString *)tagsEditted
{
    
    saveTags=tagsEditted;
    
    NSString * editString = [tagsEditted stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    apinumber=1;
    NSLog(@"editString :%@",saveTags);
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey1 =[NSString stringWithFormat:@"%@",APIKey];
    NSString *enquiryUrl=[NSString stringWithFormat:@"%@",@"Tags/UpdateAllTags"];
    NSString *urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&GameId=%@&Tags=%@",serverAddress,enquiryUrl,token,apiKey1,self.gameId,editString];
    
   NSDictionary *tagsInfo =[callInstance afnetworkingPostServerCall:urlHit postdictionary:nil isAPIkeyToken:NO];
    NSLog(@"tagsInfo :%@",tagsInfo);
}

#pragma mark - API Response Delegate

- (void)responseAction:(NSDictionary *)notificationInfo
{
    if(apinumber==0)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            
            NSArray* tagsDetail=(NSArray  *)[notificationInfo objectForKey:responseDataDic];
            NSMutableArray *tagsStrings=[[NSMutableArray alloc]init];
            for(int i=0;i<tagsDetail.count;i++)
            {
                [tagsStrings addObject:[[tagsDetail objectAtIndex:i]objectForKey:@"tag"]];
            }
            [[NSUserDefaults standardUserDefaults]setObject:tagsStrings forKey:ksavingGameTags];
            
            [showTags updateTags:[notificationInfo objectForKey:responseDataDic]];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
    else  if(apinumber==1)
    {
        if([[notificationInfo objectForKey:responseCode]integerValue]==200)
        {
            [[DataManager shared]removeActivityIndicator];
            NSLog(@"array=:%@",[saveTags componentsSeparatedByString:@","]);
            if([saveTags  length]>0)
            {

            [[NSUserDefaults standardUserDefaults]setObject:[saveTags componentsSeparatedByString:@","] forKey:ksavingGameTags];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray new] forKey:ksavingGameTags];

            }

           // [self fetchUpdatedTagList];
            [self backButtonAction];
        }
        else{
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView5 show];
        }
    }
}

#pragma mark - Update tag API Call

-(void)fetchUpdatedTagList
{
    apinumber=0;
    
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSString *enquiryUrl=[NSString stringWithFormat:@"%@",@"Tags/TagList"];
    NSString *  urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&GameId=%@",serverAddress,enquiryUrl,token,apiKey,self.gameId];
    NSDictionary *TAGInfo =[callInstance afnetWorkingGetServerCall:urlHit isAPIkeyToken:NO];
    NSLog(@"tagsInfo :%@",TAGInfo);
}

#pragma mark - Back Button Action

-(void)backButtonAction {
    
    [self .navigationController popViewControllerAnimated:YES];
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            showTags.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, showTags.frame.size.width, showTags.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], showTags.frame.size.width, showTags.frame.size.height)];
            mainScreenCoverView.tag=20011;
            mainScreenCoverView.userInteractionEnabled=YES;
            [self.view addSubview:mainScreenCoverView];
        }];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftMenu.frame = CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
        } completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            showTags.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished)
        {
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
}



@end
