//
//  LeftSlideMenu.m
//  XBowling3.1
//
//  Created by Click Labs on 1/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LeftSlideMenu.h"
#import "ViewController.h"
#import "BowlingViewController.h"
#import "SelectCenterViewController.h"
#import "LiveScoreViewController.h"
#import "NotificationController.h"
#import "HelpViewController.h"
#import "WalletViewController.h"

#import "CallUsViewController.h"
#import "LeagueViewController.h"
#import "WalletCouponViewController.h"

#import "VIPViewController.h"
#import "MoreViewController.h"
#import "CouponViewController.h"


@implementation LeftSlideMenu
{
    NSArray *sectionsArray;
    ViewController *mainVC;
    BowlingViewController *bowlingVC;
    SelectCenterViewController *selectCenterVC;
    LiveScoreViewController *liveScoreVC;
    XBProViewController *xbproVC;
    HelpViewController *helpVC;
    
    
    CallUsViewController *callUsVC;
    LeagueViewController *leagueVC;
    WalletCouponViewController *walletCouponVC;
    
    MoreViewController *moreVC;
    VIPViewController *vIPVC;
    CouponViewController *couponVC;
    
    WalletViewController *walletVC;
    
    UITableView *menuTable;
}
@synthesize menuDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

#pragma mark - Reload Menu Table here

-(void)reloadMenuTable {
    
    [menuTable reloadData];
}

- (void)createMenuView
{
    mainVC=[[ViewController alloc]init];
    bowlingVC=[[BowlingViewController alloc]init];
    selectCenterVC=[[SelectCenterViewController alloc]init];
    liveScoreVC=[[LiveScoreViewController alloc]init];
    xbproVC=[[XBProViewController alloc]init];
    helpVC=[[HelpViewController alloc]init];
    
    
    callUsVC=[[CallUsViewController alloc]init];
    walletCouponVC=[[WalletCouponViewController alloc]init];
    leagueVC=[[LeagueViewController alloc]init];
    
    moreVC=[[MoreViewController alloc]init];
    couponVC=[[CouponViewController alloc]init];
    vIPVC=[[VIPViewController alloc]init];
    
    walletVC=[[WalletViewController alloc]init];
    
    [self setBackgroundColor:[UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0]];
    
    menuTable=[[UITableView alloc]init];
    menuTable.frame=CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:78/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1553/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    NSLog(@"Menu Table frame=%f %f %f %f",menuTable.frame.size.height,menuTable.frame.size.width,menuTable.frame.origin.x,menuTable.frame.origin.y);
    menuTable.delegate=self;
    menuTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    menuTable.dataSource=self;
    menuTable.scrollEnabled=NO;
    menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [menuTable setBackgroundColor:[UIColor clearColor]];
    [self addSubview:menuTable];
    
    //sectionsArray=[[NSArray alloc]initWithObjects:@"Home",@"Go Bowling",@"XB Pro Stats",@"Live Scores",@"XBowling Profile",@"Notifications",@"Help",@"Logout",nil];
    
    
       sectionsArray=[[NSArray alloc]initWithObjects:@"Home",@"SCN Strike First Loyalty and Rewards",@"Special Promotions",@"Go XBowling",@"XB Pro Stats",@"Player Profile",@"Notifications",@"Help",@"Logout",nil];
    
}


