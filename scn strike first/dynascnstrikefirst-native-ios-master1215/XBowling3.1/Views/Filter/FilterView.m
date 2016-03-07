//
//  FilterView.m
//  XBowling3.1
//
//  Created by Shreya on 23/01/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView
{
    int numberOfFilters;
    CustomActionSheet *actionSheet ;
    UIPickerView *pickerView ;
    NSMutableArray *filterHeaders;
    NSMutableArray *selectedIndexArray;
    NSMutableArray *selectedFiltersArray;
    NSMutableArray *dropDownContentArray;
    UIScrollView *baseForFilterView;
    NSString *parentView;
    NSMutableArray *filterDefaultValuesArray;
    SelectCenterView *centerView;
}
@synthesize delegate;

- (void)createView:(NSArray *)filterHeadersArray filterInitialValues:(NSArray *)valuesArray centerView:(SelectCenterView *)locationView forSuperView:(NSString *)homeView
{
    parentView=[NSString stringWithFormat:@"%@",homeView];
    selectedIndexArray=[[NSMutableArray alloc]init];
    selectedFiltersArray=[[NSMutableArray alloc]init];
    filterHeaders=[[NSMutableArray alloc]initWithArray:filterHeadersArray];
    filterDefaultValuesArray=[[NSMutableArray alloc]initWithArray:valuesArray];
    numberOfFilters=(int)filterHeadersArray.count;
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [self addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Filter";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *doneButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:220/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    doneButton.backgroundColor=[UIColor clearColor];
    doneButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
     [doneButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [doneButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [headerView addSubview:doneButton];
    if (![parentView isEqualToString:@"Leaderboard"]) {
        [doneButton setTitle:@"Reset" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(resetButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveBtn.frame=CGRectMake(0,self.frame.size.height -  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [saveBtn setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [saveBtn setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, saveBtn.frame.size.width, saveBtn.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"     Done";
        titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height] ];
        [saveBtn addSubview:titleLabel];
        [saveBtn addTarget:self action:@selector(doneButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveBtn];
    }
    else{
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    int ycoordinate=headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
    
    baseForFilterView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, ycoordinate, self.frame.size.width, self.frame.size.height - ycoordinate)];
    if (![parentView isEqualToString:@"Leaderboard"]) {
        baseForFilterView.frame=CGRectMake(0, ycoordinate, self.frame.size.width, self.frame.size.height - (ycoordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]));
    }
    baseForFilterView.backgroundColor=[UIColor clearColor];
    baseForFilterView.userInteractionEnabled=YES;
    [self addSubview:baseForFilterView];
    
    ycoordinate = 0;
    for (int i=0; i<filterHeadersArray.count; i++) {
        if (i==1) {
            //Location dropdown
            centerView=locationView;
            locationView.frame=CGRectMake(0, ycoordinate, screenBounds.size.width, 100);
            locationView.tag=1000+i;
            [locationView selectCenterViewforFilterView:parentView];
            [baseForFilterView addSubview:locationView];
            if (locationView) {
                ycoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(180+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]+locationView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
            }
            else
            {
                [filterHeaders replaceObjectAtIndex:i withObject:[filterHeaders objectAtIndex:i+1]];
            }
             if ([parentView isEqualToString:@"MyGames"]) {
                 locationView.userInteractionEnabled=NO;
             }
        }
        else
        {
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,ycoordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            titleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
            titleLabel.text=[NSString stringWithFormat:@"   %@",[filterHeadersArray objectAtIndex:i]];
            if (i>1) {
                titleLabel.tag=200+(i-1);
            }
            else
                titleLabel.tag=200+i;
            titleLabel.textColor=[UIColor whiteColor];
            titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            [baseForFilterView addSubview:titleLabel];
            
            DropDownImageView *filterDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
//            if ([filterDropdown.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//                UIColor *color = [UIColor grayColor];
//                filterDropdown.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"All Countries" attributes:@{NSForegroundColorAttributeName: color}];
//            }
            filterDropdown.textLabel.text=[NSString stringWithFormat:@"%@",[valuesArray objectAtIndex:i]];
            if (i>1) {
                filterDropdown.tag=100+(i-1);
            }
            else
                filterDropdown.tag=100+i;
            if ([parentView isEqualToString:@"MyGames"]) {
                if (i ==0 || i == (filterHeadersArray.count - 1)) {
                    filterDropdown.userInteractionEnabled = YES;
                }
                else
                    filterDropdown.userInteractionEnabled = NO;
            }
            else
                filterDropdown.userInteractionEnabled = YES;
            UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
            tapRecognizer.numberOfTapsRequired = 1;
            [filterDropdown addGestureRecognizer:tapRecognizer];
            [baseForFilterView addSubview:filterDropdown];
            
            ycoordinate=titleLabel.frame.size.height+titleLabel.frame.origin.y+filterDropdown.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
        }
    }
    baseForFilterView.contentSize=CGSizeMake(baseForFilterView.frame.size.width, ycoordinate);
    
   
}

- (void)resetButtonFunction
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [selectedIndexArray removeAllObjects];
    NSLog(@"picker index=%ld",(long)[pickerView selectedRowInComponent:0]);
    for (int i=0; i<filterHeaders.count; i++) {
        int tag;
        if (i>1) {
            tag=100+(i-1);
        }
        else
           tag=100+i;
        DropDownImageView *filterDropdown=(DropDownImageView *)[baseForFilterView viewWithTag:tag];
        filterDropdown.textLabel.text=[NSString stringWithFormat:@"%@",[filterDefaultValuesArray objectAtIndex:i]];
    }
    [centerView resetCenterView];
    [delegate resetFilters];
    [[DataManager shared]removeActivityIndicator];
    for (int i=0; i < dropDownContentArray.count; i++) {
        [selectedIndexArray addObject:@"0"];
        [selectedFiltersArray addObject:@""];
    }
    if ([parentView isEqualToString:@"MyGames"]) {
        for (int i=0; i < filterHeaders.count; i++) {
            [selectedIndexArray addObject:@"0"];
            [selectedFiltersArray addObject:@""];
        }
    }
}
- (void)updateFilterView:(int)changeInHeight
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        SelectCenterView *centerSelectionView=(SelectCenterView*)[self viewWithTag:1001];
        centerSelectionView.frame=CGRectMake(centerSelectionView.frame.origin.x,centerSelectionView.frame.origin.y,centerSelectionView.frame.size.width,centerSelectionView.frame.size.height+changeInHeight);
        baseForFilterView.contentSize=CGSizeMake(baseForFilterView.frame.size.width, baseForFilterView.contentSize.height+changeInHeight);
    } completion:^(BOOL finished){
        for (int i = 1; i < numberOfFilters - 1; i++) {
            UILabel *title=(UILabel *)[self viewWithTag:200+i];
            DropDownImageView *dropdown=(DropDownImageView*)[self viewWithTag:100+i];
             title.frame=CGRectMake(title.frame.origin.x,title.frame.origin.y+changeInHeight,title.frame.size.width,title.frame.size.height);
            dropdown.frame=CGRectMake(dropdown.frame.origin.x,dropdown.frame.origin.y+changeInHeight,dropdown.frame.size.width,dropdown.frame.size.height);
        }
    }];
}

#pragma mark -
-(void)updateFiltersInteractionForSection:(NSString *)section
{
    for (int i=0; i<filterHeaders.count; i++) {
        DropDownImageView *dropdown=(DropDownImageView*)[self viewWithTag:100+i];
        if ([section isEqualToString:@"MyGames"]) {
            if (dropdown.tag == 101 || dropdown.tag == 102 || dropdown.tag == 103) {
                dropdown.userInteractionEnabled=NO;
            }
        }
        else{
            dropdown.userInteractionEnabled=YES;
        }
    }
   
}

#pragma mark - Show Dropdown
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView  *tappedImageView = (DropDownImageView *)[tapGesture view];
    
    tappedImageView.dropDownImageView.image= [UIImage imageNamed:@"dropdown_icon_on.png"];
    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    if ([[dropDownContentArray objectAtIndex:(tappedImageView.tag - 100)] count]> 0) {
        NSInteger titleIndex=(tappedImageView.tag-100);
        if (titleIndex > 0) {
            titleIndex++;
        }
        NSString *titleString=[NSString stringWithFormat:@"%@",[filterHeaders objectAtIndex:titleIndex]];
        
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
        @try {
            if (selectedIndexArray.count > 0) {
                [pickerView selectRow:[[selectedIndexArray objectAtIndex:index]integerValue] inComponent:0 animated:NO];
            }
        }
        @catch (NSException *exception) {
            
        }
        [actionSheet.actionSheet addSubview:pickerView];
    }

}

