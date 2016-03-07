//
//  PasscodeView.m
//  Xbowling
//
//  Created by Click Labs on 6/22/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "PasscodeView.h"

@implementation PasscodeView
{
    NSDictionary *itemDictionary;
    UITextField *codeTextField;
    NSString *pointsCategory;
    
}
@synthesize delegate;
- (void)createPasscodeViewFor:(NSString *)category item:(NSDictionary *)selectedItem
{
    pointsCategory=category;
    itemDictionary=[[NSDictionary alloc]initWithDictionary:selectedItem];
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
    headerLabel.text=@"Enter Code";
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
    
    UILabel *noteLabel=[[UILabel alloc]init];
    noteLabel.frame=CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    noteLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    noteLabel.textColor=[UIColor whiteColor];
    noteLabel.textAlignment=NSTextAlignmentCenter;
    noteLabel.text=@"Please hand your device to \na service employee to \nenter the code";
    noteLabel.numberOfLines=3;
    noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
    noteLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:noteLabel];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,noteLabel.frame.size.height+noteLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    titleLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.6];
    titleLabel.text=@"  Enter Code";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [self addSubview:titleLabel];
    
    if ([category isEqualToString:@"Earn"]) {
        UILabel *addPointsLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,noteLabel.frame.size.height+noteLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        addPointsLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.6];
        addPointsLabel.text=[NSString stringWithFormat:@"  Add %d Points to Account?",[[itemDictionary objectForKey:@"itemPoint"] intValue]];
        addPointsLabel.textColor=[UIColor whiteColor];
        addPointsLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [self addSubview:addPointsLabel];
        
        titleLabel.frame=CGRectMake(0,addPointsLabel.frame.size.height+addPointsLabel.frame.origin.y+1, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    }
   
    
    codeTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y, self.frame.size.width - 2,  [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    codeTextField.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.3];
    codeTextField.textColor=[UIColor whiteColor];
    codeTextField.delegate=self;
    codeTextField.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    codeTextField.textAlignment = NSTextAlignmentCenter;
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width],codeTextField.frame.size.height)];
//    [codeTextField setLeftViewMode:UITextFieldViewModeAlways];
//    [codeTextField setLeftView:paddingView];
    codeTextField.inputView = nil;
    [self addSubview:codeTextField];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake(0, 0, 20, 20)];
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    codeTextField.rightViewMode = UITextFieldViewModeWhileEditing; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [codeTextField setRightView:clearButton];
    [codeTextField becomeFirstResponder];


    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    if (screenBounds.size.height > 568) {
         numberPadView = [[CustomNumberPad alloc]initWithFrame:CGRectMake(20, codeTextField.frame.size.height+codeTextField.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width - 40,260) collectionViewLayout:layout];
    }
    else{
        numberPadView = [[CustomNumberPad alloc]initWithFrame:CGRectMake(20, codeTextField.frame.size.height+codeTextField.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width - 40,230) collectionViewLayout:layout];
    }
    numberPadView.numberPadDelegate=self;
    numberPadView.buttonLabelsArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"DEL", nil];
    [numberPadView setDataSource:self];
    [numberPadView setDelegate:self];
    [self addSubview:numberPadView];

    
    UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],numberPadView.frame.size.height + numberPadView.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    if (screenBounds.size.height == 480) {
        submitButton.frame = CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],(numberPadView.frame.size.height + numberPadView.frame.origin.y) - 20, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height]);
    }
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

- (void)submitButtonFunction
{
    [[DataManager shared]showActivityIndicator:@"Loading..."];
    [self performSelector:@selector(submitPoints) withObject:nil afterDelay:0.5];
}

- (void)submitPoints
{
    if ([pointsCategory isEqualToString:@"Redeem"]) {
        [delegate submitPasscode:itemDictionary userEnteredPasscode:codeTextField.text forCategory:@"Redeem"];
    }
    else{
        [delegate submitPasscode:itemDictionary userEnteredPasscode:codeTextField.text forCategory:pointsCategory];
    }
}

- (void)backButtonFunction
{
    [delegate removePasscodeView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)clearTextField:(UIButton *)sender
{
    codeTextField.text=@"";
}
#pragma mark - Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return 12;
}

- (void)selectedNumber:(NSString *)score
{
   //Display number
    codeTextField.text = [codeTextField.text stringByAppendingString:score];
}

- (void)deleteNumberEntry
{
   //REmove number
    if (codeTextField.text.length > 0) {
        NSString *currentText = codeTextField.text;
        NSString *newString = [currentText substringToIndex:currentText.length - 1];
        codeTextField.text = newString;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.inputView) {
        //hides the keyboard, but still shows the cursor to allow user to view entire text, even if it exceeds the bounds of the textfield
        textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}


@end
