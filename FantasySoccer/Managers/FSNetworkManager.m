//
//  FSNetworkManager.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSNetworkManager.h"
#import "AFNetworking.h"
#import "FSReachabilityManager.h"

@interface FSNetworkManager ()

@property (nonatomic, strong) AFHTTPClient *httpClient;

@end


@implementation FSNetworkManager

SINGLETON_MACRO

- (id)init
{
    if(self = [super init]) {
        NSURL *baseURL = [NSURL URLWithString:API_SERVER_HOST];
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return self;
}


#pragma mark  - Methods for network calls

- (void)getResponseAsArrayForPath :  (NSString *) path
                       parameters :(NSDictionary *) parameters
                           success:(void (^)(NSMutableArray * outputArray))success
                           failure:(void (^)(NSError *error))failure;
{
    [self sendRequestForPath:path parameters:parameters method:GET_METHOD success:^(NSHTTPURLResponse *response, id responseObject) {
        
        if([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithArray:responseObject];
            success(array);
            return;
        }
        success (nil);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getRawResponseForPath : (NSString *) path
                   parameters :(NSDictionary *) parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    [self sendRequestForPath:path parameters:parameters method:GET_METHOD success:^(NSHTTPURLResponse *response, id responseObject){
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)getRawResponseForPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                       method:(NSString *)method
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure
{
    [self sendRequestForPath:path parameters:parameters method:method success:^(NSHTTPURLResponse *response, id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)sendRequestForPath :(NSString *) path
                parameters :(NSDictionary *) parameters
                    success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    [self sendRequestForPath:path
                  parameters:parameters
                      method:GET_METHOD
                     success:success
                     failure:failure];
}

-(void)sendRequestWithAbsoluteParams:(NSDictionary *)params
                                path:(NSString *)path
                              method:(NSString*)method
                             success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    if ([method length] <= 0){
        method = GET_METHOD;
    }
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:method path:path parameters:params];
    [self.httpClient setParameterEncoding:AFJSONParameterEncoding];
    [self sendRequest:request success:success failure:failure];
}


- (void)sendRequestForPath:(NSString*)path
                parameters:(NSDictionary*)parameters
                    method:(NSString*)method
                   success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    if ([method length] <= 0){
        method = GET_METHOD;
    }
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:method path:path parameters:parameters];
    [self.httpClient setParameterEncoding:AFJSONParameterEncoding];
    [self sendRequest:request success:success failure:failure];
}



- (void)sendRequest:(NSURLRequest *)request
            success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    
    AFJSONRequestOperation *operation =    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        BOOL hasError = [self handleServerError:json response:response failure:failure];
        if (hasError){
            return;
        }
        if (success){
            success(response, json);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        BOOL handled = [self handleServerError:responseObject response:response failure:failure];
        if (!handled && failure != nil){
            failure(error);
        }
    }];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [self.httpClient enqueueHTTPRequestOperation:operation];
}



#pragma mark  -  Private Helper Methods

- (BOOL)handleServerError:(NSDictionary*)json response:(NSHTTPURLResponse*)response failure:(void (^)(NSError *error))failure
{
    if (response.statusCode >= 200 &&  response.statusCode <= 299) {
        return NO;
    }
    else if (response.statusCode == 401) {
        FSAppDelegate *appDeleate = [[UIApplication sharedApplication] delegate];
        [appDeleate logoutWithMessage:@"Token expired. Try login again"];
        return YES;
    }
    else {
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSNumber *error_code = [json numberForKey:@"error_code"];
            if ([error_code isValidObject]) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[json stringForKey:@"message"]};
                NSError *error = [NSError errorWithDomain:@"" code:[error_code integerValue] userInfo:userInfo];
                if (failure) {
                    failure(error);
                }
                return YES;
            }
         }
    }
    return NO;
}
@end
