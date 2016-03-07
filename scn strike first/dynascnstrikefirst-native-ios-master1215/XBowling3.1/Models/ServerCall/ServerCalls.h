//
//  ServerCalls.h
//  XBowling 3.0
//
//  Created by Click Labs on 7/4/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"


@protocol serverCallProtocol <NSObject>
@optional
- (void)responseAction:(NSDictionary *)responseData;
@end


@interface ServerCalls : NSObject
@property (weak) id <serverCallProtocol> serverCallDelegate;

+ (ServerCalls *)instance;
- (NSDictionary *)serverCallWithQueryParameters:(NSString *)queryParameters url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod;
- (NSDictionary *)serverCallWithPostParameters:(NSDictionary *)parametersDict url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod;
- (NSDictionary *)asyncServerCallWithQueryParameters:(NSString *)queryParameters url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod;
- (NSDictionary *)serverCallWithPostParameters:(NSDictionary *)parametersDict andQueryParameters:(NSString *)queryParam url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod;
-(NSDictionary*)afnetworkingPostServerCall:(NSString *)enquiryurl postdictionary:(NSDictionary *)postDictionary isAPIkeyToken:(BOOL)appendToken;
- (NSDictionary *)afnetWorkingGetServerCall :(NSString *)url isAPIkeyToken:(BOOL)appendToken;
- (NSDictionary *)serverCallForLoginWithPostParameters:(NSDictionary *)parametersDict url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod;
@end
