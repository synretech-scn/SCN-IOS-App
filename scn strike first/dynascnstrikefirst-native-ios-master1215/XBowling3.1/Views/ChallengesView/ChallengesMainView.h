//
//  ChallengesMainView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
@protocol ChallengesDelegate<NSObject>
@optional
- (void)enterChallenge:(int)typeOfChallenge;
- (void)removeChallengeMainView;
- (void)showH2HWebView;

@end

@interface ChallengesMainView : UIView
{
    id<ChallengesDelegate> delegate;
}
@property (retain) id<ChallengesDelegate>  delegate;
- (void)createChallengeView;
- (void)updateChallengeButtonsState;
@end
