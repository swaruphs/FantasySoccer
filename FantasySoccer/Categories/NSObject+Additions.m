//
//  NSObject+Additions.m
//
//  Created by Jesper Särnesjö on 2010-05-29.
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import "NSObject+Additions.h"
#import <objc/runtime.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSObject (Additions)

- (id)ifKindOfClass:(Class)c
{
  return [self isKindOfClass:c] ? self : nil;
}

+ (void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel
{
  Class class = [self class];
  
  Method origMethod = class_getInstanceMethod(class, origSel);
  if (!origMethod){
    origMethod = class_getClassMethod(class, origSel);
  }
  if (!origMethod)
    @throw [NSException exceptionWithName:@"Original method not found" reason:nil userInfo:nil];
  Method newMethod = class_getInstanceMethod(class, newSel);
  if (!newMethod){
    newMethod = class_getClassMethod(class, newSel);
  }
  if (!newMethod)
    @throw [NSException exceptionWithName:@"New method not found" reason:nil userInfo:nil];
  if (origMethod==newMethod)
    @throw [NSException exceptionWithName:@"Methods are the same" reason:nil userInfo:nil];
  method_exchangeImplementations(origMethod, newMethod);
}

- (NSString *)getCurrentSSID
{
    NSString *currentSSID = nil;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray == nil)
        return nil;
    
    NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    if (myDict != nil)
        currentSSID = [myDict valueForKey:@"SSID"];
    
    return currentSSID;
}

- (BOOL)use3g
{
    BOOL use3g = YES;
    NSString *ssid = [[self getCurrentSSID] lowercaseString];
    if (ssid == nil || IS_SIMULATOR)
        use3g = NO;
    
    return use3g;
}



#pragma mark - Social Helpers

- (BOOL)hasNativeFacebookApp
{
    NSURL *url = [NSURL URLWithString:@"fb://profile/566862027"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    return canOpen;
}

- (BOOL)openFacebookPageID:(NSString*)pageID
{
    BOOL hasNativeApp = [self hasNativeFacebookApp];
    
    //Open with native Facebook app
    if (hasNativeApp) {
        NSString *url = [NSString stringWithFormat:@"fb://profile/%@", pageID];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
        return YES;
    }
    
    //Open in Safari browser
    NSString *url = [NSString stringWithFormat:@"http://facebook.com/%@", pageID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    return NO;
}

- (BOOL)hasNativeTwitterApp
{
    NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=torinnguyen"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    return canOpen;
}

- (BOOL)openTwitterScreenName:(NSString*)screenName
{
    BOOL hasNativeApp = [self hasNativeFacebookApp];
    
    //Open with native Twitter app
    if (hasNativeApp) {
        NSString *url = [NSString stringWithFormat:@"twitter://user?screen_name=%@", screenName];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
        return YES;
    }
    
    //Open in Safari browser
    NSString *url = [NSString stringWithFormat:@"url://twitter.com/%@", screenName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    return NO;
}

- (BOOL)isValidObject {
    BOOL valid = NO;
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        valid = YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        valid = ![(NSString *)self isEqualToString:@"<null>"];
    }
    
    return valid;
}

@end
