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
    }
    return self;
}

- (void)configureData:(NSDictionary *)dataDic
{
    [super configureData:dataDic];
    [self configureResultsInfo];
}

- (void)configureResultsInfo
{
    FSMatch *match = self.dataDic[@"match"];
    if ([match.status isEqualToString:MATCH_STATUS_FINISHED]) {
        self.lblDays.text = [NSString stringWithFormat:@"%@ - %@",match.lTeamScore,match.rTeamScore];
        self.lblDays.font = [UIFont neutraTextLightFontNameOfSize:14];
    }
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
