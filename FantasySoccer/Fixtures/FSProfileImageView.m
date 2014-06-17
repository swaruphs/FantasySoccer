//
//  FSProfileImageView.m
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSProfileImageView.h"

@implementation FSProfileImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _init];
     }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)awakeFromNib
{
    [self _init];
}

- (void)_init
{
    [self setUpCircleBorder];
    [self setUpProfileImageView];
}
- (void)setUpProfileImageView
{
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width -10, self.frame.size.height-10)];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    [self addSubview:self.profileImageView];
}

- (void)setUpCircleBorder
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor colorWithRed:244.0/256.0 green:220.0/256.0 blue:118.0/256.0 alpha:1.0].CGColor;
    circle.lineWidth = 1.1;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
}

@end
