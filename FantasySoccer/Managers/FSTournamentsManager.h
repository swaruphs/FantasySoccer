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


@property (nonatomic, strong) NSArray *tournamentArray;
@property (nonatomic, strong) NSArray *teamArray;
@property (nonatomic, strong) NSMutableArray *matchesArray;
@property (nonatomic, strong) NSMutableArray * topScoreArray;

- (void)getAllTournamentsOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                           failure:(void (^)(NSError *error))failure;


- (void)getMatchesForTournament:(FSTournament *)tournament
                      fromCache:(BOOL)fromCache
                        success:(void (^)(NSMutableArray * resultsArray))success
                        failure:(void (^)(NSError *error))failure;

- (void)getTopScoresFromCache:(BOOL)cache
                      success:(void (^)(NSMutableArray * resultsArray))success
                      failure:(void (^)(NSError *error))failure;

- (void)getTeamsForTournament:(FSTournament *)tournament
                      success:(void (^)(NSMutableArray *resultsArray))success
                      failure:(void (^)(NSError *error))failure;

- (void)postBettingForMatch:(FSMatch *)match
                     points:(NSNumber *)points
                  selection:(NSString *)selection
                    success:(void(^)(BOOL success))success
                    failure:(void(^)(NSError *error))failure;

- (void)clearSavedData;
@end
