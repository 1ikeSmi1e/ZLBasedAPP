//
//  NoDataView.h
//  微金在线
//
//  Created by 首控微金财富 on 2017/5/25.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoDataView;
@protocol NoDataViewDelegate <NSObject>

@optional
- (CGRect)noDataViewFrame:(NoDataView *)view;
- (void)noDataViewDidClickView:(NoDataView *)view;

@end

@interface NoDataView : UIView

/*! @abstract 代理必须是控制器
 */
@property (nonatomic, weak) id<NoDataViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<NoDataViewDelegate>)delegate;
@end
