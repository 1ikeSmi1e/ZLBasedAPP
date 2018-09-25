//
//  CalculateMethod.h
//  Calculator
//
//  Created by liaosipei on 15/8/20.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateMethod : NSObject

@property(assign,nonatomic)long double operand1;
@property(assign,nonatomic)long double operand2;
@property(assign,nonatomic)long double result;

-(long double)performOperation:(int)input;
-(void)clear;

@end
