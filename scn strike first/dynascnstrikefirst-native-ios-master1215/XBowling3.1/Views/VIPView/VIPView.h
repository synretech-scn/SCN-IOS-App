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
@protocol vIPDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForVIP:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface VIPView : UIView
{
    id<vIPDelegate> delegate;
}
@property (retain) id<vIPDelegate>  delegate;
@end
