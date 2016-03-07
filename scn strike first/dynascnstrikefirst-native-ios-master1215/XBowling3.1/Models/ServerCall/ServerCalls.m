//
//  ServerCalls.m
//  XBowling 3.0
//
//  Created by Click Labs on 7/4/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "ServerCalls.h"
#import "Keys.h"
#import "DataManager.h"

static ServerCalls *serverCall;

@implementation ServerCalls

+ (ServerCalls *)instance{
    if(!serverCall){
        serverCall = [[ServerCalls alloc] init];
    }
    return serverCall;
}

- (NSDictionary *)serverCallWithQueryParameters:(NSString *)queryParameters url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod
{
    NSDictionary *responseDict;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString=[NSString stringWithFormat:@"%@%@?%@token=%@&apiKey=%@",serverAddress,url,queryParameters,token,APIKey];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",httpMethod]];
        if(contentType.length > 0)
            [URLrequest setValue:[NSString stringWithFormat:@"%@",contentType] forHTTPHeaderField:@"Content-Type"];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
//        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:URLrequest];
//        NSLog(@"responseString = %@",[[NSString alloc] initWithData:[cachedResponse data] encoding:NSUTF8StringEncoding]);

        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(responseData)
        {
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
            if(!json)
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:responseString,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
            else
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        else
        {
            responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    
    return responseDict;
}
- (NSDictionary *)serverCallWithPostParameters:(NSDictionary *)parametersDict url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod
{
    NSDictionary *responseDict;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        
//        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:parametersDict,@"",nil];
        NSError *error = NULL;
        NSData* data = [NSJSONSerialization dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"dict=%@",parametersDict);
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataString=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,url,token,APIKey];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",httpMethod]];
        [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [URLrequest setValue:[NSString stringWithFormat:@"%@",contentType] forHTTPHeaderField:@"Content-Type"];
        [URLrequest setHTTPBody:postdata];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        NSString *responseStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseStr);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(responseData)
        {
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
            if(!json)
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:responseStr,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
            else
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        else
        {
            responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
//        [responseDict setObject:responseStr forKey:@"responseString"];
//        [responseDict setObject:[NSString stringWithFormat:@"%d",response.statusCode] forKey:@"responseStatusCode"];
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    NSLog(@"responseDict %@",responseDict);

    return responseDict;
}

- (NSDictionary *)serverCallWithPostParameters:(NSDictionary *)parametersDict andQueryParameters:(NSString *)queryParam url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod
{
    NSDictionary *responseDict;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        
        //        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:parametersDict,@"",nil];
        NSError *error = NULL;
        NSData* data = [NSJSONSerialization dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"dict=%@",parametersDict);
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataString=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString=[NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@&%@",serverAddress,url,token,APIKey,queryParam];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",httpMethod]];
        [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [URLrequest setValue:[NSString stringWithFormat:@"%@",contentType] forHTTPHeaderField:@"Content-Type"];
        [URLrequest setHTTPBody:postdata];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        NSString *responseStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseStr);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(responseData)
        {
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
            if(!json)
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:responseStr,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
            else
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        else
        {
            responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        //        [responseDict setObject:responseStr forKey:@"responseString"];
        //        [responseDict setObject:[NSString stringWithFormat:@"%d",response.statusCode] forKey:@"responseStatusCode"];
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    NSLog(@"responseDict %@",responseDict);
    
    return responseDict;
}


- (NSDictionary *)serverCallForLoginWithPostParameters:(NSDictionary *)parametersDict url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod
{
    NSDictionary *responseDict;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        
        //        NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:parametersDict,@"",nil];
        NSError *error = NULL;
        NSData* data = [NSJSONSerialization dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"dict=%@",parametersDict);
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataString=%@",dataString);
        NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
        NSString *urlString=[NSString stringWithFormat:@"%@%@",serverAddress,url];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",httpMethod]];
        [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [URLrequest setValue:[NSString stringWithFormat:@"%@",contentType] forHTTPHeaderField:@"Content-Type"];
        [URLrequest setHTTPBody:postdata];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        NSString *responseStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseStr);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(responseData)
        {
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
            if(!json)
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:responseStr,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
            else
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        else
        {
            responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"responseString",[NSString stringWithFormat:@"%ld",(long)response.statusCode],@"responseStatusCode", nil];
        }
        //        [responseDict setObject:responseStr forKey:@"responseString"];
        //        [responseDict setObject:[NSString stringWithFormat:@"%d",response.statusCode] forKey:@"responseStatusCode"];
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    NSLog(@"responseDict %@",responseDict);
    
    return responseDict;
}


- (NSDictionary *)asyncServerCallWithQueryParameters:(NSString *)queryParameters url:(NSString *)url contentType:(NSString *)contentType httpMethod:(NSString *)httpMethod
{
    __block NSDictionary *responseDict;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *urlString=[NSString stringWithFormat:@"%@%@?%@token=%@&apiKey=%@",serverAddress,url,queryParameters,token,APIKey];
        NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:kTimeoutInterval];
        NSLog(@"requestURL=%@",urlString);
        [URLrequest setHTTPMethod:[NSString stringWithFormat:@"%@",httpMethod]];
        if(contentType.length > 0)
            [URLrequest setValue:[NSString stringWithFormat:@"%@",contentType] forHTTPHeaderField:@"Content-Type"];
        NSError *error1=nil;
        NSHTTPURLResponse *response=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error1];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:URLrequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = (int)[httpResponse statusCode];
            NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            //        NSLog(@"responseString = %@",responseString);
            NSLog(@"statusCode=%ld",(long)statusCode);
            if(responseData)
            {
                NSError *error1;
                NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
                if(!json)
                    responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:responseString,@"responseString",[NSString stringWithFormat:@"%ld",(long)statusCode],@"responseStatusCode", nil];
                else
                    responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:json,@"responseString",[NSString stringWithFormat:@"%ld",(long)statusCode],@"responseStatusCode", nil];
            }
            else
            {
                responseDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"responseString",[NSString stringWithFormat:@"%ld",(long)statusCode],@"responseStatusCode", nil];
            }
        }];
    }
    else
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    return responseDict;
   
}

