//
//  UserProfileView.m
//  VAFieldTest
//
//  Created by clicklabs on 1/6/15.
//
//

#import "UserProfileView.h"
#import "DataManager.h"
#import "Keys.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation UserProfileView
{
    UIImageView *backgroundImage;
    UITextField *firstNameTextfield,*lastNameTextfield,*emailTextfield,*screenNameTExtfield;
    UIImageView *userEditImageView;
    
    UIImagePickerController *imagePickerController;
    
    UIImageView *userImageView;
    UILabel*userName;
    UILabel*screenNameText;
    UILabel*centreNameText;
    UILabel *  emailText;
    
    UIImageView * profileMainbackgroundImage;
    UIView *headerwhiteBackground;
    UITextField *passwordsTextfield;
    
    int currentApiNumber;
    NSMutableDictionary *centerDictionary;
    SelectCenterView *homeCenterView;
    NSString *centreNameString;
    NSString *centreState;
    NSString *centreCountry;
}

@synthesize profileDelegate;
@synthesize profileViewController;
@synthesize profileInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"email %@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId]);
        profileMainbackgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        profileMainbackgroundImage.userInteractionEnabled=YES;
        [profileMainbackgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
        [self addSubview:profileMainbackgroundImage];
        
        UIView *headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerBlueBackground.backgroundColor=XBHeaderColor;
        [profileMainbackgroundImage addSubview:headerBlueBackground];
        
        headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
        headerwhiteBackground.backgroundColor=[UIColor clearColor];
        [self addSubview:headerwhiteBackground];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.width], headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        headerLabel.text=@"User Profile";
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.numberOfLines=2;
        headerLabel.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerwhiteBackground addSubview:headerLabel];
        
        UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake(5, headerLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
        [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
        [sideNavigationButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchDown];
        [headerwhiteBackground addSubview:sideNavigationButton];
        sideNavigationButton.userInteractionEnabled=true;
        [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

        
        UIButton *editButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        editButton.backgroundColor=[UIColor clearColor];
        editButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [editButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
        [editButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
        [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerwhiteBackground addSubview:editButton];
        
        UIImageView *backImageView;
        backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, headerwhiteBackground.frame.size.height, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:692/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        backImageView.image=[UIImage imageNamed:@"cover.png"];
        [self addSubview: backImageView];
        
        userImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        userImageView.backgroundColor=[UIColor redColor];
        userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
        userImageView.layer.masksToBounds=YES;
        userImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        userImageView.layer.borderWidth=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5 currentSuperviewDeviceSize:screenBounds.size.height];
        userImageView.image=[UIImage imageNamed:@"profile_img.png"];
        
        userImageView.userInteractionEnabled=true;
        [backImageView addSubview:userImageView];
        
        userName=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:303/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-333)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(282-60)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        userName.textAlignment=NSTextAlignmentCenter;
        userName.backgroundColor=[UIColor clearColor];
        userName.textAlignment=NSTextAlignmentLeft;
        userName.lineBreakMode=NSLineBreakByWordWrapping;
        userName.numberOfLines=0;
        userName.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        userName.textColor=[UIColor whiteColor];
        [backImageView addSubview:userName];
        
        UILabel*emailHeader=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        emailHeader.textAlignment=NSTextAlignmentLeft;
        emailHeader.backgroundColor=[UIColor clearColor];
        emailHeader.lineBreakMode=NSLineBreakByWordWrapping;
        emailHeader.numberOfLines=0;
        emailHeader.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
        emailHeader.text=@"Email";
        emailHeader.textColor=[UIColor whiteColor];
        [backImageView addSubview:emailHeader];
        
        emailText=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],emailHeader.frame.origin.y+emailHeader.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:6/3 currentSuperviewDeviceSize:screenBounds.size.height], screenBounds.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:90/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        emailText.textAlignment=NSTextAlignmentLeft;
        emailText.backgroundColor=[UIColor clearColor];
        emailText.lineBreakMode=NSLineBreakByWordWrapping;
        emailText.numberOfLines=0;
        emailText.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]];
        if([[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId]==nil||[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId]==[NSNull null]||[[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId]isEqualToString:@""])
        {
            emailText.text=@"";
        }
        else{
            emailText.text=[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailId];
        }
        emailText.textColor=[UIColor whiteColor];
        [backImageView addSubview:emailText];
        //
        
        UIView *separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake(emailText.frame.origin.x, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:screenBounds.size.height], SCREEN_WIDTH-emailText.frame.origin.x, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:3/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        separatorBlackLine.backgroundColor=[UIColor lightGrayColor];
        [backImageView addSubview: separatorBlackLine];
        
        
        UILabel*screenHeader=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:500/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        screenHeader.textAlignment=NSTextAlignmentLeft;
        screenHeader.backgroundColor=[UIColor clearColor];
        screenHeader.lineBreakMode=NSLineBreakByWordWrapping;
        screenHeader.numberOfLines=0;
        screenHeader.textColor=[UIColor whiteColor];
        screenHeader.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
        screenHeader.text=@"Screen Name";
        [backImageView addSubview:screenHeader];
        
        screenNameText=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],screenHeader.frame.origin.y+screenHeader.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:0 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-120)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:105/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        screenNameText.textAlignment=NSTextAlignmentLeft;
        screenNameText.backgroundColor=[UIColor clearColor];
        screenNameText.lineBreakMode=NSLineBreakByWordWrapping;
        screenNameText.numberOfLines=0;
        screenNameText.textColor=[UIColor whiteColor];
        screenNameText.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]];
        screenNameText.text=@"";
        [backImageView addSubview:screenNameText];
        
        UIView *centreHeaderBackground=[[UIView alloc]initWithFrame:CGRectMake(0, backImageView.frame.origin.y+backImageView.frame.size.height, SCREEN_WIDTH,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        centreHeaderBackground.backgroundColor=[UIColor blackColor];
        centreHeaderBackground.alpha=0.5;
        [profileMainbackgroundImage addSubview: centreHeaderBackground];
        
        
        UILabel*homeCentreHeader=[[UILabel alloc]initWithFrame:CGRectMake(20, backImageView.frame.origin.y+backImageView.frame.size.height, 100, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        homeCentreHeader.textAlignment=NSTextAlignmentLeft;
        homeCentreHeader.backgroundColor=[UIColor clearColor];
        homeCentreHeader.lineBreakMode=NSLineBreakByWordWrapping;
        homeCentreHeader.numberOfLines=0;
        homeCentreHeader.textColor=[UIColor whiteColor];
        homeCentreHeader.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
        homeCentreHeader.text=@"Home Center";
        [profileMainbackgroundImage addSubview:homeCentreHeader];
        
        
        UIView *centreBackground=[[UIView alloc]initWithFrame:CGRectMake(-2, centreHeaderBackground.frame.origin.y+centreHeaderBackground.frame.size.height, SCREEN_WIDTH+4, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        centreBackground.layer.borderColor=XBlightGraySeparatorLineColor.CGColor;
        centreBackground.layer.borderWidth=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5 currentSuperviewDeviceSize:screenBounds.size.height];
        [profileMainbackgroundImage addSubview:centreBackground];
        
        centreNameText=[[UILabel alloc]initWithFrame:CGRectMake(20, homeCentreHeader.frame.origin.y+homeCentreHeader.frame.size.height+5, SCREEN_WIDTH-40, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        centreNameText.textAlignment=NSTextAlignmentLeft;
        centreNameText.backgroundColor=[UIColor clearColor];
        centreNameText.lineBreakMode=NSLineBreakByWordWrapping;
        centreNameText.numberOfLines=0;
        centreNameText.textColor=[UIColor whiteColor];
        centreNameText.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]];
        centreNameText.text=@"";
        [profileMainbackgroundImage addSubview:centreNameText];
        
        
        UIButton *changePasswordButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-880)/6 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1951/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:880/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
        changePasswordButton.layer.cornerRadius=changePasswordButton.frame.size.height/2;
        changePasswordButton.clipsToBounds=YES;
        [changePasswordButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]];
        [changePasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changePasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [changePasswordButton setTitle:@"Change Password" forState:UIControlStateNormal];
        [changePasswordButton addTarget:self action:@selector(changePasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
        changePasswordButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [changePasswordButton setTitleEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:35/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:25/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width])];
        [changePasswordButton setBackgroundImage:[[DataManager shared] setColor:XBBlueButtonBackgndHighlightedState buttonframe:changePasswordButton.frame] forState:UIControlStateHighlighted];
        
        [profileMainbackgroundImage addSubview:changePasswordButton];
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:KIsFacebookLogin])
        {
            changePasswordButton.hidden=true;
        }
        
    }
    return self;
}

