//
//  FSLeaderBoardCell.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSLeaderBoardCell.h"

@interface FSLeaderBoardCell()

@property (nonatomic, weak) IBOutlet UILabel * lblTitle;
@property (nonatomic, weak) IBOutlet UILabel * lblCoins;

@end

@implementation FSLeaderBoardCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureData:(FSTopScore *)topScore
{
    self.lblCoins.text = [NSString stringWithFormat:@"%@",topScore.points];
    self.lblTitle.text = topScore.name;
}
@end
