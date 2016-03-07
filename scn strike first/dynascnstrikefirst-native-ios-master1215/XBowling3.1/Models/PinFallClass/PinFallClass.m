//
//  pinFallView.m
//  XBowling 3.0
//
//  Created by Click Labs on 5/13/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "PinFallClass.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation PinFallClass
{
    UIImageView *backgroundView;
    
}
@synthesize standingPin;
@synthesize downPin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        backgroundView=[[UIImageView alloc]init];
        backgroundView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:backgroundView];
    }
    return self;
}

- (CGFloat)getValueFromTargetSize:(CGFloat)targetSuperviewSize targetSubviewSize:(CGFloat)targetSubviewSize currentSuperviewDeviceSize:(CGFloat)currentSizeOfSuperview
{
    return currentSizeOfSuperview/(targetSuperviewSize/targetSubviewSize);
    
}

-(void)updateSingleFrameView:(int) frame standingPinsArray:(NSString *)standingValue bowlCount:(int) bowlCounter
{
    
    self.backgroundColor=[UIColor grayColor];
    float horizontalspacing=[self getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:((self.frame.size.width-4*[self getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:SCREEN_WIDTH])/5) currentSuperviewDeviceSize:SCREEN_WIDTH];
    
    float verticalSpacing=[self getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:13/3 currentSuperviewDeviceSize:SCREEN_WIDTH];
    float pinwidth=[self getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:SCREEN_HEIGHT];
    
    for (int throws=1; throws<=1; throws++) {
        
        float number_of_stars = 4;
        float yForStar = verticalSpacing;
        float xForStar = 0;
        float pinIndex = 7;
        int i=0;
        for (int rows=1; rows <= 4; rows++)
        {
            float findxcordinate=(self.frame.size.width-number_of_stars*pinwidth-horizontalspacing*(number_of_stars-1))/2;
            xForStar=findxcordinate;
            
            for (int star=4; star >= rows; star--) // for loop for pins
            {
                UIImageView *pin=[[UIImageView alloc]initWithFrame:CGRectMake(xForStar,yForStar, pinwidth, pinwidth)];
                [pin  setImage:standingPin];
                pin.tag=100*throws + pinIndex;
                
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([[userDefaults objectForKey:kscoringType] isEqualToString:@"Manual"]) {
                    pin.userInteractionEnabled=YES;
                }
                else{
                    pin.userInteractionEnabled=NO;
                }
                [backgroundView addSubview:pin];
                printf(" ");
                xForStar= pin.frame.size.width + pin.frame.origin.x + horizontalspacing ;
                pinIndex++;
                i++;
            }
            //coordinates for next row
            yForStar=yForStar +pinwidth+ horizontalspacing;
            if(rows == 1)
                pinIndex=4;
            else if (rows == 2)
                pinIndex=2;
            else if(rows == 3)
                pinIndex=1;
            else
                pinIndex=7;
            number_of_stars = number_of_stars - 1;
        }
    }
}

#pragma mark - Back ground update

-(void)updatePins:(int)frame standingPinValue:(NSString *)value
{
    
    unsigned ball1ref = [value intValue];
    for (int i = 100; i<110; i++) {
        UIImageView *pin = (UIImageView *)[self viewWithTag:i+1];
        unsigned pin1 = pow(2, i-100);
        if  ((pin1 & ball1ref) >0) {
            pin.image =  standingPin;
        }
        else{
            pin.image = downPin;
        }
    }
}

@end