#pragma mark - selected home center
- (void)selectedHomeCenter:(NSDictionary *)centerDict updated:(BOOL)boolValue
{
//    if ([centerDict isKindOfClass:[NSDictionary class]] && boolValue == YES) {
//        if ([[centerDict allKeys] count] == 2) {
//            centreNameText.attributedText=[[NSMutableAttributedString alloc] initWithString:@"You have not added any Home Center yet."];
//            return;
//        }
//    }
    
    centerDictionary=[[NSMutableDictionary alloc]initWithDictionary:centerDict];
   
    if ([centerDictionary isKindOfClass:[NSMutableDictionary class]] && centerDictionary.count > 0) {
        if (boolValue == NO) {
            centreNameString=[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"name"]];
            centreState=[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"longName"]];;
            centreCountry=[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"countryCode"]];
        }
        else
        {
            centreNameString=[NSString stringWithFormat:@"%@",[centerDictionary objectForKey:@"name"]];
            centreState=[NSString stringWithFormat:@"%@",[[[centerDictionary objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"longName"]];
            centreCountry=[NSString stringWithFormat:@"%@",[[[centerDictionary objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"countryCode"]];
        }
        
    }
    else
    {
        centreNameString=@"Select Home Center";
        centreState=@"";
        centreCountry=@"";
    }
    NSMutableAttributedString *string;
    if ([centerDictionary isKindOfClass:[NSMutableDictionary class]] && centerDictionary.count > 0) {
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@,%@",centreNameString,centreState,centreCountry]];
    }
    else
    {
        string=[[NSMutableAttributedString alloc] initWithString:@"Select Home Center"];
    }
    
    
    [string beginEditing];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]]
                   range:NSMakeRange(0, [centreNameString length])];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                   range:NSMakeRange([[NSString stringWithFormat:@"%@ \n",centreNameString] length],  [centreState length])];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                   range:NSMakeRange([[NSString stringWithFormat:@"%@ \n%@,",centreNameString,centreState]length], [centreCountry length])];
    [string endEditing];
    
    if ([centreNameString isEqualToString:@"(null)"] || [centreState isEqualToString:@"(null)"]) {
        string=[[NSMutableAttributedString alloc] initWithString:@"You have not selected any home center yet."];
    }
    centreNameText.attributedText=string ;

}

