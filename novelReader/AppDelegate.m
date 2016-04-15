//
//  AppDelegate.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/5.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "ReadingBook.h"
#import "TabBarController.h"
#import "MeViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SearchViewController.h"
#import "HomeTableView.h"
#import "TableSearchViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define LENGTH_WIDTH_CEOFFICIENT 1.43

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [NSThread sleepForTimeInterval:1];
    
    [AVOSCloud setApplicationId:@"66cJkLLbxqPFJ4xc7Cq5kIlY-gzGzoHsz" clientKey:@"N0hIEGr5zGI4Xoup6QcoHiu6"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    NSString *textFileUrl = [userDefaults objectForKey:@"fileText"];
    if (nil == textFileUrl) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVFile *file = [AVFile fileWithName:@"ynj.txt" contentsAtPath:@"/Users/sq-ios53/Downloads/ynj.txt"];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"upload error rason:%@",error.localizedDescription);
                }else {
                    [userDefaults setValue:file.url forKey:@"fileText"];
                }
            } progressBlock:^(NSInteger percentDone) {
                
            }];
        });
    }
//    1.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    2.
    [self.window makeKeyAndVisible];
//    3.
    UICollectionViewLayout *viewLayout = [[UICollectionViewLayout alloc]init];
    self.readingNovelVC = [[CzsReadingNovel alloc]initWithCollectionViewLayout:viewLayout];
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:self.readingNovelVC];
    UIImage *backgroundImage = [UIImage imageNamed:@"BookShelfCell"];
    self.readingNovelVC.collectionView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.readingNovelVC.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bookstore_op_btn_hl"]];
    UIButton *rightFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightFirstButton.frame = CGRectMake(0, 0, 48, 30);
    [rightFirstButton setTitle:@"书城" forState:UIControlStateNormal];
    [rightFirstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightFirstButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
    [rightFirstButton setImage:[UIImage imageNamed:@"app_file_arrow"] forState:UIControlStateNormal];
    [rightFirstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    [rightFirstButton addTarget:self
                         action:@selector(intoBookCityButtonClick)
               forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightSecendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSecendButton.frame = CGRectMake(0, 0, 35 ,35);
    [rightSecendButton setImage:[UIImage imageNamed:@"app_tr_cfg_search"] forState:UIControlStateNormal];
    [rightSecendButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightFirstButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightFirstButton];
    UIBarButtonItem *rightSecendButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightSecendButton];
    NSArray *array = [NSArray arrayWithObjects:rightFirstButtonItem, rightSecendButtonItem, nil];
    
    self.readingNovelVC.navigationItem.rightBarButtonItems = array;
    
    UIButton *leftFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftFirstButton.frame = CGRectMake(0, 0, 25, 30);
    leftFirstButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    [leftFirstButton setTitle:@"SS" forState:UIControlStateNormal];
    UIBarButtonItem *leftFirstButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftFirstButton];
    UIButton *leftSecendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftSecendButton.frame = CGRectMake(0, 0, 35, 35);
    [leftSecendButton setImage:[UIImage imageNamed:@"app_main_more_style_list"] forState:UIControlStateNormal];
    [leftSecendButton addTarget:self
                         action:@selector(intoPersonalButtonClick)
               forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftSecendButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftSecendButton];
    array = [NSArray arrayWithObjects:leftSecendButtonItem, leftFirstButtonItem, nil];
    self.readingNovelVC.navigationItem.leftBarButtonItems = array;
    
    self.window.rootViewController = navigation;
    
    return YES;
}

- (void)clickSearchButton {
    TableSearchViewController *tableSearchVC = [[TableSearchViewController alloc] init];
    
    [self.readingNovelVC.navigationController pushViewController:tableSearchVC animated:YES];
}

- (void)intoBookCityButtonClick {
    TabBarController *tabBarController = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:[NSBundle mainBundle]];
    [self.readingNovelVC.navigationController pushViewController:tabBarController animated:YES];
//    [self.readingNovelVC presentViewController:tabBarController animated:YES completion:nil];

}


- (void)intoPersonalButtonClick {
//    这里没有设置代理，有固定的代理方法
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"MeStoryboard" bundle:[NSBundle mainBundle]];
    MeViewController *meViewController = [meStoryboard instantiateViewControllerWithIdentifier:@"Czs"];
    UINavigationController *meNavigationController = [[UINavigationController alloc]initWithRootViewController:meViewController];
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = @"suckEffect";
    transition.subtype = kCATransitionFromRight;
    transition.duration=0.5f;
    transition.fillMode=kCAFillModeRemoved;
    transition.removedOnCompletion = YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
//    [self.readingNovelVC.navigationController pushViewController:meViewController animated:NO];
    [self.readingNovelVC presentViewController:meNavigationController animated:NO completion:nil];
    [CATransaction commit];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"dddd");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
