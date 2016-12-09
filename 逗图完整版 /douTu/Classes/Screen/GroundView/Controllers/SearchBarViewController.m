//
//  SearchBarViewController.m
//  GroupProject
//
//  Created by  张泽军 on 2016/12/5.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "SearchViewController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"

#import "NameArrayCollectionViewCell.h"
#import "SearchBarViewController.h"
#import "cellLabel.h"
#import "SearchCellViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UISearchBar * searchBar;

@property (nonatomic,strong) UIButton * doneButton;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView * HeaderView;

@property (nonatomic,strong) UIColor * tintColor;

@property (nonatomic,strong) UICollectionView * CollectionView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int pageNum;

@end

static NSString * const cellResueIdentifier = @"collect";

static NSString * const headerResueIdentifier = @"header";

static NSString * const footerResueIdengtifier = @"footer";

@implementation SearchViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LeftButtton];
    
    [self HeaderTop];
    
    [self collectionView];
    
    [self requestdata];
    
    [self Refresh];

    _dataArray = [NSMutableArray array];
    
}

//设置区头实现
- (void)HeaderTop
{
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.5) ];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    _searchBar.backgroundColor = [UIColor grayColor];
    [_searchBar setPlaceholder:@"搜索表情"];
    [_searchBar setBarStyle:UIBarStyleDefault];
    [_searchBar setBarTintColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    [_searchBar setTranslucent:YES];
    [_searchBar setSearchResultsButtonSelected:NO];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    self.searchBar.delegate = self;
    
    [header addSubview:_searchBar];
    
    [self.view addSubview:header];
    
    self.HeaderView = header;
}

- (void)Refresh
{
    //下拉刷新
    _CollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdata];
    }];
    
    [_CollectionView.mj_header beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _CollectionView.mj_header.automaticallyChangeAlpha = YES;
}

//请求数据
- (void)requestdata
{
    [_dataArray removeAllObjects];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://api.jiefu.tv/app2/api/dt/tag/allList.html" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSArray * arr = responseObject[@"data"];
         
         for (NSDictionary * dic  in arr)
         {
             NSArray * arri = dic[@"tagList"];
             
             NSMutableArray * tempArr = [NSMutableArray array];
             
             for (NSDictionary * dict in arri)
             {
                 cellLabel * model = [[cellLabel alloc] init];
                 
                 [model setValuesForKeysWithDictionary:dict];
                 
                 [tempArr addObject:model];
             }
             [_dataArray addObject:tempArr];
         }
         
         [_CollectionView reloadData];
         
         [_CollectionView.mj_header endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
     }];
          
}

//设置collectionView
- (void)collectionView
{
    UICollectionViewFlowLayout * FlowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:FlowLayout];
    
    FlowLayout.minimumInteritemSpacing = 15;
    
    _CollectionView.dataSource = self;
    
    _CollectionView.delegate = self;
    
    _CollectionView.backgroundColor = [UIColor whiteColor];
    
    [_CollectionView registerClass:[NameArrayCollectionViewCell class] forCellWithReuseIdentifier:cellResueIdentifier];
    
    [_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResueIdentifier];
    
    [_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerResueIdengtifier];
    
    [self.view addSubview:_CollectionView];
}

//设置Collection的分区
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 65) / 4, (SCREENWIDTH - 65) / 4 / 2);
}

//设置上下左右的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

//区头尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(SCREENWIDTH, _searchBar.frame.size.height + 30);
    } else
    {
        return CGSizeMake(SCREENWIDTH, 30);
    }
    
}

// 区尾尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH, 15);
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NameArrayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10;
    
    cell.contentView.layer.cornerRadius = 10;
    
    cell.layer.masksToBounds = YES;
    
    cell.contentView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:0.6] CGColor];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.contentView.layer.borderWidth = 1;
    
    cell.layer.borderWidth = 1;
    
    cell.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:0.6] CGColor];
    
    cell.model = _dataArray[indexPath.section][indexPath.item];
    
    return cell;
}

//添加区头和区尾
- (UICollectionReusableView * )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind ==UICollectionElementKindSectionHeader)
    {
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResueIdentifier forIndexPath:indexPath];
    
    header.backgroundColor = [UIColor whiteColor];
    
    //Header重用
    for (UIView * view in header.subviews)
    {
        [view removeFromSuperview];
    }
    
    //设置Header分区的样式
    if (indexPath.section == 0)
    {
        [header addSubview:_HeaderView];
        
        UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,_searchBar.frame.size.height + 5, 20, 20)];
        
        HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
        
        [header addSubview:HeaderImage];
        
        UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(HeaderImage.frame.size.width + 10, _searchBar.frame.size.height + 5, 200, 20)];
        
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
    } else
    {
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerResueIdengtifier forIndexPath:indexPath];
        
        footer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        
        return footer;
    }
}



//区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

//Item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [_dataArray[section] count];
}

//cell被点击时的实现
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.tabBarController.tabBar.hidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    SearchCellViewController * SearchCellVC = [[SearchCellViewController alloc]init];
    
    SearchCellVC.model = _dataArray[indexPath.section][indexPath.item];
    
    [self.navigationController pushViewController:SearchCellVC animated:YES];
}

//左侧按钮
- (void)LeftButtton
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@" 广场" forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"Back1"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchDown];
    
    [button sizeToFit];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = leftButton;
}

//添加左侧按钮
- (void)leftBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击搜索栏是的实现
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    SearchBarViewController * searchB = [[SearchBarViewController alloc]init];
    
    [self presentViewController:searchB animated:YES completion:nil];
    
    
    
    return YES;
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
