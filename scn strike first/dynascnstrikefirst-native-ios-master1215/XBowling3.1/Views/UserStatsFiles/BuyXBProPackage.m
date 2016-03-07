//
//  BuyXBProPackage.m
//  XBowling3.1
//
//  Created by Click Labs on 3/25/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "BuyXBProPackage.h"

@implementation BuyXBProPackage
{
    NSMutableDictionary *packagesDictionary;
    int selectedPackage;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImage.userInteractionEnabled=YES;
        [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
        [self addSubview:backgroundImage];
        
        UIView *headerView=[[UIView alloc]init];
        //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.backgroundColor=XBHeaderColor;
        headerView.userInteractionEnabled=YES;
        [backgroundImage addSubview:headerView];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        //modi
        //headerLabel.text=@"Subscription";
        headerLabel.text=@"Details";
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        UIView *noteBase=[[UIView alloc]initWithFrame:CGRectMake(0,headerView.frame.origin.y+headerView.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        noteBase.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
        [self addSubview:noteBase];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        paragraphStyle.alignment=NSTextAlignmentCenter;
        UILabel *noteLabel =  [[UILabel alloc] initWithFrame: CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],0, noteBase.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], noteBase.frame.size.height)];
        noteLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
        noteLabel.textAlignment = NSTextAlignmentCenter;
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.backgroundColor=[UIColor clearColor];
        //modi
        //NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:@"Buy XB Pro Stats to bowl better with in-depth statistics and analysis."];
        
        
        NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:@"XB PRO STATS will provide better bowl with in-depth tracking and analysis, include                                                GRAPH over time, TRACK/FILTER,  key details RECORD, and COMPARISON to any other XB Pro Stats bowler. "];
        
        [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
        noteLabel.attributedText=nameString;
        noteLabel.numberOfLines=3;
        noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [noteBase addSubview:noteLabel];
        
        int yforCheckbox=noteBase.frame.size.height +noteBase.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height];
        for(int i=0;i<2;i++)
        {
            UIButton *baseBtn=[[UIButton alloc]init];
            baseBtn.tag=1500 + i;
            baseBtn.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], yforCheckbox,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            [baseBtn setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
            [baseBtn setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
            [baseBtn setBackgroundColor:[UIColor clearColor]];
            [baseBtn setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:7/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:7/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:7/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:7/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            [baseBtn addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:baseBtn];
            UILabel *teamName=[[UILabel alloc]init];
            teamName.frame=CGRectMake(baseBtn.frame.size.width+baseBtn.frame.origin.x, yforCheckbox, 150, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width]);
            teamName.textColor=[UIColor whiteColor];
            if(i == 0)
                teamName.text=@"$1.99 per month";
            else if (i == 1)
                teamName.text=@"$19.99 per year";
            teamName.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
            teamName.backgroundColor=[UIColor clearColor];
            [self addSubview:teamName];
            //add 
            if(i == 0 || i == 1)
                
            {
                baseBtn.hidden=true;
                teamName.hidden=true;
                
            }
            yforCheckbox=baseBtn.frame.size.height+baseBtn.frame.origin.y + 5;
        }
        
        UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:221/3 currentSuperviewDeviceSize:screenBounds.size.width],yforCheckbox+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        okButton.layer.cornerRadius=okButton.frame.size.height/2;
        okButton.clipsToBounds=YES;
        [okButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:okButton.frame] forState:UIControlStateNormal];
        [okButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:okButton.frame] forState:UIControlStateHighlighted];
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        okButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [self addSubview:okButton];
        
        
        //add
        
        okButton.hidden=true;
        
    }
    return self;
}

- (void)buyPackageData:(NSDictionary *)plansListDictioanry
{
    
}

- (void)backButtonFunction
{
    [delegate removeBuyPackageView];
}

- (void)okButtonFunction
{
    [delegate inAppPurchaseFunction:selectedPackage];
}

- (void)checkboxSelected:(UIButton *)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        selectedPackage=99;
    }
    else{
        sender.selected=YES;
        selectedPackage=(int)(sender.tag - 1500);
    }
    for (int i=0; i<2; i++) {
        if (1500+i != sender.tag) {
            UIButton *checkboxBtn=(UIButton *)[self viewWithTag:1500+i];
            checkboxBtn.selected=NO;
        }
    }
}

@end
