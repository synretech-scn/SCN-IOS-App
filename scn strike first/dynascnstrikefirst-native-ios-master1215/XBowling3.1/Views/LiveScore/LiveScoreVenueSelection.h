//
//  LiveScoreVenueSelection.h
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCenterView.h"
#import "DataManager.h"
#import "Keys.h"

@protocol LiveScoreCenterDelegate <NSObject>
- (void)getLiveScoreforSelectedCenter:(NSString *)venueId;
- (void)showMainMenu:(UIButton *)sender;
- (void)showLeaderboard:(int)leaderboardType;

@end
@interface LiveScoreVenueSelection : UIView
{
    id<LiveScoreCenterDelegate> delegate;
}
@property(retain) id<LiveScoreCenterDelegate> delegate;
- (void)createViewWithCenterView:(SelectCenterView *)selectCenterView;
- (void)updateVenueforLiveCenter:(NSString *)venueId country:(NSString *)country state:(NSString *)state center:(NSString *)center;
@end
