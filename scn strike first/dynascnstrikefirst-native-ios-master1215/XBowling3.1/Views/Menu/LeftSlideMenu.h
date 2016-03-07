//
//  LeftSlideMenu.h
//  XBowling3.1
//
//  Created by Click Labs on 1/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

// define the protocol for the delegate
@protocol LeftMenuDelgate<NSObject>

// define protocol functions that can be used in any class using this delegate
- (void)dismissMenu;
@end

@interface LeftSlideMenu : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<LeftMenuDelgate> menuDelegate;
}
@property (retain) id<LeftMenuDelgate>  menuDelegate;
@property (strong) UIViewController *rootViewController;
- (void)createMenuView;
-(void)reloadMenuTable;
@end
