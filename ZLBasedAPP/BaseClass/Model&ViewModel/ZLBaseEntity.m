//
//  BaseEntity.m
//  MobilePaymentOS
//
//  Created by admin on 2018/4/24.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import "ZLBaseEntity.h"

@implementation ZLBaseEntity

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self mj_objectWithKeyValues:dictionary];
}
@end
