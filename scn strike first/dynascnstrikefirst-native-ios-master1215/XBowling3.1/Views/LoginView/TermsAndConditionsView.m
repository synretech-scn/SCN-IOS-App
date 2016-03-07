//
//  TermsAndConditionsView.m
//  XBowling3.1
//
//  Created by Click Labs on 4/18/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "TermsAndConditionsView.h"

@implementation TermsAndConditionsView
{
    NSMutableArray *comparisonItemselectArray;
    UIWebView *mainWebView;
    UIView *footerViewForWebview;
    NSString *signUpMethod;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
         comparisonItemselectArray=[NSMutableArray new];
        UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
        [self addSubview:backgroundImage];
        
        UIView *headerView=[[UIView alloc]init];
        //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
        headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
        headerView.backgroundColor=[UIColor clearColor];
        [self addSubview:headerView];
        
//        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
//        headerLabel.backgroundColor=[UIColor clearColor];
//        headerLabel.textAlignment=NSTextAlignmentCenter;
//        headerLabel.textColor=[UIColor whiteColor];
//        headerLabel.text=@"Terms & Conditions";
//        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
//        [headerView addSubview:headerLabel];
        
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:300/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:589/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        logoImageView.image=[UIImage imageNamed:@"x bowling logo.png"];
        [self addSubview:logoImageView];
        
        int ycoordinate=[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:200 currentSuperviewDeviceSize:self.frame.size.height];
        for (int i=0; i<1; i++) {  //modi 2
            UIButton *checkboxButton=[[UIButton alloc]init];
            checkboxButton.tag=1500+i;
            if (i==0) {
                  checkboxButton.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinate-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20 currentSuperviewDeviceSize:self.frame.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            }
            else{
                checkboxButton.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:80/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinate-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20 currentSuperviewDeviceSize:self.frame.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height]);
            }
            [checkboxButton setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
            [checkboxButton setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
            [checkboxButton setBackgroundColor:[UIColor clearColor]];
            [checkboxButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:4/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            [checkboxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:checkboxButton];
            
            UILabel *starLabel=[[UILabel alloc]init];
            starLabel.frame=CGRectMake(checkboxButton.frame.size.width - 10, checkboxButton.imageEdgeInsets.top, 10, 30);
            starLabel.text=@"*";
            starLabel.font=[UIFont fontWithName:AvenirRegular size: [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]];
            starLabel.textColor=[UIColor whiteColor];
            [checkboxButton addSubview:starLabel];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            UITextView *nameLabel=[[UITextView alloc]initWithFrame:CGRectMake(checkboxButton.frame.size.width+checkboxButton.frame.origin.x, ycoordinate,self.frame.size.width - ( checkboxButton.frame.size.width+checkboxButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width]), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:470/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
            nameLabel.delegate=self;
            nameLabel.textColor=[UIColor whiteColor];
            nameLabel.userInteractionEnabled=YES;
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.editable = NO;
            nameLabel.scrollEnabled=NO;
            nameLabel.dataDetectorTypes = UIDataDetectorTypeLink;
            nameLabel.selectable=YES;
            NSString *statement;
            NSMutableAttributedString* mutableAttributedText;
            if (i==0) {
                nameLabel.frame=CGRectMake(checkboxButton.frame.size.width+checkboxButton.frame.origin.x, ycoordinate,self.frame.size.width - ( checkboxButton.frame.size.width+checkboxButton.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width]), [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:300/3 currentSuperviewDeviceSize:screenBounds.size.height]);
                statement=@"I agree to the XBowling Terms and Conditions and Privacy Policy.";
                NSUInteger locationOfTerms=[statement rangeOfString:@"Terms"].location;
                NSUInteger locationOfPrivacy=[statement rangeOfString:@"Privacy"].location;
                mutableAttributedText = [[NSMutableAttributedString alloc]initWithString:statement attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size: [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]]}];
                 [mutableAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,mutableAttributedText.length)];
                [mutableAttributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]] range:NSMakeRange(locationOfTerms,20)];
                [mutableAttributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]] range:NSMakeRange(locationOfPrivacy, 14)];
                [mutableAttributedText addAttribute:NSForegroundColorAttributeName value:XBBlueButtonBackgndNormalState range:NSMakeRange(locationOfTerms,20)];
                [mutableAttributedText addAttribute:NSForegroundColorAttributeName value:XBBlueButtonBackgndNormalState range:NSMakeRange(locationOfPrivacy, 14)];
                [mutableAttributedText addAttribute:NSLinkAttributeName value:@"https://www.xbowling.com/mobile/terms-of-use.html" range:NSMakeRange(locationOfTerms,20)];
                [mutableAttributedText addAttribute:NSLinkAttributeName value:@"https://www.xbowling.com/mobile/privacy-policy.html" range:NSMakeRange(locationOfPrivacy, 14)];
                
            }
            else{
                statement=@"I agree to receive email and/or electronic communications from XBowling and from its third party affiliates such as the bowling centers where I bowl.";
                  mutableAttributedText = [[NSMutableAttributedString alloc]initWithString:statement attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height]]}];
                [mutableAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,mutableAttributedText.length)];
            }
            [mutableAttributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [mutableAttributedText length])];

            nameLabel.attributedText=mutableAttributedText;
            [self addSubview:nameLabel];
            ycoordinate=nameLabel.frame.size.height+nameLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.height];
        }
        
        UILabel *requiredFieldsLabel=[[UILabel alloc]init];
        requiredFieldsLabel.frame=CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinate-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]);
