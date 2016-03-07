//
//  userStatsView.m
//  XBowling 3.0
//
//  Created by Click Labs on 6/26/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "UserStatsClass.h"
#import "DropDownImageView.h"
#import "LineGraph.h"
#import "BarChart.h"
#import "PCPieChart.h"



@implementation UserStatsClass
{
    UIImageView *backgroundView;
    UIView *headerView;
    UIScrollView *adsScroll;
    int adIndex;
    NSArray *adsImgsArray;
    
  
//    UIActionSheet *actionSheet;
    CustomActionSheet *actionSheet;
    UIPickerView *pickerView ;
    int selectedGraphType;
    DropDownImageView *graphTypeImageView;
    DropDownImageView *comparisonWithImageView;
    int stepIndex; // to keep track of the current step     //1=Summary; 2=Graphs; 3=Pin stats;
    int previousStepIndex;
    NSArray *graphTypesArray;
    NSArray *graphServerUrlArray;
    NSDictionary *piechartDic;

    
    //for PinStats view
    NSMutableArray *selectedPinStatsArray;
    NSIndexPath *selectedIndexPath;
	NSArray *articles;
    
    UIScrollView *resizableScroll;  //base scroll view
    
    NSMutableArray *sectionHeaderArray;  //array of section headers
    int heightOfCell;
    BOOL sectionExpanded;
    
    NSMutableArray *pinViewJsonArray;
    BOOL checkboxOfFilter;
    
    //for duration
//    NSString *duration;
    
    //for location
    DropDownImageView *selectCountryImageView;
    DropDownImageView *selectStateImageView;
    DropDownImageView *selectCenterImageView;
    NSArray *countryInfoDict;
    NSArray *centerDetails;
    int selectedCountryIndex;
    int selectedStateIndex;
    int selectedCenterIndex;
//    NSString *filterVenueId;
    
    //for oil pattern
    DropDownImageView *oilPatternDropDown;
    int selectedOilPattern;
//    NSString *oilPattern;
    
    //for pattern length
    DropDownImageView *patternLengthDropDown;
    int selectedPatternLength;
//    NSString *patternLength;
    
    //for game type
    DropDownImageView *gameTypeDropDown;
    int selectedGameType;
    
    //equipment view
    NSMutableDictionary *equipmentDetailDictionary;
    NSMutableArray *patternNamesEquipmentDetails;
    NSMutableArray *heightOfCellArray;
    
    //comparison
    NSMutableArray *comparisonItemselectArray;
    UIButton *allXbowlersBtn;
    UIButton *myFriendsBtn;
    UIScrollView *baseScrollcompare;
    UITextField *searchchBar;
    UIImageView *btnsBaseImagecompare;
    UILabel*    suggestionlabel;
    BOOL allxbowlers;
    UIView*  clearColorview;
    UIImageView*  enterScoreImageView;
    ASIHTTPRequest *searchRequest;
    NSMutableArray *myFriendsArray;
    UIButton*   makeComparison;
    int selectedComparisonType;
    
    int statsStatus;
    float animatedDistance;
    
    NSUInteger numberofbowlersdisplayed;
    NSMutableArray *bowlersArray;
    int ycoordinateForBowlersList;
    NSString *searchXBowler;
    BOOL searchOn;
    BOOL showListView;
    NSNumberFormatter *formatter;
    int ycoordinateForSectionButton;
     NSMutableArray *openSectionsArray;   //Array of index of open sections
    ComparisonView *statsComparisonView;
    int selectedOpponentIndex;
    ExpandableTableView *equipmentTableView;
    BOOL maintainedPreviouStepIndex;

}
@synthesize ballTypeNamesArray,patternNamesArray,gameTypeNamesArray,patternLengthArray,delegate,subscriptionCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectedCountryIndex = 0;
        selectedStateIndex = 0;
        selectedCenterIndex = 0;
        openSectionsArray=[NSMutableArray new];
        // Display score in standard format
        formatter = [[NSNumberFormatter alloc] init];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [formatter setGroupingSeparator:groupingSeparator];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:YES];
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:kfilterCountryIndex])
            selectedCountryIndex=(int)[[NSUserDefaults standardUserDefaults]integerForKey:kfilterCountryIndex];
        if([[NSUserDefaults standardUserDefaults]integerForKey:kfilterStateIndex])
            selectedStateIndex=(int)[[NSUserDefaults standardUserDefaults]integerForKey:kfilterStateIndex];
        if([[NSUserDefaults standardUserDefaults]integerForKey:kfilterVenueIndex])
            selectedCenterIndex=(int)[[NSUserDefaults standardUserDefaults]integerForKey:kfilterVenueIndex];
        if(![[NSUserDefaults standardUserDefaults]valueForKey:kduration])
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKeyPath:kduration];
        
        articles=[[NSArray alloc]initWithObjects:@"Average Score",@"High Score",@"Open/Spare/Strike",nil];
        graphTypesArray=[[NSArray alloc]initWithObjects:@"Average Score",@"High Score",@"Open/Spare/Strike",@"Score Distribution",@"Multi-Pin Spare Conversion",@"Split Conversion",@"Oil Pattern",@"Single-Pin Spare Conversion",@"Ball Type Spare-Strike Percentage",@"First Ball Average based on Ball Type", nil];
        graphServerUrlArray=[[NSArray alloc]initWithObjects:@"UserStat/GetAverageScoreGraph",@"UserStat/GetHighestScoreGraph_ByUser",@"UserStat/GetSpare_StrikeGraph",@"UserStat/GetScoreDistributionGraph",@"UserStat/GetMultipinAndSplit_SplitConversionGraph",@"UserStat/GetMultipinAndSplit_SplitConversionGraph",@"UserStat/GetOilPatternGraph_ByUser",@"UserStat/GetSinglePinGraph",@"UserStat/GetSpare_StrikeGraphByBallType",@"UserStat/GetAverageScoreGraphByBallType", nil];
        
        UIImageView *baseImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        baseImage.userInteractionEnabled=YES;
        [baseImage setImage:[UIImage imageNamed:@"bg.png"]];
        [self addSubview:baseImage];
        
        backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundView.userInteractionEnabled=YES;
        [self addSubview:backgroundView];
        
        headerView=[[UIView alloc]init];
        //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.backgroundColor=XBHeaderColor;
        headerView.userInteractionEnabled=YES;
        [self addSubview:headerView];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
        headerLabel.text=@"XB Pro Stats";
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:37 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
        [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
        [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
        [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:sideNavigationButton];
        sideNavigationButton.userInteractionEnabled=true;
        [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

        
        NSArray *itemArray = [NSArray arrayWithObjects: @"My Games",@"My Stats",@"Compare",@"Settings", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.tag=16000;
        segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1160/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 1;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    nil];
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 1) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
        NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                              [UIColor whiteColor], NSForegroundColorAttributeName,
                                              nil];
        [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
        //        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
        [self addSubview:segmentedControl];

        UIButton *filterButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
        filterButton.tag=123;
        filterButton.backgroundColor=[UIColor clearColor];
        filterButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
        [filterButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
        [filterButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
        [filterButton addTarget:self action:@selector(filterButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:filterButton];

        
        selectedPinStatsArray=[NSMutableArray new];
        comparisonItemselectArray=[NSMutableArray new];
        selectedGraphType=0;
       
        ycoordinateForSectionButton=segmentedControl.frame.size.height+segmentedControl.frame.origin.y+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
      
//        [self myStats];
        [self resetFiltersFunction];
        
    }
    return self;
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    UIButton *filterButton=(UIButton *)[headerView viewWithTag:123];
    if (segment.tag == 16000) {
        if(segment.selectedSegmentIndex == 0){
            //My games
            filterButton.hidden=NO;
            stepIndex=0;
            previousStepIndex=0;
            for(UIView *view in backgroundView.subviews)
                [view removeFromSuperview];
            UISegmentedControl *pinStatsSegment=(UISegmentedControl *)[self viewWithTag:17000];
            [pinStatsSegment removeFromSuperview];
            for (int i=0; i<3; i++) {
                UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
                [settingsSectionButton removeFromSuperview];
                UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
                [statsSectionButton removeFromSuperview];
            }
            MyGamesView *gameView = [delegate showMyGames:ycoordinateForSectionButton];
            [backgroundView addSubview:gameView];
        }
        else if (segment.selectedSegmentIndex == 1){
            //My stats
            filterButton.hidden=NO;
            for(UIView *view in backgroundView.subviews)
                [view removeFromSuperview];
            UISegmentedControl *pinStatsSegment=(UISegmentedControl *)[self viewWithTag:17000];
            [pinStatsSegment removeFromSuperview];
            for (int i=0; i<3; i++) {
                UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
                [settingsSectionButton removeFromSuperview];
                UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
                [statsSectionButton removeFromSuperview];
            }
            [self myStats];
            
        }
        else if (segment.selectedSegmentIndex == 2){
            //Compare
            selectedComparisonType=0;
            for(UIView *view in backgroundView.subviews)
                [view removeFromSuperview];
            UISegmentedControl *pinStatsSegment=(UISegmentedControl *)[self viewWithTag:17000];
            [pinStatsSegment removeFromSuperview];
            for (int i=0; i<3; i++) {
                UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
                [settingsSectionButton removeFromSuperview];
                UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
                [statsSectionButton removeFromSuperview];
            }
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                 filterButton.hidden=YES;
                [self comparisonSubview:nil];
            }
            else{
                 filterButton.hidden=NO;
                [self myStats];
            }
        }
        else{
            //Settings
            
            for(UIView *view in backgroundView.subviews)
                [view removeFromSuperview];
            UISegmentedControl *pinStatsSegment=(UISegmentedControl *)[self viewWithTag:17000];
            [pinStatsSegment removeFromSuperview];
            for (int i=0; i<3; i++) {
                UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
                [settingsSectionButton removeFromSuperview];
                UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
                [statsSectionButton removeFromSuperview];
            }
            if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
                 filterButton.hidden=YES;
                [self settingsButtonFunction];
            }
            else{
                 filterButton.hidden=NO;
                [self myStats];
            }
        }
    }
    else if (segment.tag == 15000) {
        //Compare section
        
        if (segment.selectedSegmentIndex == 0) {
            //all xbowlers
            [self allXBowlersButtonFunction];
        }
        else{
            //friends
            [self friendbuttonAction:myFriendsBtn];
        }
    }
    else{
        //Pin stats section
        if (segment.selectedSegmentIndex == 0) {
            // pin view
            [self pinStats];
        }
        else{
            // list view
            [self listView];
        }
    }
    
}

- (void)showMyGames
{
    UISegmentedControl *segment=(UISegmentedControl *)[self viewWithTag:16000];
    [segment setSelectedSegmentIndex:0];
    [self MySegmentControlAction:segment];
}

- (void)myStats
{
    stepIndex=1;
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[self viewWithTag:16000];
    [segmentedControl setSelectedSegmentIndex:1];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased] == YES) {
     
        
        NSArray *sectionLabelArray=[[NSArray alloc]initWithObjects:@"Summary",@"Graphs",@"Pin Stats", nil];
        int xcoordinate=0;
        int ycoordinate=ycoordinateForSectionButton;
        UIButton *sectionButton;
        for (int i=0; i<3; i++) {
            UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
            [settingsSectionButton removeFromSuperview];
            UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
            [statsSectionButton removeFromSuperview];
            sectionButton=[[UIButton alloc]init];
            sectionButton.frame=CGRectMake(xcoordinate, ycoordinate, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:406/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:185/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            sectionButton.tag=90+i;
            [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithWhite:0 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateNormal];
            [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateHighlighted];
             [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateSelected];
            [sectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sectionButton setTitle:[NSString stringWithFormat:@"%@",[sectionLabelArray objectAtIndex:i]] forState:UIControlStateNormal];
            [sectionButton addTarget:self action:@selector(sectionFunction:) forControlEvents:UIControlEventTouchUpInside];
            sectionButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
            [self addSubview:sectionButton];
            if (i == 0) {
                sectionButton.selected=YES;
            }
            xcoordinate=sectionButton.frame.size.width+sectionButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width];
        }
        ycoordinate=sectionButton.frame.origin.y+sectionButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
        NSArray *statLabelsArray=[[NSArray alloc]initWithObjects:@"Open",@"Open Percentage",@"Strike",@"Strike Percentage",@"Single-Pin Spare",@"Single-Pin Spare Percentage",@"Multi-Pin Spare",@"Multi-Pin Spare Percentage",@"Split",@"Split Percentage",@"Games < 150",@"Games between 151-175",@"Games between 176-200",@"Games between 201-225",@"Games between 226-250",@"Games between 251-299",@"Perfect Score Percentage",@"Filled Frame Percentage",@"Pocket Percentage",@"Carry Percentage", nil];
        NSArray *keysArray=[[NSArray alloc]initWithObjects:@"opens,openChances",@"openpercent",@"strike,strikeChances",@"strikepercent",@"singlePin,singlePinChances",@"singlePinpercent",@"multiPin,multiPinChances",@"multiPinpercent",@"split,splitChances",@"splitpercent",@"percentageOfgameLessthan150",@"percentageOfgameBet151To175",@"percentageOfgameBet176To200",@"percentageOfgameBet201To225",@"percentageOfgameBet226To250",@"percentageOfgameBet251To299",@"percentageOfPerfectScore",@"filledFrame",@"noOfPocketpercent",@"carry", nil];
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        //current date
        NSDate *currentDate=[NSDate date];
        NSLog(@"currentDate=%@",currentDate);
        NSString *format=@"MM/dd/yyyy";
        NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
        [formatterUtc setDateFormat:format];
        [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
        NSString *displayDate=[formatterUtc stringFromDate:currentDate];
        NSLog(@"displayDate=%@",displayDate);
        
        NSString *params= [[NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&Tag=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate,[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@"All Tags"] || [[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@""]) {
            params= [NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate];
        }
        NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:@"UserStat/BowlingGameUserStatViewListIndividual" contentType:@"" httpMethod:@"GET"];
        @try {
            if([[json objectForKey:kResponseStatusCode] intValue] == 200)
            {
                if ([[json objectForKey:kResponseString] count]>0) {
                    NSDictionary *response=[[json objectForKey:kResponseString] objectAtIndex:0];
                    NSLog(@"responseDict=%@",response);
                    //stats view
                    if(response.count > 0)
                    {
                        UIView *backImageView=[[UIView alloc]init];
                        backImageView.frame=CGRectMake(0, ycoordinate, backgroundView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:245/3 currentSuperviewDeviceSize:screenBounds.size.height]);
                        backImageView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.3];
                        [backgroundView addSubview:backImageView];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:5];
                        //Score Labels
                        UILabel *averageScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:245/3 currentSuperviewDeviceSize:screenBounds.size.height])];
                        NSMutableAttributedString *avgScoreAttributedString=[[NSMutableAttributedString alloc] initWithString: [formatter stringFromNumber:[NSNumber numberWithInt:[[response objectForKey:@"averageScores"] intValue]]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        NSAttributedString *averageScoreLabelText=[[NSAttributedString alloc] initWithString:@"\nAvg. Score" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        [avgScoreAttributedString appendAttributedString:averageScoreLabelText];
                        [avgScoreAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [avgScoreAttributedString length])];
                        averageScoreLabel.attributedText=avgScoreAttributedString;
                        averageScoreLabel.backgroundColor=[UIColor clearColor];
                        averageScoreLabel.textColor=[UIColor whiteColor];
                        averageScoreLabel.textAlignment=NSTextAlignmentCenter;
                        averageScoreLabel.numberOfLines=0;
                        [backImageView addSubview:averageScoreLabel];
                        
                        UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(averageScoreLabel.frame.size.width + averageScoreLabel.frame.origin.x , averageScoreLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], averageScoreLabel.frame.size.height)];
                        NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString: [formatter stringFromNumber:[NSNumber numberWithInt:[[response objectForKey:@"totalScore"] intValue]]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        NSAttributedString *scoreLabelText=[[NSAttributedString alloc] initWithString:@"\nTotal Score" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        [scoreAttributedString appendAttributedString:scoreLabelText];
                        scoreLabel.backgroundColor=[UIColor clearColor];
                        [scoreAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [scoreAttributedString length])];
                        scoreLabel.attributedText=scoreAttributedString;
                        scoreLabel.textColor=[UIColor whiteColor];
                        scoreLabel.numberOfLines=0;
                        scoreLabel.textAlignment=NSTextAlignmentCenter;
                        [backImageView addSubview:scoreLabel];
                        
                        UILabel *totalGamesLabel=[[UILabel alloc]initWithFrame:CGRectMake(scoreLabel.frame.size.width + scoreLabel.frame.origin.x , averageScoreLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:414/3 currentSuperviewDeviceSize:screenBounds.size.width], averageScoreLabel.frame.size.height)];
                        NSMutableAttributedString *totalGamesAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[[response objectForKey:@"games"] intValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        NSAttributedString *totalGamesLabelText=[[NSAttributedString alloc] initWithString:@"\nTotal Games" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
                        [totalGamesAttributedString appendAttributedString:totalGamesLabelText];
                        totalGamesLabel.backgroundColor=[UIColor clearColor];
                        [totalGamesAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalGamesAttributedString length])];
                        totalGamesLabel.attributedText=totalGamesAttributedString;
                        totalGamesLabel.textColor=[UIColor whiteColor];
                        totalGamesLabel.numberOfLines=0;
                        totalGamesLabel.textAlignment=NSTextAlignmentCenter;
                        [backImageView addSubview:totalGamesLabel];
                        
                        ycoordinate=backImageView.frame.size.height+backImageView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
                        UIScrollView *baseScroll=[[UIScrollView alloc]init];
                        baseScroll.frame=CGRectMake(2.5, ycoordinate, backgroundView.frame.size.width - 5, self.frame.size.height - ycoordinate - 10);
                        [backgroundView addSubview:baseScroll];
                        UIView *clearviewLabel;
                        int ycoordinate=2;
                        //                    for(int i=0;i<statLabelsArray.count/2;i=i*2)
                        for(int i=0;i<statLabelsArray.count;i++)
                        {
                            clearviewLabel= [[UIView alloc]init];
                            clearviewLabel.userInteractionEnabled=YES;
                            [clearviewLabel setFrame:CGRectMake(0, ycoordinate, baseScroll.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:184/3 currentSuperviewDeviceSize:self.frame.size.height])];
                            [baseScroll addSubview:clearviewLabel];
                            clearviewLabel.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
                            
                            UILabel *label1=[[UILabel alloc]init];
                            label1.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.width], 0,clearviewLabel.frame.size.width/2 - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.width] , clearviewLabel.frame.size.height);
                            NSMutableAttributedString *titleString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[statLabelsArray objectAtIndex:i]]];
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                            [paragraphStyle setLineSpacing:6];
                            [titleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleString length])];
                            label1.attributedText=titleString;
                            label1.numberOfLines=2;
                            label1.textAlignment=NSTextAlignmentLeft;
                            label1.lineBreakMode=NSLineBreakByWordWrapping;
                            label1.textColor=[UIColor whiteColor];
                            label1.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
                            label1.backgroundColor=[UIColor clearColor];
                            [clearviewLabel addSubview:label1];
                            
                            UILabel *value1=[[UILabel alloc]init];
                            //                        value1.frame=CGRectMake(label1.frame.size.width+label1.frame.origin.x, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310.5/3 currentSuperviewDeviceSize:self.frame.size.width] , clearviewLabel.frame.size.height);
                            value1.frame=CGRectMake(label1.frame.size.width+label1.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20/3 currentSuperviewDeviceSize:self.frame.size.width],0,clearviewLabel.frame.size.width -  (label1.frame.size.width+label1.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:self.frame.size.width]) , clearviewLabel.frame.size.height);
                            value1.textAlignment=NSTextAlignmentCenter;
                            if(i == 2|| i == 4 || i == 6 || i == 8 || i == 0)
                            {
                                NSArray *keysTempArray=[[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:i]] componentsSeparatedByString:@","];
                                value1.text=[NSString stringWithFormat:@"%ld/%ld",(long)[[response valueForKey:[NSString stringWithFormat:@"%@",[keysTempArray objectAtIndex:0]]] integerValue],(long)[[response valueForKey:[NSString stringWithFormat:@"%@",[keysTempArray objectAtIndex:1]]] integerValue]];
                            }
                            else
                                value1.text=[NSString stringWithFormat:@"%.2f%%",[[response objectForKey:[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:i]]] doubleValue]];
                            value1.textColor=[UIColor whiteColor];
                            value1.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
                            value1.backgroundColor=[UIColor clearColor];
                            [clearviewLabel addSubview:value1];
                            
                            UIView *separatorImage=[[UIView alloc]init];
                            separatorImage.frame=CGRectMake(0,label1.frame.size.height - 0.5,clearviewLabel.frame.size.width, 0.5);
                            separatorImage.backgroundColor=separatorColor;
                            [clearviewLabel addSubview:separatorImage];
                            ycoordinate=clearviewLabel.frame.size.height+clearviewLabel.frame.origin.y;
                            
                        }
                        baseScroll.contentSize=CGSizeMake(baseScroll.frame.size.width, ycoordinate);
                    }
                    else
                    {
                        UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
                        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                        {
                            if (screenBounds.size.height == 480)
                            {
                                suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                            }
                        }
                        suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                        suggestions1.textAlignment = NSTextAlignmentCenter;
                        suggestions1.textColor = [UIColor whiteColor];
                        suggestions1.backgroundColor=[UIColor clearColor];
                        suggestions1.text = @"You have no stats. \nPlease play more games.";
                        suggestions1.numberOfLines=2;
                        suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
                        [backgroundView addSubview:suggestions1];
                        statsStatus=1;
                    }
                    [[DataManager shared]removeActivityIndicator];
                }
                else
                {
                    [[DataManager shared]removeActivityIndicator];
                    UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
                    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                    {
                        if (screenBounds.size.height == 480)
                        {
                            suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                        }
                    }
                    suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                    suggestions1.textAlignment = NSTextAlignmentCenter;
                    suggestions1.textColor = [UIColor whiteColor];
                    suggestions1.backgroundColor=[UIColor clearColor];
                    suggestions1.text = @"You have no stats. \nPlease play more games.";
                    suggestions1.numberOfLines=2;
                    suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
                    [backgroundView addSubview:suggestions1];
                    statsStatus=1;
                }

            }
            else
            {
                [[DataManager shared]removeActivityIndicator];
                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        @catch (NSException *exception) {
            [[DataManager shared]removeActivityIndicator];
            
        }
    }
    else{
        //Show Purchase screen
        UIImageView *adsBaseView=[[UIImageView alloc]initWithFrame:CGRectMake(0,ycoordinateForSectionButton, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1030/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        //    [adsBaseView setImage:[UIImage imageNamed:@"ad_banner_1.png"]];
        adsBaseView.userInteractionEnabled=YES;
        [adsBaseView setBackgroundColor:[UIColor clearColor]];
        [backgroundView addSubview:adsBaseView];
        adsImgsArray=[[NSArray alloc]initWithObjects:@"XBProBanner.jpg", nil];
        
        adsScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, adsBaseView.frame.size.height)];
        adsScroll.userInteractionEnabled = YES;
        adsScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        adsScroll.pagingEnabled=YES;
        adsScroll.backgroundColor = [UIColor clearColor];
        adsScroll.showsVerticalScrollIndicator = NO;
        
        adsScroll.showsHorizontalScrollIndicator=NO;
        adsScroll.delegate=self;
        adsScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [adsBaseView addSubview:adsScroll];
        for(int i=0;i<adsImgsArray.count;i++)
        {
            UIImageView *mainImageAdsView=[[UIImageView alloc]initWithFrame:CGRectMake(adsBaseView.frame.size.width * i, 0, adsBaseView.frame.size.width, adsBaseView.frame.size.height)];
            //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //        NSString *documentsDirectory = [paths objectAtIndex:0];
            //        NSLog(@"document directory==%@",documentsDirectory);
            //        NSString *savedGroupImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[adsImgsArray objectAtIndex:i]]];
            //        UIImage *image = [UIImage imageWithContentsOfFile:savedGroupImagePath];
            [mainImageAdsView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[adsImgsArray objectAtIndex:i]]]];
            mainImageAdsView.tag=16600+i;
            //        mainImageAdsView.userInteractionEnabled=YES;
            //        UITapGestureRecognizer  *adtapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLearnFunction:)] ;
            //        adtapRecognizer.numberOfTapsRequired = 1;
            //        [mainImageAdsView addGestureRecognizer:adtapRecognizer];
            [adsScroll addSubview:mainImageAdsView];
        }
        [adsScroll setContentSize:CGSizeMake(adsBaseView.frame.size.width*adsImgsArray.count,adsScroll.frame.size.height)];
        
        UIButton *buyNowButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], adsBaseView.frame.size.height+adsBaseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        buyNowButton.layer.cornerRadius=buyNowButton.frame.size.height/2;
        buyNowButton.clipsToBounds=YES;
        [buyNowButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:buyNowButton.frame] forState:UIControlStateNormal];
        [buyNowButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:buyNowButton.frame] forState:UIControlStateHighlighted];
        [buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        //modi
        // [buyNowButton setTitle:@"Buy Now" forState:UIControlStateNormal];
        [buyNowButton setTitle:@"Details" forState:UIControlStateNormal];
        
        [buyNowButton addTarget:self action:@selector(buyNowButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        buyNowButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [backgroundView addSubview:buyNowButton];
        
        if (subscriptionCount > 2) {
            UIView *separatorImage=[[UIView alloc]init];
            separatorImage.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], buyNowButton.frame.size.height+buyNowButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:495/3 currentSuperviewDeviceSize:screenBounds.size.width], 0.5);
            separatorImage.backgroundColor=separatorColor;
            [backgroundView addSubview:separatorImage];
            
            UILabel *orLabel=[[UILabel alloc]initWithFrame:CGRectMake(separatorImage.frame.size.width+separatorImage.frame.origin.x, separatorImage.frame.origin.y-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width])];
            orLabel.text=@"OR";
            orLabel.backgroundColor=[UIColor clearColor];
            orLabel.textColor=[UIColor whiteColor];
            orLabel.textAlignment=NSTextAlignmentCenter;
            orLabel.font=[UIFont fontWithName:AvenirDemi size:XbH2size];
            [backgroundView addSubview:orLabel];
            
            UIView *separatorImage2=[[UIView alloc]init];
            separatorImage2.frame=CGRectMake(orLabel.frame.size.width+orLabel.frame.origin.x, separatorImage.frame.origin.y,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:490/3 currentSuperviewDeviceSize:screenBounds.size.width], 0.5);
            separatorImage2.backgroundColor=separatorColor;
            [backgroundView addSubview:separatorImage2];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,orLabel.frame.size.height+orLabel.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:160/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            NSMutableAttributedString *noteAttributedString=[[NSMutableAttributedString alloc] initWithString:@"Try XB Pro Stats for 10 days," attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH3size]}];
            NSAttributedString *noteLabelText=[[NSAttributedString alloc] initWithString:@"\nAbsolutely Free!!" attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH1size]}];
            [noteAttributedString appendAttributedString:noteLabelText];
            [noteAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteAttributedString length])];
            noteLabel.attributedText=noteAttributedString;
            noteLabel.backgroundColor=[UIColor clearColor];
            noteLabel.textColor=[UIColor whiteColor];
            noteLabel.textAlignment=NSTextAlignmentCenter;
            noteLabel.numberOfLines=0;
            [backgroundView addSubview:noteLabel];
            
            UIButton *trialButton=[[UIButton alloc] init];
            trialButton.frame=CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], noteLabel.frame.size.height+noteLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height]);
            trialButton.titleEdgeInsets=UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
            trialButton.titleLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
            [trialButton setTitle:@"Start Trial Version" forState:UIControlStateNormal];
            [trialButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            trialButton.exclusiveTouch=YES;
            trialButton.layer.borderColor= [UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0].CGColor;
            trialButton.layer.borderWidth=4.0;
            [trialButton setBackgroundColor:[UIColor whiteColor]];
            trialButton.layer.cornerRadius=trialButton.frame.size.height/2;
            trialButton.clipsToBounds=YES;
            trialButton.alpha=0.8;
            [trialButton addTarget:self action:@selector(trialButtonFunction) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:trialButton];
        }
        else{
            buyNowButton.frame=CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], adsBaseView.frame.size.height+adsBaseView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height]);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],buyNowButton.frame.size.height+buyNowButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:160/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            noteLabel.backgroundColor=[UIColor clearColor];
            noteLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
            NSString *noteString= @"Your trial period is over. Please contact us to analyze your stats further.";
            NSMutableAttributedString *noteAttributedString=[[NSMutableAttributedString alloc] initWithString:noteString attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
            [noteAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteAttributedString length])];
            noteLabel.attributedText=noteAttributedString;
            noteLabel.textColor=[UIColor whiteColor];
            noteLabel.textAlignment=NSTextAlignmentCenter;
            noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
            noteLabel.numberOfLines=2;
            [backgroundView addSubview:noteLabel];

        }
    }
}

