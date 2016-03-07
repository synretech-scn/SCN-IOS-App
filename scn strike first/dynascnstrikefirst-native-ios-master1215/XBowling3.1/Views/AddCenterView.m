//
//  AddCenterView.m
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "AddCenterView.h"

@implementation AddCenterView
{
    NSMutableArray *valuesArray;
    int selectedCountryIndex;
    int selectedStateIndex;
    int selectedCenterIndex;
    CustomActionSheet *actionSheet ;
    UIPickerView *pickerView ;

}
@synthesize delegate,countryInfoDict,centerDetails;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)createMainView
{
    selectedCenterIndex=0;
    selectedCountryIndex=0;
    selectedStateIndex=0;
    NSArray *filterHeadersArray=[[NSArray alloc]initWithObjects:@"Select Country",@"Select State",@"Select Center", nil];
    valuesArray=[[NSMutableArray alloc]initWithObjects:@"Select Country",@"Select State",@"Select Center", nil];
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
    headerLabel.text=@"Add Center";
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
    
    int ycoordinate = headerView.frame.size.height+headerView.frame.origin.y+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i=0; i<[filterHeadersArray count]; i++) {
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,ycoordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        titleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
        titleLabel.text=[NSString stringWithFormat:@"   %@",[filterHeadersArray objectAtIndex:i]];
        titleLabel.tag=500+i;
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [self addSubview:titleLabel];
        
        DropDownImageView *filterDropdown = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        filterDropdown.textLabel.text=[NSString stringWithFormat:@"%@",[valuesArray objectAtIndex:i]];
        filterDropdown.tag=100*(i+1);
        filterDropdown.userInteractionEnabled = YES;
        UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [filterDropdown addGestureRecognizer:tapRecognizer];
        [self addSubview:filterDropdown];
        
        ycoordinate=titleLabel.frame.size.height+titleLabel.frame.origin.y+filterDropdown.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    
    UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    submitButton.layer.cornerRadius=submitButton.frame.size.height/2;
    submitButton.clipsToBounds=YES;
    [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:submitButton.frame] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:submitButton.frame] forState:UIControlStateHighlighted];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:submitButton];
    
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [self performSelector:@selector(venues) withObject:self afterDelay:0.2];
    
}

