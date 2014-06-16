//
//  FSBettings.m
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBettings.h"

@implementation FSBettings

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.bettingID = [jsonDic numberForKey:@"id"];
    self.matchID = [jsonDic numberForKey:@"match_id"];
    self.selection  =[jsonDic stringForKey:@"selection"];
    self.points = [jsonDic numberForKey:@"point"];
}

@end
