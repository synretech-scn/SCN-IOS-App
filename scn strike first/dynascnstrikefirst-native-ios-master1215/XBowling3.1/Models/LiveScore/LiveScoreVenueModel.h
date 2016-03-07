//
//  LiveScoreVenueModel.h
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCalls.h"

@interface LiveScoreVenueModel : NSObject
+ (LiveScoreVenueModel *)shared;
- (NSDictionary *)getLiveScore:(NSString *)venueId;
@property (nonatomic) int showNetworkPopup;
@end
