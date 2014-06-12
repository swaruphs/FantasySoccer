//
//  FSFixturesViewController.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesViewController.h"
#import "FSLeaderBoardViewController.h"
#import "FSCollectionViewLayout.h"
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
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leader Board" style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnLeaderBoardTap:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    // Do any additional setup after loading the view from its nib.
}

-(void)_init
{
    NSString *cellIdentifier = NSStringFromClass([self class]);
    UINib *cellNib= [UINib nibWithNibName:NSStringFromClass([FSFixturesCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    self.cellSizeDic = [[NSMutableDictionary alloc] init];
    [self setCoinView];
}

- (void)setCoinView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 24, 24)];
    imageView.image = [UIImage imageNamed:@"coins"];
    
    self.lblScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    self.lblScore.backgroundColor = [UIColor clearColor];
    [self.lblScore setTextAlignment:NSTextAlignmentRight];
    [self.lblScore setText:@"200"];
    
    
    UIView *aView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [aView addSubview:self.lblScore];
    [aView addSubview:imageView];
    self.navigationItem.titleView = aView;
    
}

- (void)onBtnLeaderBoardTap:(id)sender
{
    NSLog(@"Leader board did tap");
    FSLeaderBoardViewController *controller = [[FSLeaderBoardViewController alloc] initWithNibName:@"FSLeaderBoardViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:TRUE completion:nil];
    
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSFixturesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.delegate =  self;

    [cell configureData:nil];
    float speed = self.scrollSpeed.y;
    float normalizedSpeed = MAX(-1.0f, MIN(1.0f, speed/20.0f));
    
    [self waveAnimateCells:cell speed:normalizedSpeed];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    cell.layer.transform = CATransform3DIdentity;
    cell.layer.opacity = 1.0f;
    [UIView commitAnimations];

    
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

- (void)fixtureCellDidSelectButton:(FSFixtureCellTap)fixtureCellTap
{
    if (self.previousIndexpath) {
        [self setNormalHeightForIndexPath:self.previousIndexpath];
        self.previousIndexpath = nil;
        [self resetCollectionViewLayout];
    }
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
