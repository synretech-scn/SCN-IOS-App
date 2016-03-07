//
//  HomeView.h
//  Xbowling
//
//  Created by Click Labs on 5/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeDelegate<NSObject>

@end


@interface HomeView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<HomeDelegate> delegate;
}
@property (retain) id<HomeDelegate>  delegate;
- (void)createHomeView;
- (void)refreshMenu;
@end
