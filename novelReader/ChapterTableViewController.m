//
//  ChapterTableViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ChapterTableViewController.h"
#import "ChapterTableViewCell.h"
#import "ReadingBook.h"

@interface ChapterTableViewController ()

@end

@implementation ChapterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"33333333");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.hidden = NO;
    [self addBackButton];
    [self achieveChapter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - back button and action
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_red"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backButtonClick:(UIButton *)send {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lan jia zai 
- (NSMutableArray *)chapterArray {
    if (nil == _chapterArray) {
        _chapterArray = [NSMutableArray array];
    }
    return _chapterArray;
}
- (NSMutableArray *)chapterIdArray {
    if (nil == _chapterIdArray) {
        _chapterIdArray = [NSMutableArray array];
    }
    return _chapterIdArray;
}

- (void)achieveChapter {
    NSLog(@"bookId:%@",self.bookId);
    NSString *strUrl = [NSString stringWithFormat:@"%@?showapi_appid=%@&showapi_sign=%@&bookId=%@",APP_CHAPTER_URL,APP_ID,APP_SECRITE,self.bookId];
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"chapter upload error reson:%@",error.localizedDescription);
            }else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (200 == httpResponse.statusCode) {
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    NSArray *chapter = [[[jsonDic valueForKey:@"showapi_res_body"] valueForKey:@"book"] valueForKey:@"chapterList"];
                    for (NSDictionary *dic in chapter) {
                        NSString *name = [dic valueForKey:@"name"];
                        [self.chapterArray addObject:name];
                        NSString *chapterId = [dic valueForKey:@"cid"];
                        [self.chapterIdArray addObject:chapterId];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    });
                }
            }
        }];
        [dataTask resume];
    });
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Czs"];
    UILabel *label;
    if (nil == cell) {
        cell = [[ChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Czs"];
        cell.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        NSLog(@"1234");
        label= [[UILabel alloc] initWithFrame:CGRectMake(20, 7, (cell.bounds.size.width-40), 30)];
        [cell addSubview:label];
    }
    label.text = self.chapterArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadingBook *readVC = [[ReadingBook alloc] init];
    readVC.bookId = self.bookId;
    readVC.chapterId = self.chapterIdArray[indexPath.row];
    readVC.isInternet = YES;
    
    [self.navigationController pushViewController:readVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
