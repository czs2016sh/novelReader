//
//  SearchViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CostomSearchView" owner:self options:nil];
    UIView *xibView = [array firstObject];

    [self.view addSubview:xibView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSearchButton:(id)sender {
    if (nil == self.searchBar.text) {
        NSLog(@"搜索内容不可为空");
    }else {
        [self createWebRequest:self.searchBar.text];
    }
}

- (void)createWebRequest:(NSString *)requestUrl {
    NSString *urlStr = [NSString stringWithFormat:@"http://m.bing.com/search?q=%@",requestUrl];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [self.webView loadRequest:urlRequest];
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
