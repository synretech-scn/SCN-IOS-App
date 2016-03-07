//
//  FriendsViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 3/27/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideMenu.h"
#import "AddFriendsView.h"
#import "InviteFriendsView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FriendsViewController : UIViewController<LeftMenuDelgate,addFriendsDelegate,FBSDKSharingDelegate,InviteFriendsDelegate>

@end
