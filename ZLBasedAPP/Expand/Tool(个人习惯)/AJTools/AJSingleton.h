//
//  AJSingleton.h
//  SP2P_6.1
//
//  Created by eims on 16/9/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#ifndef AJSingleton_h
#define AJSingleton_h

#define singletonH(name) +(instancetype)shared##name;

#define singletonM(name) \
static id sharedInstance;\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        sharedInstance = [super allocWithZone:zone];\
    });\
    \
    return sharedInstance;\
}\
+ (instancetype)shared##name\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        sharedInstance = [[self alloc]init];\
    });\
    return sharedInstance;\
}\
- (id)copyWithZone:(nullable NSZone *)zone\
{\
    return sharedInstance;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone\
{\
    return sharedInstance;\
}


#endif /* AJSingleton_h */
