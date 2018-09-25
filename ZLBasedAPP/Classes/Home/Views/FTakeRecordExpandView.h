//
//  FTakeRecordExpandView.h
//  ftool
//
//  Created by admin on 2018/6/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTakeRecordExpandView : UIView

@property (nonatomic,strong) FAccountRecord *aExpandseRecord;// 初始传入的值

@property (nonatomic, weak) id<UIViewOutterDelegate> delegate;
// 信息完成检查
- (BOOL)infoDoneCheck;
- (void)clear;
- (FAccountRecord *)expandReord;// 修改后的值
@end
