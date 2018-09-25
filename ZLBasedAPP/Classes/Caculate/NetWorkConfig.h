//
//  NetWorkConfig.h
//
//  Created by Jerry on 15/9/29.
//  Modify by Farley on 17/5/09.
//  Copyright (c) 2015年 EIMS. All rights reserved.

#ifndef Shove_NetWorkConfig_h
#define Shove_NetWorkConfig_h

//接口类型：1 汇付 2 富友 3 宝付网关
#define INTERFACE_TYPE 1

//请求响应code: 登录超时
#define NK_LOGIN_TIMEOUT -105

//请求响应code: 未开户
#define NK_NO_ACCOUNT -102
//请求响应code: 未实名认证 (富友)
#define NK_NO_RealName -103
//请求响应code: 未绑卡 
#define NK_NO_CARD -104

//请求响应code: 余额不足 (让接口同学修改为-110)
#define NK_MONEY_LESS -110


#define AppleID         @"1072288702"
#define AppDownloadURL  @"https://itunes.apple.com/cn/app/id1072288702"

//是否为测试环境
#define IS_TEST 0

#if IS_TEST               // test或debug站点

    #define MD5key  @"cAFLJNuy9SySNIvN"
    #define DESkey  @"0XRRMjgkZYaxCXzC"
    #define Baseurl   @"http://p2p-9.test5.wangdai.me"//汇付测试站点

#else                     // 正式环境
    //app端传输 key
    #define MD5key  @"DFGgrgkl45DGkj8g"
    // 加密 key
    #define DESkey  @"DFGgrgkl45DG3des"
    #define Baseurl @"http://p2p10.ys.xf.cc"

#endif

#define ShareRedirectURL @"http://p2p9.ys.xf.cc"//分享回调地址

/**
 *  是否开放登录权限
 * 0 不开放  1 开放
 */
#define IS_VISITOR  1

/** 可变服务器根url */
//#define VarBaseUrl [NetWorkClient getVarBaseURL]
//
//#define BaseImageUpload [NSString stringWithFormat:@"%@/common/appImagesUpload",VarBaseUrl]  //头像上传


#endif
