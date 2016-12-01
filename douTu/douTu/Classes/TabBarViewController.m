//
//  TabBarViewController.m
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "TabBarViewController.h"
#import "MakeViewController.h"
#import "MyViewController.h"
#import "SquareViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self childView];
    
    // Do any additional setup after loading the view.
}
- (void)childView
{
    SquareViewController * square = [[SquareViewController alloc]init];
    
    square.navigationItem.title = @"广场";
    
    [self addchildVC:square image:[UIImage imageNamed:@"guangchang"]selectImage:[UIImage imageNamed:@"guangchanglv"] edg:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    
    UIImage *xrImage = [UIImage imageNamed:@"zhizuohui"];
    xrImage = [xrImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage * lvimage = [UIImage imageNamed:@"zhizuo"];
    lvimage = [lvimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    MakeViewController * make = [[MakeViewController alloc]init];
    
    make.navigationItem.title = @"制图";
    
    [self addchildVC:make image:xrImage selectImage:lvimage edg:UIEdgeInsetsMake(2, 0, -2, 0)];
    
    MyViewController * my = [[MyViewController alloc]init];
    my.navigationItem.title = @"我的";
    
    [self addchildVC:my image:[UIImage imageNamed:@"wode"]selectImage:[UIImage imageNamed:@"wodelv"] edg:UIEdgeInsetsMake(5, 0, -5, 0)];
    self.tabBar.tintColor = [UIColor greenColor];
}
- (void)addchildVC:(UIViewController *)childVC image:(UIImage *)image selectImage:(UIImage *)selectImage edg:(UIEdgeInsets)edg{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barStyle = UIBarStyleBlackOpaque;
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:childVC];
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = selectImage;
    nav.tabBarItem.imageInsets = edg;
    nav.tabBarController.tabBar.tintColor = [UIColor greenColor];
    [self addChildViewController:nav];
    
    
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
