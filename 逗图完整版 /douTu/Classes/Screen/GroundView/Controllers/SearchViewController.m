//
//  SearchViewController.m
//  GroupProject
//
//  Created by  张泽军 on 2016/12/1.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//



#import "SearchBarViewController.h"

#import "SearchViewController.h"
#import "ImageCollectionViewCell.h"
#import "CellImage.h"

#import "AFNetworking.h"
#import "MJRefresh.h"

@interface SearchBarViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UISearchBar * searchBar;

@property (nonatomic,strong) UICollectionView * TopCollectionView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int pageNum;

@property (nonatomic,strong) UIImage * selectedImage;
@end

static NSString * const cellResueIdentifier = @"collect";

@implementation SearchBarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 50)];
    
    _searchBar.backgroundColor = [UIColor grayColor];
    
    [_searchBar setPlaceholder:@"搜索表情"];
    [_searchBar setBarStyle:UIBarStyleDefault];
    [_searchBar setBarTintColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [_searchBar setTranslucent:YES];
    [_searchBar setSearchResultsButtonSelected:NO];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    self.searchBar.delegate = self;
    
    [self.view addSubview:_searchBar];
    
    [_searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    _dataArray = [NSMutableArray array];
    
    _pageNum = 0;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    _TopCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    
    flowLayout.minimumInteritemSpacing = 15;
    
    _TopCollectionView.dataSource = self;
    
    _TopCollectionView.delegate = self;
    
    _TopCollectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [_TopCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:cellResueIdentifier];
    
    [self.view addSubview:_TopCollectionView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_searchBar resignFirstResponder];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 65) / 4, (SCREENWIDTH - 65) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 10, 5, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
    CellImage * model = _dataArray[indexPath.item];
    
    
    UIImageView * image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
    _selectedImage = image.image;
    
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //展示取消按钮
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    //设置'cancel'按钮为'取消'
    for(UIView * view in [[_searchBar.subviews lastObject] subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton * cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];
            
            _searchBar.tintColor = [UIColor greenColor];
        }
    }
    
    return YES;
}

//点击取消按钮实现
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_searchBar setShowsCancelButton:NO animated:NO];
        
        [_searchBar resignFirstResponder];
    }];
}

//点击搜索按钮实现
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    for(UIView * view in [[_searchBar.subviews firstObject] subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton * cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];
            
            [cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _pageNum = 0;
    
    if (searchText.length == 0)
    {
        [_dataArray removeAllObjects];
        
        [_TopCollectionView reloadData];
    }
    
    if (searchText != nil)
    {
        [self Refresh];
        [_TopCollectionView.mj_header endRefreshing];
        [_TopCollectionView.mj_footer endRefreshing];
    }
    
}

- (void)requestdata
{
    [_dataArray removeAllObjects];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"keyWord"] = _searchBar.text;
    
    dic[@"pageNum"] = [NSString stringWithFormat:@"%d",_pageNum];
    
    dic[@"pageSize"] = @"100";
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://api.jiefu.tv/app2/api/dt/shareItem/search.html" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSMutableArray * mu = [NSMutableArray array];
         
         for (NSDictionary * dict in responseObject[@"data"])
         {
             CellImage * model = [[CellImage alloc]init];
             
             [model setValuesForKeysWithDictionary:dict];
             
             [mu addObject:model];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [_dataArray addObjectsFromArray:mu];
             
             [_TopCollectionView reloadData];
             
         });
         [_TopCollectionView.mj_header endRefreshing];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [_TopCollectionView.mj_header endRefreshing];
         
     }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.item];
    
    return cell;
}

- (void)reloadData
{
    _pageNum ++;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"keyWord"] = _searchBar.text;
    
    dic[@"pageNum"] = [NSString stringWithFormat:@"%d",_pageNum];
    
    dic[@"pageSize"] = @"100";
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://api.jiefu.tv/app2/api/dt/shareItem/search.html" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSMutableArray * mu = [NSMutableArray array];
         
         for (NSDictionary * dict in responseObject[@"data"])
         {
             CellImage * model = [[CellImage alloc]init];
             
             [model setValuesForKeysWithDictionary:dict];
             [mu addObject:model];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_dataArray addObjectsFromArray:mu];
                 
                 [_TopCollectionView reloadData];
                 
             });
             [_TopCollectionView.mj_footer endRefreshing];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"错误信息%@",error);
     }];
    
}

- (void)Refresh
{
    //下拉刷新
    _TopCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdata];
    }];
    
    [_TopCollectionView.mj_header beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _TopCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _TopCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self reloadData];
    }];
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
