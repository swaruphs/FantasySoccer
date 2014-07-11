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

#define NUMBER_OF_PAGES 4
#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))
@interface FSOnBoardingViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView * onBoardingScrollView;
@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fourthImageView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *firstOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *secondOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *thirdOnBoardingView;
@property (nonatomic, weak) IBOutlet FSOnBoardingMessageView *fourthOnBoardingView;
@property (nonatomic, strong) IFTTTAnimator * animator;
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
    self.animator = [IFTTTAnimator new];
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
    [self setUpFirstScreen];
    [self setUpSecondScreen];
    [self setUpThirdScreen];
    [self setUpFourthScreen];
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
    [self.animator addAnimation:firstImageViewAnimation];
    [self.animator addAnimation:firstImageViewFrameAnimation];
    
}

- (void)setUpSecondScreen
{
    self.secondOnBoardingView.lblTitle.text =  @"First Screen";
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
    
    [self.animator addAnimation:secondImageViewAnimation];
    [self.animator addAnimation:secondImageViewFrameanimation];


}

- (void)setUpThirdScreen
{
    self.thirdOnBoardingView.lblTitle.text =  @"First Screen";
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
    [self.animator addAnimation:firstImageViewAnimation];
    [self.animator addAnimation:thirdImageViewFrameAnimation];
}


- (void)setUpFourthScreen
{
    self.fourthOnBoardingView.lblTitle.text =  @"First Screen";
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
    [self.animator addAnimation:firstImageViewAnimation];
    [self.animator addAnimation:fourthImageViewFrameAnimation];
}

#pragma - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.animator animate:scrollView.contentOffset.x];
}

@end
