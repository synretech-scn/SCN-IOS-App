//
//  SelectUserStatsPropertiesView.m
//  XBowling3.1
//
//  Created by Click Labs on 3/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "SelectUserStatsPropertiesView.h"

@implementation SelectUserStatsPropertiesView
{
    CustomActionSheet *actionSheet ;
    UIPickerView *pickerView ;
    NSArray *headerArray;
    NSMutableArray *selectedIndexArray;
    NSMutableArray *dropDownContentArray;
    NSArray *keysArray;
    int selectedRow;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createMainView
{
    selectedIndexArray=[[NSMutableArray alloc]init];
    keysArray=[[NSArray alloc]initWithObjects:@"userBowlingBallName",@"patternName",@"patternLength",@"competition", nil];
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=XBHeaderColor;
    [self addSubview:headerView];
    
      UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.text=@"Equipment Details";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    UIButton *skipButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:116/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:230/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    skipButton.backgroundColor=[UIColor clearColor];
    skipButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [skipButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [skipButton addTarget:self action:@selector(skipButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:skipButton];
    
    headerArray=[[NSArray alloc]initWithObjects:@"Select Ball Name",@"Select Pattern Name",@"Select Pattern Length",@"Select Competition Type", nil];
    int ycoordinate=headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i=0; i<headerArray.count; i++) {

            DropDownImageView *equipmentDetailsDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0,ycoordinate,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            NSString *placeholderText=[NSString stringWithFormat:@"%@",[headerArray objectAtIndex:i]];
            equipmentDetailsDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
            equipmentDetailsDropdown.tag=100+i;
            equipmentDetailsDropdown.userInteractionEnabled = YES;
            UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
            tapRecognizer.numberOfTapsRequired = 1;
            [equipmentDetailsDropdown addGestureRecognizer:tapRecognizer];
            [self addSubview:equipmentDetailsDropdown];
            
            ycoordinate=equipmentDetailsDropdown.frame.origin.y+equipmentDetailsDropdown.frame.size.height;
        
        if (i== 0) {
            if(![[NSUserDefaults standardUserDefaults]boolForKey:kBallTypeBoolean])
            {
                equipmentDetailsDropdown.userInteractionEnabled=NO;
                equipmentDetailsDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
            }
        }
        if (i== 1 || i==2) {
            if(![[NSUserDefaults standardUserDefaults]boolForKey:kOilPatternBoolean])
            {
                equipmentDetailsDropdown.userInteractionEnabled=NO;
                equipmentDetailsDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];

            }
        }
        
    }

    UILabel *noteLabel=[[UILabel alloc]init];
    noteLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width], ycoordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:self.frame.size.height]);
    noteLabel.backgroundColor=[UIColor clearColor];
    noteLabel.text=@"Note: Go to Equipment Settings page to add or edit equipment details.";
    noteLabel.textColor=[UIColor whiteColor];
    noteLabel.numberOfLines=2;
    noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
    noteLabel.alpha=0.39;
    noteLabel.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    [self addSubview:noteLabel];

    
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:221/3 currentSuperviewDeviceSize:screenBounds.size.width],noteLabel.frame.size.height+noteLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
    okButton.layer.cornerRadius=okButton.frame.size.height/2;
    okButton.clipsToBounds=YES;
    [okButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:okButton.frame] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:okButton.frame] forState:UIControlStateHighlighted];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:okButton];
    
    
}

- (void)backButtonFunction
{
    [delegate removeEquipmentDetails];
}

- (void)skipButtonFunction
{
    [delegate skipEquipmentDetails];
}

- (void)okButtonFunction
{
    [self storeSelectionToUserDefaults];
    [delegate setEquipmentDetails];
}
#pragma mark - Show Dropdown
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView  *tappedImageView = (DropDownImageView *)[tapGesture view];
    tappedImageView.dropDownImageView.image= [UIImage imageNamed:@"dropdown_icon_on.png"];
    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    NSString *titleString=[NSString stringWithFormat:@"%@",[headerArray objectAtIndex:(tappedImageView.tag-100)]];
    
    
    CGRect pickerFrame = CGRectMake(0, 30, 0, 0);
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
    actionSheet.customActionSheetDelegate = self;
    [actionSheet updateTitleLabel:titleString];
    NSLog(@"actionView=%@",actionSheet.actionSheet);
    NSLog(@"actionSheet");
    
    actionSheet.tag=tappedImageView.tag+1000;
    pickerView.tag=tappedImageView.tag+1000;
    [self.superview addSubview:actionSheet];
    [actionSheet showPicker];
    NSLog(@"%ld",(long)(tappedImageView.tag - 100));
    int index=(int)(tappedImageView.tag - 100);
    [pickerView selectRow:[[selectedIndexArray objectAtIndex:index]integerValue] inComponent:0 animated:NO];
    selectedRow=[[selectedIndexArray objectAtIndex:index]intValue];
    [actionSheet.actionSheet addSubview:pickerView];
    
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pV numberOfRowsInComponent:(NSInteger)component
{
    int num = 0;
    num=(int)[[dropDownContentArray objectAtIndex:(pickerView.tag - 1100)] count];
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pV
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *string =[[[dropDownContentArray objectAtIndex:(pickerView.tag - 1100)] objectAtIndex:row] objectForKey:[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:(pickerView.tag - 1100)]]];
    
    return string;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow=(int)row;
