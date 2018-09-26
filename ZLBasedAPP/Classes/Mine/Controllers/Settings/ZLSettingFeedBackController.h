//
//  ZLSettingFeedBackController.h
//  ZLBasedAPP
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "AJNetWorkController.h"

@interface ZLSettingFeedBackController : AJNetWorkController

@property (nonatomic, strong) NSMutableArray *smallImageArray;
@property (nonatomic, strong) NSMutableArray *bigImageArray;
- (void)changeSelectSmallImage:(NSArray *)smallImageArray bigImageArray:(NSArray *)bigImageArray;

@end
