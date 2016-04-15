//
//  MeViewController.m
//  novelReader
//
//  Created by sq-ios53 on 16/4/6.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "MeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MeViewController ()

@end

@implementation MeViewController{
    NSString *_headSculptureUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addRightButton];
    self.userName.text = @"吃货的世界你不懂";
    self.personalitySignature.text = @"请不要和我分享我的零食，谢谢！！！";
    CGRect textRect = [self.personalitySignature.text boundingRectWithSize:CGSizeMake(182, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    self.personalitySignature.frame = CGRectMake(106, 49, 182, textRect.size.height);
//    设置头像
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _headSculptureUrl = [userDefaults stringForKey:@"headSculptureUrl"];
    if (nil != _headSculptureUrl) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVFile *file = [AVFile fileWithURL: _headSculptureUrl];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (error) {
                    NSLog(@"error :%@",error.localizedDescription);
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headImageView.image = [UIImage imageWithData:data];
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(23, 73, 70, 70)];
                        imgView.image = [UIImage imageNamed:@"skin_vip_icon"];
                        imgView.layer.cornerRadius = 70/2;
                        imgView.layer.masksToBounds = YES;
                        [self.view addSubview:imgView];
                    });
                }
            } progressBlock:^(NSInteger percentDone) {
                
            }];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - add left button
- (void)addRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"返回" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rightButtonItem;
    [rightButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.duration = 0.6;
    transition.subtype = kCATransitionFromLeft;
    transition.fillMode = kCAFillModeBoth;
    transition.removedOnCompletion = YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [CATransaction commit];
}

#pragma mark - Table view data source/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - imagePicker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *midiaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image;
    if ([midiaType isEqualToString:(NSString *)kUTTypeImage]) {
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            self.headImageView.layer.cornerRadius = 80/2;
            self.headImageView.image = image;
        }else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            self.headImageView.layer.cornerRadius = 100/2;
            self.headImageView.image = image;
        }
    }
//    [self.tableView reloadData];
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    AVFile *file = [AVFile fileWithData:imgData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"error :%@",error.localizedDescription);
            }else {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:file.url forKey:@"headSculptureUrl"];
            }
        } progressBlock:^(NSInteger percentDone) {
        }];
    });
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
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
