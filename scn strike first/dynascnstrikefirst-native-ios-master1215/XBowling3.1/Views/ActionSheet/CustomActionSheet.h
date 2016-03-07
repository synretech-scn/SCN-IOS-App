//
//  CustomActionSheet.h
//  XBowling 3.0
//
//  Created by Click Labs on 9/16/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol customActionSheetDelegate <NSObject>

- (void)dismissActionSheet;

@end

@interface CustomActionSheet : UIView
@property(retain) id<customActionSheetDelegate> customActionSheetDelegate;
@property (nonatomic,strong) UIView *actionSheet;
- (void)updateTitleLabel:(NSString *)titleString;
- (void)showPicker;
- (void)hidePicker;
@end
