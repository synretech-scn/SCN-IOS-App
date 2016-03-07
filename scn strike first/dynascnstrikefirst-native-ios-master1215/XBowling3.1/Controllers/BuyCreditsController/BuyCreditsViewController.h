//
//  BuyCreditsViewController.h
//  XBowling3.1
//
//  Created by Click Labs on 4/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyCreditsView.h"
#import "InAppManager.h"
#import "SVProgressHUD.h"
#import "LeftSlideMenu.h"

@interface BuyCreditsViewController : UIViewController<buyCreditsDelegate,InAppManagerDelegate,LeftMenuDelgate>
- (void)creditsMainViewAddedToBaseView:(NSString *)parentViewName;
@end
