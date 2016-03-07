//
//  DetailNotificationView.h
//  XBowling3.1
//
//  Created by clicklabs on 2/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
@protocol DetailnotificationProtocol <NSObject>
- (void)backButtonAction;
-(void)notificationSelected :(NSString *)notificationId message:(NSString *)MessageText isalreadyReadOrNot:(int)readValue;
@end
@interface DetailNotificationView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak) id <DetailnotificationProtocol> backnotificationDelegate;
-(void)notificationTable:(NSDictionary *)notifcaitionresponse;
-(void)reloadTableOnly ;
@property(nonatomic,retain)NSString *centername;

@end
