//
//  FSTeam.m
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTeam.h"

@implementation FSTeam

-(void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.name            = [jsonDic stringForKey:@"name"];
    self.teamDescription     = [jsonDic stringForKey:@"description"];
    self.iconURL         = [jsonDic stringForKey:@"icon_url"];
    self.teamID          = [jsonDic numberForKey:@"id"];

    NSString *dateString = [jsonDic stringForKey:@"updated_at"];
    self.updatedAt       = [[FSUtilityManager sharedInstance] getISODateFromString:dateString];
}
@end
