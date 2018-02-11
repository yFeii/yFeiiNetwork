//
//  MotoSignatureGenerator.h
//  test
//
//  Created by wtb on 2017/10/9.
//  Copyright © 2017年 wtb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotoSignatureGenerator : NSObject
+ (NSString *)signGetWithSigParams:(NSMutableDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey;

+ (NSString *)signPostWithApiParams:(NSMutableDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey;
@end
