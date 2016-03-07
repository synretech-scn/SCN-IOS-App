//
//  ImageVerificationView.h
//  Xbowling
//
//  Created by Click Labs on 7/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"
#import "UIImageView+AFNetworking.h"

@protocol ImageVerificationDelegate <NSObject>
- (void)removeImageVerificationView;
- (void)submitPasscodeAfterImageScan:(NSDictionary *)itemDictionary enteredPasscode:(NSString *)passcode;
@end

@interface ImageVerificationView : UIView
{
    id<ImageVerificationDelegate> delegate;
}
@property (retain) id<ImageVerificationDelegate>  delegate;
- (void)createViewWithBarcodeImageURL:(NSString *)imageUrl;
- (void)passscodeData:(NSDictionary *)itemDictionary userEnteredPasscode:(NSString *)passcode;
@end
