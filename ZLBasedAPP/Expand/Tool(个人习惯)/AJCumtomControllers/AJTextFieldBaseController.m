//
//  AJTextFieldBaseController.m
//  SP2P_6.1
//
//  Created by eims on 16/8/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJTextFieldBaseController.h"

@implementation AJTextFieldBaseController
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}
@end
