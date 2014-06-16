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
        self.accessToken = [responseObject stringForKey:@"access_token"];
        [[FSCredentialsManager sharedInstance] saveAccessToken:self.accessToken];
        success(TRUE);
        
        
    } failure:^(NSError *error) {
        NSLog(@"Error is %@",error);
        failure(error);
    }];
}

- (void)getPlayerProfileWithSuccess:(void (^)(FSUserProfile * userProfile))success
                            failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [self getAuthParams];
    [[FSNetworkManager sharedInstance] getRawResponseForPath:API_PLAYER_PROFILE parameters:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
            FSUserProfile *profile = [[FSUserProfile alloc] initWithDictionary:responseObject];
            self.userProfile  = profile;
            success(profile);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSDictionary *)getAuthParams
{
    if (![[FSCredentialsManager sharedInstance] getSavedToken]) {
        return nil;
    }
    NSString *token = [[FSCredentialsManager sharedInstance] getSavedToken];
    return @{@"access_token":token};
}

- (void)logout
{
    self.accessToken = nil;
    [[FSCredentialsManager sharedInstance] clearSavedToken];
}

- (void)notifyUserLogout
{
    
}

- (void)clearUserProfile
{
    self.accessToken = nil;
    self.userProfile =  nil;
}

- (BOOL)updatePoints:(NSUInteger)points
{
    if (self.userProfile) {
       NSUInteger userpoints =  [self.userProfile.points integerValue];
        userpoints = userpoints - points;
        self.userProfile.points =  @(userpoints);
        return  TRUE;
    }
    return FALSE;
}

@end
