//
//  LoginViewController.h
//  XBowling3.1
//
//  Created by clicklabs on 1/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "Keys.h"
#import "ServerCalls.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "TermsAndConditionsView.h"


@interface LoginViewController : UIViewController<loginProtocol,serverCallProtocol,TermsAndConditionsDelegate>

@end
