//
//  FSBettingsManager.m
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBettingsManager.h"

@interface FSBettingsManager()

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic) NSUInteger totalPage;
@property (nonatomic) NSUInteger currentPage;

@end

@implementation FSBettingsManager

SINGLETON_MACRO

- (void)postBettingForMatch:(FSMatch *)match
                     points:(NSNumber *)points
                  selection:(NSString *)selection
                    success:(void(^)(FSBettings *success))success
                    failure:(void(^)(NSError *error))failure
{
    if ([match.startTime earlierDate:[NSDate date]] == match.startTime) {
        [SVProgressHUD showErrorWithStatus:@"match is already started"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"point":points,@"selection":selection}];
    NSDictionary *authParams = [[FSUserManager sharedInstance] getAuthParams];
    [params addEntriesFromDictionary:authParams];
    
    NSString *path = [NSString stringWithFormat:API_BETTINGS,match.matchID];
    [[FSNetworkManager sharedInstance] getRawResponseForPath:path parameters:params method:POST_METHOD success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            FSBettings *bettings = [[FSBettings alloc] initWithDictionary:responseObject];
            match.bettings = bettings;
            [[FSUserManager sharedInstance] updatePoints:[points integerValue]];
            success(bettings);
        }
        else{
            success(nil);
        }
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getBettingsHistoryOnSucces:(void(^)(NSMutableArray *resultArray))success
                           failure:(void(^)(NSError *error))failure
{
    NSDictionary *authParams = [[FSUserManager sharedInstance] getAuthParams];
    [[FSNetworkManager sharedInstance] getRawResponseForPath:API_PLAYER_BETTING_HISTORY parameters:authParams success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *allMatchArray = [[FSTournamentsManager sharedInstance] matchesArray];
            NSMutableArray *resultArray = [NSMutableArray array];
            NSDictionary *jsonDic = (NSDictionary *)responseObject;
            NSUInteger totalPages = [[jsonDic numberForKey:@"total_pages"] integerValue];
            NSUInteger currentPage = [[jsonDic numberForKey:@"current_page"] integerValue];
            NSArray *matchArray = [jsonDic arrayForKey:@"matches"];
            for (NSDictionary *matchDic in matchArray) {
                
                NSNumber *matchID = [matchDic numberForKey:@"id"];
                FSMatch *match = [allMatchArray firstObjectWithValue:matchID forKeyPath:@"matchID"];
                if (match) {
                    NSDictionary *bettingJson = matchDic[@"bet"];
                    FSBettings *bettings  = [[FSBettings alloc] initWithDictionary:bettingJson];
                    match.bettings = bettings;
                }
                else {
                    match = [[FSMatch alloc] initWithDictionary:matchDic];
                    [allMatchArray addObject:match];
                }
                [resultArray addObject:match];
            }
            success(resultArray);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (BOOL)hasMoreHistory
{
    if (self.totalPage == self.currentPage) {
        return NO;
    }
    
    return YES;
}

@end
