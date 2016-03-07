//
//  CoachScoreFrameView.h
//  XBowling3.1
//
//  Created by clicklabs on 1/15/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"

@interface CoachScoreFrameView : UIView
@property(nonatomic)UIColor *backViewColor;
@property(nonatomic)UIColor *separatorLineColor;
@property(nonatomic)UIColor *frameNumberTextColor;
@property(nonatomic)NSString *frameNumber;
@property(nonatomic)NSString *ball1score;
@property(nonatomic)NSString *ball2score;
@property(nonatomic)NSString *ball3scoretenthFrame;
@property(nonatomic)NSString *totalScore;

-(void)loadViewWithText;
-(void)updateText;
-(void)viewFrame:(CGRect)frame;

@end
