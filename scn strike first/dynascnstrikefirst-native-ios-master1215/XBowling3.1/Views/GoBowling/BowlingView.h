//
//  BowlingView.h
//  XBowling3.1
//
//  Created by Click Labs on 11/24/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectButton.h"
#import "DataManager.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "ScoreFrameImageView.h"
#import "ServerCalls.h"
#import "CoachScoreFrameView.h"
#import "GameSummaryView.h"
#import "FSEMView.h"

// define the protocol for the delegate
@protocol BowlingViewDelegate<NSObject>

@optional
- (NSString *)calculateScore:(int)firstPins secondPins:(int)secondPins thirdPins:(int) thirdPins currentFrame:(int)frame;
- (void)checkPreviousState:(int)frame;
- (void)updateGameView;
- (void)endGame;
- (void)showSelectedFrame;
- (void)showMainMenu:(UIButton *)sender;
- (void)showGameMenu;
- (void)updateRightMenu;
- (void)startNewGame;
- (void)liveScoreBackFunction;
- (void)showCoachView;
- (void)showChallengeView;
- (void)showFrameView;
- (void)ballTypeSelectionFunction;
- (void)pocketBrooklynFunction:(UIButton *)sender;
- (void)managePocketBrooklynForIndividualThrows:(int)throw;
- (void)updateBallNameForNextThrow;
- (void)removeMainMenu;
- (void)updateTagForPostedGame:(NSString *)tags;
- (void)postOnFacebook;
@end

@interface BowlingView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,GameSummaryDelegate,FSEMDelegate>
{
    id<BowlingViewDelegate> bowlingDelgate;
}
@property (retain) id<BowlingViewDelegate>  bowlingDelgate;
@property (retain) NSMutableDictionary *pinFallDictionary;
@property (retain) NSMutableDictionary *pinFallPreviousStateDictionary;
@property (retain) NSMutableArray *standingPinsMutableArray;
@property (retain) NSMutableArray *userStatsDataArray;
@property (retain) NSMutableArray *tagsArray;
@property (retain) NSTimer *timerforMyGameUpdateView;
//@property (retain,strong) UIViewController *root;
@property (nonatomic) int currentFrame;
@property (nonatomic) int ballsDependencyState;//1 - all independent; 2 - 1st and 2nd dependent; 3 - 2nd and 3rd dependent; 4 - 3rd not working
//@property (nonatomic) int lastFilledFrame;

- (void)updateScorePanel:(NSDictionary*)scoreDict;
- (void)updateFrameScore:(NSDictionary*)scoreDict;
- (void)updatePinView:(int)frame;
- (void)gameSummaryView:(NSDictionary *)summaryDict challengesArray:(NSArray *)array;
- (void)removeGameSummary;
- (void)bowlAgainFunction;
- (void)createBowlingView;
- (void)initiateUpdateTimer;
- (void)displayBallName:(NSString *)name;
- (void)setBallTypeArray:(NSArray *)array;
- (void)tenthFrameCountValue:(int)count;
- (void)updateViewForOrientationChange;
- (void)updateBowlingViewForChallenges;
- (void)fastScoreEntryModeView:(int)showOrHide;
@end
