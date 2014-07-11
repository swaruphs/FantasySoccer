//
//  FSCredentialsManager.m
//  FantasySoccer
//
//  Created by Swarup on 13/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSCredentialsManager.h"

#define USER_TOKEN @"serverToken"
#define USER_FB_ID @"fbID"
#define USER_FIRST_TIME @"firstTimeUser"
@implementation FSCredentialsManager

SINGLETON_MACRO

- (void)saveAccessToken:(NSString *)token
{
    if ([token isValidObject]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:USER_TOKEN];
        [userDefaults synchronize];
    }
}

- (void)clearSavedToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_TOKEN];
    [userDefaults removeObjectForKey:USER_FB_ID];
    [userDefaults synchronize];
}

- (NSString *)getSavedToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_TOKEN];
}

-(void)saveFBID:(NSString *)fbID
{
    if ([fbID isValidObject]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:fbID forKey:USER_FB_ID];
        [userDefaults synchronize];
    }
}

- (NSString *)getFBID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_FB_ID];
}

- (BOOL)isFirstTimeLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:USER_FIRST_TIME];
}

- (void)markFirstTimeLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(TRUE) forKey:USER_FIRST_TIME];
    [userDefaults synchronize];
}
@end

