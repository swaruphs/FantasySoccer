//
//  FSTournament.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTournament.h"

@implementation FSTournament

-(void)updateWithDictionary:(NSDictionary *)jsonDic
{
    self.tournamentID  = [jsonDic numberForKey:@"id"];
    self.title = [jsonDic stringForKey:@"title"];
    self.tournamentDescription = [jsonDic stringForKey:@"description"];
}
@end
