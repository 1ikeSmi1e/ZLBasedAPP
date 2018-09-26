//
//  RegisterViewController.m
//  SP2P_10
//
//  Created by Jerry on 15/10/12.
//  Copyright © 2015年 EIMS. All rights reserved.
//  注册

#import "FRegisterViewController.h"
#import "FLoginViewController.h"
//#import "CapitalEntrustController.h"
//#import "MyWebViewController.h"
//#import "ReLogin.h"
#import "InputView.h"
#import "UIButton+CountDown.h"
//#import "CertificationViewController.h"
//#import "RegisterSucceedController.h"
#import "CaptchaView.h"
#import "DejalActivityView.h"
#import "NSString+encryptDES.h"
#import "UIButton+KK.h"

@interface FRegisterViewController ()<UITextFieldDelegate> //HTTPClientDelegate, 
{
	BOOL _mbIsShowKeyboard;			//是否展示键盘
//    UIButton *_verifyBtn;            //验证码按钮
	UILabel  *_phoneLabel;			//手机号码提示label
	UIView   *_superView;			//主视图
	UIButton *_registBtn;			//注册按钮
	UIButton *_proctolBtn;			//会员注册协议按钮
	UIButton *_loginBtn;			//快速登录按钮
	UILabel  *_leftlabel;
	UILabel  *_rightlabel;
	NSString *_html;
    
    CaptchaView *_imageVerifyView;
}

@property(nonatomic,strong) InputView *phoneInput;
@property(nonatomic,strong) InputView *pwdInput;
//@property(nonatomic,strong) InputView *verifyInput;
@property(nonatomic,strong) InputView *inviteInput;
@end

@implementation FRegisterViewController

#pragma mark - 控制器视图生命周期方法
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	self.navigationController.navigationBarHidden = YES;
	[self ControlAction];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initView];
}

#pragma mark - 视图初始化
- (void)initView{
//    self.navigationController.fd_prefersNavigationBarHidden = YES;
	self.view.backgroundColor = BGC;

    _superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _superView.backgroundColor = BGC;
    [self.view addSubview:_superView];
	
	//logo视图
	UIImageView *logoImgView = [UIImageView new];
	logoImgView.image = [UIImage imageNamed:@"flogo"];
    logoImgView.layer.cornerRadius = 45*SCALE;
    logoImgView.layer.masksToBounds = YES;
	[_superView addSubview:logoImgView];
	[logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(_superView.mas_top).with.offset(30 * SCALE);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(90 * SCALE, 90 * SCALE));
	}];
	
	//文本标题
	UILabel *titleLabel = [UILabel new];
	titleLabel.text = @"会理财, 懂生活";
	titleLabel.textColor = baseNavColor;
	titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[_superView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(logoImgView.mas_bottom).with.offset(10 * SCALE);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(130, 30 * SCALE));
	}];
	
	// 手机号输入栏
	_phoneInput = [[InputView alloc]initWithImgName:@"regist_phone_normal" WithSelectImgName:@"regist_phone_lighted" placeContent:@"请输入手机号"];
	_phoneInput.inputField.delegate = self;
	[_phoneInput.inputField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
	[_superView addSubview:_phoneInput];
	[_phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).with.offset(25 * SCALE);
		make.left.equalTo(_superView.mas_left).with.offset(5);
		make.right.equalTo(_superView.mas_right).with.offset(-5);
		make.height.mas_equalTo(30 * SCALE);
	}];
	
	//号码错误提示label
	_phoneLabel = [UILabel new];
    _phoneLabel.text = @"请输入正确的手机号码";
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.font = [UIFont systemFontOfSize:13.0f];
    _phoneLabel.textColor = baseNavColor;
    _phoneLabel.hidden = YES;
	[_superView addSubview:_phoneLabel];
	[_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneInput.mas_bottom).with.offset(0.5);
		make.left.equalTo(_superView.mas_left).with.offset(10);
		make.right.equalTo(_superView.mas_right).with.offset(-10);
		make.height.mas_equalTo(1);
	}];
	
	//密码输入栏
	_pwdInput = [[InputView alloc]initWithImgName:@"regist_pwd_normal" WithSelectImgName:@"regist_pwd_lighted" placeContent:@"输入登录密码"];
	_pwdInput.inputField.delegate = self;
	_pwdInput.inputField.secureTextEntry = YES;
	_pwdInput.inputField.clearButtonMode = UITextFieldViewModeNever;
	_pwdInput.inputField.keyboardType = UIKeyboardTypeDefault;
	[_pwdInput.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[_superView addSubview:_pwdInput];
	[_pwdInput mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneLabel.mas_bottom).with.offset(20 * SCALE);
		make.left.equalTo(_superView.mas_left).with.offset(5);
		make.right.equalTo(_superView.mas_right).with.offset(-5);
		make.height.mas_equalTo(30 * SCALE);
	}];
	
	//眼睛按钮
	UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[eyeBtn setBackgroundImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
	[eyeBtn setBackgroundImage:[UIImage imageNamed:@"02"] forState:UIControlStateSelected];
	eyeBtn.selected = NO;
	[eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
	[_superView addSubview:eyeBtn];
	[eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneLabel.mas_bottom).with.offset(28 * SCALE);
		make.right.equalTo(_superView.mas_right).with.offset(-15);
		make.size.mas_equalTo(CGSizeMake(20 * SCALE, 13 * SCALE));
	}];
	
	//验证码输入栏
