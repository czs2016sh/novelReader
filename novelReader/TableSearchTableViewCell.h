//
//  TableSearchTableViewCell.h
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSearchModel.h"

@interface TableSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *updataTime;
@property (weak, nonatomic) IBOutlet UILabel *chapterOfNew;

- (void)initWithModel:(TableSearchModel *)model;

@end
