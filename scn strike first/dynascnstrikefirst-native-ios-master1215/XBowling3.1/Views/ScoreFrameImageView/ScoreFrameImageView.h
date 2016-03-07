//
//  ScoreFrameImageView.h
//  xBowling
//
//  Created by Click Labs on 3/28/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreFrameImageView : UIImageView<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) UILabel *frameNumber;
@property (nonatomic) UITextField *ball1Score;
@property (nonatomic) UITextField *ball2Score;
@property (nonatomic) UITextField *ball3Score;
@property (nonatomic) UILabel *squareScore;

//- (void)showTextFieldCursorAndDisableEditing;
@end
