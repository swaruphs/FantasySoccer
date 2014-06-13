//
//  NSArray+NSArray_Additions.m
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects {
  NSMutableArray *pagedArticles = [NSMutableArray array];
  
  __block NSMutableArray *articlesPerPage = [NSMutableArray array];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    [articlesPerPage addObject:obj];
    BOOL shouldAddArticlesToPage = ( (idx > 0 && ((idx+1) % numberOfObjects) == 0) || (idx == self.count-1));    
    if (shouldAddArticlesToPage) { 
      [pagedArticles addObject:[articlesPerPage copy]];
      articlesPerPage = [NSMutableArray array];
    }
  }];
  
  return [pagedArticles copy];
}

- (NSArray *) deepCopy {
  unsigned long count = [self count];
  NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:count];
  
  for (unsigned int i = 0; i < count; ++i) {
    id obj = [self objectAtIndex:i];
    if ([obj respondsToSelector:@selector(deepCopy)])
      [newArray addObject:[obj deepCopy]];
    else
      [newArray addObject:[obj copy]];
  }
  
  NSArray *returnArray = [newArray copy];
  newArray = nil;
  return returnArray;
}

- (NSArray *)reverse
{
    NSArray *reversedArray = [[self reverseObjectEnumerator] allObjects];
    return reversedArray;
}

- (NSArray *)sortedArrayWithAttribute:(NSString *)attributeName ascending:(BOOL)ascending
{
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
    return [self sortedArrayUsingDescriptors:@[firstDescriptor]];
}

- (NSArray *)sortedArrayWithAttributes:(NSArray *)attributeNames ascending:(BOOL)ascending
{
    if ([attributeNames count] <= 0)
        return self;
    
    NSMutableArray * descriptors = [NSMutableArray array];
    for (NSString * attr in attributeNames)
        [descriptors addObject: [[NSSortDescriptor alloc] initWithKey:attr ascending:ascending]];
    
    return [self sortedArrayUsingDescriptors:descriptors];
}

- (NSArray *)arrayWithAttributes:(NSString *)attributeName
{
    NSMutableArray * array = [NSMutableArray array];
    for (id object in self)
        if ([object respondsToSelector:NSSelectorFromString(attributeName)]) {
            id value = [object valueForKey:attributeName];
            if (value)
                [array addObject:value];
        }
    return array;
}

- (id)firstObjectOrNil
{
    if ([self count] <= 0)
        return nil;
    
    return [self objectAtIndex:0];
}

- (id)randomObjectOrNil
{
    if ([self count] <= 0)
        return nil;
    
    if ([self count] == 1)
        return [self firstObjectOrNil];
    
    int n = arc4random_uniform([self count]);
    return [self objectAtIndex:n];
}

- (id)firstObjectWithValue:(id)value forKeyPath:(NSString*)key
{
	for (id object in self)
		if ([[object valueForKeyPath:key] isEqual:value])
			return object;

	return nil;
}

- (NSArray*)filteredArrayWithValue:(id)value forKeyPath:(NSString*)key
{
	NSMutableArray * objects = [NSMutableArray arrayWithCapacity:[self count]];
    
	for (id object in self)
		if ([[object valueForKeyPath:key] isEqual:value])
			[objects addObject:object];

	return [NSArray arrayWithArray:objects];
}

- (NSMutableArray *)getDistinctObjects:(NSString *)keySelector
{
    NSMutableSet* keyValues = [[NSMutableSet alloc] init];
    NSMutableArray* distinctSet = [[NSMutableArray alloc] init];
    for (id item in self) {
        id keyForItem = [item valueForKey:keySelector];
        if (!keyForItem)
            keyForItem = [NSNull null];
        if (![keyValues containsObject:keyForItem]) {
            [distinctSet addObject:item];
            [keyValues addObject:keyForItem];
        }
    }
    return distinctSet;
}

-(NSDictionary *)getDictioanaryWithKey:(NSString *)key
{
    NSArray *keys = [self valueForKey:key];
    if([keys isValidObject]) {
        return nil;
    }
    if([keys count] != [self count]) {
        return nil;
    }
    return [NSDictionary dictionaryWithObjects:self forKeys:keys];
}

@end
