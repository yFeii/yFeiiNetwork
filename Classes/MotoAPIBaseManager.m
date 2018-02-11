//
//  MotoAPIBaseManager.m
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import "MotoAPIBaseManager.h"
#import "MotoAPIProxy.h"
#import "MotoApiUtils.h"

#define MotoCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [MotoAPIProxy call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(MotoURLResponse *response) { \
    __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
    [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(MotoURLResponse *response) {                                                        \
    __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
    [strongSelf failedOnCallingAPI:response withErrorType:MotoAPIManagerErrorTypeDefault];    \
    }];                                                                                         \
}

@interface MotoAPIBaseManager ()
@property (nonatomic, strong) id fetchedRawData;
@property (nonatomic, readwrite) MotoAPIManagerErrorType errorType;
@end

@implementation MotoAPIBaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        if ([self conformsToProtocol:@protocol(MotoAPIManager)]) {
            self.child = (id <MotoAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

#pragma mark - <public methods>
- (id)fetchDataWithReformer:(id<MotoAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    NSMutableDictionary *param = [params mutableCopy];
    if ([[MotoApiUtils shareInstance].authToken count]) {
        [param addEntriesFromDictionary:[MotoApiUtils shareInstance].authToken];
    }
    [param addEntriesFromDictionary:[MotoApiUtils shareInstance].commonParam];
    if (childIMP == selfIMP) {
        return param;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return param;
        }
    }
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}

#pragma mark - method for interceptor
- (BOOL)beforePerformSuccessWithResponse:(MotoURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(MotoURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(MotoURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(MotoURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - calling api
- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            if ([self shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            // 如果只走缓存
            if ([self shouldCache]) {
                return 0;
            }
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType) {
                    case MotoAPIManagerRequestTypeGet:
                        MotoCallAPI(GET, requestId);
                        break;
                    case MotoAPIManagerRequestTypePost:
                        MotoCallAPI(POST, requestId);
                        break;
                    case MotoAPIManagerRequestTypePut:
                        MotoCallAPI(PUT, requestId);
                        break;
                    case MotoAPIManagerRequestTypeDelete:
                        MotoCallAPI(DELETE, requestId);
                    default:
                        break;
                }
                [self afterCallingAPIWithParams:[apiParams copy]];
                return requestId;
            }else {
                self.errorMessage = @"请开启网络";
                [self failedOnCallingAPI:nil withErrorType:MotoAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        }else {
            [self failedOnCallingAPI:nil withErrorType:MotoAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}


#pragma mark - <private method>
- (void)loadDataFromNative
{
//    NSString *methodName = self.child.methodName;
//    
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        MotoURLResponse *response = [MotoServiceDataStore getServiceDiskDataWithKey:methodName];
//        [strongSelf successedOnCallingAPI:response];
//    });
}

#pragma mark - <api callBack>
- (void)successedOnCallingAPI:(MotoURLResponse *)response
{
    self.response = response;
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }

    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            //[MotoServiceDataStore storeDiskDataWithObject:response withKey:self.child.methodName];
        }
        
        if ([self beforePerformSuccessWithResponse:response]) {
            [self.delegate managerCallAPIDidSuccess:self];
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:MotoAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(MotoURLResponse *)response withErrorType:(MotoAPIManagerErrorType)errorType
{
    self.response = response;
    self.errorType = errorType;
    if (response.status == MotoURLResponseStatusErrorTimeout && errorType == MotoAPIManagerErrorTypeDefault) {
        self.errorType = MotoAPIManagerErrorTypeTimeout;
        self.errorMessage = @"网络状态不好";
    }
    else if (errorType == MotoAPIManagerErrorTypeDefault) {
        self.errorMessage = @"访问人数饱满，请稍后再试";
    }
    else if (errorType == MotoAPIManagerErrorTypeNoNetWork) {
        self.errorMessage = @"没有网络";
    }
    if ([self beforePerformFailWithResponse:response]) {
        if ([[MotoResponseConcentrateHandleGenerator shareInstance] handleEventWithResponse:self]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
    }
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for child
- (void)cleanData
{
    //[MotoServiceDataStore removeDiskObjectDataWithKey:self.child.methodName];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = MotoAPIManagerErrorTypeDefault;
}

- (BOOL)shouldCache
{
    return [self.child shouldCache];
}

#pragma mark - <get>
- (BOOL)isReachable
{
    BOOL isReachability = [MotoApiUtils shareInstance].isReachable;
    if (!isReachability) {
        self.errorType = MotoAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSString *)serviceType
{
    if ([MotoApiUtils shareInstance].serviceEnv) {
        return @"正式";
    }
    return @"测试";
}

@end
