//
//  TagsView.m
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "TagsView.h"
#import "Keys.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "DataManager.h"
#import "DetailNotificationView.h"

@implementation TagsView
{
    UIImageView * profileMainbackgroundImage;
    UIView *headerwhiteBackground;
    UITableView *centretableView;
    UILabel *headerLabel;
    //NSArray *tagsDetail;
    UIButton *saveButton;
    NSMutableArray *dynamicTag;
    UITextField *EnterTagtextField;
    UIView *blueBackgroundEnter;
    BOOL iskeyboardOpen;
    NSMutableArray *previousTagsCompareArray;
    
    NSUInteger currenTextfieldtag;
    NSString *previousTextfieldtext;
    NSString *saveEntertextFieldText;
}
@synthesize tagControllerDelegate=_tagControllerDelegate;

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        saveEntertextFieldText=@"";
        
        iskeyboardOpen=false;
        dynamicTag=[[NSMutableArray alloc]init];
        previousTagsCompareArray=[NSMutableArray new
                                   ];
        
        profileMainbackgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        profileMainbackgroundImage.userInteractionEnabled=YES;
        [profileMainbackgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
        [self addSubview:profileMainbackgroundImage];
        
        UIView *headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerBlueBackground.backgroundColor=XBHeaderColor;
        [self addSubview:headerBlueBackground];
        
        headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerwhiteBackground.backgroundColor=[UIColor clearColor];
        [headerBlueBackground addSubview:headerwhiteBackground];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-100, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        headerLabel.text=@"Tags";
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.numberOfLines=2;
        headerLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [headerwhiteBackground addSubview:headerLabel];
        
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [backButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerwhiteBackground addSubview:backButton];
        
        [centretableView removeFromSuperview];
        centretableView = nil;
        centretableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerwhiteBackground.frame.size.height+headerwhiteBackground.frame.origin.y+10, SCREEN_WIDTH, SCREEN_HEIGHT-headerwhiteBackground.frame.size.height-headerwhiteBackground.frame.origin.y-10 ) style:UITableViewStylePlain];//569
        centretableView.backgroundColor = [UIColor clearColor];
        centretableView.delegate = self;
        centretableView.dataSource = self;
        centretableView.hidden = YES;
        [centretableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [profileMainbackgroundImage addSubview:centretableView];
        
        saveButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-711)/6 currentSuperviewDeviceSize:screenBounds.size.width], centretableView.frame.origin.y+centretableView.frame.size.height+20, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:711/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
        saveButton.layer.cornerRadius=saveButton.frame.size.height/2;
        saveButton.clipsToBounds=YES;
        [saveButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        saveButton.hidden=YES;
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        saveButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [saveButton setTitleEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:25/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [saveButton setBackgroundImage:[[DataManager shared] setColor:XBBlueButtonBackgndHighlightedState buttonframe:saveButton.frame] forState:UIControlStateHighlighted];
        [profileMainbackgroundImage addSubview:saveButton];
        
        
        blueBackgroundEnter=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],centretableView.frame.origin.y+centretableView.frame.size.height+10, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        blueBackgroundEnter.backgroundColor=[UIColor blackColor];
        blueBackgroundEnter.alpha=0.3;
        [profileMainbackgroundImage addSubview:blueBackgroundEnter];

        
        EnterTagtextField = [[UITextField alloc] initWithFrame:CGRectMake(20, centretableView.frame.origin.y+centretableView.frame.size.height+10, self.frame.size.width-40, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        EnterTagtextField.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
        EnterTagtextField.placeholder = @"Enter tag";
        EnterTagtextField.tag=4578;
        
        EnterTagtextField.autocorrectionType = UITextAutocorrectionTypeNo;
        EnterTagtextField.keyboardType = UIKeyboardTypeDefault;
        EnterTagtextField.returnKeyType = UIReturnKeyDone;
        EnterTagtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        EnterTagtextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        EnterTagtextField.delegate = self;
        EnterTagtextField.textColor=[UIColor whiteColor];
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        clearButton.tag=15178133;
        [clearButton setFrame:CGRectMake(0, 0, 20, 20)];
        [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
        EnterTagtextField.rightViewMode = UITextFieldViewModeWhileEditing; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
        [EnterTagtextField setRightView:clearButton];

        
        EnterTagtextField.backgroundColor=[UIColor clearColor];
        UIColor *color = [UIColor whiteColor];
        EnterTagtextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter tag" attributes:@{NSForegroundColorAttributeName: color}];
        
        EnterTagtextField.backgroundColor=[UIColor clearColor];
        [profileMainbackgroundImage addSubview:EnterTagtextField];
    }
    return self;
}

-(void)updateTagsAfterEditing {
    
    
    NSUInteger firstArrayCount=dynamicTag.count/2;
    
    NSMutableArray *firstArray=[NSMutableArray new];
    NSMutableArray *secondArray=[NSMutableArray new];
    
    
    for(int i=0;i<firstArrayCount;i++)
    {
        [firstArray addObject:[dynamicTag objectAtIndex:i]];
    }
    
    for(NSUInteger i=firstArrayCount;i<dynamicTag.count;i++)
    {
        [secondArray addObject:[dynamicTag objectAtIndex:i]];
    }
    
    NSArray* uniqueValues = [dynamicTag valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]];
    
    if(uniqueValues.count!=dynamicTag.count)
    {
        [self ShowErrorAlertView:@"Tag Match"];
    }
    else{
        //        if([EnterTagtextField.text length]!=0)
        //        {
        //            [_tagControllerDelegate updateEdittedTags:[NSString stringWithFormat:@"%@,%@",[dynamicTag componentsJoinedByString:@","],EnterTagtextField.text]];
        //        }
        //        else{
        [_tagControllerDelegate updateEdittedTags:[dynamicTag componentsJoinedByString:@","]];
        //}
    }
    //if(EnterTagtextField.text containsString:<#(NSString *)#>)
    
    //     UITextField *textfield=(UITextField *)[self viewWithTag:currenTextfieldtag];
    //   if( iskeyboardOpen)
    //    {
    //        if(![dynamicTag containsObject:textfield.text])
    //        {
    //
    //    [dynamicTag removeObjectIdenticalTo:@""];
    //
    //    if([textfield.text length]!=0)
    //    {
    //        if(textfield!=EnterTagtextField)
    //        {
    //        [dynamicTag replaceObjectAtIndex:textfield.tag-121256 withObject:textfield.text];
    //        }
    //
    //        if(textfield==EnterTagtextField)
    //        {
    //    [_tagControllerDelegate updateEdittedTags:[NSString stringWithFormat:@"%@,%@",[dynamicTag componentsJoinedByString:@","],textfield.text]];
    //        }
    //        else{
    //            [_tagControllerDelegate updateEdittedTags:[dynamicTag componentsJoinedByString:@","]];
    //
    //        }
    //    }
    //    else{
    //
    //        [dynamicTag replaceObjectAtIndex:textfield.tag-121256 withObject:textfield.text];
    //
    //          [_tagControllerDelegate updateEdittedTags:[dynamicTag componentsJoinedByString:@","]];
    //    }
    //        }
    //        else{
    //            textfield.text=@"";
    //            [self ShowErrorAlertView:@"Tag Match"];
    //        }
    //    }
    //    else
    //    {
    //        [dynamicTag removeObjectIdenticalTo:@""];
}


-(void)emptyEnterTextField {
    
    previousTextfieldtext=@"";
    saveEntertextFieldText=@"";
     EnterTagtextField.text=@"";
}

#pragma mark - Save Button Action

-(void)saveButtonAction
{
    if(![dynamicTag containsObject:EnterTagtextField.text]&&[EnterTagtextField.text length]>0)
    {
        if ([EnterTagtextField.text isEqualToString:@"H2H Live"] || [EnterTagtextField.text isEqualToString:@"H2H Posted"] || [EnterTagtextField.text isEqualToString:@"Posted Game"])
        {
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"This is a reserved tag. Please enter some other tag." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
        else
        {
            [dynamicTag addObject:EnterTagtextField.text];
            [self reloadAndUpdateFrames];
            EnterTagtextField.text=@"";
        }
       
       
        
        //[centretableView reloadData];
        
    }
    else{
        UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter your tag first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview2 show];
    }
}

-(int)compareTwoArray:(NSArray *)firstarray  secondarr :(NSArray *)second
{
    NSMutableSet *set1 = [NSMutableSet setWithArray: firstarray];
    NSSet *set2 = [NSSet setWithArray: second];
    [set1 intersectSet: set2];
    NSLog(@"set :%@",[set1 allObjects]);
    
    return (int)[[set1 allObjects]count];
}

#pragma mark - Update Tsgs in Background

-(void)updateTags:(NSDictionary *)notifcaitionresponse
{
    centretableView.hidden=NO;
    saveButton.hidden=NO;
    NSArray * tagsDetail=(NSArray  *)notifcaitionresponse;
    [dynamicTag removeAllObjects];
    
    for(int i=0;i<tagsDetail.count;i++)
    {
        [dynamicTag addObject:[[tagsDetail objectAtIndex:i]objectForKey:@"tag"]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:dynamicTag forKey:ksavingGameTags];
    [self reloadAndUpdateFrames];
}


#pragma mark - Reload Data With Updating Frames

-(void)reloadAndUpdateFrames
{
    centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, ((dynamicTag.count)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    EnterTagtextField.frame=CGRectMake(EnterTagtextField.frame.origin.x, centretableView.frame.origin.y+centretableView.frame.size.height+20, EnterTagtextField.frame.size.width, EnterTagtextField.frame.size.height);
    
    if((EnterTagtextField.frame.size.height+EnterTagtextField.frame.origin.y+20+saveButton.frame.size.height+25)>SCREEN_HEIGHT)
    {
        centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, self.frame.size.height-headerwhiteBackground.frame.size.height-saveButton.frame.size.height-30-70);
        EnterTagtextField.frame=CGRectMake(EnterTagtextField.frame.origin.x, centretableView.frame.origin.y+centretableView.frame.size.height+20, EnterTagtextField.frame.size.width, EnterTagtextField.frame.size.height);
        saveButton.frame=CGRectMake(saveButton.frame.origin.x, EnterTagtextField.frame.size.height+EnterTagtextField.frame.origin.y+15, saveButton.frame.size.width, saveButton.frame.size.height);
    }
    else
    {
        saveButton.frame=CGRectMake(saveButton.frame.origin.x, EnterTagtextField.frame.size.height+EnterTagtextField.frame.origin.y+20, saveButton.frame.size.width, saveButton.frame.size.height);
    }
    blueBackgroundEnter.frame=CGRectMake(blueBackgroundEnter.frame.origin.x, EnterTagtextField.frame.origin.y, blueBackgroundEnter.frame.size.width, blueBackgroundEnter.frame.size.height);
    [centretableView reloadData];

}

#pragma mark - Textfield delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    iskeyboardOpen=false;

    if(self.frame.origin.y!=0.0)
    {
        [UIView animateWithDuration:.22 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             self.frame=CGRectMake(0, 0.0, self.frame.size.width, self.frame.size.height);
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, ((dynamicTag.count)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    
    if((EnterTagtextField.frame.size.height+EnterTagtextField.frame.origin.y+20+saveButton.frame.size.height+25)>SCREEN_HEIGHT)
    {
        centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, self.frame.size.height-headerwhiteBackground.frame.size.height-saveButton.frame.size.height-30-70);
    }

    return YES;
}

#pragma mark - Show Alert

-(void)ShowErrorAlertView:(NSString *)errorMessage {
    
    //errorMessage=@"Some error occurred.";
    
    errorMessage=@"Tags have already been added.";
    
    UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview2 show];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {

}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    iskeyboardOpen=true;
    currenTextfieldtag=textField.tag;
    if((EnterTagtextField.frame.origin.y+EnterTagtextField.frame.size.height)>SCREEN_HEIGHT/2&&self.frame.origin.y==0.0&&textField==EnterTagtextField)
    {
        [UIView animateWithDuration:.22 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             self.frame=CGRectMake(0, -180, self.frame.size.width, self.frame.size.height);
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    else if (textField!=EnterTagtextField)
    {
        if(self.frame.origin.y<0)
        {
            [UIView animateWithDuration:.22 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                 self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
             }
                             completion:^(BOOL finished)
             {
             }];
        }
        centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, ((6)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    }
}

#pragma mark - Touch Began

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
    if(self.frame.origin.y!=0.0)
    {
        [UIView animateWithDuration:.22 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             self.frame=CGRectMake(0, 0.0, self.frame.size.width, self.frame.size.height);
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
    if(iskeyboardOpen)
    {
    centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, ((dynamicTag.count)*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height]));
    
    if((EnterTagtextField.frame.size.height+EnterTagtextField.frame.origin.y+20+saveButton.frame.size.height+25)>SCREEN_HEIGHT)
    {
        centretableView.frame=CGRectMake(centretableView.frame.origin.x, centretableView.frame.origin.y,centretableView.frame.size.width, self.frame.size.height-headerwhiteBackground.frame.size.height-saveButton.frame.size.height-30-70);
    }
    }
    iskeyboardOpen=false;
}

#pragma mark - Table view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  dynamicTag.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    cell=nil;
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    float ycordinate=0;
    if(indexPath.row==dynamicTag.count)
    {
        ycordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height];
    }
    UIView *blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],ycordinate, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    blueBackground.backgroundColor=[UIColor blackColor];
    blueBackground.alpha=0.3;
    blueBackground.tag=1001212+indexPath.row;
    [cell.contentView addSubview:blueBackground];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-75, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    //textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
    textField.text = [dynamicTag objectAtIndex:indexPath.row];
    //textField.text=[dynamicTag objectAtIndex:indexPath.row];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.tag=121256+indexPath.row;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.userInteractionEnabled=false;
    if ([[NSString stringWithFormat:@"%@",[dynamicTag objectAtIndex:indexPath.row]] isEqualToString:@"H2H Live"] || [[NSString stringWithFormat:@"%@",[dynamicTag objectAtIndex:indexPath.row]] isEqualToString:@"H2H Posted"] || [[NSString stringWithFormat:@"%@",[dynamicTag objectAtIndex:indexPath.row]] isEqualToString:@"Posted Game"]) {
    }
    else{
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIButton *clearButton = [[UIButton alloc]init];
        clearButton.backgroundColor=[UIColor clearColor];
        //[clearButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [clearButton setFrame:CGRectMake(textField.frame.origin.x+textField.frame.size.width+15, ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height]-40)/2, 40, 40)];
        clearButton.tag=135313+indexPath.row;
        [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:clearButton];
        
        UIImageView *crossImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];crossImage.image=[UIImage imageNamed:@"cross.png"];
        [clearButton addSubview:crossImage];

    }
    
    textField.rightViewMode = UITextFieldViewModeWhileEditing; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.backgroundColor=[UIColor clearColor];
    textField.textColor=[UIColor whiteColor];
    UIColor *color = [UIColor whiteColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter tag" attributes:@{NSForegroundColorAttributeName: color}];
    [cell.contentView addSubview:textField];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(00,blueBackground.frame.size.height-1.5, SCREEN_HEIGHT,1)];
    separatorLine.backgroundColor=coachViewPlayerSeparatorLine;
    [blueBackground addSubview:separatorLine];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
}

-(void)clearTextField:(UIButton*)sender {
    
    if(sender.tag!=15178133)
    {
        [dynamicTag removeObjectAtIndex:sender.tag-135313];
        [self reloadAndUpdateFrames];
    }
    else
    {
        EnterTagtextField.text=@"";
    }
}

-(void)backWithdelay {
    
    self.userInteractionEnabled=true;
    [_tagControllerDelegate updateEdittedTags:[dynamicTag componentsJoinedByString:@","]];

    //[_tagControllerDelegate backButtonAction];
}


#pragma mark - Bakc button Action

-(void)sideMenuButtonAction {
    
    [self endEditing:YES
     ];
    self.userInteractionEnabled=false;
    [self performSelector:@selector(backWithdelay) withObject:nil afterDelay:0.0];
}


@end
