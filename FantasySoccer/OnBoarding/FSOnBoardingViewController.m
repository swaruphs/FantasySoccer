//
//  FSOnBoardingViewController.m
//  FantasySoccer
//
//  Created by Swarup on 4/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSOnBoardingViewController.h"
#import "IFTTTJazzHands.h"
#import "FSOnBoardingMessageView.h"
#import "FSLoginViewController.h"

#define NUMBER_OF_PAGES 4
#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))
@interface FSOnBoardingViewController () <UIScrollViewDelegate>
{
    BOOL disableScroll;
}


@property (nonatomic, weak) IBOutlet UILabel *lblLoginTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnBack;
@property (nonatomic, weak) IBOutlet UIScrollView * pagingScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * onBoardingScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * mainScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fourthImageView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *firstOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *secondOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *thirdOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *fourthOnBoardingView;
@property (nonatomic, weak) IBOutlet UIView *loginView;
@property (nonatomic, strong) IFTTTAnimator * onBoardingAnimator;
@property (nonatomic, strong) IFTTTAnimator * mainAnimator;
@end

@implementation FSOnBoardingViewController

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
    self.onBoardingAnimator = [IFTTTAnimator new];
    self.mainAnimator = [IFTTTAnimator new];
    disableScroll = NO;
    self.mainScrollView.scrollEnabled = NO;
    [self setUpViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpViews
{
    self.onBoardingScrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
    self.mainScrollView.contentSize = CGSizeMake(320*2, CGRectGetHeight(self.view.frame));
    [FSLoginViewController configureLoginLabel:self.lblLoginTitle];
    [self setUpOnBoardingAnimator];
    [self setUpMainAnimator];
}

- (void)setUpOnBoardingAnimator
{
    [self setUpFirstScreen];
    [self setUpSecondScreen];
    [self setUpThirdScreen];
    [self setUpFourthScreen];
    [self.onBoardingAnimator addAnimation:[self addAlphaAnimationToView:self.firstOnBoardingView fromPage:0 toPage:1 reverse:TRUE]];
        [self.onBoardingAnimator addAnimation:[self addAlphaAnimationToView:self.secondOnBoardingView fromPage:1 toPage:2 reverse:TRUE]];
        [self.onBoardingAnimator addAnimation:[self addAlphaAnimationToView:self.thirdOnBoardingView fromPage:2 toPage:3 reverse:TRUE]];
        [self.onBoardingAnimator addAnimation:[self addAlphaAnimationToView:self.fourthOnBoardingView fromPage:3 toPage:4 reverse:TRUE]];
}

- (void)setUpMainAnimator
{
    [self.mainAnimator addAnimation:[self addAlphaAnimationToView:self.loginView fromPage:1 toPage:2 reverse:FALSE]];
}

- (IFTTTAlphaAnimation *)addAlphaAnimationToView:(UIView *)view fromPage:(int)fromPage toPage:(int)toPage reverse:(BOOL)reverse
{
    IFTTTAlphaAnimation *alphaAnimation = [IFTTTAlphaAnimation animationWithView:view];
    [alphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(fromPage) andAlpha:0.0f]];
    [alphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(toPage) andAlpha:1.0f]];
    if(reverse) {
        [alphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(toPage +1) andAlpha:0.0f]];
    }
    
    return alphaAnimation;
}

- (void)setUpFirstScreen
{
    self.firstOnBoardingView.lblTitle.text =  @"First Screen";
    self.firstOnBoardingView.lblMsg.text = @"some random description to fil the screen";
    
    IFTTTAngleAnimation *firstImageViewAnimation = [IFTTTAngleAnimation animationWithView:self.firstImageView];
    [firstImageViewAnimation addKeyFrames:@[
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andAngle:(CGFloat)(M_PI/4)],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1)  andAngle:0],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAngle:(CGFloat)(-M_PI/2)],
                                            ]];
    
    IFTTTFrameAnimation *firstImageViewFrameAnimation = [IFTTTFrameAnimation animationWithView:self.firstImageView];
    [firstImageViewFrameAnimation addKeyFrames:@[
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(self.firstImageView.frame, 0, 0)],[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.firstImageView.frame, -180, 0)]]];
    [self.onBoardingAnimator addAnimation:firstImageViewAnimation];
    [self.onBoardingAnimator addAnimation:firstImageViewFrameAnimation];
    
}