#pragma mark - Load user profile view
- (void)loadViewWithCenterSelectionView:(SelectCenterView *)centerView
{
    homeCenterView=(SelectCenterView *)centerView;
    if(![[self.profileInfo objectForKey:@"pictureFile"]isKindOfClass:[NSNull class]]&&[self.profileInfo objectForKey:@"pictureFile"]!=nil&&[self.profileInfo objectForKey:@"pictureFile"]!=[NSNull null])
    {
        [userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.profileInfo objectForKey:@"pictureFile"]objectForKey:@"fileUrl"]]] placeholderImage:[UIImage imageNamed:@"profile_img.png"]];
    }
    
    if(![[self.profileInfo objectForKey:@"firstName"]isKindOfClass:[NSNull class]]&&[self.profileInfo objectForKey:@"firstName"]!=nil&&[self.profileInfo objectForKey:@"firstName"]!=[NSNull null])
    {
        userName.text=[NSString stringWithFormat:@"%@ %@",[self.profileInfo objectForKey:@"firstName"],[self.profileInfo objectForKey:@"lastName"]];
    }
    else
    {
        userName.text=@"";
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:KIsFacebookLogin])
    {
        if(![[self.profileInfo objectForKey:@"firstName"]isKindOfClass:[NSNull class]]&&[self.profileInfo objectForKey:@"firstName"]!=nil&&[self.profileInfo objectForKey:@"firstName"]!=[NSNull null])
        {
             userName.text=[NSString stringWithFormat:@"%@ %@",[self.profileInfo objectForKey:@"firstName"],[self.profileInfo objectForKey:@"lastName"]];
        }
        else
        {
            if (![[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:facebookFirstName] ] isEqualToString:@"(null)"]) {
                userName.text=[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]objectForKey:facebookFirstName],[[NSUserDefaults standardUserDefaults]objectForKey:facebooklastname]];
            }
        
        }
    }
    
    emailText.text=[self.profileInfo objectForKey:@"email"];
    NSString *screenString;
    if(![[self.profileInfo objectForKey:@"screenName"]isKindOfClass:[NSNull class]]&&[self.profileInfo objectForKey:@"screenName"]!=nil&&[self.profileInfo objectForKey:@"screenName"]!=[NSNull null])
    {
        screenString=[self.profileInfo objectForKey:@"screenName"];
    }
    else
    {
        screenString=@"";
    }
    
    screenNameText.text=screenString;
    [[NSUserDefaults standardUserDefaults]setValue:screenNameText.text forKey:kuserName];
   
    NSMutableAttributedString *string;
    if ([centerDictionary isKindOfClass:[NSMutableDictionary class]] && centerDictionary.count > 0) {
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@,%@",centreNameString,centreState,centreCountry]];
    }
    else
    {
        string=[[NSMutableAttributedString alloc] initWithString:@"Select Home Center"];
    }

    [string beginEditing];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]]
                   range:NSMakeRange(0, [centreNameString length])];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                   range:NSMakeRange([[NSString stringWithFormat:@"%@ \n",centreNameString] length],  [centreState length])];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                   range:NSMakeRange([[NSString stringWithFormat:@"%@ \n%@,",centreNameString,centreState]length], [centreCountry length])];
    [string endEditing];
    
    centreNameText.attributedText=string ;
}

