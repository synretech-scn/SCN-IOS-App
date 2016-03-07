//
//  USBCLeaderboardsView.h
//  XBowling3.1
//
//  Created by Shreya on 03/04/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
@protocol leagueDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForLeague:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface LeagueView : UIView
{
    id<leagueDelegate> delegate;
}
@property (retain) id<leagueDelegate>  delegate;
@end