//    _verifyInput = [[InputView alloc]initWithImgName:@"regist_invite_normal" WithSelectImgName:@"regist_invite_lighted" placeContent:@"手机验证码"];
//    _verifyInput.inputField.delegate = self;
//    _verifyInput.inputField.clearButtonMode = UITextFieldViewModeNever;
//    [_verifyInput.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    [_superView addSubview:_verifyInput];
//    [_verifyInput mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_pwdInput.mas_bottom).with.offset(20 * SCALE);
//        make.left.equalTo(_superView.mas_left).with.offset(5);
//        make.right.equalTo(_superView.mas_right).with.offset(-5);
//        make.height.mas_equalTo(30 * SCALE);
//    }];
	
//    //获取验证码按钮
//    _verifyBtn = [UIButton buttonWithFrame:CGRectZero font:12.0f titleColor:[UIColor whiteColor] normalImage:@"button" disableImage:@"regist_btn_normal" target:self action:@selector(VerifyBtnClick) title:@"获取验证码" superview:_superView];
//    _verifyBtn.enabled = NO;
//
//    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_pwdInput.mas_bottom).with.offset(10 * SCALE);
//        make.right.equalTo(_superView.mas_right).with.offset(-15);
//        make.size.mas_equalTo(CGSizeMake(100, 30 * SCALE));
//    }];
    

    _imageVerifyView = [[CaptchaView alloc] init];
    [_superView addSubview:_imageVerifyView];
    
    //图形验证码
    [_imageVerifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdInput.mas_bottom).with.offset(10*HSCALE);
        make.right.equalTo(_superView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(100, 40 * SCALE));
    }];
	
	//邀请码输入栏
	_inviteInput = [[InputView alloc]initWithImgName:@"regist_invite_normal" WithSelectImgName:@"regist_invite_lighted" placeContent:@"请输入右边答案"]; //邀请码可选项
	_inviteInput.inputField.delegate = self;
	[_superView addSubview:_inviteInput];
	[_inviteInput mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_pwdInput.mas_bottom).with.offset(20 * SCALE); //_verifyInput.mas_bottom
		make.left.equalTo(_superView.mas_left).with.offset(5);
		make.right.equalTo(_superView.mas_right).with.offset(-110);
		make.height.mas_equalTo(30 * SCALE);
	}];
	
	//注册按钮
    _registBtn = [UIButton buttonWithFrame:CGRectZero font:15.0 titleColor:[UIColor whiteColor] normalImage:@"regist_btn_lighted" disableImage:@"regist_btn_normal" target:self action:@selector(registerAction) title:@"注 册" superview:_superView];
    _registBtn.enabled = NO;
	[_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_inviteInput.mas_bottom).with.offset(25 * SCALE);
		make.left.equalTo(_superView.mas_left).with.offset(18);
		make.right.equalTo(_superView.mas_right).with.offset(-18);
		make.height.mas_equalTo(45 * WSCALE);
	}];
	
	//登录按钮
    _loginBtn = [UIButton buttonWithFrame:CGRectZero font:15.0 titleColor:baseNavColor normalImage:nil disableImage:nil target:self action:@selector(loginBtnClick) title:@"快速登录" superview:_superView];
	[_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-30);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(MSWIDTH -60, 25 * SCALE));
	}];
	
	//左侧线条
	_leftlabel = [UILabel new];
	_leftlabel.backgroundColor = baseGrayColor;
	[_superView addSubview:_leftlabel];
	[_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(- 40);
		make.left.equalTo(_superView.mas_left).with.offset(40);
		make.width.mas_equalTo(MSWIDTH/2 - 80);
		make.height.mas_equalTo(0.5);
	}];
	
	//右侧线条
	_rightlabel = [UILabel new];
	_rightlabel.backgroundColor = baseGrayColor;
	[_superView addSubview:_rightlabel];
	[_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(- 40);
		make.right.equalTo(_superView.mas_right).with.offset(-40);
		make.width.mas_equalTo(MSWIDTH/2 - 80);
		make.height.mas_equalTo(0.5);
    }];
    
    //协议按钮 平台注册协议
    _proctolBtn = [UIButton buttonWithFrame:CGRectZero font:14.0 titleColor:baseNavColor normalImage:nil disableImage:nil target:self action:@selector(proctolBtnAction) title:@"" superview:_superView];
    [_proctolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registBtn.mas_bottom).with.offset(15 * SCALE);
        make.centerX.mas_equalTo(_superView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 25));
    }];
    
    if (self.isFromMall) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_superView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_superView.mas_top).with.offset(20);
            make.right.equalTo(_superView.mas_right).with.offset(-10);
            make.width.mas_equalTo(40 * SCALE);
            make.height.mas_equalTo(40 * SCALE);
        }];
    }
}


