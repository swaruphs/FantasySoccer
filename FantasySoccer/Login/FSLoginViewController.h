//
//  FSLoginViewController.h
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FSLoginViewController : UIViewController <FBLoginViewDelegate>

@property(nonatomic) BOOL hideControls;
- (void)hideControls:(BOOL)hidden;

@end
