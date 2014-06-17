//
//  FSFixturesViewController.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesViewController.h"
#import "FSLeaderBoardViewController.h"
#import "FSFixturesCell.h"
#import "UIImage+BlurAdditions.h"
#import "FSBettingsView.h"


#define COINS_TO_PLAY @"- Coins to play:"

@interface FSFixturesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FSFixturesCellDelegate,FSBettingsViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *cellSizeDic;
@property (nonatomic, strong) NSIndexPath *previousIndexpath;
@property (nonatomic, strong) FSTournament * tournament;
@property (nonatomic, strong) NSArray *teamsArray;
@property (nonatomic, strong) NSMutableDictionary *selectedDataDic;

@end

@implementation FSFixturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _init];
    [self populateData];
}

-(void)_init
{
    NSString *cellIdentifier = NSStringFromClass([self class]);
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([FSFixturesCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    self.cellSizeDic = [[NSMutableDictionary alloc] init];
    self.teamsArray  = [[FSTournamentsManager sharedInstance] teamArray];

    [self setTitleLabel:@"MATCHES"];
    [self setDrawerBarButton];
}


- (void)populateData
{
    if (![[FSTournamentsManager sharedInstance] tournamentArray]) {
        [self getTournaments];
    }
    else {
        self.tournament = [[[FSTournamentsManager sharedInstance] tournamentArray] firstObjectOrNil];
        if(![[FSTournamentsManager sharedInstance] teamArray]) {
            [self getTeams];
        }
        else {
            [self getAllMatchesForTournament:self.tournament];
        }
    }
}

- (void)getTournaments
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[FSTournamentsManager sharedInstance] getAllTournamentsOnSuccess:^(NSMutableArray *resultsArray) {
        self.tournament = [resultsArray firstObjectOrNil];
        [self getTeams];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)getTeams
{
    [[FSTournamentsManager sharedInstance] getTeamsForTournament:self.tournament success:^(NSMutableArray *resultsArray) {
        self.teamsArray = resultsArray;
        [self getAllMatchesForTournament:self.tournament];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)getAllMatchesForTournament:(FSTournament *)tournament
{
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    if (!tournament) {
        [SVProgressHUD showErrorWithStatus:@"Error fetching matches"];
        return;
    }
    
    [[FSTournamentsManager sharedInstance] getMatchesForTournament:tournament fromCache:TRUE success:^(NSMutableArray *resultsArray) {
        [SVProgressHUD dismiss];
        if ([resultsArray isValidObject]) {
            self.dataArray = resultsArray;
            [self generateDataModel];
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)generateDataModel
{
    NSDate *currentDate = [NSDate date];
    
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"startTime > %@ && status != %@",[NSDate date],MATCH_STATUS_FINISHED];
    NSArray *filteredArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    filteredArray = [filteredArray sortedArrayWithAttribute:@"startTime" ascending:YES];
    self.dataArray = [NSMutableArray arrayWithArray:filteredArray];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in self.dataArray) {
        
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [self.teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [self.teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        
        NSInteger days = [FSUtilityManager daysBetweenDate:currentDate andDate:match.startTime];
        NSString *dateString  = [self getNoOfDaysString:days];
        
        NSDictionary *aDic = @{@"match":match,
                               @"lteam":lTeam,
                               @"rteam":rTeam,
                               @"days":dateString};
        [resultsArray addObject:aDic];
    }
    self.dataArray = resultsArray;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSFixturesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.delegate =  self;
    NSDictionary *datDic = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureData:datDic];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.previousIndexpath && indexPath.row == self.previousIndexpath.row) {
        return CGSizeMake(320, 108);
    }
    else {
        FSMatch *match = self.dataArray[indexPath.row][@"match"];
        if (match.bettings) {
            return CGSizeMake(320, 84);
        }
        else {
            return CGSizeMake(320, 64);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSMatch * match = self.dataArray[indexPath.row][@"match"];

    if (self.previousIndexpath && indexPath.row == self.previousIndexpath.row) {
        self.previousIndexpath = nil;
    }
    else if(!match.bettings){
        self.previousIndexpath = indexPath;
    }
    [self resetCollectionViewLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fixtureCellDidSelectButton:(NSString *)selection withData:(NSDictionary *)dataDic
{
    if (self.previousIndexpath) {
        self.previousIndexpath = nil;
        [self resetCollectionViewLayout];
    }
    [self displayBettingsViewWithSelection:selection andData:dataDic];
}

- (void)resetCollectionViewLayout
{
    UICollectionViewFlowLayout * collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setMinimumLineSpacing:1];
    [self.collectionView setCollectionViewLayout:collectionViewLayout animated:YES];
}


#pragma mark - Bettings view

- (void)displayBettingsViewWithSelection:(NSString *)selection andData:(NSDictionary *)dataDic
{
    self.selectedDataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    self.selectedDataDic[@"selection"] = selection;
    
    NSString *title = [self getTitleForBettingsView:self.selectedDataDic];
    NSNumber *points  = [[FSUserManager sharedInstance].userProfile points];
    [FSBettingsView showBettingsFromViewController:self withTitle:title points:[points integerValue]];
}

- (void)FSBettingsViewDidCancelView:(FSBettingsView *)view
{
    DLog(@"bettings view is cancelled");
}

- (void)FSBettingsViewDidDismissView:(FSBettingsView *)view withBet:(NSInteger)points
{
    FSMatch *match = self.selectedDataDic[@"match"];
    NSString *selection = self.selectedDataDic[@"selection"];
    
//    [[FSTournamentsManager sharedInstance] postBettingForMatch:match points:@(points) selection:selection success:^(FSBettings * bettings) {
//        
//        if ([bettings isValidObject]) {
//            [self.collectionView reloadData];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    }];
}

- (NSString *)getTitleForBettingsView:(NSDictionary *)dataDic
{
    NSString *selection = dataDic[@"selection"];
    if ([selection isEqualToString:MATCH_BET_DRAW]) {
        selection = [NSString stringWithFormat:@"Draw %@",COINS_TO_PLAY];
    }
    else {
        FSTeam *team  = [selection isEqualToString:MATCH_BET_LEFT] ? dataDic[@"lteam"] : dataDic[@"rteam"];
        selection = [NSString stringWithFormat:@"%@ Win %@",team.name,COINS_TO_PLAY];
    }
    return selection;
}

- (NSString *)getNoOfDaysString:(NSInteger)noOfDays
{
    switch (noOfDays) {
        case 0:
            return @"Today";
            case 1:
            return @"Tomorrow";
            default:
            return [NSString stringWithFormat:@"%ld days to go",(long)noOfDays];
    }
}

@end