//
//  FSBettingsManager.h
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"

@interface FSBettingsManager : BaseManager

- (void)postBettingForMatch:(FSMatch *)match
                     points:(NSNumber *)points
                  selection:(NSString *)selection
                    success:(void(^)(FSBettings *success))success
                    failure:(void(^)(NSError *error))failure;

- (void)getBettingsHistoryOnSucces:(void(^)(NSMutableArray *resultArray))success
                           failure:(void(^)(NSError *error))failure;
@end