#pragma mark - Password screen button action

- (void)donePasswordButtonAction:(UIButton *)sender {
    
    UITextField *oldPassword=(UITextField *)[backgroundImage viewWithTag:500];
    UITextField *newPassword=(UITextField *)[backgroundImage viewWithTag:501];
    UITextField *confirmPassword=(UITextField *)[backgroundImage viewWithTag:502];
    NSString *alertMessage;
    if(oldPassword.text.length == 0 || newPassword.text.length == 0)
    {
        alertMessage=@"Please fill all the fields.";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(![newPassword.text isEqualToString:confirmPassword.text])
    {
        alertMessage=@"Your passwords do not match.";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [self endEditing:YES];
        sender.userInteractionEnabled=false;
        [self performSelector:@selector(changePasswordDelay:) withObject:sender afterDelay:0.5];
    }
}

-(void)changePasswordDelay:(UIButton *)sender
{
    UITextField *oldPassword=(UITextField *)[backgroundImage viewWithTag:500];
    UITextField *newPassword=(UITextField *)[backgroundImage viewWithTag:501];
    
    sender.userInteractionEnabled=true;
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:oldPassword.text,@"oldPassword",newPassword.text,@"newPassword", nil];
    
    currentApiNumber=1;
    NSString *siteurl = [NSString stringWithFormat:@"user/current/password"];
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    [profileDelegate serverCallMethodurlAppend:siteurl postDictionary:postDict isKeyTokenAppend:YES apinumber:1];
}

-(void)cancelChangePasswordButtonAction{
    
    for(UIView *removeView in backgroundImage.subviews)
    {
        UIView *removeThisView=removeView;
        [removeThisView removeFromSuperview];
        removeThisView=nil;
    }
    
    [backgroundImage removeFromSuperview];
    backgroundImage=nil;
}

#pragma mark - Change Password View

