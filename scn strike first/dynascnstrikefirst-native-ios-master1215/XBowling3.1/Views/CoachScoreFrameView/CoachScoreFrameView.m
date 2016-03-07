//
//  CoachScoreFrameView.m
//  XBowling3.1
//
//  Created by clicklabs on 1/15/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CoachScoreFrameView.h"

@implementation CoachScoreFrameView
{
    UILabel *ball1ScoreLabel;
    UILabel *ball2ScoreLabel;
    UILabel *ball3ScoreLabel;
    UILabel *totalScoreLabel;
    UIView *backview;
    UILabel *frameNumberLabel;
    
    float fontSizeRegular;
    float fontSizeDemi;
}
@synthesize backViewColor;
@synthesize frameNumberTextColor;
@synthesize frameNumber;
@synthesize separatorLineColor;
@synthesize ball1score;
@synthesize ball2score;
@synthesize ball3scoretenthFrame;
@synthesize totalScore;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
#pragma mark - Check For iPhone 4
        
        if(screenBounds.size.height<=480)
        {
            fontSizeRegular=54-6;
            fontSizeDemi=54-3;
        }
        else{
            fontSizeRegular=54;
            fontSizeDemi=54+4;
        }
    }
    return self;
}

- (void)viewFrame:(CGRect)frame
{
    self.frame=frame;
}

-(void)loadViewWithText{
    
    backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backview.backgroundColor=self.backViewColor;
    [self addSubview:backview];
    
    frameNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,2,self.frame.size.width,self.frame.size.height/3)];
    [frameNumberLabel setBackgroundColor:[UIColor clearColor]];
    frameNumberLabel.text=self.frameNumber;
    frameNumberLabel.textColor=self.frameNumberTextColor;
    frameNumberLabel.textAlignment=NSTextAlignmentCenter;
    frameNumberLabel.numberOfLines=0;
    frameNumberLabel.lineBreakMode=NSLineBreakByWordWrapping;
    frameNumberLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:fontSizeRegular/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:frameNumberLabel];
    
    
    float ycordinate=self.frame.size.height/3;
    for(int i=0;i<2;i++)
    {
        UIImageView *separatorLineHorizontal=[[UIImageView alloc]initWithFrame:CGRectMake(0, ycordinate, self.frame.size.width, 1)];
        separatorLineHorizontal.backgroundColor=self.separatorLineColor;
        separatorLineHorizontal.tag=10+i;
        [self addSubview:separatorLineHorizontal];
        ycordinate=ycordinate+self.frame.size.height/3;
    }
    
    ball1ScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height/3+2,self.frame.size.width/2,self.frame.size.height/3)];
    [ball1ScoreLabel setBackgroundColor:[UIColor clearColor]];
    ball1ScoreLabel.text=self.ball1score;
    ball1ScoreLabel.textColor=self.frameNumberTextColor;
    ball1ScoreLabel.textAlignment=NSTextAlignmentCenter;
    ball1ScoreLabel.numberOfLines=0;
    ball1ScoreLabel.lineBreakMode=NSLineBreakByWordWrapping;
    ball1ScoreLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:fontSizeRegular/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:ball1ScoreLabel];
    
    ball2ScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2,self.frame.size.height/3+2,self.frame.size.width/2,self.frame.size.height/3)];
    [ball2ScoreLabel setBackgroundColor:[UIColor clearColor]];
    ball2ScoreLabel.text=self.ball2score;
    ball2ScoreLabel.textColor=self.frameNumberTextColor;
    ball2ScoreLabel.textAlignment=NSTextAlignmentCenter;
    ball2ScoreLabel.numberOfLines=0;
    ball2ScoreLabel.lineBreakMode=NSLineBreakByWordWrapping;
    ball2ScoreLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:fontSizeRegular/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:ball2ScoreLabel];
    
    
    if([self.frameNumber integerValue]<10)
    {
        UIImageView *separatorLinevertical=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/3, 1, self.frame.size.height/3)];
        separatorLinevertical.tag=5;
        separatorLinevertical.backgroundColor=self.separatorLineColor;
        [self addSubview:separatorLinevertical];
        
    }
    else{
        ball1ScoreLabel.frame=CGRectMake(0,self.frame.size.height/3+2,self.frame.size.width/3,self.frame.size.height/3);
        ball2ScoreLabel.frame=CGRectMake(self.frame.size.width/3+1.5,self.frame.size.height/3+2,self.frame.size.width/3,self.frame.size.height/3);
        
        ball3ScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(2*self.frame.size.width/3,self.frame.size.height/3+2,self.frame.size.width/3,self.frame.size.height/3)];
        [ball3ScoreLabel setBackgroundColor:[UIColor clearColor]];
        ball3ScoreLabel.text=self.ball3scoretenthFrame;
        ball3ScoreLabel.textColor=self.frameNumberTextColor;
        ball3ScoreLabel.textAlignment=NSTextAlignmentCenter;
        ball3ScoreLabel.numberOfLines=0;
        ball3ScoreLabel.lineBreakMode=NSLineBreakByWordWrapping;
        ball3ScoreLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:fontSizeRegular/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [self addSubview:ball3ScoreLabel];
        
        
        float xcordinate=self.frame.size.width/3;
        for(int i=0;i<2;i++)
        {
            UIImageView *separatorLinevertical=[[UIImageView alloc]initWithFrame:CGRectMake(xcordinate, self.frame.size.height/3, 1, self.frame.size.height/3)];
            separatorLinevertical.tag=3+i;
            separatorLinevertical.backgroundColor=self.separatorLineColor;
            [self addSubview:separatorLinevertical];
            xcordinate=xcordinate+self.frame.size.width/3;
        }
    }
    
    totalScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,2*self.frame.size.height/3+2,self.frame.size.width,self.frame.size.height/3)];
    [totalScoreLabel setBackgroundColor:[UIColor clearColor]];
    totalScoreLabel.text=totalScore;
    totalScoreLabel.textColor=self.frameNumberTextColor;
    totalScoreLabel.textAlignment=NSTextAlignmentCenter;
    totalScoreLabel.numberOfLines=0;
    totalScoreLabel.lineBreakMode=NSLineBreakByWordWrapping;
    totalScoreLabel.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(fontSizeDemi+4)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:totalScoreLabel];
}


-(void)updateText
{
    backview.backgroundColor=self.backViewColor;
    ball1ScoreLabel.text=self.ball1score;
    ball2ScoreLabel.text=self.ball2score;
    ball3ScoreLabel.text=self.ball3scoretenthFrame;
    totalScoreLabel.text=self.totalScore;
    
    frameNumberLabel.textColor=self.frameNumberTextColor;
    ball1ScoreLabel.textColor=self.frameNumberTextColor;
    ball2ScoreLabel.textColor=self.frameNumberTextColor;
    ball3ScoreLabel.textColor=self.frameNumberTextColor;
    totalScoreLabel.textColor=self.frameNumberTextColor;
    
    [self viewWithTag:3].backgroundColor=[UIColor blackColor];
    [self viewWithTag:4].backgroundColor=[UIColor blackColor];
    [self viewWithTag:5].backgroundColor=[UIColor blackColor];
    [self viewWithTag:10].backgroundColor=[UIColor blackColor];
    [self viewWithTag:11].backgroundColor=[UIColor blackColor];
    
}

@end
