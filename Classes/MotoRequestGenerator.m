//
//  MotoRequestGenerator.m
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import "MotoRequestGenerator.h"
#import "MotoService.h"
#import "MotoSignatureGenerator.h"

const NSTimeInterval requestTimeOut = 10;

@implementation MotoRequestGenerator
+ (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableString *urlString = [[self detecteUrlIsCorrectWithServiceIdentifier:serviceIdentifier methodName:methodName] mutableCopy];
    
    [urlString appendString:[NSString stringWithFormat:@"?%@",[self signWithParam:requestParams methodName:methodName]]];
//    if (requestParams.count) {
//        [urlString appendString:@"?"];
//        for (NSInteger i = 0; i < requestParams.allKeys.count; i++) {
//            NSString *key = requestParams.allKeys[i];
//            [urlString appendString:[NSString stringWithFormat:@"%@=%@",key,requestParams[key]]];
//            if (i != requestParams.allKeys.count - 1) {
//                [urlString appendString:@"&"];
//            }
//        }a
//    }
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [self motoCatRequestWithUrl:urlStr];
    if (requestParams[@"biaoshi"] != nil) {
        [request setValue:requestParams[@"biaoshi"] forHTTPHeaderField:@"biaoshi"];
    }
    request.HTTPMethod = @"GET";
    return request;
}

+ (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableString *urlString = [[self detecteUrlIsCorrectWithServiceIdentifier:serviceIdentifier methodName:methodName] mutableCopy];
    NSMutableURLRequest *request = [self motoCatRequestWithUrl:urlString];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    return request;
}

+ (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableString *urlString = [[self detecteUrlIsCorrectWithServiceIdentifier:serviceIdentifier methodName:methodName] mutableCopy];
    NSMutableURLRequest *request = [self motoCatRequestWithUrl:urlString];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    return request;
}

+ (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableString *urlString = [[self detecteUrlIsCorrectWithServiceIdentifier:serviceIdentifier methodName:methodName] mutableCopy];
    NSMutableURLRequest *request = [self motoCatRequestWithUrl:urlString];
    request.HTTPMethod = @"DELETE";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    return request;
}

+ (NSString *)detecteUrlIsCorrectWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName
{
    NSAssert(serviceIdentifier.length, @"测试服还是正式服给个啊");
    NSString *baseApiUrl = [MotoService getApiBaseUrlWithServiceIdentifier:serviceIdentifier];
    NSAssert(baseApiUrl.length, @"难道没配置服务器地址😂😂😂😂😂😂");
    //NSString *urlString = [NSString stringWithFormat:@"%@%@",baseApiUrl,methodName];
    return baseApiUrl;
}

+ (NSMutableURLRequest *)motoCatRequestWithUrl:(NSString *)urlString
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = requestTimeOut;
    return request;
}

+ (NSString *)signWithParam:(NSDictionary *)param methodName:(NSString *)methodName
{
    NSMutableDictionary *params = [param mutableCopy];
    NSString *sign = [MotoSignatureGenerator signGetWithSigParams:params methodName:methodName apiVersion:[MotoService apiVersion] privateKey:nil publicKey:nil];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:params.allKeys];
    NSMutableString *query = [NSMutableString stringWithCapacity:0];
    if (params.count) {
        for (NSInteger i = 0; i < keys.count; i++) {
            [query appendString:[NSString stringWithFormat:@"%@=%@",keys[i],params[keys[i]]]];
            if (i != keys.count - 1) {
                [query appendString:@"&"];
            }
        }
    }
    [query appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    return query;
}


@end
