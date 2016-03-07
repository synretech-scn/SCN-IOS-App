//
//  LoginView.m
//  XBowling3.1
//
//  Created by clicklabs on 1/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LoginView.h"
#import "Keys.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation LoginView
{
    UITextField *loginusernameTextfield,*loginpasswordTextfield;
    UITextField *forgotTextfield;
    UITextField *signUpuserNametextfield,*signUpPasswordTextfield;
    UIImageView *backImage;
    UIImageView *mainBackImage;
    UIView *signUpBackground;
    UIView *forgotBackground;
    UIButton *sideNavigationButton;
    int currentApiNUmber;
    UIButton *signUpButton;
}
@synthesize loginDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",0] forKey:currentUnreadAllNotification];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]integerValue];

        mainBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        mainBackImage.image=[UIImage imageNamed:@"loginbackground.png"];
        mainBackImage.userInteractionEnabled=YES;
        [self addSubview:mainBackImage];
        
        backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backImage.backgroundColor=[UIColor clearColor];
        backImage.userInteractionEnabled=YES;
        [self addSubview:backImage];
        
        UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:989/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.height])];
//        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
//        {
//            if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
//            {
//                //iphone 3.5 inch screen
//                logoImageView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:266/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:264/3 currentSuperviewDeviceSize:screenBounds.size.height]);
//                logoImageView.center=CGPointMake(self.center.x, logoImageView.center.y);
//            }
//            else
//            {
//                
//            }
//        }
//        else
//        {
//            //[ipad]
//            logoImageView.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:266/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:264/3 currentSuperviewDeviceSize:screenBounds.size.height]);
//            logoImageView.center=CGPointMake(self.center.x, logoImageView.center.y);
//        }
      
        logoImageView.image=[UIImage imageNamed:@"x bowling logo.png"];
        [backImage addSubview:logoImageView];
        
        UIImageView *userIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:125/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:743/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:51/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        userIcon.image=[UIImage imageNamed:@"ic_username.png"];
        [backImage addSubview:userIcon];
        
        loginusernameTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:232/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:744/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-(1242-973)-232)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        loginusernameTextfield.borderStyle = UITextBorderStyleNone;
        loginusernameTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        loginusernameTextfield.placeholder = @"Email Address";
        loginusernameTextfield.backgroundColor=[UIColor clearColor];
        loginusernameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        loginusernameTextfield.keyboardType = UIKeyboardTypeEmailAddress;
        loginusernameTextfield.returnKeyType = UIReturnKeyDone;
        loginusernameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        loginusernameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        loginusernameTextfield.delegate = self;
        loginusernameTextfield.textColor=[UIColor whiteColor];
        loginusernameTextfield.leftViewMode=UITextFieldViewModeAlways;
        loginusernameTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UIColor *color = [UIColor whiteColor];
        loginusernameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
        [backImage addSubview:loginusernameTextfield];
        
        UIView *separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:855/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-2*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
        separatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
        [backImage addSubview: separatorBlackLine];
        
        UIImageView *passwordIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:125/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:908/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:51/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        passwordIcon.image=[UIImage imageNamed:@"ic_password.png"];
        [backImage addSubview:passwordIcon];
        
        loginpasswordTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:232/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-(1242-973)-232)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        loginpasswordTextfield.borderStyle = UITextBorderStyleNone;
        loginpasswordTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        loginpasswordTextfield.placeholder = @"Password";
        loginpasswordTextfield.backgroundColor=[UIColor clearColor];
        loginpasswordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        loginpasswordTextfield.keyboardType = UIKeyboardTypeDefault;
        loginpasswordTextfield.returnKeyType = UIReturnKeyDone;
        loginpasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        loginpasswordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        loginpasswordTextfield.delegate = self;
        loginpasswordTextfield.leftViewMode=UITextFieldViewModeAlways;
        loginpasswordTextfield.secureTextEntry=true;
        loginpasswordTextfield.textColor=[UIColor whiteColor];
        loginpasswordTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        color = [UIColor whiteColor];
        loginpasswordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
        [backImage addSubview:loginpasswordTextfield];
        
        UIButton *forgotButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:975/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:915/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        forgotButton.backgroundColor=[UIColor clearColor];
        forgotButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [forgotButton setTitle:@"Forgot?" forState:UIControlStateNormal];
        [forgotButton setTitleColor:XBBlueTitleButtonNormalStateColor forState:UIControlStateNormal];
        [forgotButton setTitleColor:XBBlueTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
        [forgotButton addTarget:self action:@selector(forgotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backImage addSubview:forgotButton];
        
        separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1009/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-2*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
        separatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
        [backImage addSubview: separatorBlackLine];
        
        UIButton *signInButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1095/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        signInButton.layer.cornerRadius=signInButton.frame.size.height/2;
        signInButton.clipsToBounds=YES;
        //[signInButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [signInButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:signInButton.frame] forState:UIControlStateNormal];
        [signInButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:signInButton.frame] forState:UIControlStateHighlighted];
        [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [signInButton addTarget:self action:@selector(loginInButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        signInButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [backImage addSubview:signInButton];
        
        UIView  *LeftseparatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:82/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1315/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:494/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
        LeftseparatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
        [backImage addSubview: LeftseparatorBlackLine];
        
        
        UILabel*orLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:583/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1295/3 currentSuperviewDeviceSize:self.frame.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75/3 currentSuperviewDeviceSize:screenBounds.size.width] , [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:self.frame.size.height])];
        orLabel.textAlignment=NSTextAlignmentCenter;
        orLabel.backgroundColor=[UIColor clearColor];
        orLabel.lineBreakMode=NSLineBreakByWordWrapping;
        orLabel.numberOfLines=0;
        orLabel.backgroundColor=[UIColor clearColor];
        orLabel.textColor=[UIColor whiteColor];
        orLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.width]];
        orLabel.text=@"or";
        [backImage addSubview:orLabel];
        
        UIView  *rightSeparatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:670/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1315/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:494/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
        rightSeparatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
        [backImage addSubview: rightSeparatorBlackLine];
        
        UIView *signwithFaceookbackGround=[[UIView alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1405/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        signwithFaceookbackGround.layer.cornerRadius=signwithFaceookbackGround.frame.size.height/2;
        signwithFaceookbackGround.clipsToBounds=YES;
        signwithFaceookbackGround.alpha=0.6;
        [signwithFaceookbackGround setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [backImage addSubview:signwithFaceookbackGround];
        
        
        UIButton *signwithFaceook=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1405/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        signwithFaceook.layer.cornerRadius=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/6 currentSuperviewDeviceSize:self.frame.size.height];
        [signwithFaceook setBackgroundColor:[UIColor clearColor]];
        [signwithFaceook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signwithFaceook setImage:[UIImage imageNamed:@"fb icon.png"] forState:UIControlStateNormal];
        [signwithFaceook setImage:[UIImage imageNamed:@"fb icon.png"] forState:UIControlStateHighlighted];
        [signwithFaceook setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:signwithFaceook.frame] forState:UIControlStateHighlighted];
        [signwithFaceook setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:145/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:753/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        signwithFaceook.layer.masksToBounds=YES;
        signwithFaceook.clipsToBounds=YES;
        [signwithFaceook setTitle:@"Sign In with Facebook" forState:UIControlStateNormal];
        [signwithFaceook addTarget:self action:@selector(signInWithFacebookButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        signwithFaceook.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [signwithFaceook setTitleEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [backImage addSubview:signwithFaceook];
        //modi
        UILabel*homeCentreHeaderAdd=[[UILabel alloc]initWithFrame:CGRectMake( 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1752/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height])];
        homeCentreHeaderAdd.textAlignment=NSTextAlignmentCenter;
        homeCentreHeaderAdd.backgroundColor=[UIColor clearColor];
        homeCentreHeaderAdd.lineBreakMode=NSLineBreakByWordWrapping;
        homeCentreHeaderAdd.numberOfLines=0;//0
        homeCentreHeaderAdd.textColor=[UIColor whiteColor];
        homeCentreHeaderAdd.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.width]];
     // homeCentreHeaderAdd.text=@"Don't have an account yet?";
    //    homeCentreHeaderAdd.text=@"If you have already had SCN/Xbowling account,\n you can directly Sign In.\n Otherwise, please Sign Up to join us";
            homeCentreHeaderAdd.text=@"(Sign In directly, if you have already had SCN/Xbowling account)";
        [backImage addSubview:homeCentreHeaderAdd];
        
        //add
        UILabel*homeCentreHeader=[[UILabel alloc]initWithFrame:CGRectMake( 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1822/3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height])];
        homeCentreHeader.textAlignment=NSTextAlignmentCenter;
        homeCentreHeader.backgroundColor=[UIColor clearColor];
        homeCentreHeader.lineBreakMode=NSLineBreakByWordWrapping;
        homeCentreHeader.numberOfLines=0;//0
        homeCentreHeader.textColor=[UIColor whiteColor];
        homeCentreHeader.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.width]];
          homeCentreHeader.text=@"Don't have an account yet?";
       // homeCentreHeader.text=@"If you have already had SCN/Xbowling account,\n you can directly Sign In.\n Otherwise, please Sign Up to join us";
        [backImage addSubview:homeCentreHeader];
        
        UIButton *joinUsButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1935/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        joinUsButton.layer.cornerRadius=signInButton.frame.size.height/2;
        joinUsButton.layer.borderWidth=2;
        joinUsButton.layer.borderColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:0.6].CGColor;
        joinUsButton.clipsToBounds=YES;
        [joinUsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:signInButton.frame] forState:UIControlStateNormal];
        [joinUsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:signInButton.frame] forState:UIControlStateHighlighted];
        [joinUsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinUsButton setTitle:@"Join us!" forState:UIControlStateNormal];
        [joinUsButton setTitleEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width])];

        [joinUsButton addTarget:self action:@selector(joinButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        joinUsButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [backImage addSubview:joinUsButton];
    }
    return self;
}

