//
//  MyViewController.m
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "MyViewController.h"
#import "GBNMySendViewController.h"
#import "GBNMyMakeViewController.h"
#import "GBNFeedbackViewController.h"
#import "GBNGameViewController.h"
#import "GBNHelpViewController.h"
#import "GBNQQViewController.h"
#import "GBNFeedbackViewController.h"
#import "GBNDisclaimerViewController.h"
#import "GBNTableViewCell.h"
#import <UShareUI/UMSocialUIManager.h>
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * oneImageArray;
@property (nonatomic,strong)NSArray * oneTextArray;
@property (nonatomic,strong)NSArray * twoImageArray;
@property (nonatomic,strong)NSArray * twoTextArray;
@property (nonatomic,strong)NSArray * threeImageArray;
@property (nonatomic,strong)NSArray * threeTextArray;
@property (nonatomic,strong)NSString * imageViewCacheSize;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation MyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getImageCache];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupArray];
    
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor lightGrayColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    //设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    tableView.separatorColor = [UIColor lightGrayColor];
    
    [tableView registerNib:[UINib nibWithNibName:@"GBNTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    // Do any additional setup after loading the view.
}
//得到缓存
- (void)getImageCache{
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    float temp = [cache getSize];
    
    if (temp >= 1024) {
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fM",temp/1024/1024];
    }else{
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fKB",temp/1024];
    }
}


- (void)setupArray{
    _oneImageArray = @[@"fasongde",@"zhizuode"];
    _oneTextArray = @[@"我发送的",@"我制作的"];
    _twoImageArray = @[@"bangzhu",@"qqqun",@"yijian",@"mianze",@"faq",@"yaoqing"];
    _twoTextArray = @[@"使用帮助",@"官方QQ群",@"意见反馈",@"免责声明",@"清除缓存",@"推荐APP给好友"];
    _threeImageArray = @[@"jiefu",@"gifbiaoqing"];
    _threeTextArray = @[@"下载爆笑姐夫",@"下载GIF表情"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _oneImageArray.count;
    }
    if (section == 1) {
        return _twoImageArray.count;
    }
    if (section == 2) {
        return _threeImageArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GBNTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.twoLabel.hidden = YES;
    cell.gameImage.hidden = YES;
    if (indexPath.section == 0) {
        cell.headerImage.image = [UIImage imageNamed:_oneImageArray[indexPath.row]];
        cell.label.text = _oneTextArray[indexPath.row];
        if ([cell.label.text isEqualToString:@"游戏大厅"]) {
            cell.gameImage.hidden = NO;
            cell.gameImage.image = [UIImage imageNamed:@"chuanqi"];
            cell.label.textColor = [UIColor redColor];
        }
    }else if (indexPath.section == 1){
        cell.headerImage.image = [UIImage imageNamed:_twoImageArray[indexPath.row]];
        cell.label.text = _twoTextArray[indexPath.row];
        if ([cell.label.text isEqualToString:@"清除缓存"]) {
            cell.twoLabel.hidden = NO;
            if (_imageViewCacheSize == nil) {
                cell.twoLabel.text = @"0.00";
            }else{
            cell.twoLabel.text = _imageViewCacheSize;
            }
        }
    }else{
        cell.headerImage.image = [UIImage imageNamed:_threeImageArray[indexPath.row]];
        cell.label.text = _threeTextArray[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[GBNMySendViewController alloc]init] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[GBNMyMakeViewController alloc]init] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[GBNHelpViewController alloc]init] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 1){
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[GBNQQViewController alloc]init] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 2){
            [self.navigationController pushViewController:[[GBNFeedbackViewController alloc]init] animated:YES];
        }else if (indexPath.row == 3){
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[GBNDisclaimerViewController alloc]init] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 4){
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"您确认清除缓存图片吗？清除后浏览时需要重新下载已看过的图片" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                GBNTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.twoLabel.text = @"0.00";
                SDImageCache *cache = [SDImageCache sharedImageCache];
                [cache clearDisk];
                UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"✅" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
                [self  showDetailViewController:alert1 sender:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert1 dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [self showDetailViewController:alert sender:nil];
        }else{
            
            __weak typeof(self) weakSelf = self;
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [weakSelf shareTextToPlatformType:platformType];
            }];
            
        }
        
    }else{
        if (indexPath.row == 0) {
            //跳转到AppStore下载爆笑姐夫
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/bao-xiao-jie-fu-zui-gao-xiao/id996788058?mt=8"] options:@{} completionHandler:nil];
            
        }else{
            //跳转到AppStore下载GIF
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/gif-biao-qing-fen-xiang-dong/id1052974859?mt=8"] options:@{} completionHandler:nil];
        }
    }
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    
    UMShareExtendObject * APPUrl = [[UMShareExtendObject alloc]init];
    APPUrl.url = @"https://itunes.apple.com/cn/app/dou-tu-qing-song-zhi-zuogif/id1091452104?mt=8";
    
    messageObject.shareObject = APPUrl;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
