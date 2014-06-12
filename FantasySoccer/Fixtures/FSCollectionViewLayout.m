//
//  HSCollectionViewLayout.m
//  UVDetailSample
//
//  Created by Swarup on 30/5/14.
//  Copyright (c) 2014 Swarup. All rights reserved.
//

#import "FSCollectionViewLayout.h"

#define ITEM_WIDTH

@interface FSCollectionViewLayout()

@property (nonatomic, retain) NSDictionary * layoutInfo;
@property (nonatomic) CGSize size;

@end


@implementation FSCollectionViewLayout


- (id)initWithItemSize:(CGSize)size
{
    self = [self init];
    if (self) {
        self.size = size;
    }
    
    return self;
}

-(void)prepareLayout{
    
    [super prepareLayout];
    
    NSMutableDictionary *layoutDic = [NSMutableDictionary dictionary];
    int noOfItems  = [self.collectionView numberOfItemsInSection:0];
    CGFloat originY = 0;
    for (int index  = 0 ; index <noOfItems; index ++) {
        
        NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:index inSection:0];
        CGRect frame  = CGRectMake(0, originY, self.size.width, self.size.height);
        UICollectionViewLayoutAttributes *attributes  = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        [attributes setFrame:frame];
        originY += self.size.height;
        [layoutDic setObject:attributes forKey:indexPath];
    }
    
    self.layoutInfo = layoutDic;
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *elementsArray = [NSMutableArray array];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [elementsArray addObject:attributes];
        }
    }];
    
    return elementsArray;
    
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutInfo objectForKey:indexPath];
}

- (CGSize)collectionViewContentSizes
{
    NSUInteger items  = [self.collectionView numberOfItemsInSection:0];
    CGSize size  = CGSizeMake(320, items * self.size.height);
    
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (CGFloat)getCurrentIndex
{
    return self.collectionView.contentOffset.y / self.size.height;
}
@end
