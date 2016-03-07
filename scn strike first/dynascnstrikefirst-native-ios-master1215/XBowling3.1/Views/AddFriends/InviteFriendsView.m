//
//  tellAFriendView.m
//  XBowling 3.0
//
//  Created by Click Labs on 4/22/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "InviteFriendsView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

#ifdef DEBUG
#   define TWDLog(fmt, ...) NSLog((@"\n%s\n" fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define TWDLog(...)
#endif

#define TWALog(fmt, ...) NSLog((@"\n%s\n" fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)

@implementation InviteFriendsView
{
    UIImageView*popUpImgView;
    UIImageView*popUpImgView1;  //for contacts screen
    UIView *clearColorview;
    UITextView *mailContactsLabel;
    NSMutableArray *allEmails;
    UIImageView *emailPreviewView;
    UIImageView *contactListView;
     NSMutableArray *comparisonItemselectArray;
    id<GAITracker> tracker;
    
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.accountStore = [[ACAccountStore alloc] init];
        _apiManager = [[TWAPIManager alloc] init];
        tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Invite Friends"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
        
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
        headerLabel.text=@"Share";
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        float scrollviewheight;
        scrollviewheight=self.frame.size.height-(headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        //uiscrollview containing buttons
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, scrollviewheight)];
        scrollView.userInteractionEnabled = YES;
        scrollView.backgroundColor=[UIColor clearColor];
        [self addSubview:scrollView];
        
        //height for first button
        float ycoordinateForButtons;
        ycoordinateForButtons=5;
        
        NSArray *shareBtnImgsArray=[[NSArray alloc]initWithObjects:@"via_email_off.png",@"via_email_on.png",@"via_fb_off.png",@"via_fb_on.png",@"via_tw_off.png",@"via_tw_on.png",nil];
        
        NSArray *LabelTextArray=[[NSArray alloc]initWithObjects:@"Email your friends - If your friends signs up using their email address, you get 10 credits!",@"Post to Facebook - Get 5 credits per Facebook message, for up to 30 credits per month!",@"Send a Tweet - Get 5 credits per each Twitter message, for up to 30 credits per month!", nil];
        UIButton *cancelButton;
        int shareImageCount =0;
        for(int i=0;i < 3; i++)
        {
            cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.tag=7500+i;
            [cancelButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[shareBtnImgsArray objectAtIndex:shareImageCount]]] forState:UIControlStateNormal];
            shareImageCount++;
            [cancelButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[shareBtnImgsArray objectAtIndex:shareImageCount]]] forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(cancelButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:cancelButton];
            
            shareImageCount++;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];
            paragraphStyle.alignment=NSTextAlignmentCenter;
            UILabel *shareLabel=[[UILabel alloc]init];
            shareLabel.textAlignment=NSTextAlignmentCenter;
            shareLabel.textColor=[UIColor whiteColor];
            shareLabel.lineBreakMode=NSLineBreakByWordWrapping;
            shareLabel.numberOfLines=4;
            NSMutableAttributedString *subjectString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[LabelTextArray objectAtIndex:i]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH1size]}];
            [subjectString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subjectString length])];
            shareLabel.attributedText=subjectString;
            [scrollView addSubview:shareLabel];
            if (self.frame.size.width==480) {
                cancelButton.frame=CGRectMake(60,ycoordinateForButtons, 554/2, 78/2);
            }
            else{
                cancelButton.frame=CGRectMake(100,ycoordinateForButtons, 554/2, 78/2);
                
            }
            cancelButton.center=CGPointMake(self.center.x, cancelButton.center.y);
            shareLabel.frame=CGRectMake(20, cancelButton.frame.origin.y+cancelButton.frame.size.height + 10,scrollView.frame.size.width - 40,80);
            
            ycoordinateForButtons=shareLabel.frame.size.height + shareLabel.frame.origin.y + 10;
            
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,ycoordinateForButtons);
    }
    return self;
}

-(void)cancelSelection:(UIButton *)sender
{
    [sender removeFromSuperview];
    [clearColorview removeFromSuperview];
    [popUpImgView removeFromSuperview];
    clearColorview=nil;
    popUpImgView=nil;
    [self removeFromSuperview];
    
}

