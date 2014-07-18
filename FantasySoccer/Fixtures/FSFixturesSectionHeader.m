//
//  FSFixturesSectionHeader.m
//  FantasySoccer
//
//  Created by Swarup on 11/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesSectionHeader.h"

@interface FSFixturesSectionHeader()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation FSFixturesSectionHeader

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
    self.lblTitle.font = [UIFont neutraTextBookFontNameOfSize:10];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setTitle:(NSString *)title
{
    self.lblTitle.text = title;
}

@end
