//
//  TermsAndConditionsView.h
//  XBowling3.1
//
//  Created by Click Labs on 4/18/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@protocol TermsAndConditionsDelegate<NSObject>

// define protocol functions that can be used in any class using this delegate
- (void)continueSignUpFor:(NSString *)facebookOrEmail;
- (void)removeTermsAndConditionsView;
@end
@interface TermsAndConditionsView : UIView<UITextViewDelegate,UIWebViewDelegate>
{
    id<TermsAndConditionsDelegate> delegate;
}
@property (retain) id<TermsAndConditionsDelegate>  delegate;
- (void)signUpMethod:(NSString *)facebookOrEmail;
@end
