//
//  ViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 11/21/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "ViewController.h"
#import "BowlingViewController.h"
#import "SelectCenterViewController.h"
#import "Keys.h"
#import "LiveScoreViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *titlesArray;
    NSMutableArray *categoryImagesArray;
    //add
    NSURL *dynamicurl;
    //=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/home/generic?name=DynamicMenu&VenueId=15103"];
        NSDictionary *dynamicadsJsonDictionary;
       ServerCalls *serverCallInstance;
    
    
    UIScrollView *adsScroll;
    int adIndex;
    UIImageView *mainImageAdsView;
    NSDictionary *adsJsonDictionary;
    NSMutableArray *adsImgsArray;
    NSMutableArray *adsURLArray;
    NSMutableArray *adsBooleanCheckArray;
    NSMutableArray *adsNameArray;
    UIImageView *adsBaseView;
    LeftSlideMenu *leftMenu;
    UIImageView *backgroundView;
     ServerCalls *callInstance;
    UITableView *optionsTable;
    UIButton *sideNavigationButton;
    UIWebView *mainWebView;
    UIView *footerViewForWebview;
    id<GAITracker> tracker;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    if ([optionsTable isDescendantOfView:backgroundView]) {
        [optionsTable reloadData];
    }
    [self supportedInterfaceOrientations:NO];
//    tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home Screen"
//                                                          action:@"Action"
//                                                           label:nil
//                                                           value:nil] build]];
}

-(void)viewDidAppear:(BOOL)animated
{
    callInstance=[ServerCalls instance];
    callInstance.serverCallDelegate=self;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        NSDictionary *notificationInfo =[callInstance afnetWorkingGetServerCall:@"NotificationHistory/UnreadNotificationsCount" isAPIkeyToken:YES];
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:kAdsServerCall] == 0)
        {
            [self pushNotificationServerCall:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserEmailId]]];
            [self userProfileServerCall];
            [self adsServerCall];
        }
        [[DataManager shared ]removeActivityIndicator];
        NSLog(@"notificationInfo :%@",notificationInfo);

    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }


}


- (void)responseAction:(NSDictionary *)notificationInfo
{
    NSLog(@"notificationInfo :%@",notificationInfo);
//    [[DataManager shared]removeActivityIndicator];
    
    if([[notificationInfo objectForKey:responseCode]integerValue]==200)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[notificationInfo objectForKey:responseStringAF]] forKey:currentUnreadAllNotification];
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]);
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]integerValue];
        
        sideNavigationButton.userInteractionEnabled=true;
        [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-25,-5,25 ,25)]];
        
        [leftMenu reloadMenuTable];
        
    }
    else
    {
//        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView5=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView5 show];
        
    }
    
}

-(void)userProfileServerCall
{
    NSString *siteurl = [NSString stringWithFormat:@"%@userprofile",serverAddress];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSLog(@"token=%@",token);
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@",siteurl,token,apiKey];
    NSLog(@"enquiryurl=%@",enquiryurl);
    
    ASIHTTPRequest *userProfileRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:enquiryurl]];
    [userProfileRequest setDelegate:self];
    [userProfileRequest startSynchronous];
    
}

-(void)requestFinished:(ASIHTTPRequest *)ASIrequest
{
    NSLog(@"data=%@",[[NSString alloc]initWithData:[ASIrequest responseData] encoding:NSUTF8StringEncoding] );
    [[DataManager shared]removeActivityIndicator];
    if([ASIrequest responseData])
    {
        NSError *jsonError=nil;
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:ASIrequest.responseData options:kNilOptions error:&jsonError];
        NSLog(@"userName=%@",json);
        NSString *userName=[NSString stringWithFormat:@"%@",[json objectForKey:kScreenName]];
        userName=[userName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [[NSUserDefaults standardUserDefaults]setValue:userName forKeyPath:kuserName];
    }
    
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"errorOnProfileServerCall=%@",request.error);
    
}

#pragma mark - Push notification

