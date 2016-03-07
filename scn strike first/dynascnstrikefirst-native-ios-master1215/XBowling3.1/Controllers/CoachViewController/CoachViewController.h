//
//  CoachViewController.h
//  XBowling3.1
//
//  Created by clicklabs on 1/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoachView.h"
#import "ServerCalls.h"

@interface CoachViewController : UIViewController<coachProtocol,serverCallProtocol>
- (void)liveScoreVenueID:(int)venueid laneNumber:(int)lane;

@end
