//
//  MotoAPIBaseManager.h
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotoResponseConcentrateHandleGenerator.h"

@class MotoAPIBaseManager;

typedef NS_ENUM (NSUInteger, MotoAPIManagerErrorType){
    MotoAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    MotoAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    MotoAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    MotoAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    MotoAPIManagerErrorTypeTimeout,       //请求超时。MotoAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看MotoAPIProxy的相关代码。
    MotoAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, MotoAPIManagerRequestType){
    MotoAPIManagerRequestTypeGet,
    MotoAPIManagerRequestTypePost,
    MotoAPIManagerRequestTypePut,
    MotoAPIManagerRequestTypeDelete
};

//api回调
@protocol MotoAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(MotoAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(MotoAPIBaseManager *)manager;
@end

//负责重新组装API数据的对象
@protocol MotoAPIManagerDataReformer <NSObject>
@required
- (id)manager:(MotoAPIBaseManager *)manager reformData:(NSDictionary *)data;
@end

//验证器，用于验证API的返回或者调用API的参数是否正确
@protocol MotoAPIManagerValidator <NSObject>
@required
- (BOOL)manager:(MotoAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(MotoAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

//让manager能够获取调用API所需要的数据
@protocol MotoAPIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(MotoAPIBaseManager *)manager;
@end

/*
 MotoAPIBaseManager的派生类必须符合这些protocal
 */
@protocol MotoAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (MotoAPIManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

@end

/*
 MotoAPIBaseManager的派生类必须符合这些protocal
 */
@protocol MotoAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(MotoAPIBaseManager *)manager beforePerformSuccessWithResponse:(MotoURLResponse *)response;
- (void)manager:(MotoAPIBaseManager *)manager afterPerformSuccessWithResponse:(MotoURLResponse *)response;

- (BOOL)manager:(MotoAPIBaseManager *)manager beforePerformFailWithResponse:(MotoURLResponse *)response;
- (void)manager:(MotoAPIBaseManager *)manager afterPerformFailWithResponse:(MotoURLResponse *)response;

- (BOOL)manager:(MotoAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(MotoAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

@interface MotoAPIBaseManager : NSObject
@property (nonatomic, weak) id<MotoAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<MotoAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<MotoAPIManagerValidator> validator;
@property (nonatomic, weak) NSObject<MotoAPIManager> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<MotoAPIManagerInterceptor> interceptor;

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, readonly) MotoAPIManagerErrorType errorType;
@property (nonatomic, strong) MotoURLResponse *response;

- (id)fetchDataWithReformer:(id<MotoAPIManagerDataReformer>)reformer;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

// 测试服还是正式服
- (NSString *)serviceType;

/*
用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;
@end
