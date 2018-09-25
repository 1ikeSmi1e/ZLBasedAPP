//
//  WSPlaceholderTextView.h
//  微金在线
//
//  Created by dawe on 2018/1/24.
//  Copyright © 2018年 zhouli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end

