//
//  ChallengesFrameView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "ScoreFrameImageView.h"
#import "RoundedRectButton.h"
@protocol ChallengesGameDelegate<NSObject>
@optional
- (void)removeFrameView;
- (void)updateFramesforChallenge:(NSString *)challengeType;
- (void)showMyGame;
- (void)showAddOpponentView;
@end

@interface ChallengesFrameView : UIView
{
    id<ChallengesGameDelegate> delegate;
}
@property (retain) id<ChallengesGameDelegate>  delegate;
- (void)createFrameViewforChallenge:(NSString *)challenge numberOfPlayers:(int)playersCount;
- (void)updateViewofPlayer:(int)playerIndex scoreDict:(NSDictionary *)scoreDictionary forChallenge:(NSString *)challenge arrayForLiveChallenge:(NSArray *)challengersArray;
- (void)addFrameViews:(int)numberOfPlayers;
@end