-(void)venues
{
    DropDownImageView *selectCountryImageView=(DropDownImageView *)[self viewWithTag:100];
    DropDownImageView *selectStateImageView=(DropDownImageView *)[self viewWithTag:200];
    DropDownImageView *selectCenterImageView=(DropDownImageView *)[self viewWithTag:300];
    @try {
        if (delegate && [delegate respondsToSelector:@selector(venueInfo)]) {
            [delegate venueInfo];
        }
        if ([countryInfoDict count]>0 )
        {

                [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
                [delegate getNearbyCenter];  //for live score
        }
        else
        {
            if (selectedCountryIndex > 0) {
                [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
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
        }
        else{
            selectCenterImageView.textLabel.text = @"Select Center";
        }
//        [delegate updateCenterInformation:0 selectedCountry:selectCountryImageView.textLabel.text selectedState:selectStateImageView.textLabel.text selectedCenter:selectCenterImageView.textLabel.text];
        NSDictionary *centerDict=[NSDictionary new];
        if(centerDetails.count > 0)
        {
            centerDict=[NSDictionary dictionaryWithDictionary:[centerDetails objectAtIndex:selectedCenterIndex]];
        }
//        if([delegate respondsToSelector:@selector(selectedCenterDictionary:)])
//            [delegate selectedCenterDictionary:centerDict];
        
    }
    @catch (NSException *exception) {
        selectedCenterIndex=0;
    }
    [[DataManager shared]removeActivityIndicator];
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
    if (tappedImageView.tag == 100) {
        titleString = @"Select Country";
    }
    else if (tappedImageView.tag == 200){
        titleString = @"Select State";
    }
    else if (tappedImageView.tag == 300){
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

        [self.superview addSubview:actionSheet];
        [actionSheet showPicker];
        if (tappedImageView.tag == 100) {
            actionSheet.tag = 100;
            pickerView.tag = 100;
            [pickerView selectRow:selectedCountryIndex inComponent:0 animated:NO];
        }
        else if (tappedImageView.tag == 200){
            actionSheet.tag = 200;
            pickerView.tag = 200;
            [pickerView selectRow:selectedStateIndex inComponent:0 animated:NO];
        }
        else if (tappedImageView.tag == 300){
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
    [self.superview addSubview:actionSheet];

    
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
    DropDownImageView *selectCountryImageView=(DropDownImageView *)[self viewWithTag:100];
    DropDownImageView *selectStateImageView=(DropDownImageView *)[self viewWithTag:200];
    DropDownImageView *selectCenterImageView=(DropDownImageView *)[self viewWithTag:300];

    @try {
        if(countryInfoDict.count>0)
        {
            if (actionSheet.tag == 100) {
                //select country
                selectCountryImageView.textLabel.text = [[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"];
                selectStateImageView.textLabel.text = [[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
                
                //for filter
//                if (filterView == YES) {
//                    if ([filterSuperview isEqualToString:@"Leaderboard"]) {
//                        if (selectedCountryIndex > 0) {
//                            if ([selectStateImageView isHidden]) {
//                                selectStateImageView.hidden=NO;
//                                UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
//                                titleLabel.hidden=NO;
//                                if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                    [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                }
//                            }
//                        }
//                        else
//                        {
//                            if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                if (![selectStateImageView isHidden]) {
//                                    selectStateImageView.hidden=YES;
//                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
//                                    titleLabel.hidden=YES;
//                                    if (![selectCenterImageView isHidden]) {
//                                        selectCenterImageView.hidden=YES;
//                                        UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
//                                        titleLabel.hidden=YES;
//                                        [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                    }
//                                    else
//                                    {
//                                        [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        // XBPro
//                        if (selectedCountryIndex > 0) {
//                            [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
//                            if ([selectStateImageView isHidden]) {
//                                selectStateImageView.hidden=NO;
//                                UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
//                                titleLabel.hidden=NO;
//                                if ([selectCenterImageView isHidden]) {
//                                    selectCenterImageView.hidden=NO;
//                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
//                                    titleLabel.hidden=NO;
//                                }
//                                [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
//                                if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                    [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                }
//                            }
//                        }
//                        else
//                        {
//                            if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                if (![selectStateImageView isHidden]) {
//                                    selectStateImageView.hidden=YES;
//                                    UILabel *titleLabel=(UILabel *)[self viewWithTag:210];
//                                    titleLabel.hidden=YES;
//                                    if (![selectCenterImageView isHidden]) {
//                                        selectCenterImageView.hidden=YES;
//                                        UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
//                                        titleLabel.hidden=YES;
//                                        [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(2*(180+30+86))/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                    }
//                                    else
//                                    {
//                                        [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                    }
//                                }
//                            }
//                            [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
//                        }
//                    }
//                }
//                else
//                {
                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                    [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
//                }
                
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
//                if (filterView == YES) {
//                    if ([filterSuperview isEqualToString:@"Leaderboard"]) {
//                        if (selectedStateIndex > 0) {
//                            [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
//                            [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
//                        }
//                        // Update Height of filter View
//                        if (selectedStateIndex > 0) {
//                            if ([selectCenterImageView isHidden]) {
//                                selectCenterImageView.hidden=NO;
//                                UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
//                                titleLabel.hidden=NO;
//                                if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                    [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                }
//                            }
//                        }
//                        else{
//                            if (![selectCenterImageView isHidden]) {
//                                selectCenterImageView.hidden=YES;
//                                UILabel *titleLabel=(UILabel *)[self viewWithTag:211];
//                                titleLabel.hidden=YES;
//                                if (delegate && [delegate respondsToSelector:@selector(updateFilterView:)]) {
//                                    [delegate updateFilterView:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:-(180+30+86)/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//                                    
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        //XBPro Filter
//                        
//                    }
//                }
//                else
//                {
                    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
                    [delegate centerInfoForCountry:[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"]];
//                }
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

//            if (delegate && [delegate respondsToSelector:@selector(updateCenterInformation:selectedCountry:selectedState:selectedCenter:)]) {
//                [delegate updateCenterInformation:1 selectedCountry:selectCountryImageView.textLabel.text selectedState:selectStateImageView.textLabel.text selectedCenter:selectCenterImageView.textLabel.text];
//            }
            NSDictionary *centerDict=[NSDictionary new];
            if(centerDetails.count > 0)
            {
                centerDict=[NSDictionary dictionaryWithDictionary:[centerDetails objectAtIndex:selectedCenterIndex]];
            }
            if([delegate respondsToSelector:@selector(selectedCenterDictionary:)])
                [delegate selectedCenterDictionary:centerDict];
            if([delegate respondsToSelector:@selector(selectedCountryDictionary:state:)])
                [delegate selectedCountryDictionary:[countryInfoDict objectAtIndex:selectedCountryIndex] state:[[[countryInfoDict objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex]];
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


- (void)backButtonFunction
{
    [delegate removeCenterView];
}

- (void)submitButtonFunction:(UIButton *)sender
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
        if (centerDetails.count > 0) {
            [[DataManager shared]showActivityIndicator:@"Loading..."];
            [self performSelector:@selector(addCenter) withObject:nil afterDelay:0.2];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select some center." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
       
    }
   
}

- (void)addCenter
{
    [delegate submitSelectedCenter:[centerDetails objectAtIndex:selectedCenterIndex]];
}
@end
