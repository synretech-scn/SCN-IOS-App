//
//  pinFallView.h
//  XBowling 3.0
//
//  Created by Click Labs on 5/13/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@interface PinFallClass : UIView
@property(nonatomic)UIImage *standingPin;
@property(nonatomic)UIImage *downPin;
-(void)updatePins:(int)frame standingPinValue:(NSString *)value;
-(void)updateSingleFrameView:(int) frame standingPinsArray:(NSMutableArray *)standingPinsMutableArray bowlCount:(int) bowlCounter;
@end
