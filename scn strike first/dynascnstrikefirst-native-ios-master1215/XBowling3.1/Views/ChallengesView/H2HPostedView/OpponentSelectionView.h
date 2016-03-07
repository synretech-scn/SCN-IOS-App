//
//  OpponentSelectionView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"

@protocol OpponentSelectionDelegate<NSObject>
- (void)selectedOpponent:(NSDictionary *)opponentDictionary;
- (void)removeOpponentSelectionView;
@optional

@end


@interface OpponentSelectionView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    id<OpponentSelectionDelegate> delegate;
}
@property (retain) id<OpponentSelectionDelegate>  delegate;
- (void)displayPlayers:(NSMutableArray *)playersDict searchString:(NSString *)search showingFreinds:(int)showFriends challengeType:(NSString *)type;
-(void)reloadOpponentsTable;
@end
