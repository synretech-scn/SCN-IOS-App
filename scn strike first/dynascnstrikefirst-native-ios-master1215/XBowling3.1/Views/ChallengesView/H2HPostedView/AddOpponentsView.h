//
//  AddOpponentsView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/11/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
@protocol AddOpponentsDelegate<NSObject>
- (void)addMoreOpponents;
- (void)removeAddOpponentView;
- (void)showFrameViewOfPlayer:(NSDictionary*)playerDict;
@optional

@end

@interface AddOpponentsView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    id<AddOpponentsDelegate> delegate;
}
@property (retain) id<AddOpponentsDelegate>  delegate;
- (void)displayOpponents:(NSMutableArray *)array;
@end
