//
//  PointsView.m
//  Xbowling
//
//  Created by Click Labs on 6/16/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "PointsView.h"

@implementation PointsView
{
    NSUInteger venueId;
    int availablePoints;
    NSMutableArray *userPointsArray;
}

@synthesize delegate;

- (void)createViewForCenter:(NSString *)centerName venueId:(NSUInteger)venue pointsArray:(NSArray *)pointsArray
{
    if (pointsArray.count > 0) {
        userPointsArray=[[NSMutableArray alloc]initWithArray:pointsArray];
        availablePoints=[[pointsArray objectAtIndex:1] intValue];
        venueId=venue;
        NSArray *categories=[[NSArray alloc]initWithObjects:@"Lifetime Points",@"Available Points", nil];
        UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImage.userInteractionEnabled=YES;
        [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
        [self addSubview:backgroundImage];
        
        UIView *headerView=[[UIView alloc]init];
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.backgroundColor=XBHeaderColor;
        headerView.userInteractionEnabled=YES;
        [backgroundImage addSubview:headerView];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:12 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.text=[NSString stringWithFormat:@"%@",centerName];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:25 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        
        int ycoordinate=headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
        
        //add
        
        
        
        NSArray *imagesArray=[[NSArray alloc]initWithObjects:@"walletxb.png",@"walletwc.png",@"walletoc.png", nil];
        
     
        
         for (int i=0; i<2; i++) {
            
            /*UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            baseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
                [self addSubview:baseView];
             */
             
             UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.height])];
             baseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
             [self addSubview:baseView];
             
         
            
            //add
          //
             /*baseView.hidden=true;
            
            UILabel *categoryLabel=[[UILabel alloc]init];
            categoryLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], baseView.frame.size.height);
            categoryLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
            categoryLabel.textColor=[UIColor whiteColor];
            categoryLabel.text=[NSString stringWithFormat:@"%@",[categories objectAtIndex:i]];
            categoryLabel.lineBreakMode=NSLineBreakByWordWrapping;
            categoryLabel.numberOfLines=2;
            categoryLabel.backgroundColor=[UIColor clearColor];
            [baseView addSubview:categoryLabel];
            
            UILabel *pointsLabel=[[UILabel alloc]init];
            pointsLabel.tag=100+i;
            pointsLabel.frame=CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], baseView.frame.size.height);
            pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
            pointsLabel.textColor=[UIColor whiteColor];
            pointsLabel.textAlignment=NSTextAlignmentRight;
            pointsLabel.text=[NSString stringWithFormat:@"%@",[pointsArray objectAtIndex:i]];
            pointsLabel.backgroundColor=[UIColor clearColor];
            [baseView addSubview:pointsLabel];
              */
             //add
             UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 6, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:650/1.8 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:330/1.8 currentSuperviewDeviceSize:screenBounds.size.height])];
             [iconImageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
             //        iconImageView.center=CGPointMake(iconImageView.center.x,baseView.center.y);
             [baseView addSubview:iconImageView];
            
           // ycoordinate = baseView.frame.size.height+baseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
             
                  ycoordinate=50+baseView.frame.size.height+baseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
        }
        
        UIButton *redeemPointsButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:900/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1260/3.6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:self.frame.size.height])];
        redeemPointsButton.center=CGPointMake(self.center.x-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], redeemPointsButton.center.y);
        redeemPointsButton.layer.cornerRadius=redeemPointsButton.frame.size.height/3;
        redeemPointsButton.clipsToBounds=YES;
     //   [redeemPointsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:redeemPointsButton.frame] forState:UIControlStateNormal];
      //  [redeemPointsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:redeemPointsButton.frame] forState:UIControlStateHighlighted];
        //add
        [redeemPointsButton setBackgroundColor:[UIColor clearColor]  ];
      //  [redeemPointsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:redeemPointsButton.frame] forState:UIControlStateHighlighted];
        
        
        
        [redeemPointsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [redeemPointsButton setTitle:@"" forState:UIControlStateNormal];
        [redeemPointsButton addTarget:self action:@selector(redeemPointsButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        redeemPointsButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:XbH1size];
        [self addSubview:redeemPointsButton];
        //add
       // redeemPointsButton.hidden=true;
        
        UIButton *earnPointsButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.height] , [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1260/3.6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:self.frame.size.height])];
        earnPointsButton.center=CGPointMake(self.center.x-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], earnPointsButton.center.y);
        earnPointsButton.layer.cornerRadius=earnPointsButton.frame.size.height/3;
        earnPointsButton.clipsToBounds=YES;
        /*[earnPointsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:earnPointsButton.frame] forState:UIControlStateNormal];
        [earnPointsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:earnPointsButton.frame] forState:UIControlStateHighlighted];
       */
        
        //add
        
            [earnPointsButton setBackgroundColor:[UIColor clearColor]  ];
        
        
        [earnPointsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [earnPointsButton setTitle:@"" forState:UIControlStateNormal];
        [earnPointsButton addTarget:self action:@selector(earnPointsButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        earnPointsButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:XbH1size];
        [self addSubview:earnPointsButton];
        //add
      //  earnPointsButton.hidden=true;
        
        
    
    }
    
    /*
    
    //add
   // [self clickearnPointsButtonFunction];
    
   // [self earnPointsButtonFunction];
    
     //[delegate redeemOrEarnPointsFunction:@"Earn" points:availablePoints venue:venueId];
    
    
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
    headerLabel.text=@"Wallet/Coupon";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
   
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    sideNavigationButton.tag=802;
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:  [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];
   
      
    int ycoordinate=headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
    
      
    NSArray *imagesArray=[[NSArray alloc]initWithObjects:@"walletxb.png",@"walletwc.png",@"walletoc.png", nil];
    
    for (int i=0; i<4; i++) {
        UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        baseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
        [self addSubview:baseView];
        if(i==2 || i==3)
        {
            baseView.hidden=true;
        }
        if(i<3)
        {
            UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 6, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:650/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:330/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            [iconImageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
            //        iconImageView.center=CGPointMake(iconImageView.center.x,baseView.center.y);
            [baseView addSubview:iconImageView];
            
            if(i==2)
            {
                iconImageView.hidden=true;
            }
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
            [viewButton setTitle:@"View" forState:UIControlStateNormal];
        else
            [viewButton setTitle:@"Back" forState:UIControlStateNormal];
        viewButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
        [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:viewButton.frame] forState:UIControlStateNormal];
        [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:viewButton.frame] forState:UIControlStateHighlighted];
        
        if(     i==1     )
             [viewButton addTarget:self action:@selector(redeemPointsButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
            
         if(     i==0     )
                [viewButton addTarget:self action:@selector(earnPointsButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        
        
       if(     i==3     )[viewButton addTarget:self action:@selector(backButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        
        //[viewButton addTarget:self action:@selector(viewButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewButton];
        if(i==2)
        {
            viewButton.hidden=true;
        }
        ycoordinate=baseView.frame.size.height+baseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }

    
    }//add
         
         */
    
    
}