-(void)changePasswordButtonAction {
    
    [backgroundImage removeFromSuperview];
    backgroundImage=nil;
    
    backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
    backgroundImage.userInteractionEnabled=YES;
    [self addSubview:backgroundImage];
    
    UIView *headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
    headerBlueBackground.backgroundColor=XBHeaderColor;
    [backgroundImage addSubview:headerBlueBackground];
    
    headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
    headerwhiteBackground.backgroundColor=[UIColor clearColor];
    [backgroundImage addSubview:headerwhiteBackground];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.width], headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    headerLabel.text=@"Change Password";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.numberOfLines=2;
    headerLabel.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerwhiteBackground addSubview:headerLabel];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cancelButton.backgroundColor=[UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.userInteractionEnabled=YES;
    [cancelButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelChangePasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerwhiteBackground addSubview:cancelButton];
    
    UIButton *doneButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    doneButton.backgroundColor=[UIColor clearColor];
    doneButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [doneButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(donePasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerwhiteBackground addSubview:doneButton];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:27/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, 1)];
    separatorLine.backgroundColor=XBlightGraySeparatorLineColor;
    [backgroundImage addSubview:separatorLine];
    
    
    UIView *blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(190*3)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    blueBackground.backgroundColor=[UIColor blackColor];
    blueBackground.alpha=0.3;
    [backgroundImage addSubview:blueBackground];
    
    UIView *namesBackgroundView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(190*3)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    namesBackgroundView.backgroundColor=[UIColor clearColor];
    [backgroundImage addSubview:namesBackgroundView];
    
    float ycordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:31/3 currentSuperviewDeviceSize:screenBounds.size.height];
    
    
    NSArray *labelTextArray=[[NSArray alloc]initWithObjects:@"Current Password",@"New Password",@"Confirm Password", nil];
    
    for(int i=0;i<3;i++)
    {
        UILabel *firstName=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],ycordinate , namesBackgroundView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [firstName setBackgroundColor:[UIColor clearColor]];
        firstName.text=[[ labelTextArray objectAtIndex:i] uppercaseString];
        firstName.textColor=[UIColor whiteColor];
        firstName.textAlignment=NSTextAlignmentLeft;
        firstName.numberOfLines=2;
        firstName.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
        [namesBackgroundView addSubview:firstName];
        ycordinate=ycordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(190)/3 currentSuperviewDeviceSize:screenBounds.size.height];
        
        separatorLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],ycordinate-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:36/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, 1)];
        separatorLine.backgroundColor=XBlightGraySeparatorLineColor;
        [namesBackgroundView addSubview:separatorLine];
        
        
        passwordsTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width],firstName.frame.origin.y+firstName.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], namesBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width]-8, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:63/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        passwordsTextfield.borderStyle = UITextBorderStyleNone;
        passwordsTextfield.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
        //passwordsTextfield.text = [[userName.text componentsSeparatedByString:@" " ]objectAtIndex:0];
        passwordsTextfield.backgroundColor=[UIColor clearColor];
        passwordsTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        passwordsTextfield.keyboardType = UIKeyboardTypeEmailAddress;
        passwordsTextfield.tag=500+i;
        passwordsTextfield.returnKeyType = UIReturnKeyDone;
        passwordsTextfield.textColor=[UIColor whiteColor];
        
        passwordsTextfield.delegate=self;
        passwordsTextfield.secureTextEntry=YES;
        passwordsTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        passwordsTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwordsTextfield.leftViewMode=UITextFieldViewModeAlways;
        UIColor *color = [UIColor lightGrayColor];
        passwordsTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"oooooooooooo" attributes:@{NSForegroundColorAttributeName: color}];
        passwordsTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [namesBackgroundView addSubview:passwordsTextfield];
        
    }
}

#pragma mark - menu Button Action

- (void)sideMenuButtonAction {
    
    [profileDelegate backButtonAction];
    
}

#pragma mark - Edit Profile View Create

