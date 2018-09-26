//
//  LoginViewController.m
//  SP2P_10
//
//  登录

#import "FLoginViewController.h"
#import "FRegisterViewController.h"
#import "ForgetKeyController.h"
#import "InputView.h"
//#import "SetGestureLockView.h"
#import "Macros.h"


@interface FLoginViewController ()< UITextFieldDelegate>
{
	UIButton *_loginBtn;			//登录按钮
	UIButton *_forgetBtn;			//忘记密码按钮
	UIButton *_registBtn;			//注册按钮
	BOOL _isLoading;				//是否为登录状态
	NSInteger _typeNum;
	BOOL _mbIsShowKeyboard;			//是否显示键盘
	BOOL _phoneLabelSpread;			//手机号码提示框是否展开
	UILabel *_phoneLabel;			//手机号码错误提示label
	UIView *_superView;
	UILabel *_leftlabel;
	UILabel *_rightlabel;
	UIView *_cover;
//    SetGestureLockView *_setGestureView;
}
@property(nonatomic ,strong) InputView *phoneInput;
@property(nonatomic ,strong) InputView *pwdInput;

@end

@implementation FLoginViewController

#pragma mark - 控制器视图生命周期方法
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	self.navigationController.navigationBarHidden = YES;
	[self ControlAction];
}


- (void)viewDidLoad{
	[super viewDidLoad];

	[self initView];
}


- (void)initView{
	self.navigationController.navigationBar.translucent = NO;
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
		make.size.mas_equalTo(CGSizeMake(90* SCALE,90* SCALE));
	}];
	
	//文本标题
	UILabel *titleLabel = [UILabel new];
	titleLabel.text = @"会理财, 懂生活";
	titleLabel.textColor = baseNavColor;
	titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[_superView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(logoImgView.mas_bottom).with.offset(10 * SCALE);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(130, 30 * SCALE));
	}];
	
	//手机号输入栏
	_phoneInput = [[InputView alloc]initWithImgName:@"regist_phone_normal" WithSelectImgName:@"regist_phone_lighted" placeContent:@"输入手机号"];
	_phoneInput.inputField.delegate = self;
	[_superView addSubview:_phoneInput];
	[_phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).with.offset(55 * SCALE);
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
	_pwdInput.inputField.keyboardType = UIKeyboardTypeDefault;
	[_pwdInput.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[_superView addSubview:_pwdInput];
	[_pwdInput mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneLabel.mas_bottom).with.offset(20 * SCALE);
		make.left.equalTo(_superView.mas_left).with.offset(5);
		make.right.equalTo(_superView.mas_right).with.offset(-5);
		make.height.mas_equalTo(30 * SCALE);
	}];

	//登录按钮
    _loginBtn = [UIButton buttonWithFrame:CGRectZero font:15.0 titleColor:[UIColor whiteColor] normalImage:@"regist_btn_lighted" disableImage:@"regist_btn_normal" target:self action:@selector(loginBtnAction) title:@"登录" superview:_superView];
	_loginBtn.enabled = NO;
	[_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_pwdInput.mas_bottom).with.offset(20 * SCALE);
		make.left.equalTo(_superView.mas_left).with.offset(18);
		make.right.equalTo(_superView.mas_right).with.offset(-18);
		make.height.mas_equalTo(45 * WSCALE);
	}];
	
	
	//注册按钮
    _registBtn = [UIButton buttonWithFrame:CGRectZero font:15.0 titleColor:baseNavColor normalImage:nil disableImage:nil target:self action:@selector(registBtnClick) title:@"马上注册" superview:_superView];
	[_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-30);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(MSWIDTH -60, 25));
	}];
	
	
	//注册按钮左边线条
	_leftlabel = [UILabel new];
	_leftlabel.backgroundColor = baseGrayColor;
	[_superView addSubview:_leftlabel];
	[_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-40);
		make.left.equalTo(_superView.mas_left).with.offset(40);
		make.width.mas_equalTo(MSWIDTH/2 - 80);
		make.height.mas_equalTo(0.5);
	}];
	
	//注册按钮右边线条
	_rightlabel = [UILabel new];
	_rightlabel.backgroundColor = baseGrayColor;
	[_superView addSubview:_rightlabel];
	[_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-40);
		make.right.equalTo(_superView.mas_right).with.offset(-40);
		make.width.mas_equalTo(MSWIDTH/2 - 80);
		make.height.mas_equalTo(0.5);
	}];
	
	//忘记密码按钮
    _forgetBtn = [UIButton buttonWithFrame:CGRectZero font:14.0 titleColor:baseNavColor normalImage:nil disableImage:nil target:self action:@selector(forgetBtnAction) title:@"忘记密码" superview:_superView];
	_forgetBtn.hidden = YES;
	[_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_loginBtn.mas_bottom).with.offset(15 * SCALE);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(0, 0));
	}];
    
    if (IS_VISITOR)
    {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"fclose"] forState:UIControlStateNormal];
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


