//
//  MotoService.h
//  MotoCat
//
//  Created by Tianbiao Wang on 17/5/18.
//  Copyright © 2017年 Tianbiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotoService : NSObject
+ (NSString *)getApiBaseUrlWithServiceIdentifier:(NSString *)serviceIdentifier;

+ (NSString *)apiVersion;
@end
