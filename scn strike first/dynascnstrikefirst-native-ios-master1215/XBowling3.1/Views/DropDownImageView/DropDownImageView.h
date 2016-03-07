//
//  DropDownImageView.h
//  xBowling
//
//  Created by Click Labs on 3/21/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownImageView : UIImageView<UITextFieldDelegate>


@property (nonatomic,retain) UITextField *textLabel;

@property (nonatomic,retain)UIImage *dropDownImage;
@property (nonatomic,retain)UIView *separatorImage;
@property (nonatomic,retain) UIImageView *dropDownImageView;
@end