- (void)pushNotificationServerCall:(NSString *)address
{
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/savedevicetoken?Email=%@&devicetype=0&deviceToken=%@",serverAddress,address,[[NSUserDefaults standardUserDefaults]valueForKey:kDeviceToken]]]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:kTimeoutInterval];
    NSLog(@"requestURL=%@",[NSString stringWithFormat:@"%@user/savedevicetoken?Email=%@&devicetype=0&deviceToken=%@",serverAddress,address,[[NSUserDefaults standardUserDefaults]valueForKey:kDeviceToken]]);
    [URLrequest setHTTPMethod:@"POST"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    if(response.statusCode == 200 && responseData)
    {
        
    }
    
    
    
    //add
    
    
    
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
      token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
     token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    
    NSMutableURLRequest *venueURLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/savevenuedevicetoken?Email=%@&devicetype=0&deviceToken=%@&venueid=15103&token=%@&apikey=%@",serverAddress,address,[[NSUserDefaults standardUserDefaults]valueForKey:kDeviceToken],token,apiKey    ]]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                             timeoutInterval:kTimeoutInterval];
    NSLog(@"venuerequestURL=%@",[NSString stringWithFormat:@"%@user/savevenuedevicetoken?Email=%@&devicetype=0&deviceToken=%@&venueid=15103&token=%@&apikey=%@",serverAddress,address,[[NSUserDefaults standardUserDefaults]valueForKey:kDeviceToken]   ,token,apiKey  ]);
    [venueURLrequest setHTTPMethod:@"POST"];
    [venueURLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *venueerror1=nil;
    NSHTTPURLResponse *venueresponse=nil;
    NSData *venueresponseData=[NSURLConnection sendSynchronousRequest:venueURLrequest returningResponse:&venueresponse error:&venueerror1];
    NSString *venueresponseString=[[NSString alloc] initWithData:venueresponseData encoding:NSUTF8StringEncoding];
    NSLog(@"venueresponseString = %@",venueresponseString);
    NSLog(@"venuestatusCode=%ld",(long)venueresponse.statusCode);
    if(venueresponse.statusCode == 200 && venueresponseData)
    {
        
    }
    
    //http://api.xbowling.com/User/SaveVenueDeviceToken?venueId={venueId}&deviceType={type}&deviceToken={deviceToken}&apiKey={apiKey}&token={token}

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self supportedInterfaceOrientations:NO];
    backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.userInteractionEnabled=YES;
    [backgroundView setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroundView];
    
    //add
    backgroundView.backgroundColor=XBHeaderColor;
    
    NSLog(@"view controller");
      //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.menuDelegate=self;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];
    leftMenu.hidden=YES;
    
    adsBaseView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1030/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    //    [adsBaseView setImage:[UIImage imageNamed:@"ad_banner_1.png"]];
    adsBaseView.userInteractionEnabled=YES;
    [adsBaseView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:adsBaseView];
    
    
    adsURLArray=[NSMutableArray new];
    adsBooleanCheckArray = [NSMutableArray new];
    NSArray *tempArrayForURL=[[NSUserDefaults standardUserDefaults]objectForKey:@"adsURLArray"];
    adsURLArray=[[NSMutableArray alloc]initWithArray:tempArrayForURL];
    NSLog(@"adsURLArray=%@",adsURLArray);
    
    NSArray *tempArrayForCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"adsCheckArray"];
    adsBooleanCheckArray=[[NSMutableArray alloc]initWithArray:tempArrayForCheck];
    NSLog(@"adsBooleanCheckArray=%@",adsBooleanCheckArray);
    
    adsNameArray=[NSMutableArray new];
    NSArray *tempArrayForNames=[[NSUserDefaults standardUserDefaults]objectForKey:@"adsNameArray"];
    adsNameArray=[[NSMutableArray alloc]initWithArray:tempArrayForNames];
    NSLog(@"adsNameArray=%@",adsNameArray);
    
    adsImgsArray=[NSMutableArray new];
    long int count=[[NSUserDefaults standardUserDefaults]integerForKey:@"adsArrayCount"];
    if (count > 0) {
        for(int i=0;i<count;i++)
        {
            [adsImgsArray addObject:[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
        }
        NSLog(@"adsArray=%@",adsImgsArray);
        adsScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, adsBaseView.frame.size.height)];
        adsScroll.bounces=NO;
        adsScroll.userInteractionEnabled = YES;
        adsScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        adsScroll.pagingEnabled=YES;
        adsScroll.backgroundColor = [UIColor clearColor];
        adsScroll.showsVerticalScrollIndicator = NO;
        adsScroll.showsHorizontalScrollIndicator=NO;
        adsScroll.delegate=self;
        adsScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [adsBaseView addSubview:adsScroll];
        for(int i=0;i<adsImgsArray.count;i++)
        {
            
            mainImageAdsView=[[UIImageView alloc]initWithFrame:CGRectMake(adsBaseView.frame.size.width * i, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
            mainImageAdsView.contentMode=UIViewContentModeScaleAspectFit;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"document directory==%@",documentsDirectory);
            NSString *savedGroupImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[adsImgsArray objectAtIndex:i]]];
            if([[NSFileManager defaultManager] fileExistsAtPath:savedGroupImagePath] && [NSData dataWithContentsOfFile:savedGroupImagePath])
            {
                UIImage *image = [UIImage imageWithContentsOfFile:savedGroupImagePath];
                [mainImageAdsView setImage:image];
                mainImageAdsView.tag=16600+i;
                mainImageAdsView.userInteractionEnabled=YES;
                UITapGestureRecognizer  *adtapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adsTapFunction:)] ;
                adtapRecognizer.numberOfTapsRequired = 1;
                [mainImageAdsView addGestureRecognizer:adtapRecognizer];
                [adsScroll addSubview:mainImageAdsView];
            }
        }
        [adsScroll setContentSize:CGSizeMake(adsBaseView.frame.size.width*adsImgsArray.count,adsScroll.frame.size.height)];
        
    }
    else{
        mainImageAdsView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
        mainImageAdsView.contentMode=UIViewContentModeScaleAspectFit;
        [mainImageAdsView setImage:[UIImage imageNamed:@"default_slider.png"]];
        mainImageAdsView.tag=16600;
        mainImageAdsView.userInteractionEnabled=YES;
        UITapGestureRecognizer  *adtapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adsTapFunction:)] ;
        adtapRecognizer.numberOfTapsRequired = 1;
        [mainImageAdsView addGestureRecognizer:adtapRecognizer];
        [adsBaseView addSubview:mainImageAdsView];
        
    }
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20,self.view.frame.size.width, 35)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    headerLabel.tag=190;
    headerLabel.text=@"SCN Strike First";
    //add
    headerLabel.opaque= true;

    
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.numberOfLines=2;
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:23.3 currentSuperviewDeviceSize:screenBounds.size.height]];
    headerLabel.userInteractionEnabled=YES;
    //    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:23.3];
    [adsBaseView addSubview:headerLabel];
    
    
    
    /////add
    headerLabel.backgroundColor=XBHeaderColor;
    
    
    sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60 currentSuperviewDeviceSize:screenBounds.size.width], headerLabel.frame.size.height)];
    sideNavigationButton.tag=90;
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:16.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:16.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(showMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [headerLabel addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-25,-5,25 ,25)]];
  
    UIImage *iconImage=[UIImage imageNamed:@"gobowling_icon_on.png"];
    UIButton *goBowlingButton=[[UIButton alloc]initWithFrame:CGRectMake(0, adsBaseView.frame.origin.y+adsBaseView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height],self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    /*
    
//    [goBowlingButton setBackgroundImage:[[DataManager shared]imageWithColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]] forState:UIControlStateHighlighted];
  //[goBowlingButton setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
   //
    //add
            [goBowlingButton setBackgroundColor:[UIColor colorWithRed:25.0/255 green:7.0/255 blue:27.0/255 alpha:1]];
    
    [goBowlingButton addTarget:self action:@selector(goBowlingFunction) forControlEvents:UIControlEventTouchUpInside];
    //set attributed title of button
    NSString *string = @"Go Bowling \nWelcome to the ultimate bowling experience";
    NSRange range = [string rangeOfString:@"\n"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]] range:NSMakeRange(0, range.location)];
    if (screenBounds.size.height == 480)
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range.location)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
    [goBowlingButton setAttributedTitle:attrString forState:UIControlStateNormal];
    goBowlingButton.titleLabel.font=[UIFont systemFontOfSize:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [goBowlingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBowlingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    goBowlingButton.titleLabel.numberOfLines = 0;
    [backgroundView addSubview:goBowlingButton];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:iconImage.size.width/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:iconImage.size.height/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    icon.center = CGPointMake(icon.center.x, goBowlingButton.frame.size.height/2);
    [icon setImage:[UIImage imageNamed:@"gobowling_icon_on.png"]];
    [goBowlingButton addSubview:icon];
    
    //make the buttons content appear in the center
    [goBowlingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [goBowlingButton setContentEdgeInsets:UIEdgeInsetsMake(0,icon.frame.size.width+icon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.width], 0, 0)];
    [goBowlingButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(goBowlingButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.center=CGPointMake(arrow.center.x, goBowlingButton.frame.size.height/2);
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [goBowlingButton addSubview:arrow];
      */
     
    optionsTable=[[UITableView alloc]init];
    //add
        optionsTable.frame=CGRectMake(0,  goBowlingButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:goBowlingButton.frame.size.height+970/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    
   // optionsTable.frame=CGRectMake(0, goBowlingButton.frame.size.height+goBowlingButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:870/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    NSLog(@"self.view.frame.size.height=%f optionsTable.frame.origin.y=%f",self.view.frame.size.height,optionsTable.frame.origin.y);
   // optionsTable.backgroundColor=[UIColor clearColor];
    //add
 /////   optionsTable.backgroundColor=[UIColor colorWithRed:48.0/255 green:0.0/255 blue:47.0/255 alpha:0.9];
    
    
    optionsTable.backgroundColor=[UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.9];
    
    
    
    optionsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    optionsTable.delegate=self;
    optionsTable.dataSource=self;
    [backgroundView addSubview:optionsTable];
 
    if (screenBounds.size.height == 480) {
        //iphone 4
        //        headerLabel.frame = CGRectMake(0, 20,self.view.frame.size.width, 35);
        //        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:15];
        //        adsBaseView.frame=CGRectMake(0, headerLabel.frame.size.height+headerLabel.frame.origin.y, self.view.frame.size.width, 200);
        //        goBowlingButton.frame=CGRectMake(0, adsBaseView.frame.origin.y+adsBaseView.frame.size.height+8,self.view.frame.size.width, 60);
        //        goBowlingButton.titleLabel.font=[UIFont systemFontOfSize:11.0];
        //        //move text 10 pixels down and 50 px right
        //        [goBowlingButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 50.0f, 0.0f, 0.0f)];
    /*    [goBowlingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [goBowlingButton setContentEdgeInsets:UIEdgeInsetsMake(0,icon.frame.size.width+icon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6 currentSuperviewDeviceSize:screenBounds.size.width], 0, 0)];
        [goBowlingButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        icon.frame=CGRectMake(12, 15, 35, 35);
        icon.center = CGPointMake(icon.center.x, goBowlingButton.frame.size.height/2);
       
     *///        arrow.frame= CGRectMake(goBowlingButton.frame.size.width - 15, 22, 9, 15);
        //        optionsTable.frame=CGRectMake(0, goBowlingButton.frame.size.height+goBowlingButton.frame.origin.y+8, self.view.frame.size.width, self.view.frame.size.height - (goBowlingButton.frame.size.height+goBowlingButton.frame.origin.y+8));
    }
   
    [[DataManager shared] initializeLocationManager];
    
    /*For Wallet*/
    /*
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"XB Pro Stats \nThe official stats tracker of USBC",@"Scores & Statistics \nView your game history and analysis",@"Live Scores \nCheckout live scores around the world",@"XBowling Profile \nManage your bowler profile details and photo",@"USBC Tournaments \nLeaderboards and Live Scores",@"Friends \nTell a Friend, Add a XBowling Friend",@"Credits \nPurchase credits",@" \nComing soon to XBowling. Learn more.",@" \nComing soon to XBowling. Learn more.",@"Reward Points Wallet \nEarn and redeem reward points",nil];
    categoryImagesArray=[[NSMutableArray alloc]initWithObjects:@"xbpro_icon.png",@"xbpro_icon_on.png",@"scores_stats_icon.png",@"scores_stats_icon_on.png",@"livescores_icon.png",@"livescores_icon_on.png",@"xbowling_profile_icon.png",@"xbowling_profile_icon_on.png",@"championship_icon.png",@"championship_icon_onclick.png",@"add_friend_icon.png",@"add_friends_icon_onclick.png",@"credit_icon.png",@"credit_icon_onclick.png",@"music_play_offclick.png",@"music_play_onclick.png",@"bowler_offclick.png",@"bowler_onclick.png",@"wallet_offclick.png",@"wallet_onclick.png", nil];
    */
    
    /*
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"SCN Strike First Loyalty and Rewards \nEarn and redeem reward points",@"Special Promotions \nGet the latest specials and deals",@"Bowl VIP \nVIP Membership access only.",@"League Information \nLeague standings and league sign-up",@"Go Bowling \nWelcome to the ultimate bowling experience",@"My XB Pro Stats \nOfficial USBC game analysis",@"Scores & Statistics \nView your game history and analysis",@"Call Us/Find Us \nContact, Schedule , Get directions",@"Learn More \nExplore SCN Strike First Websites, Events and More.",@"Live Scores \nCheckout live scores around the world",@"XBowling Profile \nManage your bowler profile details and photo",@"USBC Tournaments \nLeaderboards and Live Scores",@"Friends \nTell a Friend, Add a XBowling Friend",@"Credits \nPurchase credits",@" \nComing soon to XBowling. Learn more.",@" \nComing soon to XBowling. Learn more.",nil];
    categoryImagesArray=[[NSMutableArray alloc]initWithObjects:@"wallet_offclick.png",@"wallet_onclick.png",@"coupon_offclick.png",@"coupon_onclick.png",@"vip_offclick.png",@"vip_onclick.png",@"league_offclick.png",@"league_onclick.png",
          @"gobowling_icon.png",@"gobowling_icon_on.png",
                         
                         @"xbpro_icon.png",@"xbpro_icon_on.png",@"scores_stats_icon.png",@"scores_stats_icon_on.png",@"callus_offclick.png",@"callus_onclick.png",@"more_offclick.png",@"more_onclick.png",@"livescores_icon.png",@"livescores_icon_on.png",@"xbowling_profile_icon.png",@"xbowling_profile_icon_on.png",@"championship_icon.png",@"championship_icon_onclick.png",@"add_friend_icon.png",@"add_friends_icon_onclick.png",@"credit_icon.png",@"credit_icon_onclick.png",@"music_play_offclick.png",@"music_play_onclick.png",@"bowler_offclick.png",@"bowler_onclick.png", nil];
    
    */
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"SCN Strike First Loyalty and Rewards \nEarn and redeem reward points",@"Special Promotions \nGet the latest specials and deals",@"Bowl VIP \nVIP Membership access only.",@"League Information \nLeague standings and league sign-up",@"Go XBowling \nConnect and bowl with people around the world",@"Call Us/Find Us \nContact, Schedule, Get directions",@"My XB Pro Stats \nOfficial USBC game analysis",@"Live Scores and Leaderboards \nLive scores and leaderboards around the world",@"Learn More \nExplore SCN Strike First Websites, Events and More.",@"Player Profile \nManage your profile and photo",@"Get Social with Friends \nShare with friends / add friends on social media",@" \nComing soon to XBowling. Learn more.",@" \nThe latest bowling news at your fingertips",@"XBowling Credits \nCredits for head-to-head challenges to win SCN reward points",@"USBC Tournaments \nLeaderboards and Live Scores",@"pBirthday Events \npSpecial events for Birthday",nil];
    categoryImagesArray=[[NSMutableArray alloc]initWithObjects:@"wallet_onclick.png",@"wallet_offclick.png",@"coupon_onclick.png",@"coupon_offclick.png",@"vip_onclick.png",@"vip_offclick.png",@"league_onclick.png",@"league_offclick.png",
                         @"gobowling_icon_on.png",@"gobowling_icon.png",
                         @"callus_onclick.png",@"callus_offclick.png",
                         @"xbpro_icon_on.png",@"xbpro_icon.png"
                         ,@"livescores_icon_on.png",@"livescores_icon.png"
                         ,@"more_onclick.png",@"more_offclick.png", @"xbowling_profile_icon_on.png",@"xbowling_profile_icon.png",@"add_friends_icon_onclick.png",@"add_friend_icon.png",@"music_play_onclick.png",@"music_play_offclick.png",@"bowler_onclick.png",@"bowler_offclick.png",@"credit_icon_onclick.png",@"credit_icon.png",@"championship_icon_onclick.png",@"championship_icon.png",@"Birthday_icon_on.png",@"Birthday_icon.png", nil];
    //add
    
      dynamicurl=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/home/generic?name=DynamicMenu&VenueId=15103"];
    /*
    titlesArray=[[NSMutableArray alloc]initWithObjects:@"SCN Strike First Loyalty and Rewards \nEarn and redeem reward points",@"Special Promotions \nGet the latest specials and deals",@"Call Us/Find Us \nContact, Schedule , Get directions",@"League Information \nLeague standings and league sign-up",@"Go XBowling \nWelcome to the ultimate bowling experience",@"My XB Pro Stats \nOfficial USBC game analysis",@"Live Scores and Leaderboards \nLive scores and leaderboards around the world",@"Bowl VIP \nVIP Membership access only.",@"Learn More \nExplore SCN Strike First Websites, Events and More.",@"Player Profile \nManage your profile and photo",@"Get Social with Friends \nShare with friends / add friends on social media",@" \nComing soon to XBowling. Learn more.",@" \nThe latest bowling news at your fingertips",@"XBowling Credits \nPurchase credits to contest against other XBowlers",@"USBC Tournaments \nLeaderboards and Live Scores",nil];
    categoryImagesArray=[[NSMutableArray alloc]initWithObjects:@"wallet_onclick.png",@"wallet_offclick.png",@"coupon_onclick.png",@"coupon_offclick.png",@"callus_onclick.png",@"callus_offclick.png",@"league_onclick.png",@"league_offclick.png",
                         @"gobowling_icon_on.png",@"gobowling_icon.png",
                         
                         @"xbpro_icon_on.png",@"xbpro_icon.png"
                         ,@"livescores_icon_on.png",@"livescores_icon.png"
                         ,@"vip_onclick.png",@"vip_offclick.png",@"more_onclick.png",@"more_offclick.png", @"xbowling_profile_icon_on.png",@"xbowling_profile_icon.png",@"add_friends_icon_onclick.png",@"add_friend_icon.png",@"music_play_onclick.png",@"music_play_offclick.png",@"bowler_onclick.png",@"bowler_offclick.png",@"credit_icon_onclick.png",@"credit_icon.png",@"championship_icon_onclick.png",@"championship_icon.png", nil];
    */
    
    /*Without Wallet*/
//    titlesArray=[[NSMutableArray alloc]initWithObjects:@"XB Pro Stats \nThe official stats tracker of USBC",@"Scores & Statistics \nView your game history and analysis",@"Live Scores \nCheckout live scores around the world",@"XBowling Profile \nManage your bowler profile details and photo",@"USBC Tournaments \nLeaderboards and Live Scores",@"Friends \nTell a Friend, Add a XBowling Friend",@"Credits \nPurchase credits",@"Bowling Music Network \nComing soon to XBowling. Learn more.",@"Bowlers Journal \nComing soon to XBowling. Learn more.",nil];
//      categoryImagesArray=[[NSMutableArray alloc]initWithObjects:@"xbpro_icon.png",@"xbpro_icon_on.png",@"scores_stats_icon.png",@"scores_stats_icon_on.png",@"livescores_icon.png",@"livescores_icon_on.png",@"xbowling_profile_icon.png",@"xbowling_profile_icon_on.png",@"championship_icon.png",@"championship_icon_onclick.png",@"add_friend_icon.png",@"add_friends_icon_onclick.png",@"credit_icon.png",@"credit_icon_onclick.png",@"music_play_offclick.png",@"music_play_onclick.png",@"bowler_offclick.png",@"bowler_onclick.png", nil];
    if(adsImgsArray.count > 0)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(autoScrollAds)
                                                   object:nil];
        [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:2.0];
    }
    
 }

