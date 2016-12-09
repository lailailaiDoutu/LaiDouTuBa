//
//  GBNFeedbackViewController.m
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "GBNFeedbackViewController.h"

@interface GBNFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UITextField * textField;
@end

@implementation GBNFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [self setupNavigation];
    
    [self setupSubViews];
    
    // Do any additional setup after loading the view.
}
- (void)setupNavigation{
    self.navigationItem.title = @"意见反馈";
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit:)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)setupSubViews{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 + 64, 75, 30)];
    
    label.text = @"联系方式:";
    
    [self.view addSubview:label];
    
    
    UITextField * textField = [[UITextField alloc]init];
    
    textField.placeholder = @" 微信号/QQ号/手机号/邮箱";
    
    textField.layer.borderWidth = 0.8;
    
    textField.layer.cornerRadius = 5;
    
    textField.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.delegate = self;
    
    textField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:textField];
    self.textField = textField;
    
    
    UITextView * textView = [[UITextView alloc]init];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:textView];
    self.textView = textView;
    
    UILabel * textViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 2, 200, 30)];
    
    textViewLabel.text = @"请输入您的意见或建议";
    
    textViewLabel.enabled = NO;
    
    [textView addSubview:textViewLabel];
    self.textLabel = textViewLabel;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.right).offset(10);
        make.right.equalTo(-10);
        make.top.equalTo(label);
        make.height.equalTo(label);
    }];
    
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(textField.bottom).offset(30);
        make.height.equalTo(150);
    }];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(textView.bottom).offset(10);
        make.width.equalTo(200);
        make.height.equalTo(40);
    }];

}

- (void)commit:(UIButton *)button{
    if (self.textView.text.length == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"❎" message:@"您还没有输入意见或建议" preferredStyle:UIAlertControllerStyleAlert];
        [self showDetailViewController:alert sender:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }else{
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"contactType"] = @"-1";
        dic[@"content"] = self.textView.text;
        dic[@"type"] = @"2";
        
        [manager GET:@"http://api.jiefu.tv/app2/api/suggest/save.html" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",task.currentRequest.URL);
            
            if ([responseObject[@"message"] isEqualToString:@"成功"]) {
                [self.navigationController popViewControllerAnimated:YES];
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"非常感谢" message:@"感谢您提供的意见或建议，我们会认真解读" preferredStyle:UIAlertControllerStyleAlert];
                [self showDetailViewController:alert sender:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissViewControllerAnimated:YES completion:nil];
                });
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"意见或建议上传错误" message:@"请重新上传" preferredStyle:UIAlertControllerStyleAlert];
                [self showDetailViewController:alert sender:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.textLabel.hidden = NO;
    }else{
        self.textLabel.hidden = YES;
    }
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
