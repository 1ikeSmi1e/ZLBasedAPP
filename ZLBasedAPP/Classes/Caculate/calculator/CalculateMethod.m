//
//  CalculateMethod.m
//  Calculator
//
//  Created by liaosipei on 15/8/20.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "CalculateMethod.h"

@implementation CalculateMethod

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        _operand1=0;
        _operand2=0;
        _result=0;
    }
    return self;
}

-(long double)performOperation:(int)input;
{
    switch (input) {
        case 13:    //按下“÷”
            if(_operand2!=0)
                _result=_operand1/_operand2; 
            break;
        case 14:    //按下“×”
            _result=_operand1*_operand2;
            break;
        case 15:    //按下“-”
            _result=_operand1-_operand2;
            break;
        case 16:    //按下“+”
            _result=_operand1+_operand2;
            break;
        default:
            break;
    }
    
    // 处理没有输入运算符的时候, 返回值
    if (input == 0 && _operand1 == 0 && _result == 0) {
        return _operand2;
    }
    
    return _result;
}


-(void)clear
{
    _operand1=0;
    _operand2=0;
    _result=0;
}


@end
