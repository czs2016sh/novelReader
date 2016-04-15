//
//  ReadingBook.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ReadingBook.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ReadingViewController.h"
#import <CoreText/CoreText.h>

@interface ReadingBook ()

@end

@implementation ReadingBook{
    BOOL _isClick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    if (self.isInternet) {
        [self achieveInfo];
    }else {
        [self labelShowText];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationContentSizeChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notificationContentSizeChange:(NSNotification *)notification {
    NSLog(@"content size chang@!!!");
}


- (void)setupPagView {
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.view.frame = [UIScreen mainScreen].bounds;
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    ReadingViewController *initViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (ReadingViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (0 == self.pagecontentArray.count || index >self.pagecontentArray.count) {
        return nil;
    }
    ReadingViewController *readingViewController = [[ReadingViewController alloc]init];
    readingViewController.dataObject = self.pagecontentArray[index];
    
    return readingViewController;
}

- (void)createContentPage {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.pagesArray.count; i ++) {
        NSString *string = self.pagesArray[i];
        [tempArray addObject:string];
    }
    self.pagecontentArray = [NSArray arrayWithArray:tempArray];
}

- (NSUInteger)indexOfViewController:(ReadingViewController *)readingViewcontroller {
    NSInteger index = [self.pagecontentArray indexOfObject:readingViewcontroller.dataObject];
    return index;
}

#pragma mark - data source / delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ReadingViewController *)viewController];
    if (0 == index || NSNotFound == index) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ReadingViewController *)viewController];
    if (NSNotFound == index) {
        return nil;
    }
    index++;
    if (self.pagecontentArray.count == index) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - label text setup
- (void) textAttributeLabel:(UILabel *)label attributedStr:(NSString *)attrStr {
    NSDictionary *fontAndRowNum = @{
                                     @"16" : @"19",
                                     @"17" : @"18",
                                     @"18" : @"17",
                                     };
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *font_rowNum = [userDefaults valueForKey:@"font_rowNum"];
    if (nil == font_rowNum) {
        [userDefaults setObject:fontAndRowNum forKey:@"font_rowNum"];
    }
    CGFloat font = [[userDefaults valueForKey:@"font"] intValue];
    if (16 != font || 17 != font || 18 != font) {
        [userDefaults setValue:@17 forKey:@"font"];
    }
    self.rowNum = [[font_rowNum valueForKey:@"font"] intValue];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:attrStr];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    paragraph.headIndent = 8;
    paragraph.paragraphSpacing = 20;
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.firstLineHeadIndent = 8;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 2)];
    label.attributedText = attributedStr;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    
}

- (void)achieveInfo {
    NSLog(@"bookId:%@",self.bookId);
    NSLog(@"chapterId:%@",self.chapterId);
    NSString *strUrl = [NSString stringWithFormat:@"%@?showapi_appid=%@&showapi_sign=%@&bookId=%@&cid=%@",APP_INFO_URL,APP_ID,APP_SECRITE,self.bookId,self.chapterId];
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"info upload error reson:%@",error.localizedDescription);
            }else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (200 == httpResponse.statusCode) {
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    self.bookInfo = [[jsonDic valueForKey:@"showapi_res_body"] valueForKey:@"txt"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
                    [self textAttributeLabel:self.textLabel attributedStr:self.bookInfo];
                    self.pagesArray = [self getSeparatedLinesFormLabel:self.textLabel];
                    [self createContentPage];
                    [self setupPagView];
                });
            }
        }];
        [dataTask resume];
    });
}


- (void)labelShowText {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    NSString *fileUrlStr = [userDefaults objectForKey:@"fileText"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVFile *file = [AVFile fileWithURL:fileUrlStr];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"download error reson:%@",error.localizedDescription);
            }else {
                NSStringEncoding strEncod = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:strEncod];
                int encoding;
                self.bookInfo = dataStr;
                if (nil == self.bookInfo) {
                    encoding = 0x80000632;
                    self.bookInfo = [NSString stringWithContentsOfFile:dataStr encoding:encoding error:&error];
                }
                if (nil == self.bookInfo) {
                    encoding = 0x80000631;
                    self.bookInfo = [NSString stringWithContentsOfFile:dataStr encoding:encoding error:&error];
                }
                if (self.bookInfo){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
                        self.textLabel.text = self.bookInfo;
                        self.textLabel.numberOfLines = 0;
                        [self textAttributeLabel:self.textLabel attributedStr:self.bookInfo];
                        self.pagesArray = [self getSeparatedLinesFormLabel:self.textLabel];
                        [self createContentPage];
                        [self setupPagView];
                    });
                }
            }
            
        }];

    });
}
//        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *filePath = [[array firstObject] stringByAppendingPathComponent:@"myText"];
//        NSData *data = [textLabel.text dataUsingEncoding:NSUTF8StringEncoding];
//        if ([data writeToFile:filePath atomically:YES]) {
//            NSLog(@"ok");
//        }
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *textPath = [documentsDirectory stringByAppendingPathComponent:@"mytext"];
//        NSLog(@"%@",textPath);
    
