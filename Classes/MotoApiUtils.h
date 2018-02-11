//
//  MotoApiUtils.h
//  test
//
//  Created by wtb on 2017/9/30.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger,serviceEnvType) {
    serviceEnvTypeTest,
    serviceEnvTypeRelease
};

@interface MotoApiUtils : NSObject
// token
@property (nonatomic, strong, readonly) NSDictionary *authToken;

// 服务端地址(正式环境)
@property (nonatomic, strong) NSString *baseUrlRease;

// 服务端地址(测试环境)
@property (nonatomic, strong) NSString *baseUrlTest;

// 服务端环境
@property (nonatomic, assign) serviceEnvType serviceEnv;

// api版本
@property (nonatomic, assign) NSString *apiVersion;

// 公共参数,除了api版本
@property (nonatomic, strong, readonly) NSDictionary *commonParam;

// 网络状态
@property (nonatomic, assign, readonly) BOOL isReachable;

+ (instancetype)shareInstance;

/**
 * @param accessToken token
 */
- (void)updateAccessToken:(NSDictionary *)accessToken;

/**
 * @param param 公共参数
 */
- (void)PublicParameters:(NSDictionary *)param;

@end
