//
//  UIButton+CountDown.h
//  SP2P_10
//
//  Created by EIMS-IOS on 16/11/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

- (void)countDown;

- (void)startTime:(NSInteger)timeout title:(NSString *)title waitTitle:(NSString *)waitTitle;


@end
