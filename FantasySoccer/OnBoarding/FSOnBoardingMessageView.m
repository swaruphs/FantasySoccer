//
//  FSOnBoardingMessageView.m
//  FantasySoccer
//
//  Created by Swarup on 4/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSOnBoardingMessageView.h"

@implementation FSOnBoardingMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    DDLogInfo(@"In awake from nib");
    [self _init];
}

- (void)_init
{
   // [self setUpBackgroundImageView];
    self.backgroundColor = [UIColor clearColor];
    [self setUpTitleLabel];
    [self setUpDescLabel];
}

- (void)setUpBackgroundImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [imageView setImage:[UIImage imageNamed:@"bg_text_a"]];
    [self addSubview:imageView];
}

- (void)setUpTitleLabel
{
    CGFloat width  =  self.frame.size.width;
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, width-20,30)];
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.font = [UIFont neutraTextBoldFontNameOfSize:20];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblTitle];
}

- (void)setUpDescLabel
{
    CGFloat width  =  self.frame.size.width;
    self.lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, width - 20, 45)];
    self.lblMsg.numberOfLines = 2;
    self.lblMsg.font = [UIFont neutraTextBookFontNameOfSize:18];
    self.lblMsg.textColor = [UIColor whiteColor];
    self.lblMsg.textAlignment = NSTextAlignmentCenter;
    self.lblMsg.contentMode = UIViewContentModeTop;
    self.lblMsg.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:self.lblMsg];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
