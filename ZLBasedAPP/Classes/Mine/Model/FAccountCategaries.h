//
//  FAccountCategaries.h
//  ftool
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBaseEntity.h"

@class FFirstType, FSubType;
// 记账类别
@interface FAccountCategaries : ZLBaseEntity

@property (nonatomic, copy) NSMutableArray<FFirstType *> *expensesTypeArr;
@property (nonatomic, copy) NSMutableArray<FFirstType *> *incomeTypeArr;
@property (nonatomic, copy) NSMutableArray<NSString *> *accountTypeArr;
@end


@interface FFirstType : ZLBaseEntity

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic,assign) CGFloat budget;
@property (nonatomic, copy) NSMutableArray<FSubType *> *subTypeArr;


@property (nonatomic,assign) CGFloat initBudget;// 仅随机生成数据时使用

+ (instancetype)firstTypeWithName:(NSString *)name budget:(CGFloat)budget subTypeArr:(NSMutableArray<FSubType *> *)SubTypeArr;
@end

@interface FSubType : ZLBaseEntity

@property (nonatomic, weak) FFirstType *firstType;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isEditable;


@property (nonatomic, copy) NSString *amountRange;// 用于随机生成时，其他时候不用管这个属性


+ (instancetype)subTypeWithName:(NSString *)name;
@end
