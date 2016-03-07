//
//  TagsView.h
//  XBowling3.1
//
//  Created by clicklabs on 2/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tagProtocol <NSObject>
- (void)backButtonAction;
-(void)updateEdittedTags :(NSString *)tagsEditted;
@end

@interface TagsView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak) id <tagProtocol> tagControllerDelegate;
-(void)updateTags:(NSDictionary *)notifcaitionresponse;
@end
