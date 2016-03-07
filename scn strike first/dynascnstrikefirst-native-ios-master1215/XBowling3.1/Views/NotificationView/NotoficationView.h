//
//  NotoficationView.h
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
@protocol notificationProtocol <NSObject>
- (void)menuButtonAction;
-(void)centreSelected:(NSString *)venueId centreNameSelected:(NSString *)centreName;
@end

@interface NotoficationView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak) id <notificationProtocol> notificationDelegate;
-(void)LoadNotificationView:(NSDictionary *)notifcaitionresponse;
-(void)reloadCentreTable;
@end
