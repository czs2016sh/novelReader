//
//  ReadingViewController.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingViewController : UIViewController<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) id dataObject;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *backView;

@end