- (void)setUpSecondScreen
{
    self.secondOnBoardingView.lblTitle.text =  @"Second Screen";
    self.secondOnBoardingView.lblMsg.text = @"some random description to fil the screen";
    
    IFTTTAngleAnimation *secondImageViewAnimation = [IFTTTAngleAnimation animationWithView:self.secondImageView];
    [secondImageViewAnimation addKeyFrames:@[
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAngle:(CGFloat)(+M_PI/2)],
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2)  andAngle:0],
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAngle:(CGFloat)(-M_PI/2)],
                                             ]];
    
    
    IFTTTFrameAnimation *secondImageViewFrameanimation = [IFTTTFrameAnimation animationWithView:self.secondImageView];
    [secondImageViewFrameanimation addKeyFrames:@[[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(self.secondImageView.frame, 180, 0)],
                                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.secondImageView.frame, 0, 0)],[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.secondImageView.frame, -180, 0)]]];
    
    [self.onBoardingAnimator addAnimation:secondImageViewAnimation];
    [self.onBoardingAnimator addAnimation:secondImageViewFrameanimation];


}

- (void)setUpThirdScreen
{
    self.thirdOnBoardingView.lblTitle.text =  @"Third Screen";
    self.thirdOnBoardingView.lblMsg.text = @"some random description to fil the screen";
    
    IFTTTAngleAnimation *firstImageViewAnimation = [IFTTTAngleAnimation animationWithView:self.thirdImageView];
    [firstImageViewAnimation addKeyFrames:@[
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAngle:(CGFloat)(M_PI/2)],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3)  andAngle:0],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAngle:(CGFloat)(-M_PI/2)],
                                            ]];
    
    IFTTTFrameAnimation *thirdImageViewFrameAnimation = [IFTTTFrameAnimation animationWithView:self.thirdImageView];
    [thirdImageViewFrameAnimation addKeyFrames:@[[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.thirdImageView.frame, 180, 0)],
                                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.thirdImageView.frame, 0, 0)],[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.thirdImageView.frame, -180, 0)]]];
    [self.onBoardingAnimator addAnimation:firstImageViewAnimation];
    [self.onBoardingAnimator addAnimation:thirdImageViewFrameAnimation];
}


- (void)setUpFourthScreen
{
    self.fourthOnBoardingView.lblTitle.text =  @"Fourth Screen";
    self.fourthOnBoardingView.lblMsg.text = @"some random description to fil the screen";
    
    IFTTTAngleAnimation *firstImageViewAnimation = [IFTTTAngleAnimation animationWithView:self.fourthImageView];
    [firstImageViewAnimation addKeyFrames:@[
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAngle:(CGFloat)(M_PI/2)],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4)  andAngle:0],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andAngle:(CGFloat)(-M_PI/4)],
                                            ]];
    
    IFTTTFrameAnimation *fourthImageViewFrameAnimation = [IFTTTFrameAnimation animationWithView:self.fourthImageView];
    [fourthImageViewFrameAnimation addKeyFrames:@[[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.fourthImageView.frame, 180, 0)],
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.fourthImageView.frame, 0, 0)],
                                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andFrame:CGRectOffset(self.fourthImageView.frame, -180, 0)]]];
    [self.onBoardingAnimator addAnimation:firstImageViewAnimation];
    [self.onBoardingAnimator addAnimation:fourthImageViewFrameAnimation];
}


#pragma - UIScrollView Delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.onBoardingScrollView) {
        [self.onBoardingAnimator animate:scrollView.contentOffset.x];
        [self.pagingScrollView setContentOffset:scrollView.contentOffset];
    }
    else if (scrollView == self.mainScrollView) {
        [self.mainAnimator animate:self.mainScrollView.contentOffset.x];
        [self.onBoardingAnimator animate:timeForPage(4) + self.mainScrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.onBoardingScrollView) {
        int pagination = scrollView.contentOffset.x / 320.0f;
        self.pageControl.currentPage = pagination;
        self.mainScrollView.scrollEnabled = pagination == 3 ? TRUE : FALSE;
    }
    else if(scrollView == self.mainScrollView) {
        int pagination = scrollView.contentOffset.x / 320.0f;
        if(pagination == 1) {
            self.mainScrollView.scrollEnabled = NO;
        }
    }
}

- (void)animateMainScrollView
{
    
}

- (IBAction)onLoginBtn
{
    [FSLoginViewController loginUser];
}

- (IBAction)onBackBtn:(id)sender
{
    self.mainScrollView.scrollEnabled  = YES;
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
