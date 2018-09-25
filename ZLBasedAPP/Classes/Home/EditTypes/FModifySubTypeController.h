//
//  FModifySubTypeController.h
//  ftool
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AJNetWorkController.h"
static NSString * const FModifySubTypeControllerDidAddSubTypeNotification = @"FModifySubTypeControllerDidAddSubTypeNotification";

@interface FModifySubTypeController : AJNetWorkController

@property (nonatomic,strong) FSubType *subType;
@end