//    NSInteger index=(pickerView.tag - 1100);
//    DropDownImageView *equipmentDropdown=(DropDownImageView *)[self viewWithTag:index+100];
//    NSString *selectedValue=[[[dropDownContentArray objectAtIndex:(pickerView.tag - 1100)] objectAtIndex:row] objectForKey:[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:(pickerView.tag - 1100)]]];
//    equipmentDropdown.textLabel.text=[NSString stringWithFormat:@"%@",selectedValue];
//    [selectedequipmentsArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@",selectedValue]];
}

#pragma mark - Hide Dropdown
- (void)dismissActionSheet
{
    NSInteger index=(pickerView.tag - 1100);
    [selectedIndexArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%ld",(long)selectedRow]];
    NSLog(@"picker index=%ld",(long)[pickerView selectedRowInComponent:0]);
    DropDownImageView *selectedOption=(DropDownImageView *)[self viewWithTag:(pickerView.tag - 1000)];
    selectedOption.textLabel.text = [[[dropDownContentArray objectAtIndex:(pickerView.tag - 1100)] objectAtIndex:[[selectedIndexArray objectAtIndex:(pickerView.tag - 1100)] integerValue]] objectForKey:[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:(pickerView.tag - 1100)]]];
    [self storeSelectionToUserDefaults];
}

- (void)storeSelectionToUserDefaults
{
    @try {
        [[NSUserDefaults standardUserDefaults]setValue:[[dropDownContentArray objectAtIndex:0] objectAtIndex:[[selectedIndexArray objectAtIndex:0] integerValue]] forKeyPath:kBowlingBallName];
        [[NSUserDefaults standardUserDefaults]setValue:[[[dropDownContentArray objectAtIndex:1] objectAtIndex:[[selectedIndexArray objectAtIndex:1] integerValue]] objectForKey:@"id"] forKeyPath:kPatternNameId];
        [[NSUserDefaults standardUserDefaults]setValue:[[[dropDownContentArray objectAtIndex:2] objectAtIndex:[[selectedIndexArray objectAtIndex:2] integerValue]] objectForKey:@"id"] forKeyPath:kPatternLengthId];
        [[NSUserDefaults standardUserDefaults]setValue:[[[dropDownContentArray objectAtIndex:3] objectAtIndex:[[selectedIndexArray objectAtIndex:3] integerValue]] objectForKey:@"id"] forKeyPath:kCompetitionTypeId];
    }
    @catch (NSException *exception) {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kCompetitionTypeId];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternLengthId];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternNameId];
    }
    
    
}

- (void)changeDropdownIconImage:(UIImageView *)dropDownImageView
{
    dropDownImageView.image=[UIImage imageNamed:@"dropdown_icon.png"];
}

#pragma mark - Delegate Methods
- (void)equipmentDropdownInfo:(NSDictionary *)dropdownDictionary
{
    NSArray *equipmentkeysArray=[[NSArray alloc]initWithArray:[dropdownDictionary allKeys]];
    NSMutableArray *sortedKeysArray=[NSMutableArray new];
    [sortedKeysArray insertObject:@"bowlingBallNames" atIndex:0];
    [sortedKeysArray insertObject:@"userStatPatternNameList" atIndex:1];
    [sortedKeysArray insertObject:@"userStatPatternLengthList" atIndex:2];
    [sortedKeysArray insertObject:@"userStatCompetitionTypeList" atIndex:3];
    dropDownContentArray=[[NSMutableArray alloc]init];
    for (int i=0; i < dropdownDictionary.count; i++) {
        [selectedIndexArray addObject:@"0"];
//        [selectedequipmentsArray addObject:@""];
        if (![[NSString stringWithFormat:@"%@",[equipmentkeysArray objectAtIndex:i]] isEqualToString:@"(null)"]) {
            [dropDownContentArray addObject:[dropdownDictionary objectForKey:[NSString stringWithFormat:@"%@",[sortedKeysArray objectAtIndex:i]]]];
        }
    }

}
@end
