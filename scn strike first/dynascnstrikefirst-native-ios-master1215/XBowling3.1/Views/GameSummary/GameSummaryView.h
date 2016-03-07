//
//  GameSummaryView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/5/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "RoundedRectButton.h"
#import <FacebookSDK/FacebookSDK.h>


@protocol GameSummaryDelegate<NSObject>
- (void)updateTags:(NSString *)edittedTags;
- (void)fbScorePost;
@end

@interface GameSummaryView : UIView<UIAlertViewDelegate>
{
    id<GameSummaryDelegate> summaryDelegate;
}
@property (retain) id<GameSummaryDelegate>  summaryDelegate;
- (void)createMainView:(NSDictionary *)json challengesArray:(NSArray *)array;
@end
