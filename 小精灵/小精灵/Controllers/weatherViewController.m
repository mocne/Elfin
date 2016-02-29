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
#import "futureWeayherViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface weatherViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cityNameItem;
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
@property (nonatomic, strong) NSDictionary *todayWeather;
@property (nonatomic, strong) NSArray *futureWeather;
@property (weak, nonatomic) IBOutlet UIView *newlifeInfoView;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dressing_index;
@property (weak, nonatomic) IBOutlet UILabel *uv_index;
@property (weak, nonatomic) IBOutlet UILabel *comfort_index;
@property (weak, nonatomic) IBOutlet UILabel *wash_index;
@property (weak, nonatomic) IBOutlet UILabel *travel_index;
@property (weak, nonatomic) IBOutlet UILabel *exercise_index;
@property (weak, nonatomic) IBOutlet UILabel *drying_index;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation weatherViewController

#define QYScreenW [UIScreen mainScreen].bounds.size.width
#define QYScreenH [UIScreen mainScreen].bounds.size.height
#define Count 3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self loadData];
    [self startLocation];
    
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityName:) name:@"changeCityName" object:nil];
    if (_cityName == nil) {
        _cityName = @"北京";
    }
    
    [self loadData];
    [self startLocation];
    
    _cityNameItem.title = _cityName;
    [_cityNameBtn setTitle:_cityName forState:UIControlStateNormal];
    
    [self getWeather];
}

- (void)loadData{
    
}

//开始定位

-(void)startLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //向用户申请授权,如果授权是没有决定的
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = 10.0f;
    
    //GPS硬件是开启的
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"GPS 不能用");
    }
}


//定位代理经纬度回调

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"location ok");
    
//    CLLocation *location = oldLocation.lastObject;
//    NSLog(@"%@", location);
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            
            //  Country(国家)  State(城市)  SubLocality(区)
            
            NSLog(@"%@", [test objectForKey:@"State"]);
            
            _cityName = test[@"City"];
            _cityNameItem.title = _cityName;
            [_cityNameBtn  setTitle:_cityName forState:UIControlStateNormal];
            [self getWeather];
            
        }
    }];
    [_locationManager stopUpdatingLocation];

}


// 进入
- (void)join{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    _scrollView.hidden = YES;
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
    params[@"key"] = kJuheWeatherAppKey;
    params[@"cityname"] = _cityName;
    params[@"dtype"] = @"json";
    
    NSString *urlStr = @"http://op.juhe.cn/onebox/weather/query";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //提示：如果开发网络应用，可以将反序列化出来的对象，保存至沙箱，以便后续开发使用。
        
    
        NSDictionary *temp = (NSDictionary *)responseObject;

        NSDictionary *dic = temp[@"result"][@"data"];
        
        _weatherInfo = dic[@"realtime"];
        _todayWeather = dic[@"today"];
        _futureWeather = dic[@"weather"];
        
        [_cityNameBtn setTitle:_weatherInfo[@"city_name"] forState:UIControlStateNormal];
        
        _temperatureLabel.text = [NSString stringWithFormat:@"%@°",_weatherInfo[@"weather"][@"temperature"]];

        _weatherLabel.text = _weatherInfo[@"weather"][@"info"];
        _weekLabel.text = [NSString stringWithFormat:@"星期%@",dic[@"weather"][0][@"week"]];
        _pollutionIndexLabel.text =[NSString stringWithFormat:@"PM2.5：%@",dic[@"pm25"][@"pm25"][@"pm25"]];
        _humidityANDwind.text = [NSString stringWithFormat:@"%@%@ %@米/秒",_weatherInfo[@"wind"][@"direct"],_weatherInfo[@"wind"][@"power"],_weatherInfo[@"wind"][@"windspeed"]];
        _dateLabel.text = [NSString stringWithFormat:@"%@",_weatherInfo[@"date"]];
        _timeLabel.text = [NSString stringWithFormat:@"信息于 %@ 发布",_weatherInfo[@"time"]];
        _adviceLabel.text = [NSString stringWithFormat:@"  %@",dic[@"life"][@"info"][@"ganmao"][1]];
        _dressing_index.text = [NSString stringWithFormat:@"穿衣指数:%@",dic[@"life"][@"info"][@"chuanyi"][1]];
        _drying_index.text = [NSString stringWithFormat:@"空调指数:%@",dic[@"life"][@"info"][@"kongtiao"][0]];
        _uv_index.text = [NSString stringWithFormat:@"紫外线指数:%@",dic[@"life"][@"info"][@"ziwaixian"][0]];
        _comfort_index.text = [NSString stringWithFormat:@"污染指数:%@",dic[@"life"][@"info"][@"wuran"][0]];
        _wash_index.text = [NSString stringWithFormat:@"洗刷指数:%@",dic[@"life"][@"info"][@"xiche"][0]];
        _travel_index.text = [NSString stringWithFormat:@"感冒指数:%@",dic[@"life"][@"info"][@"ganmao"][0]];
        _exercise_index.text = [NSString stringWithFormat:@"锻炼指数:%@",dic[@"life"][@"info"][@"yundong"][0]];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"errror:%@",error);
    }];

}


- (IBAction)jumpToFuture:(UIButton *)sender {
    
    futureWeayherViewController *new1 = [futureWeayherViewController new];
    [new1 setValue:_futureWeather forKey:@"futureWeatherInfo"];
    
    [self.navigationController pushViewController:new1 animated:YES];
}

- (IBAction)showLifeInfo:(UIButton *)sender {
    if (_newlifeInfoView.hidden == NO) {
        _newlifeInfoView.hidden = YES;
    }
    else{
    _newlifeInfoView.hidden = NO;
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _newlifeInfoView.hidden = YES;

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//      判断启动的目标View是否为MyViewController
    if([[segue destinationViewController] class] == [futureWeayherViewController class])
    {
        futureWeayherViewController *myView = [segue destinationViewController];
        [myView setValue:_futureWeather forKey:@"futureWeatherInfo"];
    }
}
@end
