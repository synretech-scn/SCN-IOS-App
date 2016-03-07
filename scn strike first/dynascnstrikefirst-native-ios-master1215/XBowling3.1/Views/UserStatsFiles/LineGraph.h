//
//  CashFlowGraphView.h
//  BusinessForecaster_iPadApp
//
//  Created by clicklabs on 6/17/14.
//  Copyright (c) 2014 Samar Singla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
@interface LineGraph : UIView
{
#define kGraphHeight 185
#define klinemaxheight 160
//#define kDefaultGraphWidth 700
#define kOOffsetX 50
#define kSteppX 500
#define kGraphBottom 10
#define kGraphTop 10
#define kStepY 70
#define kOffsetY 10
    
#define kBarTop 10
#define kBarWidth 40
#define kCircleRadius 3
    
}

-(void)lineGraphData:(NSArray *)data xAxis:(NSString *)xKey yAxis:(NSString *)yKey;

@end
