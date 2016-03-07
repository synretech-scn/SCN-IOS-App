//
//  ShowNotificationText.m
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "ShowNotificationText.h"
#import "NotificationTextView.h"

@interface ShowNotificationText ()

@end

@implementation ShowNotificationText
{
    NotificationTextView *textView;
}
@synthesize messageNotification;

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    textView=[[NotificationTextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.notificationMessage=self.messageNotification;
    [textView loadMessage];
    textView.backShownotificationDelegate=self;
    [self.view addSubview: textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Change Orientation
- (NSUInteger)supportedInterfaceOrientations :(BOOL)isCampusLandsc{
    NSLog(@"%d",isCampusLandsc);
    BOOL isOrientationLandscape = [[NSUserDefaults standardUserDefaults]boolForKey:@"showLandscape"];
    if(isOrientationLandscape)
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        //    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
