//
//  FSUtilityManager.m
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSUtilityManager.h"
#import "ISO8601DateFormatter.h"

#define UPDATE_TIME 15*60*1000

@interface FSUtilityManager()

@property (nonatomic, retain) ISO8601DateFormatter *dateFormatter;

@end

@implementation FSUtilityManager

SINGLETON_MACRO

- (id)init
{
    self  = [super init];
    if(self != nil) {
        self.dateFormatter = [[ISO8601DateFormatter alloc] init];
    }
    return self;
}

- (NSDate *)getISODateFromString:(NSString *)dateString
{
    if (!dateString) {
        return nil;
    }
    if (!self.dateFormatter) {
        self.dateFormatter = [[ISO8601DateFormatter alloc] init];
    }
    
    return [self.dateFormatter dateFromString:dateString];
}

- (BOOL)doesRequireUpdate:(NSDate *)lastUpdateTime
{
    if (![lastUpdateTime isValidObject]) {
        return YES;
    }
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:lastUpdateTime];
    if (timeInterval < UPDATE_TIME) {
        return NO;
    }
    
    return YES;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
@end
