//
//  WalletViewController.h
//  Xbowling
//
//  Created by Click Labs on 6/8/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletView.h"
#import "LeftSlideMenu.h"
#import "AddCenterView.h"
#import "SelectCenterModel.h"
#import "PointsView.h"
#import "OfferingsListView.h"
#import "PasscodeView.h"
#import "ImageVerificationView.h"
#import "ShippingInformationView.h"

@interface WalletViewController : UIViewController<LeftMenuDelgate,walletDelegate,CenterSelectionDelegate,walletCenterDelegate,pointsDelegate,offeringsDelegate,passcodeDelegate,UIAlertViewDelegate,ImageVerificationDelegate,ShippingInformationDelegate>
- (void)createMainWalletView;
@end
