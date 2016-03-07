//
//  ImageVerificationView.m
//  Xbowling
//
//  Created by Click Labs on 7/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ImageVerificationView.h"

@implementation ImageVerificationView
{
    NSDictionary *itemDictionary;
    NSString *passcode;
}
@synthesize delegate;
- (void)createViewWithBarcodeImageURL:(NSString *)imageUrl
{
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
    headerLabel.text=@"Redemption Image";
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
    noteLabel.text=@"Please scan the image \nthen tap close.";
    noteLabel.numberOfLines=2;
    noteLabel.lineBreakMode=NSLineBreakByWordWrapping;
    noteLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:noteLabel];
    
    UIImageView *barcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, noteLabel.frame.size.height + noteLabel.frame.origin.y + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width - 60, 180)];
    barcodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    __weak UIImageView *wBarcodeImageView = barcodeImageView;
    barcodeImageView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    NSURL *imageURL = [NSURL URLWithString:imageUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(barcodeImageView.center.x - 30, barcodeImageView.frame.size.height/2);
    [barcodeImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    [barcodeImageView setImageWithURLRequest:imageRequest
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         wBarcodeImageView.backgroundColor=[UIColor clearColor];
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
         wBarcodeImageView.image = image;
         [self addSubview:wBarcodeImageView];
     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
     }];
    
   [self addSubview:barcodeImageView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UILabel *bottomNoteLabel=[[UILabel alloc]init];
    bottomNoteLabel.frame=CGRectMake(0, self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:650/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    bottomNoteLabel.textColor=[UIColor whiteColor];
    NSMutableAttributedString *noteString=[[NSMutableAttributedString alloc]initWithString:@"Image will close permanently \nwhen you tap \"Close\"." attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    [noteString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteString length])];
    bottomNoteLabel.attributedText = noteString;
    bottomNoteLabel.numberOfLines=0;
    bottomNoteLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:bottomNoteLabel];

    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:306/3 currentSuperviewDeviceSize:screenBounds.size.width],self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:400/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:630/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:178/3 currentSuperviewDeviceSize:self.frame.size.height])];
    closeButton.layer.cornerRadius=closeButton.frame.size.height/2;
    closeButton.clipsToBounds=YES;
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:closeButton.frame] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:closeButton.frame] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:80/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [self addSubview:closeButton];

}

- (void)passscodeData:(NSDictionary *)itemDictionaryFromPasscodeScreen userEnteredPasscode:(NSString *)passcodeFromPasscodeScreen
{
    itemDictionary = [[NSDictionary alloc]initWithDictionary:itemDictionaryFromPasscodeScreen];
    passcode = passcodeFromPasscodeScreen;
}
- (void)backButtonFunction
{
    [delegate removeImageVerificationView];
}

- (void)closeButtonFunction
{
//    [[DataManager shared]showActivityIndicator:@"Loading..."];
//    [self performSelector:@selector(closeButtonFunctionAfterDelay) withObject:nil afterDelay:0.2];
    
    [delegate submitPasscodeAfterImageScan:itemDictionary enteredPasscode:passcode];
}

- (void)closeButtonFunctionAfterDelay
{
    [delegate submitPasscodeAfterImageScan:itemDictionary enteredPasscode:passcode];

}
@end
