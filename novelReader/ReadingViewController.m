//
//  ReadingViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController{
    BOOL _isClick;
//    NSInteger _increaseClickCount;
//    NSInteger _reduceClickCount;
    NSInteger _chapterClickCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupLabel];
    [self addToobbar];
}

#pragma mark - bar hidden or show
- (void)hiddenOrShowOfBar {
    if (NO == _isClick) {
        self.navigationController.navigationBar.hidden = NO;
        self.toolbar.hidden = NO;
        _isClick = YES;
    }else {
        self.navigationController.navigationBar.hidden = YES;
        self.toolbar.hidden = YES;
        _isClick = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"dff");
    [self hiddenOrShowOfBar];
}
#pragma mark - setup label
- (void)setupLabel {
    self.contentLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.center = self.view.center;
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    [self.contentLabel setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
    [self textAttributeLabel:self.contentLabel attributedStr:self.dataObject];
    
    [self.view addSubview: self.contentLabel];

}


#pragma mark - label text setup
- (void) textAttributeLabel:(UILabel *)label attributedStr:(NSString *)attrStr {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    CGFloat font = [[userDefaults valueForKey:@"font"] intValue];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:attrStr];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    paragraph.headIndent = 8;
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.firstLineHeadIndent = 8;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 2)];
    label.attributedText = attributedStr;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    
}

- (void)addToobbar {
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.toolbar.center = CGPointMake(160, 548);
    self.toolbar.hidden = YES;
    UIBarButtonItem *catalogButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Read_mulu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCatalogButton)];

    UIBarButtonItem *sizeIncreaseButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Read_size_jia"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSizeIncreaseButton)];
    
    UIBarButtonItem *sizeReduceButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Read_size_jian"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSizeReduceButton)];
    
    UIBarButtonItem *spraing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *itemArray = @[spraing, catalogButtonItem,spraing,  sizeReduceButtonItem,spraing, sizeIncreaseButtonItem, spraing];
    self.toolbar.items = itemArray;
    [self.view addSubview:self.toolbar];
    [self.view bringSubviewToFront:self.toolbar];

}

- (void)clickCatalogButton {
    _chapterClickCount++;
    if (1 == _chapterClickCount%2) {
        self.contentLabel.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.16 alpha:1];
    } else {
        self.contentLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)clickSizeIncreaseButton {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    CGFloat font = [[userDefaults valueForKey:@"font"] intValue];
    if (18 > font) {
        font++;
        [userDefaults setObject:[NSString stringWithFormat:@"%f",font] forKey:@"font"];
        [self viewWillAppear:YES];
    }
}

- (void)clickSizeReduceButton {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    CGFloat font = [[userDefaults valueForKey:@"font"] intValue];
    if (16 < font) {
        font--;
        [userDefaults setValue:[NSString stringWithFormat:@"%f",font] forKey:@"font"];
        [self viewWillAppear:YES];
    }
}



#pragma mark - 丢弃的webview
/*
- (void)setupWebView {
    // Do any additional setup after loading the view.
    
    //    [self.dataObject drawInRect:CGRectMake(10, 10, 300, 548) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    [self addBackButton];
    
    
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //    [webView loadHTMLString:self.dataObject baseURL:nil];
    //    [self.view addSubview:webView];
    //    [self addToobbar];
    //    [self addNavigationBar];
    //    [webView becomeFirstResponder];
    //
    //    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGestureRecongnizer)];
    //    [self.view addGestureRecognizer:tapGestureRecongnizer];
    //    tapGestureRecongnizer.delegate = self;
    //    tapGestureRecongnizer.cancelsTouchesInView = NO;
}
 - (void)singleGestureRecongnizer {
 if (_isClick) {
 _isClick = NO;
 self.toolbar.hidden = NO;
 self.backView.hidden = NO;
 }else {
 _isClick = YES;
 self.toolbar.hidden = YES;
 self.backView.hidden = YES;
 }
 }
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)addNavigationBar {
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.backView.hidden = YES;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, 5, 55, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_red"] forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview: backButton];
    [self.view addSubview:self.backView];
    [self.view bringSubviewToFront:self.backView];
}

- (void)goback {
    [self dismissViewControllerAnimated:YES completion:nil];
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