- (void)updatePoints:(NSArray *)pointsArray
{
    [userPointsArray removeAllObjects];
    userPointsArray=nil;
    userPointsArray=[[NSMutableArray alloc]initWithArray:pointsArray];
    availablePoints=[[userPointsArray objectAtIndex:1] intValue];
    for (int i=0; i<2; i++) {
        UILabel *pointsLabel=(UILabel *)[self viewWithTag:100+i];
        pointsLabel.text=[NSString stringWithFormat:@"%@",[userPointsArray objectAtIndex:i]];
    }
}

//add
#pragma mark - Side Menu

/*
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}

- (void)backButtonFunction
{
    [delegate removeView];
}
*/
- (void)clickearnPointsButtonFunction
{
    [delegate redeemOrEarnPointsFunction:@"Earn" points:availablePoints venue:venueId];
}



- (void)clickredeemPointsButtonFunction
{
    [delegate redeemOrEarnPointsFunction:@"Redeem" points:availablePoints venue:venueId];
}





- (void)redeemPointsButtonFunction
{
    [delegate redeemOrEarnPointsFunction:@"Redeem" points:availablePoints venue:venueId];
}

- (void)earnPointsButtonFunction
{
    [delegate redeemOrEarnPointsFunction:@"Earn" points:availablePoints venue:venueId];
}

- (void)backButtonFunction
{
    [delegate removePointsView];
}


@end
