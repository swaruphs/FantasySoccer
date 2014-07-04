//
//  FSBaseCell.h
//  FantasySoccer
//
//  Created by Swarup on 4/7/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FSBaseCell : UICollectionViewCell


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

- (void)_init;
- (void)configureData:(NSDictionary *)dataDic;
- (void)positionBettingsView;

@end
