//
//  LoginView.h
//  XBowling3.1
//
//  Created by clicklabs on 1/9/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "ServerCalls.h"
@protocol loginProtocol <NSObject>
- (void)loginbackButtonAction;
-(void)fbSignUpFunction;
- (void)signUpTermsAndConditions:(NSString *)signupVia;
-(void)checkFirstSignInurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber calltype:(BOOL)isPostType;
-(void)loginViewServerCallurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber calltype:(BOOL)isPostType;
@end

@interface LoginView : UIView<UITextFieldDelegate>
@property (weak) id <loginProtocol> loginDelegate;
- (void)continueSignUpWithEmail;
@end

