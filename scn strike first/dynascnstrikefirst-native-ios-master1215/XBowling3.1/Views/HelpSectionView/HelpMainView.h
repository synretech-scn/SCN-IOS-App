//
//  HelpMainView.h
//  XBowling3.1
//
//  Created by Click Labs on 4/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "ExpandableTableView.h"
@protocol HelpDelegate <NSObject>
- (void)showMainMenu:(UIButton *)sender;
@end

@interface HelpMainView : UIView<ExpandableTableDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    id<HelpDelegate> delegate;
}
@property(retain) id<HelpDelegate> delegate;
@end
