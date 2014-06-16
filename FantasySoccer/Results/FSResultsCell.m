//
//  FSResultsCell.m
//  FantasySoccer
//
//  Created by Swarup on 16/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSResultsCell.h"

@interface FSResultsCell()

@property (nonatomic, weak) IBOutlet UIImageView *teamOneImageView;
@property (nonatomic, weak) IBOutlet UIImageView *teamTwoImageView;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamOne;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamTwo;
@property (nonatomic, weak) IBOutlet UILabel *lblResults;

@end

@implementation FSResultsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)configureData:(NSDictionary *)dataDic
{
    FSTeam *lTeam = [dataDic objectForKey:@"lteam"];
    FSTeam *rTeam = [dataDic objectForKey:@"rteam"];
    FSMatch *match = dataDic[@"match"];
    [self.teamOneImageView setImageWithURL:[NSURL URLWithString:lTeam.iconURL]];
    [self.teamTwoImageView setImageWithURL:[NSURL URLWithString:rTeam.iconURL]];
    self.lblTeamOne.text = lTeam.name;
    self.lblTeamTwo.text = rTeam.name;
    self.lblResults.text = [NSString stringWithFormat:@"%@ - %@",match.lTeamScore, match.rTeamScore];
}

@end
