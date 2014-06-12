//
//  FSUsermanager.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FSUserManager : BaseManager

- (void)loginWithUsernameOrEmail:(id<FBGraphUser>)fbUser
                         fbToken:(NSString *)token
                         success:(void (^)(BOOL success))success
                         failure:(void (^)(NSError *error))failure;

- (NSDictionary *)getAuthParams;
- (void)logout;
@end
