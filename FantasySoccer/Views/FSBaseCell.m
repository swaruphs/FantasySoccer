//
//  FSBaseCell.m
//  FantasySoccer
//
//  Created by Swarup on 4/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseCell.h"
#import <SDWebImage/SDImageCache.h>

@interface FSBaseCell()

@end


@implementation FSBaseCell

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
    self.backgroundColor = [UIColor clearColor];    
    UIFont *bettingsFont = [UIFont neutraTextBookFontNameOfSize:12];
    self.lblBetChosen.font = bettingsFont;
    self.lblBetPoints.font = bettingsFont;
    self.bettingsView.hidden = FALSE;
    
    UIFont *titleFont = [UIFont neutraTextLightFontNameOfSize:16];
    self.lblTeamOne.font = titleFont;
    self.lblTeamTwo.font = titleFont;
    self.lblDays.font = [UIFont neutraTextLightFontNameOfSize:12];
    
}

- (void)configureData:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    self.lblDays.font = [UIFont neutraTextLightFontNameOfSize:12];
    FSTeam *lTeam = [dataDic objectForKey:@"lteam"];
    FSTeam *rTeam = [dataDic objectForKey:@"rteam"];
    [self.teamOneImageView setImageWithURL:[NSURL URLWithString:lTeam.iconURL]];
    [self.teamTwoImageView setImageWithURL:[NSURL URLWithString:rTeam.iconURL]];
    self.lblTeamOne.text = lTeam.name;
    self.lblTeamTwo.text = rTeam.name;
    [self configureBettingsInfo];
}


- (void)configureBettingsInfo
{
    FSMatch *match   =   self.dataDic[@"match"];
    if (match.bettings) {
        self.lblBetChosen.text = [match.bettings.selection isEqualToString:MATCH_BET_DRAW] ? @"draw" : @"win";
        self.lblBetPoints.text = [NSString stringWithFormat:@"%@",match.bettings.points];
        [self positionBettingsView];
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

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    FSMatch *match   =   self.dataDic[@"match"];
    if (match.bettings) {
        [self positionBettingsView];
    }
}

- (void)positionBettingsView
{
    FSMatch * match  =  self.dataDic[@"match"];
    self.arrowImageview.hidden  = false;
    CGFloat yOrg = 0.0;
    
    if ([match.bettings.selection isEqualToString:MATCH_BET_LEFT]) {
        self.arrowImageview.frame  = CGRectMake(0, 1, 7, 7);
        yOrg += CGRectGetWidth(self.arrowImageview.frame) + 8;
    }
    CGSize size = [self.lblBetChosen.text stringSizeWithFont:self.lblBetChosen.font];
    CGRect frame  = self.lblBetChosen.frame;
    frame.size.width = size.width;
    frame.origin.x = yOrg;
    self.lblBetChosen.frame = frame;
    yOrg = yOrg + frame.size.width +8;
    
    
    CGRect coinsFrame = self.coinsImageview.frame;
    coinsFrame.origin.x = yOrg;
    self.coinsImageview.frame = coinsFrame;
    yOrg = yOrg + coinsFrame.size.width + 8;
    size = [self.lblBetPoints.text stringSizeWithFont:self.lblBetPoints.font];
    frame = self.lblBetPoints.frame;
    frame.size.width = size.width;
    frame.origin.x = yOrg;
    self.lblBetPoints.frame = frame;
    
    yOrg = yOrg + size.width;
    
    if ([match.bettings.selection isEqualToString:MATCH_BET_RIGHT]) {
        self.arrowImageview.frame = CGRectMake(yOrg+8, 1, 7, 7);
        yOrg = yOrg +8+7;
    }
    
    frame = self.bettingsView.frame;
    frame.size.width = yOrg;
    
    
    
    if([match.bettings.selection isEqualToString:MATCH_BET_DRAW]) {
        CGPoint center = self.bettingsView.center;
        center.x = self.center.x;
        self.bettingsView.frame = frame;
        self.bettingsView.center = center;
        self.arrowImageview.hidden = TRUE;
        return;
    }
    else if([match.bettings.selection isEqualToString:MATCH_BET_LEFT]) {
        frame.origin.x  = self.lblTeamOne.frame.origin.x;
    }
    else {
        CGFloat offset = self.frame.size.width -  self.lblTeamTwo.frame.origin.x - self.lblTeamTwo.frame.size.width;
        frame.origin.x = self.frame.size.width - offset - frame.size.width;
    }
    self.bettingsView.frame = frame;
}

@end
