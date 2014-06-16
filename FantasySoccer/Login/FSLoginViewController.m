//
//  FSLoginViewController.m
//  FantasySoccer
//
//  Created by Swarup on 10/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSFixturesViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FSLoginViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIButton *fbBtn;

@end

@implementation FSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _init];
    // Do any additional setup after loading the view from its nib.
}

- (void)_init
{
    self.lblTitle.font = [UIFont neutraTextBoldFontNameOfSize:36];
    
    NSMutableParagraphStyle * paraStyle= [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 12;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attrString  = [[NSAttributedString alloc] initWithString:@"SOCCER\nFANTASY" attributes:attrDic];
    

    self.lblTitle.attributedText = attrString;
    
}

- (IBAction)buttonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             FSAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
