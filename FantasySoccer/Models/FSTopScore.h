//
//  FSTopScore.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSTopScore : FSBaseModel

@property (nonatomic, retain) NSNumber *topScoreID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *points;
@property (nonatomic, retain) NSString *faceBookID;


@end