-(void)removeContactListView
{
    [contactListView removeFromSuperview];
    
}

-(void)removeInternalPopup
{
    [popUpImgView removeFromSuperview];
    popUpImgView=nil;
    
}

-(void)cancelButtonFunction:(UIButton *)sender
{
    int index=(int)(sender.tag - 7500);
    if(index == 0)
    {
        //email
//        Reachability *reach = [Reachability reachabilityForInternetConnection];
//        NetworkStatus netStatus = [reach currentReachabilityStatus];
//        if (netStatus == NotReachable)
//        {
//            [[DataManager shared]removeActivityIndicator];
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alertView show];
//        }
//        else
//        {
//        }
        [self emailButtonFunction];
    }
    else if(index == 1)
    {
        //fb
        UIAlertView *fbalert=[[UIAlertView alloc]initWithTitle:@"Post to Facebook" message:@"I am really enjoying my XBowling experience! If you have not downloaded or activated your XBowling App, what are you waiting for? I am ready to challenge you to a friendly game of bowling." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        fbalert.tag=8888;
        [fbalert show];
        
    }
    else
    {
        //twitter
        UIAlertView *twitteralert=[[UIAlertView alloc]initWithTitle:@"Post to Twitter" message:@"I'm really enjoying my XBowling experience! Have you downloaded your XBowling App yet? I'm ready to bowl against you!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        twitteralert.tag=8889;
        [twitteralert show];
    }
}

- (void)emailButtonFunction
{
    emailPreviewView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)];
    //  popUpImgView.center = self .center;
    emailPreviewView.image = [UIImage imageNamed:@"bg.png"];
    emailPreviewView.userInteractionEnabled = YES;
    [self addSubview: emailPreviewView];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [emailPreviewView addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:215 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Preview Message";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    backButton.tag=1001;
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
//    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
//    cancelButton.tag=123;
//    cancelButton.backgroundColor=[UIColor clearColor];
//    cancelButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
//    [cancelButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
//    [cancelButton addTarget:self action:@selector(cancelMail) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:cancelButton];

    //to & subject view
    UIImageView *emailHeaderBg=[[UIImageView alloc]init];
    emailHeaderBg.backgroundColor=[UIColor whiteColor];
    emailHeaderBg.layer.cornerRadius=2.0;
    emailHeaderBg.clipsToBounds=YES;
    emailHeaderBg.userInteractionEnabled=YES;
    if (screenBounds.size.height == 480)
        emailHeaderBg.frame=CGRectMake(5, headerView.frame.size.height + headerView.frame.origin.y + 7, self.frame.size.width - 10,100);
    else
        emailHeaderBg.frame=CGRectMake(5, headerView.frame.size.height + headerView.frame.origin.y + 7, self.frame.size.width - 10,100);
    [emailPreviewView addSubview:emailHeaderBg];
    
    UILabel *contactTitle=[[UILabel alloc]init];
    contactTitle.frame=CGRectMake(8,0,22, 40);
    contactTitle.textColor=[UIColor grayColor];
    contactTitle.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    contactTitle.text=@"To:";
    [emailHeaderBg addSubview:contactTitle];
    
    
    mailContactsLabel=[[UITextView alloc]init];
    mailContactsLabel.backgroundColor=[UIColor clearColor];
    mailContactsLabel.frame=CGRectMake(contactTitle.frame.size.width + contactTitle.frame.origin.x,0,emailHeaderBg.frame.size.width - 60,50);
    mailContactsLabel.textColor=[UIColor grayColor];
    mailContactsLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
    mailContactsLabel.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mailContactsLabel.delegate=self;
    mailContactsLabel.text=@"Email";
    [mailContactsLabel setContentInset:UIEdgeInsetsMake(6,0,0,0)];
    mailContactsLabel.scrollEnabled=YES;
    mailContactsLabel.editable=YES;
    [emailHeaderBg addSubview:mailContactsLabel];
    
    UIButton *addContactBtn=[[UIButton alloc]init];
    addContactBtn.frame= CGRectMake(emailHeaderBg.frame.size.width - 27,11, 40/2, 36/2);
    [addContactBtn setImage:[UIImage imageNamed:@"add_off.png"] forState:UIControlStateNormal];
    [addContactBtn setImage:[UIImage imageNamed:@"add_on.png"] forState:UIControlStateHighlighted];
    [addContactBtn addTarget:self action:@selector(showEmailContacts) forControlEvents:UIControlEventTouchUpInside];
    [emailHeaderBg addSubview:addContactBtn];
    
    UIView *separatorImage=[[UIView alloc]init];
    separatorImage.frame=CGRectMake(0,mailContactsLabel.frame.size.height, emailHeaderBg.frame.size.width,0.6);
    separatorImage.tag=101;
    separatorImage.backgroundColor=separatorColor;
    [emailHeaderBg addSubview:separatorImage];
    
    UILabel *subjectTitle=[[UILabel alloc]init];
    subjectTitle.frame=CGRectMake(5, separatorImage.frame.size.height+separatorImage.frame.origin.y,58, emailHeaderBg.frame.size.height - mailContactsLabel.frame.size.height);
    subjectTitle.textColor=[UIColor grayColor];
    subjectTitle.font=[UIFont fontWithName:AvenirRegular size:XbH3size];
    subjectTitle.text=@"Subject:";
    [emailHeaderBg addSubview:subjectTitle];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    UILabel *subjectlabel=[[UILabel alloc]init];
    subjectlabel.frame=CGRectMake(subjectTitle.frame.size.width + subjectTitle.frame.origin.x, subjectTitle.frame.origin.y, emailHeaderBg.frame.size.width-(subjectTitle.frame.size.width+subjectTitle.frame.origin.x), emailHeaderBg.frame.size.height - mailContactsLabel.frame.size.height);
    subjectlabel.textColor=[UIColor blackColor];
    subjectlabel.numberOfLines=2;
    subjectlabel.lineBreakMode=NSLineBreakByWordWrapping;
    NSMutableAttributedString *subjectString=[[NSMutableAttributedString alloc]initWithString:@"Check out XBowling - Bowl, Have Fun, and Win Prizes!" attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    [subjectString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subjectString length])];
    subjectlabel.attributedText=subjectString;
    [emailHeaderBg addSubview:subjectlabel];
    
    //body text
    UITextView *bodyText=[[UITextView alloc]init];
    bodyText.textColor=[UIColor whiteColor];
    bodyText.backgroundColor=[UIColor clearColor];
    bodyText.editable=NO;
    bodyText.font=[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    bodyText.frame=CGRectMake(10, emailHeaderBg.frame.size.height + emailHeaderBg.frame.origin.y+20, emailPreviewView.frame.size.width - 20, 290);
    bodyText.text=@"I just downloaded the Free XBowling App on my Apple/Android device, and I am winning real prizes while I bowl and compete! Please join me by downloading and activationg the App so we can enjoy XBowling together.\n\nClick here to download!\n\nNote: If the link above does not work, copy and paste the following URL into your browser: http://bit.ly/xbowlme";
    [emailPreviewView addSubview:bodyText];
    
    UIButton *sendButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:321/3 currentSuperviewDeviceSize:screenBounds.size.width],bodyText.frame.size.height+bodyText.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:600/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
    sendButton.layer.cornerRadius=sendButton.frame.size.height/2;
    sendButton.clipsToBounds=YES;
    [sendButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:sendButton.frame] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:sendButton.frame] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [emailPreviewView addSubview:sendButton];
}

