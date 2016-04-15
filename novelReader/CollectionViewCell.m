//
//  CollectionViewCell.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CollectionViewCell.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)initWithData:(collectionData *)data {
    self.bookNameLabel.text = data.bookName;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVFile *file = [AVFile fileWithURL:data.bookImgUrl];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error.localizedDescription);
            }else {
                self.bookImgView.image = [UIImage imageWithData:data];
            }
        } progressBlock:^(NSInteger percentDone) {
            
        }];
    });
}

@end