#pragma mark - Auto Scroll Ads

-(void)adsServerCall
{
    NSLog(@"backgroundTask in adsCall1");
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
    [[NSUserDefaults standardUserDefaults]setInteger:999 forKey:kAdsServerCall];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
       
        
    NSString *urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/location?token=%@&apiKey=%@&Latitude=%@&Longitude=%@",serverAddress,token,APIKey,[[NSUserDefaults standardUserDefaults]valueForKey:kLatitude],[[NSUserDefaults standardUserDefaults]valueForKey:kLongitude]];
//    NSString *urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/Location/LandScapeApp?token=%@&apiKey=%@&Latitude=%@&Longitude=%@",serverAddress,token,APIKey,@"33.9875",@"-83.8919"];
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kLatitude]] isEqualToString:@"(null)"]) {
        urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/location?token=%@&apiKey=%@&Latitude=0.0&Longitude=0.0",serverAddress,token,APIKey];
    }
        
        
      //   urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/location?token=%@&apiKey=%@&Latitude=40.5324223&Longitude=-74.2967081",serverAddress,token,APIKey];
        
   //urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/Location/VenueId?VenueId=15103&token=%@&apiKey=%@&Latitude=40.5324223&Longitude=-74.2967081",serverAddress,token,APIKey];
        
        
       
        
    //    urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/Location/VenueId?VenueId=15103&apiKey=&token=%@&apiKey=%@&Latitude=40.5324223&Longitude=-74.2967081",serverAddress,token,APIKey];
        
        
        urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/Location/VenueId?VenueId=15103&token=%@&apiKey=%@",serverAddress,token,APIKey];
        
       // https://api.xbowling.com/advertisementimage/slider/location?token=MDEwMDE2V0zGdQR5wD7MD8qXumQ4zBSKqZEiTiA37pDRGFefxtvQTiXhbF4GrZCOEX7HRaKz%2BkKvT36Kaes6Xk2SHXZIchC7ihSLEx2FIsPxOaa5pFyvDls6nrVS0jJELyoiBdB1ad3jRow9QSKJB%2FGVkM492w%3D%3D&apiKey=158478DC73FA498DB5D29BF13E9033F5&Latitude=40.5324223&Longitude=-74.2967081
       // urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/location?token=MDEwMDE2V0zGdQR5wD7MD8qXumQ4zBSKqZEiTiA37pDRGFefxtvQTiXhbF4GrZCOEX7HRaKz%2BkKvT36Kaes6Xk2SHXZIchC7ihSLEx2FIsPxOaa5pFyvDls6nrVS0jJELyoiBdB1ad3jRow9QSKJB%2FGVkM492w%3D%3D&apiKey=158478DC73FA498DB5D29BF13E9033F5&Latitude=40.5324223&Longitude=-74.2967081",serverAddress,token,APIKey];
        
        
        //urlString = [NSString stringWithFormat:@"%@advertisementimage/slider/Location/LandScapeApp?token=%@&apiKey=%@&Latitude=%@&Longitude=%@",serverAddress,token,APIKey,@"33.9875",@"-83.8919"];
        NSLog(@"urlString=%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:@{}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [adsImgsArray removeAllObjects];
             adsImgsArray=nil;
             adsImgsArray=[NSMutableArray new];
             [adsURLArray removeAllObjects];
             adsURLArray=nil;
             adsURLArray=[NSMutableArray new];
             [adsBooleanCheckArray removeAllObjects];
             adsBooleanCheckArray=nil;
             adsBooleanCheckArray=[NSMutableArray new];
             [adsNameArray removeAllObjects];
             adsNameArray=nil;
             adsNameArray=[NSMutableArray new];
             adsJsonDictionary=[[NSDictionary alloc]initWithDictionary:responseObject];
             //NSLog(@"adsJsonDictionary=%@",adsJsonDictionary);
             dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 for(int i=0;i<[[adsJsonDictionary objectForKey:@"table"] count]; i++)
                 {
                     
                     NSString *imageString=[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"left_ImageBase64"];
                     NSData *imgdata=[NSData dataFromBase64String:imageString];
                     if(imgdata){
                         if(imgdata.length > 4){
                             UIImage *image=[UIImage imageWithData:imgdata];
                             //write to DD
                             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString *documentsDirectory = [paths objectAtIndex:0];
                             NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                             NSLog(@"path=%@",fullPath);
                             NSData *imageData = UIImagePNGRepresentation(image);
                             [imageData writeToFile:fullPath atomically:NO];
                             NSURL *url = [NSURL fileURLWithPath:fullPath];
                             [[DataManager shared] addSkipBackupAttributeToItemAtURL:url];
                         }
                     }
                     [adsImgsArray addObject:[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                     //                    [adsBooleanCheckArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"isUrl"]];
                     [adsURLArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"uRL"]];
                     if(![[NSString stringWithFormat:@"%@",[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"sectionName"]] isEqualToString:@"<null>"])
                         [adsNameArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"sectionName"]];
                     else
                         [adsNameArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"name"]];
                 }
                 [[NSUserDefaults standardUserDefaults]setObject:adsURLArray forKey:@"adsURLArray"];
                 //                [[NSUserDefaults standardUserDefaults]setObject:adsBooleanCheckArray forKey:@"adsCheckArray"];
                 [[NSUserDefaults standardUserDefaults]setObject:adsNameArray forKey:@"adsNameArray"];
                 [[NSUserDefaults standardUserDefaults]setInteger:adsImgsArray.count forKey:@"adsArrayCount"];
            dispatch_async( dispatch_get_main_queue(), ^{
                [[DataManager shared]removeActivityIndicator];
                if(adsJsonDictionary.count > 0)
                {
                    //display Images
                    NSLog(@"adsURLArray=%@",adsURLArray);
                    
                    [mainImageAdsView removeFromSuperview];
                    for(int i=0;i<adsImgsArray.count;i++)
                    {
                        [mainImageAdsView removeFromSuperview];
                        mainImageAdsView=nil;
                    }
                    [adsScroll removeFromSuperview];
                    adsScroll=nil;
                    adsScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
                    adsScroll.bounces=NO;
                    adsScroll.userInteractionEnabled = YES;
                    adsScroll.decelerationRate = UIScrollViewDecelerationRateFast;
                    adsScroll.pagingEnabled=YES;
                    adsScroll.backgroundColor = [UIColor clearColor];
                    adsScroll.showsVerticalScrollIndicator = NO;
                    adsScroll.showsHorizontalScrollIndicator=NO;
                    adsScroll.delegate=self;
                    adsScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                    [adsBaseView insertSubview:adsScroll belowSubview:(UILabel *)[self.view viewWithTag:190]];
                    // [adsBaseView addSubview:adsScroll];
                    NSLog(@"imagesArray=%@",adsImgsArray);
                    for(int i=0;i<adsImgsArray.count;i++)
                    {
                        mainImageAdsView=[[UIImageView alloc]initWithFrame:CGRectMake(adsBaseView.frame.size.width * i, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSLog(@"document directory==%@",documentsDirectory);
                        NSString *savedGroupImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[adsImgsArray objectAtIndex:i]]];
                        if([[NSFileManager defaultManager] fileExistsAtPath:savedGroupImagePath] && [NSData dataWithContentsOfFile:savedGroupImagePath])
                        {
                            UIImage *image = [UIImage imageWithContentsOfFile:savedGroupImagePath];
                            [mainImageAdsView setImage:image];
                            mainImageAdsView.tag=16600+i;
                            mainImageAdsView.userInteractionEnabled=YES;
                            mainImageAdsView.contentMode=UIViewContentModeScaleAspectFit;
                            UITapGestureRecognizer  *adtapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adsTapFunction:)] ;
                            adtapRecognizer.numberOfTapsRequired = 1;
                            [mainImageAdsView addGestureRecognizer:adtapRecognizer];
                            [adsScroll addSubview:mainImageAdsView];
                        }
                        
                    }
                    [adsScroll setContentSize:CGSizeMake(adsBaseView.frame.size.width*adsImgsArray.count,adsScroll.frame.size.height)];
                    //                [adsBaseView bringSubviewToFront:(UIButton *)[adsBaseView viewWithTag:6001]];
                    if(adsImgsArray.count > 0)
                    {
                        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                                 selector:@selector(autoScrollAds)
                                                                   object:nil];
                        [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
                        
                    }
                }
            });
                              });

         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"fsilure reason=%@",error.description);
         }];
  
    
    
    
    
    
