//
//  UIButton+CountDown.m
//  SP2P_10
//
//  Created by EIMS-IOS on 16/11/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)


- (void)countDown
{
    [self startTime:60 title:@"获取验证码" waitTitle:@"秒后重新发送"];
}

- (void)startTime:(NSInteger)timeout title:(NSString *)title waitTitle:(NSString *)waitTitle
{
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                self.alpha = 1;
            });
        }else{
            long seconds = timeOut % (timeout+1);
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
              //  NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                self.alpha = 0.4;
            });
            timeOut--;  
        }
    });
    dispatch_resume(_timer);
}

@end
