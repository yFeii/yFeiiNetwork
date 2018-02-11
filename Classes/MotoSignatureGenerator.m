//
//  MotoSignatureGenerator.m
//  test
//
//  Created by wtb on 2017/10/9.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import "MotoSignatureGenerator.h"

@implementation MotoSignatureGenerator
+ (NSString *)signGetWithSigParams:(NSMutableDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    return @"";
}

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    return @"";
}

+ (NSString *)signPostWithApiParams:(NSMutableDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    return @"";
}

+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    return @"";
}
@end