- (void)sectionFunction:(UIButton *)sender
{
    if (sender.tag != 91) {
        UISegmentedControl *segment=(UISegmentedControl *)[self viewWithTag:17000];
        [segment removeFromSuperview];
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        for (int i=0; i<3; i++) {
            UIButton *btn=(UIButton *)[self viewWithTag:90+i];
            if (btn.tag != sender.tag) {
                btn.selected=NO;
            }
            UIButton *equipmentBtn=(UIButton *)[self viewWithTag:10+i];
            if (equipmentBtn.tag != sender.tag) {
                equipmentBtn.selected=NO;
            }
            
        }
        sender.selected=YES;
    }
    if (sender.tag == 90) {
        [self myStats];
    }
    else if (sender.tag == 91) {
        [self showGraphs];
        if (!(previousStepIndex ==3 || previousStepIndex == 4)) {
            UISegmentedControl *segment=(UISegmentedControl *)[self viewWithTag:17000];
            [segment removeFromSuperview];
        }
    }
    else if (sender.tag == 92)
    {
        [self performSelector:@selector(pinStats) withObject:nil afterDelay:0.2];
    }
    else if(sender.tag == 10){
        [self performSelector:@selector(equipmentView) withObject:nil afterDelay:0.2];
    }
    else if(sender.tag == 11){
        [self performSelector:@selector(settingsView) withObject:nil afterDelay:0.2];
    }
    else if(sender.tag == 12){
        [self exportStatsView];
    }


}

- (void)buyNowButtonFunction
{
    [delegate showBuyPackageView];
}
#pragma mark - Apply Filters
- (void)applyFilters
{
    if (stepIndex == 0) {
        for(UIView *view in backgroundView.subviews)
            [view removeFromSuperview];
        UISegmentedControl *pinStatsSegment=(UISegmentedControl *)[self viewWithTag:17000];
        [pinStatsSegment removeFromSuperview];
        for (int i=0; i<3; i++) {
            UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
            [settingsSectionButton removeFromSuperview];
            UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
            [statsSectionButton removeFromSuperview];
        }
        MyGamesView *gameView = [delegate showMyGames:ycoordinateForSectionButton];
        [backgroundView addSubview:gameView];
    }
    else if (stepIndex == 1) {
        [self myStats];
    }
    else if (stepIndex == 2) {
        [self showGraphs];
    }
    else if (stepIndex == 3) {
        [self pinViewServerCall:1];
    }
    else if (stepIndex == 4){
        [self pinViewServerCall:2];
    }
}

#pragma mark - graphs
- (void)showGraphs
{
    if (maintainedPreviouStepIndex == NO) {
        previousStepIndex=stepIndex;
        maintainedPreviouStepIndex=YES;
    }
    stepIndex=2;
    [delegate showGraphsView];
    [self performSelector:@selector(deselectGraphHeader) withObject:nil afterDelay:0.3];
}

- (void)deselectGraphHeader
{
    UIButton *graphsSectionButton=(UIButton *)[self viewWithTag:91];
    [graphsSectionButton setSelected:NO];
    UIButton *statsSectionButton;
    if (previousStepIndex == 4) {
        statsSectionButton=(UIButton *)[self viewWithTag:92];
    }
    else
        statsSectionButton=(UIButton *)[self viewWithTag:90+(previousStepIndex - 1)];
    [statsSectionButton setSelected:YES];
}

- (void)graphViewRemoved
{
    stepIndex=previousStepIndex;
    maintainedPreviouStepIndex=NO;
}
#pragma mark - Pin Stats
- (void)pinStats
{
    stepIndex=3;
    //pin stats view
    [self pinViewServerCall:1];
}

- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}
#pragma mark - Start Trial
- (void)trialButtonFunction
{
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[self viewWithTag:16000];
    [segmentedControl setSelectedSegmentIndex:1];
    [delegate startTrialFunction];
}

#pragma mark - Auto Scroll Ads
-(void)autoScrollAds
{
    CGFloat width = adsScroll.frame.size.width;
    adIndex = (adsScroll.contentOffset.x + (0.5f * width)) / width;
    
    if(adIndex < adsImgsArray.count - 1)
    {
        adIndex++;
        [adsScroll setContentOffset:CGPointMake(adsScroll.frame.size.width*adIndex, 0) animated:YES];
    }
    else
    {
        adIndex=0;
        [adsScroll setContentOffset:CGPointMake(adsScroll.frame.size.width*0, 0) animated:NO];
    }
    CGFloat width2 = adsScroll.frame.size.width;
    adIndex = (adsScroll.contentOffset.x + (0.5f * width2)) / width2;
    
    [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(autoScrollAds) withObject:nil afterDelay:5.0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(autoScrollAds)
                                               object:nil];
}

#pragma mark - Filter View
- (void)filterButtonFunction
{
    if (stepIndex > 0) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased]) {
            [delegate showFilterViewforSection:@"XBPro"];
        }
    }
    else{
        [delegate showFilterViewforSection:@"MyGames"];
    }
    
}

#pragma mark - Compare Section
-(void)comparisonSubview:(UIButton *)sender
{
    if(statsStatus == 1)
    {
        UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if (screenBounds.size.height == 480)
            {
                suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            }
        }
        suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        suggestions1.textAlignment = NSTextAlignmentCenter;
        suggestions1.textColor = [UIColor whiteColor];
        suggestions1.backgroundColor=[UIColor clearColor];
        suggestions1.text = @"You have no stats. \nPlease play more games.";
        suggestions1.numberOfLines=2;
        suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
        [backgroundView addSubview:suggestions1];
        statsStatus=1;

    }
    else
    {
        allxbowlers=YES;
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        
        for(UIView *view in backgroundView.subviews)
            [view removeFromSuperview];

        //compare view
        
        if (self.frame.size.width == 480)
        {
            comparisonWithImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, ycoordinateForSectionButton, backgroundView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        }
        else
            comparisonWithImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, ycoordinateForSectionButton, backgroundView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        if(selectedComparisonType == 0)
        {
            comparisonWithImageView.textLabel.text = @"Compare With: Individual Users";
        }
        else
        {
            comparisonWithImageView.textLabel.text = @"Compare With: All XBowlers";
        }
        comparisonWithImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [comparisonWithImageView addGestureRecognizer:tapRecognizer];
        [backgroundView addSubview:comparisonWithImageView];
        UIView *separatorImage=[[UIView alloc]init];
        separatorImage.frame=CGRectMake(0, 0, self.frame.size.width, 0.5);
        separatorImage.tag=100;
        separatorImage.backgroundColor=separatorColor;
        [comparisonWithImageView addSubview:separatorImage];
        if(selectedComparisonType == 0)
        {
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"All XBowlers",@"My Friends",  nil];
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
            segmentedControl.tag=15000;
            segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:171/3 currentSuperviewDeviceSize:screenBounds.size.width], comparisonWithImageView.frame.size.height+comparisonWithImageView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
            segmentedControl.selectedSegmentIndex = 1;
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil];
            [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
             [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 1) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
            NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                                  nil];
            [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
            //        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
            [backgroundView addSubview:segmentedControl];
            
            UIView *separatorImage=[[UIView alloc]init];
            separatorImage.frame=CGRectMake(0, segmentedControl.frame.size.height+segmentedControl.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, 0.5);
            separatorImage.tag=101;
            separatorImage.backgroundColor=separatorColor;
            [backgroundView addSubview:separatorImage];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            UIImageView *searchIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            searchIcon.center=CGPointMake(searchIcon.center.x, paddingView.frame.size.height/2-1);
            [searchIcon setImage:[UIImage imageNamed:@"search_icon.png"]];
            [paddingView addSubview:searchIcon];
            searchchBar = [[UITextField alloc] initWithFrame:CGRectMake(0,separatorImage.frame.size.height+separatorImage.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            searchchBar.tag=1550;
            searchchBar.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.4];
            searchchBar.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
            searchchBar.textColor=[UIColor whiteColor];
            //        if(showfriends == NO)
            //        {
            //            allXBowlersBtn.selected=YES;
            //        }
            //        else
            //        {
            //            myFriendsBtn.selected=YES;
            //
            //        }
            //        if (search) {
            //            searchchBar.text=[NSString stringWithFormat:@"%@",search];
            //            [searchchBar becomeFirstResponder];
            //        }
            searchchBar.placeholder = @"Search";
            searchchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            searchchBar.keyboardType = UIKeyboardTypeDefault;
            searchchBar.returnKeyType = UIReturnKeyDone;
            searchchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
            searchchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            searchchBar.delegate = self;
            searchchBar.leftView = paddingView;
            searchchBar.leftViewMode = UITextFieldViewModeAlways;
            searchchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchchBar.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:AvenirRegular size:XbH1size]}];
            [backgroundView addSubview:searchchBar];
            [searchchBar endEditing:YES];
            
            UIView *separatorImage2=[[UIView alloc]init];
            separatorImage2.tag=102;
            separatorImage2.frame=CGRectMake(0, searchchBar.frame.size.height+searchchBar.frame.origin.y-1, self.frame.size.width, 0.5);
            separatorImage2.backgroundColor=separatorColor;
            [backgroundView addSubview:separatorImage2];
            //NSString *allxbowlers;
