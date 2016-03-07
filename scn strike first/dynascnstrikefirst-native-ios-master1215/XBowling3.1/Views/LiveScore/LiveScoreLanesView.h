//
//  LiveScoreLanesView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/14/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableTableView.h"
#import "Reachability.h"
@protocol LiveScoreLanesDelegate <NSObject>
- (void)showGameplayForPlayer:(NSString *)rowkey laneID:(NSString *)laneID venueID:(NSString *)venueID;
- (void)liveScoreBackButtonFunction;
@end

@interface LiveScoreLanesView : UIView<UITableViewDataSource,UITableViewDelegate,ExpandableTableDelegate>
{
    id<LiveScoreLanesDelegate> liveScoreGameplayDelegate;
}
@property (retain)  id<LiveScoreLanesDelegate> liveScoreGameplayDelegate;
- (void)createViewwithLanesInformation:(NSArray *)lanesArray centerInformation:(NSDictionary*)centerDetailsDict;
- (void)updateViewWithLanesInformation:(NSArray *)lanesArray;
@end
