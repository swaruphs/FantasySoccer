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
@property (nonatomic, weak) IBOutlet UILabel *lblTime;

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
    [super _init];
    
    UIFont *btnFont = [UIFont neutraTextBookFontNameOfSize:18];
    self.winButton.titleLabel.font = btnFont;
    self.drawButton.titleLabel.font = btnFont;
    self.loseButton.titleLabel.font = btnFont;
    self.lblTime.font = [UIFont neutraTextLightFontNameOfSize:12];
}

- (void)configureData:(NSDictionary *)dataDic
{
    [super configureData:dataDic];
    self.lblDays.text = dataDic[@"days"];
    self.lblTime.text =  dataDic[@"time"];
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
}

@end
