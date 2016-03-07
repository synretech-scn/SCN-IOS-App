//
//  AddFriendsView.h
//  XBowling3.1
//
//  Created by Click Labs on 3/27/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "ASIHTTPRequest.h"

@protocol addFriendsDelegate <NSObject>
- (void)showMainMenu:(UIButton *)sender;
- (void)showShareView;
@end
@interface AddFriendsView : UIView<UITextFieldDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    id<addFriendsDelegate> delegate;
}
@property (retain) id<addFriendsDelegate> delegate;
- (void)createFriendsView;

@end
