//
//  MotoService.m
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import "MotoService.h"
#import "MotoApiUtils.h"

@implementation MotoService
+ (NSString *)getApiBaseUrlWithServiceIdentifier:(NSString *)serviceIdentifier
{
    if ([serviceIdentifier isEqualToString:@"测试"]) {
        return [self offlineApiBaseUrl];
    }
    return [self onlineApiBaseUrl];
}

+ (NSString *)offlineApiBaseUrl
{
    return [MotoApiUtils shareInstance].baseUrlTest;
}

+ (NSString *)onlineApiBaseUrl
{
    return [MotoApiUtils shareInstance].baseUrlRease;
}

+ (NSString *)apiVersion
{
    return [MotoApiUtils shareInstance].apiVersion;
}
@end
