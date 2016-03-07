//
//  ShippingInformationView.m
//  Xbowling
//
//  Created by Click Labs on 8/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ShippingInformationView.h"

@implementation ShippingInformationView
{
    DropDownImageView *selectStateImageView;
    CustomActionSheet *actionSheet ;
    int selectedStateIndex;
    UIPickerView *pickerView ;
    NSMutableArray *statesArray;
    UIScrollView *scroll;
}
@synthesize delegate;
- (void)createViewForItem:(NSDictionary *)itemDictionary forStates:(NSArray *)states
{
    selectedStateIndex = 0;
    statesArray = [[NSMutableArray alloc]initWithArray:states];
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
    headerLabel.text=@"Shipping Information";
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
    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    closeButton.layer.cornerRadius=closeButton.frame.size.height/2;
    closeButton.clipsToBounds=YES;
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:closeButton.frame] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:closeButton.frame] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Submit" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(submitAddressFunction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:closeButton];
    
    scroll= [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]+headerView.frame.size.height, self.frame.size.width, 400)];
    scroll.userInteractionEnabled = YES;
    scroll.delegate=self;
    scroll.showsVerticalScrollIndicator=YES;
    scroll .backgroundColor=[UIColor clearColor];
    [self addSubview:scroll];
    
    NSArray *fieldsArray=[[NSArray alloc]initWithObjects:@"First Name",@"Last Name",@"Address Line 1",@"Address Line 2",@"Zip Code",@"City Name",@"Select State", nil];
    int ycoordinate = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height];
    for (int i =0 ; i<(fieldsArray.count - 1); i++) {
        //Lane Number box
//        UIImageView *laneNumberBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, ycoordinate,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
////        [laneNumberBackground setTag:100+i];
//        laneNumberBackground.userInteractionEnabled=YES;
////        [scroll addSubview:laneNumberBackground];
      
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        UITextField *laneTextField =  [[UITextField alloc] initWithFrame: CGRectMake(0,ycoordinate,scroll.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        laneTextField.textColor = [UIColor whiteColor];
        laneTextField.leftViewMode = UITextFieldViewModeAlways;
        laneTextField.leftView = paddingView;
        laneTextField.keyboardType = UIKeyboardTypeNumberPad;
        laneTextField.returnKeyType = UIReturnKeyNext;
        laneTextField.delegate=self;
        [laneTextField setTag:100+i];
        if ([laneTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor grayColor];
            laneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@",[fieldsArray objectAtIndex:i]] attributes:@{NSForegroundColorAttributeName: color}];
        }
        laneTextField.backgroundColor=[UIColor clearColor];
        laneTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        laneTextField.userInteractionEnabled=YES;
        [scroll addSubview:laneTextField];
        
        UIView *separatorImage=[[UIView alloc]init];
        separatorImage.frame=CGRectMake(0,laneTextField.frame.size.height - 0.5, laneTextField.frame.size.width, 0.5);
        separatorImage.backgroundColor=separatorColor;
        [laneTextField addSubview:separatorImage];
        
        ycoordinate = laneTextField.frame.size.height + laneTextField.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    selectStateImageView = [[DropDownImageView alloc] initWithFrame:CGRectMake(0, ycoordinate,self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    if ([selectStateImageView.textLabel respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        selectStateImageView.textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select State" attributes:@{NSForegroundColorAttributeName: color}];
    }
    selectStateImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *StatetapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
    StatetapRecognizer.numberOfTapsRequired = 1;
    [selectStateImageView addGestureRecognizer:StatetapRecognizer];
    [scroll addSubview:selectStateImageView];
    
    ycoordinate = ycoordinate + selectStateImageView.textLabel.frame.size.height + selectStateImageView.textLabel.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height];

    scroll.contentSize = CGSizeMake(scroll.frame.size.width, ycoordinate);
}

#pragma mark - Show Dropdown
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    DropDownImageView  *tappedImageView = (DropDownImageView *)[tapGesture view];
    tappedImageView.dropDownImageView.image= [UIImage imageNamed:@"dropdown_icon_on.png"];
    [self performSelector:@selector(changeDropdownIconImage:) withObject:tappedImageView.dropDownImageView afterDelay:0.5];
    NSString *titleString;
    if (tappedImageView == selectStateImageView) {
        titleString = @"Select State";
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
    actionSheet.tag = 1000;
    pickerView.tag = 1000;
    if(statesArray.count > 0) {
         [actionSheet showPicker];
         [actionSheet.actionSheet addSubview:pickerView];
        [self addSubview:actionSheet];
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

#pragma mark - Hide Dropdown
- (void)dismissActionSheet
{
    //select state
    selectStateImageView.textLabel.text = [[statesArray objectAtIndex:selectedStateIndex] objectForKey:@"displayName"];
}

- (void)submitAddressFunction
{
    NSLog(@"scroll = %@",scroll.subviews);
    UITextField *firstname = (UITextField *)[scroll viewWithTag:100];
    UITextField *lastname = (UITextField *)[scroll viewWithTag:101];
    UITextField *addline1 = (UITextField *)[scroll viewWithTag:102];
    UITextField *addline2 = (UITextField *)[scroll viewWithTag:103];
    UITextField *cityfield = (UITextField *)[scroll viewWithTag:105];
    UITextField *zipcode = (UITextField *)[scroll viewWithTag:104];
    if(([firstname.text length]>0)&&([lastname.text length]>0)&&([addline1.text length]>0)&&([zipcode.text length]>0)&&([cityfield.text length]>0)&&([selectStateImageView.textLabel.text length]>0))
    {
        if([addline2.text length]>0)
        {
        }
        else{
            addline2.text=@" ";
        }
        
        NSDictionary *iemIdDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",[[[statesArray objectAtIndex:selectedStateIndex] objectForKey:@"administrativeAreaId"] integerValue]], @"id", nil];
        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:iemIdDict,@"product",addline1.text,@"shipToAddressLine1",addline2.text ,@"shipToAddressLine2",cityfield.text,@"shipToCity",[[firstname.text stringByAppendingString:@" "] stringByAppendingString: lastname.text],@"shipToName",zipcode.text,@"shipToZip",selectStateImageView.textLabel.text,@"shipToState", nil];
        [delegate submitAddressInformation:postDict];

    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }

}

- (void)backButtonFunction
{
    [delegate removeAddressView];
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pV numberOfRowsInComponent:(NSInteger)component
{
    return statesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pV
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *string = [[statesArray objectAtIndex:row] objectForKey:@"displayName"];
    return string;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedStateIndex = (int)row;
}

@end
