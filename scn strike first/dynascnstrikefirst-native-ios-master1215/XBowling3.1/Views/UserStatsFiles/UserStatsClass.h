//
//  userStatsView.h
//  XBowling 3.0
//
//  Created by Click Labs on 6/26/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "CustomActionSheet.h"
#import "Keys.h"
#import "DataManager.h"
#import "ExpandableTableView.h"
#import "ComparisonView.h"
#import "MyGamesView.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>


@protocol userStatsDelegate <NSObject>

- (void)removeUserStats;
- (void)startTrialFunction;
- (void)showMainMenu:(UIButton *)sender;
- (void)showFilterViewforSection:(NSString *)section;
- (void)showGraphsView;
- (MyGamesView *)showMyGames:(int)yCoordinate;
- (void)showBuyPackageView;
- (void)shareOnFacebook;
@end
@interface UserStatsClass : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,customActionSheetDelegate,ExpandableTableDelegate,ComparisonDelegate>
{
    id<userStatsDelegate> delegate;
}
@property (retain) id<userStatsDelegate> delegate;
@property (nonatomic, strong) NSArray *patternNamesArray;
@property (nonatomic, strong) NSArray *patternLengthArray;
@property (nonatomic, strong) NSArray *ballTypeNamesArray;
@property (nonatomic, strong) NSArray *gameTypeNamesArray;
@property (nonatomic) int subscriptionCount;

- (void)myStats;
- (void)applyFilters;
- (void)resetFiltersFunction;
- (void)graphViewRemoved;
- (void)showMyGames;
@end
