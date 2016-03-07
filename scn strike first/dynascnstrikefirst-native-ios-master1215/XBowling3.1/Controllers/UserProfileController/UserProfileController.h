//
//  UserProfileController.h
//  XBowling3.1
//
//  Created by clicklabs on 1/7/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileView.h"
#import "SelectCenterView.h"
#import "SelectCenterModel.h"
#import "LeftSlideMenu.h"

@interface UserProfileController : UIViewController<userProfileProtocol,UIImagePickerControllerDelegate,serverCallProtocol,CenterSelectionDelegate,LeftMenuDelgate>

@end
