//
//  FSResultsViewController.m
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSResultsViewController.h"
#import "FSFixturesCell.h"

@interface FSResultsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong)UIRefreshControl *refreshControl;

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
    [self setTitleLabel:@"MY HISTORY"];
    [self setDrawerBarButton];
    [self populateData];
}

- (void)_init
{
    UINib *aNib = [UINib nibWithNibName:@"FSFixturesCell" bundle:nil];
    [self.collectionView registerNib:aNib forCellWithReuseIdentifier:@"FSResultsViewController"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.collectionView addSubview:refreshControl];
    [self _initBlocks];
    
}
void (^errorBlock)(NSError *error);

-(void)_initBlocks
{
    __block FSResultsViewController *vc = self;
    errorBlock =  ^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [vc.refreshControl endRefreshing];
    };
}

- (void)reloadData:(id)sender
{
    [self populateData];
}

- (void)populateData
{
    if (!self.refreshControl.isRefreshing) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }

    [[FSBettingsManager sharedInstance] getBettingsHistoryOnSucces:^(NSMutableArray *resultArray) {
        DDLogDebug(@"results are %@", resultArray);
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        self.dataArray =  resultArray;
        if (![self.dataArray isValidObject] || [self.dataArray count] <= 0) {
            [SVProgressHUD showErrorWithStatus:@"You have not made any guess yet."];
        }
        [self generateDataModel];
        [self.collectionView reloadData];
        
    } failure:errorBlock];
}



- (void)generateDataModel
{
    NSArray *teamsArray = [[FSTournamentsManager sharedInstance] teamArray];
    NSArray *filteredArray = [self.dataArray sortedArrayWithAttribute:@"startTime" ascending:NO];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (FSMatch *match in filteredArray) {
        
        NSNumber *lTeamID = match.lTeamID;
        NSNumber *rTeamID = match.rTeamID;
        FSTeam *lTeam = [teamsArray firstObjectWithValue:lTeamID forKeyPath:@"teamID"];
        FSTeam *rTeam = [teamsArray firstObjectWithValue:rTeamID forKeyPath:@"teamID"];
        
        if (![lTeam isValidObject] || ![rTeam isValidObject]) {
            continue;
        }
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
   FSFixturesCell *cell =   [collectionView dequeueReusableCellWithReuseIdentifier:@"FSResultsViewController" forIndexPath:indexPath];
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    [cell configureData:dataDic];
    [cell setNeedsLayout];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 84);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //empty implementation. Avoid super class call
}

@end
