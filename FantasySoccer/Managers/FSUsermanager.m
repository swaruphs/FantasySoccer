//
//  FSUsermanager.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSUserManager.h"


@interface FSUserManager()

@property (nonatomic,retain) NSString *accessToken;

@end


@implementation FSUserManager

SINGLETON_MACRO

- (void)loginWithUsernameOrEmail:(id<FBGraphUser>)fbUser
                         fbToken:(NSString *)token
                         success:(void (^)(BOOL success))success
                         failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *params = @{@"fb_token":token,
                             @"grant_type":@"password",
                             @"client_id":CLIENT_ID,
                             @"client_secret":CLIENT_SECRET};
    
    [[FSNetworkManager sharedInstance] getRawResponseForPath:API_OAUTH_TOKEN parameters:params method:POST_METHOD success:^(id responseObject) {
        
        NSLog(@"response got is %@",responseObject);
        self.accessToken = responseObject[@"access_token"];
        success(TRUE);
        
        
    } failure:^(NSError *error) {
        NSLog(@"Error is %@",error);
        failure(error);
    }];
}

- (NSDictionary *)getAuthParams
{
    if (!self.accessToken) {
        return nil;
    }
    return @{@"access_token":self.accessToken};
}


- (void)logout
{
    self.accessToken = nil;
}

- (void)notifyUserLogout
{

}
@end
