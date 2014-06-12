//
//  FSMatch.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSMatch.h"
#import "ISO8601DateFormatter.h"

@implementation FSMatch

static ISO8601DateFormatter *formatter =  nil;

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.matchID = [jsonDic numberForKey:@"id"];
    self.description = [jsonDic stringForKey:@"description"];
    self.lTeamID = [jsonDic numberForKey:@"lteam_id"];
    self.published = [jsonDic numberForKey:@"published"];
    self.rTeamID = [jsonDic numberForKey:@"rteam_id"];
    self.status = [jsonDic stringForKey:@"status"];

    NSString *dateString = [jsonDic stringForKey:@"start_time"];
    if (formatter == nil) {
        formatter = [[ISO8601DateFormatter alloc] init];
    }
    self.startTime = [formatter dateFromString:dateString];
}




@end