//add
   /*
    UITableViewCell *cell = [optionsTable  cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#>:15];
    UIButton *btn=(UIButton *)[cell viewWithTag:100+15];
    [btn setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
    UIImageView *arrow=(UIImageView *)[btn viewWithTag:903];
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIImage *iconImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[categoryImagesArray objectAtIndex:(indexPath.row*2)+1]]];
    UIImageView *icon=(UIImageView *)[cell viewWithTag:902];
    [icon setImage:iconImage];
    */
    
    
    
   
   // NSString      *dynamicurlString = [NSString stringWithFormat:@"%@DynamicMenu?venueId=15103&token=%@&apiKey=%@",serverAddress,token,APIKey];
    
      //  NSString      *dynamicurlString = [NSString stringWithFormat:@"DynamicMenu"];
        
      
        /*
        
        NSString *siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=100",siteurl,token,apiKey];
        NSLog(@"enquiryurl=%@",enquiryurl);
        */
      /*  NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:dynamicurlString]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                   encoding:NSUTF8StringEncoding]);
         */
     ////   NSString *urlString = [NSString stringWithFormat:@"venue/%lu/userpointPair",(unsigned long)venueId];
         serverCallInstance=[ServerCalls instance];
        
        NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"venueId=15103&" url:@"DynamicMenu" contentType:@"" httpMethod:@"GET"];
       // NSLog(@"response code=%@",json);
       // return json;
        
        
        /*NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
         */
     //   if(response.statusCode == 200 && responseData)
       if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
          //  NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
          //  NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //
         //   NSDictionary *jsondict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:@"responseString"]];
          //  NSDictionary *jsondict =[[NSDictionary alloc]initWithDictionary:[[json objectForKey:kResponseString] objectAtIndex:0 ]];
            
             NSDictionary *jsondict =[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]  ];
            
            //responseString
            int rowid=15;
           // NSString *titleString=[[jsondict  objectForKey:@"title"] stringValue];
               NSString *titleString=[jsondict  objectForKey:@"title"];
            NSString *descriptionString=[jsondict  objectForKey:@"description"] ;
            NSString *linkString=[jsondict  objectForKey:@"linkUrl"]  ;
            NSLog(@"linkString=%@",linkString);
           //  if([[[json objectForKey:@"responseString"] objectAtIndex:0] count]> 0)
            NSString *imageString=[jsondict objectForKey:@"imageBase64"] ;
            
            NSData *imgdata=[NSData dataFromBase64String:imageString];
            
               NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            
            
            if(imgdata){
                if(imgdata.length > 4){
                    UIImage *image=[UIImage imageWithData:imgdata];
                    //write to DD
                 //   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 //   NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[@"dynaicon" stringByAppendingString:[NSString stringWithFormat:@"%d.png",rowid]]];
                    NSLog(@"path=%@",fullPath);
                    NSData *imageData = UIImagePNGRepresentation(image);
                    [imageData writeToFile:fullPath atomically:NO];
                 //   NSURL *url = [NSURL fileURLWithPath:fullPath];
                  //  [[DataManager shared] addSkipBackupAttributeToItemAtURL:url];
                }
            }

            //[@"icon" stringByAppendingString:[NSString stringWithFormat:@"%d",rowid]]
         
            [categoryImagesArray replaceObjectAtIndex: rowid*2+1 withObject:[documentsDirectory stringByAppendingPathComponent:[@"dynaicon" stringByAppendingString:[NSString stringWithFormat:@"%d.png",rowid]]]];
            [categoryImagesArray replaceObjectAtIndex: rowid*2 withObject:[documentsDirectory stringByAppendingPathComponent:[@"dynaicon" stringByAppendingString:[NSString stringWithFormat:@"%d.png",rowid]]]];
            [titlesArray replaceObjectAtIndex: rowid withObject:[titleString stringByAppendingString:[NSString stringWithFormat:@" \n%@",descriptionString]]];
            
              dynamicurl=   [NSURL URLWithString:linkString];

             [optionsTable reloadData];
          /*
           myFriendsArray=[[NSMutableArray alloc]initWithArray:json];
            NSLog(@"json=%@",myFriendsArray);
            numberofbowlersdisplayed=(int)myFriendsArray.count;
            [self showscrollview:myFriendsArray searchString:nil];
           */
        }
        else
            [[DataManager shared]removeActivityIndicator];
        
        
        /*
        
        AFHTTPRequestOperationManager *dynamicmanager = [AFHTTPRequestOperationManager manager];
        [dynamicmanager GET:dynamicurlString
          parameters:@{}
         
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         */
        /*
                 [adsImgsArray removeAllObjects];
                 adsImgsArray=nil;
                 adsImgsArray=[NSMutableArray new];
                 [adsURLArray removeAllObjects];
                 adsURLArray=nil;
                 adsURLArray=[NSMutableArray new];
                 [adsBooleanCheckArray removeAllObjects];
                 adsBooleanCheckArray=nil;
                 adsBooleanCheckArray=[NSMutableArray new];
                 [adsNameArray removeAllObjects];
                 adsNameArray=nil;
                 adsNameArray=[NSMutableArray new];
                  */
            /*     dynamicadsJsonDictionary=responseObject;//[[NSDictionary alloc]initWithDictionary:responseObject];
                //  NSLog(@"dynamicadsJsonDictionary=%@",dynamicadsJsonDictionary);
                 dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   //  for(int i=0;i< [[adsJsonDictionary objectForKey:@"table"] count]; i++)
                     {
                         int rowid=15;
                         
                         
                         NSString *imageString=[dynamicadsJsonDictionary  objectForKey:@"imageBase64"];
                                                
                         NSData *imgdata=[NSData dataFromBase64String:imageString];
                         if(imgdata){
                             if(imgdata.length > 4){
                                 UIImage *image=[UIImage imageWithData:imgdata];
                                 //write to DD
                                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                 NSString *documentsDirectory = [paths objectAtIndex:0];
                                 NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[@"icon" stringByAppendingString:[NSString stringWithFormat:@"%d",rowid]]];
                                 NSLog(@"path=%@",fullPath);
                                 NSData *imageData = UIImagePNGRepresentation(image);
                                 [imageData writeToFile:fullPath atomically:NO];
                                 NSURL *url = [NSURL fileURLWithPath:fullPath];
                                 [[DataManager shared] addSkipBackupAttributeToItemAtURL:url];
                             }
                         }
             
             */
                        /* [adsImgsArray addObject:[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                         //                    [adsBooleanCheckArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"isUrl"]];
                         [adsURLArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"uRL"]];
                         if(![[NSString stringWithFormat:@"%@",[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"sectionName"]] isEqualToString:@"<null>"])
                             [adsNameArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"sectionName"]];
                         else
                             [adsNameArray addObject:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:i] objectForKey:@"name"]];
                         */
                /*     }  //for
                 */
                     /*
                     [[NSUserDefaults standardUserDefaults]setObject:adsURLArray forKey:@"adsURLArray"];
                     //                [[NSUserDefaults standardUserDefaults]setObject:adsBooleanCheckArray forKey:@"adsCheckArray"];
                     [[NSUserDefaults standardUserDefaults]setObject:adsNameArray forKey:@"adsNameArray"];
                     [[NSUserDefaults standardUserDefaults]setInteger:adsImgsArray.count forKey:@"adsArrayCount"];
                      */
                  /*   dispatch_async( dispatch_get_main_queue(), ^{
                         [[DataManager shared]removeActivityIndicator];
                         
                         
                         int rowid=15;
                          NSString *titleString=[dynamicadsJsonDictionary  objectForKey:@"title"];
                           NSString *descriptionString=[dynamicadsJsonDictionary  objectForKey:@"description"];
                            NSString *linkString=[dynamicadsJsonDictionary  objectForKey:@"linkUrl"];
                        NSLog(@"linkString=%@",linkString);
                         //[@"icon" stringByAppendingString:[NSString stringWithFormat:@"%d",rowid]]
                           
                           [categoryImagesArray replaceObjectAtIndex: rowid*2+1 withObject:[@"icon" stringByAppendingString:[NSString stringWithFormat:@"%d",rowid]]];
                           [categoryImagesArray replaceObjectAtIndex: rowid*2 withObject:[@"icon" stringByAppendingString:[NSString stringWithFormat:@"%d",rowid]]];
                         [titlesArray replaceObjectAtIndex: rowid withObject:[titleString stringByAppendingString:[NSString stringWithFormat:@" \n%@",descriptionString]]];
                          
                       */
                           /*
                         
                         [categoryImagesArray replaceObjectAtIndex: rowid*2+1 withObject:@"skillgaming_icon_on.png"];
                         [categoryImagesArray replaceObjectAtIndex: rowid*2 withObject:@"skillgaming_icon.png"];
                         [titlesArray replaceObjectAtIndex: rowid withObject:@"Skilled gaming \nSkilled Gaming"];
                         */
                         
                     /*    [optionsTable reloadData];
                      */
                         /*
                         
                         if(adsJsonDictionary.count > 0)
                         {
                             //display Images
                             NSLog(@"adsURLArray=%@",adsURLArray);
                             
                             [mainImageAdsView removeFromSuperview];
                             for(int i=0;i<adsImgsArray.count;i++)
                             {
                                 [mainImageAdsView removeFromSuperview];
                                 mainImageAdsView=nil;
                             }
                             [adsScroll removeFromSuperview];
                             adsScroll=nil;
                             adsScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
                             adsScroll.bounces=NO;
                             adsScroll.userInteractionEnabled = YES;
                             adsScroll.decelerationRate = UIScrollViewDecelerationRateFast;
                             adsScroll.pagingEnabled=YES;
                             adsScroll.backgroundColor = [UIColor clearColor];
                             adsScroll.showsVerticalScrollIndicator = NO;
                             adsScroll.showsHorizontalScrollIndicator=NO;
                             adsScroll.delegate=self;
                             adsScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                             [adsBaseView insertSubview:adsScroll belowSubview:(UILabel *)[self.view viewWithTag:190]];
                             // [adsBaseView addSubview:adsScroll];
                             NSLog(@"imagesArray=%@",adsImgsArray);
                             for(int i=0;i<adsImgsArray.count;i++)
                             {
                                 mainImageAdsView=[[UIImageView alloc]initWithFrame:CGRectMake(adsBaseView.frame.size.width * i, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
                                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                 NSString *documentsDirectory = [paths objectAtIndex:0];
                                 NSLog(@"document directory==%@",documentsDirectory);
                                 NSString *savedGroupImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[adsImgsArray objectAtIndex:i]]];
                                 if([[NSFileManager defaultManager] fileExistsAtPath:savedGroupImagePath] && [NSData dataWithContentsOfFile:savedGroupImagePath])
                                 {
                                     UIImage *image = [UIImage imageWithContentsOfFile:savedGroupImagePath];
                                     [mainImageAdsView setImage:image];
                                     mainImageAdsView.tag=16600+i;
                                     mainImageAdsView.userInteractionEnabled=YES;
                                     mainImageAdsView.contentMode=UIViewContentModeScaleAspectFit;
                                     UITapGestureRecognizer  *adtapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adsTapFunction:)] ;
                                     adtapRecognizer.numberOfTapsRequired = 1;
                                     [mainImageAdsView addGestureRecognizer:adtapRecognizer];
                                     [adsScroll addSubview:mainImageAdsView];
                                 }
                                 
                             }
                             [adsScroll setContentSize:CGSizeMake(adsBaseView.frame.size.width*adsImgsArray.count,adsScroll.frame.size.height)];
                             //                [adsBaseView bringSubviewToFront:(UIButton *)[adsBaseView viewWithTag:6001]];
                             if(adsImgsArray.count > 0)
                             {
                                 [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                                          selector:@selector(autoScrollAds)
                                                                            object:nil];
                                 [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
                                 
                             }
                         }
                          */
        /*
                     });
                 });
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"fsilure reason=%@",error.description);
             }];
        
        */


      }//reachable
    
}

