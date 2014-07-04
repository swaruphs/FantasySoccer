//
//  FSBettingsView.h
//  FantasySoccer
//
//  Created by Swarup on 15/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSBettingsView;

@protocol FSBettingsViewDelegate <NSObject>

@required
- (void)FSBettingsViewDidDismissView:(FSBettingsView *)view withBet:(NSInteger)points;
- (void)FSBettingsViewDidCancelView:(FSBettingsView *)view;

@end


@interface FSBettingsView : UIView

@property (nonatomic, assign) UIViewController <FSBettingsViewDelegate>  * delegate;

+(FSBettingsView *)showBettingsFromViewController:(UIViewController<FSBettingsViewDelegate>*)viewController
                                        withTitle:(NSString *)title
                                           points:(NSUInteger)points
                                       userPoints:(NSUInteger)userPoints;
@end
