//
//  ViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 11/21/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideMenu.h"
#import "UserProfileController.h"
#import "ServerCalls.h"
#import "XBProViewController.h"
#import "NSData+Base64.h"
#import "FriendsViewController.h"
#import "ChampionshipViewController.h"
#import "BuyCreditsViewController.h"
#import "NotificationController.h"
#import "WalletViewController.h"

#import "CallUsViewController.h"
#import "LeagueViewController.h"
#import "WalletCouponViewController.h"
#import "MoreViewController.h"
#import "CouponViewController.h"
#import "VIPViewController.h"


@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LeftMenuDelgate,serverCallProtocol,UIWebViewDelegate,ASIHTTPRequestDelegate,UIWebViewDelegate>


@end