#pragma mark - Sign In with Facebook

-(void)signInWithFacebookButtonFunction
{
    [loginDelegate fbSignUpFunction];
}

#pragma mark - Sign Up view

-(void)joinButtonFunction {
    
    sideNavigationButton.hidden=YES;
    [self endEditing:YES];
    backImage .hidden=true;
    
    signUpBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    signUpBackground.backgroundColor=[UIColor clearColor];
    [mainBackImage addSubview:signUpBackground];
    
    UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:989/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    logoImageView.image=[UIImage imageNamed:@"x bowling logo.png"];
    [signUpBackground addSubview:logoImageView];
    
    
    //    UIButton *bacSignUpButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    //    [bacSignUpButton setBackgroundColor:[UIColor clearColor]];
    //    [bacSignUpButton setImage:[UIImage imageNamed:@"back_login.png"] forState:UIControlStateNormal];
    //    [bacSignUpButton setImage:[UIImage imageNamed:@"back_login_onclick.png"] forState:UIControlStateHighlighted];
    //    [bacSignUpButton addTarget:self action:@selector(bacSignUpButtonAction:) forControlEvents:UIControlEventTouchDown];
    //   // [signUpBackground addSubview:bacSignUpButton];
    
    
    UIView  *LeftseparatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:82/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1315/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:494/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
    LeftseparatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
    [signUpBackground addSubview: LeftseparatorBlackLine];
    
    
    UILabel*orLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:583/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1295/3 currentSuperviewDeviceSize:self.frame.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:75/3 currentSuperviewDeviceSize:screenBounds.size.width] , [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:self.frame.size.height])];
    orLabel.textAlignment=NSTextAlignmentCenter;
    orLabel.backgroundColor=[UIColor clearColor];
    orLabel.lineBreakMode=NSLineBreakByWordWrapping;
    orLabel.numberOfLines=0;
    orLabel.backgroundColor=[UIColor clearColor];
    orLabel.textColor=[UIColor whiteColor];
    orLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.width]];
    orLabel.text=@"or";
    [signUpBackground addSubview:orLabel];
    
    UIView  *rightSeparatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:670/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1315/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:494/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
    rightSeparatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
    [signUpBackground addSubview: rightSeparatorBlackLine];
    
    
    UIButton *editPhotoButton=[[UIButton alloc]initWithFrame:CGRectMake(5, screenBounds.size.height-150, screenBounds.size.width-5, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    editPhotoButton.backgroundColor=[UIColor clearColor];
    editPhotoButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:63/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    editPhotoButton.userInteractionEnabled=true;
    [editPhotoButton setTitle:@"Already have account? Sign In Here." forState:UIControlStateNormal];
    //editPhotoButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [editPhotoButton setTitleColor:XBBlueTitleButtonNormalStateColor forState:UIControlStateNormal];
    [editPhotoButton setTitleColor:XBBlueTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [editPhotoButton addTarget:self action:@selector(bacSignUpButtonAction:) forControlEvents:UIControlEventTouchDown];
    [signUpBackground addSubview:editPhotoButton];
    
    
    
    UIImageView *userIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:125/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:743/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:51/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    userIcon.image=[UIImage imageNamed:@"ic_username.png"];
    [signUpBackground addSubview:userIcon];
    
    signUpuserNametextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:232/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:744/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-232-160)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    signUpuserNametextfield.borderStyle = UITextBorderStyleNone;
    signUpuserNametextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    signUpuserNametextfield.placeholder = @"Email Address";
    signUpuserNametextfield.backgroundColor=[UIColor clearColor];
    signUpuserNametextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    signUpuserNametextfield.keyboardType = UIKeyboardTypeEmailAddress;
    signUpuserNametextfield.returnKeyType = UIReturnKeyDone;
    signUpuserNametextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    signUpuserNametextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    signUpuserNametextfield.delegate = self;
    signUpuserNametextfield.textColor=[UIColor whiteColor];
    signUpuserNametextfield.leftViewMode=UITextFieldViewModeAlways;
    signUpuserNametextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIColor *color = [UIColor whiteColor];
    signUpuserNametextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    [signUpBackground addSubview:signUpuserNametextfield];
    
    UIView *separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:855/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-2*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
    separatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
    [signUpBackground addSubview: separatorBlackLine];
    
    
    UIImageView *passwordIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:125/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:908/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:51/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    passwordIcon.image=[UIImage imageNamed:@"ic_password.png"];
    [signUpBackground addSubview:passwordIcon];
    
    
    signUpPasswordTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:232/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-232-160)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    signUpPasswordTextfield.borderStyle = UITextBorderStyleNone;
    signUpPasswordTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    signUpPasswordTextfield.placeholder = @"Password";
    signUpPasswordTextfield.backgroundColor=[UIColor clearColor];
    signUpPasswordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    signUpPasswordTextfield.keyboardType = UIKeyboardTypeDefault;
    signUpPasswordTextfield.returnKeyType = UIReturnKeyDone;
    signUpPasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    signUpPasswordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    signUpPasswordTextfield.delegate = self;
    signUpPasswordTextfield.leftViewMode=UITextFieldViewModeAlways;
    signUpPasswordTextfield.secureTextEntry=true;
    signUpPasswordTextfield.textColor=[UIColor whiteColor];
    signUpPasswordTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    color = [UIColor whiteColor];
    signUpPasswordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    [signUpBackground addSubview:signUpPasswordTextfield];
    
    
    separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1009/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-2*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
    separatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
    [signUpBackground addSubview: separatorBlackLine];
    
    signUpButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1095/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
    signUpButton.layer.cornerRadius=signUpButton.frame.size.height/2;
    signUpButton.clipsToBounds=YES;
    [signUpButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:signUpButton.frame] forState:UIControlStateNormal];
    [signUpButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:signUpButton.frame] forState:UIControlStateHighlighted];    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(signUpButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    signUpButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [signUpBackground addSubview:signUpButton];
    
    
    UIView *signwithFaceookbackGround=[[UIView alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1405/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
    signwithFaceookbackGround.layer.cornerRadius=signwithFaceookbackGround.frame.size.height/2;
    signwithFaceookbackGround.clipsToBounds=YES;
    signwithFaceookbackGround.alpha=0.6;
    [signwithFaceookbackGround setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
    [signUpBackground addSubview:signwithFaceookbackGround];
    
    
    UIButton *signwithFaceook=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1405/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
    signwithFaceook.layer.cornerRadius=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/6 currentSuperviewDeviceSize:self.frame.size.height];
    [signwithFaceook setBackgroundColor:[UIColor clearColor]];
    [signwithFaceook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signwithFaceook setImage:[UIImage imageNamed:@"fb icon.png"] forState:UIControlStateNormal];
    [signwithFaceook setImage:[UIImage imageNamed:@"fb icon.png"] forState:UIControlStateHighlighted];
    [signwithFaceook setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:signwithFaceook.frame] forState:UIControlStateHighlighted];
    [signwithFaceook setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:145/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:753/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    signwithFaceook.layer.masksToBounds=YES;
    signwithFaceook.clipsToBounds=YES;
    [signwithFaceook setTitle:@"Sign Up with Facebook" forState:UIControlStateNormal];
    [signwithFaceook addTarget:self action:@selector(signInWithFacebookButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    signwithFaceook.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [signwithFaceook setTitleEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    [signUpBackground addSubview:signwithFaceook];

    
}

#pragma mark - Touch began

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%@",touch.view);

    [self endEditing:YES];
}

#pragma mark - Back sign up view button

-(void)bacSignUpButtonAction:(UIButton *)sender {
    
    sideNavigationButton.hidden=false;
    [self endEditing:YES];
    backImage.hidden=false;
    
    for(UIView *removeView in signUpBackground.subviews)
    {
        UIView *removeThisView=removeView;
        [removeThisView removeFromSuperview];
        removeThisView=nil;
    }
    
    [signUpBackground removeFromSuperview];
    signUpBackground=nil;
}

-(void)signUpwithDelay:(UIButton *)sender
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:signUpPasswordTextfield.text,@"password",signUpuserNametextfield.text,@"email",[NSString stringWithFormat:@"%@",APIKey],@"apiKey", nil];
    NSLog(@"postDict :%@",postDict);
    NSString *enquiryurl=[NSString stringWithFormat:@"%@user",serverAddress];
    [loginDelegate loginViewServerCallurlAppend:enquiryurl postDictionary:postDict isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];
    sender.userInteractionEnabled=true;
}


#pragma mark - Sign up sever call

- (void)signUpServerCall :(NSString *)userNameString password:(NSString *)passwordString signUpButton:(UIButton *)sender
{
    currentApiNUmber=3;
    [self endEditing:YES];
    [self performSelector:@selector(signUpwithDelay:) withObject:sender afterDelay:0.5];
    
}

#pragma mark - Sign up Button Action

-(void)signUpButtonFunction:(UIButton *)sender {
    
    NSLog(@"emailAddress=%@  password=%@",signUpuserNametextfield.text,signUpPasswordTextfield.text);
    if(![signUpuserNametextfield.text isEqualToString:@""] && [self validateEmail:signUpuserNametextfield.text])
    {
        if(![signUpPasswordTextfield.text isEqualToString:@""])
        {
//            sender.userInteractionEnabled=false;
            [[NSUserDefaults standardUserDefaults]setValue:signUpuserNametextfield.text forKey:kUserEmailId];
            [loginDelegate signUpTermsAndConditions:@"email"];
           
        }
        else
        {
            UIAlertView *alertview1=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview1 show];
        }
    }
    else
    {
        UIAlertView *alertview1=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview1 show];
    }
}

