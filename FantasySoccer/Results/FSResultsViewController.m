//
//  FSResultsViewController.m
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSResultsViewController.h"
#import "FSResultsCell.h"

@interface FSResultsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@end

@implementation FSResultsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self setTitleLabel:@"RESULTS"];
    [self setDrawerBarButton];
    [self populateData];
    // Do any additional setup after loading the view.
}

- (void)_init
{
    UINib *aNib = [UINib nibWithNibName:@"FSResultsCell" bundle:nil];
    [self.collectionView registerNib:aNib forCellWithReuseIdentifier:NSStringFromClass([self class])];
    
}

- (void)populateData
{
    FSTournament *tournament  = [[[FSTournamentsManager sharedInstance] tournamentArray] firstObjectOrNil];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
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
    NSArray *teamsArray = [[FSTournamentsManager sharedInstance] teamArray];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startTime < %@ && status ==[c]%@",[NSDate date], MATCH_STATUS_FINISHED];
    NSArray *filteredArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    filteredArray = [filteredArray sortedArrayWithAttribute:@"startTime" ascending:NO];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in filteredArray) {
        
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        
        NSDictionary *aDic = @{@"match":match,
                               @"lteam":lTeam,
                               @"rteam":rTeam};
        [resultsArray addObject:aDic];
    }
    self.dataArray = resultsArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   FSResultsCell *cell =   [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    [cell configureData:dataDic];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 64);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //empty implementation. Avoid super class call
}



@end
