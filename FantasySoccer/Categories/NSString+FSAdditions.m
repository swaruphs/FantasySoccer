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

        NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize size =  [self sizeWithAttributes:attributes];
        DLog(@"%lf,%lf",size.width,size.height);
        return size;
}
@end
