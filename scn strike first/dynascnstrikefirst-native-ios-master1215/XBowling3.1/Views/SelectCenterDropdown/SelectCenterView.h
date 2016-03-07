//
//  SelectCenterView.h
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"

@protocol CenterSelectionDelegate<NSObject>
- (void)venueInfo;
- (void)centerInfoForCountry:(NSString*)country State:(NSString*)state;

- (void)getNearbyCenter;
@optional
- (void)removeCenterSelectionView;
- (void)updateCenterInformation:(int)totalLanes selectedCountry:(NSString *)country selectedState:(NSString *)state selectedCenter:(NSString *)center;
- (void)selectedCenterDictionary:(NSDictionary *)dictionary;
- (void)selectedCountryDictionary:(NSDictionary *)countryDictionary state:(NSDictionary *)stateDictionary;
- (void)updateFilterView:(int)height;
@end

@interface SelectCenterView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,customActionSheetDelegate,UITextFieldDelegate>
{
    id<CenterSelectionDelegate> centerSelectionDelegate;
}
@property (retain) id<CenterSelectionDelegate>  centerSelectionDelegate;
@property (retain) NSMutableArray *countryInfoDict;
@property (retain) NSMutableArray *centerDetails;
- (void)nearbyCenter:(NSMutableArray *)indexArray;
- (void)createView;
- (void)venues;
//for filter
- (void)selectCenterViewforFilterView:(NSString *)filterParentView;
- (void)resetCenterView;
@end
