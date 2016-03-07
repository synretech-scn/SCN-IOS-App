//
//  CallUsView.m
//  XBowling3.1
//
//  Created by Shreya on 03/04/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CallUsView.h"

@implementation CallUsView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImage addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Call Us/Find Us";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    sideNavigationButton.tag=802;
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];
    NSArray *imagesArray=[[NSArray alloc]initWithObjects:@"callusxb.png",@"callusoc.png",@"calluswc.png", nil];
    int ycoordinate=headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i=0; i<4; i++) {
        UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        baseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
        [self addSubview:baseView];
        
        if(i<3)
        {
        UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 6, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:650/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:330/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [iconImageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
//        iconImageView.center=CGPointMake(iconImageView.center.x,baseView.center.y);
        [baseView addSubview:iconImageView];
               iconImageView.hidden=true;
            
        }
        
        UIButton *viewButton=[[UIButton alloc]init];
        [viewButton setFrame:CGRectMake(baseView.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width]), headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
        viewButton.center=CGPointMake(viewButton.center.x,baseView.center.y);
        viewButton.layer.cornerRadius=viewButton.frame.size.height/2;
        viewButton.clipsToBounds=YES;
        viewButton.tag=100+i;
        viewButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
        
        if(i<3)
            [viewButton setTitle:@"Find" forState:UIControlStateNormal];
        
        else
            [viewButton setTitle:@"Back" forState:UIControlStateNormal];
        
        viewButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
        [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:viewButton.frame] forState:UIControlStateNormal];
        [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:viewButton.frame] forState:UIControlStateHighlighted];
        [viewButton addTarget:self action:@selector(viewButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewButton];
        
        ycoordinate=baseView.frame.size.height+baseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
        
        baseView.hidden=true;
        viewButton.hidden=true;
        
        [self clickButtonFunction];
        
        
        
    }
}

- (void)backButtonFunction
{
    [delegate removeView];
}

-(void)clickButtonFunction
{
    //int selection=(int)sender.tag - 100;
    NSString *selectedCategory;
    /*if (selection == 0) {
     selectedCategory=@"ITC";
     }
     else if (selection == 1){
     selectedCategory=@"OC";
     }
     else if (selection == 2){
     selectedCategory=@"WC";
     }
     else{selectedCategory=@"Back";}
     */
    
    selectedCategory=@"OC";
    
    
    [self performSelectorOnMainThread:@selector(leaderboard:) withObject:selectedCategory waitUntilDone:NO];
    
}

#pragma mark - Side Menu
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}
-(void)viewButtonFunction:(UIButton *)sender
{
    int selection=(int)sender.tag - 100;
    NSString *selectedCategory;
    if (selection == 0) {
        selectedCategory=@"ITC";
    }
    else if (selection == 1){
        selectedCategory=@"OC";
    }
    else if (selection == 2){
        selectedCategory=@"WC";
    }
    else{selectedCategory=@"Back";}
    [self performSelectorOnMainThread:@selector(leaderboard:) withObject:selectedCategory waitUntilDone:YES];
    
}

- (void)leaderboard:(NSString *)championship
{
    [delegate showLeaderboardForCallUs:championship];
}
@end
