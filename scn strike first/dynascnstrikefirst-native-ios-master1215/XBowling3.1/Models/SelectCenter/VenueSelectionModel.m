//
//  VenueSelectionModel.m
//  XBowling3.1
//
//  Created by Click Labs on 1/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "VenueSelectionModel.h"
static VenueSelectionModel *selectedVenue;

@implementation VenueSelectionModel
+(VenueSelectionModel *) shared{
    if(!selectedVenue){
        selectedVenue = [[VenueSelectionModel alloc] init];
    }
    return selectedVenue;
}

- (NSDictionary *)laneCheckout
{
    NSString *laneString;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:kscoringType] isEqualToString:@"Manual"]) {
        laneString = @"manuallanecheckout";
    }
    else{
        laneString = @"lanecheckout";
    }    NSLog(@"lanecheckout");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *venueId = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:kvenueId] intValue]];
    NSDictionary *venueDict = [[NSDictionary alloc] initWithObjectsAndKeys:venueId, @"id", nil];
//    NSString *bowlerName=[[NSString stringWithFormat:@"%@",[userDefaults stringForKey:kbowlerName]]stringByReplacingOccurrencesOfString:@" " withString:@"+"];
     NSString *bowlerName=[NSString stringWithFormat:@"%@",[userDefaults stringForKey:kbowlerName]];
    NSString *laneNumber = [NSString stringWithFormat:@"%d",[[userDefaults objectForKey:klaneNumber] intValue]];
    NSString *centername = [userDefaults objectForKey:kcenterName];
    NSString *competitionType = [userDefaults objectForKey:kCompetitionTypeId];
    if([[NSString stringWithFormat:@"%@",competitionType] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kCompetitionTypeId];
        competitionType=@"0";
    }
    NSString *patternLengthId= [userDefaults objectForKey:kPatternLengthId];
    if([[NSString stringWithFormat:@"%@",patternLengthId] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternLengthId];
        patternLengthId=@"0";
    }
    NSString *patternNameId=[userDefaults objectForKey:kPatternNameId];
    if([[NSString stringWithFormat:@"%@",patternNameId] isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kPatternNameId];
        patternNameId=@"0";
    }
    NSLog(@"venueId %@ bowlerName %@ laneNumber %@ centerName %@ ",venueId, bowlerName, laneNumber, centername );
    
    NSDate *currentDate=[NSDate date];
    NSLog(@"currentDate=%@",currentDate);
    NSString *format=@"MM/dd/yyyy HH:mm:ss";
    NSDateFormatter *formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone localTimeZone]];
    NSString *displayDate=[formatterUtc stringFromDate:currentDate];
    NSLog(@"displayDate=%@",displayDate);
    
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:venueDict, @"venue",bowlerName, @"bowlerName", laneNumber, @"laneNumber", centername, @"venueName",competitionType,@"CompetitionTypeId",patternLengthId,@"UserStatPatternLengthId",patternNameId,@"UserStatPatternNameId",displayDate,@"CreatedDate",  nil];
    
    NSDictionary *json=[[ServerCalls instance]serverCallWithPostParameters:postDict url:laneString contentType:@"application/json" httpMethod:@"POST"];
    return json;
}

@end
