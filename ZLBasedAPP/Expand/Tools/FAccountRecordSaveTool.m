//
//  FAccountRecordSaveTool.m
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FAccountRecordSaveTool.h"

// 在存储时，需要添加这个数组再存，否则会数据丢失
static NSMutableArray *expiredDateExpandseArr;
//static BOOL  isFormDocumentDirectory = YES;

@implementation FAccountRecordSaveTool

+ (BOOL)saveCurrentMonthBlanceRecords
{
    FAccountRecord *bean = AppDelegateInstance.currentMonthRecord.expandseArr.firstObject;
    NSDate *lastDate = [NSDate getDate:bean.time_month format:@"yyyy年MM月"];
    NSInteger year = lastDate.year;
    NSInteger month = lastDate.month;
    NSString *targetDateStr = [NSString stringWithFormat:@"%04d%02d", (int)year, (int)month];
    
    NSString *userName = nil;
    DLOG(@"AppDelegateInstance.userInfo.phone = %@", AppDelegateInstance.userInfo.phone);
    if ([AppDelegateInstance.userInfo.phone isEqualToString:defName]) {
        
        userName = @"default";
    }else if(AppDelegateInstance.userInfo.phone.length>0){
        
        userName = AppDelegateInstance.userInfo.phone;
    }else{
        
        return NO;
    }
    NSString *fileName = [NSString stringWithFormat:@"F_%@_%@.txt", userName, targetDateStr];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
//    AppDelegateInstance.currentMonthRecord.expandseArr
    NSDictionary *month4Account = [AppDelegateInstance.currentMonthRecord mj_JSONObject];
    NSString *jsonString = [month4Account mj_JSONString];
    NSString *jsonstringLast = [NSString stringWithContentsOfFile:filePathName encoding:NSUTF8StringEncoding error:nil];
    
    if ([[jsonstringLast md5] isEqualToString:[jsonString md5]]) {// 未更改
        return YES;
    }
    
    BOOL isSuccess = [jsonString writeToFile:filePathName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return isSuccess;
}


+ (FCurrentMonthRecord *)readLoaclCurrentMonthBlanceRecords{
    
    NSInteger year = [NSDate date].year;
    NSInteger month = [NSDate date].month;
    NSString *targetDateStr = [NSString stringWithFormat:@"%04d%02d", (int)year, (int)month];
//    targetDateStr = @"201806";
    NSString *userName = nil;
    DLOG(@"AppDelegateInstance.userInfo.phone = %@", AppDelegateInstance.userInfo.phone);
    if ([AppDelegateInstance.userInfo.phone isEqualToString:defName]) {
        
         userName = @"default";
    }else if(AppDelegateInstance.userInfo.phone.length>0){
        
        userName = AppDelegateInstance.userInfo.phone;
    }else{
        
        return nil;
    }

    NSString *fileName = [NSString stringWithFormat:@"F_%@_%@.txt", userName, targetDateStr];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    NSString *jsonstring = [NSString stringWithContentsOfFile:filePathName encoding:NSUTF8StringEncoding error:nil];
    
    BOOL isFormDocumentDirectory = YES;
    if (!jsonstring && [userName isEqualToString:@"default"]) {// 不存在而且读取APP里面设定的
        
        filePathName = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        jsonstring = [NSString stringWithContentsOfFile:filePathName encoding:NSUTF8StringEncoding error:nil];
        isFormDocumentDirectory = NO;
    }
    FCurrentMonthRecord *targetMonthRecord = [FCurrentMonthRecord mj_objectWithKeyValues:jsonstring];
    
    // 如果是默认用户，需要先拿走超过当前日期的记录，但是不能删除，也不能直接引用。需要先保存，并且在存储数据的时候需要添加保存的这部分再一起写进文件
    if ([userName isEqualToString:@"default"] && isFormDocumentDirectory == NO) {
        
        expiredDateExpandseArr = [NSMutableArray array];
        // 支出
        NSMutableArray *expandseArrTemp = targetMonthRecord.expandseArr.mutableCopy;
        
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-60*60];
        NSString *currentTime = [NSDate getDateString:date format:@"MM月dd日HH时mm分"];
        
        NSMutableArray *arrBean = [NSMutableArray array];
        for (FAccountRecord *bean in expandseArrTemp) {
            if ([bean.time_minute compare:currentTime] != NSOrderedAscending) {// 距现在60分钟以内的都不行
                [arrBean addObject:bean];
            }
        }
        if (arrBean.count>0) {
            [expandseArrTemp removeObjectsInArray:arrBean];
            [expiredDateExpandseArr addObject:arrBean];
        }
        targetMonthRecord.expandseArr = expandseArrTemp;
        
        // 收入
        NSMutableArray *incomeArrTemp = targetMonthRecord.incomeArr.mutableCopy;
        NSMutableArray *arrBean2 = [NSMutableArray array];

        for (FAccountRecord *bean in incomeArrTemp) {
            if ([bean.time_minute compare:currentTime] != NSOrderedAscending) {// 距现在60分钟以内的都不行
                [arrBean2 addObject:bean];
            }
        }
        if (arrBean2.count>0) {
            [incomeArrTemp removeObjectsInArray:arrBean2];
            [expiredDateExpandseArr addObject:arrBean2];
        }
        targetMonthRecord.incomeArr = incomeArrTemp;
    }
    
    return targetMonthRecord;
}