#pragma mark - 点击空白处收回键盘
- (void)ControlAction{
	[self.view endEditing:YES];
	[self hidePhoneLabel];
}


#pragma mark - 按钮事件触发
/*关闭按钮触发*/
- (void)closeBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* 登录按钮事件触发 */
-(void)loginBtnClick{
    
    if (self.isFromMall) {
        [ReLogin goLogin:self];
        
    }else{
       	[self closeBtnClick];
    }
}

/* 获取验证码按钮事件触发 */
- (void)VerifyBtnClick{
	if ([_phoneInput.inputField.text isPhone]) {
		DLOG(@"PhoneNum is right");

		[self getVerification];
	}
	else {
		[SVProgressHUD showImage:nil status:@"手机号码格式不正确"];
	}
}

/* 注册按钮事件触发 */
- (void)registerAction{
	[self ControlAction];
    NSString *reslut = _inviteInput.inputField.text;
    if (![_imageVerifyView verifyContent:reslut]) {
        [SVProgressHUD showImage:nil status:@"图形验证码不正确"];
        return;
    }
    
	[[AppDefaultUtil sharedInstance] setPhoneNum:_phoneInput.inputField.text];// 保存用户账号(手机号)
    NSString *pwdStr = [NSString encrypt3DES:_pwdInput.inputField.text key:DESkey];//用户密码3Des加密
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:_phoneInput.inputField.text forKey:@"mobile"];
//    [parameters setObject:pwdStr forKey:@"password"];
//    [parameters setObject:_verifyInput.inputField.text forKey:@"verificationCode"];
	[parameters setObject:_inviteInput.inputField.text forKey:@"invitationCode"];
	[parameters setObject:@"3" forKey:@"deviceType"];
