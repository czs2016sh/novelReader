//
//  ClassifyViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/9.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassifyCollectionViewCell.h"

@interface ClassifyViewController ()

@end

@implementation ClassifyViewController

static NSString * const reuseIdentifier = @"Czs";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self arrayAddMembers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup collection view
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width/3 - 10, self.view.bounds.size.width/6);
    self.manCollectionView = [[UICollectionView alloc]initWithFrame:self.manView.bounds collectionViewLayout:flowLayout];
    self.manCollectionView.backgroundColor = [UIColor whiteColor];
    [self.manView addSubview:self.manCollectionView];
    [self.manCollectionView registerNib:[UINib nibWithNibName:@"ClassifyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    self.manCollectionView.delegate = self;
    self.manCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout2.itemSize = CGSizeMake(self.view.bounds.size.width/3 - 10, self.view.bounds.size.width/6);
    self.womanCollectionView = [[UICollectionView alloc] initWithFrame:self.womanView.bounds collectionViewLayout:flowLayout2];
    [self.womanView addSubview:self.womanCollectionView];
    self.womanCollectionView.backgroundColor = [UIColor whiteColor];
    [self.womanCollectionView registerNib:[UINib nibWithNibName:@"ClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.womanCollectionView.delegate = self;
    self.womanCollectionView.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.manCollectionView) {
        return self.manArray.count;
    }else {
        return self.womanArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.manCollectionView) {
        ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (1 == indexPath.item || 8 == indexPath.item) {
            cell.classsifyImageView.image = [UIImage imageNamed:@"bulletscreen_icon_award"];
        }
        cell.classifyNameLabel.text = self.manArray[indexPath.item];
        
        return cell;
    }else {
        ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.classifyNameLabel.text = self.womanArray[indexPath.item];
        
        return cell;
    }
    
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.manCollectionView) {
        NSLog(@"选择了男频：%@",self.manArray[indexPath.item]);

    }else {
        NSLog(@"选择了女频：%@",self.womanArray[indexPath.item]);
    }
}



/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (0 == indexPath.section) {
        cell.classifyNameLabel.text = self.manArray[indexPath.item];
    } else {
        cell.classifyNameLabel.text = self.womanArray[indexPath.item];
    }
 
    return cell;
}
*/

#pragma mark - array add members
- (void)arrayAddMembers {
    self.manArray = @[@"玄幻",@"奇幻",@"武侠",@"仙侠",@"都市",@"校园",@"历史",@"军事",@"科幻"];
    self.womanArray = @[@"现代言情",@"古代言情",@"幻想言情",@"青春校园",@"同人作品",@"推理悬疑",@"恐怖／惊悚"];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
