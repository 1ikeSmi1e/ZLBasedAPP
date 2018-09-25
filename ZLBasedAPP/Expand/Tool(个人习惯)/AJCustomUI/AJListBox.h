//
//  AJListBox.h
//  SP2P
//
//  Created by Ajax on 16/3/5.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJListBox;

@protocol AJListBoxDelegate <NSObject>

@optional
- (void)didClickAjComboBox:(AJListBox *)comboBox;
- (void)listBoxDidHidden:(AJListBox *)comboBox;
@required

-(void)didChangeComboBoxValue:(AJListBox *)comboBox selectedIndex:(NSInteger)selectedIndex;
@end

@interface AJListBox : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIControl *viewControl;
    //    NSInteger selectedIndex;
}
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, weak)   UITableView *table;
@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, weak) id<AJListBoxDelegate> delegate;
@property (nonatomic, assign) BOOL enabled;
@end
