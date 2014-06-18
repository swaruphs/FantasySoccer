//
//  FSRefreshModelManager.h
//  FantasySoccer
//
//  Created by Swarup on 17/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseManager.h"

@class FSRefreshModelManager;

@protocol FSRefreshModelManagerDelegate <NSObject>


-(void)refreshManagerDidFinishRefresh:(FSRefreshModelManager *)manager;

@end

@interface FSRefreshModelManager : BaseManager

@property (nonatomic, retain)id <FSRefreshModelManagerDelegate> delegate;

- (void)refreshModels;
@end