-(void)editButtonAction:(UIButton *)sender
{
    
    backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:@"mainbackground.png"]];
    backgroundImage.userInteractionEnabled=YES;
    [self addSubview:backgroundImage];
    
    
    UIView *headerBlueBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
    headerBlueBackground.backgroundColor=XBHeaderColor;
    [backgroundImage addSubview:headerBlueBackground];
    
    
    headerwhiteBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:237/3 currentSuperviewDeviceSize:self.frame.size.height])];
    headerwhiteBackground.backgroundColor=[UIColor clearColor];
    [backgroundImage addSubview:headerwhiteBackground];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.width], headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    headerLabel.text=@"Edit Profile";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.numberOfLines=2;
    headerLabel.font=[UIFont fontWithName:AvenirDemi size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerwhiteBackground addSubview:headerLabel];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:260/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cancelButton.backgroundColor=[UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.userInteractionEnabled=YES;
    [cancelButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelEditButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerwhiteBackground addSubview:cancelButton];
    
    UIButton *doneButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:24/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height- [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    doneButton.backgroundColor=[UIColor clearColor];
    doneButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [doneButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerwhiteBackground addSubview:doneButton];
    
    
    userEditImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], headerwhiteBackground.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:39/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    userEditImageView.backgroundColor=[UIColor clearColor];
    userEditImageView.layer.cornerRadius=userEditImageView.frame.size.width/2;
    userEditImageView.layer.masksToBounds=YES;
    userEditImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    userEditImageView.layer.borderWidth=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5 currentSuperviewDeviceSize:screenBounds.size.height];
    userEditImageView.image=userImageView.image;;
    userEditImageView.userInteractionEnabled=true;
    [backgroundImage addSubview:userEditImageView];
    
    
    UIButton *editPhotoButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:507/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:190/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    editPhotoButton.backgroundColor=[UIColor clearColor];
    editPhotoButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [editPhotoButton setTitle:@" Edit \nPhoto" forState:UIControlStateNormal];
    editPhotoButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [editPhotoButton setTitleColor:XBBlueTitleButtonNormalStateColor forState:UIControlStateNormal];
    [editPhotoButton setTitleColor:XBBlueTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [editPhotoButton addTarget:self action:@selector(editPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImage addSubview:editPhotoButton];
    
    UIView *blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:303/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-333)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(380)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    blueBackground.backgroundColor=[UIColor blackColor];
    blueBackground.alpha=0.3;
    [backgroundImage addSubview:blueBackground];
    
    UIView *namesBackgroundView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:303/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(1242-333)/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(380)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    namesBackgroundView.backgroundColor=[UIColor clearColor];
    [backgroundImage addSubview:namesBackgroundView];
    
    
    UILabel *firstName=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:31/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [firstName setBackgroundColor:[UIColor clearColor]];
    firstName.text=[@"First NAME" uppercaseString];
    firstName.textColor=[UIColor whiteColor];
    firstName.textAlignment=NSTextAlignmentLeft;
    firstName.numberOfLines=2;
    firstName.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    [namesBackgroundView addSubview:firstName];
    
    
    firstNameTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width],firstName.frame.origin.y+firstName.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], namesBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width]-8, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    firstNameTextfield.borderStyle = UITextBorderStyleNone;
    firstNameTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    
    firstNameTextfield.backgroundColor=[UIColor clearColor];
    firstNameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    firstNameTextfield.returnKeyType = UIReturnKeyDone;
    firstNameTextfield.textColor=[UIColor whiteColor];
    firstNameTextfield.delegate=self;
    firstNameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstNameTextfield.leftViewMode=UITextFieldViewModeAlways;
    firstNameTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [namesBackgroundView addSubview:firstNameTextfield];
    
    UIView *separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:186/3 currentSuperviewDeviceSize:screenBounds.size.height], namesBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    separatorBlackLine.backgroundColor=[UIColor lightGrayColor];
    [namesBackgroundView addSubview: separatorBlackLine];
    
    UILabel *lastName=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:215/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], firstName.frame.size.height)];
    [lastName setBackgroundColor:[UIColor clearColor]];
    lastName.text=[@"LAST NAME" uppercaseString];
    lastName.textColor=[UIColor whiteColor];
    lastName.textAlignment=NSTextAlignmentLeft;
    lastName.numberOfLines=2;
    lastName.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    [namesBackgroundView addSubview:lastName];
    
    
    lastNameTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width],lastName.frame.origin.y+lastName.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], firstNameTextfield.frame.size.width, firstNameTextfield.frame.size.height)];
    lastNameTextfield.borderStyle = UITextBorderStyleNone;
    lastNameTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];

    lastNameTextfield.delegate=self;
    lastNameTextfield.backgroundColor=[UIColor clearColor];
    lastNameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    lastNameTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    lastNameTextfield.returnKeyType = UIReturnKeyDone;
    lastNameTextfield.textColor=[UIColor whiteColor];
    lastNameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastNameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lastNameTextfield.leftViewMode=UITextFieldViewModeAlways;
    lastNameTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [namesBackgroundView addSubview:lastNameTextfield];
    
        if([[userName.text componentsSeparatedByString:@" " ]count]>0)
        {
          firstNameTextfield.text = [[userName.text componentsSeparatedByString:@" " ]objectAtIndex:0];
        }
          if([[userName.text componentsSeparatedByString:@" " ]count]>1)
          {
          lastNameTextfield.text = [[userName.text componentsSeparatedByString:@" " ]objectAtIndex:1];
          }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:KIsFacebookLogin])
           {
           }
    
    blueBackground=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:screenBounds.size.height], SCREEN_WIDTH, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(190)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    blueBackground.backgroundColor=[UIColor blackColor];
    blueBackground.alpha=0.3;
    [backgroundImage addSubview:blueBackground];
    
    
    UIView *screensBackgroundView=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:0/3 currentSuperviewDeviceSize:screenBounds.size.width],headerwhiteBackground.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:460/3 currentSuperviewDeviceSize:screenBounds.size.height], SCREEN_WIDTH, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(190)/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    screensBackgroundView.backgroundColor=[UIColor clearColor];
    [backgroundImage addSubview:screensBackgroundView];
    
    
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:36/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    emailLabel.text=[@"email" uppercaseString];
    emailLabel.textColor=[UIColor whiteColor];
    emailLabel.textAlignment=NSTextAlignmentLeft;
    emailLabel.numberOfLines=2;
    emailLabel.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    //headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:23.3];
    //[screensBackgroundView addSubview:emailLabel];
    
    emailTextfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width],emailLabel.frame.origin.y+emailLabel.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], namesBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width]-8, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:63/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    emailTextfield.borderStyle = UITextBorderStyleNone;
    emailTextfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    emailTextfield.text = @"John";
    emailTextfield.backgroundColor=[UIColor clearColor];
    emailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextfield.returnKeyType = UIReturnKeyDone;
    emailTextfield.textColor=[UIColor whiteColor];
    emailTextfield.delegate=self;
    emailTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextfield.leftViewMode=UITextFieldViewModeAlways;
    emailTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // [screensBackgroundView addSubview:emailTextfield];
    
    separatorBlackLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:186/3 currentSuperviewDeviceSize:screenBounds.size.height], namesBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:1.5/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    separatorBlackLine.backgroundColor=XBlightGraySeparatorLineColor;
    // [screensBackgroundView addSubview: separatorBlackLine];
    
    
    UILabel* screenNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:31/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1242/3 currentSuperviewDeviceSize:screenBounds.size.width]-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [screenNameLabel setBackgroundColor:[UIColor clearColor]];
    screenNameLabel.text=[@"Screen NAME" uppercaseString];
    screenNameLabel.textColor=[UIColor whiteColor];
    screenNameLabel.textAlignment=NSTextAlignmentLeft;
    screenNameLabel.numberOfLines=2;
    screenNameLabel.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    //    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:23.3];
    [screensBackgroundView addSubview:screenNameLabel];
    
    
    screenNameTExtfield = [[UITextField alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width],emailLabel.frame.origin.y+emailLabel.frame.size.height+ [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15/3 currentSuperviewDeviceSize:screenBounds.size.height], screensBackgroundView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:66/3 currentSuperviewDeviceSize:screenBounds.size.width]-8, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    screenNameTExtfield.borderStyle = UITextBorderStyleNone;
    screenNameTExtfield.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    screenNameTExtfield.placeholder = @"James";
    screenNameTExtfield.text = screenNameText.text;
    screenNameTExtfield.delegate=self;
    screenNameTExtfield.backgroundColor=[UIColor clearColor];
    screenNameTExtfield.autocorrectionType = UITextAutocorrectionTypeNo;
    screenNameTExtfield.keyboardType = UIKeyboardTypeEmailAddress;
    screenNameTExtfield.returnKeyType = UIReturnKeyDone;
    screenNameTExtfield.textColor=[UIColor whiteColor];
    screenNameTExtfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    screenNameTExtfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    screenNameTExtfield.leftViewMode=UITextFieldViewModeAlways;
    screenNameTExtfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [screensBackgroundView addSubview:screenNameTExtfield];
    
    
    UIView *centreHeaderBackground=[[UIView alloc]initWithFrame:CGRectMake(0, screensBackgroundView.frame.origin.y+screensBackgroundView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], SCREEN_WIDTH,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    centreHeaderBackground.backgroundColor=[UIColor blackColor];
    centreHeaderBackground.alpha=0.8;
    [backgroundImage addSubview: centreHeaderBackground];
    
    
    UILabel *homeCentreHeader=[[UILabel alloc]initWithFrame:CGRectMake(20, screensBackgroundView.frame.origin.y+screensBackgroundView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], 100, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:85/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    homeCentreHeader.textAlignment=NSTextAlignmentLeft;
    homeCentreHeader.backgroundColor=[UIColor clearColor];
    homeCentreHeader.lineBreakMode=NSLineBreakByWordWrapping;
    homeCentreHeader.numberOfLines=0;
    homeCentreHeader.textColor=[UIColor whiteColor];
    homeCentreHeader.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    homeCentreHeader.text=@"Home Center";
    [backgroundImage addSubview:homeCentreHeader];
    
    homeCenterView.frame=CGRectMake(0, homeCentreHeader.frame.size.height+homeCentreHeader.frame.origin.y, screenBounds.size.width, homeCenterView.frame.size.height);
//    [homeCenterView createView];
    [backgroundImage addSubview:homeCenterView];
}

#pragma mark - Alert click Button Action

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1) {
        NSLog(@"Button tag:%ld",(long)buttonIndex);
        imagePickerController=nil;
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing=NO;
        imagePickerController.navigationBarHidden=NO;
        if (buttonIndex==1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                [self.profileViewController presentViewController:imagePickerController animated:YES completion:Nil];
            }
            else {
                
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not open photo gallary" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
                [alert show];
            }
        }
        else if(buttonIndex==2)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self.profileViewController presentViewController:imagePickerController animated:NO completion:Nil];
            }
            else {
                UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Device does not supprot camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
                [alert show];
            }
        }
        else if (buttonIndex==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

#pragma mark - Edit User Photo Button Action

-(void)editPhotoButtonAction:(UIButton *)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Add Photo" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles: @"Gallery",@"Camera",nil];
    [alert show];
    alert.tag=1;
}

