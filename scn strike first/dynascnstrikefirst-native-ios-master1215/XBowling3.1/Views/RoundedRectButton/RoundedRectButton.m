//
//  RoundedRectButton.m
//  XBowling3.1
//
//  Created by Click Labs on 11/26/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "RoundedRectButton.h"
#import "DataManager.h"
#import "Keys.h"

@implementation RoundedRectButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3]];
       
//        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
      
//        [self addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
//        [self addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}
-(void)buttonFrame:(CGRect)frame
{
    self.frame=frame;
    self.layer.cornerRadius=self.frame.size.height/2;
    self.clipsToBounds=YES;
    self.contentEdgeInsets=UIEdgeInsetsMake(3.5, 0.0, 0.0, 0.0);
    [self setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3] buttonframe:self.frame] forState:UIControlStateNormal];
    [self setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7] buttonframe:self.frame] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7] buttonframe:self.frame] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exclusiveTouch=YES;
    self.layer.borderColor=[UIColor whiteColor].CGColor;
    self.layer.borderWidth=0.7;
}

-(void)setBgColorForButton:(UIButton*)sender
{
    //highlighted
    [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7]];
}


-(void)doSomething:(UIButton*)sender
{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3]];
    });
    //do something
    
}
@end
