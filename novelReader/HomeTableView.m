//
//  HomeTableView.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/6.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HomeTableView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CollectionViewCell.h"
#import "ReadingBook.h"

@interface HomeTableView ()<UIScrollViewDelegate>

@end

@implementation HomeTableView{
    NSMutableArray *_imgViewArray;
    NSTimer *_timer;
    NSUInteger _tableViewBookNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollArrayAddMembers];
    [self arrayAddMembers];
    [self setupScrollView];
    [self setupTableView];
    [self setupCollectionView];
    
    int tempNum = arc4random()%6;
    NSArray *array = @[self.firstStarButton,self.secendStarButton,self.thirdStarButton,self.fourthStarButton,self.fifithStarButton];
    for (int i = 0; i<tempNum; i++) {
        UIImage *image = [UIImage imageNamed:@"card_icon_favorite_highlighted"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = array[i];
        [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)collectionArray {
    if (nil == _collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}
- (NSMutableArray *)collectionDataArray {
    if (nil == _collectionDataArray) {
        _collectionDataArray = [NSMutableArray array];
    }
    return _collectionDataArray;
}

#pragma mark - setup cell
- (void)setupScrollView {
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, 128)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strUrl = [_imgViewArray[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:strUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = [UIImage imageWithData:data];
                [self.scrollView addSubview:imgView];
            });
//            NSLog(@"%@",_imgViewArray[i]);
//            AVFile *file = [AVFile fileWithURL:_imgViewArray[i]];
//            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                if (error) {
//                    NSLog(@"error:%@",error.localizedDescription);
//                } else {
//                    NSLog(@"ddd");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imgView.image = [UIImage imageWithData:data];
//                        [self.scrollView addSubview:imgView];
//                    });
//                }
//            } progressBlock:^(NSInteger percentDone) {
//                
//            }];
        });
    }
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*_imgViewArray.count, 128);
    self.scrollView.pagingEnabled = YES;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.pageControl.numberOfPages = _imgViewArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    self.pageControl.center = CGPointMake(280, 180);
    [self.view addSubview:_pageControl];
    self.scrollView.delegate = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollOffset) userInfo:nil repeats:YES];
}
- (void)setupTableView {
    _tableViewBookNum = arc4random()%10;
    NSDictionary *bookDic = self.collectionArray[_tableViewBookNum];
    self.bookNameLable.text = [bookDic valueForKey:@"bookName"];
    self.bookAuthor.text = [bookDic valueForKey:@"bookAuthor"];
    [self.bookAuthor setTextColor:[UIColor lightGrayColor]];
    [self.bookBriefIntroduction setTextColor:[UIColor lightGrayColor]];
    self.bookBriefIntroduction.text = [bookDic valueForKey:@"bookBriefIntroduction"];
    CGRect textRect = [self.bookBriefIntroduction.text boundingRectWithSize:CGSizeMake(208, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.bookBriefIntroduction.frame = CGRectMake(104, 66, 208, textRect.size.height);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVFile *file = [AVFile fileWithURL:[bookDic valueForKey:@"bookImgUrl"]];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.imgView.image = [UIImage imageWithData:data];
            });
        } progressBlock:^(NSInteger percentDone) {
            
        }];
    });
}
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 150);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.viewOfCollection.bounds collectionViewLayout:flowLayout];
    for (int i = 0; i < 6; i++) {
        collectionData *data = [[collectionData alloc] init];
        int index = arc4random()%10;
        NSDictionary *dataDic = self.collectionArray[index];
        data.bookImgUrl = [dataDic valueForKey:@"bookImgUrl"];
        data.bookName = [dataDic valueForKey:@"bookName"];
        [self.collectionDataArray addObject:data];
    }
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.viewOfCollection addSubview:self.collectionView];
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Czs"];
}

#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (self.view.bounds.size.width/2 + self.scrollView.contentOffset.x)/self.view.bounds.size.width;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollOffset) userInfo:nil repeats:YES];
}

#pragma mark - timer target
- (void)changeScrollOffset {
    if (self.scrollView.contentOffset.x <  self.view.bounds.size.width*(_imgViewArray.count -1)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.view.bounds.size.width, 0);
        }];
    }else {
        self.pageControl.currentPage = 0;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - collectionview dataSource/delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.backgroundColor = [UIColor whiteColor];
    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Czs" forIndexPath:indexPath];
    collectionData *data = self.collectionDataArray[indexPath.item];
    [cell initWithData:data];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingBook *readingBook = [[ReadingBook alloc]init];
    [self updateUserDefaults:collectionView indexPath: indexPath];
    
    [self.navigationController pushViewController:readingBook animated:YES];
}

#pragma mark - upload userDefaults

- (void)updateUserDefaults:(UIScrollView *)scrollView indexPath:(NSIndexPath *)indexPath {
    collectionData *data = [[collectionData alloc] init];
    if (scrollView == self.collectionView) {
        data = self.collectionDataArray[indexPath.item];
    }else {
        NSDictionary *tempDic = self.collectionArray[_tableViewBookNum];
        data.bookName = [tempDic valueForKey:@"bookName"];
        data.bookImgUrl = [tempDic valueForKey:@"bookImgUrl"];
    }
    NSDictionary *dic = @{
                          @"name" : data.bookName,
                          @"url" : data.bookImgUrl
                          };
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [userDefaults objectForKey:@"bookImgUrl"];
    BOOL isExist = NO;
    for (NSDictionary *dict in tempArray) {
        NSString *nameStr = [dict valueForKey:@"name"];
        if ([data.bookName isEqualToString:nameStr]) {
            isExist = YES;
        }
    }
    if (!isExist) {
        NSArray *temp = [tempArray arrayByAddingObject:dic];
        [userDefaults removeObjectForKey:@"bookImgUrl"];
        [userDefaults setObject:temp forKey:@"bookImgUrl"];
    }
}


