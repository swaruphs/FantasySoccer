//
//  UIImage+BlurAdditions.m
//  BlurOverlay
//
//  Created by Swarup on 22/5/14.
//  Copyright (c) 2014 Swarup. All rights reserved.
//

#import "UIImage+BlurAdditions.h"
#import "UIImage+ImageEffects.h"

@implementation UIImage (BlurAdditions)

+ (UIImage*)captureView:(UIView *)view
{
    CGRect rect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,view.opaque,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

- (UIImage *)applyLightEffectWithReducedRadius
{
    UIColor *tintColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    return [self applyBlurWithRadius:3 tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
}


@end
