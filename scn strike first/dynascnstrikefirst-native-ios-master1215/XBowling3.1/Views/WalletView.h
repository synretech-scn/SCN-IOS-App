//
//  WalletView.h
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@protocol walletDelegate <NSObject>;
- (void)showMainMenu:(UIButton *)sender;
- (void)showAddCenterView;
- (void)showPointsViewForCenter:(NSDictionary *)selectedCenterDictionary;
- (void)showRewardPointsView;
//add
- (void)addSelectedCenter;
//add
- (NSDictionary *)getPointsForVenue:(NSUInteger)venueId;
@end


@interface WalletView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<walletDelegate> delegate;
}
@property (retain) id<walletDelegate>  delegate;
- (void)createWalletView:(NSArray *)walletCentersArray forXBowlingPoints:(NSDictionary *)pointsDictionary;
- (void)reloadListWithCenters:(NSMutableArray *)updatedCentersArray andRewardPoints:(NSDictionary *)pointsDictionary;
- (void)reloadList;
@end
