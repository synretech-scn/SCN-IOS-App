//
//  VenueSelectionModel.h
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keys.h"
#import "DataManager.h"
#import "ServerCalls.h"

@interface VenueSelectionModel : NSObject
+ (VenueSelectionModel *)shared;
- (NSDictionary *)laneCheckout;
@end
