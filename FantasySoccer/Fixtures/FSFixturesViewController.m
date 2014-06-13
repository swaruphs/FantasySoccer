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

@interface FSFixturesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FSFixturesCellDelegate>

{
    CGPoint _currentScrollPosition;
    CGPoint _lastScrollPosition;
}
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *cellSizeDic;
@property (nonatomic, retain) NSIndexPath *previousIndexpath;
@property (nonatomic, retain) UILabel *lblScore;
@property (nonatomic) CGPoint scrollSpeed;
@property (nonatomic, strong) FSTournament * tournament;
@property (nonatomic, strong) NSArray *teamsArray;

@end

@implementation FSFixturesViewController
@dynamic scrollSpeed;

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
    UINib *cellNib= [UINib nibWithNibName:NSStringFromClass([FSFixturesCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    self.cellSizeDic = [[NSMutableDictionary alloc] init];
    self.teamsArray  = [[FSTournamentsManager sharedInstance] teamArray];

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
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in self.dataArray) {
    
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [self.teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [self.teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        
        NSDictionary *aDic = @{@"match":match,
                               @"lteam":lTeam,
                               @"rteam":rTeam};
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
    if ([self.cellSizeDic objectForKey:indexPath]) {
        NSValue *value =  [self.cellSizeDic objectForKey:indexPath];
        return [value CGSizeValue];
    }
    else {
        NSValue * value  = [NSValue valueWithCGSize:CGSizeMake(320, 60)];
        [self.cellSizeDic setObject:value forKey:indexPath];
        return [value CGSizeValue];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previousIndexpath) {
        [self setNormalHeightForIndexPath:self.previousIndexpath];
    }
    self.previousIndexpath = indexPath;
    [self setHeightForIndexPath:indexPath];
    [self resetCollectionViewLayout];
}

- (void)setNormalHeightForIndexPath:(NSIndexPath *)indexpath
{
    NSValue *value = [NSValue valueWithCGSize:CGSizeMake(320, 60)];
    [self.cellSizeDic setObject:value forKey:indexpath];
}

- (void)setHeightForIndexPath:(NSIndexPath *)indexPath
{
    NSValue *value  = [NSValue valueWithCGSize:CGSizeMake(320, 100)];
    [self.cellSizeDic setObject:value forKey:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fixtureCellDidSelectButton:(NSString *)selection
{
    if (self.previousIndexpath) {
        [self setNormalHeightForIndexPath:self.previousIndexpath];
        self.previousIndexpath = nil;
        [self resetCollectionViewLayout];
    }
    
    FSMatch *match = [self.dataArray objectAtIndex:0][@"match"];
    
    
    [[FSTournamentsManager sharedInstance] postBettingForMatch:match points:@(10) selection:selection success:^(BOOL success) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)resetCollectionViewLayout
{
    UICollectionViewFlowLayout * collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setMinimumLineSpacing:1];
    [self.collectionView setCollectionViewLayout:collectionViewLayout animated:YES];
}


#pragma mark  - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _lastScrollPosition = _currentScrollPosition;
    _currentScrollPosition = scrollView.contentOffset;
}

- (void)waveAnimateCells :(UICollectionViewCell *)cell speed:(float)speed
{
    if (speed == 0.0) {
        return;
    }
    cell.layer.transform = CATransform3DMakeTranslation(-cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
}

- (CGPoint)scrollSpeed
{
    return CGPointMake(_lastScrollPosition.x - _currentScrollPosition.x,
                       _lastScrollPosition.y - _currentScrollPosition.y);
}
@end
