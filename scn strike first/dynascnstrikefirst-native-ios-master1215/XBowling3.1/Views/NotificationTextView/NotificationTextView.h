//
//  NotificationTextView.h
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol shownotificationProtocol <NSObject>
- (void)backButtonAction;
@end
@interface NotificationTextView : UIView
@property (weak) id <shownotificationProtocol> backShownotificationDelegate;
@property(nonatomic,retain)NSString *notificationMessage;
-(void)loadMessage;

@end
