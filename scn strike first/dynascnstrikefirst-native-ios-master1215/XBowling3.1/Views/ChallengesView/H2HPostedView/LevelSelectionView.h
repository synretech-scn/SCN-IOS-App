//
//  LevelSelectionView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/11/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
@protocol LevelSelectionDelegate<NSObject>
- (void)selectedLevel:(int)creditsRequired;
- (void)removeLevelView;
- (NSDictionary *)userCredits;
- (void)showBuyCreditsView;
@optional

@end

@interface LevelSelectionView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<LevelSelectionDelegate> delegate;
}
@property (retain) id<LevelSelectionDelegate>  delegate;
- (void)getCredits;
@end
