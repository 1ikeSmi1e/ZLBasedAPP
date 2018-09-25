//
//  UITableViewCell+AJ.h
//  SP2P_9
//
//  Created by eims on 16/12/12.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewCellDelegate <NSObject>

- (void)setTopBar;

@end

@interface UITableViewCell (AJ)<UITableViewCellDelegate>

@end

//@interface UITableView(custom)
//@end
//@implementation UITableView(custom)
//
//+ (void)load
//{
//    Method method1 = class_getInstanceMethod(self, @selector(initWithFrame:style:));
//    Method method2 = class_getInstanceMethod(self, @selector(aj_initWithFrame:style:));
//    method_exchangeImplementations(method1, method2);
//}
//- (instancetype)aj_initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    UITableView *tableV = [[UITableView alloc] aj_initWithFrame:frame style:UITableViewStylePlain];
//    // tableV的统一设置
//    return tableV;
//}
//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
//    [tableView setValue:@(UITableViewStylePlain) forKey:@"style"];
//    return tableView;
//}
//@end

