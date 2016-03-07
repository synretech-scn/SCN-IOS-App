//
//  FSEMView.h
//  Xbowling
//
//  Created by Click Labs on 5/15/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "CustomNumberPad.h"
@protocol FSEMDelegate <NSObject>;
- (void)selectedScore:(NSString *)score;
- (void)deleteScoreEntry;
- (void)markStrikeOrSpare:(NSString *)value;
@end

@interface FSEMView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,NumberPadDelegate>
{
    id<FSEMDelegate> delegate;
}
@property (retain) id<FSEMDelegate>  delegate;
- (void)updateStrikeOrSpareBasedOnCurrentThrow:(NSString *)status;
- (void)updateScoreFrameBasedOnPreviousThrowScore:(NSString *)score currentFrame:(NSUInteger)frameNumber currentThrow:(NSUInteger)throwNumber;
@end