- (void)backButtonFunction:(UIButton *)sender
{
    if (sender.tag == 1001) {
        [emailPreviewView removeFromSuperview];
    }
    else{
        [self removeFromSuperview];
    }
}

-(void)cancelMail
{
    [emailPreviewView removeFromSuperview];
}
-(void)sendMail
{
    if([mailContactsLabel.text isEqualToString:@"Email"])
    {
        UIAlertView *emailalert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter an email address to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailalert show];
    }
    else
    {
        
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        NSArray *contactArray=[[mailContactsLabel.text lowercaseString] componentsSeparatedByString:@","];
        [self emailPostServerCall:contactArray];
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    mailContactsLabel.textColor=[UIColor blackColor];
    if(mailContactsLabel.text.length == 0 || [mailContactsLabel.text isEqualToString:@"Email"])
        mailContactsLabel.text=@"";
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(mailContactsLabel.text.length == 0)
    {
        mailContactsLabel.text=@"Email";
        mailContactsLabel.textColor=[UIColor grayColor];
    }
    [mailContactsLabel resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 8888) {
        //fb
        if(buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else
        {
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            [self fbPostFunction];
        }
    }
    else if (alertView.tag == 8889) {
        //twitter
        if(buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else
        {
            [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
            [self twitterPostFunction];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

#pragma mark - fb post

-(void)fbPostFunction
{
    [delegate postOnFacebook];
}

/*-(void)fbPostFunction
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        //        [FBSession.activeSession closeAndClearTokenInformation];
        
        NSArray *permissions=[[NSArray alloc]initWithObjects:@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             //             NSLog(@"session=%hhd  status=%d",session.isOpen,session.state);
             if(error)
             {
                 //                 NSLog(@"error=%d   %hhd",error.fberrorCategory,error.fberrorShouldNotifyUser);
                 [[DataManager shared]removeActivityIndicator];

                 if (error.fberrorCategory == FBErrorCategoryUserCancelled)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"" message:@"App could not get the desired permissions to use your Facebook account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                     
                 }
                 else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Session Error" message:@"Your current session is no longer valid. Please log in again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                 }
                 if(error.fberrorShouldNotifyUser == 1)
                 {
                     UIAlertView *LoginFailed=[[UIAlertView alloc]initWithTitle:@"Failed to login" message:[NSString stringWithFormat:@"%@",error.fberrorUserMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [LoginFailed show];
                     
                 }
                 
             }
             
             else if(FBSession.activeSession.isOpen)
             {
                 
                 FBRequest *me = [FBRequest requestForMe];
                 
                 [me startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my,NSError *error)
                  {
                      [[NSUserDefaults standardUserDefaults]setValue:session.accessTokenData.accessToken forKey:@"FB_ACCESSTOKEN"];
                      if (!error)  {
                          [self fbPostServerCall];
                      }
                      else {
                          [[DataManager shared]removeActivityIndicator];
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"An error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                          NSLog(@"fb login failed");
                      }
                  }];
                 
                 
             }
             
             else {
                 
                 NSLog(@"fb login failed");
                 
             }
         }];
        
    }
    
}

-(void)fbPostServerCall
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];

    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@userreferral/facebook?token=%@&apiKey=%@&referralMessageType=2&accessToken=%@",serverAddress,token,APIKey,[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ACCESSTOKEN"]]]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:kTimeoutInterval];
    
    NSLog(@"enquiryURL=%@",[NSString stringWithFormat:@"%@userreferral/facebook?token=%@&apiKey=%@&referralMessageType=2&accessToken=%@",serverAddress,token,APIKey,[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ACCESSTOKEN"]]);
    [URLrequest setHTTPMethod:@"POST"];
    //    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [URLrequest setHTTPBody:postdata];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    [[DataManager shared]removeActivityIndicator];
    if(response.statusCode==200)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully posted on Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else if (response.statusCode == 400 || response.statusCode == 409)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post the same message twice in a row to Facebook. Please try again after you have posted a different post at least once!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else if (response.statusCode == 403)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post to social media more than 6 times in a 1 month period. Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"errorCode=%ld",(long)response.statusCode] message:@"An error occurred posting to Facebook. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        
    }
    
    
}*/

#pragma mark - twitter post
-(void)twitterPostFunction
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
        
    }
    else
    {
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        if ([self userHasAccessToTwitter]) {
            
            //  Step 1:  Obtain access to the user's Twitter accounts
            ACAccountType *twitterAccountType =
            [self.accountStore accountTypeWithAccountTypeIdentifier:
             ACAccountTypeIdentifierTwitter];
            
            [self.accountStore
             requestAccessToAccountsWithType:twitterAccountType
             options:NULL
             completion:^(BOOL granted, NSError *error) {
                 if (granted) {
                     //  Step 2:  Create a request
                     
                     
                     ACAccount* account = [[self.accountStore accountsWithAccountType:[self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]] lastObject];
                     
                     
                     [_apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error)
                      {
                          if (responseData) {
                              NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                              
                              TWDLog(@"Reverse Auth process returned: %@", responseStr);
                              
                              NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                              NSLog(@"parts=%@",parts);
                              NSArray *temp=[[parts objectAtIndex:0] componentsSeparatedByString:@"="];
                              NSLog(@"parts=%@",temp);
                              NSString *token=[temp objectAtIndex:1];
                              NSArray *temp2=[[parts objectAtIndex:1]componentsSeparatedByString:@"="];
                              NSString *secretToken=[temp2 objectAtIndex:1];
                              [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"twitterAccessToken"];
                              [[NSUserDefaults standardUserDefaults]setValue:secretToken forKey:@"twitterSecretKey"];
                              NSString *lined = [parts componentsJoinedByString:@"\n"];
                              
                              NSLog(@"Token: %@", lined);
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  //                              [alert show];
                                  
                              });
                              [self twitterPostServerCall];
                          }
                          else {
                              TWALog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                          }
                      }];
                     NSArray *twitterAccounts =
                     [self.accountStore accountsWithAccountType:twitterAccountType];
                     
                     //                 NSLog(@"%@", [twitterAccounts objectAtIndex:0]);
                     
                     NSString *_oAuthTimestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
                     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
                     NSDictionary *params = @{@"oauth_consumer_key" : @"RaFBvISkU97o0Bhke3RA",
                                              @"oauth_nonce" : [self _generateNonce],
                                              @"oauth_signature_method" : @"HMAC-SHA1",
                                              @"oauth_timestamp" : _oAuthTimestamp,
                                              @"oauth_version" : @"1.0",
                                              @"x_auth_mode" : @"reverse_auth"};
                     
                     SLRequest *request =
                     [SLRequest requestForServiceType:SLServiceTypeTwitter
                                        requestMethod:SLRequestMethodPOST
                                                  URL:url
                                           parameters:params];
                     
                     //  Attach an account to the request
                     [request setAccount:[twitterAccounts lastObject]];
                     
                     //  Step 3:  Execute the request
                     [request performRequestWithHandler:
                      ^(NSData *responseData,
                        NSHTTPURLResponse *urlResponse,
                        NSError *error) {
                          
                          if (responseData) {
                              if (urlResponse.statusCode >= 200 &&
                                  urlResponse.statusCode < 300) {
                                  
                                  NSError *jsonError;
                                  NSDictionary *timelineData =
                                  [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:NSJSONReadingAllowFragments error:&jsonError];
                                  if (timelineData) {
                                      NSLog(@"Timeline Response: %@\n", timelineData);
                                  }
                                  else {
                                      // Our JSON deserialization went awry
                                      NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  }
                              }
                              else {
                                  // The server did not respond ... were we rate-limited?
                                  NSLog(@"The response status code is %ld",
                                        (long)urlResponse.statusCode);
                              }
                          }
                      }];
                 }
                 else {
                     // Access was not granted, or an error occurred
                     NSLog(@"%@", [error localizedDescription]);
                 }
             }];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *twitterAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"No twitter account found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [twitterAlert show];
        }
        
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

- (NSString *)_generateNonce {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    
    NSString *nonce = (__bridge NSString *)string;
    return nonce;
}

-(void)twitterPostServerCall
{
    NSString *TWtoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"twitterAccessToken"]];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@userreferral/twitter?token=%@&apiKey=%@&referralMessageType=2&accessTokenKey=%@&accessTokenSecret=%@",serverAddress,token,APIKey,TWtoken,[[NSUserDefaults standardUserDefaults]valueForKey:@"twitterSecretKey"]]]
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:kTimeoutInterval];
    NSLog(@"url=%@",[NSString stringWithFormat:@"%@userreferral/twitter?token=%@&apiKey=%@&referralMessageType=2&accessTokenKey=%@&accessTokenSecret=%@",serverAddress,token,APIKey,TWtoken,[[NSUserDefaults standardUserDefaults]valueForKey:@"twitterSecretKey"]]);
    [URLrequest setHTTPMethod:@"POST"];
    //    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [URLrequest setHTTPBody:postdata];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    [[DataManager shared]removeActivityIndicator];
    if(response.statusCode == 200 && responseData)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"Posted on twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        
    }
    else if (response.statusCode == 400 || response.statusCode == 409)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post the same message twice in a row to Twitter. Please try again after you have posted a different tweet at least once!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else if (response.statusCode == 403)
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You cannot post to social media more than 6 times in a 1 month period.  Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
    }
    else
    {
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred posting to Twitter. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        
    }
    
    
    
}

