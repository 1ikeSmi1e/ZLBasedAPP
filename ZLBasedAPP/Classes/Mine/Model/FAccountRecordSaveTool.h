//
//  FAccountRecordSaveTool.h
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAccountRecord.h"
#import "FAccountCategaries.h"

@interface FAccountRecordSaveTool : NSObject

+ (BOOL)saveCurrentMonthBlanceRecords;

+ (FCurrentMonthRecord *)readLoaclCurrentMonthBlanceRecords;


+ (BOOL)saveAccountCategaries;
+ (FAccountCategaries *)readLocalUserAccountCategaries;
@end
