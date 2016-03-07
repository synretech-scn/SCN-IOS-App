//
//  LiveScoreViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "SelectCenterView.h"
#import "SelectCenterModel.h"
#import "LiveScoreVenueModel.h"
#import "LiveScoreVenueSelection.h"
#import "LeftSlideMenu.h"
#import "BowlingViewController.h"
#import "LiveScoreLanesView.h"
#import "LeaderboardViewController.h"

@interface LiveScoreViewController : UIViewController<CenterSelectionDelegate,LiveScoreCenterDelegate,LeftMenuDelgate,LiveScoreLanesDelegate>

@end
