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

@property (nonatomic, weak) IBOutlet UILabel *lblValue;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblUserPoints;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSString *title;
@property(nonatomic) NSUInteger points;
@property(nonatomic) NSUInteger userPoints;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonArray;

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
    self.lblUserPoints.font = [UIFont neutraTextLightFontNameOfSize:12];
    self.lblTitle.font = [UIFont neutraTextLightFontNameOfSize:18];
    self.lblValue.font = [UIFont neutraTextLightFontNameOfSize:60];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.numberFormatter setMaximumFractionDigits:0];
}

-(void)configureData
{
    self.lblTitle.text = self.title;
    self.lblUserPoints.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.userPoints]];
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
                                       userPoints:(NSUInteger)userPoints

{
    FSBettingsView *aView = [[[NSBundle mainBundle] loadNibNamed:@"FSBettingsView" owner:nil options:nil] objectAtIndex:0];
    aView.delegate = viewController;
    [aView _initWithTitle:title points:points userPoints:userPoints];
    return aView;
    
}

- (void)_initWithTitle:(NSString *)title points:(NSUInteger)points userPoints:(NSUInteger)userPoints
{
    self.title = title;
    self.points = points;
    self.userPoints = userPoints;
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
        frame.origin.y = 0;
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
    [self addNumberToDisplay:sender.tag];
}

- (IBAction)onDeleteButtonTap:(UIButton *)sender
{
    [self deleteLastDigit];
}

- (void)cancelView
{
    [self dismissBettingsView:NO];
}

- (void)deleteLastDigit
{
    if (self.points == 0) {
        return;
    }
    
    self.points = self.points /10;
    self.lblValue.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInt:self.points]];
}
- (void)addNumberToDisplay:(NSUInteger)points
{
    if (points > 9) {
        return;
    }
    
    NSUInteger value  = self.points *10 + points;
    if (value < self.userPoints) {
        self.points = value;
       self.lblValue.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:value]];
    }
    
}


@end
