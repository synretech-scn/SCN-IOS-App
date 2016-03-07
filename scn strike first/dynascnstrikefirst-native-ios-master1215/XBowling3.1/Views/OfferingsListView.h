//
//  OfferingsListView.h
//  Xbowling
//
//  Created by Click Labs on 6/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "UIImageView+AFNetworking.h"
#import "ServerCalls.h"

@protocol offeringsDelegate <NSObject>;
- (void)removeOfferingsViewForCategory:(NSString *)category;
- (void)submitSelection:(NSDictionary *)selectedItemDictionary forCategory:(NSString *)category;
- (void)showRedemptionImage;
- (void)showItemsForRewardPointCategory:(NSString *)category;
- (void)redeemRewardPointsItem:(NSDictionary *)itemDictionary;

//add
- (NSDictionary *)getPointsForVenue:(NSUInteger)venueId;

@end
@interface OfferingsListView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    id<offeringsDelegate> delegate;
}
@property (retain) id<offeringsDelegate>  delegate;
- (void)reloadTableForCategory:(NSString *)newCategory withOfferings:(NSArray *)itemsArray;
- (void)createViewForList:(NSArray *)offeringsList forCategory:(NSString *)redeemOrEarnPoints userAvailablePoints:(int)points;
@end
