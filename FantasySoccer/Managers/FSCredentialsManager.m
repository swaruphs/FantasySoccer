//
//  FSCredentialsManager.m
//  FantasySoccer
//
//  Created by Swarup on 13/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSCredentialsManager.h"

#define USER_TOKEN @"serverToken"
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

@end
