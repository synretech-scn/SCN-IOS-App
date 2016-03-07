//
//  TagsController.h
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCalls.h"
#import "TagsView.h"
#import "LeftSlideMenu.h"
@interface TagsController : UIViewController<serverCallProtocol,tagProtocol,LeftMenuDelgate>
@property(nonatomic,retain)NSString *gameId;
@end