-(void)continueSignUpWithEmail
{
     [self signUpServerCall:signUpuserNametextfield.text password:signUpPasswordTextfield.text signUpButton:signUpButton];
}

#pragma mark Validate email

- (BOOL)validateEmail: (NSString *) candidate
{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9-.]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(void)loginWithDelay:(UIButton*)login
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:loginpasswordTextfield.text,@"password",loginusernameTextfield.text,@"email",[NSString stringWithFormat:@"%@",APIKey],@"apiKey", nil];
    NSLog(@"dict=%@",postDict);
    [[NSUserDefaults standardUserDefaults]setValue:loginusernameTextfield.text forKey:kUserEmailId];
    NSString *enquiryurl=[NSString stringWithFormat:@"%@user/authenticate",serverAddress];
    [loginDelegate loginViewServerCallurlAppend:enquiryurl postDictionary:postDict isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];
     login.userInteractionEnabled=true;
}

-(void)checkFirstLoginStatus:(UIButton*)login
{
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:loginpasswordTextfield.text,@"password",loginusernameTextfield.text,@"email",[NSString stringWithFormat:@"%@",APIKey],@"apiKey", nil];
    NSLog(@"dict=%@",postDict);
    [[NSUserDefaults standardUserDefaults]setValue:loginusernameTextfield.text forKey:kUserEmailId];
    NSString *enquiryurl=[NSString stringWithFormat:@"user/CheckIsthisFirstLogin"];
    [loginDelegate checkFirstSignInurlAppend:enquiryurl postDictionary:postDict isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];
    login.userInteractionEnabled=true;
}

