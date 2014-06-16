//
//  FSMatch.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSMatch : FSBaseModel

@property (nonatomic,retain) NSString * description;
@property (nonatomic, retain) NSNumber * matchID;
@property (nonatomic, retain) NSNumber * lTeamID;
@property (nonatomic, strong) NSNumber * lTeamScore;
@property (nonatomic, retain) NSNumber *published;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * rTeamID;
@property (nonatomic, strong) NSNumber * rTeamScore;
@property (nonatomic, strong) FSBettings *bettings;

@end
