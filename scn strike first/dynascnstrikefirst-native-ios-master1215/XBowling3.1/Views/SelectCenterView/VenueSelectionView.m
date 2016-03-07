//
//  VenueSelectionView.m
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "VenueSelectionView.h"

@implementation VenueSelectionView
{
    UITextField *laneTextField;
    UILabel *laneRangeLabel;
    UITextField *nameTextField;
    NSString *selectedCountry,*selectedState,*selectedCenter;
    int lanes;
    float animatedDistance;
    NSDictionary *responseDictionary;
}
@synthesize venueDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
      }
    return self;
}

- (void)createMainViewWithCenterView:(SelectCenterView *)selectCenterView
{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:kUserStatsPackagePurchased])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"-1" forKey:kCompetitionTypeId];
        [[NSUserDefaults standardUserDefaults]setValue:@"-1" forKey:kPatternLengthId];
        [[NSUserDefaults standardUserDefaults]setValue:@"-1" forKey:kPatternNameId];
    }

    
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=XBHeaderColor;
    [self addSubview:headerView];
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:194 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Go XBowling";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
   
    selectCenterView.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y, screenBounds.size.width, 100);
    [selectCenterView createView];
    [self addSubview:selectCenterView];
    
    //Lane Number box
    UIImageView *laneNumberBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, selectCenterView.frame.size.height + selectCenterView.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    laneNumberBackground.userInteractionEnabled=YES;
    [self addSubview:laneNumberBackground];
    //        UIView *separatorImage=[[UIView alloc]init];
    //        separatorImage.frame=CGRectMake(0, 0, self.frame.size.width, 0.5);
    //        separatorImage.backgroundColor=separatorColor;
    //        [laneNumberBackground addSubview:separatorImage];
    
    laneTextField =  [[UITextField alloc] initWithFrame: CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.height],laneNumberBackground.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    laneTextField.textColor = [UIColor whiteColor];
    laneTextField.keyboardType = UIKeyboardTypeNumberPad;
    laneTextField.returnKeyType = UIReturnKeyNext;
    laneTextField.delegate=self;
    [laneTextField setTag:400];
    if ([laneTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        laneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Lane Number" attributes:@{NSForegroundColorAttributeName: color}];
    }
    laneTextField.backgroundColor=[UIColor clearColor];
    laneTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    laneTextField.userInteractionEnabled=YES;
    [laneNumberBackground addSubview:laneTextField];
    laneRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(laneNumberBackground.frame.size.width-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:452/3 currentSuperviewDeviceSize:screenBounds.size.width]), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:452/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    laneRangeLabel.backgroundColor = [UIColor clearColor];
    laneRangeLabel.textAlignment = NSTextAlignmentRight;
    laneRangeLabel.textColor=[UIColor grayColor];
    [laneRangeLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH3size]];
    [laneNumberBackground addSubview:laneRangeLabel];
    
    //Bowler Name box
    UIImageView *bowlerNameBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, laneNumberBackground.frame.size.height + laneNumberBackground.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    bowlerNameBackground.userInteractionEnabled=YES;
    [self addSubview:bowlerNameBackground];
    UIView *separatorImage2=[[UIView alloc]init];
    separatorImage2.frame=CGRectMake(0, 0, self.frame.size.width, 0.5);
    separatorImage2.backgroundColor=separatorColor;
    [bowlerNameBackground addSubview:separatorImage2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(bowlerNameBackground.frame.size.width-([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:26/3 currentSuperviewDeviceSize:screenBounds.size.width]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:452/3 currentSuperviewDeviceSize:screenBounds.size.width]), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:452/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor=[UIColor grayColor];
    nameLabel.numberOfLines = 2;
    //        nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [nameLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:43/3 currentSuperviewDeviceSize:screenBounds.size.height]]];
    NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:@"Must match scoring \nsystem name entry" attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH3size]}];
    [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
    nameLabel.attributedText=nameString;
    [bowlerNameBackground addSubview:nameLabel];
    
    nameTextField =  [[UITextField alloc] initWithFrame: CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.height],bowlerNameBackground.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]- nameLabel.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    nameTextField.textColor = [UIColor whiteColor];
    nameTextField.backgroundColor=[UIColor clearColor];
    nameTextField.delegate=self;
    [nameTextField setTag:500];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.returnKeyType = UIReturnKeyDone;
    [nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    if ([nameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Bowler Name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    nameTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    nameTextField.userInteractionEnabled=YES;
    [bowlerNameBackground addSubview:nameTextField];
    UIView *separatorImage3=[[UIView alloc]init];
    separatorImage3.frame=CGRectMake(0, bowlerNameBackground.frame.size.height+bowlerNameBackground.frame.origin.y, self.frame.size.width, 0.5);
    separatorImage3.backgroundColor=separatorColor;
    [self addSubview:separatorImage3];
    
    UIButton *doneButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], bowlerNameBackground.frame.size.height+bowlerNameBackground.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    doneButton.layer.cornerRadius=doneButton.frame.size.height/2;
    doneButton.clipsToBounds=YES;
    [doneButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Bowl Now" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:doneButton];

}

- (void)updateVenue:(int)laneRange country:(NSString *)country state:(NSString *)state center:(NSString *)center
{
    lanes=laneRange;
    selectedCountry=country;
    selectedState=state;
    selectedCenter=center;
    if(lanes > 1)
        laneRangeLabel.text = [NSString stringWithFormat:@"Range: 1-%d",lanes];
    else if (lanes == 1)
        laneRangeLabel.text = [NSString stringWithFormat:@"Range: %d",lanes];
    else
        laneRangeLabel.text=@"";
}

#pragma mark - Side Menu Function
- (void)sideMenuFunction:(UIButton *)sender
{
    [venueDelegate showMainMenu:sender];
}

#pragma mark - Header Bar Button Functions
- (void)doneButtonFunction:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0]];
    [self performSelector:@selector(changeDoneButtonBackgroundColor:) withObject:sender afterDelay:0.2];
  
    NSLog(@"venue=%@",[[NSUserDefaults standardUserDefaults] objectForKey:kvenueId]);
    [[NSUserDefaults standardUserDefaults] setObject:nameTextField.text forKey:kbowlerName];
    [laneTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
//    [self endEditing:YES];
    if (laneTextField.text.length>0 && nameTextField.text.length>0 && ![selectedCenter isEqualToString: @"Select Center"] && ![selectedCountry isEqualToString: @"Select Country"] && ![selectedState isEqualToString:@"Select State"]){
        if(lanes > 0){
            if ([laneTextField.text intValue]>lanes){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"This lane number is not available. Please enter a lane number within the given range." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            else{
                [[DataManager shared]showActivityIndicator:@"Loading..."];
                [[NSUserDefaults standardUserDefaults] setObject:laneTextField.text forKey:klaneNumber];
                //Check for user stats subscription and accordingly continue the flow
                [self performSelector:@selector(showEquipmentDetailsView) withObject:nil afterDelay:0.2];
            }
        }
        else{
             [[DataManager shared]showActivityIndicator:@"Loading..."];
            [[NSUserDefaults standardUserDefaults] setObject:laneTextField.text forKey:klaneNumber];
            [self performSelector:@selector(showEquipmentDetailsView) withObject:nil afterDelay:0.2];
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"To continue bowling you must fill in all the fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    NSLog(@"continue");
}

- (void)changeDoneButtonBackgroundColor:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
}

#pragma mark - User Stats Equipment Details
- (void)showEquipmentDetailsView
{
    NSDictionary *json=[[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/CommonStandards" contentType:@"" httpMethod:@"GET"];
    NSLog(@"response in MainVC=%@",json);
    if([[json objectForKey:kResponseStatusCode] integerValue] == 200)
    {
        responseDictionary=[json objectForKey:@"responseString"];
        NSLog(@"responseDict=%@",responseDictionary);
        int subscription=[[responseDictionary objectForKey:@"subcriptionStatus"] intValue];
      
        if(subscription == 1)
        {
              [self addDefaultValuesToDictionary];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserStatsPackagePurchased];
            // get user stats settings
            NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:@"" url:@"UserStat/UserStatSettingsList" contentType:@"" httpMethod:@"GET"];
            NSDictionary *response=[json objectForKey:kResponseString];
            NSLog(@"responseDict=%@",response);
            if([[json objectForKey:kResponseStatusCode] intValue] == 200)
            {
                if(response.count > 0)
                {
                    [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"ballType"] integerValue] forKey:kBallTypeBoolean];
                    [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"oilPattern"] integerValue] forKey:kOilPatternBoolean];
                    [[NSUserDefaults standardUserDefaults]setInteger:[[response objectForKey:@"brooklynPercentage"] integerValue] forKey:kPocketBrooklynBoolean];
                }
                [venueDelegate showUserStatsView:responseDictionary];
            }
            [[DataManager shared]removeActivityIndicator];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kUserStatsPackagePurchased];
            [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
             [venueDelegate bowlNow];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                dispatch_apply(1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t size) {
//                   [venueDelegate bowlNow];
//                });
//            });
        }
    }
    else
    {
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
         [venueDelegate bowlNow];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            dispatch_apply(1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t size) {
//               
//            });
//        });
    }
    
}

