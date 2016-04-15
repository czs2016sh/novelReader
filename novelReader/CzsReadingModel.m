//
//  CzsReadingModel.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CzsReadingModel.h"

@implementation CzsReadingModel

- (NSArray *)saveInDocument {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (!(self.urlArray = [userDefaults arrayForKey:@"bookImgUrl"])) {
        NSLog(@"kong de");
        return nil;
    }else {
        return self.urlArray;
    }
}

@end
