//
//  VenueSelectionView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "SelectCenterView.h"

@protocol VenueDelegate<NSObject>
- (void)showMainMenu:(UIButton *)sender;
- (void)showUserStatsView:(NSDictionary *)contentDictionary;
@optional
- (void)bowlNow;
- (void)removeVenueView;

@end


@interface VenueSelectionView : UIView<UITextFieldDelegate>
{
        id<VenueDelegate> venueDelegate;
}
@property (retain) id<VenueDelegate>  venueDelegate;
- (void)createMainViewWithCenterView:(SelectCenterView *)selectCenterView;
- (void)updateVenue:(int)laneRange country:(NSString *)country state:(NSString *)state center:(NSString *)center;
@end
