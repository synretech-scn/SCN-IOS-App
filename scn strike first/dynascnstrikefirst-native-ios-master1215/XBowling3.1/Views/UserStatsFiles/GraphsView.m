//
//  GraphsView.m
//  XBowling3.1
//
//  Created by Click Labs on 3/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "GraphsView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.width)
@implementation GraphsView
{
    UIImageView *backgroundView;
    UIImageView *headerBaseView;
    UIImageView *filterView;
    NSArray *stepsImagesArray;
    NSArray *stepsLabelArray;
    //    UIActionSheet *actionSheet;
    CustomActionSheet *actionSheet;
    UIPickerView *pickerView ;
    int selectedGraphType;
    DropDownImageView *graphTypeImageView;
    DropDownImageView *comparisonWithImageView;
    int stepIndex; // to keep track of the current step
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
    
    int numberofbowlersdisplayed;
    NSMutableArray *bowlersArray;
    int ycoordinateForBowlersList;
    NSString *searchXBowler;
    BOOL searchOn;
    BOOL showListView;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createGraphView];
    }
    return self;
}

- (void)createGraphView
{
    graphTypesArray=[[NSArray alloc]initWithObjects:@"Average Score",@"High Score",@"Open/Spare/Strike",@"Score Distribution",@"Multi-Pin Spare Conversion",@"Split Conversion",@"Oil Pattern",@"Single-Pin Spare Conversion",@"Ball Type Spare-Strike Percentage",@"First Ball Average based on Ball Type", nil];
    graphServerUrlArray=[[NSArray alloc]initWithObjects:@"UserStat/GetAverageScoreGraph",@"UserStat/GetHighestScoreGraph_ByUser",@"UserStat/GetSpare_StrikeGraph",@"UserStat/GetScoreDistributionGraph",@"UserStat/GetMultipinAndSplit_SplitConversionGraph",@"UserStat/GetMultipinAndSplit_SplitConversionGraph",@"UserStat/GetOilPatternGraph_ByUser",@"UserStat/GetSinglePinGraph",@"UserStat/GetSpare_StrikeGraphByBallType",@"UserStat/GetAverageScoreGraphByBallType", nil];
    selectedGraphType=(int)[[NSUserDefaults standardUserDefaults]integerForKey:kselectedGraph];

    selectedPinStatsArray=[NSMutableArray new];
    comparisonItemselectArray=[NSMutableArray new];
    backgroundView=[[UIImageView alloc]init];
    backgroundView.frame=CGRectMake(0,0,SCREEN_HEIGHT, SCREEN_WIDTH);
    backgroundView.userInteractionEnabled=YES;
    [backgroundView setImage:[UIImage imageNamed:@"mainbackground.png"]];
    [self addSubview:backgroundView];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [self addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT/2-200, headerView.frame.size.height+3- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:SCREEN_WIDTH]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width]-10, 400, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
    headerLabel.text=@"Graphs";
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [headerView addSubview:headerLabel];
    UIButton *filterButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:230/3 currentSuperviewDeviceSize:SCREEN_HEIGHT], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:17/3 currentSuperviewDeviceSize:SCREEN_WIDTH], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:230/3 currentSuperviewDeviceSize:SCREEN_HEIGHT], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
    filterButton.backgroundColor=[UIColor clearColor];
    filterButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [filterButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [filterButton addTarget:self action:@selector(filterButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:filterButton];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:135/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
//        stepIndex=(int)sender.tag - 8100;
    //graph view
    graphTypeImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0,headerView.frame.size.height+headerView.frame.origin.y+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:SCREEN_WIDTH], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:900/3 currentSuperviewDeviceSize:SCREEN_HEIGHT],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:130/3 currentSuperviewDeviceSize:SCREEN_WIDTH])];
    graphTypeImageView.textLabel.text=[NSString stringWithFormat:@"%@",[graphTypesArray objectAtIndex:selectedGraphType]];
    graphTypeImageView.textLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height],graphTypeImageView.dropDownImageView.frame.origin.x - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    graphTypeImageView.textLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    graphTypeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    tapRecognizer.numberOfTapsRequired = 1;
    graphTypeImageView.center=CGPointMake(self.center.x, graphTypeImageView.center.y);
    [graphTypeImageView addGestureRecognizer:tapRecognizer];
    [backgroundView addSubview:graphTypeImageView];
    graphTypeImageView.dropDownImageView.frame=CGRectMake(graphTypeImageView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:67/3 currentSuperviewDeviceSize:SCREEN_HEIGHT], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:37/3 currentSuperviewDeviceSize:SCREEN_HEIGHT], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75/3 currentSuperviewDeviceSize:SCREEN_WIDTH]);
    graphTypeImageView.dropDownImageView.center=CGPointMake(graphTypeImageView.dropDownImageView.center.x, graphTypeImageView.textLabel.center.y);
    UIView *separatorImage=[[UIView alloc]init];
    separatorImage.frame=CGRectMake(0,0, graphTypeImageView.frame.size.width, 0.5);
    separatorImage.backgroundColor=separatorColor;
    [graphTypeImageView addSubview:separatorImage];
    
    resizableScroll=[[UIScrollView alloc]init];
    resizableScroll.delegate=self;
    resizableScroll.frame=CGRectMake(2.5, graphTypeImageView.frame.size.height + graphTypeImageView.frame.origin.y + 7, backgroundView.frame.size.width - 5,self.frame.size.height - (graphTypeImageView.textLabel.frame.size.height+graphTypeImageView.textLabel.frame.origin.y));
    [backgroundView addSubview:resizableScroll];
    resizableScroll.backgroundColor=[UIColor clearColor];
    [self performSelector:@selector(initGraphView) withObject:nil afterDelay:0.2];
