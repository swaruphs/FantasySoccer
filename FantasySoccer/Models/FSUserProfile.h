//
//  FSUserProfile.h
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSUserProfile : FSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSDate *updatedAt;

- (NSString *)getPointsAsString;

@end
