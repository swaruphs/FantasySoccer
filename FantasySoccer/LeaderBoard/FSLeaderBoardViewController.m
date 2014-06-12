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
    // Do any additional setup after loading the view from its nib.

}

- (void)_init
{
    self.title =  @"Leader Board";
    self.dataArray = [NSMutableArray array];
    UINib *aNib = [UINib nibWithNibName:@"FSLeaderBoardCell" bundle:nil];
    [self.tableView registerNib:aNib forCellReuseIdentifier:cellIdentifier];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBtnDoneTap:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self populateDummyData];
}

- (void)populateDummyData
{
    NSArray * dummyArray = @[@{@"name": @"Kimi Raikonen",
                               @"coins": @"200"},
                               @{@"name":@"Vettel",
                                 @"coins":@"100"},
                             @{@"name":@"Alonso",
                               @"coins":@"1"}];
    
    [self.dataArray addObjectsFromArray:dummyArray];
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
    
    NSDictionary *dataDic = [self.dataArray objectAtIndex:indexPath.row % 3];
    [cell configureData:dataDic];
    return cell;
}


@end
