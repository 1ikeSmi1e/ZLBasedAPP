//
//  ZLSettingFeedBackController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 zlbased. All rights reserved.
//
#define KmarginLeft 12.0f
#define Kmargin 10.0f
#define KmarginTop 15.0f
#define KActivityHW   40

#import "ZLSettingFeedBackController.h"
#import "LCActionSheet.h"
#import "PreviewBigImageViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "YSTFeedbackPhotoCollectionViewCell.h"

@interface ZLSettingFeedBackController ()<UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, LCActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate> {
    BOOL _isSelectOriginalPhoto;
}
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UIButton *comfirmBtn;
@property (nonatomic, strong) UIScrollView *baseScrollerView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UILabel *placeHoldLabel;
@property (nonatomic, strong) UICollectionView *pickerCollectionView;
@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIView *midBackgroundView;
@property (nonatomic, strong) UIView *topMarginView;
@property (nonatomic, strong) UIView *midTopMarginView;
@property (nonatomic, strong) UIView *midBottomMarginView;
@property (nonatomic, strong) NSString *defaultImageName;
@property (nonatomic, assign) NSInteger maxPhotoNum;
@property (nonatomic, strong) UILabel *addImgStrLabel;
@property(nonatomic,assign) CGFloat collectionFrameY;
@property (assign, nonatomic) NSInteger countNum;
@property (nonatomic, strong) NSMutableArray *identifierArray;
@property (nonatomic, strong) NSMutableArray *imageListArray;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end
static NSString * reuseIdentifierCellID = @"YSTFeedbackPhotoCollectionViewCellID";
@implementation ZLSettingFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView{
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"意见与反馈" leftName:nil rightName:@"" delegate:self];
    self.navBar = bar;
    
    [self.view addSubview:self.baseScrollerView];

    self.maxPhotoNum = 7;

    [self setSubViewsFrame];
}

#pragma mark - subviews init
- (void)setSubViewsFrame {
    [self setTopViewFrame];
    
    [self setMidViewFrame];
    
    [self setSubmitButtonFrame];
}

- (void)setTopViewFrame {
    self.topBackgroundView.frame = CGRectMake(0, 0, MSWIDTH, 160);
    [self.baseScrollerView addSubview:self.topBackgroundView];
    
    self.feedbackTextView.frame = CGRectMake(7, 0, MSWIDTH - 14, self.topBackgroundView.frame.size.height - 10);
    [self.topBackgroundView addSubview:self.feedbackTextView];
    
    self.placeHoldLabel.frame = CGRectMake(5, 5, self.feedbackTextView.frame.size.width, 20);
    [self.feedbackTextView addSubview:self.placeHoldLabel];
    
    self.topMarginView.frame = CGRectMake(0, self.topBackgroundView.frame.size.height - SINGLE_LINE_WIDTH, MSWIDTH, SINGLE_LINE_WIDTH);
    [self.topBackgroundView addSubview:self.topMarginView];
}

- (void)setMidViewFrame {
    self.midBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(self.topBackgroundView.frame) + 10, MSWIDTH, 100);
    [self.baseScrollerView addSubview:self.midBackgroundView];
    
    self.midTopMarginView.frame = CGRectMake(0, 0, MSWIDTH, SINGLE_LINE_WIDTH);
    [self.midBackgroundView addSubview:self.midTopMarginView];
    
    self.pickerCollectionView.frame = CGRectMake(0, 15, MSWIDTH, 70);
    [self.midBackgroundView addSubview:self.pickerCollectionView];
    
    self.addImgStrLabel.frame = CGRectMake(94, (self.midBackgroundView.frame.size.height - 40)/ 2, MSWIDTH - 108, 15);
    [self.pickerCollectionView addSubview:self.addImgStrLabel];
    
    self.midBottomMarginView.frame = CGRectMake(0, self.midBackgroundView.frame.size.height - SINGLE_LINE_WIDTH, MSWIDTH, SINGLE_LINE_WIDTH);
    [self.midBackgroundView addSubview:self.midBottomMarginView];
}

- (void)setSubmitButtonFrame {
    self.comfirmBtn.frame = CGRectMake(28, CGRectGetMaxY(self.midBackgroundView.frame) + 28, MSWIDTH - 56, 50);
    [self.baseScrollerView addSubview:self.comfirmBtn];
}

