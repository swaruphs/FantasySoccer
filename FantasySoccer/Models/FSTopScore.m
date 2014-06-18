//
//  FSTopScore.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTopScore.h"

@implementation FSTopScore

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.topScoreID = [jsonDic numberForKey:@"id"];
    self.name = [jsonDic stringForKey:@"name"];
    self.points = [jsonDic numberForKey:@"point"];
    self.faceBookID = [jsonDic stringForKey:@"fb_id"];
}

@end