#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    NSLog(@" display");
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *line=(UIView*)[cell.contentView viewWithTag:901];
        [line removeFromSuperview];
        line=nil;
    }
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    NSLog(@"row height : %f", frame.size.height);
    NSString *string = [sectionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text=string;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.highlightedTextColor=[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:1.0];
    if(indexPath.row == 0)
    {
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    }
    else if (indexPath.row == sectionsArray.count -1)
    {
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        cell.textLabel.textColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];
        cell.textLabel.highlightedTextColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];
    }
    else
    {
        cell.textLabel.font= [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    }
    if([[sectionsArray objectAtIndex:indexPath.row]isEqualToString:@"Notifications"])
    {
        
        UILabel *unreadLabel=[[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-45,frame.size.height/2-30/2,30 ,30)];
        [unreadLabel setBackgroundColor:[UIColor clearColor]];
        unreadLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]];
        unreadLabel.backgroundColor=[UIColor redColor];
        unreadLabel.layer.cornerRadius=unreadLabel.frame.size.width/2;
        unreadLabel.layer.masksToBounds=YES;
        unreadLabel.textColor=[UIColor whiteColor];
        unreadLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        unreadLabel.textAlignment=NSTextAlignmentCenter;
        unreadLabel.numberOfLines=2;
        unreadLabel.hidden=false;
        unreadLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        unreadLabel.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:unreadLabel];
        NSLog(@"currentUnreadAllNotification %@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]);
        
        if([[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]integerValue]<=0)
        {
            unreadLabel.hidden=true;
        }
        else {
            unreadLabel.hidden=false;
        }
    }
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cell.contentView addSubview:separatorLine];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"will display cell=%@",cell);
    
    //Highlight the open section
    switch (indexPath.row) {
        case 0:
        {
            if ([_rootViewController isMemberOfClass:[mainVC class]])
            {
                NSLog(@"cell=%@",cell);
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [cell.selectedBackgroundView removeFromSuperview];
                cell.selectedBackgroundView=nil;
                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
                
            }
            break;
        }
        case 1:
        {
            if ([_rootViewController isMemberOfClass:[bowlingVC class]])
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [cell.selectedBackgroundView removeFromSuperview];
                cell.selectedBackgroundView=nil;
                cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
            }
        }
        default:
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sectionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedBackgroundView removeFromSuperview];
    cell.selectedBackgroundView=nil;
    cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
    switch (indexPath.row) {
        case 0:
        {
            //Home
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            NSLog(@"class = %@",[_rootViewController class]);
            if (![_rootViewController isMemberOfClass:[mainVC class]]) {
                [[_rootViewController navigationController]pushViewController:mainVC animated:YES];
            }
            [menuDelegate dismissMenu];
            break;
        }
        case 3:
        {
            //GoBowling
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showBowlingView"];
            NSLog(@"class = %@",[_rootViewController class]);
            if (![[NSUserDefaults standardUserDefaults]valueForKey:klaneCheckOutId]) {
                Reachability *reach = [Reachability reachabilityForInternetConnection];
                NetworkStatus netStatus = [reach currentReachabilityStatus];
                if (netStatus != NotReachable) {
                    [self performSelector:@selector(navigateToCenterSelectionView) withObject:nil afterDelay:0.0];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    alert=nil;
                }
            }
            else{
                if (![_rootViewController isMemberOfClass:[bowlingVC class]]) {
                    Reachability *reach = [Reachability reachabilityForInternetConnection];
                    NetworkStatus netStatus = [reach currentReachabilityStatus];
                    if (netStatus != NotReachable) {
                        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                        [self performSelector:@selector(navigateToBowlingView) withObject:nil afterDelay:0.0];
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        alert=nil;
                    }
                }
                if ([_rootViewController isMemberOfClass:[selectCenterVC class]]) {
                    
                }
                
            }
            [menuDelegate dismissMenu];
            break;
        }
        
            
        case 1:
        {
            //Wallet
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            NSLog(@"class = %@",[_rootViewController class]);
            
            if (![_rootViewController isMemberOfClass:[xbproVC class]]) {
                [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                   [self performSelector:@selector(navigateToWalletController) withObject:nil afterDelay:0.1];
            }
            [menuDelegate dismissMenu];
            
            /*
            if (![_rootViewController isMemberOfClass:[walletVC class]]) {
                [[_rootViewController navigationController]pushViewController:walletVC animated:YES];
            }
            [menuDelegate dismissMenu];
             */
            break;
        }
                /*
            
        case 2:
        {
            //WalletCoupon
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            NSLog(@"class = %@",[_rootViewController class]);
            if (![_rootViewController isMemberOfClass:[walletCouponVC class]]) {
                [[_rootViewController navigationController]pushViewController:walletCouponVC animated:YES];
            }
            [menuDelegate dismissMenu];
            break;
        }
             */
            
        case 2:
        {
            //WalletCoupon
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            NSLog(@"class = %@",[_rootViewController class]);
            if (![_rootViewController isMemberOfClass:[couponVC class]]) {
                [[_rootViewController navigationController]pushViewController:couponVC animated:YES];
            }
            [menuDelegate dismissMenu];
            break;
        }
            /*
             
             case 4:
             {
             //VIP
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
             NSLog(@"class = %@",[_rootViewController class]);
             if (![_rootViewController isMemberOfClass:[vIPVC class]]) {
             [[_rootViewController navigationController]pushViewController:vIPVC animated:YES];
             }
             [menuDelegate dismissMenu];
             break;
             }
             
             
             
             
             case 5:
             {
             //League Standings
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
             NSLog(@"class = %@",[_rootViewController class]);
             if (![_rootViewController isMemberOfClass:[leagueVC class]]) {
             [[_rootViewController navigationController]pushViewController:leagueVC animated:YES];
             }
             [menuDelegate dismissMenu];
             break;
             }
             */

            
        case 4:
        {
            //XB Pro
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];

            if (![_rootViewController isMemberOfClass:[xbproVC class]]) {
                [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
                [self performSelector:@selector(navigateToXBProView) withObject:nil afterDelay:0.2];
            }
            [menuDelegate dismissMenu];
            break;
        }
/*
        case 3:
        {
            //Live Score
            [self performSelector:@selector(navigateToLiveScoreView) withObject:nil afterDelay:0.1];
            break;
        }
            
    */
            /*
             case 7:
             {
             //Call us
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
             NSLog(@"class = %@",[_rootViewController class]);
             if (![_rootViewController isMemberOfClass:[callUsVC class]]) {
             [[_rootViewController navigationController]pushViewController:callUsVC animated:YES];
             }
             [menuDelegate dismissMenu];
             break;
             }
             
             
             case 8:
             {
             //More
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
             NSLog(@"class = %@",[_rootViewController class]);
             if (![_rootViewController isMemberOfClass:[moreVC class]]) {
             [[_rootViewController navigationController]pushViewController:moreVC animated:YES];
             }
             [menuDelegate dismissMenu];
             break;
             }
             
             
             case 9:
             {
             //Skill Based Gaming
             
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://xbowling-wp.cloudapp.net/paydemo/index.html"]];
             [menuDelegate dismissMenu];
             break;
             }
             
             case 10:
             {
             //Live Score
             [self performSelector:@selector(navigateToLiveScoreView) withObject:nil afterDelay:0.1];
             break;
             }
             
             */

            
            
        case 5:
        {
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            UserProfileController *profileObject=[[UserProfileController alloc]init];
            [[_rootViewController navigationController] pushViewController:profileObject animated:YES];
            [[DataManager shared]removeActivityIndicator];
            break;
        }
        case 6:
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            NotificationController *notification=[[NotificationController alloc]init];
            [[_rootViewController navigationController] pushViewController:notification animated:YES];
            [menuDelegate dismissMenu];
            
            break;
        }
        case 7:
        {
            //Help
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
            if (![_rootViewController isMemberOfClass:[helpVC class]]) {
                [[_rootViewController navigationController]pushViewController:helpVC animated:YES];
            }
            [menuDelegate dismissMenu];
            break;
            
        }
        case 8:
        {
//           cell.contentView.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
            [cell setSelectedBackgroundView:bgColorView];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];

            UIAlertView *logoutalert= [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Do you want to logout?"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil] ;
            logoutalert.tag=12121;
            [logoutalert show];
            
            break;
        }
            
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor clearColor];
    //    cell.textLabel.textColor=[UIColor colorWithRed:255.0/255 green:56.0/255 blue:35.0/255 alpha:1.0];
    
}
- (void)navigateToLiveScoreView
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showBowlingView"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    if (![_rootViewController isMemberOfClass:[liveScoreVC class]]) {
        [[_rootViewController navigationController]pushViewController:liveScoreVC animated:YES];
    }
    [menuDelegate dismissMenu];
}
- (void)navigateToCenterSelectionView
{
    [[_rootViewController navigationController]pushViewController:selectCenterVC animated:YES];
}
- (void)navigateToBowlingView
{
//     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInChallengeView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kliveScoreUpdate];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kInGameHistoryView];
    [bowlingVC createGameViewforCategory:@"MyGame"];
    [[_rootViewController navigationController]pushViewController:bowlingVC animated:YES];
}

- (void)navigateToXBProView
{
    [[_rootViewController navigationController] pushViewController:xbproVC animated:YES];
}

//add

- (void)navigateToWalletController
{
    WalletViewController *walletView=[[WalletViewController alloc]init];
    [walletView createMainWalletView];
    [[_rootViewController navigationController] pushViewController:walletView animated:YES];
}

#pragma mark - Logout Function

-(void)logoutApiCall
{
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"EnterInCenter/Logout" contentType:@"" httpMethod:@"POST"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    [[DataManager shared]removeActivityIndicator];
    
    if([[json objectForKey:@"responseStatusCode"]integerValue]==200)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserAccessToken];
        [[_rootViewController navigationController] popToRootViewControllerAnimated:YES];
        
        NSString *deviceToken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kDeviceToken]];
        [self resetDefaults];
        [[DataManager shared] removeActivityIndicator];
        [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:kDeviceToken];
    }
}

- (void)resetDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"nsuserDefault=%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

#pragma mark - Alert Button Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag==12121)
    {
        if (buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            
            
            [self performSelector:@selector(logoutApiCall) withObject:nil afterDelay:0.2];
        }
        else{
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            
        }
    }
    else
    {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
}

@end
