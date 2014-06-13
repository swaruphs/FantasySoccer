//
//  FSUserProfile.m
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSUserProfile.h"

@implementation FSUserProfile

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.userID          = [jsonDic numberForKey:@"id"];
    self.userName        = [jsonDic stringForKey:@"name"];
    self.points          = [jsonDic numberForKey:@"point"];

    NSString *dateString = [jsonDic stringForKey:@"updated_at"];
    self.updatedAt       = [[FSUtilityManager sharedInstance] getISODateFromString:dateString];
}

@end
