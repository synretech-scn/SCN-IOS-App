//
//  SelectCenterModel.m
//  XBowling3.1
//
//  Created by Click Labs on 12/17/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "SelectCenterModel.h"
static SelectCenterModel *selectCenter;
@implementation SelectCenterModel
{
    NSArray *centersArray;
    NSArray *venuesArray;
    int selectedCountryIndex,selectedStateIndex,selectedCenterIndex;
}

+(SelectCenterModel *) shared{
    if(!selectCenter){
        selectCenter = [[SelectCenterModel alloc] init];
    }
    return selectCenter;
}

- (NSArray *)getAllVenues:(NSString *)scoringType
{
    venuesArray=[[NSArray alloc]init];
    NSDictionary *json;
    if ([scoringType isEqualToString:@"Machine"]) {
         json=[[ServerCalls instance]serverCallWithQueryParameters:@"scoringType=Machine&" url:@"venue/locations" contentType:@"" httpMethod:@"GET"];
    }
    else if ([scoringType isEqualToString:@"Wallet"])
    {
        json=[[ServerCalls instance]serverCallWithQueryParameters:@"PilotGroup=1&" url:@"venue/Restrictedlocations" contentType:@"" httpMethod:@"GET"];
    }
    else
    {
        json=[[ServerCalls instance]serverCallWithQueryParameters:@"" url:@"venue/locations" contentType:@"" httpMethod:@"GET"];
    }
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            venuesArray=[json objectForKey:kResponseString];
        }
    }
    return venuesArray;
}

- (NSArray*)getAllCentersForCountry:(NSString *)country State:(NSString *)state ScoringType:(NSString *)scoringType
{
    centersArray=[[NSArray alloc]init];
    NSDictionary *json;
    if ([scoringType isEqualToString:@"Machine"]) {
      json=[[ServerCalls instance]serverCallWithQueryParameters:@"scoringType=Machine&" url:[NSString stringWithFormat:@"venue/locations/%@/%@",[country stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[state stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] contentType:@"" httpMethod:@"GET"];
    }
    else if ([scoringType isEqualToString:@"Wallet"])
    {
          json=[[ServerCalls instance]serverCallWithQueryParameters:@"PilotGroup=1&" url:[NSString stringWithFormat:@"venue/Restrictedlocations/%@/%@",[country stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[state stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] contentType:@"" httpMethod:@"GET"];
    }
    else
    {
        json=[[ServerCalls instance]serverCallWithQueryParameters:@"" url:[NSString stringWithFormat:@"venue/locations/%@/%@",[country stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[state stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] contentType:@"" httpMethod:@"GET"];
    }
    if ([[json objectForKey:kResponseStatusCode] integerValue] == 200) {
        if([json objectForKey:kResponseString])
        {
            centersArray=[json objectForKey:kResponseString];
        }
    }
    return centersArray;
}

-(void)geolocationServerCall
{
    double latitude;
    double longitude;
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *urlString;
    NSMutableURLRequest *request;
    urlString=[NSString stringWithFormat:@"%@geolocation",serverAddress];
    
    NSLog(@"urlString %@",urlString);
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
               
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
               
                                  timeoutInterval:kTimeoutInterval];
    NSDictionary *locationsdata;
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        locationsdata = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        latitude = [[locationsdata objectForKey:@"latitude"] doubleValue];
        longitude =[[locationsdata objectForKey:@"longitude"] doubleValue];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",latitude] forKey:kLatitude];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",longitude] forKey:kLongitude];
    }
}

- (NSMutableArray*)getNearbyCenterIndex:(NSString *)scoringType
{
    NSMutableArray *indexArray=[NSMutableArray new];
    double latitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLatitude] floatValue];
    double longitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLongitude] floatValue];
