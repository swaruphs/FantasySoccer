//
//  FSSidePanelViewController.m
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSSidePanelViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FSProfileImageView.h"

@interface FSSidePanelViewController ()
{
    long _currentIndex;
}
@property (nonatomic, weak) IBOutlet FSProfileImageView *profilView;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblPoints;
@property (nonatomic, weak) IBOutlet UIButton *btnMyHistory;
@property (nonatomic, weak) IBOutlet UIButton *btnAllMatches;
@property (nonatomic, weak) IBOutlet UIButton *btnLeaderboard;
@property (nonatomic, weak) IBOutlet UIButton *fbButton;
@property (nonatomic, weak) IBOutlet UIButton *btnSignout;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUserProfile];
}

- (void)_init
{
    self.lblName.font = [UIFont neutraTextLightFontNameOfSize:20];
    self.lblPoints.font = [UIFont neutraTextLightFontNameOfSize:14];
    self.fbButton.titleLabel.font = [UIFont neutraTextBoldFontNameOfSize:14];
    
    UIFont *btnFont = [UIFont neutraTextLightFontNameOfSize:20];
    self.btnAllMatches.titleLabel.font = btnFont;
    self.btnMyHistory.titleLabel.font = btnFont;
    self.btnLeaderboard.titleLabel.font = btnFont;
    self.btnSignout.titleLabel.font = btnFont;
    
    [self setUserProfile];
    [self setProfileImage];
}

- (void)setUserProfile
{
    FSUserProfile *userProfile = [[FSUserManager sharedInstance] userProfile];
    if ([userProfile isValidObject]) {
        self.lblName.text = userProfile.userName;
        self.lblPoints.text = [userProfile getPointsAsString];
    }
}

- (void)setProfileImage
{
    NSString *FBID = [[FSCredentialsManager sharedInstance] getFBID];
    NSString *urlstring  = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",FBID];
    [self.profilView.profileImageView setImageWithURL:[NSURL URLWithString:urlstring]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchToViewController:(id)sender
{
    NSUInteger index  = [sender tag];
    UIViewController *aVC =  nil;
    switch (index) {
        case 100:
            aVC = [[FSFixturesViewController alloc] initWithNibName:NSStringFromClass([FSFixturesViewController class]) bundle:nil];
            break;
        case 101:
            aVC = [[FSResultsViewController alloc] initWithNibName:NSStringFromClass([FSFixturesViewController class]) bundle:nil];
            break;
        case 102:    
            aVC = [[FSLeaderBoardViewController alloc] initWithNibName:NSStringFromClass([FSLeaderBoardViewController class]) bundle:nil];
            break;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aVC];
    FSAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate changeCenterViewControllerToViewController:navController];
}

- (IBAction)onBtnSignOut:(id)sender
{
    FSAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate logoutUserAndClearToken];
}

@end
