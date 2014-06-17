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
@implementation FSCredentialsManager

SINGLETON_MACRO

- (void)saveAccessToken:(NSString *)token
{
    if ([token isValidObject]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:USER_TOKEN];
    }
}

- (void)clearSavedToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_TOKEN];
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
    }
}

- (NSString *)getFBID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_FB_ID];
}

@end
