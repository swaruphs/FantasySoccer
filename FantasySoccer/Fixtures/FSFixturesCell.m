//
//  FSFixturesCell.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSFixturesCell.h"



@interface FSFixturesCell()
@property (nonatomic, weak) IBOutlet UIView *chooseBettingsView;
@property (nonatomic, weak) IBOutlet UIButton *winButton;
@property (nonatomic, weak) IBOutlet UIButton *drawButton;
@property (nonatomic, weak) IBOutlet UIButton *loseButton;

@property (nonatomic, weak) IBOutlet UIView *bettingsView;
@property (nonatomic, weak) IBOutlet UIView *bettingsContainerView;
@property (nonatomic, weak) IBOutlet UILabel *lblBetChosen;
@property (nonatomic, weak) IBOutlet UILabel *lblBetPoints;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageview;
@property (nonatomic, weak) IBOutlet UIImageView *coinsImageview;

@property (nonatomic, weak) IBOutlet UIImageView *teamOneImageView;
@property (nonatomic, weak) IBOutlet UIImageView *teamTwoImageView;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamOne;
@property (nonatomic, weak) IBOutlet UILabel *lblTeamTwo;
@property (nonatomic, weak) IBOutlet UILabel *lblDays;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation FSFixturesCell

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
    UIFont *btnFont = [UIFont neutraTextBookFontNameOfSize:18];
    self.winButton.titleLabel.font = btnFont;
    self.drawButton.titleLabel.font = btnFont;
    self.loseButton.titleLabel.font = btnFont;
    
    UIFont *bettingsFont = [UIFont neutraTextBookFontNameOfSize:12];
    self.lblBetChosen.font = bettingsFont;
    self.lblBetPoints.font = bettingsFont;
    self.bettingsView.hidden = FALSE;
    
    UIFont *titleFont = [UIFont neutraTextLightFontNameOfSize:18];
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
    self.lblDays.text = dataDic[@"days"];
    [self configureResultsInfo];
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

- (void)configureResultsInfo
{
    FSMatch *match = self.dataDic[@"match"];
    if ([match.status isEqualToString:MATCH_STATUS_FINISHED]) {
        self.lblDays.text = [NSString stringWithFormat:@"%@ - %@",match.lTeamScore,match.rTeamScore];
        self.lblDays.font = [UIFont neutraTextLightFontNameOfSize:14];
    }
}

- (IBAction)onBtnTap:(UIButton *)sender
{
    NSString *selection =  nil;
    switch (sender.tag) {
        case 1:
            selection = MATCH_BET_LEFT;
            break;
        case 2:
            selection = MATCH_BET_DRAW;
            break;
        case 3:
            selection = MATCH_BET_RIGHT;
            break;
        default:
            selection = MATCH_BET_DRAW;
            break;
    }
    
    [self.delegate fixtureCellDidSelectButton:selection withData:self.dataDic];
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
     CGRect frame =  layoutAttributes.frame;
    if (frame.size.height == 84) {
        self.bettingsContainerView.hidden = FALSE;
        self.chooseBettingsView.hidden = TRUE;
    }
    else if(frame.size.height == 108){
        self.chooseBettingsView.hidden =FALSE;
        self.bettingsContainerView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    FSMatch *match   =   self.dataDic[@"match"];
    if (match.bettings) {
        [self positionBettingsView];
    }
}

@end