#pragma mark - Table view data source/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        ReadingBook *readingBook = [[ReadingBook alloc]init];
//        UINavigationController *readNav = [[UINavigationController alloc]initWithRootViewController:readingBook];
        [self updateUserDefaults:tableView indexPath:indexPath];
        [self presentViewController:readingBook animated:YES completion:nil];
    }
}


#pragma mark - init array
- (void)scrollArrayAddMembers {
    NSString *url0 = @"http://img.ma16.com/upload/cimg/2015/11-26/XPH0C60635841481550270469.jpg";
    NSString *url1 = @"http://zhuxian.wanmei.com/images/wallpaper131008/222x162/5bb.jpg";
    NSString *url2 = @"http://img.ma16.com/upload/cimg/2015/11-26/XPH0C60635841481550270469.jpg";
    NSString *url3 = @"http://img.ma16.com/upload/cimg/2015/11-26/XPH0C60635841481550270469.jpg";
    _imgViewArray = [NSMutableArray arrayWithObjects:url0, url1, url2, url3, nil];
}

- (void)arrayAddMembers {
    NSDictionary *dic0 = @{
                          @"bookImgUrl" : @"http://images.bookuu.com/book/C/00878/97875462016031636485-fm.jpg",
                          @"bookName" : @"射雕英雄传",
                          @"bookAuthor" : @"金庸",
                          @"bookBriefIntroduction" : @"“为国为民，侠之大者”。一腔正气，命运便会还他以想不到的机缘。一路坎坷，终成一代大侠。"
                              };
    NSDictionary *dic1 = @{
                           @"bookImgUrl" : @"http://a.hiphotos.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=cbb1c5018b5494ee932f074b4c9c8b9b/bd3eb13533fa828b9e71d95dfa1f4134970a5a39.jpg",
                           @"bookName" : @"白马啸西风",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"因情而活、为情而死、情之所在、孽之所在。"
                           };
    NSDictionary *dic2 = @{
                           @"bookImgUrl" : @"http://photocdn.sohu.com/20101029/Img276731285.jpg",
                           @"bookName" : @"鹿鼎记",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"金庸的「封刀」之作，悲剧性的英雄史诗，是金庸为其昔日笔下创造出的无数江湖英雄唱出的一曲无尽挽歌。"
                           };
    NSDictionary *dic3 = @{
                           @"bookImgUrl" : @"http://imgsrc.baidu.com/forum/pic/item/c8ea15ce36d3d5390d0ea5703a87e950352ab056.jpg",
                           @"bookName" : @"笑傲江湖",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"“笑傲江湖”源自《西游记》中的一句词。折射政治斗争，同时也表露对斗争的哀叹。"
                           };
    NSDictionary *dic4 = @{
                           @"bookImgUrl" : @"http://img32.mtime.cn/up/2012/06/18/133924.18311629_o.jpg",
                           @"bookName" : @"书剑恩仇录",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"小说将历史与传奇融为一体、虚实相间，史笔与诗情相结合，绘出了一幅波澜壮阔的历史画卷。"
                           };
    NSDictionary *dic5 = @{
                           @"bookImgUrl" : @"http://imgsrc.baidu.com/baike/pic/item/7e3e6709c93d70cffa7a637dfadcd100baa12b3a.jpg",
                           @"bookName" : @"神雕侠侣",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"“射雕三部曲”系列第二部，上承《射雕英雄传》，下接《倚天屠龙记》。金庸武侠小说创作上的里程碑。"
                           };
    NSDictionary *dic6 = @{
                           @"bookImgUrl" : @"http://a.hiphotos.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=4b4a40f2f703918fc3dc359830544df2/f7246b600c338744c395386e510fd9f9d72aa04b.jpg",
                           @"bookName" : @"侠客行",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"大巧反成大拙，大愚才是大智。石破天用他离奇的经历讲述了一个“吃亏是福”的道理。"
                           };
    NSDictionary *dic7 = @{
                           @"bookImgUrl" : @"http://shopimg.kongfz.com/20080303/4064/1204504766_1_b.jpg",
                           @"bookName" : @"倚天屠龙记",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"元末群雄纷起、江湖动荡，倚天剑和屠龙刀更掀起了江湖的腥风血雨。"
                           };
    NSDictionary *dic8 = @{
                           @"bookImgUrl" : @"http://www.hinews.cn/pic/0/11/06/14/11061438_975359.jpg",
                           @"bookName" : @"碧血剑",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"本书讲的是明末抗清将领袁崇焕之子袁承志及“金蛇郎君”夏雪宜的故事。"
                           };
    NSDictionary *dic9 = @{
                           @"bookImgUrl" : @"http://imgsrc.baidu.com/baike/abpic/item/dc54564e9258d10986fdec1ad158ccbf6c814d7f.jpg",
                           @"bookName" : @"鸳鸯刀",
                           @"bookAuthor" : @"金庸",
                           @"bookBriefIntroduction" : @"小说叙述江湖上盛传的鸳鸯宝刀的秘密以及围绕它发生的故事。"
                           };
    for (int i = 0; i < 10; i++) {
        [self.collectionArray addObject: dic0];
        [self.collectionArray addObject: dic1];
        [self.collectionArray addObject: dic2];
        [self.collectionArray addObject: dic3];
        [self.collectionArray addObject: dic4];
        [self.collectionArray addObject: dic5];
        [self.collectionArray addObject: dic6];
        [self.collectionArray addObject: dic7];
        [self.collectionArray addObject: dic8];
        [self.collectionArray addObject: dic9];
    }
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Czs" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
