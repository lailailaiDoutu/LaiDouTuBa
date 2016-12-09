//
//  GBNMySendViewController.m
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "GBNMySendViewController.h"
#import "zjfMySendCollectionViewCell.h"
#import <UShareUI/UMSocialUIManager.h>
@interface GBNMySendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray * sendMuarr;

@property (nonatomic,strong)UIImage * cachoimage;

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)UIImage * selectedImage;
@end

@implementation GBNMySendViewController
-(void)viewWillAppear:(BOOL)animated{
    _sendMuarr = [NSMutableArray array];
    [_collectionView reloadData];
    
    [self selectDataBase];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"shanchuitem"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(deleteItem1) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    //如果为空 right 隐藏
    if (_sendMuarr.firstObject == nil) {
        button.hidden = YES;
    }else{
        button.hidden = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我发送的";
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(SCREENWIDTH/5, SCREENWIDTH/5);
    
    UICollectionView * collection = [[UICollectionView alloc]initWithFrame:SCREENRECT collectionViewLayout:flowLayout];
    _collectionView = collection;
    
    collection.delegate = self;
    collection.dataSource = self;
    
    [collection registerClass:[zjfMySendCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    collection.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    
    [self.view addSubview:collection];

   
    

    // Do any additional setup after loading the view.
}
//删除数据
- (void)deleteItem1{
    
    UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"确定要删除表情" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * sql = @"delete from Send";
        
        char * error = NULL;
        
        
        int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &error);
        
        if(result == SQLITE_OK){
            
            NSLog(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            NSLog(@"删除失败%s",error);
        }
        
    }];
    [alertCon addAction:action];
    [alertCon addAction:action1];
    [self showDetailViewController:alertCon sender:nil];
    
    
    
}

//设置距上下左右的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _sendMuarr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    zjfMySendCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10.0f;
    
    
    cell.itemBackImageView.image = _sendMuarr[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
    self.selectedImage = _sendMuarr[indexPath.item];
    
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    
//    UIImage * baseImage = _douTuImage.image;
//    
//    UIImage * resultImage = [baseImage imageWaterMarkWithString:_textView.text point:CGPointMake(_viewsBack.frame.origin.x + 10,_viewsBack.frame.origin.y) attribute:@{NSForegroundColorAttributeName:_textColor,NSFontAttributeName:[UIFont fontWithName:_textFont size:30]}];
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject * object = [[UMShareImageObject alloc]init];
    
    object.shareImage = self.selectedImage;
    
    messageObject.shareObject = object;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)selectDataBase{
    //打开或者创建数据库路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"dataBase.sqlite"];
    
    int result = sqlite3_open(path.UTF8String, &db);
    if(result == SQLITE_OK){
        NSLog(@"数据库打开成功");
    }else{
        
        NSLog(@"数据库打开失败");
    }
    
    
    NSString * sql = @"SELECT * from Send";
    
    //陈述
    sqlite3_stmt * stmt;
    //查询前的准备工作(预处理) -1 自动计算
    int results = sqlite3_prepare_v2(db, sql.UTF8String, -1,&stmt, NULL);
    
    char * error = NULL;
    if(results == SQLITE_OK){
        NSLog(@"准备成功");
        //每一次step就是一行
        while (sqlite3_step(stmt) == SQLITE_ROW){
            //第1个字段
            const unsigned char * pic = sqlite3_column_text(stmt, 0);
            
            //转成NSString的字符串解决乱码
            NSString * picstr = [NSString stringWithUTF8String:(const char *)pic];
            
            //NSLog(@"%@",picstr);
            _cachoimage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:picstr];
            if (_cachoimage != nil) {
                [_sendMuarr addObject:_cachoimage];
            }else{
                NSLog(@"未发送过表情");
            }
        }
        NSLog(@"%@",_sendMuarr);
    }else{
        
        NSLog(@"准备失败%s",error);
    }
    
    //释放stmt(完成)
    sqlite3_finalize(stmt);
    

    
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
