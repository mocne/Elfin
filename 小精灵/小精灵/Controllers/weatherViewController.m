//
//  weatherViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/20.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "weatherViewController.h"
#import "citysViewController.h"
#import "AFNetworking.h"
#import "Header.h"

@interface weatherViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cityNameItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareItem;
@property (weak, nonatomic) IBOutlet UIButton *cityNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pollutionIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIView *allWeatherView;
@property (weak, nonatomic) IBOutlet UILabel *humidityANDwind;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIButton *lifeBtn;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSDictionary *weatherInfo;
@property (weak, nonatomic) IBOutlet UIView *centerView;


@end

@implementation weatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityName:) name:@"changeCityName" object:nil];
    if (_cityName == nil) {
        _cityName = @"北京";
    }
    _cityNameItem.title = _cityName;
    [_cityNameBtn setTitle:_cityName forState:UIControlStateNormal];
    [self getWeather];
    [self setAutoLayout];
    
}

- (void)changeCityName:(NSNotification *)notification{
    
    _cityName = notification.userInfo[@"value"];
    _cityNameItem.title = _cityName;
    [_cityNameBtn setTitle:_cityName forState:UIControlStateNormal];
    
    [self getWeather];
    
}
- (IBAction)showCitysViewController:(UIBarButtonItem *)sender {
    
    citysViewController *new = [citysViewController new];
    [self.navigationController pushViewController:new animated:YES];
    
}
- (IBAction)showCityView:(UIButton *)sender {
    citysViewController *new = [citysViewController new];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)getWeather{
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kPobAppKey;
    params[@"city"] = _cityName;
    
    NSString *urlStr = @"http://apicloud.mob.com/v1/weather/query";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *temp = (NSDictionary *)responseObject;
        
        NSArray *arr = temp[@"result"];
        
        _weatherInfo = arr[0];
        
        NSString *temper = _weatherInfo[@"temperature"];
        NSString *sig = [temper substringWithRange:NSMakeRange(0, 1)];
        if ([sig isEqualToString:@"-"]) {
            if (temper.length == 4) {
                _temperatureLabel.text = [temper substringWithRange:NSMakeRange(1, 2)];
            }
            _temperatureLabel.text = [temper substringWithRange:NSMakeRange(1, 1)];
        }
        else
        {
            if (temper.length == 3) {
                _temperatureLabel.text = [temper substringWithRange:NSMakeRange(0, 2)];
            }
            _temperatureLabel.text = [temper substringWithRange:NSMakeRange(0, 1)];
        }
    
        [_cityNameBtn setTitle:_weatherInfo[@"distrct"] forState:UIControlStateNormal];
        if (_weatherInfo[@"distrct"] == nil) {
            [_cityNameBtn setTitle:@"找不到该城市" forState:UIControlStateNormal];

        }

        _weatherLabel.text = _weatherInfo[@"weather"];
        _weekLabel.text = _weatherInfo[@"week"];
        _pollutionIndexLabel.text =[NSString stringWithFormat:@"污染指数：%@,%@",_weatherInfo[@"pollutionIndex"],_weatherInfo[@"airCondition"]];
        _humidityANDwind.text = [NSString stringWithFormat:@"%@ %@",_weatherInfo[@"humidity"],_weatherInfo[@"wind"]];
        NSString *str = _weatherInfo[@"updateTime"];
        
        NSString *str1 = [str substringWithRange:NSMakeRange(0, 4)];
        NSString *str2 = [str substringWithRange:NSMakeRange(4, 2)];
        NSString *str3 = [str substringWithRange:NSMakeRange(6, 2)];
        NSString *str4 = [str substringWithRange:NSMakeRange(8, 2)];
        NSString *str5 = [str substringWithRange:NSMakeRange(10, 2)];
        
        _dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",str1,str2,str3];
        _timeLabel.text = [NSString stringWithFormat:@"信息于 %@:%@ 发布",str4,str5];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"errror:%@",error);
    }];
    
}

- (void)setAutoLayout{
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_imageView,_temperatureLabel,_centerView);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_temperatureLabel][_imageView]-10-[_centerView]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_centerView]-20-[_centerView]" options:0 metrics:nil views:views]];

    
    
    
    
}


@end
