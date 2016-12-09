//
//  zjfSortClassViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSortClassViewController.h"
#import "zjfSortClassCollectionViewCell.h"
#import "zjfMakeDetailViewController.h"
@interface zjfSortClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,assign)int pageNum;


@end

@implementation zjfSortClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _pageNum = 0;
    
    self.title = self.formWorkModel.name;
    [self setCollectionView];
    [self requestDatata];
    [self shuaxin];
    
    // Do any additional setup after loading the view.
}

- (void)shuaxin{
    // 下拉刷新
    WEAKSELF;
    _collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestDatata];
        // 结束刷新
        [_collectionView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestMoreData];
        // 结束刷新
        [_collectionView.mj_footer endRefreshing];
        
    }];
    
}
- (void)requestMoreData{
    _pageNum ++;
    [self requestDatata];
}

- (void)requestDatata{
    NSString * str = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getByTag.html?tagId=%@&pageNum=%d&pageSize=48",self.formWorkModel.id,_pageNum];
    //NSString * str1 = @"http://api.jiefu.tv/app2/api/dt/item/getByTag.html?tagId=5&pageNum=1&pageSize=48";
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@",responseObject[@"data"]);
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"data"]){
            
            zjfSortModel * mamodel = [[zjfSortModel alloc]init];
            [mamodel setValuesForKeysWithDictionary:dic];
            [muarr addObject:mamodel];
        }
        if(responseObject[@"data"] == nil){
            [SVProgressHUD showWithStatus:@"没有更多"];
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
    
    [_collectionView registerClass:[zjfSortClassCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}


#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
    //return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfSortClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    zjfSortModel * sortModel = _dataArray[indexPath.item];

    cell.sortModel = sortModel;
    if ([sortModel.gifPath hasSuffix:@"gif"]) {
        cell.gifImageView.hidden = NO;
    }else{
        cell.gifImageView.hidden = YES;
    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    zjfMakeDetailViewController * makeDetail = [[zjfMakeDetailViewController alloc]init];
    
    makeDetail.sortModel  = _dataArray[indexPath.item];
    [self.navigationController pushViewController:makeDetail animated:YES];

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
