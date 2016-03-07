//
//  BuyCreditsView.h
//  XBowling3.1
//
//  Created by Click Labs on 3/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@protocol buyCreditsDelegate <NSObject>;
- (void)buyPackageAtIndex:(int)selectedPackageIndex;
- (void)removeBuyCreditsView;
- (NSDictionary *)userCredits;
- (void)showMainMenu:(UIButton *)sender;
@end

@interface BuyCreditsView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<buyCreditsDelegate> delegate;
}
@property (retain) id<buyCreditsDelegate>  delegate;
- (void)createCreditsViewForBaseView:(NSString *)baseViewName;
- (void)creditPackages:(NSArray *)packagesArray;
- (void)getCredits;
@end
