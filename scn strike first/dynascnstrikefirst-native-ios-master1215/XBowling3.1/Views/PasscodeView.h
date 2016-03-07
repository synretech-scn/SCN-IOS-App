//
//  PasscodeView.h
//  Xbowling
//
//  Created by Click Labs on 6/22/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "CustomNumberPad.h"

@protocol passcodeDelegate <NSObject>
- (void)removePasscodeView;
- (void)submitPasscode:(NSDictionary *)itemDictionary userEnteredPasscode:(NSString *)passcode forCategory:(NSString *)category;

@end

@interface PasscodeView : UIView<UITextFieldDelegate,NumberPadDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    id<passcodeDelegate> delegate;
    CustomNumberPad *numberPadView;
}
@property (retain) id<passcodeDelegate>  delegate;
- (void)createPasscodeViewFor:(NSString *)category item:(NSDictionary *)selectedItem;
@end
