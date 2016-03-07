//
//  CouponViewController.m
//  XBowling3.1
//
//  Created by Shreya on 03/04/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CouponViewController.h"
///
 //#import "ViewController.h"

@interface CouponViewController ()
{
    CouponView *mainView;
    UIWebView *mainWebView;
    UIView *footerViewForWebview;
    LeftSlideMenu *leftMenu;
    
    // ViewController *mainVC;
    
}
@end

@implementation CouponViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    [self supportedInterfaceOrientations:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 

    mainView=[[CouponView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainView.delegate=self;
    [self.view addSubview:mainView];
    
    //Left side Menu
    leftMenu=[[LeftSlideMenu alloc]init];
    leftMenu.frame=CGRectMake(-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], screenBounds.size.height);
    leftMenu.rootViewController=self;
    leftMenu.backgroundColor=[UIColor redColor];
    leftMenu.menuDelegate=self;
    leftMenu.hidden=YES;
    [self.view addSubview:leftMenu];
    [leftMenu createMenuView];

    
 
}

#pragma mark - USBC Leaderboard Delegate Methods
- (void)removeView
{
    [mainView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLeaderboardForCoupon:(NSString *)name
{
    if(mainWebView)
    {
        [mainWebView removeFromSuperview];
        mainWebView.delegate=nil;
        mainWebView=nil;
    }
    
    /*
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,65,self.view.frame.size.width,self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    //add
        mainWebView.backgroundColor=[UIColor colorWithRed:35/255.0 green:21.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    mainWebView.delegate=self;
    NSURL *url;
    if ([name isEqualToString:@"OC"]) {
        url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
    }
    else if([name isEqualToString:@"WC"]){
        url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
        
    }
    else if([name isEqualToString:@"ITC"]){
        url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
    }
    else if([name isEqualToString:@"Back"]){
        url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
    
        */
        
        
        NSString *siteurl = [NSString stringWithFormat:@"http://xbowling-mobile.trafficmanager.net/Coupon/Index?VenueId=15103&Token="];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        // token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"&ApiKey=%@",APIKey];
        NSString *userIDKey =[NSString stringWithFormat:@"&UserId=%@",  [[NSUserDefaults standardUserDefaults]valueForKey:kuserId]  ];
        NSLog(@"token=%@",token);
        NSString *enquiryurl =  [[[siteurl stringByAppendingString:token] stringByAppendingString:apiKey] stringByAppendingString:userIDKey] ;
        
        
        NSLog(@"enquiryurl=%@",enquiryurl);
        
        
        mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,65,self.view.frame.size.width,self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
        
        //add
        mainWebView.backgroundColor=[UIColor colorWithRed:35/255.0 green:21.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    
    
    //add
    
    mainWebView.backgroundColor = [UIColor clearColor];
    mainWebView.opaque = NO;
    [mainWebView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    
        mainWebView.delegate=self;
        NSURL *url;
        if ([name isEqualToString:@"OC"]) {
            url=[NSURL URLWithString: enquiryurl];
            //   url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
        }
        else if([name isEqualToString:@"WC"]){
            url=[NSURL URLWithString: enquiryurl];
            //   url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
            
        }
        else if([name isEqualToString:@"ITC"]){
            url=[NSURL URLWithString: enquiryurl];
            //   url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
        }
        else if([name isEqualToString:@"Back"]){
            url=[NSURL URLWithString: enquiryurl];
            //   url=[NSURL URLWithString:@"http://xbowling-dev.cloudapp.net/Coupon/Index?VenueId=15103&amp;Token=a&amp;ApiKey=b&amp;UserId=1"];
            
        /*
        //Home
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
        NSLog(@"class = %@",[_rootViewController class]);
        if (![_rootViewController isMemberOfClass:[mainVC class]]) {
            [[_rootViewController navigationController]pushViewController:mainVC animated:YES];
        }
        [menuDelegate dismissMenu];
        */
       
        // [[ leftMenu.rootViewController navigationController]pushViewController:mainVC animated:YES];
        [mainView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
        
        //[self.navigationController pushViewController:mainVC animated:YES];
        //[self.navigationController pushViewController:mainVC animated:YES];
        
    }
    
    
    NSLog(@"url=%@",url);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:requestObj];
    [self.view addSubview:mainWebView];
    
    footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.view.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
//    [footerViewForWebview setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Back" forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    closeButton.frame = CGRectMake(self.view.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.layer.borderWidth=0.2;
    closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
    [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [footerViewForWebview addSubview:closeButton];
    
    [self.view addSubview:footerViewForWebview];

}

#pragma mark - WebView Methods
-(void)dismissWebView
{
    
    [footerViewForWebview removeFromSuperview];
    footerViewForWebview=nil;
    
    [mainWebView loadHTMLString:@"" baseURL:nil];
    [mainWebView stopLoading];
    [mainWebView setDelegate:nil];
    
    
    
    
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    
    
    [mainView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
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
      [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
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

#pragma mark - Main Menu
- (void)showMainMenu:(UIButton *)sender
{
    if([leftMenu isHidden] == YES)
    {
        leftMenu.hidden=NO;
        [self.view bringSubviewToFront:leftMenu];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            mainView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, mainView.frame.size.width, mainView.frame.size.height);
            
        } completion:^(BOOL finished){
            UIView *mainScreenCoverView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1050/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120 currentSuperviewDeviceSize:screenBounds.size.height], mainView.frame.size.width, mainView.frame.size.height)];
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
            mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
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


@end
