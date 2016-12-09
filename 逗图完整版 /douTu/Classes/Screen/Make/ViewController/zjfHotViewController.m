//
//  HotViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfHotViewController.h"
#import "zjfHotCollectionViewCell.h"
#import "zjfMakeDetailViewController.h"
@interface zjfHotViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * hotArray;

@property (nonatomic,assign) int pageNum;
@end

@implementation zjfHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    self.navigationItem.title = @"热门模块";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    _hotArray = [NSMutableArray array];
    _pageNum = 0;
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
    NSString * str = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/hotList.html?pageNum=%d&pageSize=48",_pageNum];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"data"]) {
            
            zjfHotModel * mamodel = [[zjfHotModel alloc]init];
            [mamodel setValuesForKeysWithDictionary:dic];
            [muarr addObject:mamodel];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hotArray addObjectsFromArray:muarr];
            [_collectionView reloadData];
            //NSLog(@"%@",_hotArray);
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
    
    [_collectionView registerClass:[zjfHotCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfHotCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    zjfHotModel * hotModel = _hotArray[indexPath.item];
    
    cell.hotModel = hotModel;
    
    if ([hotModel.gifPath hasSuffix:@"gif"]) {
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
    
    makeDetail.hotModel =_hotArray[indexPath.item];
    
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
