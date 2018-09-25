//
//  ForgetKeyController.m
//  SP2P_10
//
//  Created by md005 on 15/11/16.
//  Copyright © 2015年 EIMS. All rights reserved.
//  忘记密码（）

#import "ForgetKeyController.h"
//#import "VerifyViewController.h"
#import "Macros.h"
#import "UIButton+KK.h"
#import "NSString+Shove.h"

@interface ForgetKeyController ()<UITextFieldDelegate> //,NavBarDelegate,HTTPClientDelegate>
{
	NSMutableString *phoneNum;
}

@property (nonatomic, strong)UITextField *myTextField;
@property (nonatomic, strong)UIButton *forgetBtn;
@end

@implementation ForgetKeyController

#pragma mark - 控制器视图生命周期
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
    [self initView];
}

#pragma mark - 视图初始化
- (void)initView
{
//    NavBar *navBar = [[NavBar alloc]initWithFrame:NAVBAR_FRAME WithTitle:@"找回密码" WithleftName:@"返回" WithRightName:nil];
//    navBar.delegate = self;
//    [self.view addSubview:navBar];
//    self.view.backgroundColor = BGC;
	
	//2:手机号码label
	UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,80, MSWIDTH,48)];
	phoneLabel.font = [UIFont systemFontOfSize:13];
	phoneLabel.backgroundColor = [UIColor whiteColor];
	phoneLabel.text = @"    手机号码";
	[self.view addSubview:phoneLabel];
	
	//3:手机号码输入框
	_myTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 80, MSWIDTH - 120, 48)];
	_myTextField.placeholder = @"请输入手机号码";
	_myTextField.font = [UIFont systemFontOfSize:13];
	_myTextField.keyboardType = UIKeyboardTypeNumberPad;
	[_myTextField becomeFirstResponder];
	_myTextField.delegate = self;
	[_myTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:_myTextField];
	
	//4:获取手机验证码按钮
    _forgetBtn = [UIButton buttonWithFrame:CGRectMake(20, 160, MSWIDTH - 40, 48) font:14.0 titleColor:[UIColor whiteColor] normalImage:@"button" disableImage:@"regist_btn_normal" target:self action:@selector(getCodeAction) title:@"获取手机验证码" superview:self.view];
    _forgetBtn.enabled = NO;
}

#pragma mark - 获取手机验证码按钮事件触发
- (void)getCodeAction{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:@"111" forKey:@"OPT"];
	[parameters setObject:@"" forKey:@"body"];
	[parameters setObject:_myTextField.text forKey:@"mobile"];
	[parameters setObject:@"forgetPwd" forKey:@"scene"];
//    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark - textField代理方法
//限定textfield输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (_myTextField == textField) {
		if (range.location>= 11){
			return NO;
		}
	}
	return YES;
}

//实时监测uitextfield输入内容
- (void)textFieldDidChange{
	if ([_myTextField.text isPhone]) {
		_forgetBtn.enabled = YES;
	}
	else if (![_myTextField.text isPhone]){
		_forgetBtn.enabled = NO;
	}
}


#pragma mark - 网络数据回调代理
-(void) startRequest{
//    [DejalActivityView activityViewForView:self.view];
}

// 返回成功
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj{
//    NSDictionary *dics = obj;
//    DLOG(@"返回的参数如下:%@",dics);
//    if ([dics isResponseSuccess]){
//        DLOG(@"%@",[obj objectForKey:@"msg"]);
//        VerifyViewController *verifyVc = [[VerifyViewController alloc]init];
//        phoneNum = [_myTextField.text mutableCopy];
//        //            [phoneNum insertString:@" " atIndex:3];
//        //            [phoneNum insertString:@" " atIndex:8];
//        DLOG(@"%@",phoneNum);
//        verifyVc.phoneNum = phoneNum;
//        [self.navigationController pushViewController:verifyVc animated:YES];
//    }
//    else {
//        [SVProgressHUD showImage:nil status:[dics getMsg]];
//    }
//}

#pragma mark - NavBar 代理方法
- (void)backItemClick{
	[_myTextField  resignFirstResponder];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextItemClick{
//    VerifyViewController *verifyVc = [[VerifyViewController alloc] init];
//    [self.navigationController pushViewController:verifyVc animated:YES];
}



@end
