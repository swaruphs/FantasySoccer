//
//  FSNetworkManager.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"


#define GET_METHOD              @"GET"
#define POST_METHOD             @"POST"
#define PUT_METHOD              @"PUT"
#define DELETE_METHOD           @"DELETE"


@interface FSNetworkManager : BaseManager

- (void)getResponseAsArrayForPath:(NSString *) path
                       parameters:(NSDictionary *) parameters
                          success:(void (^)(NSMutableArray * outputArray))success
                          failure:(void (^)(NSError *error))failure;

- (void)getRawResponseForPath:(NSString *) path
                   parameters:(NSDictionary *) parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

- (void)getRawResponseForPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                       method:(NSString *)method
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure;

-(void)sendRequestWithAbsoluteParams:(NSDictionary *)params
                                path:(NSString *)path
                              method:(NSString*)method
                             success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))failure;

- (void)sendRequestForPath:(NSString*)path
                parameters:(NSDictionary*)parameters
                    method:(NSString*)method
                   success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                   failure:(void (^)(NSError *error))failure;

@end