- (void)changeDropdownIconImage:(UIImageView *)dropDownImageView
{
    dropDownImageView.image=[UIImage imageNamed:@"dropdown_icon.png"];
}

#pragma mark - Hide Dropdown
- (void)dismissActionSheet
{
    NSInteger index=(pickerView.tag - 1100);
    int row=[[selectedIndexArray objectAtIndex:index] intValue];
    NSLog(@"picker index=%ld",(long)[pickerView selectedRowInComponent:0]);
    DropDownImageView *filterDropdown=(DropDownImageView *)[self viewWithTag:index+100];
    filterDropdown.textLabel.text=[NSString stringWithFormat:@"%@",[[dropDownContentArray objectAtIndex:index] objectAtIndex:row]];
    [selectedFiltersArray replaceObjectAtIndex:index withObject:[[dropDownContentArray objectAtIndex:index] objectAtIndex:row]];
//    if (index == 3 ) {
//        //fix for game type index
//        [selectedIndexArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",(int)row-1]];
//    }
    
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
    NSString *string = [[dropDownContentArray objectAtIndex:(pickerView.tag - 1100)] objectAtIndex:row];
    
    return string;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger index=(pickerView.tag - 1100);
    [selectedIndexArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",(int)row]];
}

#pragma mark - Delegate Methods
- (void)filterDropdownInfo:(NSMutableArray *)dropdownArray
{
    for (int i=0; i < dropdownArray.count; i++) {
        [selectedIndexArray addObject:@"0"];
        [selectedFiltersArray addObject:@""];
    }
    if ([parentView isEqualToString:@"MyGames"]) {
        for (int i=0; i < filterHeaders.count; i++) {
            [selectedIndexArray addObject:@"0"];
            [selectedFiltersArray addObject:@""];
        }
    }
    dropDownContentArray=[[NSMutableArray alloc]initWithArray:dropdownArray];
}

- (void)backButtonFunction
{
    [delegate removeFilterView];
}

- (void)doneButtonFunction
{
    if (![parentView isEqualToString:@"Leaderboard"]) {
        [delegate filterDoneFunction:selectedIndexArray];
    }
    else{
        [delegate filterDoneFunction:selectedFiltersArray];
    }
}

@end
