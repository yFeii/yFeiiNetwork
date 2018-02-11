//
//  MotoApiUtils.m
//  test
//
//  Created by wtb on 2017/9/30.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import "MotoApiUtils.h"
#import "AFNetworking.h"

NSString *const MotoUserValidTokenKey = @"MotoUserToken";

@interface MotoApiUtils()
@property (nonatomic, strong) NSDictionary *authToken;
@property (nonatomic, strong) NSDictionary *commonParam;
@end

@implementation MotoApiUtils
+ (instancetype)shareInstance
{
    static MotoApiUtils *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MotoApiUtils alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (void)updateAccessToken:(NSDictionary *)accessToken
{
    if (accessToken.count) {
        self.authToken = accessToken;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:MotoUserValidTokenKey]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MotoUserValidTokenKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:MotoUserValidTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:MotoUserValidTokenKey];
    }
}

- (void)PublicParameters:(NSDictionary *)param
{
    self.commonParam = param;
}

@end
