//
//  NSString+FSAdditions.m
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "NSString+FSAdditions.h"

@implementation NSString(FSAdditions)

- (CGSize)stringSizeWithFont:(UIFont *)font
{
    if(IOS7_OR_ABOVE){
        NSDictionary *attributes = @{NSFontAttributeName:font};
        return [self sizeWithAttributes:attributes];
    }
    else {
        return [self sizeWithFont:font];
    }
}
@end
