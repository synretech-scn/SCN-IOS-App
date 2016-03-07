//
//  ChallengesViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengesMainView.h"
#import "OpponentSelectionView.h"
#import "LevelSelectionView.h"
#import "AddOpponentsView.h"
#import "ChallengesFrameView.h"
#import "ServerCalls.h"
#import "BowlingViewController.h"
#import "H2HLiveBaseView.h"
#import "H2HLiveCreateGameView.h"
#import "BuyCreditsViewController.h"

@interface ChallengesViewController : UIViewController<OpponentSelectionDelegate,LevelSelectionDelegate,AddOpponentsDelegate,ChallengesDelegate,ChallengesGameDelegate,H2HLiveDelegate,H2HCreateGameDelegate,UIWebViewDelegate>
- (void)createMainView;
- (void)showH2HLiveView;
- (void)showH2HPostedView;
@end
