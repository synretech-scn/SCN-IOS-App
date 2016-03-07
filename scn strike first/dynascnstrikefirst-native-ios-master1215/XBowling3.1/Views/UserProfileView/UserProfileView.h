//
//  UserProfileView.h
//  VAFieldTest
//
//  Created by clicklabs on 1/6/15.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "SelectCenterView.h"
@protocol userProfileProtocol <NSObject>
- (void)backButtonAction;
-(void)serverCallMethodurlAppend:(NSString *)urlAppend postDictionary:(NSDictionary *)postDict isKeyTokenAppend:(BOOL)isTokenAppend apinumber:(int)apiNumber;
@end
@interface UserProfileView : UIView<UITextFieldDelegate,UIImagePickerControllerDelegate>

@property (weak) id <userProfileProtocol> profileDelegate;
@property(nonatomic,retain)UIViewController *profileViewController;
@property(nonatomic)NSDictionary *profileInfo;
- (void)loadViewWithCenterSelectionView:(SelectCenterView*)centerView;
-(void)cancelEditButtonAction;
-(void)updateProfileParameters;
-(void)selectedHomeCenter:(NSDictionary *)centerDict updated:(BOOL)boolValue;
-(void)cancelChangePasswordButtonAction;
@end