#pragma mark - button action
- (void)submitFeedbackInfoToService {

    [SVProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showImage:kSuccessImage status:@"提交成功!"];
    });
    [self.activity startAnimating];
//    [self.view showNoteWithView:self.activity Note:@"正在提交中" Time:0 mask:YES];
    [self.identifierArray removeAllObjects];
    [self.imageListArray removeAllObjects];
    [self.phoneNumberTextField resignFirstResponder];
    [self.feedbackTextView resignFirstResponder];
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
//    dictData[@"userCode"] = [YSTUserModel shareUserModel].userCode;
    dictData[@"busiCode"] = @"opinion";
    dictData[@"fileType"] = @"images";
    //拼接参数
    if (self.bigImageArray.count > 0) {
        [self.bigImageArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableString *identifierStr = [NSMutableString string];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //拼接参数
//            [identifierStr appendString:[NSString stringWithFormat:@"%@",[YSTUserModel shareUserModel].userCode]];
//            [identifierStr appendString:[NSString stringWithFormat:@"_%@",[CreateRandomTag randomA]]];
//            [identifierStr appendString:[NSString stringWithFormat:@"_%03lu",idx + 1]];
//            [identifierStr appendString:[NSString stringWithFormat:@".png"]];
            [self.identifierArray addObject:identifierStr];
            
            dict[@"imagesUrl"] = identifierStr;
            [self.imageListArray addObject:dict];
        }];
        NSMutableArray *array = [NSMutableArray array];
        for(UIImage *image in self.bigImageArray) {
            NSData *data =  UIImagePNGRepresentation(image);
            [array addObject:data];
        }
        [self uploadImagesWith:dictData andFileDataArray:array identifiesArray:self.identifierArray];
    }else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"userCode"] = ;
//        dict[@"opinionContent"] = self.feedbackTextView.text;
//        dict[@"mobile"] = [VerifyTools getSafeString:[self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//        dict[@"imagesList"] = [JSONKit jsonStringWithObject:self.imageListArray];
        [self sendOM019With:dict];
    }
}
#pragma mark - 上传图片信息
- (void)uploadImagesWith:(NSDictionary *)dictData andFileDataArray:(NSArray *)dataArray identifiesArray:(NSArray *)identifierArray{
//    [[YSTTimeLine shareManager] configForUpload:[[GainAllocationURL shareInstance] getBaseUPLoadUrl] params:dictData];
    __weak typeof (self)weakSelf = self;
    __block BOOL needChange = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        needChange = YES;
    });
    if (dataArray && dataArray.count > 0) {
//        [[YSTTimeLine shareManager] uploadFiles:dataArray identifies:identifierArray failBlock:^(NSError *error, NSString *identifie) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (needChange) {
//                    [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//                    [self showMessage:@"网络不给力"];
//                } else {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//                        [self showMessage:@"网络不给力"];
//                    });
//                }
//            });
//        } andFinished:^(BOOL isEnd, NSString *identifie) {
//            if (isEnd) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //发送报文
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    dict[@"userCode"] = [YSTUserModel shareUserModel].userCode;
//                    dict[@"opinionContent"] = [VerifyTools getSafeString:weakSelf.feedbackTextView.text];
//                    dict[@"mobile"] = [VerifyTools getSafeString:[weakSelf.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                    dict[@"imagesList"] = [JSONKit jsonStringWithObject:weakSelf.imageListArray];
//                    [self sendOM019With:dict];
//                    dict = nil;
//                    [weakSelf.identifierArray removeAllObjects];
//                    [weakSelf.imageListArray removeAllObjects];
//                });
//
//            }
//        }];
    }
}
#pragma mark - 加载中动画效果
//- (void)displayLoadStateImageName:(NSString *)stateImageName stateDescriStr:(NSString *)dicribStr {
//    [self.view removeNoteView:_activity.superview];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 40, 40)];
//    imageView.image = [UIImage imageNamed:stateImageName];
//    [self.view showNoteWithView:imageView Note:dicribStr Time:0.5 mask:NO];
//}

#pragma mark - 发送报文
- (void)sendOM019With:(NSDictionary *)dict {
    __weak typeof (self)weakSelf = self;
    __block BOOL needChange = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        needChange = YES;
    });
    
    [SVProgressHUD showImage:kSuccessImage status:@"提交成功"];
