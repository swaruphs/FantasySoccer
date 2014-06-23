//
//  FSBettingButton.m
//  FantasySoccer
//
//  Created by Swarup on 15/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBettingButton.h"

@interface FSBettingButton()

@end

@implementation FSBettingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _init];
    }
    return self;
}

-(void)awakeFromNib
{
    [self _init];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)_init
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.titleLabel.textColor.CGColor;
    circle.lineWidth = 1.1;
    [self.layer addSublayer:circle];
}

@end
