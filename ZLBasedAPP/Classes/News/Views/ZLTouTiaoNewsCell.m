//
//  ZLTouTiaoNewsCell.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLTouTiaoNewsCell.h"
#import "JLBNews.h"
#import "UIImageView+WebCache.h"

@interface ZLTouTiaoNewsCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UILabel *commentL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@end

@implementation ZLTouTiaoNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleWidth.constant = MSWIDTH - 120;
}

- (void)setAJLBNews:(JLBNews *)aJLBNews{
    _aJLBNews = aJLBNews;
    
    self.titleL.text = aJLBNews.abstract;
    if (aJLBNews.abstract.length == 0) {
        self.titleL.text = @"该用户向您推荐了一个视频，请点击进入详情查看";
    }
    self.sourceL.text = aJLBNews.media_info.name?:@"未知";
    self.commentL.text = [NSString stringWithFormat:@"评论数：%@", aJLBNews.comment_count];
    
    NSURL *imgUrl = [NSURL URLWithString:aJLBNews.large_image_list.firstObject.url];
    [self.imgV sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"news_image_default-1"]];
}
@end
