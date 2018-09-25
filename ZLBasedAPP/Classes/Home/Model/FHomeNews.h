//
//  FHomeNews.h
//  ftool
//
//  Created by admin on 2018/6/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseEntity.h"

@interface FHomeNews : ZLBaseEntity

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *image_filename;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@end