-(void)autoScrollAds
{
    CGFloat width = adsScroll.frame.size.width;
    adIndex = (adsScroll.contentOffset.x + (0.5f * width)) / width;
    
    if(adIndex < adsImgsArray.count - 1)
    {
        adIndex++;
        [adsScroll setContentOffset:CGPointMake(adsBaseView.frame.size.width*adIndex, 0) animated:YES];
    }
    else
    {
        adIndex=0;
        [adsScroll setContentOffset:CGPointMake(adsBaseView.frame.size.width*0, 0) animated:NO];
    }
    CGFloat width2 = adsScroll.frame.size.width;
    adIndex = (adsScroll.contentOffset.x + (0.5f * width2)) / width2;
    
    [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(autoScrollAds)
                                               object:nil];
}
#pragma mark - Ads OnClick Function

-(void)adsTapFunction:(UITapGestureRecognizer *)gesture
{
    int tag=(int)gesture.view.tag;
    NSLog(@"tag=%d",tag);
    int index=tag-16600;
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    if (adsNameArray.count>0)
    {
        NSString *section=[adsNameArray objectAtIndex:index];
        if([section caseInsensitiveCompare:@"LiveScore"] == NSOrderedSame)
        {
            //Live score
            [self navigateToLiveScoreViewController];
        }
        else if ([section caseInsensitiveCompare:@"UserStats"] == NSOrderedSame)
        {
            //User Stats
             [self navigateToXBProViewController];
        }
        else if ([section caseInsensitiveCompare:@"GoBowling"] == NSOrderedSame)
        {
            //Go Bowling
            [self goBowlingFunction];
        }
        else if ([section caseInsensitiveCompare:@"TellYourFriend"] == NSOrderedSame)
        {
            //Tell a friend
            [self navigateToFriendsViewController];
            
        }
        else
        {
            NSURL *url;
            if(adsJsonDictionary.count > 0)
            {
                url=[NSURL URLWithString:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:index] objectForKey:@"uRL"]];
            }
            else if(adsURLArray.count > 0)
                url=[NSURL URLWithString:[adsURLArray objectAtIndex:index]];
            else
                url=[NSURL URLWithString:@"http://www.xbowling.com"];
            NSLog(@"url=%@",url);

            [self showWebViewForURL:url];
        }
        
    }
    else
    {
        //for the very first time before adsServerCall
        NSURL *url;
        if(adsJsonDictionary.count > 0)
        {
            url=[NSURL URLWithString:[[[adsJsonDictionary objectForKey:@"table"] objectAtIndex:index] objectForKey:@"uRL"]];
        }
        else if(adsURLArray.count > 0)
            url=[NSURL URLWithString:[adsURLArray objectAtIndex:index]];
        else
            url=[NSURL URLWithString:@"https://www.xbowling.com/mobile/welcome.html"];
        NSLog(@"url=%@",url);
         [self showWebViewForURL:url];
       
        
    }
    
}

