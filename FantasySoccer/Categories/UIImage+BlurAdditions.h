//
//  UIImage+BlurAdditions.h
//  BlurOverlay
//
//  Created by Swarup on 22/5/14.
//  Copyright (c) 2014 Swarup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurAdditions)

/*******************************************************************************
 Captures a view as an image including subview
 ******************************************************************************/
+ (UIImage*)captureView:(UIView *)view;

/*******************************************************************************
 Apply blur effects using Apple's imageEffects category with reduced radius.
 ******************************************************************************/
- (UIImage *)applyLightEffectWithReducedRadius;

@end
