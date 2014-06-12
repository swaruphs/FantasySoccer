//
//  FSBaseModel.h
//  FantasySoccer
//
//  Created by Swarup on 11/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBaseModel : NSObject

- (id)initWithDictionary:(NSDictionary *)jsonDic;
+ (NSMutableArray *)populateModelWithData:(NSArray *)dataArray;
@end