//            [self getAllXBowlers:btnsBaseImagecompare stringbowlers:nil];
            [self friendbuttonAction:myFriendsBtn];
        }
        else
        {
            if([countryInfoDict count] == 0){
            [self venueInfo];
            if ([countryInfoDict count]>0) {
                [self selectCenter];
            }
            }
            [[DataManager shared]removeActivityIndicator];
            UIView *centersBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,comparisonWithImageView.frame.size.height+comparisonWithImageView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170+10 currentSuperviewDeviceSize:screenBounds.size.height])];
            centersBackgroundView.backgroundColor=[UIColor clearColor];
            centersBackgroundView.userInteractionEnabled=YES;
//            centersBackgroundView.center=CGPointMake(centersBackgroundView.center.x,self.center.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]+comparisonWithImageView.frame.size.height);
            [backgroundView addSubview:centersBackgroundView];
            selectCountryImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
          
            selectStateImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0,selectCountryImageView.frame.size.height + selectCountryImageView.frame.origin.y, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
          
            selectCenterImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0,selectStateImageView.frame.size.height + selectStateImageView.frame.origin.y , self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
           
            if ([countryInfoDict count]>0) {
                selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
            }
            else{
                selectCountryImageView.textLabel.text = @"Select Country";
            }
            selectCountryImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer  *CountrytapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
            CountrytapRecognizer.numberOfTapsRequired = 1;
            [selectCountryImageView addGestureRecognizer:CountrytapRecognizer];
            [centersBackgroundView addSubview:selectCountryImageView];
            
            if ([countryInfoDict count] >0 && [[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count]>0) {
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
            }
            else{
                selectStateImageView.textLabel.text = @"Select State";
            }
            selectStateImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer  *StatetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
            StatetapRecognizer.numberOfTapsRequired = 1;
            [selectStateImageView addGestureRecognizer:StatetapRecognizer];
            [centersBackgroundView addSubview:selectStateImageView];
            
            if ([centerDetails count] >0) {
                selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
            }
            else{
                selectCenterImageView.textLabel.text = @"Select Center";
            }
            selectCenterImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer  *CentertapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
            CentertapRecognizer.numberOfTapsRequired = 1;
            [selectCenterImageView addGestureRecognizer:CentertapRecognizer];
            [centersBackgroundView addSubview:selectCenterImageView];
            
            makeComparison=[[UIButton alloc]init];
            makeComparison.tag=15000;
            makeComparison.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
            [makeComparison setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
            [makeComparison setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
            [makeComparison addTarget:self action:@selector(makecomparisonButtonFunction) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:makeComparison];
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, makeComparison.frame.size.width, makeComparison.frame.size.height)];
            titleLabel.textColor=[UIColor whiteColor];
            titleLabel.text=@"      Make Comparison";
            titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height] ];
            [makeComparison addSubview:titleLabel];
            
            UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(makeComparison.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
            arrow.tag=902;
            arrow.center=CGPointMake(arrow.center.x, makeComparison.frame.size.height/2);
            [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
            [makeComparison addSubview:arrow];

            
        }
    }
}

-(void)resetFiltersFunction
{
    selectedCountryIndex = 0;
    selectedStateIndex = 0;
    selectedCenterIndex = 0;
    selectedGameType=0;
    selectedOilPattern=0;
    selectedPatternLength=0;
    countryInfoDict=nil;
    countryInfoDict = [NSArray new];
    centerDetails=nil;
    centerDetails = [NSArray new];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kfilterVenueId];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:koilPattern];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kpatternLength];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"0"] forKey:kGameType];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kfilterTag];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:kduration];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterCountryIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterStateIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kfilterVenueIndex];
    [equipmentTableView reloadData];

}

#pragma mark - Function to show filled pins
-(void)pinViewServerCall:(int)type
{
    pinViewJsonArray=[NSMutableArray new];
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    //current date
    NSDate *currentDate=[NSDate date];
    NSLog(@"currentDate=%@",currentDate);
    NSString *format=@"MM/dd/yyyy";
    NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
    NSString *displayDate=[formatterUtc stringFromDate:currentDate];
    NSLog(@"displayDate=%@",displayDate);
    
    NSString *params= [[NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&Tag=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate,[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@"All Tags"] || [[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@""]) {
        params= [NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate];
    }

    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:@"UserStat/BowlingGameUserPinDetail" contentType:@"" httpMethod:@"GET"];
    NSArray *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(response.count > 0)
        {
            pinViewJsonArray=[NSMutableArray arrayWithArray:response];
            if(type == 1)
                [self pinView];
            else
                [self listView];
        }
        else
        {
            UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
            if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if (screenBounds.size.height == 480)
                {
                    suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                }
            }
            suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            suggestions1.textAlignment = NSTextAlignmentCenter;
            suggestions1.textColor = [UIColor whiteColor];
            suggestions1.backgroundColor=[UIColor clearColor];
            suggestions1.text = @"You have no stats. \nPlease play more games.";
            suggestions1.numberOfLines=2;
            suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
            [backgroundView addSubview:suggestions1];
            statsStatus=1;
        }
        [[DataManager shared]removeActivityIndicator];

    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }

}

-(void)pinView
{
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Pin View",@"List View", nil];
    UISegmentedControl *segmentedControl=(UISegmentedControl *)[self viewWithTag:17000];
    [segmentedControl removeFromSuperview];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.tag=17000;
    segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(185+40)/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1140/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.center=CGPointMake(self.center.x, segmentedControl.center.y);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 1) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    //        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    [self addSubview:segmentedControl];
    
    UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, segmentedControl.frame.size.height+segmentedControl.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    noteLabel.text=@"   Single Pin Spare";
    noteLabel.textColor=[UIColor whiteColor];
    noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
    [backgroundView addSubview:noteLabel];

    
    UIScrollView *baseScroll=[[UIScrollView alloc]init];
    baseScroll.frame=CGRectMake(2.5, noteLabel.frame.size.height+noteLabel.frame.origin.y, backgroundView.frame.size.width - 5, self.frame.size.height - (segmentedControl.frame.size.height+segmentedControl.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    baseScroll.backgroundColor=[UIColor clearColor];
    baseScroll.scrollEnabled=YES;
    baseScroll.userInteractionEnabled=YES;
    [backgroundView addSubview:baseScroll];

    UIView *pinsView=[self filledPinsView];
    pinsView.userInteractionEnabled=YES;
    [baseScroll addSubview:pinsView];
    
    baseScroll.contentSize=CGSizeMake(baseScroll.frame.size.width, pinsView.frame.size.height+pinsView.frame.origin.y);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%ld",(long)touch.view.tag);
}

-(UIView *)filledPinsView
{
    UIView *pinsBackgroundView=[[UIView alloc]init];
    pinsBackgroundView.tag=2300;
    pinsBackgroundView.backgroundColor=[UIColor clearColor];
    pinsBackgroundView.frame=CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, backgroundView.frame.size.width -  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:160/3 currentSuperviewDeviceSize:screenBounds.size.width],400);

        int number_of_stars = 4;
        int yForStar = 6;
        int xForStar = 0;
        int pinIndex = 7;
        for (int rows=1; rows <= 4; rows++)
        {
            xForStar=((pinsBackgroundView.frame.size.width)-(37*number_of_stars + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:self.frame.size.width]*(number_of_stars-1)))/2 ;
            for (int star=4; star >= rows; star--) // for loop for pins
            {
                //base view for bottle and label
                UIView *starView=[[UIView alloc]init];
                starView.frame=CGRectMake(xForStar,yForStar,37, 123/2 + 25);
                starView.backgroundColor=[UIColor clearColor];
                [pinsBackgroundView addSubview:starView];
                printf(" ");
                // empty bottle (base image of bottle)
                UIImageView *bottle2=[[UIImageView alloc]initWithFrame:CGRectMake(5,0, 25, 123/2)];
                [bottle2 setImage:[UIImage imageNamed:@"empty_pin.png"]];
                [starView addSubview:bottle2];
                
                //filled bottle added as subview to base bottle
                NSLog(@"index=%d ",pinIndex);
                float filledPercent=[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePinPercentage%d",pinIndex]] floatValue]/100;
                NSLog(@"filledPercent=%f ",filledPercent);
                float percent = 1 - filledPercent;       //when 45% of bottle is filled
                int heightOfFilledBottle = bottle2.frame.size.height - (bottle2.frame.size.height*percent);
                UIImageView *iView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottle2.frame.size.height - heightOfFilledBottle, 25, heightOfFilledBottle)];
                //to get the 45% portion of completely filled bottle
                CGRect contentFrame = CGRectMake(0,percent, 1, 1-percent);
                iView.layer.contentsRect = contentFrame;
                iView.image = [UIImage imageNamed:@"filled_pin.png"];
                [bottle2 addSubview:iView];
                
                UILabel *percentLabel=[[UILabel alloc]init];
                percentLabel.frame=CGRectMake(-1, bottle2.frame.size.height, starView.frame.size.width+6, 35);
                //            percentLabel.text=[NSString stringWithFormat:@"%d",bottleIndex];
                [percentLabel setBackgroundColor:[UIColor clearColor]];
                NSNumberFormatter *formatterfloat = [[NSNumberFormatter alloc] init];
                [formatterfloat setNumberStyle:NSNumberFormatterDecimalStyle];
                [formatterfloat setMaximumFractionDigits:2];
                [formatterfloat setAllowsFloats:YES];
                float percentageValue=[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePinPercentage%d",pinIndex]] floatValue];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:4];
                NSMutableAttributedString *percentString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f%% \n%ld/%ld",percentageValue,(long)[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePincount%d",pinIndex]] integerValue],(long)[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePinChancecount%d",pinIndex]] integerValue]]];
                [percentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [percentString length])];
                percentLabel.attributedText=percentString;
                percentLabel.textColor=[UIColor whiteColor];
                percentLabel.textAlignment=NSTextAlignmentCenter;
                percentLabel.numberOfLines=2;
                percentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                percentLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                [starView addSubview:percentLabel];

                xForStar= starView.frame.size.width + starView.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:self.frame.size.width] ;
                pinIndex++;
            }
            //coordinates for next row
            yForStar=yForStar + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20 currentSuperviewDeviceSize:self.frame.size.height] +123/2;
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

    return pinsBackgroundView;
}

-(void)listView
{
    stepIndex=4;
//    [self pinViewServerCall:2];
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];

    NSArray *itemArray = [NSArray arrayWithObjects: @"Pin View",@"List View", nil];
    UISegmentedControl *segmentedControl=(UISegmentedControl *)[self viewWithTag:17000];
    [segmentedControl removeFromSuperview];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.tag=17000;
    segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(185+40)/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1140/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    segmentedControl.center=CGPointMake(self.center.x, segmentedControl.center.y);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 1) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    //        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    [self addSubview:segmentedControl];

    sectionHeaderArray=[[NSMutableArray alloc]initWithObjects:@"Single Pin Spares",@"Multi Pin Spares",@"Splits", nil];
    int yForTable= ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(185+80+150)/3 currentSuperviewDeviceSize:screenBounds.size.height];
    if (openSectionsArray.count > 0) {
        [openSectionsArray removeAllObjects];
    }
     ExpandableTableView *listTableView=[[ExpandableTableView alloc]initWithFrame:CGRectMake(0,yForTable,self.frame.size.width,self.frame.size.height - yForTable) style:UITableViewStyleGrouped];
    listTableView.backgroundColor=[UIColor clearColor];
    listTableView.tag=11000;
    [listTableView setDataSource:self];
    [listTableView setDelegate:self];
    listTableView.expandableTableDelegate=self;
    listTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [backgroundView addSubview:listTableView];
}

#pragma mark - Settings View Functions
- (void)settingsButtonFunction
{
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    NSArray *sectionLabelArray=[[NSArray alloc]initWithObjects:@"Equipment Settings",@"Other Settings",@"Export Stats", nil];
    int xcoordinate=0;
    int ycoordinate=ycoordinateForSectionButton;
    UIButton *sectionButton;
    for (int i=0; i<3; i++) {
        UIButton *settingsSectionButton=(UIButton *)[self viewWithTag:10+i];
        [settingsSectionButton removeFromSuperview];
        UIButton *statsSectionButton=(UIButton *)[self viewWithTag:90+i];
        [statsSectionButton removeFromSuperview];

        sectionButton=[[UIButton alloc]init];
        sectionButton.frame=CGRectMake(xcoordinate, ycoordinate, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:406/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:185/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        sectionButton.tag=10+i;
        sectionButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        sectionButton.titleLabel.numberOfLines=2;
        sectionButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        sectionButton.titleLabel.textColor=[UIColor whiteColor];
        sectionButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        
        NSMutableAttributedString *titleString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[sectionLabelArray objectAtIndex:i]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [titleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleString length])];
        [sectionButton setAttributedTitle:titleString forState:UIControlStateNormal];
        [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithWhite:0 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateNormal];
        [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateHighlighted];
        [sectionButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.3] buttonframe:sectionButton.frame] forState:UIControlStateSelected];
        [sectionButton addTarget:self action:@selector(sectionFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sectionButton];
        if (i == 0) {
            sectionButton.selected=YES;
        }
        xcoordinate=sectionButton.frame.size.width+sectionButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width];
    }
    ycoordinate=sectionButton.frame.origin.y+sectionButton.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
    [self equipmentView];
}

-(void)settingsView
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/UserStatSettingsList" contentType:@"" httpMethod:@"GET"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    //    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    //    {
    [[DataManager shared]removeActivityIndicator];
    if(response.count > 0)
    {
        if([[response objectForKey:@"ballType"] integerValue] == 0)
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kBallTypeBoolean];
        else
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kBallTypeBoolean];
        if([[response objectForKey:@"pocketPercentage"] integerValue] == 0)
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kPocketBrooklynBoolean];
        else
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPocketBrooklynBoolean];
        if([[response objectForKey:@"oilPattern"] integerValue] == 0)
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kOilPatternBoolean];
        else
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kOilPatternBoolean];
        
    }
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    
    
    
    UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(185+20)/3 currentSuperviewDeviceSize:screenBounds.size.height],backgroundView.frame.size.width, 40)];
    suggestions1.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
