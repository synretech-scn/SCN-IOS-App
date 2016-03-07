//
//  PlayerProfileView.h
//  XBowling3.1
//
//  Created by Click Labs on 1/22/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
#import "UIImageView+AFNetworking.h"

@protocol PlayerProfileDelegate <NSObject>
- (void)removePlayerProfileView;

@end


@interface PlayerProfileView : UIView
{
     id<PlayerProfileDelegate> delegate;
}
@property(retain) id<PlayerProfileDelegate> delegate;
- (void)createPlayerView:(NSDictionary *)playerDict;
@end
