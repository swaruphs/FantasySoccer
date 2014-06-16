//
//  FSBettings.h
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSBettings : FSBaseModel

@property (nonatomic, strong) NSNumber *bettingID;
@property (nonatomic, strong) NSString *selection;
@property (nonatomic, strong) NSNumber *matchID;
@property (nonatomic, strong) NSNumber *points;


@end