//    suggestions1.textAlignment = NSTextAlignmentCenter;
    suggestions1.textColor = [UIColor whiteColor];
    suggestions1.backgroundColor=[UIColor clearColor];
    NSString *subscriptionstring=[self getRemainingdays];
    if ([subscriptionstring isEqualToString:@"0.00"]) {
        subscriptionstring=@"";
    }
    suggestions1.text =[NSString  stringWithFormat:@"%@ %@", @"   Your Subscription ends on:",subscriptionstring];
    suggestions1.numberOfLines=0;
    suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
    [backgroundView addSubview:suggestions1];
    
    UIButton *extendDesriptionBtn=[[UIButton alloc] init];
    extendDesriptionBtn.frame=CGRectMake(backgroundView.frame.size.width - (150+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width]),suggestions1.frame.origin.y+suggestions1.frame.size.height, 150,26);
    extendDesriptionBtn.layer.cornerRadius=extendDesriptionBtn.frame.size.height/2;
    extendDesriptionBtn.contentEdgeInsets=UIEdgeInsetsMake(2.5, 0.0, 0.0, 0.0);
    [extendDesriptionBtn setTitle: @"Extend Subscription" forState: UIControlStateNormal];
    extendDesriptionBtn.layer.masksToBounds=YES;
    extendDesriptionBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
    [extendDesriptionBtn setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:extendDesriptionBtn.frame] forState:UIControlStateNormal];
    [extendDesriptionBtn setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:extendDesriptionBtn.frame] forState:UIControlStateHighlighted];
    [extendDesriptionBtn addTarget:self action:@selector(buyNowButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:extendDesriptionBtn];
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (screenBounds.size.height == 480)
        {
            suggestions1.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
            suggestions1.frame= CGRectMake(14.2,ycoordinateForSectionButton,245, 20);
            extendDesriptionBtn.frame=CGRectMake(backgroundView.frame.size.width - 155,suggestions1.frame.origin.y, 135,24);
            extendDesriptionBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
        }
    }
    
    UIScrollView *baseScroll=[[UIScrollView alloc]init];
    baseScroll.frame=CGRectMake(2.5,extendDesriptionBtn.frame.origin.y+extendDesriptionBtn.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], backgroundView.frame.size.width - 5, self.frame.size.height - (extendDesriptionBtn.frame.size.height + extendDesriptionBtn.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(130+58.5)/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    baseScroll.contentSize = CGSizeMake(250,0);
    baseScroll.backgroundColor=[UIColor clearColor];
    [backgroundView addSubview:baseScroll];
    
    UILabel *questionLabel;
    float ycordinate=10;
    int btnTag=0;;
    NSArray *yesnoArray=[[NSArray alloc]initWithObjects:@"Yes",@"No", nil];
    for(int item_count=0;item_count<3;item_count++)
    {
        questionLabel=  [[UILabel alloc] init ];//WithFrame:CGRectMake(0,1.5,340, 24)];
        questionLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
        questionLabel.layer.masksToBounds=YES;
        questionLabel.textColor=[UIColor whiteColor];
        questionLabel.textAlignment = NSTextAlignmentLeft;
        questionLabel.backgroundColor=[UIColor clearColor];
        questionLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],ycordinate,baseScroll.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        questionLabel.numberOfLines=4;
        questionLabel.lineBreakMode=NSLineBreakByWordWrapping;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        NSString *question;
        if(item_count == 0)
            question=@"Do you want to track your scores based on Ball Type?";
        else if(item_count == 1)
            question=@"Do you want to track your score based on Oil Pattern?";
        else
            question = @"Do you want to track your Pocket/Brooklyn percentage?";
        NSMutableAttributedString *questionString=[[NSMutableAttributedString alloc]initWithString:question];
        [questionString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [questionString length])];
        questionLabel.attributedText=questionString;
        [baseScroll addSubview:questionLabel];
        checkboxOfFilter=NO;
        float xCoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width];
        for(int i=0;i<2;i++)
        {
            UIButton *baseBtn=[[UIButton alloc]init];
            baseBtn.tag=(item_count+1)*100 + i;
            baseBtn.backgroundColor=[UIColor clearColor];
            baseBtn.frame=CGRectMake(xCoordinate, questionLabel.frame.size.height+questionLabel.frame.origin.y, 30, 27);
            [baseBtn addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
            [baseScroll addSubview:baseBtn];
            
            UIImageView *checkBox=[[UIImageView alloc]init];
            checkBox.frame=CGRectMake(3, 1, 22, 20.5);
            checkBox.tag=5*baseBtn.tag;
            [checkBox setImage:[UIImage imageNamed:@"check_off.png"]];
            if(i == 1)
                [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
            [baseBtn addSubview:checkBox];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(xCoordinate+30, baseBtn.frame.origin.y-1, 50, 27);
            label.textColor=[UIColor whiteColor];
            label.text=[yesnoArray objectAtIndex:i];
            label.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
            [baseScroll addSubview:label];
            
            btnTag++;
            xCoordinate=self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+ 90);
        }
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean])
        {
            UIImageView *checkBox=(UIImageView *)[baseScroll viewWithTag:5*((0+1)*100 + 0)];
            [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
            [checkBox setAccessibilityIdentifier:@"YES"];
            UIImageView *checkBox2=(UIImageView *)[baseScroll viewWithTag:5*((0+1)*100 + 1)];
            [checkBox2 setImage:[UIImage imageNamed:@"check_off.png"]];
            [checkBox2 setAccessibilityIdentifier:@"NO"];
        }
        if([[NSUserDefaults standardUserDefaults]boolForKey:kOilPatternBoolean])
        {
            UIImageView *checkBox=(UIImageView *)[baseScroll viewWithTag:5*((1+1)*100 + 0)];
            [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
            [checkBox setAccessibilityIdentifier:@"YES"];
            UIImageView *checkBox2=(UIImageView *)[baseScroll viewWithTag:5*((1+1)*100 + 1)];
            [checkBox2 setImage:[UIImage imageNamed:@"check_off.png"]];
            [checkBox2 setAccessibilityIdentifier:@"NO"];
            
        }
        if([[NSUserDefaults standardUserDefaults]boolForKey:kPocketBrooklynBoolean])
        {
            UIImageView *checkBox=(UIImageView *)[baseScroll viewWithTag:5*((2+1)*100 + 0)];
            [checkBox setImage:[UIImage imageNamed:@"check_on.png"]];
            [checkBox setAccessibilityIdentifier:@"YES"];
            UIImageView *checkBox2=(UIImageView *)[baseScroll viewWithTag:5*((2+1)*100 + 1)];
            [checkBox2 setImage:[UIImage imageNamed:@"check_off.png"]];
             [checkBox setAccessibilityIdentifier:@"NO"];
        }
        
        ycordinate=questionLabel.frame.size.height+questionLabel.frame.origin.y+27+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height];
        
    }
    baseScroll.contentSize=CGSizeMake(baseScroll.frame.size.width, ycordinate);
    
//    UIButton *saveBtn=[[UIButton alloc]init];
//    saveBtn.frame=CGRectMake(190, baseScroll.frame.size.height + baseScroll.frame.origin.y + 5, 288/2, 97/2);
//    [saveBtn setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:saveBtn.frame] forState:UIControlStateNormal];
//    saveBtn.center=CGPointMake(self.center.x, saveBtn.center.y);
//    [saveBtn setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:saveBtn.frame] forState:UIControlStateHighlighted];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
//    [saveBtn addTarget:self action:@selector(saveSettingsFunction) forControlEvents:UIControlEventTouchUpInside];
//    [backgroundView addSubview:saveBtn];
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame=CGRectMake(0,backgroundView.frame.size.height -  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
    [saveBtn setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveSettingsFunction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, saveBtn.frame.size.width, saveBtn.frame.size.height)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"     Save";
    titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height] ];
    [saveBtn addSubview:titleLabel];
    [backgroundView addSubview:saveBtn];

}

-(void)exportStatsView
{
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    
    int yCoordinate=ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(160+150)/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i=0; i<3; i++)
    {
        UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(15,yCoordinate,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:570/3 currentSuperviewDeviceSize:screenBounds.size.height], 40)];
        suggestions1.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
        suggestions1.textAlignment = NSTextAlignmentLeft;
        suggestions1.textColor = [UIColor whiteColor];
        suggestions1.backgroundColor=[UIColor clearColor];
        if(i == 0)
            suggestions1.text =@"Export all User Stats:";
        else if(i == 1)
            suggestions1.text =@"Reset all User Stats:";
        else
            suggestions1.text = @"Share on Facebook:";
        suggestions1.numberOfLines=0;
        suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
        [backgroundView addSubview:suggestions1];
        
        UIButton *exportStatsButton=[[UIButton alloc] init];
        exportStatsButton.frame=CGRectMake(backgroundView.frame.size.width - 150,suggestions1.frame.origin.y, 130,38);
        exportStatsButton.tag=700+i;
        exportStatsButton.layer.cornerRadius=exportStatsButton.frame.size.height/2;
        //        exportStatsButton.layer.shadowColor = [UIColor blackColor].CGColor;
        //        exportStatsButton.layer.shadowOpacity = 1.0;
        //        exportStatsButton.layer.shadowRadius = 15;
        //        exportStatsButton.layer.shadowOffset = CGSizeMake(15.0f, 15.0f);
        if(i == 0)
        {
            [exportStatsButton setTitle: @"Export User Stats" forState: UIControlStateNormal];
            exportStatsButton.backgroundColor=[UIColor colorWithRed:246.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:0.5];
            [exportStatsButton addTarget:self action:@selector(exportUserStatsFunction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if (i == 1)
        {
            [exportStatsButton setTitle: @"Reset User Stats" forState: UIControlStateNormal];
            exportStatsButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:0.5];
            [exportStatsButton addTarget:self action:@selector(exportUserStatsFunction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [exportStatsButton setTitle: @"Facebook Share" forState: UIControlStateNormal];
            exportStatsButton.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:255.0/255.0 alpha:0.5];
            [exportStatsButton addTarget:self action:@selector(facebookPostFunction) forControlEvents:UIControlEventTouchUpInside];
        }
        exportStatsButton.layer.masksToBounds=YES;
        exportStatsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        exportStatsButton.userInteractionEnabled=YES;
        [backgroundView addSubview:exportStatsButton];
        
        yCoordinate=exportStatsButton.frame.size.height+exportStatsButton.frame.origin.y+15;
    }
    
}


-(void)exportUserStatsFunction:(UIButton *)sender
{
    if(statsStatus == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You have no stats." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(sender.tag == 700)
        {
            //export stats
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to export user stats to your email id?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert setTag:sender.tag];
            [alert show];
            
        }
        else if(sender.tag == 701)
        {
            //reset stats
            NSString *text = @"Note: This would delete your stats and no stats would be shown here. All these stats would be emailed to you for future reference.";
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do you want to reset your stats?" message:text delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert setTag:sender.tag];
            [alert show];
            
        }
        
    }
}

-(void)exportStatsServerCall:(int)option
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSString *resetBool;
    NSString *mailBool;
    if(option == 3)
    {
        resetBool=@"true";
        mailBool=@"true";
    }
    else
    {
        resetBool=@"false";
        if(option == 1)
        {
            mailBool=@"false";
        }
        else
        {
            mailBool=@"true";
        }
    }
    NSString *params= [NSString stringWithFormat:@"reset=%@&mailtouser=%@&",resetBool,mailBool];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:@"UserStat/ExportToExcelFile" contentType:@"" httpMethod:@"GET"];
    NSString *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict for export stats=%@",response);
    [[DataManager shared]removeActivityIndicator];
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(option == 3)
        {
            statsStatus=1;
            [[[UIAlertView alloc]initWithTitle:@"" message:@"Stats have been reset." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else
        {
            NSURL  *url = [NSURL URLWithString:[response stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                    [[[UIAlertView alloc]initWithTitle:@"" message:@"Stats sent to your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            statsStatus=0;
        }
    }
}

- (NSString *)getRemainingdays
{
    
    NSString *responseString=@"";
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];

        NSString *urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,@"UserStat/RemainingDays",token,APIKey];
        
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        
        
        
        NSLog(@"requestURL=%@",urlString);
        
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",@"GET"]];
        
        
        
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        
        responseString=[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
    }
    
    
    
    return responseString;
    
}


-(void)saveSettingsFunction
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSString *ballTypeBool, *oilPatternBool, *pocketBool;
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean])
    {
        ballTypeBool=@"true";
    }
    else
        ballTypeBool=@"false";
    if([[NSUserDefaults standardUserDefaults]boolForKey:kPocketBrooklynBoolean])
    {
        pocketBool=@"true";
    }
    else
        pocketBool=@"false";
    if([[NSUserDefaults standardUserDefaults]boolForKey:kOilPatternBoolean])
    {
        oilPatternBool=@"true";
    }
    else
        oilPatternBool=@"false";

    NSString *params=[NSString stringWithFormat:@"BallType=%@&OilPattern=%@&Pocket_BrooklynPercentage=%@&",ballTypeBool,oilPatternBool,pocketBool];
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:@"UserStat/CreateUserStatSettings" contentType:@"" httpMethod:@"POST"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 201 && response.count > 0)
    {
        [[DataManager shared]removeActivityIndicator];
         [[[UIAlertView alloc]initWithTitle:@"" message:@"Settings successfully saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }

}

-(void)checkboxSelected:(UIButton *)sender
{
//    if(checkboxOfFilter == YES)
//    {
//        for (int i=0; i<3; i++)
//        {
//            if(sender.tag == 100 + i)
//            {
//                if(![sender isSelected])
//                {
//                    UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                    [btn setImage:[UIImage imageNamed:@"check_on.png"]];
//                    sender.selected=YES;
//                }
//                else
//                {
//                    UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                    [btn setImage:[UIImage imageNamed:@"check_off.png"]];
//                    sender.selected=NO;
//                }
//                
//            }
//            else
//            {
//                UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                [btn setImage:[UIImage imageNamed:@"check_off.png"]];
//            }
//        }
//        int check =sender.tag%100;
//        if(check == 0)
//        {
//            [[NSUserDefaults standardUserDefaults]setValue:@"week" forKey:kDuration];
//        }
//        else if (check ==1)
//            [[NSUserDefaults standardUserDefaults]setValue:@"month" forKey:kDuration];
//        else
//            [[NSUserDefaults standardUserDefaults]setValue:@"year" forKey:kDuration];
//    }
//    else
//    {
//        for (int i=0; i<2; i++)
//        {
//            if(sender.tag == (6500 + i))
//            {
//                if(![sender isSelected])
//                {
//                    UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                    [btn setImage:[UIImage imageNamed:@"check_on.png"]];
//                    sender.selected=YES;
//                }
//                else
//                {
//                    UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                    [btn setImage:[UIImage imageNamed:@"check_off.png"]];
//                    sender.selected=NO;
//                }
//                
//            }
//            else
//            {
//                UIImageView *btn= (UIImageView *)[self viewWithTag:(6600 + i)];
//                [btn setImage:[UIImage imageNamed:@"check_off.png"]];
//            }
//        }
//        
//        int check =sender.tag%100;
//        BOOL value=(check == 0 ? true : false);
//        NSLog(@"value = %d",value);
//        
//        int questionNumber=sender.tag/100;
//        if(questionNumber == 1)
//            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kBallTypeBoolean];
//        else if(questionNumber == 2)
//            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kOilPatternBoolean];
//        else
//            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kPocketBrooklynBoolean];
//
//    }
    
    
//    UIImageView *otherBtn= (UIImageView *)[self viewWithTag:sender.tag*5];
//    [otherBtn setImage:[UIImage imageNamed:@"check_on.png"]];
    
    if(checkboxOfFilter == YES)
    {
        for(int i=0;i<4;i++)
        {
            UIImageView *btn= (UIImageView *)[self viewWithTag:(100 + i)*5];
            [btn setImage:[UIImage imageNamed:@"check_off.png"]];
        }
        
        UIImageView *btn= (UIImageView *)[self viewWithTag:sender.tag*5];
        [btn setImage:[UIImage imageNamed:@"check_on.png"]];

        int check =sender.tag%100;
        if(check == 0)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"daily" forKey:kduration];
        }
        else if (check ==1)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"week" forKey:kduration];
        }
        else if (check ==2)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"month" forKey:kduration];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"year" forKey:kduration];
        }
    }
    else
    {
        int questionNo=(int)sender.tag/100;
        for(int i=0;i<2;i++)
        {
            UIImageView *btn= (UIImageView *)[self viewWithTag:(questionNo*100 + i)*5];
            [btn setImage:[UIImage imageNamed:@"check_off.png"]];
        }
        
        UIImageView *btn= (UIImageView *)[self viewWithTag:sender.tag*5];
        [btn setImage:[UIImage imageNamed:@"check_on.png"]];

        int check =sender.tag%100;
        BOOL value=(check == 0 ? true : false);
        NSLog(@"value = %d",value);
        
        int questionNumber=(int)sender.tag/100;
        if(questionNumber == 1)
            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kBallTypeBoolean];
        else if(questionNumber == 2)
            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kOilPatternBoolean];
        else
            [[NSUserDefaults standardUserDefaults]setBool:value forKey:kPocketBrooklynBoolean];
    }

}

- (void)equipmentView
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    heightOfCellArray=[NSMutableArray new];
    equipmentDetailDictionary=[NSMutableDictionary new];
    [self getBowlNamesList];
    [self getPatternNamesList];
    [[DataManager shared]removeActivityIndicator];
    for(UIView *view in backgroundView.subviews)
        [view removeFromSuperview];
    
    sectionHeaderArray=[[NSMutableArray alloc]initWithObjects:@"Bowling Ball Name",@"Pattern Name", nil];
    NSLog(@"sectionHeade2r=%@",sectionHeaderArray);
    if (openSectionsArray.count > 0) {
        [openSectionsArray removeAllObjects];
    }
    equipmentTableView=[[ExpandableTableView alloc]initWithFrame:CGRectMake(0,ycoordinateForSectionButton+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(185 + 40)/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width,self.frame.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:350/3 currentSuperviewDeviceSize:self.frame.size.height])) style:UITableViewStyleGrouped];
    equipmentTableView.tag=11001;
    equipmentTableView.backgroundColor=[UIColor clearColor];
    [equipmentTableView setDataSource:self];
    [equipmentTableView setDelegate:self];
    equipmentTableView.expandableTableDelegate=self;
    equipmentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [backgroundView addSubview:equipmentTableView];

}

-(void)getPatternNamesList
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/UserStatPatternNameListByUser" contentType:@"" httpMethod:@"GET"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(response)
        {
            [equipmentDetailDictionary setValue:response forKeyPath:@"PatternNames"];
            [heightOfCellArray addObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"PatternNames"] count]*29 + 29]];

        }
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];

    }
    
}

-(void)getBowlNamesList
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/BowlingBallNamesList" contentType:@"" httpMethod:@"GET"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(response)
        {
            [equipmentDetailDictionary setValue:response forKeyPath:@"BowlNames"];
            [heightOfCellArray addObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"BowlNames"] count]*29 + 29]];
        }

    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }
  

}


#pragma mark fb post
-(void)facebookPostFunction
{
    [delegate shareOnFacebook];

    
//    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus netStatus = [reach currentReachabilityStatus];
//    if (netStatus == NotReachable)
//    {
//        [[DataManager shared]removeActivityIndicator];
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
//    }
//    else
//    {
//        if(FBSession.activeSession.isOpen)
//        {
//            FBRequest *me = [FBRequest requestForMe];
//            
//            [me startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my,NSError *error) {
//                if (!error)  {
//                    [self postFunction];
//                } else {
//                    NSLog(@"fb login failed");
//                }
//            }];
//
//        }
//        else
//        {
//            NSArray *permissions=[[NSArray alloc]initWithObjects:@"publish_actions", nil];
//            [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
//             {
//                 //
//                 if(FBSession.activeSession.isOpen)
//                 {
//                     if(error)
//                     {
//                         //
//                         [[DataManager shared]removeActivityIndicator];
//                         NSLog(@"error=%d  ",error.fberrorCategory);
//                         if (error.fberrorCategory == FBErrorCategoryUserCancelled)
//                         {
//                             UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"" message:@"App could not get the desired permissions to use your Facebook account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             [LoginFailed show];
//                             
//                             
//                         }
//                         else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
//                         {
//                             UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Session Error" message:@"Your current session is no longer valid. Please log in again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             [LoginFailed show];
//                             
//                         }
//                         if(error.fberrorShouldNotifyUser == 1)
//                         {
//                             UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Failed to login" message:[NSString stringWithFormat:@"%@",error.fberrorUserMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             [LoginFailed show];
//                             
//                         }
//                         
//                     }
//                     else
//                     {
//                         FBRequest *me = [FBRequest requestForMe];
//                         
//                         [me startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my,NSError *error) {
//                             [[NSUserDefaults standardUserDefaults]setValue:session.accessTokenData.accessToken forKey:@"FB_ACCESSTOKEN"];
//                             if (!error)  {
//                                 [self postFunction];
//                             } else {
//                                 [[DataManager shared]removeActivityIndicator];
//                                 NSLog(@"fb login failed");
//                             }
//                         }];
//                         
//                         
//                     }
//                 }
//                 else {
//                     [[DataManager shared]removeActivityIndicator];
//                     NSLog(@"main: fb login failed %u",FBSession.activeSession.state);
//                     [[[UIAlertView alloc]initWithTitle:@"Facebook Error" message:@"XBowling 3.0 could not get the desired permissions to use your Facebook account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                 }
//             }];
//        }
//    }
    
}

