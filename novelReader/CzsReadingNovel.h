//
//  CzsReadingNovel.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CzsReadingNovel : UICollectionViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *bookImageArray;
@property (nonatomic, strong) NSMutableArray *bookImageUrlArray;


@end
