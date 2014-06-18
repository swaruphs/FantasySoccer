//
//  FSAppDelegate.h
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import <FacebookSDK/FacebookSDK.h>



@interface FSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) IIViewDeckController *viewDeckController;

- (void)showLoginView:(BOOL)hideControls;
- (void)changeCenterViewControllerToViewController:(UIViewController *)controller;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)logoutWithMessage:(NSString *)message;
- (void)logoutUserAndClearToken;
@end
