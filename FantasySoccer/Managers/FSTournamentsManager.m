//
//  FSTournamentsManager.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSTournamentsManager.h"

@implementation FSTournamentsManager

SINGLETON_MACRO


- (void)getAllTournamentsOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                           failure:(void (^)(NSError *error))failure
{
    
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:API_TOURNAMENTS parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultArray = [FSTournament populateModelWithData:outputArray];
        success(resultArray);
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    
}

- (void)getMatchesForTournament:(FSTournament *)tournament
                        success:(void (^)(NSMutableArray * resultsArray))success
                        failure:(void (^)(NSError *error))failure
{
    
    NSString *path  = [NSString stringWithFormat:API_MATCHES,tournament.tournamentID];
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:path parameters:nil success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultsArray = [FSMatch populateModelWithData:outputArray];
        success(resultsArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getTopScoresOnSuccess:(void (^)(NSMutableArray * resultsArray))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *params =  @{@"selection":@"draw",
                              @"point":@"3"};
    
    [[FSNetworkManager sharedInstance] getResponseAsArrayForPath:API_TOP_SCORES parameters:params success:^(NSMutableArray *outputArray) {
        
        NSMutableArray *resultsArray = [FSTopScore populateModelWithData:outputArray];
        success(resultsArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
