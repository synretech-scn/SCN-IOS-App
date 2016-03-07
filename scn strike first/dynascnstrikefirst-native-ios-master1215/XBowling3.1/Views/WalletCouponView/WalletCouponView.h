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
@protocol walletCouponDelegate <NSObject>;
- (void)removeView;
- (void)showLeaderboardForWalletCoupon:(NSString *)name;
- (void)showMainMenu:(UIButton *)sender;
@end
@interface WalletCouponView : UIView
{
    id<walletCouponDelegate> delegate;
}
@property (retain) id<walletCouponDelegate>  delegate;
@end
