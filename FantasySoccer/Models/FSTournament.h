//
//  FSTournament.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTournament : FSBaseModel

@property (nonatomic, strong) NSNumber *tournamentID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tournamentDescription;

@end