#pragma mark Validate email
- (BOOL)validateEmail: (NSString *) candidate
{
    
//    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9-.]+\\.[A-Za-z]{2,4}"; //earlier one
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
    
}


#pragma mark - email

-(void)emailPostServerCall:(NSArray *)emailAddressArray
{
    NSMutableArray *listarray=[NSMutableArray new];
    for (int i=0; i< emailAddressArray.count; i++) {
        NSMutableDictionary *emailDict=[NSMutableDictionary new];
        NSString *address=[[NSString stringWithFormat:@"%@",[emailAddressArray objectAtIndex:i]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self validateEmail:address]) {
            [emailDict setObject:[emailAddressArray objectAtIndex:i] forKey:@"emailAddress"];
            [emailDict setObject:@"email" forKey:@"userReferralType"];
            [listarray addObject:emailDict];
        }
        else
        {
            if(emailAddressArray.count == 1)
            {
                [[DataManager shared]removeActivityIndicator];
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
        }
    }

    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:listarray,@"list",nil];
    NSLog(@"dict=%@",postDict);
    NSError *error = NULL;
    NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"dataString=%@",dataString);
    NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@userreferral/batch?token=%@&apiKey=%@",serverAddress,token,APIKey]]  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData    timeoutInterval:kTimeoutInterval];
    [URLrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@userreferral/batch?token=%@&apiKey=%@",serverAddress,token,APIKey]]];
    NSLog(@"requestURL=%@", [NSURL URLWithString:[NSString stringWithFormat:@"%@userreferral/batch?token=%@&apiKey=%@",serverAddress,token,APIKey]]);
    [URLrequest setHTTPMethod:@"POST"];
    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [URLrequest setHTTPBody:postdata];
    NSError *error1=nil;
    NSHTTPURLResponse *response=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    if(response.statusCode == 200 && responseData)
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *success=[[UIAlertView alloc]initWithTitle:@"" message:@"Email sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        mailContactsLabel.text=nil;
        mailContactsLabel.text=@"Email";
        mailContactsLabel.textColor=[UIColor grayColor];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
    }
    
}

