//
//  OfferingsListView.m
//  Xbowling
//
//  Created by Click Labs on 6/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "OfferingsListView.h"

@implementation OfferingsListView
{
    NSMutableArray *offeringsArray;
    UITableView *offeringsTable;
    int selectedOffering;
    NSString *category;
    int availablePoints;
    NSString *redeemPointsCategory;
    UIImageView *informationBaseView;
    NSMutableDictionary *selectedItemDictionary;
}
@synthesize delegate;

- (void)createViewForList:(NSArray *)offeringsList forCategory:(NSString *)redeemOrEarnPoints userAvailablePoints:(int)points
{
    availablePoints=points;
    category=redeemOrEarnPoints;
    offeringsArray=[[NSMutableArray alloc]initWithArray:offeringsList];
    selectedOffering=9999;
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImageView.userInteractionEnabled=YES;
    [backgroundImageView setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImageView];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImageView addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    if ([redeemOrEarnPoints isEqualToString:@"Redeem"]) {
        headerLabel.text=@"Player's Bank";
    }
    else if ( [redeemOrEarnPoints isEqualToString:@"RewardPointsMainCategories"])
    {
        headerLabel.text=@"Select Category";
    }
    else if ([redeemOrEarnPoints isEqualToString:@"rewardPointsItems"])
    {
        headerLabel.text=@"Player's Bank";
        if (offeringsArray.count > 0) {
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"BrowseAllItems"]) {
                headerLabel.text = @"Browse All";
            }
            else{
                headerLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:0] objectForKey:@"category"]];
            }
        }
    }
    else{
        headerLabel.text=@"Add Reward Points";
    }

    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    
    //add
  //  NSArray *pointsArray;
    //NSArray *categories=[[NSArray alloc]initWithObjects:@"Select an activity to add reward points. \n Tap here to redeem points or view your balance.",@"Current Player Bank Points", nil];
    
    NSArray *categories=[[NSArray alloc]initWithObjects:@"Current Player Bank Points",@"Select an activity to add reward points", nil];
   
    NSUInteger venueId=15103;//[[centerDictionary objectForKey:@"venueId"] integerValue];
     /*
    NSUInteger selectedVenueId=15103;
    NSString *venueName= @"SCN Strike First" ;
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"venue/%lu/userpointPair",(unsigned long)selectedVenueId];
     ServerCalls *serverCallInstance;
    NSDictionary *json = [serverCallInstance serverCallWithQueryParameters:@"" url:urlString contentType:@"" httpMethod:@"GET"];
    NSLog(@"response code=%@",json);
     */
    
    NSDictionary *json= [delegate getPointsForVenue:venueId];
    NSDictionary *responseDict=[[NSDictionary alloc]initWithDictionary:[json objectForKey:kResponseString]];
    NSMutableArray *pointsArray=[NSMutableArray new];
    NSString *lifetimePoints=[[responseDict objectForKey:@"lifeTimePoint"] stringValue];
    NSString *availablePoints=[[responseDict objectForKey:@"totalAvaliablePoints"] stringValue];
    [[DataManager shared]removeActivityIndicator];
    if ([[json objectForKey:kResponseStatusCode] isEqualToString:@"200"] && [[json objectForKey:kResponseString] count]>0) {
       
        [pointsArray addObject:lifetimePoints];
        [pointsArray addObject:availablePoints];
    }
    /*
        pointsView=[[PointsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        pointsView.delegate=self;
        [pointsView createViewForCenter:venueName venueId:venueId pointsArray:pointsArray];
        */
  
     if ([category isEqualToString:@"Earn"]) {
         
    int i=1;
    
    UILabel *categoryLabel=[[UILabel alloc]init];
    categoryLabel.frame=CGRectMake(0, headerView.frame.origin.y+10+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
         //CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], backgroundImageView.frame.size.height);
    categoryLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    categoryLabel.textColor=[UIColor whiteColor];
    categoryLabel.text=[NSString stringWithFormat:@"%@",[categories objectAtIndex:i]];
    categoryLabel.lineBreakMode=NSLineBreakByWordWrapping;
    categoryLabel.numberOfLines=2;
    categoryLabel.backgroundColor=[UIColor clearColor];
    [backgroundImageView addSubview:categoryLabel];
    /*
    UILabel *pointsLabel=[[UILabel alloc]init];
    pointsLabel.tag=100+i;
    pointsLabel.frame=CGRectMake(-10, headerView.frame.origin.y+10+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
         //CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], backgroundImageView.frame.size.height);
    pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    pointsLabel.textColor=[UIColor whiteColor];
    pointsLabel.textAlignment=NSTextAlignmentRight;
    pointsLabel.text=[NSString stringWithFormat:@"%@",[pointsArray objectAtIndex:i]];
    pointsLabel.backgroundColor=[UIColor clearColor];
    [backgroundImageView addSubview:pointsLabel];*/
     }
    else
    {
        int i=0;
        
        UILabel *categoryLabel=[[UILabel alloc]init];
        categoryLabel.frame=CGRectMake(0, headerView.frame.origin.y+10+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        //CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], backgroundImageView.frame.size.height);
        categoryLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        categoryLabel.textColor=[UIColor whiteColor];
        categoryLabel.text=[NSString stringWithFormat:@"%@",[categories objectAtIndex:i]];
        categoryLabel.lineBreakMode=NSLineBreakByWordWrapping;
        categoryLabel.numberOfLines=2;
        categoryLabel.backgroundColor=[UIColor clearColor];
        [backgroundImageView addSubview:categoryLabel];
       /*
        UILabel *pointsLabel=[[UILabel alloc]init];
        pointsLabel.tag=100+i;
        pointsLabel.frame=CGRectMake(0, headerView.frame.origin.y+10+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        //CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], backgroundImageView.frame.size.height);
        pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        pointsLabel.textColor=[UIColor whiteColor];
        pointsLabel.textAlignment=NSTextAlignmentRight;
        pointsLabel.text=[NSString stringWithFormat:@"%@",[pointsArray objectAtIndex:i]];

        pointsLabel.backgroundColor=[UIColor clearColor];
        [backgroundImageView addSubview:pointsLabel];
        */
        
        UILabel *pointsLabel=[[UILabel alloc]init];
        pointsLabel.tag=100+i;
        pointsLabel.frame=CGRectMake(-10, headerView.frame.origin.y+10+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        //CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], backgroundImageView.frame.size.height);
        pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        pointsLabel.textColor=[UIColor whiteColor];
        pointsLabel.textAlignment=NSTextAlignmentRight;
        pointsLabel.text=[NSString stringWithFormat:@"%@",[pointsArray objectAtIndex:i]];
//modi
pointsLabel.text=[NSString stringWithFormat:@"%@",[pointsArray objectAtIndex:1]];
        pointsLabel.backgroundColor=[UIColor clearColor];
        [backgroundImageView addSubview:pointsLabel];
        
    
    }
    
    
    if (offeringsArray.count > 0) {
        if ([category isEqualToString:@"Redeem"]) {
            //modi
            UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+50+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
           // noteLabel.text=@"    Items for which points are insufficient are grayed out.";
            //add
             noteLabel.text=@" Select an item to buy with reward points.  ";
            noteLabel.textColor=[UIColor whiteColor];
            noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            [self addSubview:noteLabel];
            
            offeringsTable=[[UITableView alloc]init];
            //modi
            offeringsTable.frame=CGRectMake(0, noteLabel.frame.size.height+noteLabel.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1300/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            NSLog(@"self.frame.size.height=%f offeringsTable.frame.origin.y=%f",self.frame.size.height,offeringsTable.frame.origin.y);
            offeringsTable.backgroundColor=[UIColor clearColor];
            offeringsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
            offeringsTable.delegate=self;
            offeringsTable.dataSource=self;
            [self addSubview:offeringsTable];
            
            UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
            submitButton.layer.cornerRadius=submitButton.frame.size.height/2;
            submitButton.clipsToBounds=YES;
            [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:submitButton.frame] forState:UIControlStateNormal];
            [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:submitButton.frame] forState:UIControlStateHighlighted];
            [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
            [submitButton addTarget:self action:@selector(submitButtonFunction) forControlEvents:UIControlEventTouchUpInside];
            submitButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
            [self addSubview:submitButton];

        }
        else if ([category isEqualToString:@"RewardPointsMainCategories"] || [category isEqualToString:@"rewardPointsItems"]) {
            offeringsTable=[[UITableView alloc]init];
            //modi
            offeringsTable.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, self.frame.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height]));
            NSLog(@"self.frame.size.height=%f offeringsTable.frame.origin.y=%f",self.frame.size.height,offeringsTable.frame.origin.y);
            offeringsTable.backgroundColor=[UIColor clearColor];
            offeringsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
            offeringsTable.delegate=self;
            offeringsTable.dataSource=self;
            [self addSubview:offeringsTable];
        }
        else{
            
            //eadd
            //earn
            //modi
            UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+50+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
            // noteLabel.text=@"    Items for which points are insufficient are grayed out.";
            noteLabel.text=@"           Activity                                                  Points Added     ";
            noteLabel.textColor=[UIColor whiteColor];
            noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            [self addSubview:noteLabel];

            
            offeringsTable=[[UITableView alloc]init];
            offeringsTable.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+50+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1300/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            NSLog(@"self.frame.size.height=%f offeringsTable.frame.origin.y=%f",self.frame.size.height,offeringsTable.frame.origin.y);
            offeringsTable.backgroundColor=[UIColor clearColor];
            offeringsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
            offeringsTable.delegate=self;
            offeringsTable.dataSource=self;
            [self addSubview:offeringsTable];
            
            UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
            submitButton.layer.cornerRadius=submitButton.frame.size.height/2;
            submitButton.clipsToBounds=YES;
            [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:submitButton.frame] forState:UIControlStateNormal];
            [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:submitButton.frame] forState:UIControlStateHighlighted];
            [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
            [submitButton addTarget:self action:@selector(submitButtonFunction) forControlEvents:UIControlEventTouchUpInside];
            submitButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
            [self addSubview:submitButton];
 
        }
    }
    else{
        UILabel *centersLabel=[[UILabel alloc]init];
        centersLabel.tag=4500;
        centersLabel.textColor = [UIColor whiteColor];
        centersLabel.textAlignment=NSTextAlignmentCenter;
        centersLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH1size];
        //modi
        centersLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],headerView.frame.size.height+headerView
                                      .frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 80);
        centersLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
        centersLabel.lineBreakMode= NSLineBreakByWordWrapping;
        centersLabel.numberOfLines=3;
        if ([category isEqualToString:@"Redeem"]) {
            centersLabel.text=@"No items are available for redemption of points.";
        }
        else{
            centersLabel.text=@"No items are available for earning points.";
        }
        [self addSubview:centersLabel];
    }
    
   
}

