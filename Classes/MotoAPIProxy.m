//
//  MotoAPIProxy.m
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import "MotoAPIProxy.h"
#import "MotoRequestGenerator.h"
#import "MotoServiceLogger.h"
#import "AFNetworking.h"

@implementation MotoAPIProxy
+ (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail
{
    NSURLRequest *request = [MotoRequestGenerator generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self debugLogRequest:request serviceIdentifier:servieIdentifier params:params methodName:methodName httpMethod:@"GET"];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

+ (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(MotoURLResponse *))success fail:(void (^)(MotoURLResponse *))fail
{
    NSURLRequest *request = [MotoRequestGenerator generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self debugLogRequest:request serviceIdentifier:servieIdentifier params:params methodName:methodName httpMethod:@"POST"];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

+ (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(MotoURLResponse *))success fail:(void (^)(MotoURLResponse *))fail
{
    NSURLRequest *request = [MotoRequestGenerator generatePutRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self debugLogRequest:request serviceIdentifier:servieIdentifier params:params methodName:methodName httpMethod:@"PUT"];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

+ (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(MotoURLResponse *))success fail:(void (^)(MotoURLResponse *))fail
{
    NSURLRequest *request = [MotoRequestGenerator generateDeleteRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self debugLogRequest:request serviceIdentifier:servieIdentifier params:params methodName:methodName httpMethod:@"DELETE"];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

+ (void)debugLogRequest:(NSURLRequest *)request serviceIdentifier:(NSString *)servieIdentifier params:(NSDictionary *)params methodName:(NSString *)methodName httpMethod:(NSString *)httpMethod
{
    [MotoServiceLogger logDebugInfoWithRequest:request apiName:methodName service:servieIdentifier requestParams:params httpMethod:httpMethod];
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
+ (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(void(^)(MotoURLResponse * response))success fail:(void(^)(MotoURLResponse * response))fail
{
    AFHTTPSessionManager *manager = [self createSessionManager];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = nil;
        if (responseObject) {
            responseData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        }else {
            responseData = nil;
        }
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (error) {
            [MotoServiceLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:error];
            MotoURLResponse *motoResponse = [[MotoURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request content:responseObject responseData:responseData error:error];
            fail?fail(motoResponse):nil;
        }else {
            [MotoServiceLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:nil];
            MotoURLResponse *motoResponse = [[MotoURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request content:responseObject responseData:responseData status:MotoURLResponseStatusSuccess];
            success?success(motoResponse):nil;
        }
        
    }];
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    [dataTask resume];
    
    return requestId;
}

+ (AFHTTPSessionManager *)createSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return manager;
}
@end
