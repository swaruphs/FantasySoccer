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
@property (nonatomic, weak) IBOutlet UILabel * lblIndex;

@end

@implementation FSLeaderBoardCell

- (void)awakeFromNib
{
    // Initialization code
    self.lblTitle.font = [UIFont neutraTextLightFontNameOfSize:18];
    self.lblCoins.font = [UIFont neutraTextLightFontNameOfSize:12];
    self.lblIndex.font = [UIFont neutraTextLightFontNameOfSize:30];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureData:(FSTopScore *)topScore atIndexPath:(NSIndexPath *)indexpath
{
    self.lblCoins.text = [NSString stringWithFormat:@"%@",topScore.points];
    self.lblTitle.text = topScore.name;
    self.lblIndex.text = [NSString stringWithFormat:@"%ld",(long)indexpath.row+1];
}
@end
