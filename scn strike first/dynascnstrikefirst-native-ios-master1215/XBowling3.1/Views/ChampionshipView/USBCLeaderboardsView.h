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
@protocol usbcLeaderboardsDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForChampionship:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface USBCLeaderboardsView : UIView
{
    id<usbcLeaderboardsDelegate> delegate;
}
@property (retain) id<usbcLeaderboardsDelegate>  delegate;
@end