//-(void)postFunction
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"Hey!! I am using XB PRO Package to analyze my advanced stats to gain better insights into my performance. Try it: http://bit.ly/xbowlme",@"message",
//                                   nil];
//    
//    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              [[DataManager shared]removeActivityIndicator];
//                              if (error) {
//                                  NSLog(@"error description=%@",error.description);
//                                  NSLog(@"error=%ld",(long)error.code);
//                                  NSLog(@"msg=%@",error.fberrorUserMessage);
//                                   [[[UIAlertView alloc]initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
////                                  if(error.code == 5)
////                                  {
////                                        [[[UIAlertView alloc]initWithTitle:@"" message:@"This post is already shared on your wall." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
////                                  }
//                              } else  {
//                                  
//                                  [[[UIAlertView alloc]initWithTitle:@"" message:@"Post shared successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                              }
//                              
//                          }];
//
//}

- (void)postFunction
{
    [delegate shareOnFacebook];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeaderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:190/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBase=(UIButton*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBase removeFromSuperview];
        cellBase=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (tableView.tag == 11000) {
        //List View
        CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        cellView.tag=indexPath.row+100;
        cellView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:cellView];
        cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:550/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
        nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.backgroundColor=[UIColor clearColor];
        [cellView addSubview:nameLabel];
        
        UILabel *convertedLabel=[[UILabel alloc]init];
        convertedLabel.backgroundColor=[UIColor clearColor];
        convertedLabel.textAlignment=NSTextAlignmentRight;
        convertedLabel.frame=CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, 145, frame.size.height);
        convertedLabel.textColor=[UIColor whiteColor];
      
        convertedLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [cellView addSubview:convertedLabel];
        
        if (indexPath.section == 0) {
            @try {
                nameLabel.text=[NSString stringWithFormat:@"%ld-pin",indexPath.row+1];

                convertedLabel.text=[NSString stringWithFormat:@"Converted: %ld/%ld",(long)[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePincount%ld",indexPath.row+1]] integerValue],(long)[[[pinViewJsonArray objectAtIndex:0] objectForKey:[NSString stringWithFormat:@"singlePinChancecount%ld",indexPath.row+1]] integerValue]];
            }
            @catch (NSException *exception) {
                convertedLabel.text=@"";
            }
        }
        else if (indexPath.section == 1){
            
            @try {
                nameLabel.text= [[NSString stringWithFormat:@"%@",[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkMultipinList"] objectAtIndex:indexPath.row] objectForKey:@"multiPinText"]] stringByReplacingOccurrencesOfString:@"," withString:@"-"];
                convertedLabel.text=[NSString stringWithFormat:@"Converted: %ld/%ld",(long)[[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkMultipinList"] objectAtIndex:indexPath.row] objectForKey:@"multiPin"] integerValue],(long)[[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkMultipinList"] objectAtIndex:indexPath.row] objectForKey:@"multiPinChances"] integerValue]];
            }
            @catch (NSException *exception) {
                convertedLabel.text=@"";
            }
        }
        else{
            @try {
                nameLabel.text=[[NSString stringWithFormat:@"%@",[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkSplitList"] objectAtIndex:indexPath.row] objectForKey:@"splitText"]] stringByReplacingOccurrencesOfString:@"," withString:@"-"];

                convertedLabel.text=[NSString stringWithFormat:@"Converted: %ld/%ld",(long)[[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkSplitList"] objectAtIndex:indexPath.row] objectForKey:@"split"] integerValue],(long)[[[[[pinViewJsonArray objectAtIndex:0] objectForKey:@"checkSplitList"] objectAtIndex:indexPath.row] objectForKey:@"splitChances"] integerValue]];
            }
            @catch (NSException *exception) {
                
            }
        }
        UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
        separatorLine.tag=901;
        separatorLine.backgroundColor=[UIColor whiteColor];
        separatorLine.alpha=0.6;
        [cellView addSubview:separatorLine];
    }
    else if(tableView.tag == 11001){
        //Equipment Table
        if(indexPath.section == 0)
        {
            @try {
                if([[equipmentDetailDictionary objectForKey:@"BowlNames"] count]> 0)
                {
                    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
                    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                    cellView.tag=indexPath.row+100;
                    cellView.backgroundColor=[UIColor clearColor];
                    [cell.contentView addSubview:cellView];
                    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
                    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
                    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
                    nameLabel.textColor=[UIColor whiteColor];
                    nameLabel.backgroundColor=[UIColor clearColor];
                    @try {
                        nameLabel.text=[NSString stringWithFormat:@"%@",[[[equipmentDetailDictionary objectForKey:@"BowlNames"]objectAtIndex:indexPath.row] objectForKey:@"userBowlingBallName"]];
                    }
                    @catch (NSException *exception) {
                        nameLabel.text=@"";
                    }
                    [cellView addSubview:nameLabel];
                    
                    UIButton *editBtn=[[UIButton alloc] init];
                    editBtn.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:690/3 currentSuperviewDeviceSize:screenBounds.size.width] ,0, 50,24);
                    editBtn.layer.cornerRadius=5;
                    editBtn.tag = 10000*(indexPath.section+1)+indexPath.row;
                    editBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
                    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
                    editBtn.layer.masksToBounds=YES;
                    [editBtn addTarget:self action:@selector(editButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                    editBtn.backgroundColor=[UIColor colorWithRed:45.0/255.0 green:93.0/255.0 blue:195.0/255.0 alpha:1.0];
                    editBtn.alpha = 0.95;
                    editBtn.center=CGPointMake(editBtn.center.x, cellView.center.y);
                    editBtn.userInteractionEnabled=YES;
                    [cellView addSubview:editBtn];
                    
                    UIButton *deleteBtn=[[UIButton alloc] init];
                    deleteBtn.frame=CGRectMake(editBtn.frame.origin.x + editBtn.frame.size.width + 20,0, 55,24);
                    deleteBtn.layer.cornerRadius=5;
                    deleteBtn.tag = 10000*(indexPath.section+1)+indexPath.row;
                    deleteBtn.center=CGPointMake(deleteBtn.center.x, cellView.center.y);
                    deleteBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
                    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                    deleteBtn.layer.masksToBounds=YES;
                    deleteBtn.backgroundColor=[UIColor colorWithRed:173.0/255.0 green:70.0/255.0 blue:99.0/255.0 alpha:1.0];
                    deleteBtn.alpha = 0.95;
                    deleteBtn.userInteractionEnabled=YES;
                    [cellView addSubview:deleteBtn];
                    
                    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
                    separatorLine.tag=901;
                    separatorLine.backgroundColor=[UIColor whiteColor];
                    separatorLine.alpha=0.6;
                    [cellView addSubview:separatorLine];
                }
            }
            @catch (NSException *exception) {
            }
        }
        else{
            @try {
                if([[equipmentDetailDictionary objectForKey:@"PatternNames"] count]> 0)
                {
                    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
                    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                    cellView.tag=indexPath.row+100;
                    cellView.backgroundColor=[UIColor clearColor];
                    [cell.contentView addSubview:cellView];
                    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
                    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
                    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
                    nameLabel.textColor=[UIColor whiteColor];
                    nameLabel.backgroundColor=[UIColor clearColor];
                    @try {
                        nameLabel.text=[NSString stringWithFormat:@"%@",[[[equipmentDetailDictionary objectForKey:@"PatternNames"]objectAtIndex:indexPath.row] objectForKey:@"patternName"]];
                    }
                    @catch (NSException *exception) {
                        nameLabel.text=@"";
                    }
                    [cellView addSubview:nameLabel];
                    
                    UIButton *editBtn=[[UIButton alloc] init];
                    editBtn.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:690/3 currentSuperviewDeviceSize:screenBounds.size.width] ,0, 50,24);
                    editBtn.layer.cornerRadius=5;
                    editBtn.tag = 10000*(indexPath.section+1)+indexPath.row;
                    editBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
                    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
                    editBtn.layer.masksToBounds=YES;
                    [editBtn addTarget:self action:@selector(editButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                    editBtn.backgroundColor=[UIColor colorWithRed:45.0/255.0 green:93.0/255.0 blue:195.0/255.0 alpha:1.0];
                    editBtn.alpha = 0.95;
                    editBtn.center=CGPointMake(editBtn.center.x, cellView.center.y);
                    editBtn.userInteractionEnabled=YES;
                    [cellView addSubview:editBtn];
                    
                    UIButton *deleteBtn=[[UIButton alloc] init];
                    deleteBtn.frame=CGRectMake(editBtn.frame.origin.x + editBtn.frame.size.width + 20,0, 55,24);
                    deleteBtn.layer.cornerRadius=5;
                    deleteBtn.tag = 10000*(indexPath.section+1)+indexPath.row;
                    deleteBtn.center=CGPointMake(deleteBtn.center.x, cellView.center.y);
                    deleteBtn.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH3size];
                    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
                    deleteBtn.layer.masksToBounds=YES;
                    deleteBtn.backgroundColor=[UIColor colorWithRed:173.0/255.0 green:70.0/255.0 blue:99.0/255.0 alpha:1.0];
                    deleteBtn.alpha = 0.95;
                    deleteBtn.userInteractionEnabled=YES;
                    [cellView addSubview:deleteBtn];
                    
                    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
                    separatorLine.tag=901;
                    separatorLine.backgroundColor=[UIColor whiteColor];
                    separatorLine.alpha=0.6;
                    [cellView addSubview:separatorLine];
                }
            }
            @catch (NSException *exception) {
            }
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num=0;
    if (tableView.tag == 11000) {
        //List View Table
        if (section == 0) {
            num = 10;
        }
        else if (section == 1){
            num = (int)[[[pinViewJsonArray objectAtIndex:0]objectForKey:@"checkMultipinList"] count];
        }
        else{
            num = (int)[[[pinViewJsonArray objectAtIndex:0]objectForKey:@"checkSplitList"] count];
        }
    }
    else if (tableView.tag == 11001){
        //Equipment Table
        if (section == 0) {
            num = (int)[[equipmentDetailDictionary objectForKey:@"BowlNames"] count];
        }
        else{
            num = (int)[[equipmentDetailDictionary objectForKey:@"PatternNames"] count];
        }
    }
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"%f",[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    int num = 0;
    if (tableView.tag == 11001) {
        num=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    else{
        num = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:190/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    return num;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView *myHeader =[[UITableViewHeaderFooterView alloc]init];
    if(myHeader == nil)
    {
        myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    }
    else
    {
        UIView *headerBase=(UIView*)[myHeader viewWithTag:200+section];
        [headerBase removeFromSuperview];
        headerBase=nil;
    }
    CGRect frame = [tableView rectForSection:section];
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    tableHeaderView.tag=200+section;
    tableHeaderView.backgroundColor=XBHeaderColor;
    UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, tableHeaderView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.width],tableHeaderView.frame.size.height)];
    headerlabel.backgroundColor=[UIColor clearColor];
    headerlabel.textColor=[UIColor whiteColor];
    headerlabel.text=[NSString stringWithFormat:@"%@",[sectionHeaderArray objectAtIndex:section]];
    headerlabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH2size];
    [tableHeaderView addSubview:headerlabel];
    
    UIImageView *plusIndicator=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(115+30)/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    plusIndicator.tag=300;
    plusIndicator.center=CGPointMake(plusIndicator.center.x, tableHeaderView.center.y);
    if ([openSectionsArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [plusIndicator setImage:[UIImage imageNamed:@"minus.png"]];
    }
    else
    {
         [plusIndicator setImage:[UIImage imageNamed:@"plus.png"]];
    }
    [tableHeaderView addSubview:plusIndicator];
    if (tableView.tag == 11001) {
        UIButton *addButton=[[UIButton alloc]init];
        [addButton setFrame:CGRectMake( headerlabel.frame.size.width + headerlabel.frame.origin.x + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:25/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:290/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:self.frame.size.height])];
        addButton.layer.cornerRadius=addButton.frame.size.height/2;
        addButton.clipsToBounds=YES;
        if (section == 0) {
            addButton.tag=111100;
        }
        else{
            addButton.tag=111111;
        }
        addButton.center=CGPointMake(addButton.center.x, tableHeaderView.center.y);
        addButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton setTitle:@"Add New" forState:UIControlStateNormal];
        addButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
        [addButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
        [addButton addTarget:self action:@selector(addNewButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeaderView addSubview:addButton];
    }
    [myHeader addSubview:tableHeaderView];
    myHeader.tag=tableHeaderView.tag;
    return myHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - Expandable TableView Delegate Methods
- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    UIView *tableHeaderView=(UIView *)[view viewWithTag:200+sectionIndex];
//    tableHeaderView.backgroundColor=[UIColor clearColor];
    UIImageView *plusIndicator=(UIImageView *)[tableHeaderView viewWithTag:300];
     [plusIndicator setImage:[UIImage imageNamed:@"plus_onclick.png"]];
    [openSectionsArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
    [self performSelector:@selector(onClickForIndicatorImage:) withObject:plusIndicator afterDelay:0.1];
}

- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    UIView *tableHeaderView=(UIView *)[view viewWithTag:200+sectionIndex];
    UIImageView *minusIndicator=(UIImageView *)[tableHeaderView viewWithTag:300];
    [minusIndicator setImage:[UIImage imageNamed:@"minus_onclick.png"]];
    [openSectionsArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
    [self performSelector:@selector(onClickForIndicatorImage:) withObject:minusIndicator afterDelay:0.1];
}

#pragma mark - For onclick effect of Plus/Minus Icons
- (void)onClickForIndicatorImage:(UIImageView *)indicatorImage
{
    NSUInteger section=indicatorImage.superview.tag - 200;
    if ([openSectionsArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [indicatorImage setImage:[UIImage imageNamed:@"minus.png"]];
    }
    else
    {
        [indicatorImage setImage:[UIImage imageNamed:@"plus.png"]];
    }
    
}


#pragma mark - Graph type drop-down functions

- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture {
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView *tappedImageView = (DropDownImageView *)[tapGesture view];
    @try {
        if([countryInfoDict count] == 0 && tappedImageView == selectCountryImageView)
        {
            [self venueInfo];
            if ([countryInfoDict count]>0) {
                [self selectCenter];
            }
            [[DataManager shared]removeActivityIndicator];
        }

    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
    //for graph view
    NSString *titleString= @"";
     CGRect pickerFrame = CGRectMake(0, 30, 0, 0);
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
    actionSheet.customActionSheetDelegate = self;
    [self.superview addSubview:actionSheet];
    [actionSheet updateTitleLabel:titleString];
    NSLog(@"actionView=%@",actionSheet.actionSheet);
    NSLog(@"actionSheet");
    [actionSheet showPicker];

    
    if (tappedImageView == selectCountryImageView) {
        
        actionSheet.tag = 100;
        pickerView.tag = 100;
        [pickerView selectRow:selectedCountryIndex inComponent:0 animated:NO];
    }
    else if (tappedImageView == selectStateImageView){
        actionSheet.tag = 200;
        pickerView.tag = 200;
        [pickerView selectRow:selectedStateIndex inComponent:0 animated:NO];
    }
    //[pickerView selectRow:1 inComponent:0 animated:YES];
    else if (tappedImageView == selectCenterImageView){
        NSLog(@"center");
        actionSheet.tag = 300;
        pickerView.tag = 300;
        [pickerView selectRow:selectedCenterIndex inComponent:0 animated:NO];
    }
    else if (tappedImageView == oilPatternDropDown)
    {
        actionSheet.tag = 400;
        pickerView.tag = 400;
        [pickerView selectRow:selectedOilPattern inComponent:0 animated:NO];
    }
    else if (tappedImageView == gameTypeDropDown)
    {
        actionSheet.tag = 500;
        pickerView.tag = 500;
        [pickerView selectRow:selectedGameType inComponent:0 animated:NO];
    }
    else if (tappedImageView == patternLengthDropDown)
    {
        actionSheet.tag = 800;
        pickerView.tag = 800;
        [pickerView selectRow:selectedPatternLength inComponent:0 animated:NO];
    }
    else if (tappedImageView == graphTypeImageView)
    {
        actionSheet.tag = 600;
        pickerView.tag = 600;
        [pickerView selectRow:selectedGraphType inComponent:0 animated:NO];

    }
    else if (tappedImageView == comparisonWithImageView)
    {
        actionSheet.tag = 700;
        pickerView.tag = 700;
        [pickerView selectRow:selectedComparisonType inComponent:0 animated:NO];

    }
    [actionSheet.actionSheet addSubview:pickerView];

}


-(void)dismissActionSheet
{
    NSLog(@"picker index=%d  %@",selectedGraphType,[graphTypesArray objectAtIndex:selectedGraphType]);
   
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];

      if(actionSheet.tag == 600)
      {
          graphTypeImageView.textLabel.text=[NSString stringWithFormat:@"%@",[graphTypesArray objectAtIndex:selectedGraphType]];
          [self graphServerCall:selectedGraphType];
      }
    else if(actionSheet.tag == 400)
    {
        [[DataManager shared]removeActivityIndicator];
        oilPatternDropDown.textLabel.text = [[patternNamesArray objectAtIndex:selectedOilPattern] objectForKey:@"patternName"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[patternNamesArray objectAtIndex:selectedOilPattern] objectForKey:@"id"]] forKey:koilPattern];
    }
    else if (actionSheet.tag == 500)
    {
        [[DataManager shared]removeActivityIndicator];

        gameTypeDropDown.textLabel.text = [[gameTypeNamesArray objectAtIndex:selectedGameType] objectForKey:@"competition"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[gameTypeNamesArray objectAtIndex:selectedGameType] objectForKey:@"id"]] forKey:kGameType];
    }
    else if (actionSheet.tag == 700)
    {
        if(selectedComparisonType == 0)
        {
            comparisonWithImageView.textLabel.text = @"Compare With: Individual Users";
            UIButton *defaultBtn=[[UIButton alloc]init];
            defaultBtn.tag = 2400;
            [self comparisonSubview:defaultBtn];
            defaultBtn=nil;
        }
        else
        {
            comparisonWithImageView.textLabel.text = @"Compare With: All XBowlers";
            UIButton *defaultBtn=[[UIButton alloc]init];
            defaultBtn.tag = 2401;
            [self comparisonSubview:defaultBtn];
            defaultBtn=nil;
        }
    }
    else if(actionSheet.tag == 800)
    {
        [[DataManager shared]removeActivityIndicator];
        patternLengthDropDown.textLabel.text = [[patternLengthArray objectAtIndex:selectedPatternLength] objectForKey:@"patternLength"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[patternLengthArray objectAtIndex:selectedPatternLength] objectForKey:@"id"]] forKey:kpatternLength];
    }
    else
    {
        if(countryInfoDict.count>0)
        {
            if (actionSheet.tag == 100) {
                selectedCenterIndex=0;
                selectedStateIndex=0;
                selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
               
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
               
                [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                [self selectCenter];
                if(centerDetails.count> 0)
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                else
                    selectCenterImageView.textLabel.text = @"Select Center";
                
                [[NSUserDefaults standardUserDefaults]setValue:[[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"id"] forKey:kfilterVenueId];
                [[DataManager shared] removeActivityIndicator];
            }
            else if (actionSheet.tag == 200){
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
                [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                [self selectCenter];
                if(centerDetails.count > 0)
                {
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                    
                    //store state name and venue id
                    [[NSUserDefaults standardUserDefaults]setValue:[[centerDetails objectAtIndex:0] objectForKey:@"id"] forKey:kfilterVenueId];

                }
                else
                    selectCenterImageView.textLabel.text =@"Select Center";
                
               
                [[DataManager shared] removeActivityIndicator];
            }
            else if (actionSheet.tag == 300){
                [[DataManager shared] removeActivityIndicator];
                if(centerDetails.count > 0)
                {
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                 
                    [[NSUserDefaults standardUserDefaults]setValue:[[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"id"] forKey:kfilterVenueId];
                    
                }
                else
                    selectCenterImageView.textLabel.text = @"Select Center";
            }
            
        }
    }
}

-(void)graphServerCall:(int)graphType
{
    for(UIView *view in resizableScroll.subviews)
        [view removeFromSuperview];
    UILabel *label=(UILabel *)[backgroundView viewWithTag:9999];
    [label removeFromSuperview];
    
    //current date
    NSDate *currentDate=[NSDate date];
    NSLog(@"currentDate=%@",currentDate);
    NSString *format=@"MM/dd/yyyy";
    NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
    NSString *displayDate=[formatterUtc stringFromDate:currentDate];
    NSLog(@"displayDate=%@",displayDate);
    
    NSString *urlString=[graphServerUrlArray objectAtIndex:graphType];
    NSString *params= [[NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&Tag=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate,[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@"All Tags"] || [[[NSUserDefaults standardUserDefaults]valueForKey:kfilterTag] isEqualToString:@""]) {
        params= [NSString stringWithFormat:@"location=%@&oilPattern=%@&gameType=%@&timeDuration=%@&patternLength=%@&currentDate=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kfilterVenueId],[[NSUserDefaults standardUserDefaults]valueForKey:koilPattern],[[NSUserDefaults standardUserDefaults]valueForKey:kGameType],[[NSUserDefaults standardUserDefaults]valueForKey:kduration],[[NSUserDefaults standardUserDefaults]valueForKey:kpatternLength],displayDate];
    }
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:urlString contentType:@"" httpMethod:@"GET"];
    NSDictionary *response=[json objectForKey:@"responseString"];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
    {
        if(response.count > 0)
        {
            piechartDic =[[NSDictionary alloc]init];
            piechartDic=response;
            if(selectedGraphType == 4)
            {
                if([[[json objectForKey:@"responseString"] objectAtIndex:0] count]> 0)
                 [self drawGraph:graphType graphData:[[json objectForKey:@"responseString"] objectAtIndex:0]];
                else
                {
                    [[DataManager shared]removeActivityIndicator];
                    UILabel *label=(UILabel *)[backgroundView viewWithTag:9999];
                    [label removeFromSuperview];
                    UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
                    suggestions1.tag=9999;
                    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                    {
                        if (screenBounds.size.height == 480)
                        {
                            suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                        }
                    }
                    suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                    suggestions1.textAlignment = NSTextAlignmentCenter;
                    suggestions1.textColor = [UIColor whiteColor];
                    suggestions1.backgroundColor=[UIColor clearColor];
                    suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
                    suggestions1.numberOfLines=0;
                    suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
                    [backgroundView addSubview:suggestions1];

                }
            }
            else if (selectedGraphType == 5)
            {
                if([[[json objectForKey:@"responseString"] objectAtIndex:1] count]> 0)
                 [self drawGraph:graphType graphData:[[json objectForKey:@"responseString"] objectAtIndex:1]];
                else
                {
                    [[DataManager shared]removeActivityIndicator];
                    UILabel *label=(UILabel *)[backgroundView viewWithTag:9999];
                    [label removeFromSuperview];
                    UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
                    suggestions1.tag=9999;
                    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                    {
                        if (screenBounds.size.height == 480)
                        {
                            suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                        }
                    }
                    suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                    suggestions1.textAlignment = NSTextAlignmentCenter;
                    suggestions1.textColor = [UIColor whiteColor];
                    suggestions1.backgroundColor=[UIColor clearColor];
                    suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
                    suggestions1.numberOfLines=0;
                    suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
                    [backgroundView addSubview:suggestions1];

                }
            }
            else
                 [self drawGraph:graphType graphData:response];
           
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UILabel *label=(UILabel *)[backgroundView viewWithTag:9999];
            [label removeFromSuperview];
            UILabel *suggestions1 =  [[UILabel alloc] initWithFrame: CGRectMake(0,backgroundView.frame.size.height/2 - 20,backgroundView.frame.size.width, 40)];
            suggestions1.tag=9999;
            if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if (screenBounds.size.height == 480)
                {
                    suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                }
            }
            suggestions1.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            suggestions1.textAlignment = NSTextAlignmentCenter;
            suggestions1.textColor = [UIColor whiteColor];
            suggestions1.backgroundColor=[UIColor clearColor];
            suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
            suggestions1.numberOfLines=0;
            suggestions1.lineBreakMode=NSLineBreakByWordWrapping;
            [backgroundView addSubview:suggestions1];

            if(selectedGraphType ==  8)
            {
                suggestions1.text = @"No Ball name added.";
               
            }
            
        }
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    
}
- (void)drawGraph:(int)index graphData:(NSMutableArray *)dataArray
{
    
    [[DataManager shared]removeActivityIndicator];
    NSString *xaxisString,*yaxisString;
    
    if(index == 0 ||index == 1 || index == 9)
    {
        //line graph
        
        
        if(index==0)
        {
            xaxisString=@"startDate";
            yaxisString=@"avgScore";
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"startDate"]];
//                NSString *avgScore=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"avgScore"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null] || [avgScore isEqualToString:@"0"])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }

            
        }
        if(index==1)
        {
            yaxisString=@"highestScores";
            xaxisString=@"startDate";
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"startDate"]];
//                NSString *highScore=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"highestScores"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null] || [highScore isEqualToString:@"0"])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }
        }
        if(index == 9)
        {
            yaxisString=@"avgScore";
            xaxisString=@"bawlingBallName";
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"bawlingBallName"]];
//                NSString *avgScore=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"avgScore"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null] || [avgScore isEqualToString:@"0"])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }

        }
        LineGraph *lineGraphView;

       if(dataArray.count<7)
        {
            lineGraphView=[[LineGraph alloc]initWithFrame:CGRectMake(3, 0, 500, 215)];
            resizableScroll.contentOffset=CGPointMake(0, 0);
//            resizableScroll.contentSize=CGSizeMake(0,150);
        }
        else{
            
            lineGraphView=[[LineGraph alloc]initWithFrame:CGRectMake(3, 5, 500+(dataArray.count-7)*60+100, 215)];
//            resizableScroll.contentOffset=CGPointMake(0, 140);
            resizableScroll.contentSize=CGSizeMake(600+(dataArray.count-7)*60+100,150);
        }
        [lineGraphView lineGraphData:dataArray xAxis:xaxisString yAxis:yaxisString];
        [resizableScroll addSubview:lineGraphView];
        
    }
    else if(index ==3)
    {
         //pie chart

        PCPieChart *pieChart=[[PCPieChart alloc]initWithFrame:CGRectMake(3, 0, resizableScroll.frame.size.width - 6, resizableScroll.frame.size.height)];
        if(dataArray.count == 7)
            pieChart=[[PCPieChart alloc]initWithFrame:CGRectMake(3, 0, resizableScroll.frame.size.width - 6, resizableScroll.frame.size.height + 55)];
        [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [pieChart setDiameter:150];
        [pieChart setSameColorLabel:YES];
        resizableScroll.contentOffset=CGPointMake(0, 0);
        resizableScroll.contentSize=CGSizeMake(0,pieChart.frame.size.height);
        resizableScroll.delegate=self;
        [resizableScroll addSubview:pieChart];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
            pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        }
        
        NSMutableArray *keysForpieChart=[[NSMutableArray alloc]initWithObjects:@"gamesBetween151To175",@"gamesBetween176To200",@"gamesBetween201To225",@"gamesBetween226To250",@"gamesBetween251To299",@"gamesLessThan150",@"gamesPerfectScore", nil];
        NSMutableArray *components = [NSMutableArray array];
        NSLog(@"%@",piechartDic);
        NSMutableArray *statictitleArray =[[NSMutableArray alloc]initWithObjects:@"Games 151-175",@"Games 176-200",@"Games 201-225",@"Games 226-250",@"Games 251-299",@"Games<150",@"Perfect Score", nil];
        NSMutableArray *finalTitleArray=[NSMutableArray new];
        
        for (int i=0; i<keysForpieChart.count; i++)
        {
            if([[piechartDic objectForKey:[keysForpieChart objectAtIndex:i] ] floatValue] != 0.00)
            {
                NSLog(@"xomponents==%@",[piechartDic objectForKey:[keysForpieChart objectAtIndex:i]]);
                NSString *title=[NSString stringWithFormat:@"%@ (%ld%%)",[statictitleArray objectAtIndex:i],(long)[[piechartDic objectForKey:[keysForpieChart objectAtIndex:i] ] integerValue]];
                [finalTitleArray addObject:title];
                PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"" value:[[piechartDic objectForKey:[keysForpieChart objectAtIndex:i] ] floatValue]];
                [components addObject:component];
                if (i==0)
                {
                    [component setColour:PCColorYellow];
                }
                else if (i==1)
                {
                    [component setColour:PCColorGreen];
                }
                else if (i==2)
                {
                    [component setColour:PCColorOrange];
                }
                else if (i==3)
                {
                    [component setColour:PCColorRed];
                }
                else if (i==4)
                {
                    [component setColour:PCColorBlue];
                }
                else if (i==5)
                {
                    [component setColour:[UIColor whiteColor]];
                }
                else if (i==6)
                {
                    [component setColour:[UIColor magentaColor]];
                }

            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:finalTitleArray forKey:@"TitlesinPiechart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [pieChart setComponents:components];
        
    }
    else if(index == 2 ||index == 4 ||index == 5 || index == 6 ||index == 7 ||index == 8)
    {
//         resizableScroll.contentOffset=CGPointMake(resizableScroll.contentOffset.x, 90);
        if(index==2)
        {
            xaxisString=@"filterName";
            yaxisString=@"open,spare,strike";
            [[NSUserDefaults standardUserDefaults]setObject:@"Open,Spare,Strike" forKey:@"colorLabelText"];
            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"bargraphcount"];
            // resizableScroll.contentOffset=CGPointMake(0, 75);
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"filterName"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }
            if(dataArray.count>8)
            {
                resizableScroll.contentSize=CGSizeMake(500+(dataArray.count-7)*56+60,150);
            }
            else{
                resizableScroll.contentSize=CGSizeMake(350,150);
            }
        }
        if(index==4)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Multi-Pin,Multi-Pin Spare Conversion" forKey:@"colorLabelText"];
            
            xaxisString=@"multiPinText";
            yaxisString=@"multiPinChances,multiPin";
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"bargraphcount"];
            //  resizableScroll.contentOffset=CGPointMake(0, 75);
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"multiPinText"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }
            if(dataArray.count>8)
            {
                resizableScroll.contentSize=CGSizeMake(100+dataArray.count*55+60,150);
                
            }
            else{
                resizableScroll.contentSize=CGSizeMake(450,150);
                
            }
            
        }
        if(index==5)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Split,Conversion" forKey:@"colorLabelText"];
            
            xaxisString=@"splitText";
            yaxisString=@"splitChances,split";
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"bargraphcount"];
            //  resizableScroll.contentOffset=CGPointMake(0, 75);
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"splitText"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }
            if(dataArray.count>8)
            {
                resizableScroll.contentSize=CGSizeMake(500+(dataArray.count-7)*56+60,150);
            }
            else
            {
                resizableScroll.contentSize=CGSizeMake(450,150);
            }
            
        }
        if(index==6)
        {
            xaxisString=@"oilPattern";
            yaxisString=@"avgScore";
//            for(int i=0;i<dataArray.count;i++)
//            {
//                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"oilPattern"]];
////                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null])
////                {
////                    [dataArray removeObjectAtIndex:i];
////                }
//            }
            int horozontalLineLength=6;
            if(dataArray.count<8)
            {
                horozontalLineLength=6;
            }
            else
            {
                horozontalLineLength=(int)dataArray.count;
            }

            [[NSUserDefaults standardUserDefaults]setObject:@"Average Score" forKey:@"colorLabelText"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"bargraphcount"];
            resizableScroll.contentSize=CGSizeMake(55*horozontalLineLength+130,150);
            
        }
        if(index==7)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Single Pin,Single Pin Spare Conversion" forKey:@"colorLabelText"];
            xaxisString=@"";
            yaxisString=@"singlePinChancecount,singlePincount";
            [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"bargraphcount"];
            // resizableScroll.contentOffset=CGPointMake(0, 75);
