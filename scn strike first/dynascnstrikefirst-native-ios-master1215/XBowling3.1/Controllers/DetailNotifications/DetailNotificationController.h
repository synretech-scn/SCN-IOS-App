//
//  DetailNotificationController.h
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailNotificationView.h"
#import "ServerCalls.h"

@interface DetailNotificationController : UIViewController<DetailnotificationProtocol,serverCallProtocol>
@property(nonatomic,retain)NSString *venueId;
@property(nonatomic,retain)NSString *centerNameTitle;
@property(nonatomic,retain)NSDictionary *detailResponse;

@end