//    if (latitude == 0.0000 && longitude == 0.0000) {
////        [self geolocationServerCall];
//        latitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLatitude] floatValue];
//        longitude=[[[NSUserDefaults standardUserDefaults]objectForKey:kLongitude] floatValue];
//    }
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSMutableURLRequest *request;
    NSString *urlString;
    if ([scoringType isEqualToString:@"Machine"]) {
//        urlString = [NSString stringWithFormat:@"%@venue/nearby?apiKey=%@&token=%@&latitude=%@&longitude=%@&distanceLimitMiles=25", serverAddress, APIKey, token, @"33.9875", @"-83.8919"];
        urlString = [NSString stringWithFormat:@"%@venue/nearby?apiKey=%@&token=%@&latitude=%f&longitude=%f&distanceLimitMiles=25&scoringType=Machine", serverAddress, APIKey, token, latitude, longitude];
    }
    else
    {
//        urlString = [NSString stringWithFormat:@"%@venue/nearby?apiKey=%@&token=%@&latitude=%@&longitude=%@&distanceLimitMiles=25", serverAddress, APIKey, token, @"27.664827", @"-81.515754"];
         urlString = [NSString stringWithFormat:@"%@venue/nearby?apiKey=%@&token=%@&latitude=%f&longitude=%f&distanceLimitMiles=25", serverAddress, APIKey, token, latitude, longitude];
    }
    NSLog(@"urlstring %@", urlString);
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:kTimeoutInterval];
    [request setHTTPMethod: @"GET"];
    NSError *error;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (data)
    {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if ([json count] >0) {
            NSLog(@"center %@",[[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"longName"]);
            NSString *state = [[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"administrativeArea"] objectForKey:@"longName"];
            NSString *country = [[[[json objectAtIndex:0] objectForKey:@"address"] objectForKey:@"country"] objectForKey:@"countryDisplayName"];
            NSString *center = [[json objectAtIndex:0]  objectForKey:@"name"] ;
            NSLog(@"country %@, state %@, center %@", country, state, center);
            NSMutableArray *countryArray = [[NSMutableArray alloc] init];
            NSMutableArray *stateArray = [[NSMutableArray alloc] init];
            NSMutableArray *centerArray = [[NSMutableArray alloc] init];
            if(venuesArray.count > 0)
            {
                for (int i = 0; i<[venuesArray count]; i++) {
                    [countryArray addObject:[[venuesArray objectAtIndex:i] objectForKey:@"displayName"]];
                }
                if ([countryArray containsObject:country]) {
                    selectedCountryIndex = (int)[countryArray indexOfObject:country];
                }
                else
                    selectedCountryIndex = 0;
                [indexArray addObject:[NSString stringWithFormat:@"%d",selectedCountryIndex]];
                
                for (int i = 0; i<[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count]; i++) {
                    [stateArray addObject:[[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:i] objectForKey:@"displayName"]];
                }
                if ([stateArray containsObject:state]) {
                    selectedStateIndex =(int) [stateArray indexOfObject:state];
                }
                else
                    selectedStateIndex = 0;
                [indexArray addObject:[NSString stringWithFormat:@"%d",selectedStateIndex]];
                [self getAllCentersForCountry:[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"] ScoringType:scoringType];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCenterInformation" object:nil];
                if(centersArray.count >0)
                {
                    for (int i = 0; i<[centersArray count]; i++) {
                        [centerArray addObject:[[centersArray objectAtIndex:i] objectForKey:@"name"]];
                    }
                    if ([centerArray containsObject:center]) {
                        selectedCenterIndex =(int) [centerArray indexOfObject:center];
                    }
                    else
                        selectedCenterIndex = 0;
                    [indexArray addObject:[NSString stringWithFormat:@"%d",selectedCenterIndex]];
                }
            }
        }
    }
    
    return indexArray;
}

- (NSArray *)updatedCenterArray
{
    return centersArray;
}

- (NSMutableArray *)setInitialVenue:(NSString *)country state:(NSString *)state center:(NSString *)center
{
    NSMutableArray *indexArray=[NSMutableArray new];

    NSMutableArray *countryArray = [[NSMutableArray alloc] init];
    NSMutableArray *stateArray = [[NSMutableArray alloc] init];
    NSMutableArray *centerArray = [[NSMutableArray alloc] init];
    if(venuesArray.count > 0)
    {
        for (int i = 0; i<[venuesArray count]; i++) {
            [countryArray addObject:[[venuesArray objectAtIndex:i] objectForKey:@"displayName"]];
        }
        if ([countryArray containsObject:country]) {
            selectedCountryIndex = (int)[countryArray indexOfObject:country];
        }
        else
            selectedCountryIndex = 0;
        [indexArray addObject:[NSString stringWithFormat:@"%d",selectedCountryIndex]];
        
        for (int i = 0; i<[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] count]; i++) {
            [stateArray addObject:[[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:i] objectForKey:@"displayName"]];
        }
        if ([stateArray containsObject:state]) {
            selectedStateIndex =(int) [stateArray indexOfObject:state];
        }
        else
            selectedStateIndex = 0;
        [indexArray addObject:[NSString stringWithFormat:@"%d",selectedStateIndex]];
        [self getAllCentersForCountry:[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"displayName"] State:[[[[venuesArray objectAtIndex:selectedCountryIndex] objectForKey:@"states"] objectAtIndex:selectedStateIndex] objectForKey:@"displayName"] ScoringType:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCenterInformation" object:nil];
        if(centersArray.count >0)
        {
            for (int i = 0; i<[centersArray count]; i++) {
                [centerArray addObject:[[centersArray objectAtIndex:i] objectForKey:@"name"]];
            }
            if ([centerArray containsObject:center]) {
                selectedCenterIndex =(int) [centerArray indexOfObject:center];
            }
            else
                selectedCenterIndex = 0;
            [indexArray addObject:[NSString stringWithFormat:@"%d",selectedCenterIndex]];
        }
    }
    return indexArray;
}
@end
