//
//  SelectCenterViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCenterView.h"
#import "SelectCenterModel.h"
#import "Keys.h"
#import "DataManager.h"
#import "BowlingViewController.h"
#import "LeftSlideMenu.h"
#import "VenueSelectionModel.h"
#import "VenueSelectionView.h"
@interface SelectCenterViewController : UIViewController<CenterSelectionDelegate,LeftMenuDelgate,VenueDelegate,EquipmentDetailsDelegate,serverCallProtocol>

@end
