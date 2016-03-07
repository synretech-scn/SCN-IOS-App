//
//  PointsView.h
//  Xbowling
//
//  Created by Click Labs on 6/16/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@protocol pointsDelegate <NSObject>;
- (void)removePointsView;
- (void)redeemOrEarnPointsFunction:(NSString *)status points:(int)points venue:(NSUInteger)venueId;
@end

@interface PointsView : UIView
{
    id<pointsDelegate> delegate;
}
@property (retain) id<pointsDelegate>  delegate;
- (void)createViewForCenter:(NSString *)centerName venueId:(NSUInteger)venue pointsArray:(NSArray *)pointsArray;
- (void)updatePoints:(NSArray *)pointsArray;
@end
