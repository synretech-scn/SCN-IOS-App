//
//  GraphView.h
//  Graph
//
//  Created by clicklabs68 on 4/7/14.
//  Copyright (c) 2014 clicklabs68. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarChart : UIView

{
    

    
#define kbarGraphHeight 180
//#define kDefaultGraphWidth 568
#define kOffsetX 80
#define kStepX 50
//#define kGraphBottom 300
#define kGraphTop 10
//#define kStepY 50
#define kOffsetY 10
    
#define kBarTop 10
#define kBarWidth 40
#define kCircleRadius 3
   
#define CurrentHeight 5
    
    float barX;
    float barY;
    float barHeight;
    int check;
    float dataArray[12];
    float data_Sales[12];
    float gross_Profit[12];
    float total_Expenses[12];
    float net_Profit_before_Tax[12];
    float net_Profit_after_Tax[12];
    CGColorSpaceRef colorspace;
    CGGradientRef gradient;
    
    NSMutableArray *array_Storing_Y_Values_Of_Text;
    float height_Line;
}


-(void)barGraphdata:(NSArray *)data xAxis:(NSString *)xKey yAxis:(NSString *)yKey;
@property (nonatomic, strong) NSArray *colorlabelstextarray;;
@end
