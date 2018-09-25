//
//  FRateViewController.m
//  ftool
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FRateViewController.h"
#import "BaseContentCell.h"

@interface FRateViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *_titleArray;
    NSArray *_contentArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"最新利率" leftName:nil rightName:nil delegate:self];
    
    [self initData];
    
    [_tableView reloadData];
}

-(void) initData{
    [_tableView registerClass:[BaseContentCell class] forCellReuseIdentifier:@"RateViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _titleArray = [[NSArray alloc] initWithObjects:@"活期",@"3个月定期",@"6个月定期",
                   @"1年定期",@"2年定期",@"3年定期",@"5年定期", nil];
    _contentArray = [[NSArray alloc] initWithObjects:@"0.35+浮动", @"1.10+浮动",@"1.30+浮动",@"1.50+浮动",@"2.10+浮动",@"2.75+浮动",@"3.00+浮动",nil];
}


#pragma  mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ITHIGHT;
}

#pragma  mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    BaseContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RateViewCell"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rateCellIdt"];
    
    cell.titLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.conLabel.text = [_contentArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
