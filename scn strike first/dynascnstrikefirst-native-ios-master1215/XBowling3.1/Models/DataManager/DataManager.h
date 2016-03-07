//
//  DataManager.h
//  TeachersAssistant
//
//  Created by Chirag Sharma on 2/25/13.
//  Copyright (c) 2013 Click Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "ServerCalls.h"

@interface DataManager : NSObject<CLLocationManagerDelegate,serverCallProtocol>
{
   CLLocationManager *lm;
}

+(DataManager *)shared;
- (void)activityIndicatorAnimate:(NSString *)textShown;
-(void)removeActivityIndicator;
-(UILabel *)notificationRedLabel:(CGRect)frame;
-(void)setNotifcationRead:(NSString *)urlHit ;
-(void)initializeLocationManager;
-(void)showActivityIndicator:(NSString *)message;
- (UIImage *)imageOfView:(UIView *)view;
- (UIImage*)setColor:(UIColor *)color buttonframe:(CGRect)frame;
//-(void)enterChallenge:(NSString *)creditsRequired view:(UIView *)viewToRemove postedOrLive:(NSString *)postedOrLive;
- (CGFloat)getValueFromTargetSize:(CGFloat)targetSuperviewSize targetSubviewSize:(CGFloat)targetSubviewSize currentSuperviewDeviceSize:(CGFloat)currentSizeOfSuperview;
- (UIImage *)imageWithColor:(UIColor *)color;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@property(retain, nonatomic) CLLocation* locationCoordinates;
@end
