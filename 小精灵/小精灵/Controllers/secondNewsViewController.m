//
//  secondNewsViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/22.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "secondNewsViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFURLSessionManager.h"
#import "Header.h"
#import "thirdViewController.h"
#import "newsViewController.h"

@interface secondNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *newsTableView;
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSArray *newsInfo;

@end

@implementation secondNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _newsTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _newsTableView.rowHeight = 44.f;
    _newsTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;

    [self.view addSubview:_newsTableView];
    self.title = @"相关综述";
    
    [self getNewsFromTitle];
    
}

- (void)getNewsFromTitle{
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kNewsAppKey;
    params[@"q"] = _newsTitle;
    params[@"dtype"] = @"json";
    
    
    NSString *urlStr = @"http://op.juhe.cn/onebox/news/query";
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *str = dic[@"reason"];
        
        if ([str isEqualToString:@"查询成功"]) {
            _newsInfo = dic[@"result"];
            
            [_newsTableView reloadData];
        } else {
            UIAlertController *new = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"查询不到相关的新闻" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sancelAction = [UIAlertAction actionWithTitle:@"取消加载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [new addAction:sancelAction];
            
            [self presentViewController:new animated:YES completion:^{}];
            

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *new = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"查询不到相关的新闻" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sancelAction = [UIAlertAction actionWithTitle:@"取消加载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [new addAction:sancelAction];
        
        [self presentViewController:new animated:YES completion:^{}];

    }];
    
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _newsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dic = _newsInfo[indexPath.row];
    
    cell.textLabel.numberOfLines = 1;
    cell.detailTextLabel.numberOfLines = 4;
    
    cell.textLabel.text = [NSString stringWithFormat:@"⭕️ %@ : %@",dic[@"src"],dic[@"title"]];
    cell.detailTextLabel.text = dic[@"content"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        thirdViewController *new = [thirdViewController new];
        [new setValue:_newsInfo[indexPath.row][@"url"] forKey:@"urlStr"];
        [self.navigationController pushViewController:new animated:YES];

    
}



@end
