//
//  ScoreFrameImageView.m
//  xBowling
//
//  Created by Click Labs on 3/28/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "ScoreFrameImageView.h"
#import "DataManager.h"
#import "Keys.h"

@implementation ScoreFrameImageView

@synthesize ball1Score;
@synthesize ball2Score;
@synthesize ball3Score;
@synthesize squareScore;
@synthesize frameNumber;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tag =4000;
        frameNumber=[[UILabel alloc]init];
        frameNumber.frame=CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:38.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28 currentSuperviewDeviceSize:screenBounds.size.height]);
        frameNumber.textAlignment=NSTextAlignmentCenter;
        frameNumber.textColor=[UIColor grayColor];
        frameNumber.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        //        frameNumber.backgroundColor=[UIColor colorWithRed:225.0/255 green:225.0/255 blue:229.0/255 alpha:0.7];
        frameNumber.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [self addSubview:frameNumber];
        
        ball1Score=[[UITextField alloc]init];
        ball1Score.textColor=[UIColor grayColor];
        ball1Score.textAlignment=NSTextAlignmentCenter;
        ball1Score.delegate=self;
        //        ball1Score.text=[NSString stringWithFormat:@"%d",i+1];
        ball1Score.frame=CGRectMake(0, frameNumber.frame.size.height+frameNumber.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:27.6 currentSuperviewDeviceSize:screenBounds.size.height]);
        ball1Score.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        ball1Score.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [self addSubview:ball1Score];
        
        ball2Score=[[UITextField alloc]init];
        ball2Score.textColor=[UIColor grayColor];
        ball2Score.textAlignment=NSTextAlignmentCenter;
        ball3Score.delegate=self;
        //        ball2Score.text=[NSString stringWithFormat:@"%d",i+1];
        ball2Score.frame=CGRectMake(ball1Score.frame.size.width+ball1Score.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.width], ball1Score.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:27.6 currentSuperviewDeviceSize:screenBounds.size.height]);
        ball2Score.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        ball2Score.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [self addSubview:ball2Score];
        
        squareScore=[[UILabel alloc]init];
        squareScore.textColor=[UIColor grayColor];
        squareScore.textAlignment=NSTextAlignmentCenter;
        //        squareScore.text=[NSString stringWithFormat:@"%d",i+1];
        squareScore.frame=CGRectMake(0, ball1Score.frame.size.height+ball1Score.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:38.3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28 currentSuperviewDeviceSize:screenBounds.size.height]);
        squareScore.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        squareScore.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [self addSubview:squareScore];
        
        NSLog(@"frame=height= %f  width= %f",frame.size.height,frame.size.width);
        //for tenth frame
        if(frame.size.width == [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:screenBounds.size.width]){
            frameNumber.frame=CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28 currentSuperviewDeviceSize:screenBounds.size.height]);
            ball3Score=[[UITextField alloc]init];
            ball3Score.textColor=[UIColor grayColor];
            //            ball3Score.text=[NSString stringWithFormat:@"%d",i+1];
            ball3Score.textAlignment=NSTextAlignmentCenter;
            ball3Score.delegate=self;
            ball3Score.frame=CGRectMake(ball2Score.frame.size.width+ball2Score.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.width], frameNumber.frame.size.height+frameNumber.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:18.6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:27.6 currentSuperviewDeviceSize:screenBounds.size.height]);
            ball3Score.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            ball3Score.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
            [self addSubview:ball3Score];
            squareScore.frame=CGRectMake(0, ball1Score.frame.size.height+ball1Score.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:28 currentSuperviewDeviceSize:screenBounds.size.height]);
        }
        ball1Score.inputView=[[UIView alloc]init];
         ball2Score.inputView=[[UIView alloc]init];
         ball3Score.inputView=[[UIView alloc]init];
        UILongPressGestureRecognizer *LongPressgesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressgesture:)];
        [ball1Score addGestureRecognizer:LongPressgesture];
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.inputView) {
        //hides the keyboard, but still shows the cursor to allow user to view entire text, even if it exceeds the bounds of the textfield
        textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

// Long press gesture reconizer
- (void)LongPressgesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended .................");
    }
    else {
        NSLog(@"Long press detected .....................");
    }
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
@end