//        AVFile *file = [AVFile fileWithName:@"ynj.txt" contentsAtPath: @"/Users/sq-ios53/Downloads"];
//        
//        
////        AVFile *file = [AVFile fileWithData:data];
//        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                NSLog(@"error::%@",error.localizedDescription);
//            }else {
//                NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
//                [userDefaults setObject:file.url forKey:@"fileText"];
//            }
//        } progressBlock:^(NSInteger percentDone) {
//            
//        }];
//    }


//        CGRect textRect = [textLabel.text boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
//        self.textHeight = textRect.size.height;
//        NSLog(@"height :::%f",self.textHeight);
//        
//        self.textHeight = [textLabel sizeThatFits:CGSizeMake(320, MAXFLOAT)].height;
//        CGFloat numberOfLine = self.textHeight/textLabel.font.lineHeight;
//        NSLog(@"%f",textLabel.font.lineHeight);
//        NSLog(@"heitht::::%f",self.textHeight);
//        NSLog(@"hang shu ::%f",numberOfLine);
//        
//        
//        textLabel.textAlignment = NSTextAlignmentLeft;
//        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        textLabel.contentMode = UIViewContentModeLeft;
//        textLabel.numberOfLines = 0;
//        textLabel.backgroundColor = [UIColor whiteColor];
//        
//        [self.view addSubview:textLabel];


- (NSArray *)getSeparatedLinesFormLabel:(UILabel *)label {
    
    NSString *text = label.text;
    UIFont *font = label.font;
    CGRect rect = label.frame;
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)[font fontName], font.pointSize, NULL);

    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    [attributed addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range: NSMakeRange(0, attributed.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CFRelease(path);
    CFRelease(myFont);
    CFRelease(frameSetter);
    CFRelease(frame);
    NSMutableArray *linesArray = [NSMutableArray array];
    NSUInteger pageCount = lines.count/self.rowNum + 1;
    NSLog(@"pageCount:%d",pageCount);
    NSUInteger count = 0;
    NSString *pageString = nil;
    for (id line in lines) {
        count++;
        CTLineRef lineRef = (__bridge CTLineRef)line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString  = [text substringWithRange:range];
        if (1 == count) {
            pageString = lineString;
        }else {
            pageString = [pageString stringByAppendingString:lineString];
        }
        if (0 == count % 18 || (pageCount == count && (line == [lines lastObject]))) {
            [linesArray addObject:pageString];
            pageString = nil;
            count = 0;
        }
    }
//    NSLog(@"first line :%@",linesArray[1]);
//    NSLog(@"last line :%@",linesArray.lastObject);
//    NSLog(@"pages count :%d",linesArray.count);
    return (NSArray*)linesArray;
}

#pragma mark - 废弃了的textview
/*
- (void)startRead{
    NSError *error;
    NSString *fileUrl = @"/Users/sq-ios53/Downloads/越女剑.txt";
    NSStringEncoding *userEncoding = nil;
    int encoding;
    self.bookInfo = [NSString stringWithContentsOfFile:fileUrl usedEncoding:userEncoding error:&error];
    if (nil == self.bookInfo) {
        encoding = 0x80000632;
        self.bookInfo = [NSString stringWithContentsOfFile:fileUrl encoding:encoding error:&error];
    }
    if (nil == self.bookInfo) {
        encoding = 0x80000631;
        self.bookInfo = [NSString stringWithContentsOfFile:fileUrl encoding:encoding error:&error];
    }
    if (self.bookInfo){
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [self.view addSubview:self.textView];
        self.textView.text = self.bookInfo;
        NSLog(@"%d",(int)self.textView.contentSize.height/568 + 1);
        self.textView.backgroundColor = [UIColor grayColor];
        self.textView.font = [UIFont systemFontOfSize:15 weight:10];
        self.textView.editable = NO;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //        self.textView.contentInset = UIEdgeInsetsMake(5, 10, 5, 10);
        self.textView.pagingEnabled = YES;
        //        CGSize sizeToFit = [self.textView.text boundingRectWithSize:options:attributes:context:];
    }
}
 */
@end
