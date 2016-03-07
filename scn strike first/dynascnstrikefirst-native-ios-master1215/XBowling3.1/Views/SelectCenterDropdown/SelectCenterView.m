//
//  SelectCenterView.m
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "SelectCenterView.h"
#import "DropDownImageView.h"
#import "DataManager.h"
#import "Keys.h"

@implementation SelectCenterView
{
    DropDownImageView *selectCountryImageView;
    DropDownImageView *selectStateImageView;
    DropDownImageView *selectCenterImageView;
    int selectedCountryIndex;
    int selectedStateIndex;
    int selectedCenterIndex;
    CustomActionSheet *actionSheet ;
    UIPickerView *pickerView ;
    int totalLanes;
    BOOL filterView;
    NSString *filterSuperview;
}
@synthesize centerSelectionDelegate,countryInfoDict,centerDetails;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createView
{
    filterView=NO;
    self.backgroundColor=[UIColor clearColor];
    self.frame=CGRectMake(0, self.frame.origin.y, screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:640/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    //Country Dropdown box
    selectCountryImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if ([selectCountryImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectCountryImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Country" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectCountryImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *CountrytapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    CountrytapRecognizer.numberOfTapsRequired = 1;
    [selectCountryImageView addGestureRecognizer:CountrytapRecognizer];
    [self addSubview:selectCountryImageView];
    
    //State Dropdown box
    selectStateImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, selectCountryImageView.frame.size.height + selectCountryImageView.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if ([selectStateImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectStateImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select State" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectStateImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *StatetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    StatetapRecognizer.numberOfTapsRequired = 1;
    [selectStateImageView addGestureRecognizer:StatetapRecognizer];
    [self addSubview:selectStateImageView];
    
    //Center Dropdown box
    selectCenterImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, selectStateImageView.frame.size.height + selectStateImageView.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    //        selectCenterImageView.textLabel.placeholder = @"Enter lane number";
    if ([selectCenterImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectCenterImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Center" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    selectCenterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *CentertapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    CentertapRecognizer.numberOfTapsRequired = 1;
    [selectCenterImageView addGestureRecognizer:CentertapRecognizer];
    [self addSubview:selectCenterImageView];
    
    self.frame=CGRectMake(0, self.frame.origin.y, screenBounds.size.width, selectCenterImageView.frame.size.height+selectCenterImageView.frame.origin.y);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self performSelector:@selector(venues) withObject:self afterDelay:0.2];

}

- (void)selectCenterViewforFilterView:(NSString *)filterParentView
{
    filterView=YES;
    filterSuperview=filterParentView;
    self.backgroundColor=[UIColor clearColor];
    self.frame=CGRectMake(0, self.frame.origin.y, screenBounds.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(540+318)/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    //Country Dropdown box
    UILabel *countryTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    countryTitleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    countryTitleLabel.text=[NSString stringWithFormat:@"   Country"];
    countryTitleLabel.textColor=[UIColor whiteColor];
    countryTitleLabel.tag=200;
    countryTitleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:countryTitleLabel];
    
    selectCountryImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, countryTitleLabel.frame.size.height + countryTitleLabel.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if ([selectCountryImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectCountryImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Country" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectCountryImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *CountrytapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    CountrytapRecognizer.numberOfTapsRequired = 1;
    [selectCountryImageView addGestureRecognizer:CountrytapRecognizer];
    [self addSubview:selectCountryImageView];
    
    //State Dropdown box
    UILabel *stateTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,selectCountryImageView.frame.size.height + selectCountryImageView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    stateTitleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    stateTitleLabel.text=[NSString stringWithFormat:@"   State"];
    stateTitleLabel.textColor=[UIColor whiteColor];
    stateTitleLabel.hidden=YES;
    stateTitleLabel.tag=210;
    stateTitleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:stateTitleLabel];

    selectStateImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, stateTitleLabel.frame.size.height + stateTitleLabel.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if ([selectStateImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectStateImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select State" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectStateImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *StatetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    StatetapRecognizer.numberOfTapsRequired = 1;
    [selectStateImageView addGestureRecognizer:StatetapRecognizer];
    selectStateImageView.hidden=YES;
    [self addSubview:selectStateImageView];
    
    //Center Dropdown box
    UILabel *centerTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,selectStateImageView.frame.size.height + selectStateImageView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    centerTitleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
    centerTitleLabel.text=[NSString stringWithFormat:@"   Center"];
    centerTitleLabel.textColor=[UIColor whiteColor];
    centerTitleLabel.tag=211;
    centerTitleLabel.hidden=YES;
    centerTitleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:centerTitleLabel];
    
    selectCenterImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, centerTitleLabel.frame.size.height + centerTitleLabel.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    //        selectCenterImageView.textLabel.placeholder = @"Enter lane number";
    if ([selectCenterImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectCenterImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Center" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectCenterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *CentertapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    CentertapRecognizer.numberOfTapsRequired = 1;
    [selectCenterImageView addGestureRecognizer:CentertapRecognizer];
    selectCenterImageView.hidden=YES;
    [self addSubview:selectCenterImageView];
    
//    selectCenterImageView.hidden=NO;
//    selectStateImageView.hidden=NO;
//    centerTitleLabel.hidden=NO;
//    stateTitleLabel.hidden=NO;
    
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self performSelector:@selector(venues) withObject:self afterDelay:0.2];

}

-(void)venues
{
    @try {
        if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(venueInfo)]) {
            [centerSelectionDelegate venueInfo];
        }
        if ([countryInfoDict count]>0 && filterView == NO)
        {
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"inUserProfileSection"]) {
                [centerSelectionDelegate getNearbyCenter];  //for user profile
                [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
            }
            else
            {
//                [centerSelectionDelegate getNearbyCenter];  //for live score
                [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                [centerSelectionDelegate getNearbyCenter];  //for live score
            }
        }
        else
        {
            if (selectedCountryIndex > 0 && filterView == YES) {
                [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
            }
        }
        if ([countryInfoDict count]>0) {
            selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
        }
        else{
            selectCountryImageView.textLabel.text = @"Select Country";
        }
        if ([countryInfoDict count] >0 && [[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count]>0) {
            selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
        }
        else{
            selectStateImageView.textLabel.text = @"Select State";
        }
        if ([centerDetails count] >0) {
            selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
            totalLanes = [[[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"totalLanes"] intValue];
        }
        else{
            selectCenterImageView.textLabel.text = @"Select Center";
            totalLanes=0;
        }
        [centerSelectionDelegate updateCenterInformation:totalLanes selectedCountry:selectCountryImageView.textLabel.text selectedState:selectStateImageView.textLabel.text selectedCenter:selectCenterImageView.textLabel.text];
        NSDictionary *centerDict=[NSDictionary new];
        if(centerDetails.count > 0)
        {
            centerDict=[NSDictionary dictionaryWithDictionary:[centerDetails objectAtIndex:selectedCenterIndex]];
        }
        if([centerSelectionDelegate respondsToSelector:@selector(selectedCenterDictionary:)])
            [centerSelectionDelegate selectedCenterDictionary:centerDict];

    }
    @catch (NSException *exception) {
        selectedCenterIndex=0;
//        [[[UIAlertView alloc]initWithTitle:@"Center Error" message:[NSString stringWithFormat:@"Countries Array=%@ \n selectedCountry=%d SelectedState=%d \n Centers Array=%@ \nSelectedCEnter=%d",countryInfoDict,selectedCountryIndex,selectedStateIndex,centerDetails,selectedCenterIndex] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [[DataManager shared]removeActivityIndicator];
}

#pragma mark - Reset Center View
- (void)resetCenterView
{
    selectedCountryIndex=0;
    selectedStateIndex=0;
    selectedCenterIndex=0;
    selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
    selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
    if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
        if (![selectStateImageView isHidden]) {
            selectStateImageView.hidden=YES;
            UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
            titleLabel.hidden=YES;
            if (![selectCenterImageView isHidden]) {
                selectCenterImageView.hidden=YES;
                UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                titleLabel.hidden=YES;
                [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            }
            else
            {
                [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            }
        }
    }

}

#pragma mark - Show Nearby Center
- (void)nearbyCenter:(NSMutableArray *)indexArray
{
    if(indexArray.count > 0)
    {
        selectedCountryIndex=[[indexArray objectAtIndex:0] intValue];
        selectedStateIndex=[[indexArray objectAtIndex:1] intValue];
        selectedCenterIndex=[[indexArray objectAtIndex:2] intValue];
    }
    else
    {
        selectedCountryIndex=0;
        selectedStateIndex=0;
        selectedCenterIndex=0;
    }
    
}

#pragma mark - Show Dropdown
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView  *tappedImageView = (DropDownImageView *)[tapGesture view];
    tappedImageView.dropDownImageView.image= [UIImage imageNamed:@"dropdown_icon_on.png"];
    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    NSString *titleString;
    if (tappedImageView == selectCountryImageView) {
        titleString = @"Select Country";
    }
    else if (tappedImageView == selectStateImageView){
        titleString = @"Select State";
    }
    else if (tappedImageView == selectCenterImageView){
        if(centerDetails.count == 0)
        {
            return;
        }
        else
            titleString = @"Select Center";
    }
    
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
    
    if([countryInfoDict count] > 0)
    {
//          [self.superview addSubview:actionSheet];
        NSLog(@"superview=%@",self.superview.superview);
        if (![filterSuperview isEqualToString:@"Leaderboard"]) {
            actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.superview.superview.frame.size.width, self.superview.superview.frame.size.height)];
            actionSheet.customActionSheetDelegate = self;
            [actionSheet updateTitleLabel:titleString];
            NSLog(@"actionView=%@",actionSheet.actionSheet);
            [self.superview.superview addSubview:actionSheet];
            
        }
        else{
            [self.superview addSubview:actionSheet];
        }
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
        else if (tappedImageView == selectCenterImageView){
            NSLog(@"center");
            actionSheet.tag = 300;
            pickerView.tag = 300;
            [pickerView selectRow:selectedCenterIndex inComponent:0 animated:NO];
        }
        [actionSheet.actionSheet addSubview:pickerView];
    }
    else{
        pickerView=nil;
        actionSheet=nil;
    }
}

- (void)changeDropdownIconImage:(UIImageView *)dropDownImageView
{
    dropDownImageView.image=[UIImage imageNamed:@"dropdown_icon.png"];
}

- (void)showPicker:(UIButton *)sender
{
    CGRect pickerFrame = CGRectMake(0, 30, 0, 0);
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    actionSheet = [[CustomActionSheet alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
    actionSheet.customActionSheetDelegate = self;
    if (![filterSuperview isEqualToString:@"Leaderboard"]) {
        [self.superview.superview addSubview:actionSheet];
        
    }
    else{
        [self.superview addSubview:actionSheet];
    }

    NSLog(@"actionView=%@",actionSheet.actionSheet);
    NSLog(@"actionSheet");
    [actionSheet showPicker];
    
    //set Action Sheet tag and Picker View
    actionSheet.tag = sender.tag;
    pickerView.tag = sender.tag;
    //    [pickerView selectRow:selectedStateIndex inComponent:0 animated:NO];
    [actionSheet.actionSheet addSubview:pickerView];
}

#pragma mark - Hide Dropdown
- (void)dismissActionSheet
{
    NSLog(@"picker index=%ld",(long)[pickerView selectedRowInComponent:0]);
    @try {
        if(countryInfoDict.count>0)
        {
            if (actionSheet.tag == 100) {
                //select country
                selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
                
                //for filter
                if (filterView == YES) {
                    if ([filterSuperview isEqualToString:@"Leaderboard"]) {
                        if (selectedCountryIndex > 0) {
                            if ([selectStateImageView isHidden]) {
                                selectStateImageView.hidden=NO;
                                UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
                                titleLabel.hidden=NO;
                                if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                    [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                }
                            }
                        }
                        else
                        {
                            if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                if (![selectStateImageView isHidden]) {
                                    selectStateImageView.hidden=YES;
                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
                                    titleLabel.hidden=YES;
                                    if (![selectCenterImageView isHidden]) {
                                        selectCenterImageView.hidden=YES;
                                        UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                                        titleLabel.hidden=YES;
                                        [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                    }
                                    else
                                    {
                                        [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                    }
                                }
                            }
                        }
                    }
                    else{
                        // XBPro
                        if (selectedCountryIndex > 0) {
                            [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                            if ([selectStateImageView isHidden]) {
                                selectStateImageView.hidden=NO;
                                UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
                                titleLabel.hidden=NO;
                                if ([selectCenterImageView isHidden]) {
                                    selectCenterImageView.hidden=NO;
                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                                    titleLabel.hidden=NO;
                                }
                                [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                                if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                    [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                }
                            }
                        }
                        else
                        {
                            if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                if (![selectStateImageView isHidden]) {
                                    selectStateImageView.hidden=YES;
                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
                                    titleLabel.hidden=YES;
                                    if (![selectCenterImageView isHidden]) {
                                        selectCenterImageView.hidden=YES;
                                        UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                                        titleLabel.hidden=YES;
                                        [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                    }
                                    else
                                    {
                                        [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                    }
                                }
                            }
                             [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                        }
                    }
                }
                else
                {
                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                    [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                }

                if(centerDetails.count> 0)
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                else
                    selectCenterImageView.textLabel.text = @"Select Center";
                [[DataManager shared] removeActivityIndicator];
            }
            else if (actionSheet.tag == 200){
                //select state
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
                
                //for filter
                if (filterView == YES) {
                 if ([filterSuperview isEqualToString:@"Leaderboard"]) {
                    if (selectedStateIndex > 0) {
                        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                        [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                    }
                    // Update Height of filter View
                    if (selectedStateIndex > 0) {
                        if ([selectCenterImageView isHidden]) {
                            selectCenterImageView.hidden=NO;
                            UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                            titleLabel.hidden=NO;
                            if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                            }
                        }
                    }
                    else{
                        if (![selectCenterImageView isHidden]) {
                            selectCenterImageView.hidden=YES;
                            UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
                            titleLabel.hidden=YES;
                            if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateFilterView:)]) {
                                [centerSelectionDelegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                                
                            }
                        }
                    }
                 }
                 else{
                     //XBPro Filter
                     
                 }
                }
                else
                {
                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                    [centerSelectionDelegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                }
                if(centerDetails.count > 0)
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                else
                    selectCenterImageView.textLabel.text =@"Select Center";
                [[DataManager shared] removeActivityIndicator];
               
            }
            else if (actionSheet.tag == 300){
                //select center
                if(centerDetails.count > 0)
                {
                    selectCenterImageView.textLabel.text = [[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"name"];
                    
                }
                else
                    selectCenterImageView.textLabel.text = @"Select Center";
            }
            if(centerDetails.count> 0)
            {
                NSLog(@"selected center=%@",[centerDetails objectAtIndex:selectedCenterIndex]);
                totalLanes = [[[centerDetails objectAtIndex:selectedCenterIndex] objectForKey:@"totalLanes"] intValue];
            }
            else{
                totalLanes=0;
            }
            if (centerSelectionDelegate && [centerSelectionDelegate respondsToSelector:@selector(updateCenterInformation:selectedCountry:selectedState:selectedCenter:)]) {
                [centerSelectionDelegate updateCenterInformation:totalLanes selectedCountry:selectCountryImageView.textLabel.text selectedState:selectStateImageView.textLabel.text selectedCenter:selectCenterImageView.textLabel.text];
            }
            NSDictionary *centerDict=[NSDictionary new];
            if(centerDetails.count > 0)
            {
                centerDict=[NSDictionary dictionaryWithDictionary:[centerDetails objectAtIndex:selectedCenterIndex]];
            }
            if([centerSelectionDelegate respondsToSelector:@selector(selectedCenterDictionary:)])
                [centerSelectionDelegate selectedCenterDictionary:centerDict];
            if([centerSelectionDelegate respondsToSelector:@selector(selectedCountryDictionary:state:)])
                [centerSelectionDelegate selectedCountryDictionary:[countryInfoDict objectAtIndex:selectedCountryIndex] state:[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex]];
        }
        

    }
    @catch (NSException *exception) {
        return;
    }
}


#pragma mark - PickerView DataSource

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
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pV
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *string;
    if (pV.tag == 100) {
        string = [[countryInfoDict objectAtIndex:row] objectForKey:@"displayName"];
    }
    else if (pV.tag == 200){
        string = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:row] objectForKey:@"displayName"];
    }
    else if (pV.tag == 300){
        string = [[centerDetails objectAtIndex:row] objectForKey:@"name"];
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
}


@end
