//
//  InputView.h
//  SP2P_10
//
//  Created by md005 on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView

@property (nonatomic,strong) UITextField *inputField;
@property (nonatomic,strong) UIImageView *leftImg;

- (id)initWithImgName:(NSString *)imgName WithSelectImgName:(NSString *)selectImgName placeContent:(NSString *)content;

@end
