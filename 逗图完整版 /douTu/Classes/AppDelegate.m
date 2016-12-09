//
//  AppDelegate.m
//  douTu
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <UMSocialCore/UMSocialCore.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [UINavigationBar appearance].barTintColor=[UIColor colorWithRed:41/256.0 green:36/256.0 blue:33/256.0 alpha:1];
    
    
    self.window.rootViewController = [[TabBarViewController alloc]init];
    
    
    [self.window makeKeyAndVisible];
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"583e20aaf29d987b460006ba"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx00d15a9c497846eb" appSecret:@"29a155d63fc95630719c3566db3e1a7d" redirectURL:nil];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105725455"  appSecret:nil redirectURL:nil];

    //网络监听
    [self afn];
    
    // Override point for customization after application launch.
    return YES;
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }else{
        NSLog(@"回调成功");
    }
    return result;
}

-(void)afn
{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                //没网提示
                //[SVProgressHUD showErrorWithStatus:@"没有网络"];
                [SVProgressHUD showProgress:INT_MAX status:@"没有网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                [SVProgressHUD showInfoWithStatus:@"使用流量哦"];
                //取消提示
                //[SVProgressHUD dismiss];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                //取消提示
                [SVProgressHUD dismiss];
                break;
            default:
                break;
        }
    }];
    
    [manger startMonitoring];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
