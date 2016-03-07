//
//  CoachView.h
//  XBowling3.1
//
//  Created by clicklabs on 1/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "ServerCalls.h"
#import "CoachScoreFrameView.h"
#import "PinFallClass.h"
@protocol coachProtocol <NSObject>
- (void)backButtonAction;
-(void)LiveScoreCall:(NSString *)enquiryUrl apinumber:(int)apiNUmber;
@end

@interface CoachView : UIView
-(void)loadView;
- (void)backGroundUpdateAction:(NSArray *)profileResponse;
-(void)getLiveScoreInbackground:(NSArray*)response;
@property (strong) id <coachProtocol> coachDelegate;

@end


