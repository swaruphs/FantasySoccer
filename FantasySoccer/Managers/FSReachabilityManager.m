//
//  EGCReachabilityManager.m
//  EagleChild
//
//  Created by Triệu Khang on 12/12/13.
//
//

#import "FSReachabilityManager.h"
#import "Reachability.h"

@interface FSReachabilityManager()

@property (nonatomic) Reachability * hostReachability;
@property (nonatomic) Reachability * internetReachability;
@property (nonatomic) Reachability * wifiReachability;
@property (assign) BOOL              accessisble;

@end

@implementation FSReachabilityManager

SINGLETON_MACRO

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = API_SERVER_HOST;
    
	self.hostReachability = [Reachability reachabilityWithHostname:remoteHostName];
	[self.hostReachability startNotifier];

    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];

    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
    
    self.accessisble = [self canAccessToInternet:self.wifiReachability] | [self canAccessToInternet:self.internetReachability];
    
    return self;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability * curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    self.accessisble = [self canAccessToInternet:curReach];
}

- (BOOL)canAccessToInternet:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    return netStatus > 0 ? YES : NO;
}

- (BOOL)accessibleToInternet
{
    if ([self canAccessToInternet:self.hostReachability]) {
        return YES;
    }
    
    if ([self canAccessToInternet:self.internetReachability]) {
        return YES;
    }
    
    if ([self canAccessToInternet:self.wifiReachability]) {
        return YES;
    }
    
    return self.accessisble;
}


@end
