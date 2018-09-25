//
//  FAccountCategaries.m
//  ftool
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FAccountCategaries.h"

@implementation FAccountCategaries

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"expensesTypeArr": [FFirstType class], @"incomeTypeArr": [FFirstType class]};
}

@end

@implementation FFirstType

+ (instancetype)firstTypeWithName:(NSString *)name budget:(CGFloat)budget subTypeArr:(NSMutableArray<FSubType *> *)subTypeArr{
    
    FFirstType *bean = [FFirstType new];
    bean.name = name;
    bean.budget = budget;
    bean.subTypeArr = subTypeArr;
    
    return bean;
}

- (NSString *)iconName{
    
    if (!_iconName) {
        return @"FirstType_10";
    }
    return _iconName;
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"subTypeArr": [FSubType class]};
}
@end


@implementation FSubType

+ (instancetype)subTypeWithName:(NSString *)name{
    
    FSubType *bean = [FSubType new];
    bean.name = name;
    
    return bean;
}

- (NSString *)iconName{
    
    if (!_iconName) {
        
        int x = arc4random() % 10;
        if (x==0) {
            x += 1;
        }
        return [NSString stringWithFormat:@"FirstType_%02d", x];
    }
    return _iconName;
}
@end
