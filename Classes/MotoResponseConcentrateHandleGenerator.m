//
//  MotoResponseConcentrateHandleGenerator.m
//  test
//
//  Created by wtb on 2017/10/19.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import "MotoResponseConcentrateHandleGenerator.h"

@implementation MotoResponseConcentrateHandleGenerator
+ (instancetype)shareInstance
{
    static MotoResponseConcentrateHandleGenerator *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MotoResponseConcentrateHandleGenerator alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)handleEventWithResponse:(MotoAPIBaseManager *)manager
{
    return YES;
}
@end
