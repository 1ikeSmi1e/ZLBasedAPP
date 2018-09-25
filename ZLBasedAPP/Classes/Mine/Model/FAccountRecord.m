//
//  FAccountRecord.m
//  ftool
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FAccountRecord.h"

@implementation FCurrentMonthRecord

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"incomeArr": [FAccountRecord class], @"expandseArr": [FAccountRecord class]};
}
@end

@implementation FAccountRecord

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.editTime = [NSDate getDateString:[NSDate date] format:@"yyyyMMddHHmmss"];
    }
    return self;
}

- (void)copyPropertyWithRecord:(FAccountRecord *)record{
    
    self.amount = record.amount;
    self.firstType = record.firstType;
    self.subType = record.subType;
    self.accountType = record.accountType;
    self.time_minute = record.time_minute;
    self.time_month = record.time_month;
    self.remarks = record.remarks;
    self.editTime = [NSDate getDateString:[NSDate date] format:@"yyyyMMddHHmmss"];
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"subType": [FSubType class], @"firstType": [FFirstType class]};
}

+ (instancetype)recordRandomIncomeWithtime_minute:(NSString *)time_minute time_month:(NSString *)time_month{
    
    FAccountRecord *bean = [[FAccountRecord alloc] init];
    bean.time_month = time_month;// yyyy年MM月
    bean.time_minute = time_minute;// MM月dd日HH时mm分
    
    NSDate *date = [NSDate getDate:[time_month stringByAppendingString:time_minute] format:@"yyyy年MM月MM月dd日HH时mm分"];
    NSDate *target = [date dateByAddingTimeInterval:60*60];
    bean.editTime = [NSDate getDateString:target format:@"yyyyMMddHHmmss"];
    
    int x = arc4random() % 1000000;
    if (x==0) {
        x += 1;
    }
    CGFloat amount = x/100.f;
    bean.amount = amount;
    
    NSArray *firstArr = AppDelegateInstance.aFAccountCategaries.incomeTypeArr;
    bean.firstType = firstArr[x % firstArr.count];
    
    NSArray *subTypeArr = bean.firstType.subTypeArr;
    bean.subType = subTypeArr[ x % subTypeArr.count];
    
    NSArray *accoutArr = AppDelegateInstance.aFAccountCategaries.accountTypeArr;
    bean.accountType = accoutArr[x % accoutArr.count];
    
    NSArray *remarks = @[@"公司发工资补贴", @"公司发高温补贴",@"公司发出差补贴",@"公司发电话补贴",@"公司发住房补贴",@"公司发餐饮补贴",@"公司发交通补贴",@"公司发网络补贴", @"公司发生日补贴",@"公司发过节费",@"公司发项目提成", @"公司季度奖金", @"公司发小孩营养费",@"公司小孩助学补贴",@"P2P理财收益", @"基金收益", @"股票收益", @"打麻将", @"足球彩票", @"福利彩票"];
    bean.remarks = remarks[x % remarks.count];
    return bean;
}

- (void)setNomalExpanseAmountWithRandom:(CGFloat)x{
    
    NSArray *min_maxArr = [self.subType.amountRange componentsSeparatedByString:@"-"];
    CGFloat minAmount = [min_maxArr[0] doubleValue];
    CGFloat maxAmoutn = [min_maxArr[1] doubleValue];
    
    if (x < minAmount) {
        
        self.amount = minAmount + minAmount-x;
    }else if(x > maxAmoutn){
        
        self.amount = maxAmoutn - (x-maxAmoutn);
    }else{
        self.amount = x;
    }
}

// 随机生成支出记录
+ (instancetype)recordRandomExpandseWithtime_minute:(NSString *)time_minute time_month:(NSString *)time_month
{
    FAccountRecord *bean = [[FAccountRecord alloc] init];
    bean.time_month = time_month;
    bean.time_minute = time_minute;
    
    NSDate *date = [NSDate getDate:[time_month stringByAppendingString:time_minute] format:@"yyyy年MM月MM月dd日HH时mm分"];
    NSDate *target = [date dateByAddingTimeInterval:60*60];
    bean.editTime = [NSDate getDateString:target format:@"yyyyMMddHHmmss"];
    
    int x = arc4random() % 10000;
    if (x==0) {
        x += 1;
    }
    // 1.设置预算为初始预算；2.生成一个符合子类型支出范围的随机的金额
    //
    NSArray *firstArr = AppDelegateInstance.aFAccountCategaries.expensesTypeArr;
    bean.firstType = firstArr[x % firstArr.count];
    bean.firstType.budget = bean.firstType.initBudget;
    
    NSArray *subTypeArr = bean.firstType.subTypeArr;
    bean.subType = subTypeArr[ x % subTypeArr.count];
    
    // 金额
    NSArray *min_maxArr = [bean.subType.amountRange componentsSeparatedByString:@"-"];
    CGFloat minAmount = [min_maxArr[0] doubleValue];
    CGFloat maxAmoutn = [min_maxArr[1] doubleValue];
    [bean setNomalExpanseAmountWithRandom:x];
    while (bean.amount<minAmount || bean.amount > maxAmoutn) {
        [bean setNomalExpanseAmountWithRandom:bean.amount];
    }
    
    NSArray *accoutArr = AppDelegateInstance.aFAccountCategaries.accountTypeArr;
    bean.accountType = accoutArr[x % accoutArr.count];
    
//    NSArray *remarks = @[@"柴米油盐", @"鞋子",@"自己衣服",@"汽车加油",@"回家高铁票",@"回家飞机票",@"小孩衣服",@"化妆品", @"同事聚餐",@"朋友聚餐",@"地铁充值", @"话费充值", @"华为手机",@"小孩学费",@"小孩营养品", @"感冒发烧看病费用", @"股票损失", @"打麻将输钱", @"足球彩票", @"福利彩票", @"买电动车给爸妈", @"买玩具", @"夏威夷旅游", @"哈尔滨之旅", @"西藏之旅", @"昆明之旅", @"桂林之旅", @"打车费用", @"生活用品", @"买钢琴",@"高级UI设计师学习班", @"微信红包", @"快餐吃饭", @"KTV唱歌",@"看电影", @"星巴克咖啡", @"打台球场地费", @"羽毛球场地费",@"游戏充值", @"华为手环", @"书籍", @"游泳场地费用", @"健身年卡", @"养殖花", @"宠物扶养费"];
    bean.remarks = [NSString stringWithFormat:@"%@-", bean.subType.name /*,remarks[x % remarks.count]*/];
    return bean;
}
@end