//    [self graphServerCall:selectedGraphType];
    
}

- (void)initGraphView
{
    [self graphServerCall:selectedGraphType];
}
#pragma mark - Button Functions
- (void)filterButtonFunction
{
    [delegate showFilterView];
}
- (void)backButtonFunction
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kselectedGraph];
    [delegate removeGraphView];
}

#pragma mark - Graph type drop-down functions

- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture {
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView *tappedImageView = (DropDownImageView *)[tapGesture view];

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
        [[NSUserDefaults standardUserDefaults]setInteger:selectedGraphType forKey:kselectedGraph];
        graphTypeImageView.textLabel.text=[NSString stringWithFormat:@"%@",[graphTypesArray objectAtIndex:selectedGraphType]];
        [self graphServerCall:selectedGraphType];
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
                    suggestions1.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                    suggestions1.textAlignment = NSTextAlignmentCenter;
                    suggestions1.textColor = [UIColor whiteColor];
                    suggestions1.backgroundColor=[UIColor clearColor];
                    suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
                    suggestions1.numberOfLines=2;
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
                    suggestions1.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                    suggestions1.textAlignment = NSTextAlignmentCenter;
                    suggestions1.textColor = [UIColor whiteColor];
                    suggestions1.backgroundColor=[UIColor clearColor];
                    suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
                    suggestions1.numberOfLines=2;
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
            suggestions1.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            suggestions1.textAlignment = NSTextAlignmentCenter;
            suggestions1.textColor = [UIColor whiteColor];
            suggestions1.backgroundColor=[UIColor clearColor];
            suggestions1.text = @"You have no stats for this graph. \nPlease play more games.";
            suggestions1.numberOfLines=2;
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
            lineGraphView=[[LineGraph alloc]initWithFrame:CGRectMake(3, 15, 500, resizableScroll.frame.size.height)];
            resizableScroll.contentOffset=CGPointMake(0, 0);
            //            resizableScroll.contentSize=CGSizeMake(0,150);
        }
        else{
            
            lineGraphView=[[LineGraph alloc]initWithFrame:CGRectMake(3, 15, 500+(dataArray.count-7)*60+100, resizableScroll.frame.size.height)];
            //            resizableScroll.contentOffset=CGPointMake(0, 140);
            resizableScroll.contentSize=CGSizeMake(600+(dataArray.count-7)*60+100,150);
        }
        [lineGraphView lineGraphData:dataArray xAxis:xaxisString yAxis:yaxisString];
//        lineGraphView.backgroundColor=[UIColor greenColor];
        [resizableScroll addSubview:lineGraphView];
        
    }
    else if(index ==3)
    {
        //pie chart
        
        PCPieChart *pieChart=[[PCPieChart alloc]initWithFrame:CGRectMake(3, 0, resizableScroll.frame.size.width - 6, resizableScroll.frame.size.height )];
        if(dataArray.count == 7)
            pieChart=[[PCPieChart alloc]initWithFrame:CGRectMake(3, 0, resizableScroll.frame.size.width - 6, resizableScroll.frame.size.height )];
        [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [pieChart setDiameter:160];
        [pieChart setSameColorLabel:YES];
        resizableScroll.contentOffset=CGPointMake(0, 0);
        resizableScroll.contentSize=CGSizeMake(0,pieChart.frame.size.height);
        resizableScroll.delegate=self;
        [resizableScroll addSubview:pieChart];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            pieChart.titleFont = [UIFont fontWithName:AvenirDemi size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            pieChart.percentageFont = [UIFont fontWithName:AvenirDemi size:[[DataManager shared] getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
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
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 10, 500, resizableScroll.frame.size.height)];
        }
        else
        {
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 10, 600+(dataArray.count-7)*75, resizableScroll.frame.size.height)];
        }
        if([xaxisString length]==0)
        {
            barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 10,670, resizableScroll.frame.size.height)];
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
                barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 10, 500, resizableScroll.frame.size.height)];
                
                resizableScroll.contentSize=CGSizeMake(450,150);
            }
            else
            {
                resizableScroll.contentSize=CGSizeMake(500+(countcheck-7)*56+60,150);
                barChartView=[[BarChart alloc]initWithFrame:CGRectMake(1, 10, 550+(countcheck-7)*75, resizableScroll.frame.size.height)];
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

#pragma mark - Picker view DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pV numberOfRowsInComponent:(NSInteger)component
{
    
    
    int num = 0;
    if (pV.tag == 600)
    {
        num = (int)[graphTypesArray count];
    }
    
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pV titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    string = [graphTypesArray objectAtIndex:row];
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


@end
