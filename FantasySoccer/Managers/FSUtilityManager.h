//
//  FSUtilityManager.h
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"

@interface FSUtilityManager : BaseManager

- (NSDate *)getISODateFromString:(NSString *)dateString;
- (BOOL)doesRequireUpdate:(NSDate *)lastUpdateTime;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
