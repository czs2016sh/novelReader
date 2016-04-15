//
//  CzsReadingNovel.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CzsReadingNovel.h"
#import "CzsReadingCell.h"
#import "ReadingBook.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CzsReadingModel.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define LENGTH_WIDTH_CEOFFICIENT 1.43

@interface CzsReadingNovel ()

@end

@implementation CzsReadingNovel{
}

static NSString * const reuseIdentifier = @"Czs";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/4, LENGTH_WIDTH_CEOFFICIENT*SCREEN_WIDTH/4);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.bookImageUrlArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"bookImgUrl"]];
//    NSLog(@"bookImgUrlArray count:%d",self.bookImageUrlArray.count);
//    [self urlArrayAddMembers];
//    [self reloadCollectionViewItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    self.bookImageUrlArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"bookImgUrl"]];
    [self reloadCollectionViewItem];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.bookImageUrlArray.count - 1) inSection:0];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(NSMutableArray *)bookImageArray {
    if (nil == _bookImageArray) {
        _bookImageArray = [NSMutableArray array];
    }
    return _bookImageArray;
}
- (NSMutableArray *)bookImageUrlArray {
    if (nil == _bookImageUrlArray) {
        _bookImageUrlArray = [NSMutableArray array];
    }
    return _bookImageUrlArray;
}

- (void)reloadCollectionViewItem {
    self.bookImageArray = [NSMutableArray array];
    for (int i = 0; i < self.bookImageUrlArray.count; i++) {
        CzsReadingModel *model = [[CzsReadingModel alloc] init];
        model.fileUrl = [self.bookImageUrlArray[i] valueForKey:@"url"];
        [self.bookImageArray addObject:model];
//        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:i];
//        NSLog(@"%d",indexPath.item);
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        [self.collectionView reloadData];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        });
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"CzsReadingCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bookImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CzsReadingCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell initWithModel:self.bookImageArray[indexPath.item]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH/4, LENGTH_WIDTH_CEOFFICIENT*SCREEN_WIDTH/4-10);
//    return CGSizeMake(80, 105);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingBook *readingBook = [[ReadingBook alloc]init];
    readingBook.bookTag = indexPath.item;
    
    [self presentViewController:readingBook animated:YES completion:nil];
    return YES;
}

#pragma mark - url array add member
- (void) urlArrayAddMembers {
    NSDictionary *dic1 = @{
                           @"name" : @"飞狐外传",
                           @"url" :@"http://c.hiphotos.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=3a6854cb033b5bb5aada28ac57babe5c/b3b7d0a20cf431add9b316594b36acaf2edd9868.jpg"
                           };
    NSDictionary *dic2 = @{
                           @"name" : @"雪山飞狐",
                           @"url" : @"http://g.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=14ead321918fa0ec6bca6c5f47fe328b/2cf5e0fe9925bc312a5a108a5edf8db1cb137098.jpg"
                           };
    NSDictionary *dic3 = @{
                           @"name" : @"连城诀",
                           @"url"  : @"http://c.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=e019e39e572c11dfcadcb771024e09b5/ae51f3deb48f8c54162ee1523a292df5e1fe7fc9.jpg"
                           };
    NSDictionary *dic4 = @{
                           @"name" : @"天龙八部",
                           @"url" : @"http://b.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=027ca81f3b12b31bd361c57be7715d1f/0df431adcbef76093ac7adc72cdda3cc7dd99e9d.jpg"
                           };
    [self.bookImageUrlArray addObject:dic1];
    [self.bookImageUrlArray addObject:dic2];
    [self.bookImageUrlArray addObject:dic3];
    [self.bookImageUrlArray addObject:dic4];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.bookImageUrlArray forKey:@"bookImgUrl"];
}

#pragma mark - 不用了
- (void) uploadData {
    for (int i = 0; i < self.bookImageUrlArray.count; i++) {
        NSString *bookName = [self.bookImageUrlArray[i] valueForKey:@"name"];
        NSString *bookUrl = [self.bookImageUrlArray[i] valueForKey:@"url"];
        [self createData:bookName url:bookUrl];
    }
}

#pragma mark - create leanCloud data
- (void)createData:(NSString *)class url:(NSString *)bookUrl {
    AVFile *file =[AVFile fileWithURL:bookUrl];
    //    将网络资源放倒本地
    [file getData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"first_error:%@",error.localizedDescription);
        }else {
            NSLog(@"上传成功");
            NSLog(@"file_url:%@",file.url);
            CzsReadingModel *model = [[CzsReadingModel alloc]init];
            model.fileUrl = file.url;
            [self.bookImageArray addObject:model];
            if (4 == self.bookImageArray.count) {
                [self.collectionView reloadData];
            }
        }
    } progressBlock:^(NSInteger percentDone)
     {
         NSLog(@"jin_du(0~100):%d",percentDone);
         
     }];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
