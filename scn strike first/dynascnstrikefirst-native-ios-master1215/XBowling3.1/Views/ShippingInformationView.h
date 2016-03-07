//
//  ShippingInformationView.h
//  Xbowling
//
//  Created by Click Labs on 8/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "DropDownImageView.h"
#import "CustomActionSheet.h"

@protocol ShippingInformationDelegate <NSObject>
- (void)removeAddressView;
- (void)submitAddressInformation:(NSDictionary *)address;
@end

@interface ShippingInformationView : UIView<UIScrollViewDelegate,UITextFieldDelegate,customActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    id<ShippingInformationDelegate> delegate;
}
@property (retain) id<ShippingInformationDelegate>  delegate;
- (void)createViewForItem:(NSDictionary *)itemDictionary forStates:(NSArray *)states;
@end
