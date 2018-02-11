//
//  MotoResponseConcentrateHandleGenerator.h
//  test
//
//  Created by wtb on 2017/10/19.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotoURLResponse.h"
@class MotoAPIBaseManager;

@interface MotoResponseConcentrateHandleGenerator : NSObject
@property (nonatomic, strong) MotoAPIBaseManager *baseManager;
+ (instancetype)shareInstance;

- (BOOL)handleEventWithResponse:(MotoAPIBaseManager *)manager;
@end
