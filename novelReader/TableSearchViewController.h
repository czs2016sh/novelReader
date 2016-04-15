//
//  TableSearchViewController.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_ID @"17833"
#define APP_SECRITE @"63609649f8354d2bbbf7e804b6a5231b"
#define NOVEL_NAME_URL @"http://route.showapi.com/211-2"

@interface TableSearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *bookModelArray;

@end
