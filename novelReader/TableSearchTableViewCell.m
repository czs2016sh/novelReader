//
//  TableSearchTableViewCell.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "TableSearchTableViewCell.h"

@implementation TableSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithModel:(TableSearchModel *)model {
    self.bookName.text = model.bookName;
    self.bookAuthor.text = model.bookAuthor;
    self.chapterOfNew.text = model.chapterOfNew;
    self.updataTime.text = model.updataTime;
}

//- (NSString *)formatDate:(NSString *)newChapter {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"EEE-MMM-dd HH:mm:ss ZZZ yyyy";
//    NSDate *updataTime = [dateFormatter dateFromString:newChapter];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//    return [dateFormatter stringFromDate:updataTime];
//}





@end
