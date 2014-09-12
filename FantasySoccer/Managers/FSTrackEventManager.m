//
//  FSTrackEventManager.m
//  FantasySoccer
//
//  Created by Swarup on 12/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTrackEventManager.h"

@implementation FSTrackEventManager

SINGLETON_MACRO

- (void)trackEventWithName:(NSString *)name withDimensions:(NSDictionary *)dimensions
{
    [PFAnalytics trackEvent:name dimensions:dimensions];
}

@end
