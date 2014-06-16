//
//  FSLeaderBoardViewController.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSLeaderBoardViewController.h"
#import "FSLeaderBoardCell.h"

static NSString *cellIdentifier = @"leaderBoardCellIdentifier";

@interface FSLeaderBoardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation FSLeaderBoardViewController

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
    [self setTitleLabel:@"LEADERBOARD"];
    [self setDrawerBarButton];
    [self populateData];
    // Do any additional setup after loading the view from its nib.

}

- (void)_init
{
    self.dataArray = [NSMutableArray array];
    UINib *aNib = [UINib nibWithNibName:@"FSLeaderBoardCell" bundle:nil];
    [self.tableView registerNib:aNib forCellReuseIdentifier:cellIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)populateData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[FSTournamentsManager sharedInstance] getTopScoresFromCache:YES
 success:^(NSMutableArray *resultsArray) {
     [SVProgressHUD dismiss];
     self.dataArray = resultsArray;
     [self.tableView reloadData];
     
 } failure:^(NSError *error) {
     [SVProgressHUD showErrorWithStatus:@"Error fetching Top scores"];
 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBtnDoneTap:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark  - tableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSLeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    FSTopScore *topScore = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureData:topScore atIndexPath:indexPath];
    return cell;
}

@end
