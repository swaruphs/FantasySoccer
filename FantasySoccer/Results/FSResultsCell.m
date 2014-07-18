//
//  FSResultsCell.m
//  FantasySoccer
//
//  Created by Swarup on 4/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSResultsCell.h"

@interface FSResultsCell()

@end


@implementation FSResultsCell

- (id)initWithFrame:(CGRect)frame
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
    [super _init];
    self.bettingsContainerView.hidden = FALSE;
    self.lblDays.font = [UIFont neutraTextLightFontNameOfSize:14];
}

- (void)resetCell
{
    self.lblDays.text = nil;
}
- (void)configureData:(NSDictionary *)dataDic
{
    [super configureData:dataDic];
    [self resetCell];
    [self configureResultsInfo];
}

- (void)configureResultsInfo
{
    FSMatch *match = self.dataDic[@"match"];
    if ([match.status isEqualToString:MATCH_STATUS_FINISHED]) {
        self.lblDays.text = [NSString stringWithFormat:@"%@ - %@",match.lTeamScore,match.rTeamScore];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
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