#pragma mark - AFHTTP Call

-(NSDictionary*)afnetworkingPostServerCall:(NSString *)urlAppend postdictionary:(NSDictionary *)postDictionary isAPIkeyToken:(BOOL)APIkeyAppend
{
    __block NSDictionary *responseDic;
    NSDictionary *postDic=[[NSDictionary alloc]init];
    NSString *urlHit;
    
    if(APIkeyAppend)
    {
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,urlAppend,token,apiKey];
        NSLog(@"postDictionary :%@",postDictionary);
        postDic=postDictionary;
    }
    else{
        urlHit=urlAppend;
        postDic=postDictionary;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@",urlHit] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject) {
            NSLog(@"responseObject :%@",responseObject);
            NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
            responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],responseCode,operation.responseString,responseStringAF,responseObject,responseDataDic, nil];
            [self.serverCallDelegate responseAction:responseDic];
        }
        else {
            NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
            responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],responseCode,operation.responseString,responseStringAF,operation.responseObject,responseDataDic, nil];
            [self.serverCallDelegate responseAction:responseDic];
        }
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [[DataManager shared]removeActivityIndicator];
              responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],
                           responseCode,operation.responseString,responseStringAF,operation.responseObject,responseDataDic, nil];
              if(operation.response.statusCode==0)
              {
                  UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to server, please check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  
                  [al show];
              }
              else
              {
                  [self.serverCallDelegate responseAction:responseDic];
              }
              NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
          }];
    
    return responseDic;
}

#pragma mark - Get Call AFHTTP

- (NSDictionary *)afnetWorkingGetServerCall :(NSString *)urlAppend isAPIkeyToken:(BOOL)APIkeyAppend
{
    __block NSDictionary *responseDic;
    NSString *urlHit;
    
    if(APIkeyAppend)
    {
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        urlHit = [NSString stringWithFormat:@"%@%@?token=%@&apiKey=%@",serverAddress,urlAppend,token,apiKey];
    }
    else{
        urlHit=urlAppend;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@",urlHit] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"responseObject :%@",responseObject);
        
        if(responseObject)
        {
            NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
            
            responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],responseCode,operation.responseString,responseStringAF,responseObject,responseDataDic, nil];
            [self.serverCallDelegate responseAction:responseDic];
        }
        else {
            NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
            responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],responseCode,operation.responseString,responseStringAF,responseObject,responseDataDic, nil];
            [self.serverCallDelegate responseAction:responseDic];
        }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [[DataManager shared] removeActivityIndicator];
             NSLog(@"statusCode :%ld",(long)operation.response.statusCode);
             NSLog(@"%@",operation.responseString);
             NSLog(@"%@",operation.responseObject);
            responseDic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)operation.response.statusCode],responseCode,operation.responseString,responseStringAF,operation.responseObject,responseDataDic, nil];
             if(operation.response.statusCode==0)
             {
                 UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to server, please check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [al show];
             }
             else
             {
                 [self.serverCallDelegate responseAction:responseDic];
             }
             
         }];
    
    return  responseDic;
    
}


@end