//            int horozontalLineLength=6;
//            if([[dataArray objectAtIndex:0] count]<6)
//            {
//                horozontalLineLength=6;
//            }
//            else
//            {
//                horozontalLineLength=(int)dataArray.count;
//            }
//            resizableScroll.contentSize=CGSizeMake(75*horozontalLineLength+150,150);
            if([[dataArray objectAtIndex:0] count]>7)
            {
                resizableScroll.contentSize=CGSizeMake(600+dataArray.count*75,150);
            }
            else
            {
                resizableScroll.contentSize=CGSizeMake(450,150);
            }
        }
        if(index==8)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Spare,Strike" forKey:@"colorLabelText"];
            
            xaxisString=@"filterName";
            yaxisString=@"sparePercentage,strikePercentage";
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"bargraphcount"];
            //  resizableScroll.contentOffset=CGPointMake(0, 75);
            for(int i=0;i<dataArray.count;i++)
            {
                NSString *date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"filterName"]];
                if([date length]==0 || [date isEqualToString:@"<null>"]||date ==nil||[dataArray objectAtIndex:i]==[NSNull null])
                {
                    [dataArray removeObjectAtIndex:i];
                }
            }
            if(dataArray.count>8)
            {
                resizableScroll.contentSize=CGSizeMake(500+(dataArray.count-7)*56+60,150);
                
            }
            else{
                resizableScroll.contentSize=CGSizeMake(450,150);
                
            }
            
        }
        //bar chart
        BarChart *barChartView;
        if(dataArray.count<8)
        {
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 0, 500, 160)];
        }
        else
        {
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 0, 600+(dataArray.count-7)*75, 160)];
        }
        if([xaxisString length]==0)
        {
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 0,670, 160)];
        }
        if(index==4 || index==5)
        {
            
            int countcheck=0;
            for(int i=0;i<[dataArray count];i++)
            {
                
                countcheck++;
            }
            if(countcheck<8)
            {
                barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 0, 500, 160)];
                
                resizableScroll.contentSize=CGSizeMake(450,150);
            }
            else
            {
                resizableScroll.contentSize=CGSizeMake(500+(countcheck-7)*56+60,150);
                barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 0, 550+(countcheck-7)*75, 160)];
            }
            
        }
        
        [barChartView barGraphdata:dataArray xAxis:xaxisString yAxis:yaxisString];
        barChartView.backgroundColor=[UIColor clearColor];
        [resizableScroll addSubview:barChartView];
        
    }
    else
    {
        
    }
    
}

- (void)addNewButtonFunction:(UIButton *)sender
{
    
    if(sender.tag == 111100)
    {
        //Ball Name
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Ball Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.tag=sender.tag;
        av.delegate = self;
        [av show];

    }
    else
    {
        //pattern name
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Pattern Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.delegate = self;
        av.tag=sender.tag;
        [av show];
        
    }
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if(alertView.tag == 700)
    {
        if(buttonIndex == 0)
        {
            //            [self exportStatsServerCall:1];
        }
        else
        {
            //mail stats
            [self performSelector:@selector(exportStatsServerCall:) withObject:[NSString stringWithFormat:@"2"] afterDelay:0.2];
//            [self exportStatsServerCall:2];
        }
    }
    else if (alertView.tag == 701)
    {
        if(buttonIndex == 0)
        {
            
        }
        else
        {
            //reset stats
            [self exportStatsServerCall:3];
        }
    }
    else
    {
        NSDictionary *performSelectorDictionary;//=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",alertView.tag],@"alertviewTag",buttonIndex,@"buttonIndex",[NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text],@"alertviewTextlabel", nil];
        performSelectorDictionary = @{@"alertviewTag":[NSString stringWithFormat:@"%ld",(long)alertView.tag],
                                      @"buttonIndex":[NSString stringWithFormat:@"%ld",(long)buttonIndex],
                                      @"alertviewTextlabel":[NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text]
                                      };
        [self performSelector:@selector(addBallName:) withObject:performSelectorDictionary afterDelay:0.2];
    }
    
}