-(void)addDefaultValuesToDictionary
{
    @try {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"Select Pattern Name",@"patternName", nil];
        NSArray *arr=[[NSArray alloc]initWithArray:[[responseDictionary objectForKey:@"commonStatsStandards"] objectForKey:@"userStatPatternNameList"]];
        NSMutableArray *patternArray=[[NSMutableArray alloc]initWithArray:arr];
        [patternArray insertObject:temp atIndex:0];
        arr=[[NSArray alloc]initWithArray:patternArray];
        
        NSMutableDictionary *temp2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"Select Game Type",@"competition", nil];
        NSArray *arr2=[[NSArray alloc]initWithArray:[[responseDictionary objectForKey:@"commonStatsStandards"] objectForKey:@"userStatCompetitionTypeList"]];
        NSMutableArray *gameArray=[[NSMutableArray alloc]initWithArray:arr2];
        [gameArray insertObject:temp2 atIndex:0];
        arr2=[[NSArray alloc]initWithArray:gameArray];
        
        NSMutableDictionary *temp3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"Select Pattern Length",@"patternLength", nil];
        NSArray *arr3=[[NSArray alloc]initWithArray:[[responseDictionary objectForKey:@"commonStatsStandards"] objectForKey:@"userStatPatternLengthList"]];
        NSMutableArray *patternLengthArray=[[NSMutableArray alloc]initWithArray:arr3];
        [patternLengthArray insertObject:temp3 atIndex:0];
        arr3=[[NSArray alloc]initWithArray:patternLengthArray];
        
        NSMutableDictionary *temp4=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"Select Ball",@"userBowlingBallName", nil];
        NSArray *ballNames=[[NSArray alloc]initWithArray:[[responseDictionary objectForKey:@"commonStatsStandards"] objectForKey:@"bowlingBallNames"]];
        NSMutableArray *ballArray=[[NSMutableArray alloc]initWithArray:ballNames];
        [ballArray insertObject:temp4 atIndex:0];
        ballNames=[[NSArray alloc]initWithArray:ballArray];
        
        responseDictionary=nil;
        responseDictionary=[[NSMutableDictionary alloc] init];
        [responseDictionary setValue:ballNames forKey:@"bowlingBallNames"];
        [responseDictionary setValue:arr forKey:@"userStatPatternNameList"];
        [responseDictionary setValue:arr2 forKey:@"userStatCompetitionTypeList"];
        [responseDictionary setValue:arr3 forKey:@"userStatPatternLengthList"];
        
        temp=nil;
        temp2=nil;
        temp3=nil;
        arr=nil;
        arr2=nil;
        arr3=nil;
        patternArray=nil;
        gameArray=nil;
        ballNames=nil;
        ballArray=nil;
    }
    @catch (NSException *exception) {
        return;
    }
}

#pragma mark - Bowler Name Capitalization

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSRange lowercaseCharRange;
    lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    if (lowercaseCharRange.location != NSNotFound) {
        
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 145;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self convertRect:self.bounds fromView:self];
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
    CGRect viewFrame = self.frame;
    NSLog(@"animated=%f",animatedDistance);
    NSLog(@"y=%f",viewFrame.origin.y);
    viewFrame.origin.y -= animatedDistance;
    NSLog(@"y=%f",viewFrame.origin.y);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [laneTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    NSLog(@"touched");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 400) {
        [textField resignFirstResponder];
        [nameTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        UIButton *bowlNowBtn=[[UIButton alloc]init];
        [self doneButtonFunction:bowlNowBtn];
    }
    
    return YES;
}

@end
