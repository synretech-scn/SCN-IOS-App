//
//  NotificationController.h
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotoficationView.h"
#import "LeftSlideMenu.h"

@interface NotificationController : UIViewController<notificationProtocol,LeftMenuDelgate,serverCallProtocol>
@end
