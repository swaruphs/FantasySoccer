//
//  FSFixturesCell.h
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FSFixtureCellLeft  = 1,
    FSFixtureCellDraw = 2,
    FSFixtureCellRight = 3,
} FSFixtureCellTap;

@protocol FSFixturesCellDelegate <NSObject>

- (void)fixtureCellDidSelectButton:(NSString *)selection;

@end


@interface FSFixturesCell : UICollectionViewCell

@property (nonatomic, weak) id<FSFixturesCellDelegate>delegate;

- (void)configureData:(NSDictionary *)dataDic;


@end
