//
//  PersonViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfPersonViewController.h"
#import "zjfPersonCollectionViewCell.h"
#import "zjfPersonDetailController.h"
#import "zjfPersonDetailController.h"
@interface zjfPersonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation zjfPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    self.navigationItem.title = @"动态真人";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    _dataArray = [NSMutableArray array];
    
    [self requestDatata];
    
    // Do any additional setup after loading the view.
}



- (void)requestDatata{
    NSString * str = @"http://api.jiefu.tv/app2/api/dt/tag/getByType.html?typeId=6";
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        [_collectionView reloadData];
        for (NSDictionary * dic in responseObject[@"data"]) {
            zjfPersonModel * personModel = [[zjfPersonModel alloc]init];
            [personModel setValuesForKeysWithDictionary:dic];
            [muarr addObject:personModel];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:muarr];
            [_collectionView reloadData];
        });
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"++++%@+++",error);
    }];
    
}


- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[zjfPersonCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfPersonCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.personModel = _dataArray[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    zjfPersonDetailController * personDetail = [[zjfPersonDetailController alloc]init];
    
    personDetail.personModel = _dataArray[indexPath.item];
    
    [self.navigationController pushViewController:personDetail animated:YES];
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
