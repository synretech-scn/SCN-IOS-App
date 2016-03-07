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
@protocol moreDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForMore:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface MoreView : UIView
{
    id<moreDelegate> delegate;
}
@property (retain) id<moreDelegate>  delegate;
@end
