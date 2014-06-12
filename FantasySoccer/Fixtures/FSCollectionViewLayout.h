//
//  HSCollectionViewLayout.h
//  UVDetailSample
//
//  Created by Swarup on 30/5/14.
//  Copyright (c) 2014 Swarup. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  FSCollectionViewLayoutDelegate <NSObject>

@optional
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;


@end


@interface FSCollectionViewLayout : UICollectionViewLayout

- (id)initWithItemSize:(CGSize)size;

@end