//        requiredFieldsLabel.textAlignment=NSTextAlignmentCenter;
        requiredFieldsLabel.text=@"* Required Fields.";
        requiredFieldsLabel.backgroundColor=[UIColor clearColor];
        requiredFieldsLabel.font=[UIFont fontWithName:AvenirRegular size: [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        requiredFieldsLabel.textColor=[UIColor whiteColor];
        [self addSubview:requiredFieldsLabel];

        
        UIButton *continueButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:121/3 currentSuperviewDeviceSize:screenBounds.size.width], ycoordinate+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:180/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:1000/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:175/3 currentSuperviewDeviceSize:self.frame.size.height])];
        continueButton.layer.cornerRadius=continueButton.frame.size.height/2;
        continueButton.clipsToBounds=YES;
        [continueButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:continueButton.frame] forState:UIControlStateNormal];
        [continueButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:continueButton.frame] forState:UIControlStateHighlighted];
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(continueButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        continueButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
        [self addSubview:continueButton];

    }
    return self;
}
- (void)signUpMethod:(NSString *)facebookOrEmail
{
    signUpMethod=facebookOrEmail;
}

- (void)backButtonFunction
{
    [delegate removeTermsAndConditionsView];
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

- (void)continueButtonFunction
{
    if (comparisonItemselectArray.count < 1) {  //modi 2
        [[[UIAlertView alloc]initWithTitle:@"" message:@"In order to use the XBowling App, you must agree to our Terms and Conditions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
         //     [[[UIAlertView alloc]initWithTitle:@"" message:@"In order to use the XBowling App, you must agree to our Terms and Conditions, to our Privacy Policy, and to receive electronic communications from us and our affiliates." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }
    else{
        //go for sign up
        [delegate continueSignUpFor:signUpMethod];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"Began: touch=%@",touch.view);

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (characterRange.location == 24) {
        URL=[NSURL URLWithString:@"https://www.xbowling.com/mobile/terms-of-use.html"];
    }
    else{
        URL=[NSURL URLWithString:@"https://www.xbowling.com/mobile/privacy-policy.html"];
    }
    NSLog(@"=============%@",URL);
    if(mainWebView)
    {
        [mainWebView removeFromSuperview];
        mainWebView.delegate=nil;
        mainWebView=nil;
    }
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    mainWebView.delegate=self;
//    NSURL *url=[NSURL URLWithString:@"%@",URL];
    NSURL *url=URL;
       NSLog(@"url=%@",url);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:requestObj];
    [self addSubview:mainWebView];
    
    footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    closeButton.frame = CGRectMake(self.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.layer.borderWidth=0.2;
    closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
    [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [footerViewForWebview addSubview:closeButton];
    
    [self addSubview:footerViewForWebview];

    return NO;
}

#pragma mark - WebView Methods
-(void)dismissWebView
{
    [footerViewForWebview removeFromSuperview];
    footerViewForWebview=nil;
    
    [mainWebView loadHTMLString:@"" baseURL:nil];
    [mainWebView stopLoading];
    [mainWebView setDelegate:nil];
    
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[DataManager shared]removeActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *) portal
{
    [[DataManager shared]removeActivityIndicator];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [self performSelector:@selector(removeIndicator) withObject:nil afterDelay:1.2];
}

@end
