//
//  MyGamesView.h
//  XBowling3.1
//
//  Created by Click Labs on 3/18/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
@protocol myGamesDelegate <NSObject>
- (void)showGamePlayforPlayer:(NSDictionary *)playerInfoDictionary;
@end
@interface MyGamesView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<myGamesDelegate> delegate;
}
@property (retain) id<myGamesDelegate> delegate;
- (void)createMyGames:(NSArray *)gamesData;
@end