-(void)dismissWebView
{
    [footerViewForWebview removeFromSuperview];
    footerViewForWebview=nil;
    
    [mainWebView loadHTMLString:@"" baseURL:nil];
    [mainWebView stopLoading];
    [mainWebView setDelegate:nil];
    
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    
     [optionsTable reloadData];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[DataManager shared]removeActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *) portal
{
    [[DataManager shared]removeActivityIndicator];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [self performSelector:@selector(removeIndicator) withObject:nil afterDelay:1.2];
}

-(void)removeIndicator
{
    [[DataManager shared]removeActivityIndicator];
}

#pragma mark - GoBowling Function
-(void)goBowlingFunction
{

//    NSArray *testarr=[NSArray new];
//    NSLog(@"%@",[testarr objectAtIndex:0]);
//     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInChallengeView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kliveScoreUpdate];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInGameHistoryView];
    //To be done in select center viewcontroller
    if (![[NSUserDefaults standardUserDefaults]valueForKey:klaneCheckOutId]) {
//        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
//        [self laneCheckout];
        SelectCenterViewController *centerSelection=[[SelectCenterViewController alloc]init];
        [self.navigationController pushViewController:centerSelection animated:YES];
    }
    else{
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus != NotReachable) {
           
            BowlingViewController *bowlingView=[[BowlingViewController alloc]init];
            [bowlingView createGameViewforCategory:@"MyGame"];
            [self.navigationController pushViewController:bowlingView animated:YES];
        }
        else
        {
//            [[DataManager shared] removeActivityIndicator];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            alert=nil;
        }
    }
}



