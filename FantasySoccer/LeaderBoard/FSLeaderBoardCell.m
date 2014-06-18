//
//  FSLeaderBoardCell.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSLeaderBoardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FSLeaderBoardCell()

@property (nonatomic, weak) IBOutlet UILabel * lblTitle;
@property (nonatomic, weak) IBOutlet UILabel * lblCoins;
@property (nonatomic, weak) IBOutlet UILabel * lblIndex;
@property (nonatomic, weak) IBOutlet UIImageView * profileImageView;

@end

@implementation FSLeaderBoardCell

- (void)awakeFromNib
{
    // Initialization code
    self.lblTitle.font = [UIFont neutraTextLightFontNameOfSize:18];
    self.lblCoins.font = [UIFont neutraTextLightFontNameOfSize:12];
    self.lblIndex.font = [UIFont neutraTextLightFontNameOfSize:30];
    
    self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
    self.profileImageView.clipsToBounds = YES;
    
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
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",topScore.faceBookID];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
    
    
}
@end
