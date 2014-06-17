//
//  FSBettingsView.m
//  FantasySoccer
//
//  Created by Swarup on 15/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBettingsView.h"

@interface FSBettingsView()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *bettingsView;
@property (nonatomic, weak) IBOutlet UISlider *betingSlider;

@property (nonatomic, weak) IBOutlet UILabel *lblValue;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblSliderMin;
@property (nonatomic, weak) IBOutlet UILabel *lblSliderMax;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSString *title;
@property(nonatomic) NSUInteger points;

@property (nonatomic, weak) IBOutletCollection(UIButton) NSArray *buttonArray;

@end

@implementation FSBettingsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _init];
}

- (void)_init
{
    self.btnConfirm.titleLabel.font = [UIFont neutraTextLightFontNameOfSize:24];
    self.btnCancel.titleLabel.font = [UIFont neutraTextLightFontNameOfSize:24];
    self.lblSliderMin.font = [UIFont neutraTextLightFontNameOfSize:12];
    self.lblSliderMax.font = [UIFont neutraTextLightFontNameOfSize:12];
    self.lblTitle.font = [UIFont neutraTextLightFontNameOfSize:18];
    self.lblValue.font = [UIFont neutraTextLightFontNameOfSize:60];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.numberFormatter setMaximumFractionDigits:0];
    
    //work around for slider thumb tint color.
    [self.betingSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    [self.betingSlider setThumbTintColor:self.lblValue.textColor];
}

-(void)configureData
{
    self.lblTitle.text = self.title;
    [self.numberFormatter stringFromNumber:@(self.points)];
    self.lblSliderMax.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.points];
    self.betingSlider.minimumValue = 0.0;
    self.betingSlider.maximumValue = self.points;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


+(FSBettingsView *)showBettingsFromViewController:(UIViewController<FSBettingsViewDelegate>*)viewController
                                        withTitle:(NSString *)title
                                           points:(NSUInteger)points

{
    FSBettingsView *aView = [[[NSBundle mainBundle] loadNibNamed:@"FSBettingsView" owner:nil options:nil] objectAtIndex:0];
    aView.delegate = viewController;
    [aView _initWithTitle:title points:points];
    return aView;
    
}

- (void)_initWithTitle:(NSString *)title points:(NSUInteger)points
{
    self.title = title;
    self.points = points;
    [self configureData];
    [self.delegate.view.window addSubview:self];
    [self animateViews];
}

- (void)animateViews
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundView.alpha = 0.0;
    CGRect frame  = self.bettingsView.frame;
    frame.origin.y = self.frame.size.height + 100;
    self.bettingsView.frame =  frame;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.backgroundView.alpha = 0.6;
        CGRect frame = self.bettingsView.frame;
        frame.origin.y = 178;
        self.bettingsView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissBettingsView:(BOOL)isCancelled
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.backgroundView.alpha = 0.0;
        CGRect frame = self.bettingsView.frame;
        frame.origin.y = self.frame.size.height + 100;
        self.bettingsView.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (!isCancelled) {
            [self.delegate FSBettingsViewDidDismissView:self withBet:self.points];
        }
        else {
            [self.delegate FSBettingsViewDidCancelView:self];
        }
    }];
}

- (IBAction)sliderDidUpdate:(id)sender
{
    NSUInteger value = round(self.betingSlider.value);
    self.points = value;
    NSString *number = [self.numberFormatter stringFromNumber:@(value)];
    self.lblValue.text = number;
}

-(IBAction)onBtnCancel:(id)sender
{
    [self dismissBettingsView:YES];
}

-(IBAction)onBtnConfirm:(id)sender
{
    [self dismissBettingsView:NO];
}

-(IBAction)onBettingsButtonTap:(UIButton *)sender
{
    self.points = sender.tag;
    self.lblValue.text = [self.numberFormatter stringFromNumber:@(sender.tag)];
}

- (void)cancelView
{
    [self dismissBettingsView:NO];
}

@end
