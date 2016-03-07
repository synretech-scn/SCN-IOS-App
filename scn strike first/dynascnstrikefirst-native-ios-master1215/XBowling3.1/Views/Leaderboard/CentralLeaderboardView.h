//
//  CentralLeaderboardView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/21/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "SelectCenterView.h"

@protocol centerLeaderboardDelegate <NSObject>
- (void)leaderboardBackFunction;
- (void)displayLeaderboard;
@end
@interface CentralLeaderboardView : UIView
{
    id<centerLeaderboardDelegate> delegate;
}
@property (retain) id<centerLeaderboardDelegate>  delegate;
- (void)createLeaderboardViewWithCenterView:(SelectCenterView *)selectCenterView;
@end