- (void)backButtonFunction
{
    [delegate removeOfferingsViewForCategory:category];
}

- (void)reloadTableForCategory:(NSString *)newCategory withOfferings:(NSArray *)itemsArray
{
    category = newCategory;
    offeringsArray = nil;
    [offeringsArray removeAllObjects];
    offeringsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    [offeringsTable reloadData];
    
    offeringsTable.frame=CGRectMake(0, offeringsTable.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1300/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    submitButton.layer.cornerRadius=submitButton.frame.size.height/2;
    submitButton.clipsToBounds=YES;
    [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:submitButton.frame] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:submitButton.frame] forState:UIControlStateHighlighted];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:submitButton];
    
}

#pragma mark - Checkbox
- (void)checkboxSelected:(UIButton *)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        selectedOffering=9999;
    }
    else{
        sender.selected=YES;
        selectedOffering=(int)sender.tag - 1500;
        
    }
    for (int i=0; i<offeringsArray.count; i++) {
        if (1500+i != sender.tag) {
            UIButton *checkboxBtn=(UIButton *)[self viewWithTag:1500+i];
            checkboxBtn.selected=NO;
        }
    }
}

- (void)submitButtonFunction
{
    if (selectedOffering == 9999) {
          [[[UIAlertView alloc]initWithTitle:@"" message:@"Please select some item to proceed further." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else{
        if ([category isEqualToString:@"Redeem"]) {
            [[[UIAlertView alloc]initWithTitle:@"Confirm redemption" message:[NSString stringWithFormat:@"Are you sure you want to spend %d points for %@?",[[[offeringsArray objectAtIndex:selectedOffering] objectForKey:@"itemPoint"] intValue],[[offeringsArray objectAtIndex:selectedOffering] objectForKey:@"itemDescription"]] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil] show];
//            [delegate showRedemptionImage];
        }
        else{
            [delegate submitSelection:[offeringsArray objectAtIndex:selectedOffering] forCategory:@"Earn"];
            //          [[[UIAlertView alloc]initWithTitle:@"Add Points" message:[NSString stringWithFormat:@"Are you sure you want to add %d points for %@?",[[[offeringsArray objectAtIndex:selectedOffering] objectForKey:@"itemPoint"] intValue],[[offeringsArray objectAtIndex:selectedOffering] objectForKey:@"itemDescription"]] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil] show];
        }

    }
    
  
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if ([alertView.title isEqualToString:@"Confirm redemption"]) {
        if (buttonIndex == 0) {
            [delegate submitSelection:[offeringsArray objectAtIndex:selectedOffering] forCategory:@"Redeem"];
        }
    }
    else{
        if (buttonIndex == 0) {
            [delegate submitSelection:[offeringsArray objectAtIndex:selectedOffering] forCategory:@"Earn"];
        }
    }
}
#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBckgd=(UIView*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBckgd removeFromSuperview];
        cellBckgd=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    //add
     cellView.backgroundColor=[UIColor colorWithRed:03.0/255 green:96.0/255 blue:8.0/255 alpha:0.9];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *offeringLabel=[[UILabel alloc]init];
    offeringLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], 1, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
    offeringLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    offeringLabel.textColor=[UIColor whiteColor];
    offeringLabel.lineBreakMode=NSLineBreakByWordWrapping;
    offeringLabel.numberOfLines=2;
    offeringLabel.backgroundColor=[UIColor clearColor];
    [cellView addSubview:offeringLabel];
    
    if ([category isEqualToString:@"RewardPointsMainCategories"]) {
         offeringLabel.text=[[NSString stringWithFormat:@"%@",[offeringsArray objectAtIndex:indexPath.row]] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        offeringLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 1, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(cellView.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, cellView.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [cellView addSubview:arrow];
    }
    else if ([category isEqualToString:@"rewardPointsItems"])
    {
        offeringLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 1, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:850/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
        offeringLabel.text=[[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"name"]] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        UILabel *pointsLabel=[[UILabel alloc]init];
        pointsLabel.frame=CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
        pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        pointsLabel.textColor=[UIColor whiteColor];
        pointsLabel.textAlignment=NSTextAlignmentRight;
        if ([category isEqualToString:@"rewardPointsItems"]) {
            pointsLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"costPoints"]];
        }
        else{
            pointsLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"itemPoint"]];
        }
        pointsLabel.backgroundColor=[UIColor clearColor];
        [cellView addSubview:pointsLabel];

    }
    else{
        offeringLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"itemDescription"]];
        UIButton *baseBtn=[[UIButton alloc]init];
        baseBtn.tag=1500 + indexPath.row;
        //    if(screenBounds.size.height == 480)
        //        baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width] , 27);
        //    else
        baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
        [baseBtn setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
        [baseBtn setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
        [baseBtn setBackgroundColor:[UIColor clearColor]];
        [baseBtn setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:4/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [baseBtn addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:baseBtn];
        
        if (baseBtn.tag == (1500+selectedOffering)) {
            baseBtn.selected=YES;
        }

        UILabel *pointsLabel=[[UILabel alloc]init];
        pointsLabel.frame=CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width]), 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
        pointsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        pointsLabel.textColor=[UIColor whiteColor];
        pointsLabel.textAlignment=NSTextAlignmentRight;
        if ([category isEqualToString:@"rewardPointsItems"]) {
                    pointsLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"costPoints"]];
        }
        else{
            pointsLabel.text=[NSString stringWithFormat:@"%@",[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"itemPoint"]];
        }
        pointsLabel.backgroundColor=[UIColor clearColor];
        [cellView addSubview:pointsLabel];
        
        if ([category isEqualToString:@"Redeem"]) {
            int itemPoints=[[[offeringsArray objectAtIndex:indexPath.row] objectForKey:@"itemPoint"] intValue];
            if (itemPoints > availablePoints) {
                UIView *grayOverlay=[[UIView alloc]init];
                grayOverlay.frame=cellView.frame;
                grayOverlay.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.2];
                grayOverlay.userInteractionEnabled=YES;
                [cell.contentView addSubview:grayOverlay];
            }
        }
    }
    

    
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%@",touch.view);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return offeringsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIView *cellView=(UIView*)[cell viewWithTag:(indexPath.row+100)];
//    [cellView setBackgroundColor:[UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]];
////    [delegate showPointsViewForCenter:indexPath.row];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([category isEqualToString:@"RewardPointsMainCategories"]) {
            if (indexPath.row == 0) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"BrowseAllItems"];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"BrowseAllItems"];
            }
            [delegate showItemsForRewardPointCategory:[offeringsArray objectAtIndex:indexPath.row]];
        }
    else if ([category isEqualToString:@"rewardPointsItems"])
    {
        [self showInformationViewForItem:[offeringsArray objectAtIndex:indexPath.row]];
    }
}

