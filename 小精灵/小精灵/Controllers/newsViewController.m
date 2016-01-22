//
//  newsViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/21.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "newsViewController.h"
#import "Header.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "secondNewsViewController.h"

@interface newsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *newsInfo;
@property (nonatomic, strong) NSArray *newstitle;
@property (nonatomic, strong) NSString *temp;
//@property (nonatomic, strong) NSString *title;

@end

@implementation newsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getNews];
    
}

- (void)getNews{

    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kNewsAppKey;
    params[@"q"] = @"郑州";
    params[@"dtype"] = @"json";
    

    NSString *urlStr = @"http://op.juhe.cn/onebox/news/words";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        _newstitle = dic[@"result"];
        [_tableView reloadData];
    } failure:nil];

    
    
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newstitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"♦️ %@",_newstitle[indexPath.row]];
    return cell;
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    secondNewsViewController *new = [secondNewsViewController new];
    [new setValue:_newstitle[indexPath.row] forKey:@"newsTitle"];
    [self.navigationController pushViewController:new animated:YES];
    
}


@end