//    [self.requestClient requestGet:@"app/services" withParameters:parameters];
    if([FUsersTool isExsits:_phoneInput.inputField.text]){
        [SVProgressHUD showImage:nil status:@"用户已存在"];
    }
    else if ([FUsersTool registUser:_phoneInput.inputField.text andPassword:pwdStr]) {
        [SVProgressHUD showImage:kSuccessImage status:@"注册成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/* 平台注册协议按钮事件触发 */
- (void)proctolBtnAction{

	[self ControlAction];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithOPT:112];
//    [self requestwithParameters:parameters];
}


#pragma mark - 网络数据请求
/* 获取验证码网络请求 */
-(void) getVerification{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithOPT:111];
//    [parameters setObject:_phoneInput.inputField.text forKey:@"mobile"];
//    [parameters setObject:@"register" forKey:@"scene"];
//    [self requestParameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        // 是否成功发送验证码
//        NSDictionary *dics = responseObject;
//        if ([dics isResponseSuccess])
//        {
//            [SVProgressHUD showSuccessWithStatus:[dics getMsg]];
//            //成功后倒计时
//            [_verifyBtn countDown];
//
//        }else{
//            [SVProgressHUD showErrorWithStatus:[dics getMsg]];
//        }
//    }];
}


#pragma mark - 网络数据回调代理方法
//开始请求
-(void) startRequest{
	[DejalActivityView activityViewForView:self.view];
}

// 返回成功
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj withParameters:(NSDictionary *)requestParam{
//    NSDictionary *dics = obj;
//    DLOG(@"返回的参数如下:%@",dics);
//    if ([dics isResponseSuccess]) {
//        if ([requestParam isOptEqual:113]) {
//
//        }
//        else if ([requestParam isOptEqual:112]){
//            _html = [NSString stringWithFormat:@"%@", [obj objectForKey:@"html"]];
//            DLOG(@"html --> %@",_html);
//            MyWebViewController *myWebVc = [[MyWebViewController alloc] init];
//            myWebVc.html = _html;
//            myWebVc.title = @"平台注册协议";
//            [self.navigationController pushViewController:myWebVc animated:YES];
//
//        }
//        else{
//            // 登录成功
//            DLOG(@"msg -> %@",[obj objectForKey:@"msg"]);
//            DLOG(@"error -> %@",[obj objectForKey:@"error"]);
//            //            [self loginSuccess];
//        }
//    }else {
//        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
//        [SVProgressHUD showImage:nil status:[dics getMsg]];
//    }
//}

#pragma mark - textfield代理方法
/* 动态视图方法 */
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
	if (_phoneInput.inputField == textField ) {
		_phoneInput.leftImg.highlighted = YES;
		[self  hidePhoneLabel];
		[self  moveView];
	}
	else if (_pwdInput.inputField == textField){
		_pwdInput.leftImg.highlighted = YES;
		[self  moveView];
	}
//    else if (_verifyInput.inputField == textField){
//        _verifyInput.leftImg.highlighted = YES;
//        [self  moveView];
//    }
	else if (_inviteInput.inputField == textField){
		_inviteInput.leftImg.highlighted = YES;
		[self  moveView];
	}
}

/* 动态视图方法 */
- ( void )textFieldDidEndEditing:( UITextField *)textField{
	if (_phoneInput.inputField == textField ) {
		_phoneInput.leftImg.highlighted = NO;
		if (_phoneInput.inputField.text.length) {
			if (![_phoneInput.inputField.text isPhone]) {
                [self showPhoneLabel:nil];
            }else if([FUsersTool isExsits:_phoneInput.inputField.text]){
                [self showPhoneLabel:@"用户已存在"];
            }
		}
		[self  resumeView];
	}
	else if (_pwdInput.inputField == textField){
		_pwdInput.leftImg.highlighted = NO;
		[self resumeView];
	}
//    else if (_verifyInput.inputField == textField){
//        _verifyInput.leftImg.highlighted = NO;
//        [self resumeView];
//    }
	else if (_inviteInput.inputField == textField){
		_inviteInput.leftImg.highlighted = NO;
		[self resumeView];
	}
}


