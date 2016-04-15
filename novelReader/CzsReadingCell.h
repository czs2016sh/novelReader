//
//  CzsReadingCell.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CzsReadingModel.h"

@interface CzsReadingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
//@property (strong, nonatomic) CzsReadingModel *model;

- (void)initWithModel:(CzsReadingModel *)model;

@end
