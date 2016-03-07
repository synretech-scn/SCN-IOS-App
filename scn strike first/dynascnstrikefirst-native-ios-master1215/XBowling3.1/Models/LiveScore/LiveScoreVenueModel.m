//
//  LiveScoreVenueModel.m
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LiveScoreVenueModel.h"
static LiveScoreVenueModel *selectedVenue;

@implementation LiveScoreVenueModel

+(LiveScoreVenueModel *) shared{
    if(!selectedVenue){
        selectedVenue = [[LiveScoreVenueModel alloc] init];
    }
    selectedVenue.showNetworkPopup=1;
    return selectedVenue;
}

- (NSDictionary *)getLiveScore:(NSString *)venueId
{
    NSDictionary *response=[NSDictionary new];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        
        NSString *toDateString = [dateFormat stringFromDate:[NSDate date]];
        
        NSDate *fromDate=[NSDate dateWithTimeInterval:-5400 sinceDate:[NSDate date]];
        NSString *fromDateString=[dateFormat stringFromDate:fromDate];
        fromDateString=[fromDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        toDateString=[toDateString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"toDate=%@  fromDate=%@",toDateString,fromDateString);
        NSString *urlString = [NSString stringWithFormat:@"venue/%@/summarywithscore",venueId];
        NSString *queryParameters=[NSString stringWithFormat:@"to=%@&from=%@&",toDateString,fromDateString];
       response=[[ServerCalls instance]serverCallWithQueryParameters:queryParameters url:urlString contentType:@"" httpMethod:@"GET"];
    }
    else
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (selectedVenue.showNetworkPopup == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                alert=nil;
                selectedVenue.showNetworkPopup =0;
            }
        });
       
        
    }
        return response;
}
@end
