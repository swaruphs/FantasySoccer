//
//  FSTournamentsManager.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"
#import "FSTournament.h"

@interface FSTournamentsManager : BaseManager


- (void)getAllTournamentsOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                           failure:(void (^)(NSError *error))failure;

- (void)getMatchesForTournament:(FSTournament *)tournament
                        success:(void (^)(NSMutableArray * resultsArray))success
                        failure:(void (^)(NSError *error))failure;

- (void)getTopScoresOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                      failure:(void (^)(NSError *error))failure;


@end
