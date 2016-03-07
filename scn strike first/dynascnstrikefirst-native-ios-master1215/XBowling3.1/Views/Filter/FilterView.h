//
//  FilterView.h
//  XBowling3.1
//
//  Created by Shreya on 23/01/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "DropDownImageView.h"
#import "SelectCenterView.h"
#import "CustomActionSheet.h"

@protocol FilterDelegate <NSObject>
- (void)removeFilterView;
- (void)filterDoneFunction:(NSMutableArray *)filterValuesDict;
@optional
- (void)resetFilters;
@end

@interface FilterView : UIView<customActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    id<FilterDelegate> delegate;
}
@property(retain) id<FilterDelegate> delegate;
- (void)createView:(NSArray *)filterHeadersArray filterInitialValues:(NSArray *)valuesArray centerView:(SelectCenterView *)locationView forSuperView:(NSString *)homeView;
- (void)updateFilterView:(int)changeInHeight;
- (void)filterDropdownInfo:(NSMutableArray *)dropdownArray;
- (void)resetButtonFunction;
- (void)updateFiltersInteractionForSection:(NSString *)section;
@end