//    [self.http sendHttp:@"OM019" content:dict controller:self animate:NO completion:^(NSString *msgCode, NSString *isMore, NSDictionary *backCodeDict, NSDictionary *backContentDict, NSArray *backContentListDict, NSDictionary *backHeadDict) {
//        NSString *object = [backCodeDict objectForKey:@"busiState"];
//        if ([object isEqualToString:@"00"]){
//            if (needChange) {
//                [self displayLoadStateImageName:@"success_state" stateDescriStr:@"提交成功"];
//            } else {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self displayLoadStateImageName:@"success_state" stateDescriStr:@"提交成功"];
//                });
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            });
//
//        }else{
//            [self.identifierArray removeAllObjects];
//            [self.imageListArray removeAllObjects];
//            if (![@"1234" isEqualToString:[backCodeDict objectForKey:@"code"]]){
//                if (needChange) {
//                    [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//                } else {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//                    });
//                }
//            }
//        }
//    } error:^(NSError *connectionError) {
//
//        if (needChange) {
//            [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//        } else {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self displayLoadStateImageName:@"faile_state" stateDescriStr:@"提交失败"];
//            });
//        }
//        [self.identifierArray removeAllObjects];
//        [self.imageListArray removeAllObjects];
//    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallImageArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSTFeedbackPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCellID forIndexPath:indexPath];
    if (indexPath.row == self.smallImageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"SQplusImage.png"]];
        //没有任何图片
        if (self.smallImageArray.count == 0) {
            self.addImgStrLabel.hidden = NO;
        }
        else{
            self.addImgStrLabel.hidden = YES;
        }
    }
    else{
        [cell.profilePhoto setImage:self.bigImageArray[indexPath.item]];
        
    }
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto.userInteractionEnabled = YES;
    [cell.profilePhoto addGestureRecognizer:singleTap];
    
    [self updateSubviewFrame];
    
    return cell;
}

- (void)updateSubviewFrame {
    CGFloat itemWH = [self getCollectionCellWidth];
    CGFloat collectionHeight =  (itemWH + 10)* (self.smallImageArray.count / 4 + 1 );
    self.pickerCollectionView.frame = CGRectMake(0, 15, MSWIDTH, collectionHeight);
    self.midBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(self.topBackgroundView.frame) + 10, MSWIDTH, collectionHeight + 20);
    self.addImgStrLabel.frame = CGRectMake(itemWH + 24, (self.midBackgroundView.frame.size.height - 40)/ 2, MSWIDTH - itemWH - 36, 20);
    self.midBottomMarginView.frame = CGRectMake(0, self.midBackgroundView.frame.size.height - SINGLE_LINE_WIDTH, MSWIDTH, SINGLE_LINE_WIDTH);
    self.comfirmBtn.frame = CGRectMake(28, CGRectGetMaxY(self.midBackgroundView.frame) + 28, MSWIDTH - 56, 50);
    CGFloat maxHeight = CGRectGetMaxY(self.comfirmBtn.frame);
//    if (maxHeight + SafeAreaTopHeight + 20 > MSHIGHT) {
//        self.baseScrollerView.contentSize = CGSizeMake(0, maxHeight + SafeAreaTopHeight + 20 );
//    }
}

#pragma mark - otherMethod
// 图片点击事件
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    if (index == self.smallImageArray.count) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    else{
        self.hidesBottomBarWhenPushed = YES;
        PreviewBigImageViewController *previewState = [[PreviewBigImageViewController alloc] initWithCollectionViewLayout:[PreviewBigImageViewController photoPreviewViewLayoutWithSize:CGSizeMake(MSWIDTH, MSHIGHT)]];
        previewState.imgsArray = self.bigImageArray;
        [previewState.dataArray addObjectsFromArray:self.smallImageArray];
        previewState.smallImageArray = self.bigImageArray;
        previewState.selectIndex = index;
//        previewState.weakFeedbackVc = self;
        [self.navigationController pushViewController:previewState animated:YES];
    }
}
- (void)addNewImg{
    if (self.smallImageArray.count == self.maxPhotoNum) {
//        [self showMessage:@"最多只能上传7张照片"];
        ShowLightMessage(@"最多只能上传7张照片");
        return;
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] redButtonIndex:-1 delegate:self];
    [sheet show];
}

