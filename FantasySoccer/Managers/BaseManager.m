//
//  BaseManager.m
//  TemplateProject
//
//  Created by Torin on 4/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseManager.h"

@interface BaseManager()
@property (nonatomic, strong) NSMutableArray * dataArray;
@end


@implementation BaseManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
	
    dispatch_once(&pred, ^{ __singleton = [[self alloc] init]; });
    return __singleton;
}


#pragma mark - Offline files

+ (NSData*)loadJSONDataFromFileName:(NSString *)filename
{
  if ([filename length] <= 0)
    return nil;
  
  if ([filename hasSuffix:@"json"] == YES)
    filename = [filename stringByReplacingOccurrencesOfString:@".json"
                                                   withString:@""
                                                      options:NSCaseInsensitiveSearch
                                                        range:NSRangeFromString(filename)];
  
  //Read JSON file
  NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
  NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
  if (fileData == nil)
    return nil;
  
  return fileData;
}

+ (id)loadJSONObjectFromFileName:(NSString*)filename
{
  NSData *fileData = [BaseManager loadJSONDataFromFileName:filename];
  if (fileData == nil)
    return nil;
  
  //iOS5 JSON Framework
  NSError *error;
  NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:fileData
                                                            options:kNilOptions
                                                              error:&error];
  
  //File contains error
  if (error != nil)
    return error;
  
  return jsonArray;
}

#pragma mark -  class methods
- (void)sendNotification:(NSString *)notificationName
{
	[self sendNotification:notificationName body:nil type:nil];
}


- (void)sendNotification:(NSString *)notificationName body:(id)body
{
	[self sendNotification:notificationName body:body type:nil];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type
{
	NSMutableDictionary *dic = nil;
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notificationName object:self userInfo:dic]];
}

- (void)sendSuccess:(void (^)(id obj))success withData:(id)data;
{
    [self sendMessageToBlock:success withData:data];
}

- (void)sendFailure:(void (^)(id obj))failure withData:(id)data
{
    [self sendMessageToBlock:failure withData:data];
}

#pragma mark - Private Methods

-(void)sendMessageToBlock:(void(^)(id obj))block withData:(id)data
{
    if(block) {
        block(data);
    }
}
@end
