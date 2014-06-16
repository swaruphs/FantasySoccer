//
//  UIFont+AppFonts.m
//  FantasySoccer
//
//  Created by Swarup on 13/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont(AppFonts)

+(UIFont *)neutraTextBookFontNameOfSize:(NSUInteger)fontSize
{
    return [UIFont fontWithName:@"NeutraText-Book" size:fontSize];
}

+(UIFont *)neutraTextLightFontNameOfSize:(NSUInteger)fontSize
{
    return [UIFont fontWithName:@"NeutraText-Light" size:fontSize];
}
@end