#pragma mark - Login Button Action

-(void)loginInButtonFunction:(UIButton *)sender
{
    currentApiNUmber=1;
    
    if(![loginusernameTextfield.text isEqualToString:@""] )
    {
        if(![loginpasswordTextfield.text isEqualToString:@""])
        {
            [self endEditing:YES];
            sender.userInteractionEnabled=false;
            [self performSelector:@selector(checkFirstLoginStatus:) withObject:sender afterDelay:0.6];
        }
        else
        {
            UIAlertView *alertview1=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview1 show];
        }
    }
    else
    {
        UIAlertView *alertview1=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview1 show];
    }
}


#pragma mark - should return

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    
    return YES;
}

#pragma mark - Forgot Button Action

-(void)forgotButtonAction:(UIButton *)sender {
    
    sideNavigationButton.hidden=YES;
    [self endEditing:YES];
    backImage .hidden=true;
    
    if(!forgotBackground){
        forgotBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        forgotBackground.backgroundColor=[UIColor clearColor];
        [mainBackImage addSubview:forgotBackground];
        
        UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:140/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:989/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        logoImageView.image=[UIImage imageNamed:@"x bowling logo.png"];
        [forgotBackground addSubview:logoImageView];
        
        UIButton *bacForgotButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [bacForgotButton setBackgroundColor:[UIColor clearColor]];
        [bacForgotButton setImage:[UIImage imageNamed:@"back_login.png"] forState:UIControlStateNormal];
        [bacForgotButton setImage:[UIImage imageNamed:@"back_login_onclick.png"] forState:UIControlStateHighlighted];
        [bacForgotButton addTarget:self action:@selector(bacForgotButtonAction:) forControlEvents:UIControlEventTouchDown];
        [forgotBackground addSubview:bacForgotButton];
        
        UILabel*orLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:82/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:580/3 currentSuperviewDeviceSize:self.frame.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*82)/3 currentSuperviewDeviceSize:screenBounds.size.width] , [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:300/3 currentSuperviewDeviceSize:self.frame.size.height])];
        orLabel.textAlignment=NSTextAlignmentCenter;
        orLabel.backgroundColor=[UIColor clearColor];
        orLabel.lineBreakMode=NSLineBreakByWordWrapping;
        orLabel.numberOfLines=0;
        orLabel.backgroundColor=[UIColor clearColor];
        orLabel.textColor=[UIColor whiteColor];
        orLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:55/3 currentSuperviewDeviceSize:screenBounds.size.width]];
        orLabel.text=@"Please enter the Email Address used to register your account to get instructions for resetting your password.";
        [forgotBackground addSubview:orLabel];
        
        
        UIImageView *userIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:125/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:904/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:53/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:42/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        userIcon.image=[UIImage imageNamed:@"email.png.png"];
        [forgotBackground addSubview:userIcon];
        
        forgotTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:232/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:901/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-232-160)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        forgotTextfield.borderStyle = UITextBorderStyleNone;
        forgotTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        forgotTextfield.placeholder = @"Registered email address";
        forgotTextfield.backgroundColor=[UIColor clearColor];
        forgotTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        forgotTextfield.keyboardType = UIKeyboardTypeEmailAddress;
        forgotTextfield.returnKeyType = UIReturnKeyDone;
        forgotTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        forgotTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        forgotTextfield.delegate = self;
        forgotTextfield.textColor=[UIColor whiteColor];
        forgotTextfield.leftViewMode=UITextFieldViewModeAlways;
        forgotTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UIColor *color = [UIColor whiteColor];
        forgotTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Registered email address" attributes:@{NSForegroundColorAttributeName: color}];
        [forgotBackground addSubview:forgotTextfield];
        
        UIView *  separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1009/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width-2*[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], 1)];
        separatorBlackLine.backgroundColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0];
        [forgotBackground addSubview: separatorBlackLine];
        
        UIView *signwithFaceookbackGround=[[UIView alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1155/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        signwithFaceookbackGround.layer.cornerRadius=signwithFaceookbackGround.frame.size.height/2;
        signwithFaceookbackGround.clipsToBounds=YES;
        signwithFaceookbackGround.alpha=0.6;
        [signwithFaceookbackGround setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [forgotBackground addSubview:signwithFaceookbackGround];
        
        UIButton *resetButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:152/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1155/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-2*152)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:138/3 currentSuperviewDeviceSize:self.frame.size.height])];
        resetButton.layer.cornerRadius=resetButton.frame.size.height/2;
        resetButton.clipsToBounds=YES;
        [resetButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:resetButton.frame] forState:UIControlStateNormal];
        [resetButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:resetButton.frame] forState:UIControlStateHighlighted];
        [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resetButton setTitle:@"Reset Password" forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetPasswordButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        resetButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [forgotBackground addSubview:resetButton];
    }
    else{
        forgotTextfield.text=@"";
        forgotBackground.hidden=false;
    }
}

