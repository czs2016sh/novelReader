//
//  ClassifyViewController.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/9.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyViewController : UITableViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSArray *manArray;
@property (nonatomic, copy) NSArray *womanArray;

@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UIView *womanView;

@property (strong, nonatomic) UICollectionView *manCollectionView;
@property (strong, nonatomic) UICollectionView *womanCollectionView;

@end
