//
//  HomeHeader.h
//  微金在线
//
//  Created by 首控微金财富 on 2017/5/17.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^imgSingleTapBlock)(id item);


@interface HomeHeader : UIView

@property (nonatomic,strong) NSArray *imageURLStringsGroup;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, copy) imgSingleTapBlock tapImgBlock;

- (instancetype)initWithFixedHeght;

@end

NS_ASSUME_NONNULL_END

