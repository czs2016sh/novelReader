//
//  ReadingBook.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_ID @"17833"
#define APP_SECRITE @"63609649f8354d2bbbf7e804b6a5231b"
#define APP_INFO_URL @"http://route.showapi.com/211-4"

@interface ReadingBook : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger bookTag;
@property (nonatomic, strong) NSString *bookInfo;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, copy) NSArray *pagecontentArray;

@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, copy) NSArray *pagesArray;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) BOOL isInternet;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *chapterId;

@property (nonatomic, assign) CGFloat rowNum;

@end
