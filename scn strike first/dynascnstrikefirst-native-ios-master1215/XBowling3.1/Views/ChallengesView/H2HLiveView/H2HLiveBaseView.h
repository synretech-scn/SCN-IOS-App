//
//  H2HLiveBaseView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/20/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"

@protocol H2HLiveDelegate<NSObject>
- (void)joinGame;
- (void)createGame;
- (void)removeh2hBaseView;
@optional

@end

@interface H2HLiveBaseView : UIView
{
    id<H2HLiveDelegate> delegate;
}
@property (retain) id<H2HLiveDelegate>  delegate;
- (void)displayH2HLiveStatus:(NSString *)status;

@end