#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIButton *btn=(UIButton*)[cell.contentView viewWithTag:100+indexPath.row];
        UIImageView *icon=(UIImageView *)[btn viewWithTag:902];
        [icon removeFromSuperview];
        icon=nil;
        UIImageView *arrow=(UIImageView *)[btn viewWithTag:903];
        [arrow removeFromSuperview];
        arrow=nil;
        UIImageView *separator=(UIImageView *)[btn viewWithTag:901];
        [separator removeFromSuperview];
        separator=nil;
        [btn removeFromSuperview];
        btn=nil;
       
    }
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    
    //add
    cell.backgroundColor=[UIColor colorWithRed:48.0/255 green:0.0/255 blue:47.0/255 alpha:0.9];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSLog(@"row height : %f", frame.size.height);
  
    UIButton *goBowlingButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,frame.size.height)];
    NSLog(@"height=%f",cell.contentView.frame.size.height);
//    [goBowlingButton setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
    
    //add
    [goBowlingButton setBackgroundColor:[UIColor colorWithRed:36.0/255 green:8.0/255 blue:39.0/255 alpha:1]];
   
    
    [goBowlingButton setBackgroundColor:[UIColor colorWithRed:48.0/255 green:0.0/255 blue:47.0/255 alpha:1]];
    
    
    
    [goBowlingButton setBackgroundColor:[UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:1]];
    
   // [goBowlingButton setBackgroundColor:[UIColor clearColor]];
   // [goBowlingButton setBackgroundImage:[[DataManager shared]imageWithColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]] forState:UIControlStateHighlighted];
    
    goBowlingButton.userInteractionEnabled=NO;
    goBowlingButton.tag=100+indexPath.row;
    //set attributed title of button
    NSString *string = [titlesArray objectAtIndex:indexPath.row];
    NSRange range = [string rangeOfString:@"\n"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]] range:NSMakeRange(0, range.location)];
    if (screenBounds.size.height == 480)
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range.location)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
    [goBowlingButton setAttributedTitle:attrString forState:UIControlStateNormal];
    goBowlingButton.titleLabel.font=[UIFont systemFontOfSize:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [goBowlingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBowlingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    goBowlingButton.titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:goBowlingButton];
    
    UIImage *iconImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[categoryImagesArray objectAtIndex:indexPath.row*2]]];
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:iconImage.size.width/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:iconImage.size.height/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if (screenBounds.size.height == 480) {
        icon.frame=CGRectMake(12, 15, 35, 35);
    }
    icon.tag=902;
    icon.center = CGPointMake(icon.center.x, goBowlingButton.frame.size.height/2);
    [icon setImage:iconImage];
    [goBowlingButton addSubview:icon];
    
    //make the buttons content appear in the center
    [goBowlingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [goBowlingButton setContentEdgeInsets:UIEdgeInsetsMake(0,icon.frame.size.width+icon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.width], 0, 0)];
    [goBowlingButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
   
    
    if (indexPath.row == 12) {
        //Bowlers Journal
        UIImageView *titleImage=[[UIImageView alloc]init];
        titleImage.frame=CGRectMake(icon.frame.size.width+icon.frame.origin.x+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:619/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [titleImage setImage:[UIImage imageNamed:@"Bowlers_journal.png"]];
        [goBowlingButton addSubview:titleImage];
    }
    if (indexPath.row == 11) {
        //Bowling Music
        UIImageView *titleImage=[[UIImageView alloc]init];
        titleImage.frame=CGRectMake(icon.frame.size.width+icon.frame.origin.x+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:555/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [titleImage setImage:[UIImage imageNamed:@"Bowling_music.png"]];
        [goBowlingButton addSubview:titleImage];

    }
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(goBowlingButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.tag=903;
    arrow.center=CGPointMake(arrow.center.x, goBowlingButton.frame.size.height/2);
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [goBowlingButton addSubview:arrow];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, goBowlingButton.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [goBowlingButton addSubview:separatorLine];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn=(UIButton *)[cell viewWithTag:100+indexPath.row];
    [btn setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
    UIImageView *arrow=(UIImageView *)[btn viewWithTag:903];
    [arrow setImage:[UIImage imageNamed:@"arrow_on.png"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIImage *iconImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[categoryImagesArray objectAtIndex:(indexPath.row*2)+1]]];
    UIImageView *icon=(UIImageView *)[cell viewWithTag:902];
    [icon setImage:iconImage];
    switch (indexPath.row) {
        case 0:
        {
            //Wallet
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            [self performSelector:@selector(navigateToWalletController) withObject:nil afterDelay:0.1];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
            /*
        case 0:
        {
            //WalletCoupon
            WalletCouponViewController *walletCouponVC=[[WalletCouponViewController alloc]init];
            [self.navigationController pushViewController:walletCouponVC animated:YES];
            break;
        }
            */
        case 1:
        {
            //Coupon
            CouponViewController *couponVC=[[CouponViewController alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
            break;
        }
            
        case 2:
        {
            //VIP
            VIPViewController *vIPVC=[[VIPViewController alloc]init];
            [self.navigationController pushViewController:vIPVC animated:YES];
            break;
        }
        case 3:
        {
            //League Standings
            LeagueViewController *leagueVC=[[LeagueViewController alloc]init];
            [self.navigationController pushViewController:leagueVC animated:YES];
            break;
        }

            
        case 4:
        {
            //Go Bowling
            [self goBowlingFunction];
               break;
        }
            
            
            
        case 5:
        {
            //CallUs
            CallUsViewController *callusVC=[[CallUsViewController alloc]init];
            [self.navigationController pushViewController:callusVC animated:YES];
            break;
        }
            

            
            
        case 6:
        {
            // XB Pro
            [self performSelector:@selector(navigateToXBProViewController) withObject:nil afterDelay:0.1];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
            /*
        case 6:
        {
            //XB Pro My Games
            [self performSelector:@selector(navigateToMyGamesController) withObject:nil afterDelay:0.1];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
             */
            
            
            /*
        case 8:
        {
            // Skill Based Gaming
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://xbowling-wp.cloudapp.net/paydemo/index.html"]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
            
        }

            */
        case 7:
        {
            // Live Score
              [self performSelector:@selector(navigateToLiveScoreViewController) withObject:nil afterDelay:0.1];
              [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
            

        case 8:
        {
            //More
            MoreViewController *moreVC=[[MoreViewController alloc]init];
            [self.navigationController pushViewController:moreVC animated:YES];
            break;
        }

            
        case 9:
        {
            //Profile Info Server Call
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            UserProfileController *profileObject=[[UserProfileController alloc]init];
            [self.navigationController pushViewController:profileObject animated:YES];
            [[DataManager shared]removeActivityIndicator];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }

        case 10:
        {
            //Friends
            [self performSelector:@selector(navigateToFriendsViewController) withObject:nil afterDelay:0.1];
              [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 11:
        {
            //Bowling Music
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            NSURL *url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Music?VenueId=15103"];
   //NSURL *url=[NSURL URLWithString:@"https://www.xbowling.com/bowlingmusic/"];
            [self performSelector:@selector(showWebViewForURL:) withObject:url afterDelay:0.1];
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 12:
        { 
            //Bowling Journal
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            NSURL *url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Journal?VenueId=15103"];
         //NSURL *url=[NSURL URLWithString:@"http://www.bowlersjournal.com/?cat=7"];
            [self performSelector:@selector(showWebViewForURL:) withObject:url afterDelay:0.1];
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;

        }
        case 13:
        {
            //Buy Credits
            [self performSelector:@selector(navigateToBuyCreditsViewController) withObject:nil afterDelay:0.1];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }

            
        case 14:
        {
            //Championship
            ChampionshipViewController *championshipVC=[[ChampionshipViewController alloc]init];
            [self.navigationController pushViewController:championshipVC animated:YES];
            break;
        }
            
        case 15:
        {
            //Dynamic
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            NSURL *url=  dynamicurl;
            //=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/home/generic?name=DynamicMenu&VenueId=15103"];
            
           // [NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/home/generic?name=DynamicMenu&VenueId=15103"];
            //NSURL *url=[NSURL URLWithString:@"http://www.bowlersjournal.com/?cat=7"];
            [self performSelector:@selector(showWebViewForURL:) withObject:url afterDelay:0.1];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
            
        }
            
        default:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
    }
}

- (void)navigateToMyGamesController
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
    XBProViewController *xbproView=[[XBProViewController alloc]init];
    [self.navigationController pushViewController:xbproView animated:YES];
    [xbproView showMyGamesSection];
    [[DataManager shared]removeActivityIndicator];
    
}


- (void)showWebViewForURL:(NSURL *)url
{
    [mainWebView removeFromSuperview];
    mainWebView = nil;
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    mainWebView.delegate=self;
    NSLog(@"url=%@",url);
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:requestObj];
    [self.view addSubview:mainWebView];
    
    footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    //    [footerViewForWebview setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    closeButton.frame = CGRectMake(self.view.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.layer.borderWidth=0.2;
    closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
    [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [footerViewForWebview addSubview:closeButton];
    [self.view addSubview:footerViewForWebview];

}

- (void)navigateToWalletController
{
    WalletViewController *walletView=[[WalletViewController alloc]init];
    [walletView createMainWalletView];
    [self.navigationController pushViewController:walletView animated:YES];
}

- (void)navigateToXBProViewController
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
    XBProViewController *xbproView=[[XBProViewController alloc]init];
    [self.navigationController pushViewController:xbproView animated:YES];
    [[DataManager shared]removeActivityIndicator];

}
- (void)navigateToLiveScoreViewController
{
    LiveScoreViewController *liveScoreView=[[LiveScoreViewController alloc]init];
    [self.navigationController pushViewController:liveScoreView animated:YES];
  

}
- (void)navigateToBuyCreditsViewController
{
     [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    BuyCreditsViewController *buyCreditsVC=[[BuyCreditsViewController alloc]init];
     [buyCreditsVC creditsMainViewAddedToBaseView:@"MainMenu"];
    [self.navigationController pushViewController:buyCreditsVC animated:YES];

}

- (void)navigateToFriendsViewController
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    FriendsViewController *friendsVC=[[FriendsViewController alloc]init];
    [self.navigationController pushViewController:friendsVC animated:YES];
    [[DataManager shared]removeActivityIndicator];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn=(UIButton *)[cell viewWithTag:100+indexPath.row];
    [btn setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2]];
    UIImageView *arrow=(UIImageView *)[btn viewWithTag:903];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    
    UIImage *iconImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[categoryImagesArray objectAtIndex:(indexPath.row*2)]]];
    UIImageView *icon=(UIImageView *)[cell viewWithTag:902];
    [icon setImage:iconImage];
}

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            backgroundView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, backgroundView.frame.size.width, backgroundView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], backgroundView.frame.size.width, backgroundView.frame.size.height)];
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
            backgroundView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
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

- (void)viewWillDisappear:(BOOL)animated
{
//    [leftMenu removeFromSuperview];
//    leftMenu=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    BOOL isOrientationLandscape = isCampusLandsc;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%ld",(long)touch.view.tag);
}

@end
