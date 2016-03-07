//
//  CustomActionSheet.m
//  XBowling 3.0
//
//  Created by Click Labs on 9/16/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "CustomActionSheet.h"

@implementation CustomActionSheet
{
    UILabel *titleLabel;
}
@synthesize customActionSheetDelegate,actionSheet;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        //Transparent view for action sheet
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
        
        // UIView as Picker base view
        actionSheet = [[UIView alloc]init];
        actionSheet.backgroundColor=[UIColor whiteColor];
        actionSheet.frame=CGRectMake(0,self.frame.size.height,self.frame.size.width, 162+ 50);
       titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55,5, actionSheet.frame.size.width-110, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:14.0];
        titleLabel.textColor=[UIColor grayColor];
        [actionSheet addSubview:titleLabel];
        actionSheet.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
        [actionSheet addGestureRecognizer:tap];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
        //    closeButton.selectedSegmentIndex = 0;
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        closeButton.momentary = YES;
        if (actionSheet.frame.size.width==480)
        {
            closeButton.frame = CGRectMake(self.frame.size.width - 68, 3.0f, 65, 25);
        }
        else{
            closeButton.frame = CGRectMake(self.frame.size.width - 68, 3.0f, 65, 25);
        }
        closeButton.backgroundColor = [UIColor clearColor];
        [actionSheet addSubview:closeButton];

        [self addSubview:actionSheet];
    }
    return self;
}

- (void)showPicker
{
    [self.superview endEditing:YES];
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.hidden = NO;
        actionSheet.frame=CGRectMake(0,self.frame.size.height - actionSheet.frame.size.height,actionSheet.frame.size.width, actionSheet.frame.size.height);
    } completion:^(BOOL finished){
        
    }];
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.hidden = YES;
        actionSheet.frame=CGRectMake(0,actionSheet.frame.size.height + actionSheet.frame.origin.y,actionSheet.frame.size.width, actionSheet.frame.size.height);
    } completion:^(BOOL finished){
        [actionSheet removeFromSuperview];
            [self removeFromSuperview];
    }];

}

- (void)updateTitleLabel:(NSString *)titleString
{
    titleLabel.text=titleString;
}

-(void)dismissActionSheet
{
    [self hidePicker];
    [customActionSheetDelegate dismissActionSheet];
}

@end
