//
//  FSFixturesCell.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesCell.h"


@interface FSFixturesCell()

@property (nonatomic, weak) IBOutlet UIImageView *teamOneImageView;
@property (nonatomic, weak) IBOutlet UIImageView *teamTwoImageView;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamOne;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamTwo;


@end

@implementation FSFixturesCell

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
    UIImage *imgTeamOne = [UIImage imageNamed:dataDic[@"imgTeamOne"]];
    UIImage *imgTeamTwo = [UIImage imageNamed:dataDic[@"imgTeamTwo"]];
    NSString *teamOne = dataDic[@"teamOne"];
    NSString *teamTwo = dataDic[@"teamTwo"];
    
    self.teamOneImageView.image = [UIImage imageNamed:@"CIS"];
    self.teamTwoImageView.image = [UIImage imageNamed:@"Chile"];
    self.lblTeamOne.text = @"CIS";
    self.lblTeamTwo.text = @"CHI";
}


- (IBAction)onBtnTap:(id)sender
{
    [self.delegate fixtureCellDidSelectButton:[sender tag]];
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
