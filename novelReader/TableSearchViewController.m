//
//  TableSearchViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "TableSearchViewController.h"
#import "TableSearchTableViewCell.h"
#import "TableSearchModel.h"
#import "ChapterTableViewController.h"

@interface TableSearchViewController ()

@end

@implementation TableSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationController.navigationBar.hidden = YES;
    [self addSearchBarAndTableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"Czs"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lan jia zai
- (NSMutableArray *)bookModelArray {
    if (nil == _bookModelArray) {
        _bookModelArray = [NSMutableArray array];
    }
    return _bookModelArray;
}


#pragma mark - setup view
- (void)addSearchBarAndTableView {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 20, 210, 30)];
    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜搜";
    [self.view addSubview:self.searchBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(-25, 20, 75, 30);
    [backButton setTintColor:[UIColor blackColor]];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"frame_topbkbtn_bg_hl"] forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: backButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(260, 20, 60, 30);
    [searchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    [self.view addSubview: self.tableView];
}

#pragma mark - button clicked
- (void)clickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)clickSearchButton {
    self.searchBar.text = @"";
    if (nil == self.searchBar.text) {
        NSLog(@"text bu ke wei kong");
    }else {
        NSString *urlStr = [NSString stringWithFormat:@"%@?showapi_appid=%@&showapi_sign=%@&keyword=%@",NOVEL_NAME_URL,APP_ID,APP_SECRITE,self.searchBar.text];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        NSURLSession *session = [NSURLSession sharedSession];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"error reson:%@",error.localizedDescription);
                if (200 == httpResponse.statusCode) {
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    NSArray *novelArray = [[[jsonDic valueForKey:@"showapi_res_body"] valueForKey:@"pagebean"] valueForKey:@"contentlist"];
                    for (NSDictionary *dic in novelArray) {
                        TableSearchModel *novelModel = [[TableSearchModel alloc] init];
                        novelModel.bookId = [dic valueForKey:@"id"];
                        novelModel.bookAuthor = [dic valueForKey:@"author"];
                        novelModel.bookName = [dic valueForKey:@"name"];
                        novelModel.chapterOfNew = [dic valueForKey:@"newChapter"];
                        novelModel.updataTime = [dic valueForKey:@"updateTime"];
                        [self.bookModelArray addObject:novelModel];
                    }
                }else {
                    NSLog(@"dataTask error reson:%@",error.localizedDescription);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
            [dataTask resume];
        });
    }
}

#pragma mark - dataSource / delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@",self.bookModelArray);
    return self.bookModelArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Czs"];
    [cell initWithModel:self.bookModelArray[indexPath.row]];
    NSLog(@"12345");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"22222");
    ChapterTableViewController *chapterVC = [[ChapterTableViewController alloc] init];
    chapterVC.bookId = [self.bookModelArray[indexPath.row] bookId];
    NSLog(@"id::%@",chapterVC.bookId);
    UINavigationController *navigatioinController = [[UINavigationController alloc] initWithRootViewController:chapterVC];
    
    [self presentViewController:navigatioinController animated:YES completion:nil];
}

@end
