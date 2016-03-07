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
@protocol callUsDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForCallUs:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface CallUsView : UIView
{
    id<callUsDelegate> delegate;
}
@property (retain) id<callUsDelegate>  delegate;
@end
