//
//  FSFixturesCell.h
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseCell.h"

typedef enum : NSUInteger {
    FSFixtureCellLeft  = 1,
    FSFixtureCellDraw = 2,
    FSFixtureCellRight = 3,
} FSFixtureCellTap;

@protocol FSFixturesCellDelegate <NSObject>

- (void)fixtureCellDidSelectButton:(NSString *)selection withData:(NSDictionary *)dataDic;

@end


@interface FSFixturesCell : FSBaseCell

@property (nonatomic, weak) id<FSFixturesCellDelegate>delegate;




@end
