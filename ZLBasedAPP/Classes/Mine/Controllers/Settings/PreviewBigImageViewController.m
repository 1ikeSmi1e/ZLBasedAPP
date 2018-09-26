//
//  PreviewBigImageViewController.m
//  MobilePaymentOS
//
//  Created by YST on 16/6/20.
//  Copyright © 2016年 yinsheng. All rights reserved.
//

#import "PreviewBigImageViewController.h"
#import "PreviewBigImageCell.h"
#import "LCActionSheet.h"
//#import "UIView+LYExtension.h"

@interface PreviewBigImageViewController ()<LCActionSheetDelegate>{
    
    UILabel *titleLabel;
}

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *smallImageSource;

@property (nonatomic, strong) UIButton *topBar;
@property (nonatomic, assign) BOOL isDelete;
@end

@implementation PreviewBigImageViewController

static NSString * const reuseIdentifier = @"PreviewBigImageCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDelete = NO;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self initDataSource];
    
    [self _setupCollectionView];
    
    [self _setup];
    
    // Do any additional setup after loading the view.
}
#pragma mark - navigationBarStyle set
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - init
- (void)_setupCollectionView {
    
    [self.collectionView registerClass:[PreviewBigImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.assets.count, self.view.frame.size.height);
    self.collectionView.pagingEnabled = YES;
    
}
- (void)_setup{
    
    [self.view addSubview:self.topBar];
    
}
- (void)initDataSource{
    
    [self.smallImageSource addObjectsFromArray:_smallImageArray];
    
    [self.dataSource addObjectsFromArray:_imgsArray];
}
+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(size.width, size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        
        PreviewBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        id object = self.dataSource[indexPath.row];
        
        if ([object isKindOfClass:[UIImage class]]) {
            
            [cell configureWithBigImage:self.dataSource[indexPath.row] andIsHidden:_topBar.selected];
            
        }else if([object isKindOfClass:[NSDictionary class]]){
            
            [cell configureWithImageDict:self.dataSource[indexPath.row] andIsHidden:_topBar.selected];
        }
        
        
        // Configure the cell
        
        if (self.isDelete) {
            titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",indexPath.row + 1,self.dataSource.count];
            
            _selectIndex = indexPath.row ;
            
            self.isDelete = NO;
        }
        
        __weak typeof(*&self) wSelf = self;
        [cell setSingleTapBlock:^{
            __weak typeof(*&self) self = wSelf;
            
            [self _setBar];
        }];
        
        return cell;

    }else{
        
        return nil;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",indexPathNow.row + 1,self.dataSource.count];
    
    _selectIndex = indexPathNow.row ;
    // 更新底部的数据
    // ...
}

#pragma mark - getter method
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)smallImageSource{
    
    if (!_smallImageSource) {
        
        _smallImageSource = [NSMutableArray array];
    }
    
    return _smallImageSource;
}
- (UIButton *)topBar {
    if (!_topBar) {
        
        CGFloat originY = 20;
        
        _topBar = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBar.frame = CGRectMake(0, 0, self.view.frame.size.width, originY + 44);
        _topBar.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f];
        
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backgroundBtn.frame = CGRectMake(0, 20, 100, 44);
        
        [_topBar addSubview:backgroundBtn];
        
        [backgroundBtn addTarget:self action:@selector(_handleBackAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 12, 17)];
        
        [backgroundBtn addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:@"navigation_back"];
        
//        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
//        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//        [backButton sizeToFit];
//        backButton.frame = CGRectMake(0, _topBar.frame.size.height/2 - backButton.frame.size.height/2 + originY/2, backButton.frame.size.width, backButton.frame.size.height);
//        [backButton addTarget:self action:@selector(_handleBackAction) forControlEvents:UIControlEventTouchUpInside];
//        [_topBar addSubview:backButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5 , imageView.frame.origin.y, backgroundBtn.frame.size.width - CGRectGetMaxX(imageView.frame)- 10, 20)];
        
        [backgroundBtn addSubview:label];
        
        label.text = @"返回";
        
        label.textColor = [UIColor whiteColor];
        
        label.font = [UIFont systemFontOfSize:17.0f];
        
        if (!_isTransmit) {
            
            UIButton *stateButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            [stateButton setImage:[UIImage imageNamed:@"frienddelete"] forState:UIControlStateNormal];
            //        [stateButton setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
            //        [stateButton setTitle:@"..." forState:UIControlStateNormal];
            [stateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            [stateButton sizeToFit];
            stateButton.frame = CGRectMake(_topBar.frame.size.width - 12 - stateButton.frame.size.width, _topBar.frame.size.height/2 - stateButton.frame.size.height/2 + originY/2, stateButton.frame.size.width, stateButton.frame.size.height);
            
            [stateButton addTarget:self action:@selector(_handleStateChangeAction) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:stateButton];
        }

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH /2 - 40, CGRectGetMidY(backgroundBtn.frame) - 8, 80, 20)];
        
        [_topBar addSubview:titleLabel];
        
        titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",_selectIndex + 1,_imgsArray.count];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        
        titleLabel.textColor = [UIColor whiteColor];
        
    }
    return _topBar;
}
#pragma mark - button aciton
- (void)_handleBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)_handleStateChangeAction{
    
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"要删除这张照片吗?" buttonTitles:@[@"删除"] redButtonIndex:0 delegate:self];
    
    [sheet show];
}

- (void)_setBar {
    
    self.topBar.selected = !self.topBar.selected;
    
    if (self.topBar.selected) {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.topBar.frame = CGRectMake(0, - self.topBar.frame.size.height, MSWIDTH, self.topBar.frame.size.height);
            
            //            self.bottomBar.frame = CGRectMake(0, MSHIGHT , MSWIDTH, self.bottomBar.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:.3 animations:^{
            self.topBar.frame = CGRectMake(0, 0, MSWIDTH, self.topBar.frame.size.height);
            
            //            self.bottomBar.frame = CGRectMake(0, MSHIGHT - self.bottomBar.frame.size.height, MSWIDTH, self.bottomBar.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    DLOG_METHOD;
    if (buttonIndex == 0) {
        self.isDelete = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 40, 40)];
        imageView.image = [UIImage imageNamed:@"succeed_state_jsd"];
//        [self.view showNoteWithView:imageView Note:@"删除" Time:0.5 mask:NO];
        
        __weak typeof (self)weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.dataSource removeObjectAtIndex:_selectIndex];
            [weakSelf.dataArray removeObjectAtIndex:_selectIndex];
            [weakSelf.smallImageSource removeObjectAtIndex:_selectIndex];
            
            
//            if (weakSelf.stateVc) {
//                [weakSelf.stateVc changeSelectImageWithBigImagesArray:weakSelf.dataArray andSmallImagsArry:weakSelf.smallImageSource];
//                
//                if (weakSelf.dataSource.count == 0) {
//                    
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                    
//                }else{
//                    
//                    [weakSelf.collectionView reloadData];
//                }
//            }else if (weakSelf.weakFeedbackVc) {
//                [weakSelf.weakFeedbackVc changeSelectSmallImage:weakSelf.dataArray bigImageArray:weakSelf.smallImageSource];
//                
//                if (weakSelf.dataSource.count == 0) {
//                    
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                    
//                }else{
//                    
//                    [weakSelf.collectionView reloadData];
//                }
//            }

            
        });
    }
}

#pragma mark - other system method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
