//
//  DataManager.m
//  TeachersAssistant
//
//  Created by Chirag Sharma on 2/25/13.
//  Copyright (c) 2013 Click Labs. All rights reserved.
//

#import "DataManager.h"
#import "SVProgressHUD.h"
#import "Keys.h"
#import "Reachability.h"



static DataManager *dataManager;
@implementation DataManager
{
    int pushOrPull;
    UIView *viewToBeUsed;
    UILabel *unreadLabel;
    BOOL enterInCenterBool;
}
@synthesize locationCoordinates;
+(DataManager *) shared{
    if(!dataManager){
        dataManager = [[DataManager alloc] init];
    }
    return dataManager;
}

- (void)activityIndicatorAnimate:(NSString *)textShown
{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    [SVProgressHUD showWithStatus:textShown maskType:SVProgressHUDMaskTypeGradient];
//    [SVProgressHUD showWithStatus:textShown];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
//    [self performSelector:@selector(showActivityIndicator:) withObject:textShown afterDelay:0.01];
//    [self performSelectorOnMainThread:@selector(showActivityIndicator:) withObject:textShown waitUntilDone:YES];
}

-(void)showActivityIndicator:(NSString *)message
{
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
}


-(void)removeActivityIndicator
{
    [SVProgressHUD dismiss];
}

-(void)initializeLocationManager
{
    NSLog(@"[CLLocationManager authorizationStatus]: %d",[CLLocationManager authorizationStatus]);
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location required"
                                                        message:@"We need your current location. Please go to Settings and make sure Location Services for XBowling is turned on."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    [lm stopUpdatingLocation];
    lm=nil;
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    if ([lm respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [lm requestWhenInUseAuthorization];
    }
    lm.desiredAccuracy=kCLLocationAccuracyBest;
    lm.distanceFilter=kCLDistanceFilterNone;
    [lm startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        locationCoordinates=currentLocation;
        NSLog(@"*dLocation : %f", locationCoordinates.coordinate.latitude);
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",locationCoordinates.coordinate.latitude] forKey:kLatitude];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",locationCoordinates.coordinate.longitude] forKey:kLongitude];
        //Las Vegas
//        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",@"36.169941"] forKey:kLatitude];
//        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",@"-115.139830"] forKey:kLongitude];
        //Dacula
//        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",@"33.988717"] forKey:kLatitude];
//        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",@"-83.897957"] forKey:kLongitude];
        if (!enterInCenterBool) {
            [self enterInCenter];
            enterInCenterBool=YES;
        }
        manager=nil;
        
    }
    
}

-(void)enterInCenter {

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *queryParams=[NSString stringWithFormat:@"Latitude=%@&Longitude=%@&",[[NSUserDefaults standardUserDefaults]valueForKey:kLatitude],[[NSUserDefaults standardUserDefaults]valueForKey:kLongitude]];
        NSLog(@"queryParams :%@",queryParams);
        NSDictionary *json = [[ServerCalls instance] asyncServerCallWithQueryParameters:queryParams url:@"EnterInCenter" contentType:@"" httpMethod:@"POST"];
        NSDictionary *response=[json objectForKey:@"responseString"];
        NSLog(@"responseDict=%@",response);
    });
    
    NSLog(@"%d",[CLLocationManager authorizationStatus]);
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0,0,screenBounds.size.width,screenBounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context,0.3);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)responseAction:(NSDictionary *)responseData {
    
    if([[responseData objectForKey:responseCode]integerValue]==200)
    {
        NSString *updatedNotification=[NSString stringWithFormat:@"%d",([[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]intValue]-1)];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",updatedNotification] forKey:currentUnreadAllNotification];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:currentUnreadAllNotification]integerValue];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        
        if([responseData objectForKey:responseStringAF]!=nil&&[responseData objectForKey:responseStringAF]!=[NSNull null]&&![[responseData objectForKey:responseStringAF] isEqualToString:@""])
        {
            
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:[responseData objectForKey:responseStringAF] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
        else
        {
            UIAlertView *alertview2=[[UIAlertView alloc] initWithTitle:@"" message:@"Some error occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview2 show];
        }
    }
}

#pragma mark - Add Notification label

-(UILabel *)notificationRedLabel:(CGRect)frame
{
    [unreadLabel removeFromSuperview];
    unreadLabel=nil;
    unreadLabel=[[UILabel alloc]initWithFrame:frame];
    [unreadLabel setBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].applicationIconBadgeNumber =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]]integerValue];
    unreadLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]];
    unreadLabel.backgroundColor=[UIColor redColor];
    unreadLabel.layer.cornerRadius=unreadLabel.frame.size.width/2;
    unreadLabel.layer.masksToBounds=YES;
    unreadLabel.textColor=[UIColor whiteColor];
    unreadLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    unreadLabel.textAlignment=NSTextAlignmentCenter;
    unreadLabel.numberOfLines=2;
    unreadLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
    unreadLabel.adjustsFontSizeToFitWidth=YES;
    
    if([[[NSUserDefaults standardUserDefaults ]objectForKey:currentUnreadAllNotification]integerValue]<=0)
    {
        unreadLabel.hidden=true;
    }
    return unreadLabel;
}

-(void)setNotifcationRead:(NSString *)urlHit {
    
    ServerCalls*  callInstance=[ServerCalls instance];
    callInstance.serverCallDelegate=self;
    NSDictionary *notificationInfo =[callInstance afnetworkingPostServerCall:urlHit postdictionary:nil isAPIkeyToken:NO];
    NSLog(@"notificationInfo :%@",notificationInfo);
}

#pragma mark - Set Color for highlighted state

- (UIImage*)setColor:(UIColor *)color buttonframe:(CGRect)frame
{
    UIView *colorView = [[UIView alloc] initWithFrame:frame];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

- (CGFloat)getValueFromTargetSize:(CGFloat)targetSuperviewSize targetSubviewSize:(CGFloat)targetSubviewSize currentSuperviewDeviceSize:(CGFloat)currentSizeOfSuperview
{
//    if(currentSizeOfSuperview==480)
//        currentSizeOfSuperview=568;
        return currentSizeOfSuperview/(targetSuperviewSize/targetSubviewSize);
    
}

#pragma mark - Render ImageView

- (UIImage *)imageOfView:(UIView *)view {
    // This if-else clause used to check whether the device support retina display or not so that
    // we can render image for both retina and non retina devices.
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - Restrict Backup on iCloud
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
@end
