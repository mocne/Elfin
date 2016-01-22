//
//  futureWeayherViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/21.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "futureWeayherViewController.h"

@interface futureWeayherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *futureWeatherInfo;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation futureWeayherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}


#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _futureWeatherInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"kCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = _futureWeatherInfo[indexPath.row];
    NSString *str = dict[@"date"];
    NSArray *dayInfo = dict[@"info"][@"day"];
    NSArray *nightInfo = dict[@"info"][@"night"];
    
    NSString *str3 = [str substringWithRange:NSMakeRange(8, 2)];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@日 农历:%@ 星期%@",str3,dict[@"nongli"],dict[@"week"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"    白天：%@; 最低温度:%@; 最高温度:%@; 风速:%@%@; 日出时间:%@\n    夜晚：%@; 最低温度:%@; 最高温度:%@; 风速:%@%@; 日落时间:%@",dayInfo[1],dayInfo[2],dayInfo[0],dayInfo[3],dayInfo[4],dayInfo[5],nightInfo[1],nightInfo[2],nightInfo[0],nightInfo[3],nightInfo[4],nightInfo[5]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.f;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




@end
