//
//  JLBNews.h
//  ZLBasedAPP
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLBaseEntity.h"

@class JLBNews_media_info, JLBNews_large_image_list;
@interface JLBNews : ZLBaseEntity

@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *article_url;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *display_url;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, strong) NSArray<JLBNews_large_image_list *> *large_image_list;// JLBNews_large_image_list
@property (nonatomic, strong) JLBNews_media_info *media_info;// JLBNews_media_info
@end

@interface JLBNews_large_image_list : ZLBaseEntity //
@property (nonatomic, copy) NSString *url;
@end


@interface JLBNews_media_info : ZLBaseEntity //
@property (nonatomic, copy) NSString *name;


@end
