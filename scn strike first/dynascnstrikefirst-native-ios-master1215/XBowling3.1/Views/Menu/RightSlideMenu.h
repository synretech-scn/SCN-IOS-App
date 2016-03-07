//
//  RightSlideMenu.h
//  XBowling3.1
//
//  Created by Click Labs on 1/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

// define the protocol for the delegate
@protocol RightMenuDelgate<NSObject>

// define protocol functions that can be used in any class using this delegate
- (void)dismissRightMenu;
- (void)gameMenuSummaryFunction;
- (void)gameMenuQuitGameFunction;
- (void)gameMenuLeaderboardFunction;
-(void)showGameTagsUpdate:(NSString *)bowlingId;
- (void)fastScoreEntryMode:(int)showOrHide;
@end

@interface RightSlideMenu : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<RightMenuDelgate> rightMenuDelegate;
}
@property (retain) id<RightMenuDelgate>  rightMenuDelegate;
@property (strong) UIViewController *rootViewController;
- (void)createRightMenuView;
-(void)updateGametags;
- (void)reloadRightMenu:(int)updatedRow;
@end
