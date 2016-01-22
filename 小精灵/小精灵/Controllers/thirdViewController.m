//
//  thirdViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/22.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "thirdViewController.h"

@interface thirdViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImage *loading;

@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation thirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;    [self.view addSubview:_webView];

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:request];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{

//    _alert = [UIAlertController alertControllerWithTitle:@"加载中^_^" message:@"网速较慢，请耐心等待……" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *sancelAction = [UIAlertAction actionWithTitle:@"取消加载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//
//    [_alert addAction:sancelAction];
//    
//    //显示alertController
//    [self presentViewController:_alert animated:YES completion:^{}];
}

@end
