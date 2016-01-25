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
    _webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    [self.view addSubview:_webView];

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stopLoading];
}

@end
