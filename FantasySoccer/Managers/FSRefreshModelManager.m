//
//  FSRefreshModelManager.m
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSRefreshModelManager.h"

@implementation FSRefreshModelManager

//TODO: Implement promise pattern.

- (void)refreshModels
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self getTournaments];
}

- (void)getTournaments
{
    [[FSTournamentsManager sharedInstance] getAllTournamentsOnSuccess:^(NSMutableArray *resultsArray) {
        
        FSTournament *tournament = [[[FSTournamentsManager sharedInstance] tournamentArray] firstObjectOrNil];
        if ([tournament isValidObject]) {
            [self getAllTeamsForTournament:tournament];
        }
        
    } failure:^(NSError *error) {
        DLog(@"failed to get tournaments");
        [SVProgressHUD dismiss];
    }];
}

- (void)getAllTeamsForTournament:(FSTournament *)tournament
{
    [[FSTournamentsManager sharedInstance] getTeamsForTournament:tournament success:^(NSMutableArray *resultsArray) {
        
        [self getUserProfile];
        
    } failure:^(NSError *error) {
        [self getUserProfile];
    }];
}

- (void)getUserProfile
{
    [[FSUserManager sharedInstance] getPlayerProfileWithSuccess:^(FSUserProfile *userProfile) {
        [self notifyDelegate];
    } failure:^(NSError *error) {
        [self notifyDelegate];
    }];
}

-(void)notifyDelegate
{
    [SVProgressHUD dismiss];
    [self.delegate refreshManagerDidFinishRefresh:self];
}
@end