#pragma mark - 按钮事件触发
/*关闭按钮触发*/
- (void)closeBtnClick
{
    [self ControlAction];
    
//    if (self.backType == ChangeRootView || self.backType == LoginTimeOut)
//    {
//        //直接跳转首页
//        TabBarController *tabbarVC = [TabBarController shareInstance];
//        AppDelegateInstance.window.rootViewController = tabbarVC;
//    }
//    else
    {
        if (self.tabBarController.selectedIndex == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETABBAR object:@"0"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*注册按钮触发*/
-(void)registBtnClick{
	[self resumeView];
	[self ControlAction];
	FRegisterViewController *registView = [[FRegisterViewController alloc] init];
	[self.navigationController pushViewController:registView animated:YES];
}

/*忘记密码按钮触发*/
-(void)forgetBtnAction{
	[self ControlAction];
	ForgetKeyController *forVC = [[ForgetKeyController alloc] init];
	UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:forVC];
	[self presentViewController:navVc animated:YES completion:nil];
}

/*登录按钮触发*/
-(void)loginBtnAction{
	[self ControlAction];
    
    NSString *password1 = [NSString encrypt3DES:_pwdInput.inputField.text key:DESkey];
    if ([FUsersTool loginUser:_phoneInput.inputField.text andPassword:password1]) {
        [SVProgressHUD showImage:kSuccessImage status:@"成功登录"];
        [self loginSuccess];
    }else {
        [SVProgressHUD showImage:nil status:@"用户名或密码错误"];
    }
    
	_typeNum = 1;
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

	[parameters setObject:@"123" forKey:@"OPT"];
	[parameters setObject:@"" forKey:@"body"];
	[parameters setObject:_phoneInput.inputField.text forKey:@"mobile"];
//    [parameters setObject:password1 forKey:@"password"];
	[parameters setObject:@"3" forKey:@"deviceType"];
//    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark - 网络数据回调代理
// 开始请求
-(void) startRequest{
	[DejalActivityView activityViewForView:self.view];
	_isLoading = YES;
}

// 返回成功
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj{
//    NSDictionary *dics = obj;
//    DLOG(@"返回的参数如下:%@",dics);
//    if ([dics isResponseSuccess]) {
//        if(_typeNum == 1){
//            DLOG(@"返回成功:登录信息-> %@",[obj objectForKey:@"msg"]);
//
//            NSString *userId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"userId"]];
//            DLOG(@"userSignId --> %@",userId);
//            //保存用户注册成功后得到的用户ID
//            [[AppDefaultUtil sharedInstance] setDefaultUserID:userId];
//
//            [self loginSuccess];// 登录成功
//        }
//    }
//    else if ([dics isCodeEqual:-1]){
//        [SVProgressHUD showErrorWithStatus:[dics getMsg]];
//    }
//    else{
//        [SVProgressHUD showImage:nil status:[dics getMsg]];
//    }
//}
//
//
//// 返回失败
//-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
//{
//    _isLoading  = NO;
//}


// 无可用的网络
-(void) networkError
{
	_isLoading  = NO;
}


#pragma mark - 点击空白处收回键盘
- (void)ControlAction{
	[self.view endEditing:YES];
}


#pragma mark - textfield代理方法
//开始进入编辑状态
- (void) textFieldDidBeginEditing:(UITextField *)textField{
	
	if (_phoneInput.inputField == textField ) {
		_phoneInput.leftImg.highlighted = YES;
		[self hidePhoneLabel];
		[self moveView];
	}
	
	else if (_pwdInput.inputField == textField){
		_pwdInput.leftImg.highlighted = YES;
		[self moveView];
	}
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (_phoneInput.inputField == textField ) {
		_phoneInput.leftImg.highlighted = NO;
		
		if (_phoneInput.inputField.text.length) {
			if (![_phoneInput.inputField.text isPhone]) {
				[self showPhoneLabel];
			}
		}
		[self resumeView];
	}
	else if (_pwdInput.inputField == textField){
		_pwdInput.leftImg.highlighted = NO;
		[self  resumeView];
	}
}

/*限制输入框输入长度
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
	   //修复问题：复制的手机号码长度大于11位，无法进行删除操作，只能清空
    if (_phoneInput.inputField == textField) {
		if (range.location>= 11 && ![string isEqualToString:@""]){
			return NO;
		}
	}
    else if (_pwdInput.inputField == textField){
        if (range.location>= 15 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
	return YES;
}

// 监听密码输入框的输入（正在编辑中）
-(void)textFieldDidChange:(id)sender{
	UITextField *textField = (UITextField *)sender;
	_loginBtn.enabled = NO;
	if (textField.text.length > 5 && [_phoneInput.inputField.text isPhone]) {
		_loginBtn.enabled = YES;
	}
}

#pragma mark - 动态视图方法
// 视图上移
-(void) moveView{
	
	if ( !_mbIsShowKeyboard ){
		
		NSTimeInterval animationDuration=0.30f;
		[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
		[UIView setAnimationDuration:animationDuration];

        CGRect superRect = _superView.frame;
        superRect.origin.y = _superView.frame.origin.y - 153 * SCALE;
		_superView.frame = superRect;
        
		[UIView commitAnimations];
		
		//[self performSelector:@selector(showforgetBtn) withObject:nil afterDelay:1.0f];
		[self showforgetBtn];
		_leftlabel.hidden = YES;
		_rightlabel.hidden = YES;
		_mbIsShowKeyboard = true;
	}
}


// 视图恢复
-(void)resumeView{
	if ( _mbIsShowKeyboard ){
		NSTimeInterval animationDuration=0.30f;
		[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
		[UIView setAnimationDuration:animationDuration];
		
		//如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
        CGRect superRect = _superView.frame;
        superRect.origin.y = _superView.frame.origin.y + 153 * SCALE;
        _superView.frame = superRect;
        
		[self showRegistBtn];
		[UIView commitAnimations];
		_leftlabel.hidden = NO;
		_rightlabel.hidden = NO;
		_mbIsShowKeyboard = false;
	}
}

//   展示号码错误提示label
- (void)showPhoneLabel{
	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ShowPhoneLabel" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _phoneLabel.hidden = NO;
    [_phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_phoneInput.mas_bottom).with.offset(0.5);
		make.left.equalTo(_superView.mas_left).with.offset(40);
		make.right.equalTo(_superView.mas_right).with.offset(-10);
		make.height.mas_equalTo(30);
	}];
	[UIView commitAnimations];
}

//  隐藏号码错误提示label
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

//显示忘记密码按钮
- (void)showforgetBtn{
//    _forgetBtn.hidden = NO;
	_registBtn.hidden = YES;
	_leftlabel.hidden = YES;
	_rightlabel.hidden = YES;
	[_forgetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_loginBtn.mas_bottom).with.offset(15);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(120, 25));
	}];
	
	[_registBtn mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-30);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(0, 0));
	}];
}

//显示注册按钮
- (void)showRegistBtn{
	_forgetBtn.hidden = YES;
	_registBtn.hidden = NO;
	_leftlabel.hidden = NO;
	_rightlabel.hidden = NO;
	[_registBtn mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(_superView.mas_bottom).with.offset(-30);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(120, 25));
	}];
	
	[_forgetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_loginBtn.mas_bottom).with.offset(15);
		make.centerX.mas_equalTo(_superView.mas_centerX);
		make.size.mas_equalTo(CGSizeMake(0, 0));
	}];
}


#pragma mark - 登录成功保存登录状态
-(void) loginSuccess{
	
	// 登录成功，记住密码,记录登录状态. 保存账号密码到UserDefault
	[[AppDefaultUtil sharedInstance] setPhoneNum:_phoneInput.inputField.text];//保存手机号
	NSString *pwdStr = [NSString encrypt3DES:_pwdInput.inputField.text key:DESkey];//用户密码3Des加密
	[[AppDefaultUtil sharedInstance] setPassword:pwdStr];// 保存用户密码（des加密）
    [[AppDefaultUtil sharedInstance] setLoginState:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETABBAR object:@"2"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ZLUserModel *user = [[ZLUserModel alloc] init];
    user.phone = _phoneInput.inputField.text;
    user.pwdStr = pwdStr;
    AppDelegateInstance.userInfo = user;
//    _setGestureView = [[SetGestureLockView alloc]initWithFrame:[[UIScreen mainScreen] bounds] delegate:self];
//    [_setGestureView show];
}


#pragma mark - SetGestureLockViewDelegate
- (void)setGestureLockSuccess
{
    [self ControlAction];
    
//    if (self.backType == ChangeRootView)
//    {
//        //直接跳转首页
//        TabBarController *tabbarVC = [TabBarController shareInstance];
//        AppDelegateInstance.window.rootViewController = tabbarVC;
//        [_setGestureView removeFromSuperview];
//
//    }else{
//        if (self.backType == MyWealth)
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETABBAR object:@"2"];
//        }
//
//        [self dismissViewControllerAnimated:NO completion:^{
//             [_setGestureView removeFromSuperview];
//        }];
//    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	return NO;
}


-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	}
	[self.navigationItem setHidesBackButton:YES];
}



@end
