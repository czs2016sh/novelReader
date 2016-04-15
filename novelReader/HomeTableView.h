//
//  HomeTableView.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/6.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef blockType(^reloadShelfItemBlock)(BOOL reload);
//typedef void(^blockType)(BOOL reload);

@interface HomeTableView : UITableViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLable;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookBriefIntroduction;
@property (weak, nonatomic) IBOutlet UIView *viewOfCollection;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *collectionArray;
@property (strong, nonatomic) NSMutableArray *collectionDataArray;
@property (weak, nonatomic) IBOutlet UIButton *firstStarButton;
@property (weak, nonatomic) IBOutlet UIButton *secendStarButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fifithStarButton;

//@property (strong, nonatomic) blockType reloadShelfItemBlock;

@end
