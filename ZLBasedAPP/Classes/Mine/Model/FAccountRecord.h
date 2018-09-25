//
//  FAccountRecord.h
//  ftool
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseEntity.h"

@class FFirstType, FSubType, FAccountRecord;

@interface FCurrentMonthRecord : ZLBaseEntity
// 在有编辑的地方记得保存到本地doctment，下次启动才能读取到，否则数据丢失
@property (nonatomic,strong) NSMutableArray<FAccountRecord *> *incomeArr;
@property (nonatomic,strong) NSMutableArray<FAccountRecord *> *expandseArr;
@end


@interface FAccountRecord : ZLBaseEntity

@property (nonatomic,assign) CGFloat amount;

@property (nonatomic,strong) FFirstType *firstType;
@property (nonatomic,strong) FSubType *subType;

@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *time_minute;//MM月dd日HH时mm分
@property (nonatomic, copy) NSString *time_month;// yyyy年MM月
@property (nonatomic, copy) NSString *remarks;


/**
 编辑的时间
 * 1. 新生成的记录，设定当前时间
 * 2. 从存储中取数据时会新赋值，所以初始化设置当前时间时会在取存储的数据时覆盖，不会导致时间出错
 * 3. 调用-copyPropertyWithRecord：方法时要设置时间为当前时间
 */
@property (nonatomic, copy) NSString *editTime;//编辑时间，yyyyMMddHHmmss


- (void)copyPropertyWithRecord:(FAccountRecord *)record;
// 随机生成收入记录
+ (instancetype)recordRandomIncomeWithtime_minute:(NSString *)time_minute time_month:(NSString *)time_month;

// 随机生成支出记录
+ (instancetype)recordRandomExpandseWithtime_minute:(NSString *)time_minute time_month:(NSString *)time_month;
@end
