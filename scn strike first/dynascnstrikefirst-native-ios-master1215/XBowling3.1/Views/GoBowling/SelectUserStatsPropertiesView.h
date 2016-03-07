//
//  SelectUserStatsPropertiesView.h
//  XBowling3.1
//
//  Created by Click Labs on 3/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "DropDownImageView.h"
#import "CustomActionSheet.h"

@protocol EquipmentDetailsDelegate <NSObject>
- (void)removeEquipmentDetails;
- (void)skipEquipmentDetails;
- (void)setEquipmentDetails;
@end
@interface SelectUserStatsPropertiesView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,customActionSheetDelegate>
{
    id<EquipmentDetailsDelegate> delegate;
}
@property (retain) id<EquipmentDetailsDelegate> delegate;
- (void)createMainView;
- (void)equipmentDropdownInfo:(NSDictionary *)dropdownDictionary;
@end
