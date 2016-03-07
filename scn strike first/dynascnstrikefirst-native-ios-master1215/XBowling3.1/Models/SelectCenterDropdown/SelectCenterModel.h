//
//  SelectCenterModel.h
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "Keys.h"
#import "ServerCalls.h"

@interface SelectCenterModel : NSObject
+ (SelectCenterModel *)shared;
- (NSArray *)getAllVenues:(NSString *)scoringType;
- (NSArray *)getAllCentersForCountry:(NSString*)country State:(NSString*)state ScoringType:(NSString *)scoringType;
- (NSMutableArray*)getNearbyCenterIndex:(NSString *)scoringType;
//- (NSDictionary *)laneCheckout;
- (NSArray *)updatedCenterArray;
- (void)geolocationServerCall;
- (NSMutableArray *)setInitialVenue:(NSString *)country state:(NSString *)state center:(NSString *)center;
@end
