//
//  zjfHelpViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfHelpViewController.h"

@interface zjfHelpViewController ()

@end

@implementation zjfHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    UIWebView * webView = [[UIWebView alloc]initWithFrame:SCREENRECT];
    
    NSURL * url = [NSURL URLWithString:@"http://bq.jiefu.tv/views/dt/help/index.html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