-(void)showEmailContacts
{
    [self endEditing:YES];
    comparisonItemselectArray=[NSMutableArray new];
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            // add your contacts or get emails
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
            allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
            for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
                ABRecordRef person = CFArrayGetValueAtIndex(people, i);
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
                    NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                    [allEmails addObject:email];
                    
                }
                CFRelease(emails);
            }
            CFRelease(addressBook);
            CFRelease(people);
            NSLog(@"emailsArray=%@",allEmails);
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        // add your contacts or get emails
        CFErrorRef *error=nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
        for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
                NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                [allEmails addObject:email];
                
            }
            CFRelease(emails);
        }
        CFRelease(addressBook);
        CFRelease(people);
        NSLog(@"emailsArray=%@",allEmails);
        
        contactListView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)];
        //  popUpImgView.center = self .center;
        contactListView.image = [UIImage imageNamed:@"bg.png"];
        contactListView.userInteractionEnabled = YES;
        [self addSubview: contactListView];
        
        UIView *headerView=[[UIView alloc]init];
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.backgroundColor=XBHeaderColor;
        headerView.userInteractionEnabled=YES;
        [contactListView addSubview:headerView];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:100 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:215 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.text=@"Mail Contact List";
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(removeContactListView) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        UIButton *doneButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
        doneButton.tag=123;
        doneButton.backgroundColor=[UIColor clearColor];
        doneButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
        [doneButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
        [doneButton addTarget:self action:@selector(doneButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:doneButton];

        
        UITableView *contactsTable=[[UITableView alloc]init];
        contactsTable.frame=CGRectMake(0, headerView.frame.size.height + headerView.frame.origin.y + 8, contactListView.frame.size.width,contactListView.frame.size.height-(headerView.frame.size.height + headerView.frame.origin.y + 8));
        contactsTable.dataSource=self;
        contactsTable.delegate=self;
        contactsTable.backgroundColor=[UIColor clearColor];
        [contactsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [contactListView addSubview:contactsTable];
     }
    else {
        // The user has previously denied access
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Permission denied. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}
#pragma mark - Tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [allEmails count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBckgd=(UIView*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBckgd removeFromSuperview];
        cellBckgd=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    
    UIButton *baseBtn=[[UIButton alloc]init];
    baseBtn.tag=1500 + indexPath.row;
    //    if(screenBounds.size.height == 480)
    //        baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width] , 27);
    //    else
    baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
    [baseBtn setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
    [baseBtn setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
    [baseBtn setBackgroundColor:[UIColor clearColor]];
    [baseBtn setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:4/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [baseBtn addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:baseBtn];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(baseBtn.frame.size.width+baseBtn.frame.origin.x, 0,cellView.frame.size.width - ( baseBtn.frame.size.width+baseBtn.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.width]), frame.size.height)];
    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    nameLabel.text=[NSString stringWithFormat:@"%@",[allEmails objectAtIndex:indexPath.row]];
    [cellView addSubview:nameLabel];
    
//    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(cellView.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
//    arrow.tag=902;
//    arrow.center=CGPointMake(arrow.center.x, cellView.frame.size.height/2);
//    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
//    [cellView addSubview:arrow];

    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didselect");
//    Reachability * reach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus netStatus = [reach currentReachabilityStatus];
//    
//    if (netStatus == NotReachable)
//    {
//        //        [self hideActivityIndicator];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]  animated:YES];
//        alert=nil;
//        
//    }
//    else
//    {
//           }
}

-(void)checkboxSelected:(UIButton *)sender
{
    NSUInteger selectedIndex=sender.tag - 1500;
    if([comparisonItemselectArray containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)selectedIndex] ])
    {
        sender.selected=NO;
        [comparisonItemselectArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)selectedIndex]];
    }
    else{
//        if(comparisonItemselectArray.count>0)
//        {
//            UIImageView *btn12= (UIImageView *)[self  viewWithTag:[[comparisonItemselectArray objectAtIndex:0]integerValue] *10000];
//            [btn12 setImage:[UIImage imageNamed:@"check_off.png"]];
//            [comparisonItemselectArray removeAllObjects];
//        }
        sender.selected=YES;
        [comparisonItemselectArray addObject:[NSString stringWithFormat:@"%ld",(long)selectedIndex]];
        
    }
}

- (void)doneButtonFunction
{
    mailContactsLabel.textColor=[UIColor blackColor];
    NSString *mailsList;
    if([mailContactsLabel.text isEqualToString:@"Email"])
    {
       mailsList=[NSString stringWithFormat:@"%@",[allEmails objectAtIndex:[[comparisonItemselectArray objectAtIndex:0] integerValue]]];
    }
    else
    {
        mailsList=mailContactsLabel.text;
       mailsList=[mailsList stringByAppendingString:[NSString stringWithFormat:@",%@",[allEmails objectAtIndex:[[comparisonItemselectArray objectAtIndex:0] integerValue]]]];
    }
    for (int i=1; i<comparisonItemselectArray.count; i++) {
        mailsList = [mailsList stringByAppendingString:[NSString stringWithFormat:@",%@",[allEmails objectAtIndex:[[comparisonItemselectArray objectAtIndex:i] integerValue]]]];
    }
    [mailContactsLabel setText:mailsList];
    [self removeContactListView];
}
@end
