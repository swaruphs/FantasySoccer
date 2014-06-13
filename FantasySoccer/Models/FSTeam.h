//
//  FSTeam.h
//  FantasySoccer
//
//  Created by Swarup on 12/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSTeam : FSBaseModel

@property (nonatomic, strong) NSNumber    * teamID;
@property (nonatomic, strong) NSString    * description;
@property (nonatomic, strong) NSString    * name;
@property (nonatomic, strong) NSString    * iconURL;
@property (nonatomic, strong) NSDate      * updatedAt;

@end
