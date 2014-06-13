//
//  FSFixturesCell.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


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
    
    FSTeam *lTeam = [dataDic objectForKey:@"lteam"];
    FSTeam *rTeam = [dataDic objectForKey:@"rteam"];
    
    [self.teamOneImageView setImageWithURL:[NSURL URLWithString:lTeam.iconURL]];
    [self.teamTwoImageView setImageWithURL:[NSURL URLWithString:rTeam.iconURL]];
    self.lblTeamOne.text = lTeam.name;
    self.lblTeamTwo.text = rTeam.name;
}


- (IBAction)onBtnTap:(UIButton *)sender
{
    NSString *selection =  nil;
    switch (sender.tag) {
        case 1:
            selection = @"left";
            break;
        case 2:
            selection = @"draw";
            break;
        case 3:
            selection = @"right";
            break;
        default:
            selection = @"draw";
            break;
    }
    
    [self.delegate fixtureCellDidSelectButton:selection];
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
