//
//  H2HLiveCreateGameView.h
//  XBowling3.1
//
//  Created by Click Labs on 2/23/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownImageView.h"
#import "CustomActionSheet.h"
@protocol H2HCreateGameDelegate<NSObject>
- (void)removeh2hCreateGameView;
- (void)createGame:(NSDictionary *)postDictionary;
@optional

@end
@interface H2HLiveCreateGameView : UIView<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,customActionSheetDelegate>
{
     id<H2HCreateGameDelegate> delegate;
}
@property (retain) id<H2HCreateGameDelegate>  delegate;
@end