+ (FAccountCategaries *)readLocalUserAccountCategaries{
    
    // 用户是否默认用户
    // 用户是否是有效用户
    // 用户无效
    NSString *fileName = nil;
    if ([AppDelegateInstance.userInfo.phone isEqualToString:defName]) {
        
        fileName = @"AccoutCategeries.plist";
    }else if(AppDelegateInstance.userInfo.phone.length>0){
        
        fileName = [NSString stringWithFormat:@"F%@_AccoutCategeries.plist", AppDelegateInstance.userInfo.phone];
    }else{
        
        fileName = @"AccoutCategeries.plist";
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    FAccountCategaries *bean = [FAccountCategaries mj_objectWithFile:filePathName];
    if (bean) {// 读取用户自定义的数据
        return  bean;
    }else{// 读取APP内部设定的数据
        
        NSString *AccoutCategeriesPath = [[NSBundle mainBundle] pathForResource:@"AccoutCategeries" ofType:@"plist"];
        return  [FAccountCategaries mj_objectWithFile:AccoutCategeriesPath];
    }
}

+ (BOOL)saveAccountCategaries{

    NSString *fileName = nil;
    if ([AppDelegateInstance.userInfo.phone isEqualToString:defName]) {
        
        fileName = @"AccoutCategeries.plist";
    }else if(AppDelegateInstance.userInfo.phone.length>0){
        
        fileName = [NSString stringWithFormat:@"F%@_AccoutCategeries.plist", AppDelegateInstance.userInfo.phone];
    }else{
        
        fileName = @"AccoutCategeries.plist";
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    // 写入plist
    NSDictionary *dic = [AppDelegateInstance.aFAccountCategaries mj_JSONObject];
    NSString *jsonstr = [dic mj_JSONString];
    
    NSDictionary *dicLast = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *jsonstrLast = [dicLast mj_JSONString];
    if ([[jsonstr md5] isEqualToString:[jsonstrLast md5]]) {
        return YES;
    }
    
    if ([dic writeToFile:filePathName atomically:YES]) {
        
        return YES;
        DLOG(@"写入成功");
    }else{
        
        DLOG(@"写入失败");
        return NO;
    }
}



/// 二维码识别记录
+ (BOOL)saveANewQRCodeRecord:(NSDictionary *)qrInfoDic{
    
    if (qrInfoDic[JLBQRCodeStringKey] == nil || qrInfoDic[JLBQRCodeTimeKey] == nil) {
        return NO;
    }
    
    // 存进plist文件
    NSString *fileName = nil;
    if(AppDelegateInstance.userInfo.phone.length > 0){
        
        fileName = [NSString stringWithFormat:@"JLB%@_QRCodeRecords.plist", AppDelegateInstance.userInfo.phone];
    }else{
        
        fileName = @"common.plist";
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    NSMutableArray *arrLast = [NSArray arrayWithContentsOfFile:filePathName].mutableCopy;
//    for (NSDictionary *recordInfo in arrLast) {
//        if ([qrInfoDic[JLBQRCodeStringKey] isEqualToString:recordInfo[JLBQRCodeStringKey]]) {
//
//            [arrLast removeObject:recordInfo];
//
//        }
//    }
    if (!arrLast) {
        arrLast = [NSMutableArray array];
    }
    [arrLast insertObject:qrInfoDic atIndex:0];
    // 写入plist
    if ([arrLast writeToFile:filePathName atomically:YES]) {
        
        return YES;
        DLOG(@"写入成功");
    }else{
        
        DLOG(@"写入失败");
        return NO;
    }
}

+ (NSMutableArray *)QRCodeRecords{
    
    // 存进plist文件
    NSString *fileName = nil;
    if(AppDelegateInstance.userInfo.phone.length > 0){
        
        fileName = [NSString stringWithFormat:@"JLB%@_QRCodeRecords.plist", AppDelegateInstance.userInfo.phone];
    }else{
        
        fileName = @"common.plist";
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    NSMutableArray *arrLast = [NSArray arrayWithContentsOfFile:filePathName].mutableCopy;
    
    return arrLast;
}

+ (NSMutableArray *)QRCodeRecordsFromDefault{
    
    NSMutableArray *arr = self.QRCodeRecords;
    if (arr.count > 0) {
        return arr;
    }
    // 如果是已经保存过了不执行保存
    NSDictionary *record1 = @{JLBQRCodeStringKey : @"https://qq.com", JLBQRCodeTimeKey : @"2018-09-28 13:18:09"};
    NSDictionary *record2 = @{JLBQRCodeStringKey : @"https://blog.csdn.net/cc1991_/article/details/73900093", JLBQRCodeTimeKey : @"2018-09-27 15:18:09"};
    NSDictionary *record3 = @{JLBQRCodeStringKey : @"https://baidu.com", JLBQRCodeTimeKey : @"2018-09-26 19:18:09"};
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [FAccountRecordSaveTool saveANewQRCodeRecord:record3];
        
        [FAccountRecordSaveTool saveANewQRCodeRecord:record2];
        
        [FAccountRecordSaveTool saveANewQRCodeRecord:record1];
    });
    return  @[record1,record2,record3].mutableCopy;
  
}

+ (BOOL)clearQRCodeRecords{
    
    // 存进plist文件
    NSString *fileName = nil;
    if(AppDelegateInstance.userInfo.phone.length > 0){
        
        fileName = [NSString stringWithFormat:@"JLB%@_QRCodeRecords.plist", AppDelegateInstance.userInfo.phone];
    }else{
        
        fileName = @"common.plist";
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    NSMutableArray *arrLast = [NSArray arrayWithContentsOfFile:filePathName].mutableCopy;
    //    for (NSDictionary *recordInfo in arrLast) {
    //        if ([qrInfoDic[JLBQRCodeStringKey] isEqualToString:recordInfo[JLBQRCodeStringKey]]) {
    //
    //            [arrLast removeObject:recordInfo];
    //
    //        }
    //    }
    if (!arrLast) {
        arrLast = [NSMutableArray array];
    }
    [arrLast removeAllObjects];
    // 写入plist
    if ([arrLast writeToFile:filePathName atomically:YES]) {
        
        return YES;
        DLOG(@"写入成功");
    }else{
        
        DLOG(@"写入失败");
        return NO;
    }
}
@end
