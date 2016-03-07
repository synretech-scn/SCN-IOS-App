//
//  tellAFriendView.h
//  XBowling 3.0
//
//  Created by Click Labs on 4/22/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DataManager.h"
#import "Keys.h"

@protocol InviteFriendsDelegate <NSObject>
- (void)postOnFacebook;
@end

@interface InviteFriendsView : UIView<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    id<InviteFriendsDelegate> delegate;
}
@property (retain) id<InviteFriendsDelegate> delegate;
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@end