- (void)addBallName:(NSDictionary *)alertViewDictionary
{
    NSLog(@"%@",alertViewDictionary);
    int buttonIndex=[[alertViewDictionary  objectForKey:@"buttonIndex"] intValue];
    NSString *alertviewTextlabel=[alertViewDictionary  objectForKey:@"alertviewTextlabel"];
    int tag=[[alertViewDictionary  objectForKey:@"alertviewTag"] intValue];
    @try {
        
        if(buttonIndex == 1)
        {
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            //add names
            if(alertviewTextlabel.length > 0)
            {
                if(tag == 111100)
                {
                    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"UserBowlingBallName=%@&Id=%@&",[alertviewTextlabel stringByReplacingOccurrencesOfString:@" " withString:@"%20"],@"0"] url:@"UserStat/AddEditEquipmentBowlingBallName" contentType:@"" httpMethod:@"POST"];
                    NSDictionary *response=[json objectForKey:@"responseString"];
                    NSLog(@"responseDict=%@",response);
                    if([[json objectForKey:@"responseStatusCode"] intValue] == 201)
                    {
                        [[DataManager shared]removeActivityIndicator];
                        NSMutableArray *bowlArr=[NSMutableArray arrayWithArray:[equipmentDetailDictionary objectForKey:@"BowlNames"]];
                        [bowlArr addObject:response];
                        [equipmentDetailDictionary removeObjectForKey:@"BowlNames"];
                        [equipmentDetailDictionary setObject:bowlArr forKey:@"BowlNames"];
                        [heightOfCellArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"BowlNames"] count]*29 + 29]];
                        
                    }
                    else if ([[json objectForKey:@"responseStatusCode"] intValue] == 409)
                    {
                        [[DataManager shared]removeActivityIndicator];
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"Bowling Ball name already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                    else
                    {
                        [[DataManager shared]removeActivityIndicator];
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        
                    }
                }
                else if(tag == 111111)
                {
                    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"UserPatternName=%@&Id=%@&",[alertviewTextlabel stringByReplacingOccurrencesOfString:@" " withString:@"%20"],@"0"] url:@"UserStat/AddEditEquipmentPatternName" contentType:@"" httpMethod:@"POST"];
                    NSDictionary *response=[json objectForKey:@"responseString"];
                    NSLog(@"responseDict=%@",response);
                    if([[json objectForKey:@"responseStatusCode"] intValue] == 201)
                    {
                        [[DataManager shared]removeActivityIndicator];
                        NSMutableArray *bowlArr=[NSMutableArray arrayWithArray:[equipmentDetailDictionary objectForKey:@"PatternNames"]];
                        [bowlArr addObject:response];
                        [equipmentDetailDictionary removeObjectForKey:@"PatternNames"];
                        [equipmentDetailDictionary setObject:bowlArr forKey:@"PatternNames"];
                        [heightOfCellArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"PatternNames"] count]*29 + 29]];
                    }
                    else if ([[json objectForKey:@"responseStatusCode"] intValue] == 409)
                    {
                        [[DataManager shared]removeActivityIndicator];
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"Pattern name already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                    else
                    {
                        [[DataManager shared]removeActivityIndicator];
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        
                    }
                    
                }
                else
                {
                    //edit names
                    int type=(int)tag/10000;
                    int index=(int)tag%10000;
                    if(type == 1)
                    {
                        //Ball Name
                        NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"UserBowlingBallName=%@&Id=%@&",[alertviewTextlabel stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[[[equipmentDetailDictionary objectForKey:@"BowlNames"] objectAtIndex:index] objectForKey:@"id"]] url:@"UserStat/AddEditEquipmentBowlingBallName" contentType:@"" httpMethod:@"POST"];
                        NSDictionary *response=[json objectForKey:@"responseString"];
                        NSLog(@"responseDict=%@",response);
                        if([[json objectForKey:@"responseStatusCode"] intValue] == 201)
                        {
                            
                            [[DataManager shared]removeActivityIndicator];
                            NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:[equipmentDetailDictionary  objectForKey:@"BowlNames"]];
                            [temp replaceObjectAtIndex:index withObject:response];
                            [equipmentDetailDictionary removeObjectForKey:@"BowlNames"];
                            [equipmentDetailDictionary setObject:temp forKey:@"BowlNames"];
                            
                            
                        }
                        else if ([[json objectForKey:@"responseStatusCode"] intValue] == 409)
                        {
                            [[DataManager shared]removeActivityIndicator];
                            [[[UIAlertView alloc]initWithTitle:@"" message:@"Bowling Ball name already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        }
                        else
                        {
                            [[DataManager shared]removeActivityIndicator];
                            [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                            
                        }
                        
                    }
                    else
                    {
                        //pattern name
                        @try {
                            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"UserPatternName=%@&Id=%@&",[alertviewTextlabel stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[[[equipmentDetailDictionary objectForKey:@"PatternNames"] objectAtIndex:index] objectForKey:@"id"]] url:@"UserStat/AddEditEquipmentPatternName" contentType:@"" httpMethod:@"POST"];
                            NSDictionary *response=[json objectForKey:@"responseString"];
                            NSLog(@"responseDict=%@",response);
                            if([[json objectForKey:@"responseStatusCode"] intValue] == 201)
                            {
                                [[DataManager shared]removeActivityIndicator];
                                NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:[equipmentDetailDictionary  objectForKey:@"PatternNames"]];
                                [temp replaceObjectAtIndex:index withObject:response];
                                [equipmentDetailDictionary removeObjectForKey:@"PatternNames"];
                                [equipmentDetailDictionary setObject:temp forKey:@"PatternNames"];
                                
                            }
                            else if ([[json objectForKey:@"responseStatusCode"] intValue] == 409)
                            {
                                [[DataManager shared]removeActivityIndicator];
                                [[[UIAlertView alloc]initWithTitle:@"" message:@"Pattern name already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                            }
                            else
                            {
                                [[DataManager shared]removeActivityIndicator];
                                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                                
                            }
                            
                        }
                        @catch (NSException *exception) {
                            [[DataManager shared]removeActivityIndicator];
                            [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                            
                        }
                        
                    }
                }
                [equipmentTableView reloadData];
            }
            else
            {
                [[DataManager shared]removeActivityIndicator];
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter some text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
        }
        
    }
    @catch (NSException *exception) {
        [[DataManager shared]removeActivityIndicator];
    }
}

- (void)editButtonFunction:(UIButton *)sender
{
    int type=(int)sender.tag/10000;
    if(type == 1)
    {
        //Ball Name
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Ball Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.tag=sender.tag;
        int indexOfSelectedBall = sender.tag%10000;
        NSString *ballName;
        @try {
            ballName=[NSString stringWithFormat:@"%@",[[[equipmentDetailDictionary objectForKey:@"BowlNames"]objectAtIndex:indexOfSelectedBall] objectForKey:@"userBowlingBallName"]];
        }
        @catch (NSException *exception) {
            ballName=@"";
        }
        [av textFieldAtIndex:0].text=[NSString stringWithFormat:@"%@",ballName];
        av.delegate = self;
        [av show];
        
        
    }
    else
    {
        //pattern name
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Pattern Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.delegate = self;
        av.tag=sender.tag;
        int indexOfSelectedPattern = sender.tag%10000;
        NSString *patternName;
        @try {
            patternName=[NSString stringWithFormat:@"%@",[[[equipmentDetailDictionary objectForKey:@"PatternNames"]objectAtIndex:indexOfSelectedPattern] objectForKey:@"patternName"]];
        }
        @catch (NSException *exception) {
            patternName=@"";
        }
        [av textFieldAtIndex:0].text=[NSString stringWithFormat:@"%@",patternName];
        [av show];
        
    }
}

- (void)deleteButtonFunction:(UIButton *)sender
{
    int type=(int)sender.tag/10000;
    int index=(int)sender.tag%10000;
    NSLog(@"Delete");
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    if(type == 1)
    {
        //Ball Name
        @try {
            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"Id=%@&",[[[equipmentDetailDictionary objectForKey:@"BowlNames"] objectAtIndex:index] objectForKey:@"id"]] url:@"UserStat/DeleteEquipmentBowlingBallName" contentType:@"" httpMethod:@"DELETE"];
            NSDictionary *response=[json objectForKey:@"responseString"];
            NSLog(@"responseDict=%@",response);
//            if([[json objectForKey:@"responseStatusCode"] intValue] == 200)
//            {
                [[DataManager shared]removeActivityIndicator];
                NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:[equipmentDetailDictionary  objectForKey:@"BowlNames"]];
                [temp removeObjectAtIndex:index];
                [equipmentDetailDictionary removeObjectForKey:@"BowlNames"];
                [equipmentDetailDictionary setObject:temp forKey:@"BowlNames"];
                [heightOfCellArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"BowlNames"] count]*29 + 29]];
//
//            }
//            else
//            {
//                [[DataManager shared]removeActivityIndicator];
//                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                
//            }
            
            [equipmentTableView reloadData];

        }
        @catch (NSException *exception) {
            [[DataManager shared]removeActivityIndicator];
            [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
    else
    {
        //pattern name
        @try {
            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"Id=%@&",[[[equipmentDetailDictionary objectForKey:@"PatternNames"] objectAtIndex:index] objectForKey:@"id"]] url:@"UserStat/DeleteEquipmentPatternName" contentType:@"" httpMethod:@"DELETE"];
            NSDictionary *response=[json objectForKey:@"responseString"];
            NSLog(@"responseDict=%@",response);
//            if([[json objectForKey:kResponseStatusCode] intValue] == 200)
//            {
                [[DataManager shared]removeActivityIndicator];
                NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:[equipmentDetailDictionary  objectForKey:@"PatternNames"]];
                [temp removeObjectAtIndex:index];
                [equipmentDetailDictionary removeObjectForKey:@"PatternNames"];
                [equipmentDetailDictionary setObject:temp forKey:@"PatternNames"];
                [heightOfCellArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",(int)[[equipmentDetailDictionary objectForKey:@"PatternNames"] count]*29 + 29]];
            
            [equipmentTableView reloadData];
//            }
//            else
//            {
//                [[DataManager shared]removeActivityIndicator];
//                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                
//            }

        }
        @catch (NSException *exception) {
            [[DataManager shared]removeActivityIndicator];
            [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
       
    }
}
#pragma mark - Picker view DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pV numberOfRowsInComponent:(NSInteger)component
{

    
    int num = 0;
    if (pV.tag == 100) {
        num = (int)[countryInfoDict count];
    }
    else if (pV.tag == 200){
        num =(int) [[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count];
    }
    else if (pV.tag == 300){
        num = (int)[centerDetails count];
    }
    else if (pV.tag == 400)
    {
        num = (int)[patternNamesArray count];
    }
    else if (pV.tag == 500)
    {
        num = (int)[gameTypeNamesArray count];
    }
    else if (pV.tag == 600)
    {
        num = (int)[graphTypesArray count];
    }
    else if (pV.tag == 800)
    {
        num = (int)[patternLengthArray count];
    }
    else
    {
        num = 2;
    }
    
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pV titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    if(pV.tag == 700)
    {
        if(row == 0)
            string=@"Individual Users";
        else
            string=@"All XBowlers";
    }
    else if (pV.tag == 100) {
        string = [[countryInfoDict objectAtIndex:row] objectForKey:@"displayName"];
    }
    else if (pV.tag == 200){
        string = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:row] objectForKey:@"displayName"];
    }
    else if (pV.tag == 300){
        string = [[centerDetails objectAtIndex:row] objectForKey:@"name"];
    }
    else if (pV.tag == 400)
    {
        string = [[patternNamesArray objectAtIndex:row] objectForKey:@"patternName"];
    }
    else if (pV.tag == 500)
    {
        string = [[gameTypeNamesArray objectAtIndex:row] objectForKey:@"competition"];
    }
    else if (pV.tag == 800)
    {
        string = [[patternLengthArray objectAtIndex:row] objectForKey:@"patternLength"];
    }
    else
    {
        string = [graphTypesArray objectAtIndex:row];
    }
    return string;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pV.tag == 100) {
        selectedCountryIndex = (int)row;
        selectedStateIndex = 0;
        selectedCenterIndex = 0;
        
    }
    else if (pV.tag == 200){
        selectedStateIndex = (int)row;
        selectedCenterIndex = 0;
    }
    else if (pV.tag == 300){
        selectedCenterIndex = (int)row;
    }
    else if (pV.tag == 400){
        selectedOilPattern = (int)row;
    }
    else if (pV.tag == 500){
        selectedGameType = (int)row;
    }
    else if (pV.tag == 800){
        selectedPatternLength = (int)row;
    }
    else if (pV.tag == 600)
        selectedGraphType=(int)row;
    else
        selectedComparisonType = (int)row;
    [[NSUserDefaults standardUserDefaults]setInteger:selectedCountryIndex forKey:kfilterCountryIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:selectedStateIndex forKey:kfilterStateIndex];
    [[NSUserDefaults standardUserDefaults]setInteger:selectedCenterIndex forKey:kfilterVenueIndex];
}

#pragma mark - make comparison
- (void)makecomparisonButtonFunction
{
    if(comparisonItemselectArray.count==0 && selectedComparisonType == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"Please select a Xbowler first."]
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        
        
        NSLog(@"called");
        NSString *urlStringSingle=@"UserStat/BowlingGameUserStatViewListComparisonByUser";
        @try {
            [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
            NSString *params;
            if(selectedComparisonType == 0)
                params=[NSString stringWithFormat:@"anotherUserId=%@&",[comparisonItemselectArray objectAtIndex:0]];
            else
            {
                params=[NSString stringWithFormat:@"VenueId=%@&",[[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"id"]];
                urlStringSingle=@"UserStat/BowlingGameUserStatViewListComparisonByVenue";
            }
            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:params url:urlStringSingle contentType:@"" httpMethod:@"GET"];
            NSDictionary *response=[json objectForKey:@"responseString"];
            NSLog(@"responseDict=%@",response);
            if([[json objectForKey:@"responseStatusCode"] intValue] == 200 && response.count > 0)
            {
                [[DataManager shared]removeActivityIndicator];
                NSLog(@"%@",json);
                NSArray *passComparison=response;
                if(passComparison.count > 0)
                {
                    if([[passComparison objectAtIndex:0] count]>0)
                    {
                        [self showComparisonViewFunction:passComparison];
                    }
                }
            }
            else
            {
                [[DataManager shared]removeActivityIndicator];
                [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }

        }
        @catch (NSException *exception)
        {
            [[DataManager shared]removeActivityIndicator];
            [[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
    
}
-(void)removeSubviews:(UIButton*)sender
{
    for(UIView *view in sender.superview.subviews)
    {
        [view removeFromSuperview];
        //  view=nil;
    }
    [sender.superview removeFromSuperview];
    [clearColorview removeFromSuperview];
    clearColorview=nil;
    [enterScoreImageView removeFromSuperview];
    enterScoreImageView=nil;
    
    
}

-(void)showComparisonViewFunction:(NSArray *)displayarray
{
    statsComparisonView=[[ComparisonView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    statsComparisonView.delegate=self;
    [self addSubview:statsComparisonView];
    if (selectedComparisonType == 0) {
        [statsComparisonView createComparisonViewWithData:displayarray andOpponentName:[[bowlersArray objectAtIndex:selectedOpponentIndex] objectForKey:@"screenName"]];
    }
    else{
        [statsComparisonView createComparisonViewWithData:displayarray andOpponentName:@"Others"];
    }
    
}

- (void)removeComparisonView
{
    [statsComparisonView removeFromSuperview];
    statsComparisonView=nil;
    @try {
        if (comparisonItemselectArray.count > 0) {
            UIImageView *btn12= (UIImageView *)[self viewWithTag:[[comparisonItemselectArray objectAtIndex:0] integerValue]];
            [btn12 setImage:[UIImage imageNamed:@"check_off.png"]];
            [comparisonItemselectArray removeAllObjects];
        }
    }
    @catch (NSException *exception) {
        
    }
    
    
}

-(void)getAllXBowlers :(UIImageView *)backimg stringbowlers:(NSString *)searchString
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        searchOn=NO;
        NSString *siteurl;
        if(searchString == nil)
        {
            searchString=@"";
            siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
        }
        else
        {
            siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        }
        searchXBowler=searchString;
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=100&search=%@",siteurl,token,apiKey,searchString];
     
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
       
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
           NSMutableArray*  allXBowlersArray =[[NSMutableArray alloc]initWithArray:json];
            NSLog(@"allXBowlersArray=%@",allXBowlersArray);
            [self showscrollview:allXBowlersArray backgroundmain:backgroundView];
    
        }
        else
            [[DataManager shared]removeActivityIndicator];
    }
    
}

#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    searchOn=YES;
    if(textField.text.length > 0)
    {
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    //TODO: add search code here
    //searchImplemented=1;
    //searchName=textField.text;
    if(allxbowlers==false)
    {
        NSMutableArray *filteredFriendsArray=[[NSMutableArray alloc]init];
        [filteredFriendsArray removeAllObjects];
        for (NSDictionary* friend in myFriendsArray)
        {
            NSLog(@"friend=%@",friend);
            NSString *friendName=[friend objectForKey:kScreenName];
            NSRange nameRange = [friendName rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredFriendsArray addObject:friend];
            }
        }
        [self showscrollview:filteredFriendsArray backgroundmain:backgroundView];
        
    }
    else
    {
        //    if(showfriends == YES)
        //    {
        //        [filteredFriendsArray removeAllObjects];
        //        for (NSDictionary* friend in myFriendsArray)
        //        {
        //            NSLog(@"friend=%@",friend);
        //            NSString *friendName=[friend objectForKey:kScreenName];
        //
        //            NSRange nameRange = [friendName rangeOfString:searchName options:NSCaseInsensitiveSearch];
        //            if(nameRange.location != NSNotFound)
        //            {
        //                [filteredFriendsArray addObject:friend];
        //            }
        //
        //        }
        //        [self updateScrollView:filteredFriendsArray searchstring:searchName];
        //        [[DataManager shared]removeActivityIndicator];
        //
        //    }
        //    else
        //{
        [textField resignFirstResponder];
        
        NSLog(@"searchString=%@",textField.text);
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        [self allXBowlersAsyncCall:textField.text];
    }
    //}
    }
    [searchchBar resignFirstResponder];
    return YES;
}
-(void)allXBowlersButtonFunction
{
    searchchBar.text=@"";
    allxbowlers=YES;
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [btnsBaseImagecompare setImage:[UIImage imageNamed:@"all_xbowlers.png"]];
    [self getAllXBowlers:btnsBaseImagecompare stringbowlers:nil];
    
}

-(void)friendbuttonAction:(UIButton *)sender
{
    allxbowlers=NO;
    searchchBar.text=@"";
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    
    // UIImageView *background=[(UIImageView *)sender.superview];
    [btnsBaseImagecompare setImage:[UIImage imageNamed:@"my_friends.png"]];
    [self getAllFriends];
    //}
}

-(void)getAllFriends
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        NSString *siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=100",siteurl,token,apiKey];
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
           myFriendsArray=[[NSMutableArray alloc]initWithArray:json];
            //  NSLog(@"json=%@",myFriendsArray);
            
            [self showscrollview:json backgroundmain:backgroundView];
            // numberofbowlersdisplayed=(int)myFriendsArray.count;
            //[self showscrollview:myFriendsArray searchString:nil];
            
        }
        else
            [[DataManager shared]removeActivityIndicator];
    }
    
}


