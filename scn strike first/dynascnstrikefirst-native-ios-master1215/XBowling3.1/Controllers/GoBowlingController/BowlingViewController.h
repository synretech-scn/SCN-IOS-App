//
//  BowlingViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 11/24/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BowlingView.h"
#import "ASIFormDataRequest.h"
#import "LeftSlideMenu.h"
#import "RightSlideMenu.h"
#import "CoachViewController.h"
#import "LeaderboardViewController.h"
#import "ChallengesViewController.h"
#import "ChallengesFrameView.h"
#import "TagsController.h"
#import "CustomActionSheet.h"
#import "SelectUserStatsPropertiesView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface BowlingViewController : UIViewController<BowlingViewDelegate,LeftMenuDelgate,RightMenuDelgate,ChallengesDelegate,ChallengesGameDelegate,serverCallProtocol,customActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FBSDKSharingDelegate>
@property(retain) NSOperationQueue *queue;
- (void)liveScoreData:(NSDictionary *)liveScoreDict;
- (void)createGameViewforCategory:(NSString *)category;
- (void)urlForh2hPostedChallenger:(NSString *)url;
- (void)historyGameData:(NSDictionary *)historyGameDictionary;
@end
