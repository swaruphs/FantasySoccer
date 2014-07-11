//
//  FSCredentialsManager.h
//  FantasySoccer
//
//  Created by Swarup on 13/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"

@interface FSCredentialsManager : BaseManager

- (void)saveAccessToken:(NSString *)accessToken;
- (NSString *)getSavedToken;
- (void)clearSavedToken;

- (void)saveFBID:(NSString *)fbID;
- (NSString *)getFBID;
- (BOOL)isFirstTimeLogin;
- (void)markFirstTimeLogin;


@end
