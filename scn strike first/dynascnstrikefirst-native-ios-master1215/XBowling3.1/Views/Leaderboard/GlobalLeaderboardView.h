//
//  GlobalLeaderboardView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/21/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol globalLeaderboardDelegate <NSObject>;
- (void)showPalyerProfile:(NSString *)userid;
- (void)removeGlobalLeaderboard;
- (void)showFilterView;
@end

@interface GlobalLeaderboardView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<globalLeaderboardDelegate> delegate;
}
@property (retain) id<globalLeaderboardDelegate>  delegate;
- (void)createLeaderboardView:(NSDictionary *)leaderboardDictionary leaderboardCategory:(NSString *)category leaderboardType:(int)type centerName:(NSString *)center;
@end
