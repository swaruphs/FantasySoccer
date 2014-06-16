//
//  FSSidePanelViewController.m
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSSidePanelViewController.h"

@interface FSSidePanelViewController () <UITableViewDataSource, UITableViewDelegate>
{
    long _currentIndex;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation FSSidePanelViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)_init
{
    _currentIndex = 0;
    self.dataArray = @[@"Matches",@"Results",@"Leaderboard"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _currentIndex) {
        return;
    }
    [self switchToViewController:indexPath.row];
    _currentIndex = indexPath.row;
}

- (void)switchToViewController:(NSUInteger)index
{
    UIViewController *aVC =  nil;
    switch (index) {
        case 0:
            aVC = [[FSFixturesViewController alloc] initWithNibName:NSStringFromClass([FSFixturesViewController class]) bundle:nil];
            break;
        case 1:
            aVC = [[FSResultsViewController alloc] initWithNibName:NSStringFromClass([FSFixturesViewController class]) bundle:nil];
            break;
        default:
            aVC = [[FSLeaderBoardViewController alloc] initWithNibName:NSStringFromClass([FSLeaderBoardViewController class]) bundle:nil];
            break;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aVC];
    FSAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate changeCenterViewControllerToViewController:navController];
}

@end
