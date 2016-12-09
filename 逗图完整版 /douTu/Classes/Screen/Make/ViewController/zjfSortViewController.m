//
//  HotViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSortViewController.h"
#import "zjfSortCollectionViewCell.h"
#import "zjfSortClassViewController.h"
@interface zjfSortViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong) UIView * HeaderView;
//保存所有的item的数组
@property (nonatomic,strong)NSMutableArray * arrayi;


@end


@implementation zjfSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"模板分类";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _arrayi = [NSMutableArray array];
    
    [self setCollectionView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    [_collectionView registerClass:[zjfSortCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self.view addSubview:_collectionView];
}

//设置Collection的分区
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 5){
        return CGSizeMake((SCREENWIDTH-80)/3, 40);
    }else{
        return CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    }
}


//头的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH, 30);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _arrayi.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return   [_arrayi[section] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfSortCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.formWorkModel = _arrayi[indexPath.section][indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    zjfSortClassViewController * sortClass = [[zjfSortClassViewController alloc]init];
    
    sortClass.formWorkModel = _arrayi[indexPath.section][indexPath.item];
    
    [self.navigationController pushViewController:sortClass animated:YES];
}

- (void)requestData{
    
    NSString * str = @"http://api.jiefu.tv/app2/api/dt/tag/allList.html";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSArray * array = responseObject[@"data"];
        
        for (NSDictionary * dic in array) {
            
            NSArray * arri = dic[@"tagList"];
            
            NSMutableArray * muarr = [NSMutableArray array];
            
            for (NSDictionary * dict in arri) {
                
                zjfformWorkModel * formWork = [[zjfformWorkModel alloc]init];
                [formWork setValuesForKeysWithDictionary:dict];
                
                [muarr addObject:formWork];
            }
            
             [_arrayi addObject:muarr];
        }
            [_collectionView reloadData];
            
        [_collectionView.mj_header endRefreshing];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (UICollectionReusableView * )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.backgroundColor = [UIColor whiteColor];
    
    for (UIView * view in header.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0)
    {
        [header addSubview:_HeaderView];
        
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10,  5, 200, 20)];
        
        HeaderLabel.text = @"脸部表情";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    } else if (indexPath.section == 1)
    {
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, 5, 200, 20)];
        
        HeaderLabel.text = @"形像造型";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    } else if (indexPath.section == 2)
    {
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, 5, 200, 20)];
        
        HeaderLabel.text = @"场景";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    } else if (indexPath.section == 3)
    {
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, 5, 200, 20)];
        
        HeaderLabel.text = @"动态真人";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    } else if (indexPath.section == 4)
    {
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, 5, 200, 20)];
        
        HeaderLabel.text = @"影视娱乐";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    } else
    {
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, 5, 200, 20)];
        
        HeaderLabel.text = @"其他";
        
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        
        [header addSubview:HeaderLabel];
    }
    
    
    return header;
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
