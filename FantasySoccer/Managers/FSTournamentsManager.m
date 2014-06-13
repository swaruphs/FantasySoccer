//
//  FSTournamentsManager.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTournamentsManager.h"



@interface FSTournamentsManager()

@property (nonatomic, strong) NSDate *topScoresLastUpdatedTime;
@property (nonatomic, strong) NSDate *matchesLastUpdatedTime;

@end


@implementation FSTournamentsManager

SINGLETON_MACRO


- (void)getAllTournamentsOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                           failure:(void (^)(NSError *error))failure
{
    
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:API_TOURNAMENTS parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultArray = [FSTournament populateModelWithData:outputArray];
        self.tournamentArray = resultArray;
        success(resultArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}

- (void)getMatchesForTournament:(FSTournament *)tournament
                      fromCache:(BOOL)fromCache
                        success:(void (^)(NSMutableArray * resultsArray))success
                        failure:(void (^)(NSError *error))failure
{
    BOOL update = [[FSUtilityManager sharedInstance] doesRequireUpdate:self.matchesLastUpdatedTime];
    if (fromCache == YES && !update && [self.matchesArray isValidObject]) {
        success(self.matchesArray);
        return;
    }
    [self getMatchesForTournament:tournament success:success failure:failure];
}

- (void)getMatchesForTournament:(FSTournament *)tournament
                        success:(void (^)(NSMutableArray * resultsArray))success
                        failure:(void (^)(NSError *error))failure
{
    
    NSString *path  = [NSString stringWithFormat:API_MATCHES,tournament.tournamentID];
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:path parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultsArray = [FSMatch populateModelWithData:outputArray];
        self.matchesLastUpdatedTime = [NSDate date];
        self.matchesArray = resultsArray;
        success(resultsArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)getTopScoresFromCache:(BOOL)cache
                      success:(void (^)(NSMutableArray * resultsArray))success
                      failure:(void (^)(NSError *error))failure
{
    BOOL doesRequireUpdate = [[FSUtilityManager sharedInstance] doesRequireUpdate:self.topScoresLastUpdatedTime];
    if (cache && !doesRequireUpdate && [self.topScoreArray isValidObject]) {
        success(self.topScoreArray);
        return;
    }
    [self getTopScoresOnSuccess:success failure:failure];
}


- (void)getTopScoresOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                      failure:(void (^)(NSError *error))failure
{
    
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:API_TOP_SCORES parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultsArray = [FSTopScore populateModelWithData:outputArray];
        self.topScoreArray = resultsArray;
        self.topScoresLastUpdatedTime = [NSDate date];
        success(resultsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getTeamsForTournament:(FSTournament *)tournament
                      success:(void (^)(NSMutableArray *resultsArray))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *path  = [NSString stringWithFormat:API_TOURNAMENTS_TEAMS,tournament.tournamentID];
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:path parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultArray = [FSTeam populateModelWithData:outputArray];
        self.teamArray = resultArray;
        success(resultArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)postBettingForMatch:(FSMatch *)match
                     points:(NSNumber *)points
                  selection:(NSString *)selection
                    success:(void(^)(BOOL success))success
                    failure:(void(^)(NSError *error))failure
{
    if ([match.startTime earlierDate:[NSDate date]] == match.startTime) {
        [SVProgressHUD showErrorWithStatus:@"match is already started"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"point":points,@"selection":selection}];
    NSDictionary *authParams = [[FSUserManager sharedInstance] getAuthParams];
    [params addEntriesFromDictionary:authParams];
    
    NSString *path = [NSString stringWithFormat:API_BETTINGS,@"1"];
    [[FSNetworkManager sharedInstance] getRawResponseForPath:path parameters:params method:POST_METHOD success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)clearSavedData
{
    self.tournamentArray = nil;
    self.teamArray =  nil;
}
@end
