//
//  ZLSettingPrivacyController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLSettingPrivacyController.h"

@interface ZLSettingPrivacyController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *selectTypeImgV;
@property (weak, nonatomic) IBOutlet UILabel *selectTypeL;
@property (weak, nonatomic) IBOutlet UIView *modifyPwdView;
@property (weak, nonatomic) IBOutlet UITextField *modifyPwdField;
@property (weak, nonatomic) IBOutlet UIButton *modifyPwdSureBtn;
@property (weak, nonatomic) IBOutlet UILabel *biologyLoginLable;
@property (weak, nonatomic) IBOutlet UIImageView *biologyImgV;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImgV;

@end

@implementation ZLSettingPrivacyController
//   MIne_privacy_selectedIcon
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}
- (IBAction)sureClick:(id)sender {
    
    if (self.modifyPwdField.text.length < 6) {
        
        ShowLightMessage(@"您输入的密码长度小于6位!");
        
    }else if (self.modifyPwdField.text.length >16){
        
        ShowLightMessage(@"您输入的密码长度大于于16位!");
    }else{
        NSString *password1 = [NSString encrypt3DES:self.modifyPwdField.text key:DESkey];
        [FUsersTool modifyPwdWithUser:AppDelegateInstance.userInfo.phone password:password1];
    }
}

- (void)initView {
   
    self.view.backgroundColor = AJGrayBackgroundColor;
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"隐私设置" leftName:nil rightName:nil delegate:self];
    self.scrollViewTop.constant = bar.maxY;
    
    if (MSHIGHT >= 812) {
        self.biologyLoginLable.text = @"人脸识别登录";
    }else{
        self.biologyLoginLable.text = @"指纹登录";
    }
    // 初始化验证方式
    NSString *loginVerifyWay = [AppDefaultUtil loginVerifyWay];
    if ([loginVerifyWay isEqualToString:LoginWayPWD]) {
        
        
        [self pwdLonginSelectClick:nil];
    }else if ([loginVerifyWay isEqualToString:LoginWayFinger]) {
        
        
        [self biologyLoinSelectClick:nil];
    }else if ([loginVerifyWay isEqualToString:LoginWayhumanFace]) {
        [self biologyLoinSelectClick:nil];
    }
    
}

- (IBAction)biologyLoinSelectClick:(id)sender {
    
    self.biologyImgV.hidden = NO;
    self.pwdImgV.hidden = YES;
    
    if (MSHIGHT >= 812) {
        self.selectTypeL.text = @"人脸识别验证方式登录";
        self.selectTypeImgV.image = [UIImage imageNamed:@"Mine_Privacy_humanFace"];
        [AppDefaultUtil setLoginVerifyWay:LoginWayhumanFace];
        
    }else{
        self.selectTypeL.text = @"指纹识别验证方式登录";
        self.selectTypeImgV.image = [UIImage imageNamed:@"Mine_Privacy_finger"];
        [AppDefaultUtil setLoginVerifyWay:LoginWayFinger];
    }
    
    
}

- (IBAction)pwdLonginSelectClick:(id)sender {
    
    self.biologyImgV.hidden = YES;
    self.pwdImgV.hidden = NO;
    self.selectTypeL.text = @"密码验证方式登录";
    self.selectTypeImgV.image = [UIImage imageNamed:@"Mine_Privacy_lock"];
    [AppDefaultUtil setLoginVerifyWay:LoginWayPWD];
}

@end