/* 限制各个输入框的输入长度 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (_phoneInput.inputField == textField) {
		if (range.location>= 11){
			return NO;
		}
	}
	else if (_pwdInput.inputField == textField){
		if (range.location>= 15) {
			return NO;
		}
	}
//    else if (_verifyInput.inputField == textField){
//        if (range.location >= 6) {
//            return NO;
//        }
//    }
	return YES;
}

// 实时监测textfield里面内容变化
-(void)textFieldDidChange:(id)sender{
	UITextField *textField = (UITextField *)sender;
	if (_phoneInput.inputField == textField) {
//        _verifyBtn.enabled = NO;
		if ([_phoneInput.inputField.text isPhone]) {
//            _verifyBtn.enabled = YES;
		}
	}
    //_verifyInput.inputField.text.length == 6 &&
    if ([_phoneInput.inputField.text isPhone] && _pwdInput.inputField.text.length > 5) {
        _registBtn.enabled = YES;
    }
}


#pragma mark - 视图动态移动方法
//  视图上移
-(void) moveView{
	if ( !_mbIsShowKeyboard ){
		NSTimeInterval animationDuration=0.30f;
		[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
		[UIView setAnimationDuration:animationDuration];
	
        CGRect superRect = _superView.frame;
        superRect.origin.y = _superView.frame.origin.y - 153 * SCALE;
        _superView.frame = superRect;
        
		[UIView commitAnimations];
		_leftlabel.hidden = YES;
		_rightlabel.hidden = YES;
		_mbIsShowKeyboard = true;
	}
}

//  视图恢复
-(void)resumeView{
	if ( _mbIsShowKeyboard )
	{
		NSTimeInterval animationDuration=0.30f;
		[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
		[UIView setAnimationDuration:animationDuration];
		
		//如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
        CGRect superRect = _superView.frame;
        superRect.origin.y = _superView.frame.origin.y + 153 * SCALE;
        _superView.frame = superRect;
		[UIView commitAnimations];
		_leftlabel.hidden = NO;
		_rightlabel.hidden = NO;
		_mbIsShowKeyboard = false;
	}
}


// 展示号码错误提示label
- (void)showPhoneLabel:(NSString *)errmsg{
	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ShowPhoneLabel" context:nil];
	[UIView setAnimationDuration:animationDuration];
    _phoneLabel.hidden = NO;
    _phoneLabel.text = errmsg? errmsg: @"请输入正确的手机号码";
	[_phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneInput.mas_bottom).with.offset(0.5);
		make.left.equalTo(_superView.mas_left).with.offset(40);
		make.right.equalTo(_superView.mas_right).with.offset(-10);
		make.height.mas_equalTo(30);
	}];
	[UIView commitAnimations];
}

/* 隐藏手机提示label */
- (void)hidePhoneLabel{
	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ShowPhoneLabel" context:nil];
	[UIView setAnimationDuration:animationDuration];
	_phoneLabel.hidden = YES;
	[_phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneInput.mas_bottom).with.offset(0.5);
		make.left.equalTo(_superView.mas_left).with.offset(10);
		make.right.equalTo(_superView.mas_right).with.offset(-10);
		make.height.mas_equalTo(1);
	}];
	[UIView commitAnimations];
}

// 眼睛按钮事件触发
- (void)eyeAction:(UIButton *)sender{
	[_pwdInput.inputField becomeFirstResponder];
	sender.selected = !sender.selected;
	if (sender.selected) {
		_pwdInput.inputField.secureTextEntry = NO;
	}
	else if (!sender.selected){
		_pwdInput.inputField.secureTextEntry = YES;
	}
}


-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = NO;
}


@end