-(void)resetWithdelay:(UIButton *)sender
{
    currentApiNUmber=2;

    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
    NSString *siteurl = [NSString stringWithFormat:@"%@user/passwordreset",serverAddress];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    sender.userInteractionEnabled=true;
    NSDictionary *postParams=[[NSDictionary alloc]init];
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?email=%@&apiKey=%@",siteurl,forgotTextfield.text,apiKey];
    [loginDelegate loginViewServerCallurlAppend:enquiryurl postDictionary:postParams isKeyTokenAppend:NO apinumber:currentApiNUmber calltype:YES];

}

#pragma mark - Reset Button Action

- (void)resetPasswordButtonFunction:(UIButton *)sender
{
    if(![forgotTextfield.text isEqualToString:@""] )
    {
        [self endEditing:YES];
        sender.userInteractionEnabled=false;
        
        [self performSelector:@selector(resetWithdelay:) withObject:sender
                   afterDelay:0.5];
           }
    else
    {
        UIAlertView *alertView4=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView4 show];
    }
}

#pragma mark - Forgot Back button

-(void)bacForgotButtonAction :(UIButton*)sender {
    
    sideNavigationButton.hidden=false;
    [self endEditing:YES];
    backImage.hidden=false;
    forgotBackground.hidden=YES;
}

-(void)sideMenuButtonAction {
    [loginDelegate loginbackButtonAction];
}

#pragma mark - Terms & Conditions Screen
- (void)showTermsAndConditionsView
{
    
}
@end
