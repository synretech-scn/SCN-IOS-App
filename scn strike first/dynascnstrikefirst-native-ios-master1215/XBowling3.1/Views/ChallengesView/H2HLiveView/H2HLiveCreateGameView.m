//
//  H2HLiveCreateGameView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/23/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "H2HLiveCreateGameView.h"
#import "DataManager.h"
#import "Keys.h"

#define numberOfOpponentDropdownTag 160
#define inputTypeDropdownTag 161
#define creditsAmountDropdownTag 162
#define scoringModeDropdownTag 163

@implementation H2HLiveCreateGameView
{
    CustomActionSheet *actionSheet ;
    UIPickerView *pickerView ;
    NSArray *pickerArray;
    NSInteger selectedIndex;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImage.userInteractionEnabled=YES;
        [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
        [self addSubview:backgroundImage];
        
        UIView *headerView=[[UIView alloc]init];
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.userInteractionEnabled=YES;
        headerView.backgroundColor=XBHeaderColor;
        [self addSubview:headerView];
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:194 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.text=@"H2H Live";
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        //Game Name Dropdown
        UIImageView *gameNameBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        gameNameBackground.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
        gameNameBackground.userInteractionEnabled=YES;
        [self addSubview:gameNameBackground];
        UIView *separatorImage2=[[UIView alloc]init];
        separatorImage2.frame=CGRectMake(0, 0, self.frame.size.width, 0.5);
        separatorImage2.backgroundColor=separatorColor;
        [gameNameBackground addSubview:separatorImage2];
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:350/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height])];
//        nameLabel.backgroundColor = [UIColor clearColor];
//        nameLabel.textAlignment = NSTextAlignmentLeft;
//        nameLabel.textColor=[UIColor whiteColor];
//        nameLabel.text = @"Game Name";
//        nameLabel.numberOfLines = 2;
//        //        nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
//        [nameLabel setFont:[UIFont fontWithName:AvenirDemi size:XbH2size]];
//        [gameNameBackground addSubview:nameLabel];
        
        UITextField *nameTextField =  [[UITextField alloc] initWithFrame: CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],0,gameNameBackground.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],gameNameBackground.frame.size.height)];
        nameTextField.textColor = [UIColor whiteColor];
        nameTextField.backgroundColor=[UIColor clearColor];
        nameTextField.delegate=self;
        [nameTextField setTag:159];
        nameTextField.keyboardType = UIKeyboardTypeDefault;
        nameTextField.returnKeyType = UIReturnKeyDone;
        [nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        if ([nameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Game Name" attributes:@{NSForegroundColorAttributeName: color}];
        }
        nameTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        nameTextField.userInteractionEnabled=YES;
        [gameNameBackground addSubview:nameTextField];
        UIView *separatorImage3=[[UIView alloc]init];
        separatorImage3.frame=CGRectMake(0, gameNameBackground.frame.size.height - 0.5, self.frame.size.width, 0.5);
        separatorImage3.backgroundColor=separatorColor;
        [gameNameBackground addSubview:separatorImage3];
        //Opponent Count Dropdown
        DropDownImageView *opponentCountDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, gameNameBackground.frame.size.height + gameNameBackground.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        if ([opponentCountDropdown.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            opponentCountDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Number of Opponents" attributes:@{NSForegroundColorAttributeName: color}];
        }
        opponentCountDropdown.tag=numberOfOpponentDropdownTag;
        opponentCountDropdown.userInteractionEnabled = YES;
        UITapGestureRecognizer  *opponenttapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        opponenttapRecognizer.numberOfTapsRequired = 1;
        [opponentCountDropdown addGestureRecognizer:opponenttapRecognizer];
        [self addSubview:opponentCountDropdown];
        
        //Input Type Dropdown
        DropDownImageView *inputTypeDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, opponentCountDropdown.frame.size.height + opponentCountDropdown.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        if ([inputTypeDropdown.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            inputTypeDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Input Type" attributes:@{NSForegroundColorAttributeName: color}];
        }
        inputTypeDropdown.tag=inputTypeDropdownTag;
        inputTypeDropdown.userInteractionEnabled = YES;
        UITapGestureRecognizer  *inputTypeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        inputTypeTapRecognizer.numberOfTapsRequired = 1;
        [inputTypeDropdown addGestureRecognizer:inputTypeTapRecognizer];
        [self addSubview:inputTypeDropdown];
        
        //Credit Amount Dropdown
       DropDownImageView *creditAmountDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, inputTypeDropdown.frame.size.height + inputTypeDropdown.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        if ([creditAmountDropdown.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            creditAmountDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Credit Amount" attributes:@{NSForegroundColorAttributeName: color}];
        }
        creditAmountDropdown.tag=creditsAmountDropdownTag;
        creditAmountDropdown.userInteractionEnabled = YES;
        UITapGestureRecognizer  *creditTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        creditTapRecognizer.numberOfTapsRequired = 1;
        [creditAmountDropdown addGestureRecognizer:creditTapRecognizer];
        [self addSubview:creditAmountDropdown];
        
        // Scoring Mode Dropdown
        DropDownImageView *scoringModeDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, creditAmountDropdown.frame.size.height + creditAmountDropdown.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        if ([scoringModeDropdown.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            scoringModeDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Scoring Mode" attributes:@{NSForegroundColorAttributeName: color}];
        }
        scoringModeDropdown.tag=scoringModeDropdownTag;
        scoringModeDropdown.userInteractionEnabled = YES;
        UITapGestureRecognizer  *scoringModetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        scoringModetapRecognizer.numberOfTapsRequired = 1;
        [scoringModeDropdown addGestureRecognizer:scoringModetapRecognizer];
        [self addSubview:scoringModeDropdown];

        // Create Game Button
        UIButton *createGameButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], scoringModeDropdown.frame.size.height+scoringModeDropdown.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        createGameButton.layer.cornerRadius=createGameButton.frame.size.height/2;
        createGameButton.clipsToBounds=YES;
        [createGameButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:createGameButton.frame] forState:UIControlStateNormal];
        [createGameButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:createGameButton.frame] forState:UIControlStateHighlighted];
        [createGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createGameButton setTitle:@"Challenge" forState:UIControlStateNormal];
        [createGameButton addTarget:self action:@selector(createGameFunction) forControlEvents:UIControlEventTouchUpInside];
        createGameButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [self addSubview:createGameButton];
        
    }
    return self;
}

#pragma mark - Back Button Function
- (void)backButtonFunction
{
    [delegate removeh2hCreateGameView];
}

#pragma mark - Back Button Function
- (void)createGameFunction
{
    DropDownImageView *creditAmountImgView = (DropDownImageView *)[self viewWithTag:creditsAmountDropdownTag];
    DropDownImageView *numberOfOpponentsImgView = (DropDownImageView *)[self viewWithTag:numberOfOpponentDropdownTag];
    DropDownImageView *scoringModeImgView = (DropDownImageView *)[self viewWithTag:scoringModeDropdownTag];
    DropDownImageView *playModeImgView = (DropDownImageView *)[self viewWithTag:inputTypeDropdownTag];
    UITextField *gameNameTextField = (UITextField *)[self viewWithTag:159];
    NSLog(@"game Name %@", gameNameTextField.text);
    if ([gameNameTextField.text length] == 0 || [playModeImgView.textLabel.text length] == 0||[creditAmountImgView.textLabel.text length] == 0|| [numberOfOpponentsImgView.textLabel.text length] == 0 || [scoringModeImgView.textLabel.text length] == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter all the fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *restrictionString;
        NSString *scoringModeString;
        if ([scoringModeImgView.textLabel.text isEqualToString:@"Regular Game - Scores with Handicap"]) {
            restrictionString = @"Handicap";
        }
        else{
            restrictionString = kscratchType;
        }
        
        if ([playModeImgView.textLabel.text isEqualToString:@"Automated Only"]) {
            scoringModeString = @"MachineScoring";
        }
        else if ([playModeImgView.textLabel.text isEqualToString:@"Self Input Only"]){
            scoringModeString = @"ManualScoring";
        }
        else{
            scoringModeString = @"All";
        }
        NSDictionary *competitionDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"live", @"competitionType", [[creditAmountImgView.textLabel.text componentsSeparatedByString:@" "] objectAtIndex:0], @"entryFeeCredits",scoringModeString,@"entryRestrictions", @"1", @"maxGroups", gameNameTextField.text, @"name", numberOfOpponentsImgView.textLabel.text, @"maxChallengersPerGroup", restrictionString, @"scoringMode",  nil];
        NSDictionary *idDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:kbowlingGameId], @"id", nil];
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:idDictionary, @"bowlingGame", competitionDict, @"competition", nil];
        [delegate createGame:postDict];
    }
}
#pragma mark - Show Dropdown
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
    selectedIndex=0;
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView  *tappedImageView = (DropDownImageView *)[tapGesture view];
    tappedImageView.dropDownImageView.image= [UIImage imageNamed:@"dropdown_icon_on.png"];
    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    NSString *titleString;
    if (tappedImageView.tag == creditsAmountDropdownTag) {//CREDIT AMOUNT
        pickerArray = [NSArray arrayWithObjects:@"10 credits", @"25 credits", @"50 credits",@"100 credits", @"500 credits", @"1000 credits", nil];
        titleString = @"Credit Amount";
    }
    else if (tappedImageView.tag == numberOfOpponentDropdownTag){//NUMBER OF OPPONENTS
        pickerArray = [NSArray arrayWithObjects:@"1",@"2" ,@"3", @"4", @"5", @"6", @"7", @"8", nil];
        titleString = @"Number of Opponents";
    }
    else if (tappedImageView.tag == scoringModeDropdownTag){//SCORING MODE
        pickerArray = [NSArray arrayWithObjects:@"Regular Game - Scores with Handicap", @"I am that good- Scratch", nil];
        titleString = @"Scoring Mode";
    }
    else if (tappedImageView.tag == inputTypeDropdownTag){//PLAY MODE
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kscoringType] isEqualToString:@"Machine"]) {
            pickerArray = [NSArray arrayWithObjects:@"Automated Only", @"Automated or Self Input", nil];
            titleString = @"Play Mode";
        }
        else{
//            pickerArray = [NSArray arrayWithObjects:@"Self Input Only", @"Automated or Self Input", nil];
             pickerArray = [NSArray arrayWithObjects:@"Automated Only", @"Automated or Self Input", nil];
            titleString = @"Play Mode";
        }
    }
    if (tappedImageView.textLabel.text.length>0) {
        for (int i=0; i<pickerArray.count; i++) {
            if ([[pickerArray objectAtIndex:i]isEqual:tappedImageView.textLabel.text]) {
                selectedIndex=i;
                break;
            }
        }
    }
    CGRect pickerFrame = CGRectMake(0, 30, 0, 0);
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
    actionSheet.customActionSheetDelegate = self;
    [self addSubview:actionSheet];
    actionSheet.tag = tappedImageView.tag+10; //ACTIONSHEET TAG
    [actionSheet updateTitleLabel:titleString];
    NSLog(@"actionView=%@",actionSheet.actionSheet);
    NSLog(@"actionSheet");
    [actionSheet showPicker];
    [actionSheet.actionSheet addSubview:pickerView];

}

- (void)changeDropdownIconImage:(UIImageView *)dropDownImageView
{
    dropDownImageView.image=[UIImage imageNamed:@"dropdown_icon.png"];
}

#pragma mark - Hide Dropdown
- (void)dismissActionSheet
{
    DropDownImageView *selectedDropDown = (DropDownImageView *)[self viewWithTag:actionSheet.tag-10];
    selectedDropDown.textLabel.text = [pickerArray objectAtIndex:selectedIndex];
    pickerArray = nil;
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pV numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pV
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    selectedIndex=row;
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