#pragma mark - Textfield Should change

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
}

#pragma mark - Textfield Should Return

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)updateProfileParameters
{
    userName.text=[NSString stringWithFormat:@"%@ %@",firstNameTextfield.text,lastNameTextfield.text];
    
    [[NSUserDefaults standardUserDefaults]setObject:firstNameTextfield.text forKey:facebookFirstName];
    [[NSUserDefaults standardUserDefaults]setObject:lastNameTextfield.text forKey:facebooklastname];
    screenNameText.text=screenNameTExtfield.text;
    userImageView.image=userEditImageView.image;
}


#pragma mark - Touch began

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}


#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,100, 100)];
    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    userEditImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height), YES, 3.0);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    userEditImageView.image=im;
    UIGraphicsEndImageContext();
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Done API

-(void)doneApiDelay:(UIButton *)sender
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    
    sender.userInteractionEnabled=true;
    UIImageView *compresseImageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    compresseImageview.image=userEditImageView.image;
    
    UIImage *renderedImage=[[DataManager shared]imageOfView:compresseImageview];
    NSString *baseURLString= [UIImagePNGRepresentation(renderedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *imageBaseUrlDict=[[NSDictionary alloc]initWithObjectsAndKeys:baseURLString,@"content", nil];
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:emailText.text,@"email",screenNameTExtfield.text,@"screenName",imageBaseUrlDict,@"base64Picture",firstNameTextfield.text,@"firstName",lastNameTextfield.text,@"lastName", nil];
    
    currentApiNumber=0;
    NSString *urlAppend=[NSString stringWithFormat:@"%@",@"userprofile"];
    [profileDelegate serverCallMethodurlAppend:urlAppend postDictionary:postDict isKeyTokenAppend:YES apinumber:0];
    
    if(centerDictionary.count > 0)
    {
        [self setHomeCenter];
    }
}


