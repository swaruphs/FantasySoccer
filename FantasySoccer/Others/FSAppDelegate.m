//
//  FSAppDelegate.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FSRefreshModelManager.h"
#import "FSOnBoardingViewController.h"
#import "DDLog.h"



@interface FSAppDelegate()

@property (nonatomic, strong) UIImageView *splashImageView;
@property (nonatomic, strong) FSLoginViewController *loginController;

@end

@implementation FSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setUpLogger];
    [self setUpProgressView];
    [self setUpAnalytics];
    
    // track app with launching options.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // Override point for customization after application launch.
    
    BOOL alreadyLoggedIn = [[FSCredentialsManager sharedInstance] isFirstTimeLogin];
    if (!alreadyLoggedIn) {
        FSOnBoardingViewController *controller = [[FSOnBoardingViewController alloc] initWithNibName:NSStringFromClass([FSOnBoardingViewController class]) bundle:nil];
        self.window.rootViewController = controller;
    }
    else {
        [self showLoginView:YES];
        if ([[[FSCredentialsManager sharedInstance] getSavedToken] isValidObject]) {
            [self getUserProfile];
        }
        else  {
            [self accessFBToken];
        }
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setUpProgressView
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:47/255.0f green:47/255.0f blue:47/255.0f alpha:1.0]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
}

- (void)setUpLogger
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
}


- (void)setUpAnalytics
{
    [Parse setApplicationId:@"kHfDYOwULvY4reMM9YlN6co9001aYh3K9fBNVbR6"
                  clientKey:@"vMUENCY1v8bXKPpak74fXoN0PNRoO9V9BpEDr75t"];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([[FSUserManager sharedInstance] isLoggedIn]) {
        [[FSRefreshModelManager sharedInstance] refreshModels];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBAppCall handleDidBecomeActive];
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FSTournamentsManager sharedInstance] clearSavedData];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)accessFBToken
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    else {
        [self showLoginView:FALSE];
    }
}

- (void)getFBUser
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if ([error isValidObject]) {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                return;
            }
            [self loginUser:user];
            
        }];
    }
}


- (void)loginUser:(NSDictionary<FBGraphUser> *)user
{
    [[FSUserManager sharedInstance] loginWithUsernameOrEmail:user fbToken:FBSession.activeSession.accessTokenData.accessToken  success:^(BOOL success) {                    [[FSCredentialsManager sharedInstance] markFirstTimeLogin];
        [self getUserProfile];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)getUserProfile
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[FSUserManager sharedInstance] getPlayerProfileWithSuccess:^(FSUserProfile *userProfile) {
        [SVProgressHUD dismiss];
        
        [[FSTrackEventManager sharedInstance] trackEventWithName:@"Login" withDimensions:@{@"name":userProfile.userName}];
        [self showMainView];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)showLoginView:(BOOL)hideControls
{
    if ([self.window.rootViewController isKindOfClass:[FSOnBoardingViewController class]]) {
        return;
    }
    if(!self.loginController) {
        FSLoginViewController *loginViewController = [[FSLoginViewController alloc] initWithNibName:@"FSLoginViewController" bundle:nil];
        self.window.rootViewController = loginViewController;
        self.loginController = loginViewController;
    }
    [self.loginController hideControls:hideControls];
    
}

- (void)showMainView
{
    FSFixturesViewController *rootViewController = [[FSFixturesViewController alloc] initWithNibName:NSStringFromClass([FSFixturesViewController class]) bundle:nil];
    UINavigationController *fixNavController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    FSSidePanelViewController *sidePanelViewController = [[FSSidePanelViewController alloc] initWithNibName:NSStringFromClass([FSSidePanelViewController class]) bundle:nil];
    UINavigationController *spNavController = [[UINavigationController alloc] initWithRootViewController:sidePanelViewController];
    
    IIViewDeckController *viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:fixNavController leftViewController:spNavController];
    self.viewDeckController =  viewDeckController;
    self.window.rootViewController = viewDeckController;
    self.loginController = nil;
}

- (void)changeCenterViewControllerToViewController:(UIViewController *)controller
{
    self.viewDeckController.centerController = controller;
    [self.viewDeckController closeLeftView];
}


// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self getFBUser];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self showLoginView:NO];
        return;
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error %@",error);
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
             
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
             
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self showLoginView:NO];
    }
}

/**
 *  Logout user with a error message
 *
 *  @param message message to be displayed
 */
- (void)logoutWithMessage:(NSString *)message
{
    [self logoutUserAndClearToken];
    [SVProgressHUD showErrorWithStatus:message];
}


- (void)logoutUserAndClearToken
{
    [[FSUserManager sharedInstance] logout];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self showLoginView:NO];
}
@end
