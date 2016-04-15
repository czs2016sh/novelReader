//
//  ChapterTableViewController.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_ID @"17833"
#define APP_SECRITE @"63609649f8354d2bbbf7e804b6a5231b"
#define APP_CHAPTER_URL @"http://route.showapi.com/211-1"

@interface ChapterTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *chapterArray;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) NSMutableArray *chapterIdArray;

@end
