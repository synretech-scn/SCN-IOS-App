//
//  BuyXBProPackage.h
//  XBowling3.1
//
//  Created by Click Labs on 3/25/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"

@protocol BuyPackageDelegate<NSObject>
- (void)removeBuyPackageView;
- (void)inAppPurchaseFunction:(int)selectedSubscriptionPackage;
@end
@interface BuyXBProPackage : UIView
{
    id<BuyPackageDelegate> delegate;
}
@property (retain) id<BuyPackageDelegate>  delegate;
- (void)buyPackageData:(NSDictionary *)plansListDictioanry;
@end
