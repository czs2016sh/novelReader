//
//  CzsReadingCell.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CzsReadingCell.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation CzsReadingCell{
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)initWithModel:(CzsReadingModel *)model{
    AVFile *file = [AVFile fileWithURL:model.fileUrl];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"secend_error:%@",error.localizedDescription);
            }else {
                NSLog(@"chenggong");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.bookImage.image = [UIImage imageWithData:data];
                });
            }
        } progressBlock:^(NSInteger percentDone) {
            NSLog(@"percentDone:%d",percentDone);
            if (100 == percentDone) {
                
            }
        }];
        
    });
}


@end
