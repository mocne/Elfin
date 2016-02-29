//
//  starViewController.m
//  小精灵
//
//  Created by qingyun on 16/2/25.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "starViewController.h"
#import "AFHTTPSessionManager.h"
#import "Header.h"

@interface starViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *starBtn;

@property (nonatomic, strong) UIView *starView;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSString *starName;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation starViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [_starBtn addTarget:self action:@selector(changeStar) forControlEvents:UIControlEventTouchDown];
    _starName = @"水瓶座";
    _starBtn.titleLabel.text = [NSString stringWithFormat:@"%@",_starName];
    [_starBtn setBackgroundColor:[UIColor clearColor]];
    _imageView.image = [UIImage imageNamed:@"水瓶座"];
    CGFloat a = self.view.frame.size.width * 0.2;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = a;
    
    _imageView.userInteractionEnabled = YES;
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    [_imageView addGestureRecognizer:singleTap1];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0f;
    _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self getData];
    [_tableView reloadData];
}

- (void)UesrClicked:(UIGestureRecognizer *)tap{
    _starView.hidden = NO;
}

/**
 *  获取数据
 */
- (void)getData{
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kStarAppKey;
    params[@"consName"] = _starName;
    params[@"type"] = @"today";
    
    NSString *urlStr = kStarAppUrl;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success !");
        NSLog(@"%@",responseObject);
        NSDictionary *temp = (NSDictionary *)responseObject;
        _dataDic = temp;
        _timeLabel.text = [NSString stringWithFormat:@"%@更新",_dataDic[@"datetime"]];
        NSLog(@"%@",_dataDic);
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [_tableView reloadData];
}


- (IBAction)getName:(UIButton *)sender {
    
    _starName = sender.titleLabel.text;
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_starName]];
    _starBtn.titleLabel.text = [NSString stringWithFormat:@"%@",_starName];
    
    _starView.hidden = YES;
    
    [self getData];
    
    [_tableView reloadData];

    // tableView 滑到顶部
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)changeStar{
    _starView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8) {
        return 150;
    }
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"速配好友：%@", _dataDic[@"QFriend"]];

    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"健康指数：%@", _dataDic[@"health"]];

    } else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"爱情指数：%@", _dataDic[@"love"]];
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"财运指数：%@", _dataDic[@"money"]];
        
    } else if (indexPath.row == 4) {
        cell.textLabel.text = [NSString stringWithFormat:@"工作指数：%@", _dataDic[@"work"]];
        
    } else if (indexPath.row == 5) {
        cell.textLabel.text = [NSString stringWithFormat:@"综合指数：%@", _dataDic[@"all"]];
        
    } else if (indexPath.row == 6) {
        cell.textLabel.text = [NSString stringWithFormat:@"幸运色：%@", _dataDic[@"color"]];
        
    } else if (indexPath.row == 7) {
        cell.textLabel.text = [NSString stringWithFormat:@"幸运数字：%@", _dataDic[@"number"]];
        
    } else if (indexPath.row == 8) {
        cell.textLabel.text = [NSString stringWithFormat:@"总结：%@", _dataDic[@"summary"]];
        
        [cell.textLabel setNumberOfLines:0];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
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
