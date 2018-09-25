//
//  FAddSubTypeController.m
//  ftool
//
//  Created by zhouli on 2018/6/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FAddSubTypeController.h"

@interface FAddSubTypeController ()
@property(nonatomic , weak) UITextField *nameF;
@property(nonatomic , weak) UIImageView *selectimageView;

@property(nonatomic , copy) NSString *iconName;
@end

@implementation FAddSubTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:self.title?:@"" leftName:@"取消" rightName:@"完成" delegate:self];

    UIView *bugetView = [UIView viewWithFrame:RECT(0, bar.maxY+15, MSWIDTH, 70) backgroundColor:AJWhiteColor superview:self.view];
    int x = arc4random() % 10;
    if (x==0) {
        x += 1;
    }
    NSString *iconName = [NSString stringWithFormat:@"FirstType_%02d", x];
    CGFloat imgW = 40.f;
    UIImageView *selectimageView = [UIImageView imageViewWithFrame:RECT(15, 15, imgW, imgW) imageFile:iconName superview:bugetView];
    self.iconName = iconName;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
    selectimageView.userInteractionEnabled = YES;
    [selectimageView addGestureRecognizer:gesture];
    self.selectimageView = selectimageView;
    
    CGFloat nameFH = 45.f;
    CGFloat nameFX = selectimageView.maxX + 10;
    UITextField *nameF = [AJTextField textFieldWithFrame:RECT(nameFX, (bugetView.height - nameFH)/2, MSWIDTH-nameFX-15, nameFH) delegate:self text:nil textColor:[UIColor ys_black] textFont:17 placeholder:@"请输入名称" superview:bugetView];
    self.nameF = nameF;
    
    // 图标选择
    CGFloat iconimgW = 70.f;
    CGFloat imagesVW = iconimgW*3;
    CGFloat imagesVH = iconimgW*4;
    
    UILabel *label = [UILabel labelWithFrame:RECT(15, bugetView.maxY + 20, MSWIDTH-30, 20) text:@"点击可切换图标" textFont:15 backColor:nil superview:self.view];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor ys_darkGray];
    
    UIView *imagesV = [UIView viewWithFrame:RECT(15, label.maxY+5, imagesVW, imagesVH) backgroundColor:AJWhiteColor superview:self.view];
    ViewBorderRadius(imagesV, 0, .8, [UIColor ys_grayBorder]);
    label.x = imagesV.x;
    for (int i = 0; i<10; i++) {
        
        CGFloat x = i%3 * iconimgW;
        CGFloat y = i/3 * iconimgW;
        UIView *bgView = [UIView viewWithFrame:RECT(x, y, iconimgW, iconimgW) backgroundColor:nil superview:imagesV];
        NSString *iconName = [NSString stringWithFormat:@"FirstType_%02d", i+1];
        UIImageView *imgv = [UIImageView imageViewWithFrame:RECT(5, 5, iconimgW-10, iconimgW-10) imageFile:iconName superview:bgView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
        imgv.userInteractionEnabled = YES;
        [imgv addGestureRecognizer:gesture];
        imgv.tag = i+1+100;
    }
    
    UIView *line1 = [UIView viewWithFrame:RECT(0, iconimgW, imagesVW, .5f) backgroundColor:[UIColor ys_grayLine] superview:imagesV];
    UIView *line2 = [UIView viewWithFrame:RECT(0, iconimgW*2, imagesVW, .5f) backgroundColor:[UIColor ys_grayLine] superview:imagesV];
    UIView *line3 = [UIView viewWithFrame:RECT(0, iconimgW*3, imagesVW, .5f) backgroundColor:[UIColor ys_grayLine] superview:imagesV];
    
    UIView *line4 = [UIView viewWithFrame:RECT(iconimgW, 0, .5f, imagesVH) backgroundColor:[UIColor ys_grayLine] superview:imagesV];
    UIView *line5 = [UIView viewWithFrame:RECT(iconimgW*2, 0, .5f, imagesVH) backgroundColor:[UIColor ys_grayLine] superview:imagesV];
    
}

- (void)selectImage:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    if (gesture.view.tag > 100) {
        
        
        NSString *iconName = [NSString stringWithFormat:@"FirstType_%02d", (int)gesture.view.tag - 100];
        self.iconName = iconName;
        self.selectimageView.image = [UIImage imageNamed:iconName];
        
    }
    
}

- (void)nextItemClick{
    
    if (self.nameF.text.length < 2) {
        ShowLightMessage(@"长度不够~");
    }else{
        
        FSubType *bean = [FSubType subTypeWithName:self.nameF.text];
        bean.iconName = self.iconName;
        bean.isEditable = YES;
        [self.view endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:FAddSubTypeControllerDidAddSubTypeNotification object:bean];
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

- (void)backItemClick{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
