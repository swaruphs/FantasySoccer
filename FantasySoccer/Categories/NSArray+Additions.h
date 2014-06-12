//
//  NSArray+NSArray_Additions.h
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//


@interface NSArray (Additions)

- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects;

- (NSArray *)deepCopy;

- (NSArray *)reverse;

- (NSArray *)sortedArrayWithAttribute:(NSString *)attributeName ascending:(BOOL)ascending;
- (NSArray *)sortedArrayWithAttributes:(NSArray *)attributeNames ascending:(BOOL)ascending;

- (NSArray *)arrayWithAttributes:(NSString *)attributeName;

- (id)firstObjectOrNil;
- (id)randomObjectOrNil;
- (NSMutableArray *)getDistinctObjects:(NSString *)keySelector;

-(NSDictionary *)getDictioanaryWithKey:(NSString *)key;

/*
 * KVC related addition : find and return the first object in the array whose value for keypath *keypath* is equal to *value*.
 * will return nil if no such object is found.
 */
- (id)firstObjectWithValue:(id)value forKeyPath:(NSString*)keypath;

/*
 * KVC related addition : find and return the objects in the array whose value for keypath *keypath* is equal to *value*.
 * will return an empty array if no such object is found.
 */
- (NSArray*)filteredArrayWithValue:(id)value forKeyPath:(NSString*)keypath;

@end