-(void)showscrollview:(NSArray *)allbowlersArray backgroundmain:(UIImageView *)btnsBaseImage
{
    [[DataManager shared]removeActivityIndicator];
    [baseScrollcompare removeFromSuperview];
    baseScrollcompare=nil;
    [makeComparison removeFromSuperview];
    makeComparison=nil;
    [suggestionlabel removeFromSuperview];
    suggestionlabel =nil;
    

    bowlersArray=[[NSMutableArray alloc]initWithArray:allbowlersArray];
    if(allbowlersArray.count==0)
    {
        [searchchBar removeFromSuperview];
        UIView *separator1=(UIView *)[self viewWithTag:101];
        [separator1 removeFromSuperview];
        UIView *separator2=(UIView *)[self viewWithTag:102];
        [separator2 removeFromSuperview];

        //suggestionlabel;
        suggestionlabel= [[UILabel alloc]init];
//        suggestionlabel.backgroundColor=[UIColor redColor];
        suggestionlabel.text=@"No friends are currently available.";
        if(allxbowlers == YES)
             suggestionlabel.text=@"No result found for your search.";
        suggestionlabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14.5];
        suggestionlabel.textColor=[UIColor whiteColor];
        suggestionlabel.textAlignment=NSTextAlignmentCenter;
        [suggestionlabel setFrame:CGRectMake(0,searchchBar.frame.size.height + searchchBar.frame.origin.y + 40, backgroundView.frame.size.width, 18)];
        suggestionlabel.center=backgroundView.center;
        [backgroundView addSubview:suggestionlabel];
        // searchchBar.hidden=YES;
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            //space on top and bottom of mainImgView 130
            if (screenBounds.size.height == 480)
            {
                suggestionlabel.frame=CGRectMake(0, searchchBar.frame.size.height + searchchBar.frame.origin.y + 40, suggestionlabel.frame.size.width, suggestionlabel.frame.size.height);
            }
        }
        
    }
    else
    {
        baseScrollcompare=[[UIScrollView alloc]init];
        baseScrollcompare.frame=CGRectMake(0,searchchBar.frame.size.height+searchchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], backgroundView.frame.size.width ,backgroundView.frame.size.height - (searchchBar.frame.size.height+searchchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:71 currentSuperviewDeviceSize:screenBounds.size.height]));
        baseScrollcompare.backgroundColor=[UIColor clearColor];
        [backgroundView addSubview:baseScrollcompare];
  
        UILabel *regionsLabel;
        
        int ycoordinate=2;
        for(int i=0;i<allbowlersArray.count;i++)
        {
            UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, baseScrollcompare.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            cellView.tag=i+1000;
            cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
//            cellView.backgroundColor=[UIColor redColor];
            [baseScrollcompare addSubview:cellView];
            
            UIButton *baseBtn=[[UIButton alloc]init];
            if(allxbowlers==YES)
            {
                baseBtn.tag=[[[allbowlersArray objectAtIndex:i] objectForKey:@"userId"]integerValue];
            }
            else{
                baseBtn.tag=[[[allbowlersArray objectAtIndex:i] objectForKey:@"userId"]integerValue];
            }
            baseBtn.backgroundColor=[UIColor clearColor];
            baseBtn.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.width],cellView.frame.size.height);
            [baseBtn addTarget:self action:@selector(comparecheckbox:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:baseBtn];
            UIImageView *checkBox=[[UIImageView alloc]init];
            checkBox.frame=CGRectMake(8, 1, 22, 20.5);
            checkBox.tag=10000*baseBtn.tag;
            checkBox.center=CGPointMake(checkBox.center.x, baseBtn.center.y);
            [checkBox setImage:[UIImage imageNamed:@"check_off.png"]];
            [baseBtn addSubview:checkBox];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:2];

            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(baseBtn.frame.size.width+baseBtn.frame.origin.x, 3, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height - 3)];
            nameLabel.textColor=[UIColor whiteColor];
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.numberOfLines=0;
            NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[allbowlersArray objectAtIndex:i] objectForKey:kScreenName]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH1size]}];
            [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
            nameLabel.attributedText=nameString;
            NSLog(@"nameText=%@",nameString);
            [cellView addSubview:nameLabel];
            
            regionsLabel= [[UILabel alloc]init];
            regionsLabel.text=[NSString stringWithFormat:@"%@, %@",[[allbowlersArray objectAtIndex:i] objectForKey:@"regionLongName"],[[allbowlersArray objectAtIndex:i] objectForKey:@"countryCode"]];
            regionsLabel.backgroundColor=[UIColor clearColor];
            regionsLabel.textColor=[UIColor whiteColor];
            regionsLabel.textAlignment=NSTextAlignmentCenter;
            regionsLabel.numberOfLines=2;
            regionsLabel.lineBreakMode=NSLineBreakByWordWrapping;
            regionsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
            [regionsLabel setFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width],3,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:490/3 currentSuperviewDeviceSize:screenBounds.size.width],cellView.frame.size.height - 3)];
            [cellView addSubview:regionsLabel];
            
            UIView *separatorImage=[[UIView alloc]init];
            separatorImage.frame=CGRectMake(0,cellView.frame.size.height - 0.5,cellView.frame.size.width, 0.5);
            separatorImage.backgroundColor=separatorColor;
            [cellView addSubview:separatorImage];
            ycoordinate=cellView.frame.size.height+cellView.frame.origin.y;
            
        }
        
        baseScrollcompare.contentSize=CGSizeMake(baseScrollcompare.frame.size.width, ycoordinate+50);
        ycoordinateForBowlersList = ycoordinate;
        if (allxbowlers == YES && searchchBar.text.length == 0 && searchOn == NO)
        {
            numberofbowlersdisplayed=(int)allbowlersArray.count;

            UIButton *loadmoreBtn=[[UIButton alloc] init];
            loadmoreBtn.frame=CGRectMake(baseScrollcompare.frame.origin.x+baseScrollcompare.frame.size.width/2-30, ycoordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], 93,28);
//            loadmoreBtn.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
            [loadmoreBtn setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3] buttonframe:self.frame] forState:UIControlStateNormal];
            [loadmoreBtn setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7] buttonframe:self.frame] forState:UIControlStateHighlighted];
            loadmoreBtn.layer.cornerRadius=loadmoreBtn.frame.size.height/2;
            //loadmoreBtn.titleLabel.text=@"Load More";
            loadmoreBtn.center=CGPointMake(baseScrollcompare.center.x, loadmoreBtn.center.y);
            loadmoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [loadmoreBtn setTitle: @"Load More" forState: UIControlStateNormal];
            loadmoreBtn.titleLabel.textColor=[UIColor whiteColor];
            [loadmoreBtn addTarget:self action:@selector(loadmorebowlersMethod:) forControlEvents:UIControlEventTouchUpInside];
            [baseScrollcompare addSubview:loadmoreBtn];
        }
        makeComparison=[[UIButton alloc]init];
        makeComparison.tag=15000;
        makeComparison.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [makeComparison setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [makeComparison setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [makeComparison addTarget:self action:@selector(makecomparisonButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:makeComparison];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, makeComparison.frame.size.width, makeComparison.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"      Make Comparison";
        titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height] ];
        [makeComparison addSubview:titleLabel];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(makeComparison.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, makeComparison.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [makeComparison addSubview:arrow];

    }
}
-(void)loadmorebowlersMethod:(UIButton *)sender{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    int difference;
    difference=10;
    
    
    if(bowlersArray.count<numberofbowlersdisplayed){
        difference=(int)numberofbowlersdisplayed-(int)bowlersArray.count;
        numberofbowlersdisplayed=(int)bowlersArray.count;
    }
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        NSString *siteurl;
        if(searchXBowler.length == 0)
        {
            searchXBowler=@"";
            siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
        }
        else
        {
            siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        }
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=%lu&pageSize=50&search=%@",siteurl,token,apiKey,(unsigned long)numberofbowlersdisplayed,searchXBowler];
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            NSMutableArray*  allXBowlersArray =[[NSMutableArray alloc]initWithArray:json];
            NSLog(@"allXBowlersArray=%@",allXBowlersArray);
            [bowlersArray addObjectsFromArray:allXBowlersArray];
            NSLog(@"bowlersArray array %@", bowlersArray);
            UILabel *regionsLabel;
            int ycoordinate=ycoordinateForBowlersList;
            for(int i=numberofbowlersdisplayed;i<bowlersArray.count;i++)
            {
                UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, ycoordinate, baseScrollcompare.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
                cellView.tag=i+1000;
                cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
                //            cellView.backgroundColor=[UIColor redColor];
                [baseScrollcompare addSubview:cellView];
                
                UIButton *baseBtn=[[UIButton alloc]init];
                if(allxbowlers==YES)
                {
                    baseBtn.tag=[[[bowlersArray objectAtIndex:i] objectForKey:@"userId"]integerValue];
                }
                else{
                    baseBtn.tag=[[[bowlersArray objectAtIndex:i] objectForKey:@"userId"]integerValue];
                }
                baseBtn.backgroundColor=[UIColor clearColor];
                baseBtn.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.width],cellView.frame.size.height);
                [baseBtn addTarget:self action:@selector(comparecheckbox:) forControlEvents:UIControlEventTouchUpInside];
                [cellView addSubview:baseBtn];
                UIImageView *checkBox=[[UIImageView alloc]init];
                checkBox.frame=CGRectMake(8, 1, 22, 20.5);
                checkBox.tag=10000*baseBtn.tag;
                checkBox.center=CGPointMake(checkBox.center.x, baseBtn.center.y);
                [checkBox setImage:[UIImage imageNamed:@"check_off.png"]];
                [baseBtn addSubview:checkBox];
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:2];
                
                UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(baseBtn.frame.size.width+baseBtn.frame.origin.x, 3, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height - 3)];
                nameLabel.textColor=[UIColor whiteColor];
                nameLabel.backgroundColor=[UIColor clearColor];
                nameLabel.numberOfLines=0;
                NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[bowlersArray objectAtIndex:i] objectForKey:kScreenName]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH1size]}];
                [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
                nameLabel.attributedText=nameString;
                NSLog(@"nameText=%@",nameString);
                [cellView addSubview:nameLabel];
                
                regionsLabel= [[UILabel alloc]init];
                regionsLabel.text=[NSString stringWithFormat:@"%@, %@",[[bowlersArray objectAtIndex:i] objectForKey:@"regionLongName"],[[bowlersArray objectAtIndex:i] objectForKey:@"countryCode"]];
                regionsLabel.backgroundColor=[UIColor clearColor];
                regionsLabel.textColor=[UIColor whiteColor];
                regionsLabel.textAlignment=NSTextAlignmentCenter;
                regionsLabel.numberOfLines=2;
                regionsLabel.lineBreakMode=NSLineBreakByWordWrapping;
                regionsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
                [regionsLabel setFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width],3,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:490/3 currentSuperviewDeviceSize:screenBounds.size.width],cellView.frame.size.height - 3)];
                [cellView addSubview:regionsLabel];
                
                UIView *separatorImage=[[UIView alloc]init];
                separatorImage.frame=CGRectMake(0,cellView.frame.size.height - 0.5,cellView.frame.size.width, 0.5);
                separatorImage.backgroundColor=separatorColor;
                [cellView addSubview:separatorImage];
                ycoordinate=cellView.frame.size.height+cellView.frame.origin.y;
                
            }
            ycoordinateForBowlersList=ycoordinate ;
            baseScrollcompare.contentSize=CGSizeMake(baseScrollcompare.frame.size.width, ycoordinate+50);

            //shifting load more btn down
            if(difference==10)
            {
                sender.frame=CGRectMake(sender.frame.origin.x, ycoordinateForBowlersList+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], sender.frame.size.width, sender.frame.size.height);
            }
            else{
                [sender removeFromSuperview];
            }
            numberofbowlersdisplayed=bowlersArray.count;
            [[DataManager shared]removeActivityIndicator];
            
        }
        else
            [[DataManager shared]removeActivityIndicator];
    }
 
}

-(void)allXBowlersAsyncCall:(NSString *)searchString
{
    if (searchRequest) {
        [searchRequest clearDelegatesAndCancel];
    }
    NSString *siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSLog(@"token=%@",token);
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=100&search=%@",siteurl,token,apiKey,searchString];
  
    NSLog(@"enquiryurl=%@",enquiryurl);
    
    searchRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:enquiryurl]];
    [searchRequest setTimeOutSeconds:10];
    [searchRequest setDelegate:self];
    [searchRequest startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)ASIrequest
{
    NSLog(@"data=%@",[[NSString alloc]initWithData:[ASIrequest responseData] encoding:NSUTF8StringEncoding] );
    if([ASIrequest responseData])
    {
        NSArray* filteredXbowlersArray=nil;
        filteredXbowlersArray=[NSArray new];
        filteredXbowlersArray = [NSJSONSerialization JSONObjectWithData:[ASIrequest responseData] options:kNilOptions error:nil];
        NSLog(@"jsonnnnnnnnnn: %@", filteredXbowlersArray);
        
        //  alreadypopview=YES;
        [self showscrollview:filteredXbowlersArray backgroundmain:btnsBaseImagecompare];
        
        // [self updateScrollView:filteredXbowlersArray searchstring:@"fzv"];
        [[DataManager shared]removeActivityIndicator];
        //        [self showscrollview:json searchString:searchName];
    }
    
    
}

- (void)comparecheckbox:(UIButton *)sender
{
    selectedOpponentIndex =(int)sender.superview.tag - 1000;
    if([comparisonItemselectArray containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag] ])
    {
        UIImageView *btn12= (UIImageView *)[self viewWithTag:sender.tag *10000];
        [btn12 setImage:[UIImage imageNamed:@"check_off.png"]];
        [comparisonItemselectArray removeAllObjects];
        
    }
    else{
        if(comparisonItemselectArray.count>0)
        {
            
            UIImageView *btn12= (UIImageView *)[self viewWithTag:[[comparisonItemselectArray objectAtIndex:0]integerValue] *10000];
            [btn12 setImage:[UIImage imageNamed:@"check_off.png"]];
            [comparisonItemselectArray removeAllObjects];
            
        }
        UIImageView *btn= (UIImageView *)[self viewWithTag:sender.tag*10000];
        [btn setImage:[UIImage imageNamed:@"check_on.png"]];
        [comparisonItemselectArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        
     }
    
}


#pragma mark - To get nearby location for filter

- (void)venueInfo{
    
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSString *urlString = [NSString stringWithFormat:@"%@venue/locations?apiKey=%@", serverAddress,APIKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:kTimeoutInterval];
    
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        countryInfoDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    NSLog(@"returnDict: %@",countryInfoDict);
}

- (void)selectCenter{
    
    NSString *urlString = [NSString stringWithFormat:@"%@venue/locations/%@/%@?apiKey=%@", serverAddress, [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"], [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"], APIKey];
    //NSLog(@"url = %@", urlString);
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:kTimeoutInterval];
    
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        centerDetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    NSLog(@"centerDetails %@",centerDetails);
    
}
-(void)geolocationServerCall
{
    double latitude;
    double longitude;
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *urlString;
    NSMutableURLRequest *request;
    urlString=[NSString stringWithFormat:@"%@geolocation",serverAddress];
    
    NSLog(@"urlString %@",urlString);
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
               
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
               
                                  timeoutInterval:kTimeoutInterval];
    NSDictionary *locationsdata;
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        locationsdata = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        latitude = [[locationsdata objectForKey:@"latitude"] doubleValue];
        longitude =[[locationsdata objectForKey:@"longitude"] doubleValue];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",latitude] forKey:kLatitude];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",longitude] forKey:kLongitude];
        
    }
}
-(void)nearbyCenter{
    
    double latitude;
    double longitude;
    latitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLatitude] floatValue];
    longitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLongitude] floatValue];
//    if (latitude == 0.0000 && longitude == 0.0000) {
//        [self geolocationServerCall];
//        latitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLatitude] floatValue];
//        longitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLongitude] floatValue];
//    }
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSMutableURLRequest *request;
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"%@venue/nearby/?apiKey=%@&token=%@&latitude=%f&longitude=%f&distanceLimitMiles=25", serverAddress, APIKey, token, latitude, longitude];
    NSLog(@"urlstring %@", urlString);
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:kTimeoutInterval];
    
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if ([json count] >0) {
            NSLog(@"center %@",[[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"longName"]);
            NSString *state = [[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"longName"];
            NSString *country = [[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"countryDisplayName"];
            NSString *center = [[json objectAtIndex:0]  objectForKey:@"name"] ;
            NSLog(@"country %@, state %@, center %@", country, state, center);
            NSMutableArray *countryArray = [[NSMutableArray alloc] init];
            NSMutableArray *stateArray = [[NSMutableArray alloc] init];
            NSMutableArray *centerArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i<[countryInfoDict count]; i++) {
                [countryArray addObject:[[countryInfoDict objectAtIndex:i] objectForKey:@"displayName"]];
            }
            if ([countryArray containsObject:country]) {
                selectedCountryIndex = (int)[countryArray indexOfObject:country];
            }
            selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
            for (int i = 0; i<[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count]; i++) {
                [stateArray addObject:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:i] objectForKey:@"displayName"]];
            }
            if ([stateArray containsObject:state]) {
                selectedStateIndex =(int) [stateArray indexOfObject:state];
            }
            selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
            [self selectCenter];
            if(centerDetails.count >0)
            {
                for (int i = 0; i<[centerDetails count]; i++) {
                    [centerArray addObject:[[centerDetails objectAtIndex:i] objectForKey:@"name"]];
                }
                if ([centerArray containsObject:center]) {
                    selectedCenterIndex =(int) [centerArray indexOfObject:center];
                }
                selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                
            }
            else
            {
                selectCenterImageView.textLabel.text=@"Select Center";
            }
            
            
        }
        else{}
    }
    
    
}

#pragma mark - Keyboard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 145;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if([UIScreen mainScreen].bounds.size.height != 568.0)
//    {
        CGRect textFieldRect = [self.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect = [self.superview.window convertRect:self.superview.bounds fromView:self.superview];
        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
        CGFloat heightFraction = numerator / denominator;
        
        if (heightFraction < 0.0)
        {
            heightFraction = 0.0;
        }
        else if (heightFraction > 1.0)
        {
            heightFraction = 1.0;
        }
        UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        }
        else
        {
            animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        }
        
        CGRect viewFrame = self.superview.frame;
        NSLog(@"animated=%f",animatedDistance);
        NSLog(@"y=%f",viewFrame.origin.y);
        viewFrame.origin.y -= animatedDistance;
        NSLog(@"y=%f",viewFrame.origin.y);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.superview setFrame:viewFrame];
        [UIView commitAnimations];
        
//    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if([UIScreen mainScreen].bounds.size.height != 568.0)
//    {
        CGRect viewFrame = self.superview.frame;
        viewFrame.origin.y += animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.superview setFrame:viewFrame];
        [UIView commitAnimations];
//    }
}


@end
