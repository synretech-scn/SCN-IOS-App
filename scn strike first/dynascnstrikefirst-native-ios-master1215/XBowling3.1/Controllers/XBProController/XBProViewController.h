//
//  XBProViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 3/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStatsClass.h"
#import "LeftSlideMenu.h"
#import "FilterView.h"
#import "SelectCenterView.h"
#import "SelectCenterModel.h"
#import "GraphsViewController.h"
#import "MyGamesView.h"
#import "BowlingViewController.h"
#import "BuyXBProPackage.h"
#import "InAppManager.h"
#import "SVProgressHUD.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface XBProViewController : UIViewController<userStatsDelegate,LeftMenuDelgate,FilterDelegate,CenterSelectionDelegate,myGamesDelegate,BuyPackageDelegate,InAppManagerDelegate,FBSDKSharingDelegate>

- (void)showMyGamesSection;
@end
