//
//  ZLQRCodeGeneratorController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLQRCodeGeneratorController.h"
#import "WSPlaceholderTextView.h"
#import "UIImageView+AJ.h"

@interface ZLQRCodeGeneratorController ()<UITextViewDelegate>

@property (nonatomic, weak) UIImageView *QRImgV;
@property (nonatomic, weak) UIImageView *QRImgV_none;
@property (nonatomic, weak) UITextView *InputTextView;
@end

@implementation ZLQRCodeGeneratorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"二维码生成器" leftName:nil rightName:@"" delegate:self];
    
    // 结果展示板
    UIView *resultBoard = [UIView viewWithFrame:RECT(0, bar.maxY, MSWIDTH, 200) backgroundColor:AJWhiteColor superview:self.view];
    UILabel *headL = [UILabel labelWithFrame:RECT(15, 0, MSWIDTH, 40) text:@"预览" textColor:UIColor.ys_darkGray textFont:14 fitWidth:NO superview:resultBoard];
    
    CGFloat imgWH = 120;
    UIImageView *QRImgV = [UIImageView imageViewWithFrame:RECT((resultBoard.width - imgWH)/2, (resultBoard.height - imgWH)/2, imgWH, imgWH) imageFile:nil superview:resultBoard];
    self.QRImgV = QRImgV;
//    QRImgV.backgroundColor = UIColor.lightGrayColor;
    ViewBorderRadius(QRImgV, 2, .5, UIColor.ys_grayLine);
    
    CGFloat QRImgV_noneH = 50;
    UIImageView *QRImgV_none = [UIImageView imageViewWithFrame:RECT((QRImgV.height - QRImgV_noneH)/2, (QRImgV.height - QRImgV_noneH)/2, QRImgV_noneH, QRImgV_noneH) imageFile:@"QRCodeGenerator_none" superview:QRImgV];
    self.QRImgV_none = QRImgV_none;
//    QRImgV_none.backgroundColor = UIColor.ys_blue;
//
    UIButton *btn1 = [UIButton buttonWithFrame:RECT(0, resultBoard.height - 40, MSWIDTH, 40) backgroundColor:nil title:@"保存至相册" titleColor:UIColor.ys_blue titleFont:15 target:self action:@selector(saveToPhotoLibrary:) superview:resultBoard];
    
    UIView *line = [UIView viewWithFrame:RECT(0, resultBoard.maxY, MSWIDTH, .5) backgroundColor:UIColor.ys_darkGray superview:self.view];
    
    WSPlaceholderTextView *InputTextView = [WSPlaceholderTextView textViewWithFrame:RECT(10, resultBoard.maxY + 25, MSWIDTH-20, resultBoard.height-20) textColor:UIColor.ys_orange bgColor:nil font:14 superV:self.view];
    self.InputTextView = InputTextView;
    InputTextView.placeholder = @"请输入要生成二维码的文字";
    ViewBorderRadius(InputTextView, 3, .8, UIColor.ys_grayLine);
    InputTextView.delegate = self;
    
//    InputTextView addObserver:self forKeyPath:@"text" options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>
}

- (void)saveToPhotoLibrary:(UIButton *)sender
{
    if (self.QRImgV.image) {
        
        [self loadImageFinished:self.QRImgV.image];
    }
//    DLOG_METHOD;
}


- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
         ShowLightMessage(error.localizedDescription);
    }else{
        
         [SVProgressHUD showImage:kSuccessImage status:@"已保存至相册！"];
    }
   
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.QRImgV_none.hidden = NO;
    self.QRImgV.image = nil;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (text.length == 0) {
        ShowLightMessage(@"您未输入文字。");
        self.QRImgV_none.hidden = NO;
        return;
    }
    
    ShowLightMessage(@"二维码已刷新!");
    [self.QRImgV showQRCodeWithStr:text];
    self.QRImgV_none.hidden = YES;
}
@end