#pragma mark - Done Edittin Button Action

-(void)doneEditButtonAction: (UIButton *)sender
{
    if([firstNameTextfield.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please enter first name first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if([lastNameTextfield.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please enter last name first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if([screenNameTExtfield.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please enter screen name first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if([emailText.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Invalid Email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        sender.userInteractionEnabled=false;
        [self endEditing:YES];
        
        [self performSelector:@selector(doneApiDelay:) withObject:sender
                   afterDelay:0.5];
            }
}

- (void)setHomeCenter
{
    NSDictionary *json = [[ServerCalls instance] serverCallWithQueryParameters:[NSString stringWithFormat:@"VenueId=%@&",[centerDictionary objectForKey:@"id"]] url:@"MyCenter" contentType:@"" httpMethod:@"POST"];
    NSDictionary *response=[json objectForKey:kResponseString];
    NSLog(@"responseDict=%@",response);
    if([[json objectForKey:kResponseStatusCode] intValue] == 200)
    {
        NSMutableAttributedString *string;

        if ([centerDictionary isKindOfClass:[NSMutableDictionary class]] && centerDictionary.count > 0) {
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@,%@",centreNameString,centreState,centreCountry]];
        }
        else
        {
            string=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",centreNameString]];
        }
        [string beginEditing];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.width]]
                       range:NSMakeRange(0, [centreNameString length])];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                       range:NSMakeRange([[NSString stringWithFormat:@"%@ \n",centreNameString] length],  [centreState length])];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:AvenirRegular size:XbH3size]
                       range:NSMakeRange([[NSString stringWithFormat:@"%@ \n%@,",centreNameString,centreState]length], [centreCountry length])];
        [string endEditing];
        
        
        centreNameText.attributedText=string ;
    }
}

#pragma mark - Cancel Edit Button Action

-(void)cancelEditButtonAction
{
    for(UIView *removeView in backgroundImage.subviews)
    {
        UIView *removeThisView=removeView;
        [removeThisView removeFromSuperview];
        removeThisView=nil;
    }
    
    [backgroundImage removeFromSuperview];
    backgroundImage=nil;
}



@end
