//
//  CollectionViewCell.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionData.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImgView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

- (void)initWithData:(collectionData *)data;

@end
