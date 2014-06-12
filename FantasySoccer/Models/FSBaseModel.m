//
//  FSBaseModel.m
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@implementation FSBaseModel


-(id)initWithDictionary:(NSDictionary *)jsonDic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:jsonDic];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    // need to be implemented by sub class
}

+ (NSMutableArray *)populateModelWithData:(NSArray *)dataArray
{
    NSMutableArray *resultsArray = [NSMutableArray array];
    for(NSDictionary * jsonDic in dataArray) {
        id aModelObj = [[[self class] alloc] initWithDictionary:jsonDic];
        [resultsArray addObject:aModelObj];
    }
    
    return resultsArray;
}

@end
