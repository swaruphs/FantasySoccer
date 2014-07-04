//
//  FSBaseViewController.m
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseViewController.h"
#import "UIImage+BlurAdditions.h"

@interface FSBaseViewController ()<FSRefreshModelManagerDelegate>

@end

@implementation FSBaseViewController

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
    [[FSRefreshModelManager sharedInstance] setDelegate:self];
    // Do any additional setup after loading the view.
}


- (void)setDrawerBarButton
{
    UIImage *barbuttonImage = [UIImage imageNamed:@"btn_drawer"];
    UIBarButtonItem *leftbarButtonItem = [[UIBarButtonItem alloc] initWithImage:barbuttonImage style:UIBarButtonItemStylePlain target:self action:@selector(drawerButtonClick:)];
    [leftbarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftbarButtonItem;
}

-(void)setTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont neutraTextBookFontNameOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [title uppercaseString];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)setBlurImageBackground:(UIImageView *)imageView
{
    UIImage *blurImage =  [imageView.image applyLightEffectWithReducedRadius];
    imageView.image = blurImage;
}

- (void)drawerButtonClick:(id)sender
{
    DDLogDebug(@"bar button click");
    FSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.viewDeckController toggleLeftViewAnimated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if ([[[FSRefreshModelManager sharedInstance] delegate] isKindOfClass:[self class]]) {
         [[FSRefreshModelManager sharedInstance] setDelegate:nil];   
    }
    
}

- (void)populateData
{
    // empty implementation. Need to be overridden by the sub class.
}

#pragma mark - FSRefreshManager Delegate

-(void)refreshManagerDidFinishRefresh:(FSRefreshModelManager *)manager
{
    [self populateData];
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

@end
