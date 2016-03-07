//
//  DropDownImageView.m
//  xBowling
//
//  Created by Click Labs on 3/21/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "DropDownImageView.h"
#import "DataManager.h"
#import "Keys.h"

@implementation DropDownImageView


@synthesize textLabel;
@synthesize dropDownImage,dropDownImageView;
@synthesize separatorImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
//        self.userInteractionEnabled = YES;
        dropDownImage = [UIImage imageNamed:@"dropdown_icon.png"];
        dropDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:67/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:37/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:75/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        dropDownImageView.image = dropDownImage;
        dropDownImageView.userInteractionEnabled = NO;
        [self addSubview:dropDownImageView];
        
        textLabel =  [[UITextField alloc] initWithFrame: CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.height],dropDownImageView.frame.origin.x - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:150/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.delegate=self;
        textLabel.userInteractionEnabled=NO;
        textLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [self addSubview:textLabel];
        
        separatorImage=[[UIView alloc]init];
        separatorImage.frame=CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
        separatorImage.backgroundColor=separatorColor;
        [self addSubview:separatorImage];

//        float version=[[[UIDevice currentDevice] systemVersion] floatValue];
//        if (version>=8.0) {
//            CGSize value= [[DataManager shared]invertScreenBoundsForIOS8:screenBounds.size.width height:screenBounds.size.height];
//            screenBounds.size.width=value.width;
//            screenBounds.size.height=value.height;
//        }

        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
//            if (screenBounds.size.height == 480)
//            {
//                textLabel.frame=CGRectMake(8, 5, 168, 20);
//            }
        }
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

@end
