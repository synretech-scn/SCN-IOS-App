//
//  AddCenterView.h
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "DropDownImageView.h"
#import "SelectCenterView.h"

@protocol walletCenterDelegate <NSObject>;
- (void)removeCenterView;
- (void)venueInfo;
- (void)centerInfoForCountry:(NSString*)country State:(NSString*)state;
- (void)getNearbyCenter;
- (void)submitSelectedCenter:(NSDictionary *)centerArray;
@optional
- (void)selectedCenterDictionary:(NSDictionary *)dictionary;
- (void)selectedCountryDictionary:(NSDictionary *)countryDictionary state:(NSDictionary *)stateDictionary;
@end


@interface AddCenterView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,customActionSheetDelegate,UIAlertViewDelegate>
{
    id<walletCenterDelegate> delegate;
}
@property (retain) id<walletCenterDelegate>  delegate;
@property (retain) NSMutableArray *countryInfoDict;
@property (retain) NSMutableArray *centerDetails;
- (void)nearbyCenter:(NSMutableArray *)indexArray;
- (void)createMainView;
@end