- (void)showInformationViewForItem:(NSDictionary *)itemInfo
{
    selectedItemDictionary = [[NSMutableDictionary alloc]initWithDictionary:itemInfo];
    informationBaseView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    informationBaseView.userInteractionEnabled=YES;
    [informationBaseView setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:informationBaseView];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [informationBaseView addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=[NSString stringWithFormat:@"%@",[itemInfo objectForKey:@"name"]];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunctionForInformationView) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    UIImageView *barcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, headerView.frame.size.height + headerView.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:90/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width - 140, 180)];
    barcodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    barcodeImageView.center=CGPointMake(self.center.x, barcodeImageView.center.y);
    __weak UIImageView *wBarcodeImageView = barcodeImageView;
    barcodeImageView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    NSURL *imageURL = [NSURL URLWithString:[itemInfo objectForKey:@"imageUrl"]];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(barcodeImageView.center.x-80, barcodeImageView.frame.size.height/2);
    [barcodeImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    [barcodeImageView setImageWithURLRequest:imageRequest
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         wBarcodeImageView.backgroundColor=[UIColor clearColor];
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
         wBarcodeImageView.image = image;
         [informationBaseView addSubview:wBarcodeImageView];
     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
     }];
    
    [informationBaseView addSubview:barcodeImageView];

    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:220/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    closeButton.layer.cornerRadius=closeButton.frame.size.height/2;
    closeButton.clipsToBounds=YES;
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:closeButton.frame] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:closeButton.frame] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Submit" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeInformationView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [informationBaseView addSubview:closeButton];
    
    //From previous App
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width - 60, FLT_MAX);
    
    CGSize expectedLabelSize = [[itemInfo objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:AvenirRegular size:XbH2size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //adjust the label the the new height.
//    CGRect newFrame = yourLabel.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    yourLabel.frame = newFrame;
    
//    CGRect textRect = [[itemInfo objectForKey:@"description"] boundingRectWithSize:maximumLabelSize
//                                                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                                                                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:AvenirRegular size:XbH2size]}
//                                                                                                                                   context:nil];
//    CGSize expectedLabelSize = CGSizeMake(textRect.size.width, textRect.size.height);
    UIScrollView* scroll= [[UIScrollView alloc] initWithFrame:CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y + 240, self.frame.size.width, 210)];
    scroll.userInteractionEnabled = YES;
    [scroll setContentSize:CGSizeMake(self.frame.size.width,expectedLabelSize.height+15)];
    scroll.delegate=self;
    scroll.backgroundColor=[UIColor clearColor];
    [informationBaseView addSubview:scroll];
    
    UILabel *sportfullinfoLabel =  [[UILabel alloc] initWithFrame: CGRectMake(25,0,scroll.frame.size.width-50,expectedLabelSize.height+10)];
    sportfullinfoLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
    sportfullinfoLabel.textAlignment = NSTextAlignmentLeft;
//    sportfullinfoLabel.lineBreakMode=NSLineBreakByWordWrapping;
    sportfullinfoLabel.numberOfLines=0;
    sportfullinfoLabel.textColor = [UIColor whiteColor];
    sportfullinfoLabel.text = [itemInfo objectForKey:@"description"];
    [sportfullinfoLabel sizeToFit];
    [scroll addSubview:sportfullinfoLabel];

}
- (void)removeInformationView
{
    NSLog(@"Points=%d",[[[NSUserDefaults standardUserDefaults]objectForKey:kRewardPoints] intValue]);
    if([[[NSUserDefaults standardUserDefaults]objectForKey:kRewardPoints]intValue]<[[selectedItemDictionary objectForKey:@"costPoints"]integerValue])
    {
        [[DataManager shared]removeActivityIndicator];
        NSString *text=@"You do not have enough Reward Points to purchase this item.";
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Uh oh!" message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert1 show];
    }
    else{
        [[DataManager shared]showActivityIndicator:@"Loading..."];
        [self performSelector:@selector(redeemRewardPoints) withObject:nil afterDelay:0.2];
    }
}

- (void)redeemRewardPoints
{
    [informationBaseView removeFromSuperview];
    informationBaseView = nil;
    [delegate redeemRewardPointsItem:selectedItemDictionary];
}
- (void)backButtonFunctionForInformationView
{
    [informationBaseView removeFromSuperview];
    informationBaseView = nil;
}
@end