- (void)changeSelectSmallImage:(NSArray *)smallImageArray bigImageArray:(NSArray *)bigImageArray {
    if (!smallImageArray || !bigImageArray) {
        return;
    }
    [self.smallImageArray removeAllObjects];
    [self.bigImageArray removeAllObjects];
    
    [self.smallImageArray addObjectsFromArray:smallImageArray];
    [self.bigImageArray addObjectsFromArray:bigImageArray];
    
    [self.pickerCollectionView reloadData];
}

- (CGFloat)getCollectionCellWidth {
    CGFloat margin = 12;
    CGFloat itemWH = (MSWIDTH -  5 * margin) / 4 ;
    return itemWH;
}
#pragma mark - textViewDelegate textfieldDelegate
-(void) textFieldValueChanged:(id)sender{
    UITextField *field = (UITextField *)sender;
    if (field.text.length > _countNum+2) {
        field.text = [self phoneStrLayout:field.text];
        field.text = field.text;
    }else{
        if (_countNum > field.text.length) {
            if (_countNum == 5 || _countNum == 10) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@",field.text];
                if (str.length<3) {
                    
                }else{
                    field.text = [str substringToIndex:_countNum -2];
                }
            }
        }else if (_countNum < field.text.length){
            if (_countNum == 3 || _countNum == 8) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@",field.text];
                [str insertString:@" " atIndex:_countNum];
                field.text = str;
            }
        }
    }
    _countNum = (int)field.text.length;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumberTextField){
        NSInteger strLength = textField.text.length - range.length + string.length;
        return (strLength <= 13);
    }else{
        return YES;
    }
}
- (void)textChange {
    if (self.feedbackTextView.text.length > 0) {
        self.comfirmBtn.selected = YES;
        self.comfirmBtn.userInteractionEnabled = YES;
    }else {
        self.comfirmBtn.selected = NO;
        self.comfirmBtn.userInteractionEnabled = NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""])
    {
        _placeHoldLabel.hidden = YES;
    }else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeHoldLabel.hidden = NO;
        
    }
    NSInteger strLength = textView.text.length - range.length + text.length;
    return (strLength <= 200);
}
#pragma mark-  手机号判断
-(NSString *)phoneStrLayout:(NSString *)phoneNum
{
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneNum = [[[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return phoneNum;
}

#pragma mark - actionSheetDelegate
// actionsheet的代理方法
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//        [[YSTAccessRight sharedAccessRight] accessRightWithType:AccessRightTypeCamera callBlock:^(UIViewController *vc) {
            //提前定位
            __weak typeof(self) weakSelf = self;
            [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.location = location;
            } failureBlock:^(NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.location = nil;
            }];
            
            NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            //        imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
//        }];
    }else if (buttonIndex == 1) {
        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:7 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVC.selectedAssets = self.smallImageArray;
        imagePickerVC.isStatusBarDefault = NO;
        imagePickerVC.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        imagePickerVC.allowTakePicture = NO;
        imagePickerVC.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        imagePickerVC.navigationBar.tintColor = [UIColor whiteColor];
        [imagePickerVC setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
            [leftButton setImage:[UIImage imageNamed:@"navigationBarBackWhite"] forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
        }];
        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        }];
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:7 delegate:self];
        pickerVC.sortAscendingByModificationDate = YES;
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error) {
            if (error) {
                [pickerVC hideProgressHUD];
            }else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        TZAssetModel *assetModel = [models firstObject];
                        if (pickerVC.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [self.smallImageArray addObject:asset];
    [self.bigImageArray addObject:image];
    [self.pickerCollectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
    self.bigImageArray = [NSMutableArray arrayWithArray:photos];
    self.smallImageArray = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_pickerCollectionView reloadData];
}

#pragma mark - scrollerView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.phoneNumberTextField resignFirstResponder];
    [self.feedbackTextView resignFirstResponder];
}
#pragma mark - setter method
- (UIScrollView *)baseScrollerView {
    if (!_baseScrollerView) {
        _baseScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navBar.maxY, MSWIDTH, MSHIGHT)];
        _baseScrollerView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f  blue:244.0f/255.0f alpha:1.0f];
        _baseScrollerView.delegate = self;
        _baseScrollerView.showsVerticalScrollIndicator = NO;
        _baseScrollerView.showsHorizontalScrollIndicator = NO;
    }
    return _baseScrollerView;
}
- (UITextView *)feedbackTextView {
    if (!_feedbackTextView) {
        _feedbackTextView = [[UITextView alloc] init];
        _feedbackTextView.textColor = [UIColor blackColor];
        _feedbackTextView.delegate = self;
        _feedbackTextView.scrollEnabled  = YES;
        _feedbackTextView.font = [UIFont systemFontOfSize:16.0f];
        _feedbackTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:_phoneNumberTextField];
        
    }
    return _feedbackTextView;
}
- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [UITextField new];
        _phoneNumberTextField.font = [UIFont systemFontOfSize:16.0f];
        _phoneNumberTextField.textColor = [UIColor blackColor];
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"输入您的手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f  blue:100.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}];
        _phoneNumberTextField.attributedPlaceholder = attribute;
        _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.delegate = self;
        [_phoneNumberTextField addTarget:self action:@selector(textFieldValueChanged:)forControlEvents:UIControlEventEditingChanged];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:_phoneNumberTextField];
    }
    return _phoneNumberTextField;
}
- (UIButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_normal"] forState:UIControlStateNormal];
        [_comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_check"] forState:UIControlStateSelected];
        _comfirmBtn.layer.cornerRadius = 5.0f;
        _comfirmBtn.userInteractionEnabled = NO;
        _comfirmBtn.selected = NO;
        [_comfirmBtn addTarget:self action:@selector(submitFeedbackInfoToService) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _comfirmBtn;
}
- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        _placeHoldLabel = [[UILabel alloc] init];
        _placeHoldLabel.text = @"请写下您的意见与反馈(200字以内)";
        _placeHoldLabel.font = [UIFont systemFontOfSize:16];
        _placeHoldLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        _placeHoldLabel.enabled = NO;
    }
    return _placeHoldLabel;
}
- (UICollectionView *)pickerCollectionView {
    if (!_pickerCollectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        CGFloat margin = 12;
        CGFloat itemWH = [self getCollectionCellWidth];
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        _pickerCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        [_pickerCollectionView registerClass:[YSTFeedbackPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierCellID];
        _pickerCollectionView.delegate=self;
        _pickerCollectionView.dataSource=self;
        _pickerCollectionView.backgroundColor = [UIColor whiteColor];
        _pickerCollectionView.showsVerticalScrollIndicator = NO;
        _pickerCollectionView.showsHorizontalScrollIndicator = NO;
        _pickerCollectionView.scrollEnabled = NO;
    }
    return _pickerCollectionView;
}
- (UIView *)topBackgroundView {
    if (!_topBackgroundView) {
        _topBackgroundView = [UIView new];
        _topBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _topBackgroundView;
}
- (UIView *)midBackgroundView {
    if (!_midBackgroundView) {
        _midBackgroundView = [UIView new];
        _midBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _midBackgroundView;
}
- (UIView *)topMarginView {
    if (!_topMarginView) {
        _topMarginView = [UIView new];
        _topMarginView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    }
    return _topMarginView;
}
- (UIView *)midTopMarginView {
    if (!_midTopMarginView) {
        _midTopMarginView = [UIView new];
        _midTopMarginView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    }
    return _midTopMarginView;
}
- (UIView *)midBottomMarginView {
    if (!_midBottomMarginView) {
        _midBottomMarginView = [UIView new];
        _midBottomMarginView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    }
    return _midBottomMarginView;
}
- (UILabel *)addImgStrLabel {
    if (!_addImgStrLabel) {
        _addImgStrLabel = [UILabel new];
        _addImgStrLabel.text = @"上传照片(最多7张)";
        _addImgStrLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f  blue:100.0f/255.0f  alpha:1.0f];
        _addImgStrLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _addImgStrLabel;
}
- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((120 - KActivityHW)/2, 10, KActivityHW, KActivityHW)];
        UIImageView *imageView = _activity.subviews[0];
        imageView.frame = CGRectMake(0, 0, KActivityHW, KActivityHW);
    }
    return _activity;
}
- (NSMutableArray *)smallImageArray {
    if (!_smallImageArray) {
        _smallImageArray = [NSMutableArray array];
    }
    return _smallImageArray;
}
- (NSMutableArray *)bigImageArray {
    if (!_bigImageArray) {
        _bigImageArray = [NSMutableArray array];
    }
    return _bigImageArray;
}
- (NSMutableArray *)identifierArray {
    if (!_identifierArray) {
        _identifierArray = [NSMutableArray array];
    }
    return _identifierArray;
}
- (NSMutableArray *)imageListArray {
    if (!_imageListArray) {
        _imageListArray = [NSMutableArray array];
    }
    return _imageListArray;
}

@end
