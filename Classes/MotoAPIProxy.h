//
//  MotoAPIProxy.h
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotoURLResponse.h"


@interface MotoAPIProxy : NSObject
+ (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail;
+ (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail;
+ (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail;
+ (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail;


+ (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail;
@end
