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
#import "FSFixturesSectionHeader.h"
#import "FSResultsCell.h"
#import "UIImage+BlurAdditions.h"
#import "FSBettingsView.h"



#define COINS_TO_PLAY @"- Coins to play:"

@interface FSFixturesViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
FSFixturesCellDelegate,
FSBettingsViewDelegate>
{
    BOOL _isUpcomingMatchesAvailable;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) NSArray *teamsArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *pastMatchesArray;
@property (nonatomic, strong) NSMutableDictionary *cellSizeDic;
@property (nonatomic, strong) NSMutableDictionary *selectedDataDic;
@property (nonatomic, strong) NSIndexPath *previousIndexpath;
@property (nonatomic, strong) FSTournament * tournament;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) NSUInteger userPoints;

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

void (^errorBlock)(NSError *error);

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _init];
    [self populateData];
}


-(void)_init
{
    [self setUpCollectionView];
    [self setTitleLabel:@"MATCHES"];
    [self setDrawerBarButton];
    [self setUpRefreshControl];
    [self _initBlocks];
    self.userPoints             = 0;
    _isUpcomingMatchesAvailable = FALSE;
    self.cellSizeDic            = [[NSMutableDictionary alloc] init];
}

- (void)setUpCollectionView
{
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([FSFixturesCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"fixturesCell"];
    cellNib = [UINib nibWithNibName:NSStringFromClass([FSResultsCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"resultsCell"];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([FSFixturesSectionHeader class]) bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader"];
    
}

- (void)setUpRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(performRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

-(void)_initBlocks
{
    __block FSFixturesViewController *vc = self;
    errorBlock =  ^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [vc.refreshControl endRefreshing];
    };
}

- (void)performRefresh:(id)sender
{
    [self populateData:TRUE];
}

- (void)populateData
{
    [self populateData:FALSE];
}

- (void)populateData:(BOOL)fromPullDown
{
    self.teamsArray  = [[FSTournamentsManager sharedInstance] teamArray];
    self.userPoints = [[[FSUserManager sharedInstance] userProfile].points integerValue];
    if (!fromPullDown) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }

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
    [[FSTournamentsManager sharedInstance] getAllTournamentsOnSuccess:^(NSMutableArray *resultsArray) {
        self.tournament = [resultsArray firstObjectOrNil];
        [self getTeams];
    } failure:errorBlock];
}

- (void)getTeams
{
    [[FSTournamentsManager sharedInstance] getTeamsForTournament:self.tournament success:^(NSMutableArray *resultsArray) {
        self.teamsArray = resultsArray;
        [self getAllMatchesForTournament:self.tournament];
        
    } failure:errorBlock];
}

- (void)getAllMatchesForTournament:(FSTournament *)tournament
{
    if (!tournament) {
        [SVProgressHUD showErrorWithStatus:@"Error fetching matches"];
        return;
    }

    [[FSTournamentsManager sharedInstance] getMatchesForTournament:tournament fromCache:FALSE success:^(NSMutableArray *resultsArray) {
        [SVProgressHUD dismiss];
        if ([resultsArray isValidObject]) {
            [self generateDataModel:resultsArray];
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
        
    } failure:errorBlock];
}

- (void)generateDataModel:(NSArray *)allMatchesArray
{
    self.teamsArray  = [[FSTournamentsManager sharedInstance] teamArray];
    self.userPoints = [[[FSUserManager sharedInstance] userProfile].points integerValue];
    [self generateUpcomingMatchesModel:allMatchesArray];
    [self generatePastMatchesDataModel:allMatchesArray];
}

- (void)generateUpcomingMatchesModel:(NSArray *)allMatchesArray
{
    NSDate *currentDate = [NSDate date];
    
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"startTime > %@ && status != %@",[NSDate date],MATCH_STATUS_FINISHED];
    NSArray *filteredArray = [allMatchesArray filteredArrayUsingPredicate:predicate];
    filteredArray = [filteredArray sortedArrayWithAttribute:@"startTime" ascending:YES];
    allMatchesArray = [NSMutableArray arrayWithArray:filteredArray];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in allMatchesArray) {
        
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [self.teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [self.teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        if (![lTeam isValidObject] || ![rTeam isValidObject]) {
            continue;
        }
        
        NSInteger days = [FSUtilityManager daysBetweenDate:currentDate andDate:match.startTime];
        NSString *dateString  = [self getNoOfDaysString:days];
        NSString *time = [[FSUtilityManager sharedInstance] getTimeString:match.startTime];
        
        NSDictionary *aDic = @{@"match":match,
                               @"lteam":lTeam,
                               @"rteam":rTeam,
                               @"days":dateString,
                               @"time":time};
        [resultsArray addObject:aDic];
    }
    self.dataArray = resultsArray;
    _isUpcomingMatchesAvailable = [self.dataArray isValidObject] && [self.dataArray count] > 0;
}


- (void)generatePastMatchesDataModel:(NSArray *)allMatchesArray
{
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"startTime < %@",[NSDate date]];
    NSArray *filteredArray = [allMatchesArray filteredArrayUsingPredicate:predicate];
    filteredArray = [filteredArray sortedArrayWithAttribute:@"startTime" ascending:NO];
    allMatchesArray = [NSMutableArray arrayWithArray:filteredArray];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in allMatchesArray) {
        
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [self.teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [self.teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        if (![lTeam isValidObject] || ![rTeam isValidObject]) {
            continue;
        }
        NSDictionary *aDic = @{@"match":match,
                               @"lteam":lTeam,
                               @"rteam":rTeam
                               };
        [resultsArray addObject:aDic];
    }
    self.pastMatchesArray = resultsArray;
}
#pragma mark - UICollectionView Datasource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count  = 0;
    count += [self.pastMatchesArray isValidObject] && [self.pastMatchesArray count] > 0 ? 1 :  0;
    count += [self.dataArray isValidObject] && [self.dataArray count] > 0 ? 1 : 0;
    
    return count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [[self activeArray:[NSIndexPath indexPathForItem:0 inSection:section]] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSBaseCell *cell = nil;
    NSDictionary *datDic = [self activeArray:indexPath][indexPath.row];
    if (indexPath.section == 0 && _isUpcomingMatchesAvailable) {
        FSFixturesCell  *fixturesCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fixturesCell" forIndexPath:indexPath];
        fixturesCell.delegate =  self;
        cell = fixturesCell;

    }
    else {
        FSResultsCell *resultsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resultsCell" forIndexPath:indexPath];
        cell = resultsCell;
    }
    [cell configureData:datDic];
    [cell setNeedsLayout];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.previousIndexpath && [self.previousIndexpath compare:indexPath] == NSOrderedSame) {
        return CGSizeMake(320, 108);
    }
    else {
        
        FSMatch *match = [self activeArray:indexPath][indexPath.row][@"match"];
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
    if (indexPath.section == 1 || (indexPath.section == 0 && !_isUpcomingMatchesAvailable)) {
        return;
    }
    
    FSMatch *match = self.dataArray[indexPath.row][@"match"];
    if (self.previousIndexpath && indexPath.row == self.previousIndexpath.row) {
        self.previousIndexpath = nil;
    }
    else if(self.userPoints <= 0){
        [SVProgressHUD showErrorWithStatus:@"Sorry, you are out of points to guess"];
        return;
    }
    else if([match.startTime compare:[NSDate date]] == NSOrderedAscending) {
        [SVProgressHUD showErrorWithStatus:@"Sorry, the match has begun"];
        return;
    }
    else if(match.bettings) {
        [self displayBettingsViewWithSelection:match.bettings.selection andData:self.dataArray[indexPath.row]];
    }
    else {
        self.previousIndexpath = indexPath;
    }
    [self resetCollectionViewLayout];
}

#pragma maek  - UIColleciton View Flow Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FSFixturesSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
    if ([sectionHeader isKindOfClass:[FSFixturesSectionHeader class]]) {
        if (indexPath.section == 0 && _isUpcomingMatchesAvailable) {
            [sectionHeader setTitle:@"UPCOMING MATCHES"];
        }
        else {
            [sectionHeader setTitle:@"PAST MATCHES"];
        }
    }
    
    return sectionHeader;
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
    [FSBettingsView showBettingsFromViewController:self withTitle:title points:0 userPoints:[points integerValue]];
    
}

- (void)FSBettingsViewDidCancelView:(FSBettingsView *)view
{
    DLog(@"bettings view is cancelled");
}

- (void)FSBettingsViewDidDismissView:(FSBettingsView *)view withBet:(NSInteger)points
{
    if (points <= 0) {
        return;
    }
    FSMatch *match = self.selectedDataDic[@"match"];
    NSString *selection = self.selectedDataDic[@"selection"];
    
    [[FSBettingsManager sharedInstance] postBettingForMatch:match points:@(points) selection:selection success:^(FSBettings *bettings) {
        if ([bettings isValidObject]) {
            self.userPoints = [[[FSUserManager sharedInstance] userProfile].points integerValue];
            [self.collectionView reloadData];
        }
        
    } failure:errorBlock];
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

- (NSArray *)activeArray:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _isUpcomingMatchesAvailable) {
        return self.dataArray;
    }
    
    return self.pastMatchesArray;
}
@end
