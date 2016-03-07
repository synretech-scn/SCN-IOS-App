//
//  ShowNotificationText.h
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTextView.h"

@interface ShowNotificationText : UIViewController<shownotificationProtocol>
@property(nonatomic,retain)NSString *messageNotification;

@end
