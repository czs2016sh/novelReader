//
//  TabBarController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "TabBarController.h"
#import "HomeTableView.h"
#import "NavigationController.h"
#import "ClassifyViewController.h"
#import "RankingListViewController.h"
#import "SearchViewController.h"
#import "CzsReadingNovel.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAllChildVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAllChildVC {
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    HomeTableView *homeViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"Czs"];
    [self setupChildViewController:homeViewController title:@"首页" imageName:@"app_main_more_style_wood" selectedImageName:@"app_main_more_style_wood_hl"];
    
    UIStoryboard *classifyStroryboard = [UIStoryboard storyboardWithName:@"ClassifyStoryboard" bundle:nil];
    ClassifyViewController *classifyViewController = [classifyStroryboard instantiateViewControllerWithIdentifier:@"Czs"];
    [self setupChildViewController:classifyViewController title:@"分类" imageName:@"app_main_more_lib" selectedImageName:@"app_main_more_lib_hl"];
    
    UIStoryboard *rankingListStoryboard = [UIStoryboard storyboardWithName:@"RandingListStoryboard" bundle:[NSBundle mainBundle]];
    RankingListViewController *rankingListViewController = [rankingListStoryboard instantiateViewControllerWithIdentifier:@"Czs"];
    [self setupChildViewController:rankingListViewController title:@"排行榜" imageName:@"rank_xiangkanbang" selectedImageName:@"rank_xiangkanbang"];
    
}


- (void)setupChildViewController:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{

    viewController.tabBarItem.title = title;
//    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];

    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:nav];
    [self addSearchButton];
}

- (void)addSearchButton {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"app_tr_cfg_search"] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    [button addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickSearchButton {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
//    [self presentViewController:searchViewController animated:YES completion:nil];
}






@end
